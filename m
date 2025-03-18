Return-Path: <kvm+bounces-41407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D307DA67941
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:26:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE8F33B0A02
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78842211A02;
	Tue, 18 Mar 2025 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HC7CJ57n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE0D17A311
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314853; cv=none; b=UkNA3nkKmQP3/9sigrzjacuexaKqPTUnpJfHYKnwBx9me3JfEoqcXOXsfB8MC7Q+w/e8UcSb9+aaU+Cguw03RiD9xNi9sXeMS6GVktyX5UM2AvQ2IoeCnfLL8m7awJ7VeuIsM+d05TzIiEcmneHHRbFdRafPIVd1sFYhuXIRJyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314853; c=relaxed/simple;
	bh=+uAQQFv/HC4X/TsoZiJYsInJJ/tobCJzXnm8Ee+ujoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eTJF3TiUNkVOwp08sQdg1SVX4hLXjI+4l4IUpW0F7XjgpIE3eE/FSt7Fj5CWs/wUSR2afOlAdbqqOnwkKYnjmiyEaCyjPntLkOjIeqOU4ii2vqNsrwDwXS9KSXt0QimNsaQktHWt8gfP8peOd2HF5hviSZyxJYWHqThJif+/H9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HC7CJ57n; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bd0586b86so19670835e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314850; x=1742919650; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5BCJQxA8skMwKLEJl+6kBnMuf3AEUFL1v827aCOrto=;
        b=HC7CJ57nD1VJOOGlQP7/q/R7Oul3XIuHDc33aRZQLxdVcHn3tcsZFaIZfOY99CSba7
         6wQujL16MXBZuS47WgUTa/C7H8D6fObdoP+npFm9MrOfT/DaevwjyUVLdHMHmYVjmXpX
         aj4NtBUE/LWrAj2AvlVitAwWqtY4MkPNEFPnFPJA8QpQSVHsw74RVWPwisgibJqzxfJx
         qOSdH5NK6Ebrf9vDX/Lzd1pPIaYcXc28pnRBZg0NY1qdp8n8IUVt2BFUTlb8fWr85pCX
         jFGy/mRdmwvspGowso7GjvKmqL1nYqH2zDkWCqmge44mcWqTo+PvvmwJrFdPyS72IdLX
         7XaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314850; x=1742919650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v5BCJQxA8skMwKLEJl+6kBnMuf3AEUFL1v827aCOrto=;
        b=P1fDI1VHVi7wwzdTgl1x1UZA/r4cP6xoLGWxNEgVlzNWe23yeqe+EtZQKrcxQCV+xs
         UpShce13JIT0V+eMrIKHqLcz85Xf7cT8EDeICICQVSC0KKqf2uCNnm+KZkKQOCm+VdG6
         cOXIzUbHEs6OccDJmIQz+DnNs63KlyN7Dul62hn/Kuh1JjJlmU7684/VMnU/uGbgmUUa
         asJGF8r7dgYzgQVgw+gom/xHEIRLvB/7oJ8RevISe6FWgm/0hd2Vi2uvnnIBgFEJ8pPb
         zh6PxfXiNipZLtrhd1bu33n6HH+qme2reoCgdb11Zqj7piJUOT360i2rit5wzx0iyX1o
         FlLg==
X-Gm-Message-State: AOJu0YynucxpJu0MzIRZ8g6PeJvj2G0p5ORkCEjEQeFom0mDKjH5C1RM
	iz06hp4D/qu+ftpDiyIn8DdHG/bYlLOv1TE8hI0f5v8A4JlYjrlGtWnfsnu4GbHn594vpDuXxUI
	anHeTTUqIuaF9/ogBd46oErejUk3qzc6p26hfk1TKn8M0pnB8AN1+TsJraRpYDVRD+gMasq5aYy
	0yqLTdd4pFh+2aYR1QVzda/Lw=
X-Google-Smtp-Source: AGHT+IGbzRLPDDV73rxMsaRerWBWjkFmSiW+9snF6eGB9z04UAhCgCAjBT3TYQ4Timp1oFUP+R5pRnwAyg==
X-Received: from wmbgx13.prod.google.com ([2002:a05:600c:858d:b0:43d:1d5b:1c79])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4690:b0:43c:ec28:d303
 with SMTP id 5b1f17b1804b1-43d3b950aefmr32213585e9.5.1742314850210; Tue, 18
 Mar 2025 09:20:50 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:20:40 +0000
In-Reply-To: <20250318162046.4016367-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318162046.4016367-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162046.4016367-2-tabba@google.com>
Subject: [PATCH v6 1/7] KVM: guest_memfd: Make guest mem use guest mem inodes
 instead of anonymous inodes
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Using guest mem inodes allows us to store metadata for the backing
memory on the inode. Metadata will be added in a later patch to support
HugeTLB pages.

