Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A1E410A47
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbhISGnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:43:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:54562 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237001AbhISGnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:43:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="286675543"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="286675543"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:42:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510701962"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:42:04 -0700
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
Subject: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma interfaces
Date:   Sun, 19 Sep 2021 14:38:34 +0800
Message-Id: <20210919063848.1476776-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

This extends iommu core to manage security context for passthrough
devices. Please bear a long explanation for how we reach this design
instead of managing it solely in iommufd like what vfio does today.

Devices which cannot be isolated from each other are organized into an
iommu group. When a device is assigned to the user space, the entire
group must be put in a security context so that user-initiated DMAs via
the assigned device cannot harm the rest of the system. No user access
should be granted on a device before the security context is established
for the group which the device belongs to.

Managing the security context must meet below criteria:

1)  The group is viable for user-initiated DMAs. This implies that the
    devices in the group must be either bound to a device-passthrough
    framework, or driver-less, or bound to a driver which is known safe
    (not do DMA).

2)  The security context should only allow DMA to the user's memory and
    devices in this group;

3)  After the security context is established for the group, the group
    viability must be continuously monitored before the user relinquishes
    all devices belonging to the group. The viability might be broken e.g.
    when a driver-less device is later bound to a driver which does DMA.

4)  The security context should not be destroyed before user access
    permission is withdrawn.

Existing vfio introduces explicit container/group semantics in its uAPI
to meet above requirements. A single security context (iommu domain)
is created per container. Attaching group to container moves the entire
group into the associated security context, and vice versa. The user can
open the device only after group attach. A group can be detached only
after all devices in the group are closed. Group viability is monitored
by listening to iommu group events.

Unlike vfio, iommufd adopts a device-centric design with all group
logistics hidden behind the fd. Binding a device to iommufd serves
as the contract to get security context established (and vice versa
for unbinding). One additional requirement in iommufd is to manage the
switch between multiple security contexts due to decoupled bind/attach:

1)  Open a device in "/dev/vfio/devices" with user access blocked;

2)  Bind the device to an iommufd with an initial security context
    (an empty iommu domain which blocks dma) established for its
    group, with user access unblocked;

3)  Attach the device to a user-specified ioasid (shared by all devices
    attached to this ioasid). Before attaching, the device should be first
    detached from the initial context;

4)  Detach the device from the ioasid and switch it back to the initial
    security context;

5)  Unbind the device from the iommufd, back to access blocked state and
    move its group out of the initial security context if it's the last
    unbound device in the group;

(multiple attach/detach could happen between 2 and 5).

However existing iommu core has problem with above transition. Detach
in step 3/4 makes the device/group re-attached to the default domain
automatically, which opens the door for user-initiated DMAs to attack
the rest of the system. The existing vfio doesn't have this problem as
it combines 2/3 in one step (so does 4/5).

Fixing this problem requires the iommu core to also participate in the
security context management. Following this direction we also move group
viability check into the iommu core, which allows iommufd to stay fully
device-centric w/o keeping any group knowledge (combining with the
extension to iommu_at[de]tach_device() in a latter patch).

Basically two new interfaces are provided:

        int iommu_device_init_user_dma(struct device *dev,
                        unsigned long owner);
        void iommu_device_exit_user_dma(struct device *dev);

iommufd calls them respectively when handling device binding/unbinding
requests.

The init_user_dma() for the 1st device in a group marks the entire group
for user-dma and establishes the initial security context (dma blocked)
according to aforementioned criteria. As long as the group is marked for
user-dma, auto-reattaching to default domain is disabled. Instead, upon
detaching the group is moved back to the initial security context.

The caller also provides an owner id to mark the ownership so inadvertent
attempt from another caller on the same device can be captured. In this
RFC iommufd will use the fd context pointer as the owner id.

