Return-Path: <kvm+bounces-44949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2581DAA5241
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E983D9E2BA9
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9EA1E25E8;
	Wed, 30 Apr 2025 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cLGGa/iN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3452690C0
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032236; cv=none; b=B8PZL8ZeqE1LjSBWYl9L469LDP+q+W580HwVzj1bLkSRaFJuHmBStsw7guqVoFzU2Vcy7ZSGFn0ny05cFsbJVnOXqyWS5eljokNImujLXW5aJOBGUnCZCcG/5eAP+5SvrZsPwhOYDDkn3Oo72AwPbj9dTvVeWHKlxJuv81xdJZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032236; c=relaxed/simple;
	bh=f0TRZ36e7B2SYKPTDH8A8xdr+i/oUNUNgdw4jZd9faM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o/M8PPRZwHvwhDmtN2lZbnUZ4iKJa3ryRPgXBsJDYxwCGqISTIk/ua6plHFwFihzfjxgNH1idWeAt8gvw04fSxOaxSdBtxJwonb1xOd+x3Gl92O3dE5qMNzgYEOTud4iMNNRRhRKbIsqs0IfkiyRyelWYPG3/hiBua6r3ks8EkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cLGGa/iN; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so100245e9.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032233; x=1746637033; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qguY8wkjSLxGc6Rnm9Mow0KqEpbeWasuLEBUoK8rap4=;
        b=cLGGa/iN/E90xEiQ7IxTY7FxmiCzo+fD+7FCGxY0ZZ+lNKPFHp2hGfUt1xJUSCpqlD
         ljLdglMZ6xo/qwSCuvSac8GHb4pi2l3JiTVq528oQsaEwQSpTMV144P1NUnEsBSL1dO+
         dwdFpb0e9qMboG7ZQOpt1xKYfF/eP0d2s2dlTLcP0h2xdX8yfmqFoUpPbWk7pA/yyiMU
         HggE6Yw5zmuW5Bhb/i2SUCjRiljtCXsL+S7IPxacjrI6nacForT4BkKKKypzD3LX7Dwa
         OT9tJN8wRyMQu+SJcf6Fol3ggVGEPGcPUh5OshZPKZjQoGSihkAGn3Z3lb4Sp+NOnO9P
         355g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032233; x=1746637033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qguY8wkjSLxGc6Rnm9Mow0KqEpbeWasuLEBUoK8rap4=;
        b=Dc7U8tlSW3OdW5XAU8a8PM2r6lblC/nsKgGh0eu8kWOaZjPQers2qFAXKAs3A+WdDr
         n46F1gDminONMOCF/WnA7VJatUGCYgKy+MKZyRfkorjOxvsXONsctuUOMcUXOaTi71vQ
         TcTcnftAwI+tiP6nBEVlzEA4BkLlA7T+Nb4tp2wFA07GTaT6cG0xwLBZsRlIlR5L4Fyz
         W0z1kewaH7gaEYzmHbQRInSQ219VB01n+INs+52EDCNDrk5TcQN4wax2lYglWl4hL/m2
         8TpSEe0M/z/uu/UfMQWwL3IJCq2Fm96nZbygpWVbx9C2MqJUGjJRybFlNG1/2f4+uhjO
         /97A==
X-Gm-Message-State: AOJu0YxgCfvwzS7Km1mQp6gVQq/F4Cd/bJXLRNCGR9Q6bhp4zsuoXFIU
	M1mR0/0IUZXRnHzUHGgtyLGd/iMoaYuGaJqIxyu1DArtMFTPEMD6RPvrgxsztMOguFyZ0EW+QEu
	2Xn7nYCGqUusBhLHzwHzXNhcxJssPxXrm8gZLONbm+HLBcKmkDg97H5SynIqdbeQ8QwLXnPab93
	EG0xPKQ8T1DvKV8sHviIkh7yM=
X-Google-Smtp-Source: AGHT+IH/bjSAFj0lsB85l/2YbEt4D9+ii8jCl4h9AfCzNBDyCxisD+HmPdIjUIeed8Koj3te+0fhdPZTrA==
X-Received: from wmbgw7.prod.google.com ([2002:a05:600c:8507:b0:440:5f8a:667c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:cce:b0:43d:8ea:8d80
 with SMTP id 5b1f17b1804b1-441b2634cd0mr34951035e9.5.1746032233508; Wed, 30
 Apr 2025 09:57:13 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:50 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-9-tabba@google.com>
Subject: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map guest_memfd() pages
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add support for mmap() and fault() for guest_memfd backed memory
in the host for VMs that support in-place conversion between
shared and private. To that end, this patch adds the ability to
check whether the VM type supports in-place conversion, and only
allows mapping its memory if that's the case.

This patch introduces the configuration option KVM_GMEM_SHARED_MEM,
which enables support for in-place shared memory.

It also introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
indicates that the host can create VMs that support shared memory.
Supporting shared memory implies that memory can be mapped when shared
with the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 15 ++++++-
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig         |  5 +++
 virt/kvm/guest_memfd.c   | 92 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  4 ++
 5 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9419fb99f7c2..f3af6bff3232 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -729,6 +729,17 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
+ * private memory is enabled and it supports in-place shared/private conversion.
+ */
+#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
+static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
@@ -2516,7 +2527,9 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
 static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
 {
-	/* For now, only private memory gets consumed from guest_memfd. */
+	if (kvm_arch_gmem_supports_shared_mem(kvm))
+		return true;
+
 	return kvm_mem_is_private(kvm, gfn);
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6ae8ad8934b..8bc8046c7f3a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -930,6 +930,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_GMEM_SHARED_MEM 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
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
index 6db515833f61..8bc8fc991d58 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,99 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+/*
+ * Returns true if the folio is shared with the host and the guest.
+ */
+static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
+{
+	struct kvm_gmem *gmem = file->private_data;
+
+	/* For now, VMs that support shared memory share all their memory. */
+	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
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
+	if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
+		ret = VM_FAULT_SIGBUS;
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
+	struct kvm_gmem *gmem = file->private_data;
+
+	if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
+		return -ENODEV;
+
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE)) {
+		return -EINVAL;
+	}
+
+	vm_flags_set(vma, VM_DONTDUMP);
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6289ea1685dd..c75d8e188eb7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4845,6 +4845,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_supports_gmem(kvm);
+#endif
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	case KVM_CAP_GMEM_SHARED_MEM:
+		return !kvm || kvm_arch_gmem_supports_shared_mem(kvm);
 #endif
 	default:
 		break;
-- 
2.49.0.901.g37484f566f-goog