Metadata about backing memory should not be stored on the file, since
the file represents a guest_memfd's binding with a struct kvm, and
metadata about backing memory is not unique to a specific binding and
struct kvm.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/magic.h |   1 +
 virt/kvm/guest_memfd.c     | 130 +++++++++++++++++++++++++++++++------
 2 files changed, 111 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index bb575f3ab45e..169dba2a6920 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -103,5 +103,6 @@
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
+#define GUEST_MEMORY_MAGIC	0x474d454d	/* "GMEM" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fbf89e643add..844e70c82558 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,12 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/fs.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
 #include <linux/kvm_host.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/anon_inodes.h>
 
 #include "kvm_mm.h"
 
+static struct vfsmount *kvm_gmem_mnt;
+
 struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
@@ -320,6 +324,38 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static const struct super_operations kvm_gmem_super_operations = {
+	.statfs		= simple_statfs,
+};
+
+static int kvm_gmem_init_fs_context(struct fs_context *fc)
+{
+	struct pseudo_fs_context *ctx;
+
+	if (!init_pseudo(fc, GUEST_MEMORY_MAGIC))
+		return -ENOMEM;
+
+	ctx = fc->fs_private;
+	ctx->ops = &kvm_gmem_super_operations;
+
+	return 0;
+}
+
+static struct file_system_type kvm_gmem_fs = {
+	.name		 = "kvm_guest_memory",
+	.init_fs_context = kvm_gmem_init_fs_context,
+	.kill_sb	 = kill_anon_super,
+};
+
+static void kvm_gmem_init_mount(void)
+{
+	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
+	BUG_ON(IS_ERR(kvm_gmem_mnt));
+
+	/* For giggles. Userspace can never map this anyways. */
+	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
+}
+
 #ifdef CONFIG_KVM_GMEM_SHARED_MEM
 static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
 {
@@ -430,6 +466,8 @@ static struct file_operations kvm_gmem_fops = {
 void kvm_gmem_init(struct module *module)
 {
 	kvm_gmem_fops.owner = module;
+
+	kvm_gmem_init_mount();
 }
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
@@ -511,11 +549,79 @@ static const struct inode_operations kvm_gmem_iops = {
 	.setattr	= kvm_gmem_setattr,
 };
 
+static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
+						      loff_t size, u64 flags)
+{
+	const struct qstr qname = QSTR_INIT(name, strlen(name));
+	struct inode *inode;
+	int err;
+
+	inode = alloc_anon_inode(kvm_gmem_mnt->mnt_sb);
+	if (IS_ERR(inode))
+		return inode;
+
+	err = security_inode_init_security_anon(inode, &qname, NULL);
+	if (err) {
+		iput(inode);
+		return ERR_PTR(err);
+	}
+
+	inode->i_private = (void *)(unsigned long)flags;
+	inode->i_op = &kvm_gmem_iops;
+	inode->i_mapping->a_ops = &kvm_gmem_aops;
+	inode->i_mode |= S_IFREG;
+	inode->i_size = size;
+	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_inaccessible(inode->i_mapping);
+	/* Unmovable mappings are supposed to be marked unevictable as well. */
+	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+
+	return inode;
+}
+
+static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
+						  u64 flags)
+{
+	static const char *name = "[kvm-gmem]";
+	struct inode *inode;
+	struct file *file;
+	int err;
+
+	err = -ENOENT;
+	if (!try_module_get(kvm_gmem_fops.owner))
+		goto err;
+
+	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_put_module;
+	}
+
+	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
+				 &kvm_gmem_fops);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_put_inode;
+	}
+
+	file->f_flags |= O_LARGEFILE;
+	file->private_data = priv;
+
+out:
+	return file;
+
+err_put_inode:
+	iput(inode);
+err_put_module:
+	module_put(kvm_gmem_fops.owner);
+err:
+	file = ERR_PTR(err);
+	goto out;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
-	const char *anon_name = "[kvm-gmem]";
 	struct kvm_gmem *gmem;
-	struct inode *inode;
 	struct file *file;
 	int fd, err;
 
@@ -529,32 +635,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}
 
-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
-					 O_RDWR, NULL);
+	file = kvm_gmem_inode_create_getfile(gmem, size, flags);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
 		goto err_gmem;
 	}
 
-	file->f_flags |= O_LARGEFILE;
-
-	inode = file->f_inode;
-	WARN_ON(file->f_mapping != inode->i_mapping);
-
-	inode->i_private = (void *)(unsigned long)flags;
-	inode->i_op = &kvm_gmem_iops;
-	inode->i_mapping->a_ops = &kvm_gmem_aops;
-	inode->i_mode |= S_IFREG;
-	inode->i_size = size;
-	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-	mapping_set_inaccessible(inode->i_mapping);
-	/* Unmovable mappings are supposed to be marked unevictable as well. */
-	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
-
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
-	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
+	list_add(&gmem->entry, &file_inode(file)->i_mapping->i_private_list);
 
 	fd_install(fd, file);
 	return fd;
-- 
2.49.0.rc1.451.g8f38331e32-goog


