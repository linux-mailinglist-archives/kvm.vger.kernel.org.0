Return-Path: <kvm+bounces-46361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA504AB5A0D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ABBF4A7705
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3AAD2BFC8B;
	Tue, 13 May 2025 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LCDwW2g7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2D72BFC7F
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154099; cv=none; b=hu5IKhlzEOIKmS5vhTUCcNsz3JtjSdXl0id8f+iLiWsWNYZragt3/efq+o6duVO91ZXUTGp4EwiEeeWx9D0yzOP71mYHhyCwfLL7eJLj8RT0oFwiQ0QJepl2+wBqaEs7Wc9PkXUqI+WxaKTXxSBeRs1SWBm5+/xy4oYdP6JRQn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154099; c=relaxed/simple;
	bh=BF6onoCQPf5NdVbqWJHgvBCSL7W2+jD6ynTu+GAkpVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fmx8K8MqwtGoRidFKjpfb9rVhL9EK/p1OyA69fTBXZ7TI6VPfq1GX3c5HCBwd07a/fQYUsAAmoCwteIOz60AmTvYLJl02uUvcU50vP386BFfzZhPRil1wADeV3xc5QzKN607PAPqQq2CRHQ6a4uxF5GekkXEHz3uJCPH5PARtMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LCDwW2g7; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-441c122fa56so23381005e9.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154095; x=1747758895; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xkiFt+XKx4YC9meq4bLaztuX851NYA6IvyxpfbaNDQM=;
        b=LCDwW2g7j0giquwV85+i80qrJR1LEBIyBAXUBc2YTky+vbT2XE6XwohX4VPJCH0yxH
         wcv92r7akyYvibqR0Wma3T4wb7FsHoYyv1orxBdHPVzF/68XKFxKOjZua6yqn4oN1diu
         DejvhsfPh/JCXVu7mWrhx0ZJZ1CBn5fkyStE/oknbrwhddq1CjSOajIvrUTLaeT0fDsT
         oUj8QWwdYTGtviLNm9Iqrlc5lInfwz6+q1arkfRDgvTZYjqOjEuLcKdsxoCMpI/phK1+
         q32JC9xYDY/YIWJN3gNi1aThmCwJxQUd4dhc3PatlK8JbtBL5oZsyuESRH2g1/eaeL2P
         Vufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154095; x=1747758895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xkiFt+XKx4YC9meq4bLaztuX851NYA6IvyxpfbaNDQM=;
        b=LJXSBCNAgZaowpoJfhb1ZhG2lQ/iQzZ6VBq6LtGZ4KiujZgqQLVUimPSMe8hklBVcS
         TBL8iYaN2r8mGDQ5StgAcdsmg/m9s8b08Y9MFKUjwMbXyqnLO61oAFID3agHpwKB+cfC
         doScKB4ZR05TWFy63tGUtw7WEJT++jFiaL5RK/uTJivxZt9Asg9oshYUZG6vv6WMDZJa
         USxwjc19nT+/EqkJ5iqauH+wVm5XZPvMNP73jbkzIJI0IcBqbitbURW1k3M8VFvsTQvJ
         sMP0V7qMvR0Veo75X3L27oc1Qkhsr/LvclZJxJIIAbguuiWOjvwv1SCWnLdjHeH3ISzY
         EgHA==
X-Gm-Message-State: AOJu0YwU4RAWDLrucaWyqeVB9/xUtvr53Fmj2NDBgEegKD7AlFJmtVNc
	lS/VAHqypCetSDcM5JjnA3oZRB6m/N9CC5zeQ/zAOoZhBkqTyKh0MylT2FHAMAL88youvjhAuNY
	2sA2LsFeAHuLpkVVS2jcJeaguqay2KeF02V49SNunczushLDIcgiYbSTBQibzbj7coOgfHa6qf8
	N5JJ7G6woJvuhIVlgQN+M0BoI=
X-Google-Smtp-Source: AGHT+IGk8P+g3Nky7G3LvDTMmaXIQqyx5KcRTmLSnZLAUVXgBl74CjtJPqg5mc0nuUkEH/vJ4M6wl6DNcA==
X-Received: from wmrn17.prod.google.com ([2002:a05:600c:5011:b0:43d:abd:278f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e48:b0:43d:172:50b1
 with SMTP id 5b1f17b1804b1-442d6ddd1e1mr156690615e9.29.1747154095335; Tue, 13
 May 2025 09:34:55 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:28 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-8-tabba@google.com>
Subject: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map guest_memfd() pages
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This patch enables support for shared memory in guest_memfd, including
mapping that memory at the host userspace. This support is gated by the
configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
guest_memfd instance.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++
 include/linux/kvm_host.h        | 13 +++++
 include/uapi/linux/kvm.h        |  1 +
 virt/kvm/Kconfig                |  5 ++
 virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++
 5 files changed, 117 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 709cc2a7ba66..f72722949cae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
+
+/*
+ * CoCo VMs with hardware support that use guest_memfd only for backing private
+ * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
+ */
+#define kvm_arch_vm_supports_gmem_shared_mem(kvm)			\
+	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
+	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
+	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
 #else
 #define kvm_arch_supports_gmem(kvm) false
+#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae70e4e19700..2ec89c214978 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Returns true if this VM supports shared mem in guest_memfd.
+ *
+ * Arch code must define kvm_arch_vm_supports_gmem_shared_mem if support for
+ * guest_memfd is enabled.
+ */
+#if !defined(kvm_arch_vm_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
+static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6ae8ad8934b..9857022a0f0c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1UL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 559c93ad90be..f4e469a62a60 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_GMEM
+
+config KVM_GMEM_SHARED_MEM
+       select KVM_GMEM
+       bool
+       prompt "Enables in-place shared memory for guest_memfd"
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6db515833f61..8e6d1866b55e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+
+static bool kvm_gmem_supports_shared(struct inode *inode)
+{
+	uint64_t flags = (uint64_t)inode->i_private;
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
+	filemap_invalidate_lock_shared(inode->i_mapping);
+
+	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	if (IS_ERR(folio)) {
+		int err = PTR_ERR(folio);
+
+		if (err == -EAGAIN)
+			ret = VM_FAULT_RETRY;
+		else
+			ret = vmf_error(err);
+
+		goto out_filemap;
+	}
+
+	if (folio_test_hwpoison(folio)) {
+		ret = VM_FAULT_HWPOISON;
+		goto out_folio;
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
+out_filemap:
+	filemap_invalidate_unlock_shared(inode->i_mapping);
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
+#else
+#define kvm_gmem_mmap NULL
+#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
@@ -463,6 +544,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (kvm_arch_vm_supports_gmem_shared_mem(kvm))
+		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
@@ -501,6 +585,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	    offset + size > i_size_read(inode))
 		goto err;
 
+	if (kvm_gmem_supports_shared(inode) &&
+	    !kvm_arch_vm_supports_gmem_shared_mem(kvm))
+		goto err;
+
 	filemap_invalidate_lock(inode->i_mapping);
 
 	start = offset >> PAGE_SHIFT;
-- 
2.49.0.1045.g170613ef41-goog


