Return-Path: <kvm+bounces-49055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3A7AD572F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B71E3A527C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5833F29B214;
	Wed, 11 Jun 2025 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l32OR9nx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D2F29B23D
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648832; cv=none; b=tcReNPJFUZrRiFb0pVRAj0/p6fY/l5lD0kf1b9lZW49oc+2iTkK4kc+vAi4iApeFce9nn9zMiKy+cnXYhbk5Mk5Iq0rcoXFCHRSOaqHNrrmmF2iR7qV0tffdhiRow0pWqDFq1p6evaCi9wNO3FWyK67Vs7p0jTkmZGkxrzbjZa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648832; c=relaxed/simple;
	bh=hpf2XueJIoNKejpgsS6eEy+779j23jPnOsrhXYz7b+s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tMi1Y79+wOxLdbpCtZYUtVCzpOq6RBIXs6UW+J3rK8BSPyKCFx+xyIavWBj3UMgEbWtNxH9esDJon2GYdoLg/q5W1FTRHOkIwOD9JSpCQSeGZ+BPuI0aazlCgLxknzML3jtvzNyu15xtfnws5GzWhN9BmYj7T7WfIc8jyIF/Uh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l32OR9nx; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4eeed54c2so4365750f8f.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648829; x=1750253629; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GhEdb4XSRH5QZbPC7u52jNBRkWh7Zb0cdMH+s2fESHE=;
        b=l32OR9nx2ju7A4diBgIx6AbLrV6iGOBAxEYVnLem5V76oWCrxSBh45M76GHbFQ9oaG
         XSMWkvZlcqeMAIbZvqHubJ8TOPqo0sXsl2xQ/lJ9fgfDHqezwpepdOgtD6ZYcgFwvUPQ
         LZwwE6xqQN4zTqHgpUsrKs5zFBC5+m/cZowBPp9Txf/04GRE7VrUxtWa4dXoAQbM5Fuu
         ZM/+L3ZBDRPk6eJMgv4FkqUpn8EEm+wr4QlihX++nkRmelGTFluLQqFo20KhFZOX3Ej7
         uuf6Pmtto0RSPFHjHesXTTaBW+0Fmc9QbToyDhD0CTByZ7igI6p6PAZMLQ94af1pOzW2
         M3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648829; x=1750253629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GhEdb4XSRH5QZbPC7u52jNBRkWh7Zb0cdMH+s2fESHE=;
        b=rDjcjzSCRaPiKM+I/y/Q7y34+vtky/R4XP0QDrPbWyh8BDK//UkEFjYcq4I1C71Q02
         N7Hl8LzfRIHR6AYxbOD6ZFUdkDBNVhWloRyq2XPS7mpte5l/K/Zh2uJ4MinprUN6VLev
         kysC2bucA7gxJghm93D74kli1y0kEsCqwdf4sCbCEWyyak9i9BlbqNRu0f+kA2RftXZM
         6KKOeSPvftZf94Sdfjp6kVPAwGHhaMmz15/i8YMVk6qGGNiGEeBJ4fMV+82FUyDWjQ2c
         5kiCH0k74/Yy678JCOn5GfzB+B4chjQ8oII4sSHqPMit+jLDny9e9HSxa78UQecbH3lf
         lvsQ==
X-Gm-Message-State: AOJu0Yz88xe26Ths50Kh9/Wp650ByZS4a6YEaywhQ0M9eDVjnGBclBNz
	yPrghZHQxta1DL07r6/8pmGU/r+UYD4+slgKNO+O531I3jLb4njb+DhxpcYv1axbZ9k0wl+EP9N
	V8pFVnzRqENz1Zq7tfIbFX+FNVYSfW3i2I+TLsJs6YlYTppNSrnkypd/Hk86hBXaQ5hhnq4L3Jo
	Y6mzOIwnkk2fGRS/cPHxnVcXs1DiM=
X-Google-Smtp-Source: AGHT+IHEd86idQu16yNMsd/8yL8nqu5HVRSk9EU79tULRTu402KZNrREDQmVRg+XHZj/Hl7vzp0Q2cBjwQ==
X-Received: from wma7.prod.google.com ([2002:a05:600c:8907:b0:441:aaa8:fb65])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1a87:b0:3a5:1c3c:8d8d
 with SMTP id ffacd0b85a97d-3a558af983fmr2481697f8f.55.1749648828461; Wed, 11
 Jun 2025 06:33:48 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:20 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-9-tabba@google.com>
Subject: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This patch enables support for shared memory in guest_memfd, including
mapping that memory from host userspace.

This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
flag at creation time.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 13 +++++++
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig         |  4 +++
 virt/kvm/guest_memfd.c   | 73 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9a6712151a74..6b63556ca150 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Returns true if this VM supports shared mem in guest_memfd.
+ *
+ * Arch code must define kvm_arch_supports_gmem_shared_mem if support for
+ * guest_memfd is enabled.
+ */
+#if !defined(kvm_arch_supports_gmem_shared_mem)
+static inline bool kvm_arch_supports_gmem_shared_mem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d00b85cb168c..cb19150fd595 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1ULL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 559c93ad90be..e90884f74404 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_GMEM
+
+config KVM_GMEM_SHARED_MEM
+       select KVM_GMEM
+       bool
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6db515833f61..06616b6b493b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static bool kvm_gmem_supports_shared(struct inode *inode)
+{
+	const u64 flags = (u64)inode->i_private;
+
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
+		return false;
+
+	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
+}
+
+static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct folio *folio;
+	vm_fault_t ret = VM_FAULT_LOCKED;
+
+	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
+		return VM_FAULT_SIGBUS;
+
+	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	if (IS_ERR(folio)) {
+		int err = PTR_ERR(folio);
+
+		if (err == -EAGAIN)
+			return VM_FAULT_RETRY;
+
+		return vmf_error(err);
+	}
+
+	if (WARN_ON_ONCE(folio_test_large(folio))) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		kvm_gmem_mark_prepared(folio);
+	}
+
+	vmf->page = folio_file_page(folio, vmf->pgoff);
+
+out_folio:
+	if (ret != VM_FAULT_LOCKED) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return ret;
+}
+
+static const struct vm_operations_struct kvm_gmem_vm_ops = {
+	.fault = kvm_gmem_fault_shared,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (!kvm_gmem_supports_shared(file_inode(file)))
+		return -ENODEV;
+
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE)) {
+		return -EINVAL;
+	}
+
+	vma->vm_ops = &kvm_gmem_vm_ops;
+
+	return 0;
+}
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
@@ -463,6 +533,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (kvm_arch_supports_gmem_shared_mem(kvm))
+		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


