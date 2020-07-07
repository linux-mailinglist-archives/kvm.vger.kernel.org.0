Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6764D216379
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 03:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgGGBol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 21:44:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:40649 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727869AbgGGBok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 21:44:40 -0400
IronPort-SDR: xgUEFSrAjaUt1BegHfgMMTpe5IKP7yM2DGew1pXlkKh2ElSoDWvHwrp9E/If7aVBxafM47U+I5
 xY9DDQgIFHow==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="147536135"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="147536135"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 18:44:40 -0700
IronPort-SDR: wwrLt2T9DDD/0MUuMNOzDmBrc56X+9bu9H8+XJmtI5OICVSouPK5Sp2RJ+tpk7dmuZ2sTinZRA
 vUF+WTYzI2aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="266688936"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jul 2020 18:44:38 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 2/2] iommu: Add aux_domain_attached flag to iommu_group
Date:   Tue,  7 Jul 2020 09:39:57 +0800
Message-Id: <20200707013957.23672-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200707013957.23672-1-baolu.lu@linux.intel.com>
References: <20200707013957.23672-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The normal domain at(de)tach is parallel with aux-domain at(de)tach. In
another word, once an iommu_group is attached through the normal domain
attach api's, it should not go through the aux-domain at(de)tach api's
until the domain is detached. And, vice versa.

Currently, we prohibit an iommu_group to go through aux-domain api's if
group->domain != NULL; but we don't check aux-domain attachment in the
normal attach api's. This marks an iommu_group after an aux-domain is
attached, so that normal domain at(de)tach api's should never be used
after that.

Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 435835058209..3e7489ea2010 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -45,6 +45,7 @@ struct iommu_group {
 	struct iommu_domain *default_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
+	unsigned int aux_domain_attached:1;
 };
 
 struct group_device {
@@ -2074,6 +2075,9 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 {
 	int ret;
 
+	if (group->aux_domain_attached)
+		return -EINVAL;
+
 	if (group->default_domain && group->domain != group->default_domain)
 		return -EBUSY;
 
@@ -2111,6 +2115,9 @@ static void __iommu_detach_group(struct iommu_domain *domain,
 {
 	int ret;
 
+	if (WARN_ON(group->aux_domain_attached))
+		return;
+
 	if (!group->default_domain) {
 		__iommu_group_for_each_dev(group, domain,
 					   iommu_group_do_detach_device);
@@ -2769,6 +2776,7 @@ int iommu_aux_attach_device(struct iommu_domain *domain,
 	if (!ret) {
 		trace_attach_device_to_domain(phys_dev);
 		group->domain = domain;
+		group->aux_domain_attached = true;
 	}
 
 out_unlock:
@@ -2802,8 +2810,12 @@ void iommu_aux_detach_device(struct iommu_domain *domain,
 	if (WARN_ON(iommu_group_device_count(group) != 1))
 		goto out_unlock;
 
+	if (WARN_ON(!group->aux_domain_attached))
+		goto out_unlock;
+
 	domain->ops->aux_detach_dev(domain, phys_dev);
 	group->domain = NULL;
+	group->aux_domain_attached = false;
 	trace_detach_device_from_domain(phys_dev);
 
 out_unlock:
-- 
2.17.1

