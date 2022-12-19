Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF9B6508C0
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiLSIrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiLSIrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:42 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12B3A1BB
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439660; x=1702975660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u6ravFXwu0qcSyxTT4L4QXDzCd7tAVXR36AsFI5W24s=;
  b=VgYkqCqHb/z5b+e9cN4tn7HagWjD7keIOxbHbsgiRt4w4oIpnNzpOnqV
   5NLFA8wUF+Xc21IOrdXBXFvS8gxf4woUa1403exrYYSFOD47Fr6k5bosu
   w41WSaAe8BcuXBBnazT7qGQoDSuE6SHfXjjShMo2JRoKRFqOOp90+wfAl
   FVZV+kVt6f/YUUz4SHAZc9bI9SHD8opcU3qnu0zaGh/5wc1bvr6k1nc1d
   lapau+AwuLo6TnTuicFtojsUJvPu9Pv1I8UrEjTw+yxQwwD227Nqxt6Pu
   bgUT4r7WBZx8Z4BWyE2OD+mwgvehQDoJ6+cMKE/CA9tu7ms17HRO+WfGD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528454"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528454"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233762"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233762"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:40 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 04/12] kvm/vfio: Rename kvm_vfio_group to prepare for accepting vfio device fd
Date:   Mon, 19 Dec 2022 00:47:10 -0800
Message-Id: <20221219084718.9342-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219084718.9342-1-yi.l.liu@intel.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Meanwhile, rename related helpers. No functional change is intended.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 virt/kvm/vfio.c | 115 ++++++++++++++++++++++++------------------------
 1 file changed, 58 insertions(+), 57 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 868930c7a59b..0f54b9d308d7 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -21,7 +21,7 @@
 #include <asm/kvm_ppc.h>
 #endif
 
-struct kvm_vfio_group {
+struct kvm_vfio_file {
 	struct list_head node;
 	struct file *file;
 #ifdef CONFIG_SPAPR_TCE_IOMMU
@@ -30,7 +30,7 @@ struct kvm_vfio_group {
 };
 
 struct kvm_vfio {
-	struct list_head group_list;
+	struct list_head file_list;
 	struct mutex lock;
 	bool noncoherent;
 };
@@ -98,34 +98,35 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 }
 
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
-					     struct kvm_vfio_group *kvg)
+					     struct kvm_vfio_file *kvf)
 {
-	if (WARN_ON_ONCE(!kvg->iommu_group))
+	if (WARN_ON_ONCE(!kvf->iommu_group))
 		return;
 
-	kvm_spapr_tce_release_iommu_group(kvm, kvg->iommu_group);
-	iommu_group_put(kvg->iommu_group);
-	kvg->iommu_group = NULL;
+	kvm_spapr_tce_release_iommu_group(kvm, kvf->iommu_group);
+	iommu_group_put(kvf->iommu_group);
+	kvf->iommu_group = NULL;
 }
 #endif
 
 /*
- * Groups can use the same or different IOMMU domains.  If the same then
- * adding a new group may change the coherency of groups we've previously
- * been told about.  We don't want to care about any of that so we retest
- * each group and bail as soon as we find one that's noncoherent.  This
- * means we only ever [un]register_noncoherent_dma once for the whole device.
+ * Groups/devices can use the same or different IOMMU domains.  If the same
+ * then adding a new group/device may change the coherency of groups/devices
+ * we've previously been told about.  We don't want to care about any of
+ * that so we retest each group/device and bail as soon as we find one that's
+ * noncoherent.  This means we only ever [un]register_noncoherent_dma once
+ * for the whole device.
  */
 static void kvm_vfio_update_coherency(struct kvm_device *dev)
 {
 	struct kvm_vfio *kv = dev->private;
 	bool noncoherent = false;
-	struct kvm_vfio_group *kvg;
+	struct kvm_vfio_file *kvf;
 
 	mutex_lock(&kv->lock);
 
-	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (!kvm_vfio_file_enforced_coherent(kvg->file)) {
+	list_for_each_entry(kvf, &kv->file_list, node) {
+		if (!kvm_vfio_file_enforced_coherent(kvf->file)) {
 			noncoherent = true;
 			break;
 		}
@@ -143,10 +144,10 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 	mutex_unlock(&kv->lock);
 }
 
-static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
+static int kvm_vfio_file_add(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
-	struct kvm_vfio_group *kvg;
+	struct kvm_vfio_file *kvf;
 	struct file *filp;
 	int ret;
 
@@ -162,27 +163,27 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 
 	mutex_lock(&kv->lock);
 
-	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->file == filp) {
+	list_for_each_entry(kvf, &kv->file_list, node) {
+		if (kvf->file == filp) {
 			ret = -EEXIST;
 			goto err_unlock;
 		}
 	}
 
-	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
-	if (!kvg) {
+	kvf = kzalloc(sizeof(*kvf), GFP_KERNEL_ACCOUNT);
+	if (!kvf) {
 		ret = -ENOMEM;
 		goto err_unlock;
 	}
 
-	kvg->file = filp;
-	list_add_tail(&kvg->node, &kv->group_list);
+	kvf->file = filp;
+	list_add_tail(&kvf->node, &kv->file_list);
 
 	kvm_arch_start_assignment(dev->kvm);
 
 	mutex_unlock(&kv->lock);
 
-	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
+	kvm_vfio_file_set_kvm(kvf->file, dev->kvm);
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
@@ -193,10 +194,10 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	return ret;
 }
 
-static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
+static int kvm_vfio_file_del(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
-	struct kvm_vfio_group *kvg;
+	struct kvm_vfio_file *kvf;
 	struct fd f;
 	int ret;
 
@@ -208,18 +209,18 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 
 	mutex_lock(&kv->lock);
 
-	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->file != f.file)
+	list_for_each_entry(kvf, &kv->file_list, node) {
+		if (kvf->file != f.file)
 			continue;
 
-		list_del(&kvg->node);
+		list_del(&kvf->node);
 		kvm_arch_end_assignment(dev->kvm);
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvf);
 #endif
-		kvm_vfio_file_set_kvm(kvg->file, NULL);
-		fput(kvg->file);
-		kfree(kvg);
+		kvm_vfio_file_set_kvm(kvf->file, NULL);
+		fput(kvf->file);
+		kfree(kvf);
 		ret = 0;
 		break;
 	}
@@ -234,12 +235,12 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 }
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
-					void __user *arg)
+static int kvm_vfio_file_set_spapr_tce(struct kvm_device *dev,
+				       void __user *arg)
 {
 	struct kvm_vfio_spapr_tce param;
 	struct kvm_vfio *kv = dev->private;
-	struct kvm_vfio_group *kvg;
+	struct kvm_vfio_file *kvf;
 	struct fd f;
 	int ret;
 
@@ -254,20 +255,20 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 
 	mutex_lock(&kv->lock);
 
-	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->file != f.file)
+	list_for_each_entry(kvf, &kv->file_list, node) {
+		if (kvf->file != f.file)
 			continue;
 
-		if (!kvg->iommu_group) {
-			kvg->iommu_group = kvm_vfio_file_iommu_group(kvg->file);
-			if (WARN_ON_ONCE(!kvg->iommu_group)) {
+		if (!kvf->iommu_group) {
+			kvf->iommu_group = kvm_vfio_file_iommu_group(kvf->file);
+			if (WARN_ON_ONCE(!kvf->iommu_group)) {
 				ret = -EIO;
 				goto err_fdput;
 			}
 		}
 
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
-						       kvg->iommu_group);
+						       kvf->iommu_group);
 		break;
 	}
 