The exit_user_dma() for the last device in the group clears the user-dma
mark and moves the group back to the default domain.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 145 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/iommu.h |  12 ++++
 2 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5ea3a007fd7c..bffd84e978fb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -45,6 +45,8 @@ struct iommu_group {
 	struct iommu_domain *default_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
+	unsigned long user_dma_owner_id;
+	refcount_t owner_cnt;
 };
 
 struct group_device {
@@ -86,6 +88,7 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 static struct iommu_group *iommu_group_get_for_dev(struct device *dev);
 static ssize_t iommu_group_store_type(struct iommu_group *group,
 				      const char *buf, size_t count);
+static bool iommu_group_user_dma_viable(struct iommu_group *group);
 
 #define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
 struct iommu_group_attribute iommu_group_attr_##_name =		\
@@ -275,7 +278,11 @@ int iommu_probe_device(struct device *dev)
 	 */
 	iommu_alloc_default_domain(group, dev);
 
-	if (group->default_domain) {
+	/*
+	 * If any device in the group has been initialized for user dma,
+	 * avoid attaching the default domain.
+	 */
+	if (group->default_domain && !group->user_dma_owner_id) {
 		ret = __iommu_attach_device(group->default_domain, dev);
 		if (ret) {
 			iommu_group_put(group);
@@ -1664,6 +1671,17 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 		group_action = IOMMU_GROUP_NOTIFY_BIND_DRIVER;
 		break;
 	case BUS_NOTIFY_BOUND_DRIVER:
+		/*
+		 * FIXME: Alternatively the attached drivers could generically
+		 * indicate to the iommu layer that they are safe for keeping
+		 * the iommu group user viable by calling some function around
+		 * probe(). We could eliminate this gross BUG_ON() by denying
+		 * probe to non-iommu-safe driver.
+		 */
+		mutex_lock(&group->mutex);
+		if (group->user_dma_owner_id)
+			BUG_ON(!iommu_group_user_dma_viable(group));
+		mutex_unlock(&group->mutex);
 		group_action = IOMMU_GROUP_NOTIFY_BOUND_DRIVER;
 		break;
 	case BUS_NOTIFY_UNBIND_DRIVER:
@@ -2304,7 +2322,11 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 {
 	int ret;
 
-	if (group->default_domain && group->domain != group->default_domain)
+	/*
+	 * group->domain could be NULL when a domain is detached from the
+	 * group but the default_domain is not re-attached.
+	 */
+	if (group->domain && group->domain != group->default_domain)
 		return -EBUSY;
 
 	ret = __iommu_group_for_each_dev(group, domain,
@@ -2341,7 +2363,11 @@ static void __iommu_detach_group(struct iommu_domain *domain,
 {
 	int ret;
 
-	if (!group->default_domain) {
+	/*
+	 * If any device in the group has been initialized for user dma,
+	 * avoid re-attaching the default domain.
+	 */
+	if (!group->default_domain || group->user_dma_owner_id) {
 		__iommu_group_for_each_dev(group, domain,
 					   iommu_group_do_detach_device);
 		group->domain = NULL;
@@ -3276,3 +3302,116 @@ int iommu_device_get_info(struct device *dev, enum iommu_devattr attr, void *dat
 	return ops->device_info(dev, attr, data);
 }
 EXPORT_SYMBOL_GPL(iommu_device_get_info);
+
+/*
+ * IOMMU core interfaces for iommufd.
+ */
+
+/*
+ * FIXME: We currently simply follow vifo policy to mantain the group's
+ * viability to user. Eventually, we should avoid below hard-coded list
+ * by letting drivers indicate to the iommu layer that they are safe for
+ * keeping the iommu group's user aviability.
+ */
+static const char * const iommu_driver_allowed[] = {
+	"vfio-pci",
+	"pci-stub"
+};
+
+/*
+ * An iommu group is viable for use by userspace if all devices are in
+ * one of the following states:
+ *  - driver-less
+ *  - bound to an allowed driver
+ *  - a PCI interconnect device
+ */
+static int device_user_dma_viable(struct device *dev, void *data)
+{
+	struct device_driver *drv = READ_ONCE(dev->driver);
+
+	if (!drv)
+		return 0;
+
+	if (dev_is_pci(dev)) {
+		struct pci_dev *pdev = to_pci_dev(dev);
+
+		if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
+			return 0;
+	}
+
+	return match_string(iommu_driver_allowed,
+			    ARRAY_SIZE(iommu_driver_allowed),
+			    drv->name) < 0;
+}
+
+static bool iommu_group_user_dma_viable(struct iommu_group *group)
+{
+	return !__iommu_group_for_each_dev(group, NULL, device_user_dma_viable);
+}
+
+static int iommu_group_init_user_dma(struct iommu_group *group,
+				     unsigned long owner)
+{
+	if (group->user_dma_owner_id) {
+		if (group->user_dma_owner_id != owner)
+			return -EBUSY;
+
+		refcount_inc(&group->owner_cnt);
+		return 0;
+	}
+
+	if (group->domain && group->domain != group->default_domain)
+		return -EBUSY;
+
+	if (!iommu_group_user_dma_viable(group))
+		return -EINVAL;
+
+	group->user_dma_owner_id = owner;
+	refcount_set(&group->owner_cnt, 1);
+
+	/* default domain is unsafe for user-initiated dma */
+	if (group->domain == group->default_domain)
+		__iommu_detach_group(group->default_domain, group);
+
+	return 0;
+}
+
+int iommu_device_init_user_dma(struct device *dev, unsigned long owner)
+{
+	struct iommu_group *group = iommu_group_get(dev);
+	int ret;
+
+	if (!group || !owner)
+		return -ENODEV;
+
+	mutex_lock(&group->mutex);
+	ret = iommu_group_init_user_dma(group, owner);
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_device_init_user_dma);
+
+static void iommu_group_exit_user_dma(struct iommu_group *group)
+{
+	if (refcount_dec_and_test(&group->owner_cnt)) {
+		group->user_dma_owner_id = 0;
+		if (group->default_domain)
+			__iommu_attach_group(group->default_domain, group);
+	}
+}
+
+void iommu_device_exit_user_dma(struct device *dev)
+{
+	struct iommu_group *group = iommu_group_get(dev);
+
+	if (WARN_ON(!group || !group->user_dma_owner_id))
+		return;
+
+	mutex_lock(&group->mutex);
+	iommu_group_exit_user_dma(group);
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+}
+EXPORT_SYMBOL_GPL(iommu_device_exit_user_dma);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 52a6d33c82dc..943de6897f56 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -617,6 +617,9 @@ u32 iommu_sva_get_pasid(struct iommu_sva *handle);
 
 int iommu_device_get_info(struct device *dev, enum iommu_devattr attr, void *data);
 
+int iommu_device_init_user_dma(struct device *dev, unsigned long owner);
+void iommu_device_exit_user_dma(struct device *dev);
+
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -1018,6 +1021,15 @@ static inline int iommu_device_get_info(struct device *dev,
 {
 	return -ENODEV;
 }
+
+static inline int iommu_device_init_user_dma(struct device *dev, unsigned long owner)
+{
+	return -ENODEV;
+}
+
+static inline void iommu_device_exit_user_dma(struct device *dev)
+{
+}
 #endif /* CONFIG_IOMMU_API */
 
 /**
-- 
2.25.1

