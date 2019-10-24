Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB798E3316
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 14:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502200AbfJXMxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 08:53:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:11532 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502191AbfJXMxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 08:53:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 05:52:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="201464819"
Received: from iov.bj.intel.com ([10.238.145.67])
  by orsmga003.jf.intel.com with ESMTP; 24 Oct 2019 05:52:57 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to host
Date:   Thu, 24 Oct 2019 08:26:23 -0400
Message-Id: <1571919983-3231-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds vfio support to bind guest translation structure
to host iommu. VFIO exposes iommu programming capability to user-
space. Guest is a user-space application in host under KVM solution.
For SVA usage in Virtual Machine, guest owns GVA->GPA translation
structure. And this part should be passdown to host to enable nested
translation (or say two stage translation). This patch reuses the
VFIO_IOMMU_BIND proposal from Jean-Philippe Brucker, and adds new
bind type for binding guest owned translation structure to host.

*) Add two new ioctls for VFIO containers.

  - VFIO_IOMMU_BIND: for bind request from userspace, it could be
                   bind a process to a pasid or bind a guest pasid
                   to a device, this is indicated by type
  - VFIO_IOMMU_UNBIND: for unbind request from userspace, it could be
                   unbind a process to a pasid or unbind a guest pasid
                   to a device, also indicated by type
  - Bind type:
	VFIO_IOMMU_BIND_PROCESS: user-space request to bind a process
                   to a device
	VFIO_IOMMU_BIND_GUEST_PASID: bind guest owned translation
                   structure to host iommu. e.g. guest page table

*) Code logic in vfio_iommu_type1_ioctl() to handle VFIO_IOMMU_BIND/UNBIND

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 136 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  44 +++++++++++++
 2 files changed, 180 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3d73a7d..1a27e25 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2325,6 +2325,104 @@ static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_bind_gpasid_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	struct iommu_gpasid_bind_data *ustruct =
+		(struct iommu_gpasid_bind_data *) dc->data;
+
+	return iommu_sva_bind_gpasid(dc->domain, dev, ustruct);
+}
+
+static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	struct iommu_gpasid_bind_data *ustruct =
+		(struct iommu_gpasid_bind_data *) dc->data;
+
+	return iommu_sva_unbind_gpasid(dc->domain, dev,
+						ustruct->hpasid);
+}
+
+/*
+ * unbind specific gpasid, caller of this function requires hold
+ * vfio_iommu->lock
+ */
+static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu *iommu,
+		  struct iommu_gpasid_bind_data *gbind_data)
+{
+	return vfio_iommu_lookup_dev(iommu, vfio_unbind_gpasid_fn, gbind_data);
+}
+
+static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
+					    void __user *arg,
+					    struct vfio_iommu_type1_bind *bind)
+{
+	struct iommu_gpasid_bind_data gbind_data;
+	unsigned long minsz;
+	int ret = 0;
+
+	minsz = sizeof(*bind) + sizeof(gbind_data);
+	if (bind->argsz < minsz)
+		return -EINVAL;
+
+	if (copy_from_user(&gbind_data, arg, sizeof(gbind_data)))
+		return -EFAULT;
+
+	mutex_lock(&iommu->lock);
+	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = vfio_iommu_lookup_dev(iommu, vfio_bind_gpasid_fn, &gbind_data);
+	/*
+	 * If bind failed, it may not be a total failure. Some devices within
+	 * the iommu group may have bind successfully. Although we don't enable
+	 * pasid capability for non-singletion iommu groups, a unbind operation
+	 * would be helpful to ensure no partial binding for an iommu group.
+	 */
+	if (ret)
+		/*
+		 * Undo all binds that already succeeded, no need to check the
+		 * return value here since some device within the group has no
+		 * successful bind when coming to this place switch.
+		 */
+		vfio_iommu_type1_do_guest_unbind(iommu, &gbind_data);
+
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
+					    void __user *arg,
+					    struct vfio_iommu_type1_bind *bind)
+{
+	struct iommu_gpasid_bind_data gbind_data;
+	unsigned long minsz;
+	int ret = 0;
+
+	minsz = sizeof(*bind) + sizeof(gbind_data);
+	if (bind->argsz < minsz)
+		return -EINVAL;
+
+	if (copy_from_user(&gbind_data, arg, sizeof(gbind_data)))
+		return -EFAULT;
+
+	mutex_lock(&iommu->lock);
+	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = vfio_iommu_type1_do_guest_unbind(iommu, &gbind_data);
+
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2484,6 +2582,44 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		default:
 			return -EINVAL;
 		}
