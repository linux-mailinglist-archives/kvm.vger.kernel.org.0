Return-Path: <kvm+bounces-3220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD7AA801BC4
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:45:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E10C51C20AC5
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED9913ACD;
	Sat,  2 Dec 2023 09:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="deRAPI2L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DC819F;
	Sat,  2 Dec 2023 01:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510315; x=1733046315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=4NU1FsCRind+58ulZNL2WYHJcOcY7NHFVydNqKJRdKM=;
  b=deRAPI2L0kO8iPTYwCLUjCsIDtb4zE70WsXrZ5dA9/wunNe/hqzZoto/
   eGRcPH3t5YBH5lJTbYf+6vxDvn0S2M9URP5mNDWL8eaco+diJsD6eR1Nh
   ReA7LMEcbGw4euzzZIF/r/Eth+h3VNkqc96CUMkyzrbFim3F6zrKS26Xo
   I6BM7xXVke8mBS2fROvZAUuJSMedYj7IFhnF4F8+E0OQ6IL1EL5hTcc5Y
   5edk2rKYaRMELLrEaX6ePlkLcBnxImZKbMKjifbD7od5/Dbg1V+UJ3YwA
   p8JifwJJNHnRNiy2/ONm5ElW42lHwTw8BWDM216FLsOwXsmlk7cod5kCA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="397478868"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="397478868"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:45:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="913852587"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="913852587"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:45:09 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 04/42] KVM: Skeleton of KVM TDP FD object
Date: Sat,  2 Dec 2023 17:16:15 +0800
Message-Id: <20231202091615.13643-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This is a skeleton implementation of KVM TDP FD object.
The KVM TDP FD object is created by ioctl KVM_CREATE_TDP_FD in
kvm_create_tdp_fd(), which contains

Public part (defined in <linux/kvm_tdp_fd.h>):
- A file object for reference count
  file reference count is 1 on creating KVM TDP FD object.
  On the reference count of the file object goes to 0, its .release()
  handler will destroy the KVM TDP FD object.
- ops kvm_exported_tdp_ops (empty implementation in this patch).

Private part (kvm_exported_tdp object defined in this patch) :
  The kvm_exported_tdp object is linked in kvm->exported_tdp_list, one for
  each KVM address space. It records address space id, and "kvm" pointer
  for TDP FD object, and KVM VM ref is hold during object life cycle.
  In later patches, this kvm_exported_tdp object will be associated to a
  TDP page table exported by KVM.

Two symbols kvm_tdp_fd_get() and kvm_tdp_fd_put() are implemented and
exported to external components to get/put KVM TDP FD object.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/kvm_host.h |  18 ++++
 virt/kvm/Kconfig         |   3 +
 virt/kvm/Makefile.kvm    |   1 +
 virt/kvm/kvm_main.c      |   5 +
 virt/kvm/tdp_fd.c        | 208 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/tdp_fd.h        |   5 +
 6 files changed, 240 insertions(+)
 create mode 100644 virt/kvm/tdp_fd.c

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4944136efaa22..122f47c94ecae 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -44,6 +44,7 @@
 
 #include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
+#include <linux/kvm_tdp_fd.h>
 
 #ifndef KVM_MAX_VCPU_IDS
 #define KVM_MAX_VCPU_IDS KVM_MAX_VCPUS
@@ -808,6 +809,11 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+	struct list_head exported_tdp_list;
+	spinlock_t exported_tdplist_lock;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
@@ -2318,4 +2324,16 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+
+struct kvm_exported_tdp {
+	struct kvm_tdp_fd *tdp_fd;
+
+	struct kvm *kvm;
+	u32 as_id;
+	/* head at kvm->exported_tdp_list */
+	struct list_head list_node;
+};
+
+#endif /* CONFIG_HAVE_KVM_EXPORTED_TDP */
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 484d0873061ca..63b5d55c84e95 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -92,3 +92,6 @@ config HAVE_KVM_PM_NOTIFIER
 
 config KVM_GENERIC_HARDWARE_ENABLING
        bool
