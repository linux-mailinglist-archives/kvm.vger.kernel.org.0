Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEAC14CA45
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA2MGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:06:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:59025 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgA2MGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:06:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:06:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="222433151"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2020 04:06:39 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v3 6/8] vfio/type1: Bind guest page tables to host
Date:   Wed, 29 Jan 2020 04:11:50 -0800
Message-Id: <1580299912-86084-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

VFIO_TYPE1_NESTING_IOMMU is an IOMMU type which stands for hardware
IOMMUs that have nesting DMA translation (a.k.a dual stage address
translation). For such IOMMUs, there are two stages/levels of address
translation, and software may let userspace/VM to own the first-level/
stage-1 translation structures. Example of such usage is vSVA (virtual
Shared Virtual Addressing). VM owns the first-level/stage-1 translation
structures and bind the structures to host, then hardware IOMMU would
utilize nesting translation when handling DMA remapping.

This patch adds vfio support for binding guest translation structure
to host iommu. And for VFIO_TYPE1_NESTING_IOMMU, not only bind guest
page table is needed, it also requires to expose interface to guest
for iommu cache invalidation when guest modified the first-level/
stage-1 translation structures since hardware needs to be notified to
flush stale iotlbs. This would be introduced in next patch.

In this patch, guest page table bind and unbind are done by using
flag VFIO_IOMMU_BIND_GUEST_PGTBL and VFIO_IOMMU_UNBIND_GUEST_PGTBL
under IOCTL:VFIO_IOMMU_BIND, the bind/unbind data are conveyed by
struct iommu_gpasid_bind_data. Before binding guest page table to host,
VM should have got a PASID allocated by host via VFIO_IOMMU_PASID_REQUEST.