+
+	} else if (cmd == VFIO_IOMMU_BIND) {
+		struct vfio_iommu_type1_bind bind;
+
+		minsz = offsetofend(struct vfio_iommu_type1_bind, bind_type);
+
+		if (copy_from_user(&bind, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (bind.argsz < minsz)
+			return -EINVAL;
+
+		switch (bind.bind_type) {
+		case VFIO_IOMMU_BIND_GUEST_PASID:
+			return vfio_iommu_type1_bind_gpasid(iommu,
+					(void __user *)(arg + minsz), &bind);
+		default:
+			return -EINVAL;
+		}
+
+	} else if (cmd == VFIO_IOMMU_UNBIND) {
+		struct vfio_iommu_type1_bind bind;
+
+		minsz = offsetofend(struct vfio_iommu_type1_bind, bind_type);
+
+		if (copy_from_user(&bind, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (bind.argsz < minsz)
+			return -EINVAL;
+
+		switch (bind.bind_type) {
+		case VFIO_IOMMU_BIND_GUEST_PASID:
+			return vfio_iommu_type1_unbind_gpasid(iommu,
+					(void __user *)(arg + minsz), &bind);
+		default:
+			return -EINVAL;
+		}
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 04de290..78e8c64 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -832,6 +832,50 @@ struct vfio_iommu_type1_pasid_request {
  */
 #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 27)
 
+enum vfio_iommu_bind_type {
+	VFIO_IOMMU_BIND_PROCESS,
+	VFIO_IOMMU_BIND_GUEST_PASID,
+};
+
+/*
+ * Supported types:
+ *	- VFIO_IOMMU_BIND_GUEST_PASID: bind guest pasid, which invoked
+ *			by guest, it takes iommu_gpasid_bind_data in data.
+ */
+struct vfio_iommu_type1_bind {
+	__u32				argsz;
+	enum vfio_iommu_bind_type	bind_type;
+	__u8				data[];
+};
+
+/*
+ * VFIO_IOMMU_BIND - _IOWR(VFIO_TYPE, VFIO_BASE + 28, struct vfio_iommu_bind)
+ *
+ * Manage address spaces of devices in this container. Initially a TYPE1
+ * container can only have one address space, managed with
+ * VFIO_IOMMU_MAP/UNMAP_DMA.
+ *
+ * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by both MAP/UNMAP
+ * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2 (host) page
+ * tables, and BIND manages the stage-1 (guest) page tables. Other types of
+ * IOMMU may allow MAP/UNMAP and BIND to coexist, where MAP/UNMAP controls
+ * non-PASID traffic and BIND controls PASID traffic. But this depends on the
+ * underlying IOMMU architecture and isn't guaranteed.
+ *
+ * Availability of this feature depends on the device, its bus, the underlying
+ * IOMMU and the CPU architecture.
+ *
+ * returns: 0 on success, -errno on failure.
+ */
+#define VFIO_IOMMU_BIND		_IO(VFIO_TYPE, VFIO_BASE + 28)
+
+/*
+ * VFIO_IOMMU_UNBIND - _IOWR(VFIO_TYPE, VFIO_BASE + 29, struct vfio_iommu_bind)
+ *
+ * Undo what was done by the corresponding VFIO_IOMMU_BIND ioctl.
+ */
+#define VFIO_IOMMU_UNBIND	_IO(VFIO_TYPE, VFIO_BASE + 29)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

