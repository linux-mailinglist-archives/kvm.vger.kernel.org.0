Return-Path: <kvm+bounces-31285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 077A69C210F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA3F02865DA
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0DFB21B44B;
	Fri,  8 Nov 2024 15:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UkyBB0E1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D130D21A718
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 15:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731081070; cv=none; b=pA2nGbDfXP3S9q5+/IiCxgyXzF1eSS+UHe8SKeXyrf/3CBzcoWUAssXiV3bJKJc180QFRO9UX0sj04kTAimXVdUpTN1Ub3QNRz8LU/XM+50/4+qIV3b/EHTJHMDY9Xag+V/REgOjRqRXxoB8TOg5+5VKHATebr/R0uPFX3NVlWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731081070; c=relaxed/simple;
	bh=LScR6Xj7avBL1rJJLStBikYzGWJDQNgm+T6bJpW8hgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OqAN9Crk+gpEjC4WZkaQdYmoX0xrrwMaq0dUMyUBoiPxJGCc9hmjTkJfs3qxkYTZxAVsiRkN8b+IashTaU354ZsOAp4iIlgDLyJI0ZwzJm4+CwX1VtizAQjfHH2X72If06NNGw3EUSk37FkiJDkZMm9uKjKI3FB6YFwbyZuZrfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UkyBB0E1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731081066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KbK3ApElp81ArROKxgA5UKvEaAc0M1YUxQEdMoV1TmE=;
	b=UkyBB0E1st+BGs9Rzsu5t8pHAR4G0zbaW1ERjNRYj281O8GZoSd+1jeUVj1L9+sUMPrC3S
	fvffrZWPSFNH7zApyq9Semv3rZlFIad+bT/Fo3eTNhYf4fuhQynRQlPYA4jdN2fhkjnrSf
	J+hNzhHTnOjfnOMx/kEPeG8uLpJzy6k=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-5j0Jw1_dNpKYQfnr7qmC4A-1; Fri,
 08 Nov 2024 10:51:05 -0500
X-MC-Unique: 5j0Jw1_dNpKYQfnr7qmC4A-1
X-Mimecast-MFC-AGG-ID: 5j0Jw1_dNpKYQfnr7qmC4A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25F1F1953943;
	Fri,  8 Nov 2024 15:51:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6797A300019F;
	Fri,  8 Nov 2024 15:51:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	seanjc@google.com
Subject: [PATCH 1/3] KVM: gmem: allocate private data for the gmem inode
Date: Fri,  8 Nov 2024 10:50:54 -0500
Message-ID: <20241108155056.332412-2-pbonzini@redhat.com>
In-Reply-To: <20241108155056.332412-1-pbonzini@redhat.com>
References: <20241108155056.332412-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In preparation for removing the usage of the uptodate flag,
reintroduce the gmem filesystem type.  We need it in order to
free the private inode information.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/uapi/linux/magic.h |   1 +
 virt/kvm/guest_memfd.c     | 117 +++++++++++++++++++++++++++++++++----
 virt/kvm/kvm_main.c        |   7 ++-
 virt/kvm/kvm_mm.h          |   8 ++-
 4 files changed, 119 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index bb575f3ab45e..d856dd6a7ed9 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -103,5 +103,6 @@
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
+#define KVM_GUEST_MEM_MAGIC	0x474d454d	/* "GMEM" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8f079a61a56d..3ea5a7597fd4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,9 +4,74 @@
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
 #include <linux/anon_inodes.h>
+#include <linux/pseudo_fs.h>
 
 #include "kvm_mm.h"
 
+/* Do all the filesystem crap just for evict_inode... */
+
+static struct vfsmount *kvm_gmem_mnt __read_mostly;
+
+static void gmem_evict_inode(struct inode *inode)
+{
+	kvfree(inode->i_private);
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+}
+
+static const struct super_operations gmem_super_operations = {
+	.drop_inode	= generic_delete_inode,
+	.evict_inode    = gmem_evict_inode,
+	.statfs         = simple_statfs,
+};
+
+static int gmem_init_fs_context(struct fs_context *fc)
+{
+	struct pseudo_fs_context *ctx = init_pseudo(fc, KVM_GUEST_MEM_MAGIC);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->ops = &gmem_super_operations;
+	return 0;
+}
+
+static struct file_system_type kvm_gmem_fs_type = {
+	.name           = "kvm_gmemfs",
+	.init_fs_context = gmem_init_fs_context,
+	.kill_sb        = kill_anon_super,
+};
+
+static struct file *kvm_gmem_create_file(const char *name, const struct file_operations *fops)
+{
+	struct inode *inode;
+	struct file *file;
+
+	if (fops->owner && !try_module_get(fops->owner))
+		return ERR_PTR(-ENOENT);
+
+	inode = alloc_anon_inode(kvm_gmem_mnt->mnt_sb);
+	if (IS_ERR(inode)) {
+		file = ERR_CAST(inode);
+		goto err;
+	}
+	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, fops);
+	if (IS_ERR(file))
+		goto err_iput;
+
+	return file;
+
+err_iput:
+	iput(inode);
+err:
+	module_put(fops->owner);
+	return file;
+}
+
+
+struct kvm_gmem_inode {
+	unsigned long flags;
+};
+
 struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
