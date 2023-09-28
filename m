Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2727B24C7
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjI1SHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjI1SHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:07:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E980E19F
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695924418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=W2Qgpx+gPcVi5iw6zaPVN+JMZ4nnFY6HftGrYu1Yym0=;
        b=Lhyf04EJduDAWqy8sxJIC6NIio1b2aAFPGdlMoshQMd57z/Dim9VLbi3nX+GoHqoTL/Z4Q
        9J8F5VdIe9/jxy1EdKtVa1u6K+8tQdkZPYQQHdvUNDUH07b3gVClWK3BAQdQiYM8J+tQRj
        tULXQWNk4tBd+1lAV8YMV9GWzfdzAkg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-4YkjJcL7OQmrDNyzn_vVhQ-1; Thu, 28 Sep 2023 14:06:52 -0400
X-MC-Unique: 4YkjJcL7OQmrDNyzn_vVhQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42EBC29AA386;
        Thu, 28 Sep 2023 18:06:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2266D140273C;
        Thu, 28 Sep 2023 18:06:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Date:   Thu, 28 Sep 2023 14:06:51 -0400
Message-Id: <20230928180651.1525674-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a run-of-the-mill anonymous inode, there is nothing useful
being provided by kvm_gmem_fs.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/uapi/linux/magic.h |   1 -
 virt/kvm/guest_mem.c       | 110 ++++++++++---------------------------
 virt/kvm/kvm_main.c        |   6 --
 3 files changed, 30 insertions(+), 87 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index afe9c376c9a5..6325d1d0e90f 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -101,6 +101,5 @@
 #define DMA_BUF_MAGIC		0x444d4142	/* "DMAB" */
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
-#define KVM_GUEST_MEMORY_MAGIC	0x474d454d	/* "GMEM" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index a819367434e9..73b841a2e1b1 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -3,14 +3,10 @@
 #include <linux/falloc.h>
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
-#include <linux/pseudo_fs.h>
-
-#include <uapi/linux/magic.h>
+#include <linux/anon_inodes.h>
 
 #include "kvm_mm.h"
 
-static struct vfsmount *kvm_gmem_mnt;
-
 struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
@@ -356,23 +352,40 @@ static const struct inode_operations kvm_gmem_iops = {
 	.setattr	= kvm_gmem_setattr,
 };
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
-			     struct vfsmount *mnt)
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	const char *anon_name = "[kvm-gmem]";
-	const struct qstr qname = QSTR_INIT(anon_name, strlen(anon_name));
 	struct kvm_gmem *gmem;
 	struct inode *inode;
 	struct file *file;
 	int fd, err;
 
-	inode = alloc_anon_inode(mnt->mnt_sb);
-	if (IS_ERR(inode))
-		return PTR_ERR(inode);
+	fd = get_unused_fd_flags(0);
+	if (fd < 0)
+		return fd;
 
-	err = security_inode_init_security_anon(inode, &qname, NULL);
-	if (err)
-		goto err_inode;
+	gmem = kzalloc(sizeof(*gmem), GFP_KERNEL);
+	if (!gmem) {
+		err = -ENOMEM;
+		goto err_fd;
+	}
+
+	file = anon_inode_getfile(anon_name, &kvm_gmem_fops, gmem,
+				  O_RDWR);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_gmem;
+	}
+
+	file->f_flags |= O_LARGEFILE;
+
+	kvm_get_kvm(kvm);
+	gmem->kvm = kvm;
+	xa_init(&gmem->bindings);
+	list_add(&gmem->entry, &file->f_mapping->private_list);
+
+	inode = file->f_inode;
+	WARN_ON(file->f_mapping != inode->i_mapping);
 
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
@@ -385,44 +398,13 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
-	fd = get_unused_fd_flags(0);
-	if (fd < 0) {
-		err = fd;
-		goto err_inode;
-	}
-
-	file = alloc_file_pseudo(inode, mnt, "kvm-gmem", O_RDWR, &kvm_gmem_fops);
-	if (IS_ERR(file)) {
-		err = PTR_ERR(file);
-		goto err_fd;
-	}
-
-	file->f_flags |= O_LARGEFILE;
-	file->f_mapping = inode->i_mapping;
-
-	gmem = kzalloc(sizeof(*gmem), GFP_KERNEL);
-	if (!gmem) {
-		err = -ENOMEM;
-		goto err_file;
-	}
-
-	kvm_get_kvm(kvm);
-	gmem->kvm = kvm;
-	xa_init(&gmem->bindings);
-
-	file->private_data = gmem;
-
-	list_add(&gmem->entry, &inode->i_mapping->private_list);
-
 	fd_install(fd, file);
 	return fd;
 
-err_file:
-	fput(file);
+err_gmem:
+	kfree(gmem);
 err_fd:
 	put_unused_fd(fd);
-err_inode:
-	iput(inode);
 	return err;
 }
 
@@ -455,7 +437,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (!kvm_gmem_is_valid_size(size, flags))
 		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags, kvm_gmem_mnt);
+	return __kvm_gmem_create(kvm, size, flags);
 }
 
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -603,35 +585,3 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
-
-static int kvm_gmem_init_fs_context(struct fs_context *fc)
-{
-	if (!init_pseudo(fc, KVM_GUEST_MEMORY_MAGIC))
-		return -ENOMEM;
-
-	return 0;
-}
-
-static struct file_system_type kvm_gmem_fs = {
-	.name		 = "kvm_guest_memory",
-	.init_fs_context = kvm_gmem_init_fs_context,
-	.kill_sb	 = kill_anon_super,
-};
-
-int kvm_gmem_init(void)
-{
-	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
-	if (IS_ERR(kvm_gmem_mnt))
-		return PTR_ERR(kvm_gmem_mnt);
-
-	/* For giggles.  Userspace can never map this anyways. */
-	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
-
-	return 0;
-}
-
-void kvm_gmem_exit(void)
-{
-	kern_unmount(kvm_gmem_mnt);
-	kvm_gmem_mnt = NULL;
-}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a83dfef1316e..4a1ded1faf84 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6424,10 +6424,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		goto err_async_pf;
 
-	r = kvm_gmem_init();
-	if (r)
-		goto err_gmem;
-
 	kvm_chardev_ops.owner = module;
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
@@ -6454,8 +6450,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_register:
 	kvm_vfio_ops_exit();
 err_vfio:
-	kvm_gmem_exit();
-err_gmem:
 	kvm_async_pf_deinit();
 err_async_pf:
 	kvm_irqfd_exit();
-- 
2.39.1

