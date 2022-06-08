Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B544C54327F
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 16:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbiFHO0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 10:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241373AbiFHO0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 10:26:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 288C5169E1C;
        Wed,  8 Jun 2022 07:25:57 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9DEC1424;
        Wed,  8 Jun 2022 07:25:56 -0700 (PDT)
Received: from e121345-lin.cambridge.arm.com (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D4AD03F73B;
        Wed,  8 Jun 2022 07:25:55 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com,
        baolu.lu@linux.intel.com
Subject: [PATCH 1/2] vfio/type1: Simplify bus_type determination
Date:   Wed,  8 Jun 2022 15:25:49 +0100
Message-Id: <07c69a27fa5bf9724ea8c9fcfe3ff2e8b68f6bf0.1654697988.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.36.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since IOMMU groups are mandatory for drivers to support, it stands to
reason that any device which has been successfully be added to a group
must be on a bus supported by that IOMMU driver, and therefore a domain
viable for any device in the group must be viable for all devices in
the group. This already has to be the case for the IOMMU API's internal
default domain, for instance. Thus even if the group contains devices
on different buses, that can only mean that the IOMMU driver actually
supports such an odd topology, and so without loss of generality we can
expect the bus type of any arbitrary device in a group to be suitable
for IOMMU API calls.

Replace vfio_bus_type() with a trivial callback that simply returns any
device from which to then derive a usable bus type. This is also a step
towards removing the vague bus-based interfaces from the IOMMU API.

Furthermore, scrutiny reveals a lack of protection for the bus and/or
device being removed while .attach_group is inspecting them; the
reference we hold on the iommu_group ensures that data remains valid,
but does not prevent the group's membership changing underfoot. Holding
the vfio_goup's device_lock should be sufficient to block any relevant
device's VFIO driver from unregistering, and thus block unbinding and
any further stages of removal for the duration of the attach operation.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---

With vfio_group_viable() now gone and no longer taking the vfio_group
device_lock inside the iommu_group mutex, this seems workable, and at
least lockdep is happy.

 drivers/vfio/vfio.c             |  6 ++++++
 drivers/vfio/vfio_iommu_type1.c | 32 ++++++++++++++------------------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 61e71c1154be..0b71f3d12e5f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -760,8 +760,11 @@ static int __vfio_container_attach_groups(struct vfio_container *container,
 	int ret = -ENODEV;
 
 	list_for_each_entry(group, &container->group_list, container_next) {
+		/* Prevent devices unregistering during attach */
+		mutex_lock(&group->device_lock);
 		ret = driver->ops->attach_group(data, group->iommu_group,
 						group->type);
+		mutex_unlock(&group->device_lock);
 		if (ret)
 			goto unwind;
 	}
@@ -1017,9 +1020,12 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 
 	driver = container->iommu_driver;
 	if (driver) {
+		/* Prevent devices unregistering during attach */
+		mutex_lock(&group->device_lock);
 		ret = driver->ops->attach_group(container->iommu_data,
 						group->iommu_group,
 						group->type);
+		mutex_unlock(&group->device_lock);
 		if (ret) {
 			if (group->type == VFIO_IOMMU)
 				iommu_group_release_dma_owner(
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c13b9290e357..5c19faef90ae 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1679,18 +1679,6 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	return ret;
 }
 
-static int vfio_bus_type(struct device *dev, void *data)
-{
-	struct bus_type **bus = data;
-
-	if (*bus && *bus != dev->bus)
-		return -EINVAL;
-
-	*bus = dev->bus;
-
-	return 0;
-}
-
 static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
@@ -2153,13 +2141,20 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+static int vfio_first_dev(struct device *dev, void *data)
+{
+	/* Just grab the first device and return nonzero to stop iterating */
+	*(struct device **)data = dev;
+	return 1;
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 		struct iommu_group *iommu_group, enum vfio_group_type type)
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_iommu_group *group;
 	struct vfio_domain *domain, *d;
-	struct bus_type *bus = NULL;
+	struct device *iommu_api_dev = NULL;
 	bool resv_msi, msi_remap;
 	phys_addr_t resv_msi_base = 0;
 	struct iommu_domain_geometry *geo;
@@ -2192,9 +2187,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_unlock;
 	}
 
-	/* Determine bus_type in order to allocate a domain */
-	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
-	if (ret)
+	/* Resolve the group back to a device for IOMMU API ops */
+	ret = -ENODEV;
+	iommu_group_for_each_dev(iommu_group, &iommu_api_dev, vfio_first_dev);
+	if (!iommu_api_dev)
 		goto out_free_group;
 
 	ret = -ENOMEM;
@@ -2203,7 +2199,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_free_group;
 
 	ret = -EIO;
-	domain->domain = iommu_domain_alloc(bus);
+	domain->domain = iommu_domain_alloc(iommu_api_dev->bus);
 	if (!domain->domain)
 		goto out_free_domain;
 
@@ -2258,7 +2254,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	list_add(&group->next, &domain->group_list);
 
 	msi_remap = irq_domain_check_msi_remap() ||
-		    iommu_capable(bus, IOMMU_CAP_INTR_REMAP);
+		    iommu_capable(iommu_api_dev->bus, IOMMU_CAP_INTR_REMAP);
 
 	if (!allow_unsafe_interrupts && !msi_remap) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
-- 
2.36.1.dirty