Bind guest translation structures (here is guest page table) to host
are the first step to setup vSVA (Virtual Shared Virtual Addressing).

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 152 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  46 ++++++++++++
 2 files changed, 198 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e0bbcfb..5e715a9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -125,6 +125,33 @@ struct vfio_regions {
 #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
 					(!list_empty(&iommu->domain_list))
 
+struct domain_capsule {
+	struct iommu_domain *domain;
+	void *data;
+};
+
+/* iommu->lock must be held */
+static int vfio_iommu_for_each_dev(struct vfio_iommu *iommu,
+		      int (*fn)(struct device *dev, void *data),
+		      void *data)
+{
+	struct domain_capsule dc = {.data = data};
+	struct vfio_domain *d;
+	struct vfio_group *g;
+	int ret = 0;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		dc.domain = d->domain;
+		list_for_each_entry(g, &d->group_list, next) {
+			ret = iommu_group_for_each_dev(g->iommu_group,
+						       &dc, fn);
+			if (ret)
+				break;
+		}
+	}
+	return ret;
+}
+
 static int put_pfn(unsigned long pfn, int prot);
 
 /*
@@ -2339,6 +2366,88 @@ static int vfio_iommu_type1_set_pasid_quota(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_bind_gpasid_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	struct iommu_gpasid_bind_data *gbind_data =
+		(struct iommu_gpasid_bind_data *) dc->data;
+
+	return iommu_sva_bind_gpasid(dc->domain, dev, gbind_data);
+}
+
+static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	struct iommu_gpasid_bind_data *gbind_data =
+		(struct iommu_gpasid_bind_data *) dc->data;
+
+	return iommu_sva_unbind_gpasid(dc->domain, dev,
+						gbind_data->hpasid);
+}
+
+/**
+ * Unbind specific gpasid, caller of this function requires hold
+ * vfio_iommu->lock
+ */
+static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu *iommu,
+						void *gbind_data)
+{
+	return vfio_iommu_for_each_dev(iommu,
+			vfio_unbind_gpasid_fn, gbind_data);
+}
+
+static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
+					  void *gbind_data)
+{
+	int ret = 0;
+
+	mutex_lock(&iommu->lock);
+	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = vfio_iommu_for_each_dev(iommu,
+			vfio_bind_gpasid_fn, gbind_data);
+	/*
+	 * If bind failed, it may not be a total failure. Some devices
+	 * within the iommu group may have bind successfully. Although
+	 * we don't enable pasid capability for non-singletion iommu
+	 * groups, a unbind operation would be helpful to ensure no
+	 * partial binding for an iommu group.
+	 */
+	if (ret)
+		/*
+		 * Undo all binds that already succeeded, no need to
+		 * check the return value here since some device within
+		 * the group has no successful bind when coming to this
+		 * place switch.
+		 */
+		vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
+
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
+					    void *gbind_data)
+{
+	int ret = 0;
+
+	mutex_lock(&iommu->lock);
+	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
+
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2501,6 +2610,49 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (quota.argsz < minsz)
 			return -EINVAL;
 		return vfio_iommu_type1_set_pasid_quota(iommu, quota.quota);
+
+	} else if (cmd == VFIO_IOMMU_BIND) {
+		struct vfio_iommu_type1_bind bind;
+		u32 version;
+		int data_size;
+		void *gbind_data;
+
+		minsz = offsetofend(struct vfio_iommu_type1_bind, flags);
+
+		if (copy_from_user(&bind, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (bind.argsz < minsz)
+			return -EINVAL;
+
+		/* Get the version of struct iommu_gpasid_bind_data */
+		if (copy_from_user(&version,
+			(void __user *) (arg + minsz),
+					sizeof(version)))
+			return -EFAULT;
+
+		data_size = iommu_uapi_get_data_size(
+				IOMMU_UAPI_BIND_GPASID, version);
+		gbind_data = kzalloc(data_size, GFP_KERNEL);
+		if (!gbind_data)
+			return -ENOMEM;
+
+		if (copy_from_user(gbind_data,
+			(void __user *) (arg + minsz), data_size)) {
+			kfree(gbind_data);
+			return -EFAULT;
+		}
+
+		switch (bind.flags & VFIO_IOMMU_BIND_MASK) {
+		case VFIO_IOMMU_BIND_GUEST_PGTBL:
+			return vfio_iommu_type1_bind_gpasid(iommu,
+							gbind_data);
+		case VFIO_IOMMU_UNBIND_GUEST_PGTBL:
+			return vfio_iommu_type1_unbind_gpasid(iommu,
+							gbind_data);
+		default:
+			return -EINVAL;
+		}
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 633c07f..b05fa97 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
 
 #define VFIO_API_VERSION	0
 
@@ -874,6 +875,51 @@ struct vfio_iommu_type1_pasid_quota {
  */
 #define VFIO_NESTING_GET_IOMMU_UAPI_VERSION	_IO(VFIO_TYPE, VFIO_BASE + 24)
 
+/**
+ * Supported flags:
+ *	- VFIO_IOMMU_BIND_GUEST_PGTBL: bind guest page tables to host for
+ *			nesting type IOMMUs. In @data field It takes struct
+ *			iommu_gpasid_bind_data.
+ *	- VFIO_IOMMU_UNBIND_GUEST_PGTBL: undo a bind guest page table operation
+ *			invoked by VFIO_IOMMU_BIND_GUEST_PGTBL.
+ *
+ */
+struct vfio_iommu_type1_bind {
+	__u32		argsz;
+	__u32		flags;
+#define VFIO_IOMMU_BIND_GUEST_PGTBL	(1 << 0)
+#define VFIO_IOMMU_UNBIND_GUEST_PGTBL	(1 << 1)
+	__u8		data[];
+};
+
+#define VFIO_IOMMU_BIND_MASK	(VFIO_IOMMU_BIND_GUEST_PGTBL | \
+					VFIO_IOMMU_UNBIND_GUEST_PGTBL)
+
+/**
+ * VFIO_IOMMU_BIND - _IOW(VFIO_TYPE, VFIO_BASE + 25,
+ *				struct vfio_iommu_type1_bind)
+ *
+ * Manage address spaces of devices in this container. Initially a TYPE1
+ * container can only have one address space, managed with
+ * VFIO_IOMMU_MAP/UNMAP_DMA.
+ *
+ * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by both MAP/UNMAP
+ * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2 (host) page
+ * tables, and BIND manages the stage-1 (guest) page tables. Other types of
+ * IOMMU may allow MAP/UNMAP and BIND to coexist, where MAP/UNMAP controls
+ * the traffics only require single stage translation while BIND controls the
+ * traffics require nesting translation. But this depends on the underlying
+ * IOMMU architecture and isn't guaranteed. Example of this is the guest SVA
+ * traffics, such traffics need nesting translation to gain gVA->gPA and then
+ * gPA->hPA translation.
+ *
+ * Availability of this feature depends on the device, its bus, the underlying
+ * IOMMU and the CPU architecture.
+ *
+ * returns: 0 on success, -errno on failure.
+ */
+#define VFIO_IOMMU_BIND		_IO(VFIO_TYPE, VFIO_BASE + 25)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