@@ -308,9 +373,31 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };
 
-void kvm_gmem_init(struct module *module)
+int kvm_gmem_init(struct module *module)
 {
+	int ret;
+
+	ret = register_filesystem(&kvm_gmem_fs_type);
+	if (ret) {
+		pr_err("kvm-gmem: cannot register file system (%d)\n", ret);
+		return ret;
+	}
+
+	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs_type);
+	if (IS_ERR(kvm_gmem_mnt)) {
+		pr_err("kvm-gmem: kernel mount failed (%ld)\n", PTR_ERR(kvm_gmem_mnt));
+		return PTR_ERR(kvm_gmem_mnt);
+	}
+
 	kvm_gmem_fops.owner = module;
+
+	return 0;
+}
+
+void kvm_gmem_exit(void)
+{
+	kern_unmount(kvm_gmem_mnt);
+	unregister_filesystem(&kvm_gmem_fs_type);
 }
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
@@ -394,15 +481,23 @@ static const struct inode_operations kvm_gmem_iops = {
 
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
-	const char *anon_name = "[kvm-gmem]";
+	const char *gmem_name = "[kvm-gmem]";
+	struct kvm_gmem_inode *i_gmem;
 	struct kvm_gmem *gmem;
 	struct inode *inode;
 	struct file *file;
 	int fd, err;
 
+	i_gmem = kvzalloc(sizeof(struct kvm_gmem_inode), GFP_KERNEL);
+	if (!i_gmem)
+		return -ENOMEM;
+	i_gmem->flags = flags;
+
 	fd = get_unused_fd_flags(0);
-	if (fd < 0)
-		return fd;
+	if (fd < 0) {
+		err = fd;
+		goto err_i_gmem;
+	}
 
 	gmem = kzalloc(sizeof(*gmem), GFP_KERNEL);
 	if (!gmem) {
@@ -410,19 +505,19 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}
 
-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
-					 O_RDWR, NULL);
+	file = kvm_gmem_create_file(gmem_name, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
 		goto err_gmem;
 	}
 
+	inode = file->f_inode;
+
+	file->f_mapping = inode->i_mapping;
+	file->private_data = gmem;
 	file->f_flags |= O_LARGEFILE;
 
-	inode = file->f_inode;
-	WARN_ON(file->f_mapping != inode->i_mapping);
-
-	inode->i_private = (void *)(unsigned long)flags;
+	inode->i_private = i_gmem;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
 	inode->i_mode |= S_IFREG;
@@ -444,6 +539,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	kfree(gmem);
 err_fd:
 	put_unused_fd(fd);
+err_i_gmem:
+	kvfree(i_gmem);
 	return err;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 279e03029ce1..8b7b4e0eb639 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6504,7 +6504,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (WARN_ON_ONCE(r))
 		goto err_vfio;
 
-	kvm_gmem_init(module);
+	r = kvm_gmem_init(module);
+	if (r)
+		goto err_gmem;
 
 	r = kvm_init_virtualization();
 	if (r)
@@ -6525,6 +6527,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_register:
 	kvm_uninit_virtualization();
 err_virt:
+	kvm_gmem_exit();
+err_gmem:
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
@@ -6556,6 +6560,7 @@ void kvm_exit(void)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
+	kvm_gmem_exit();
 	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
 	kvm_irqfd_exit();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01..91e4202574a8 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -36,15 +36,17 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 #endif /* HAVE_KVM_PFNCACHE */
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
-void kvm_gmem_init(struct module *module);
+int kvm_gmem_init(struct module *module);
+void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
-static inline void kvm_gmem_init(struct module *module)
+static inline void kvm_gmem_exit(void) {}
+static inline int kvm_gmem_init(struct module *module)
 {
-
+	return 0;
 }
 
 static inline int kvm_gmem_bind(struct kvm *kvm,
-- 
2.43.5