+
+config HAVE_KVM_EXPORTED_TDP
+       bool
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 2c27d5d0c367c..fad4638e407c5 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -12,3 +12,4 @@ kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
+kvm-$(CONFIG_HAVE_KVM_EXPORTED_TDP) += $(KVM)/tdp_fd.o
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 494b6301a6065..9fa9132055807 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1232,6 +1232,11 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+	INIT_LIST_HEAD(&kvm->exported_tdp_list);
+	spin_lock_init(&kvm->exported_tdplist_lock);
+#endif
+
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
 		goto out_err_no_mmu_notifier;
diff --git a/virt/kvm/tdp_fd.c b/virt/kvm/tdp_fd.c
new file mode 100644
index 0000000000000..a5c4c3597e94f
--- /dev/null
+++ b/virt/kvm/tdp_fd.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM TDP FD
+ *
+ */
+#include <linux/anon_inodes.h>
+#include <uapi/linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include "tdp_fd.h"
+
+static inline int is_tdp_fd_file(struct file *file);
+static const struct file_operations kvm_tdp_fd_fops;
+static const struct kvm_exported_tdp_ops exported_tdp_ops;
+
+int kvm_create_tdp_fd(struct kvm *kvm, struct kvm_create_tdp_fd *ct)
+{
+	struct kvm_exported_tdp *tdp;
+	struct kvm_tdp_fd *tdp_fd;
+	int as_id = ct->as_id;
+	int ret, fd;
+
+	if (as_id >= KVM_ADDRESS_SPACE_NUM || ct->pad || ct->mode)
+		return -EINVAL;
+
+	/* for each address space, only one exported tdp is allowed */
+	spin_lock(&kvm->exported_tdplist_lock);
+	list_for_each_entry(tdp, &kvm->exported_tdp_list, list_node) {
+		if (tdp->as_id != as_id)
+			continue;
+
+		spin_unlock(&kvm->exported_tdplist_lock);
+		return -EEXIST;
+	}
+	spin_unlock(&kvm->exported_tdplist_lock);
+
+	tdp_fd = kzalloc(sizeof(*tdp_fd), GFP_KERNEL_ACCOUNT);
+	if (!tdp)
+		return -ENOMEM;
+
+	tdp = kzalloc(sizeof(*tdp), GFP_KERNEL_ACCOUNT);
+	if (!tdp) {
+		kfree(tdp_fd);
+		return -ENOMEM;
+	}
+	tdp_fd->priv = tdp;
+	tdp->tdp_fd = tdp_fd;
+	tdp->as_id = as_id;
+
+	if (!kvm_get_kvm_safe(kvm)) {
+		ret = -ENODEV;
+		goto out;
+	}
+	tdp->kvm = kvm;
+
+	tdp_fd->file = anon_inode_getfile("tdp_fd", &kvm_tdp_fd_fops,
+					tdp_fd, O_RDWR | O_CLOEXEC);
+	if (!tdp_fd->file) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		goto out;
+
+	fd_install(fd, tdp_fd->file);
+	ct->fd = fd;
+	tdp_fd->ops = &exported_tdp_ops;
+
+	spin_lock(&kvm->exported_tdplist_lock);
+	list_add(&tdp->list_node, &kvm->exported_tdp_list);
+	spin_unlock(&kvm->exported_tdplist_lock);
+	return 0;
+
+out:
+	if (tdp_fd->file)
+		fput(tdp_fd->file);
+
+	if (tdp->kvm)
+		kvm_put_kvm_no_destroy(tdp->kvm);
+	kfree(tdp);
+	kfree(tdp_fd);
+	return ret;
+}
+
+static int kvm_tdp_fd_release(struct inode *inode, struct file *file)
+{
+	struct kvm_exported_tdp *tdp;
+	struct kvm_tdp_fd *tdp_fd;
+
+	if (!is_tdp_fd_file(file))
+		return -EINVAL;
+
+	tdp_fd = file->private_data;
+	tdp = tdp_fd->priv;
+
+	if (WARN_ON(!tdp || !tdp->kvm))
+		return -EFAULT;
+
+	spin_lock(&tdp->kvm->exported_tdplist_lock);
+	list_del(&tdp->list_node);
+	spin_unlock(&tdp->kvm->exported_tdplist_lock);
+
+	kvm_put_kvm(tdp->kvm);
+	kfree(tdp);
+	kfree(tdp_fd);
+	return 0;
+}
+
+static long kvm_tdp_fd_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	/* Do not support ioctl currently. May add it in future */
+	return -ENODEV;
+}
+
+static int kvm_tdp_fd_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	return -ENODEV;
+}
+
+static const struct file_operations kvm_tdp_fd_fops = {
+	.unlocked_ioctl = kvm_tdp_fd_ioctl,
+	.compat_ioctl   = compat_ptr_ioctl,
+	.release = kvm_tdp_fd_release,
+	.mmap = kvm_tdp_fd_mmap,
+};
+
+static inline int is_tdp_fd_file(struct file *file)
+{
+	return file->f_op == &kvm_tdp_fd_fops;
+}
+
+static int kvm_tdp_register_importer(struct kvm_tdp_fd *tdp_fd,
+				     struct kvm_tdp_importer_ops *ops, void *data)
+{
+	return -EOPNOTSUPP;
+}
+
+static void kvm_tdp_unregister_importer(struct kvm_tdp_fd *tdp_fd,
+					struct kvm_tdp_importer_ops *ops)
+{
+}
+
+static void *kvm_tdp_get_metadata(struct kvm_tdp_fd *tdp_fd)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static int kvm_tdp_fault(struct kvm_tdp_fd *tdp_fd, struct mm_struct *mm,
+			 unsigned long gfn, struct kvm_tdp_fault_type type)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct kvm_exported_tdp_ops exported_tdp_ops = {
+	.register_importer = kvm_tdp_register_importer,
+	.unregister_importer = kvm_tdp_unregister_importer,
+	.get_metadata = kvm_tdp_get_metadata,
+	.fault = kvm_tdp_fault,
+};
+
+/**
+ * kvm_tdp_fd_get - Public interface to get KVM TDP FD object.
+ *
+ * @fd:      fd of the KVM TDP FD object.
+ * @return:  KVM TDP FD object if @fd corresponds to a valid KVM TDP FD file.
+ *           -EBADF if @fd does not correspond a struct file.
+ *           -EINVAL if @fd does not correspond to a KVM TDP FD file.
+ *
+ * Callers of this interface will get a KVM TDP FD object with ref count
+ * increased.
+ */
+struct kvm_tdp_fd *kvm_tdp_fd_get(int fd)
+{
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if (!is_tdp_fd_file(file)) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+	return file->private_data;
+}
+EXPORT_SYMBOL_GPL(kvm_tdp_fd_get);
+
+/**
+ * kvm_tdp_fd_put - Public interface to put ref count of a KVM TDP FD object.
+ *
+ * @tdp_fd:  KVM TDP FD object.
+ *
+ * Put reference count of the KVM TDP FD object.
+ * After the last reference count of the TDP fd goes away,
+ * kvm_tdp_fd_release() will be called to decrease KVM VM ref count and destroy
+ * the KVM TDP FD object.
+ */
+void kvm_tdp_fd_put(struct kvm_tdp_fd *tdp_fd)
+{
+	if (WARN_ON(!tdp_fd || !tdp_fd->file || !is_tdp_fd_file(tdp_fd->file)))
+		return;
+
+	fput(tdp_fd->file);
+}
+EXPORT_SYMBOL_GPL(kvm_tdp_fd_put);
diff --git a/virt/kvm/tdp_fd.h b/virt/kvm/tdp_fd.h
index 05c8a6d767469..85da9d8cc1ce4 100644
--- a/virt/kvm/tdp_fd.h
+++ b/virt/kvm/tdp_fd.h
@@ -2,9 +2,14 @@
 #ifndef __TDP_FD_H
 #define __TDP_FD_H
 
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+int kvm_create_tdp_fd(struct kvm *kvm, struct kvm_create_tdp_fd *ct);
+
+#else
 static inline int kvm_create_tdp_fd(struct kvm *kvm, struct kvm_create_tdp_fd *ct)
 {
 	return -EOPNOTSUPP;
 }
+#endif /* CONFIG_HAVE_KVM_EXPORTED_TDP */
 
 #endif /* __TDP_FD_H */
-- 
2.17.1


