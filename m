Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D368410A5E
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbhISGov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:44:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:41327 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237297AbhISGoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:44:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="219805483"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="219805483"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:42:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510702080"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:42:51 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple devices group
Date:   Sun, 19 Sep 2021 14:38:41 +0800
Message-Id: <20210919063848.1476776-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

These two helpers could be used when 1) the iommu group is singleton,
or 2) the upper layer has put the iommu group into the secure state by
calling iommu_device_init_user_dma().

As we want the iommufd design to be a device-centric model, we want to
remove any group knowledge in iommufd. Given that we already have
iommu_at[de]tach_device() interface, we could extend it for iommufd
simply by doing below:

 - first device in a group does group attach;
 - last device in a group does group detach.

as long as the group has been put into the secure context.

The commit <426a273834eae> ("iommu: Limit iommu_attach/detach_device to
device with their own group") deliberately restricts the two interfaces
to single-device group. To avoid the conflict with existing usages, we
keep this policy and put the new extension only when the group has been
marked for user_dma.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index bffd84e978fb..b6178997aef1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -47,6 +47,7 @@ struct iommu_group {
 	struct list_head entry;
 	unsigned long user_dma_owner_id;
 	refcount_t owner_cnt;
+	refcount_t attach_cnt;
 };
 
 struct group_device {
@@ -1994,7 +1995,7 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct iommu_group *group;
-	int ret;
+	int ret = 0;
 
 	group = iommu_group_get(dev);
 	if (!group)
@@ -2005,11 +2006,23 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 	 * change while we are attaching
 	 */
 	mutex_lock(&group->mutex);
-	ret = -EINVAL;
-	if (iommu_group_device_count(group) != 1)
+	if (group->user_dma_owner_id) {
+		if (group->domain) {
+			if (group->domain != domain)
+				ret = -EBUSY;
+			else
+				refcount_inc(&group->attach_cnt);
+
+			goto out_unlock;
+		}
+	} else if (iommu_group_device_count(group) != 1) {
+		ret = -EINVAL;
 		goto out_unlock;
+	}
 
 	ret = __iommu_attach_group(domain, group);
+	if (!ret && group->user_dma_owner_id)
+		refcount_set(&group->attach_cnt, 1);
 
 out_unlock:
 	mutex_unlock(&group->mutex);
@@ -2261,7 +2274,10 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 		return;
 
 	mutex_lock(&group->mutex);
-	if (iommu_group_device_count(group) != 1) {
+	if (group->user_dma_owner_id) {
+		if (!refcount_dec_and_test(&group->attach_cnt))
+			goto out_unlock;
+	} else if (iommu_group_device_count(group) != 1) {
 		WARN_ON(1);
 		goto out_unlock;
 	}
@@ -3368,6 +3384,7 @@ static int iommu_group_init_user_dma(struct iommu_group *group,
 
 	group->user_dma_owner_id = owner;
 	refcount_set(&group->owner_cnt, 1);
+	refcount_set(&group->attach_cnt, 0);
 
 	/* default domain is unsafe for user-initiated dma */
 	if (group->domain == group->default_domain)
-- 
2.25.1