@@ -278,8 +279,8 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 }
 #endif
 
-static int kvm_vfio_set_group(struct kvm_device *dev, long attr,
-			      void __user *arg)
+static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
+			     void __user *arg)
 {
 	int32_t __user *argp = arg;
 	int32_t fd;
@@ -288,16 +289,16 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr,
 	case KVM_DEV_VFIO_GROUP_ADD:
 		if (get_user(fd, argp))
 			return -EFAULT;
-		return kvm_vfio_group_add(dev, fd);
+		return kvm_vfio_file_add(dev, fd);
 
 	case KVM_DEV_VFIO_GROUP_DEL:
 		if (get_user(fd, argp))
 			return -EFAULT;
-		return kvm_vfio_group_del(dev, fd);
+		return kvm_vfio_file_del(dev, fd);
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
-		return kvm_vfio_group_set_spapr_tce(dev, arg);
+		return kvm_vfio_file_set_spapr_tce(dev, arg);
 #endif
 	}
 
@@ -309,8 +310,8 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_VFIO_GROUP:
-		return kvm_vfio_set_group(dev, attr->attr,
-					  u64_to_user_ptr(attr->addr));
+		return kvm_vfio_set_file(dev, attr->attr,
+					 u64_to_user_ptr(attr->addr));
 	}
 
 	return -ENXIO;
@@ -339,16 +340,16 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 static void kvm_vfio_destroy(struct kvm_device *dev)
 {
 	struct kvm_vfio *kv = dev->private;
-	struct kvm_vfio_group *kvg, *tmp;
+	struct kvm_vfio_file *kvf, *tmp;
 
-	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
+	list_for_each_entry_safe(kvf, tmp, &kv->file_list, node) {
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvf);
 #endif
-		kvm_vfio_file_set_kvm(kvg->file, NULL);
-		fput(kvg->file);
-		list_del(&kvg->node);
-		kfree(kvg);
+		kvm_vfio_file_set_kvm(kvf->file, NULL);
+		fput(kvf->file);
+		list_del(&kvf->node);
+		kfree(kvf);
 		kvm_arch_end_assignment(dev->kvm);
 	}
 
@@ -382,7 +383,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
 	if (!kv)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&kv->group_list);
+	INIT_LIST_HEAD(&kv->file_list);
 	mutex_init(&kv->lock);
 
 	dev->private = kv;
-- 
2.34.1

