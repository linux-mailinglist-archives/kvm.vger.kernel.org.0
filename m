Return-Path: <kvm+bounces-40842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7D8A5E345
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A62D17A3AD3
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304422580F3;
	Wed, 12 Mar 2025 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePF2pLMh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A267D25744D
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802317; cv=none; b=D4uXyYiHw4+ML47VRstscJFLqdwPeqppZ8K+N9+40D5ZiP09wUe7GFy/FZ3LJFEkmvFX8pkrW/TsbgELcxZGrR7xsjP5PPGBWpnzL4Q9WPzz7Qtl0qnlJVJpXZug/Nij3DNNJ2roJDJlA/HpvpXOXBJ8JKy6TkJQCvzZLtL8cz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802317; c=relaxed/simple;
	bh=0+R6PiRiVf6Qfgl6Xb/wXg3JYf8Soq67nwhFbPIQJKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JJvmA1ExL5GsNMtTObXtzYXidMtImrki1F+oejVPnerUofjEuLwgIPbxLQ+T4vFpDGnsix+5YkoD0TBfD2qUq7wCBWlBZIH5col+nTEeRLamOVFJOd23nRaN93Az/A7J45DBKxiicEDe5Nu2M7o86cOdRe0Kl75mEzKLE3oVaY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePF2pLMh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d00017e9dso395935e9.0
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 10:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741802314; x=1742407114; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ja4c56NjFxjN3VuYRxoRbDc+8encrsyBoZ8FkcBEBAk=;
        b=ePF2pLMhk5EeZh6bYqMFZ3hRjwDEF4A2JfQAulfbuWEGHZm8PHusiPO069B4u8fozz
         IxzZi7FIsAUCAGVA1/J6OSKHj3g1stwD9rxtWIiH0aUcFDhx/+Zp9QwtDnx+Nd7P4Rum
         OiBg2jDbca7kY5VyYNqScok9VlikAJnsjATPo8/pQeTsHqkgLgDcFxp+aBlVQVlifq00
         57nSruEduEB/wB29kF5Z6MumSttu+ld74TI6SvqhZYEFvjszBwelGQEfIW85uOH/f8xD
         Vn09kuVn1gsXOqx3kcOjXmqItiNi23tZuUz7/8aRiJrelLFZ/tJosAj8ufTYnj0Zksb5
         wCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741802314; x=1742407114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ja4c56NjFxjN3VuYRxoRbDc+8encrsyBoZ8FkcBEBAk=;
        b=bTtxkK0LokqUImmjOhY/v0nn2C8pLf2PL6qCyvIIuhw4WvyIlez8AX2P//JGOwnqUZ
         RqQBZxBPtGewouGl35gGNS0GRYCe35J85bG6jp+q2W0HS3cb5zODRd7vYxX46abXj9rY
         CZpMHBbzQD8LrngB/vYszQ/lfnE7Mw9tQiXPE9Eig9yzOy2PIs0WA84f7LDrQ4FoMkjX
         ZNZeI456CDZHn0p5/THo+2UFFs0FL57u5nGqaPOlfAICMI2l3IZ7FmUbbFLWg2G0COnQ
         eZTMkx8fP9PRrzZvYR5vB3QPPj8KoIUyqIPyyGGZ2cjvXk71Ib7NT/dp7EqxFN0paLRs
         AlyQ==
X-Gm-Message-State: AOJu0YxLBRD/2bXpjYiqFA8IaYxaASzHQpTyZ/ONcKK5CrMJUJXLT0qC
	PKKaUr6gshApHD2/Qytk2/4bO0Fe77LlfTv0SEBNwxV8lMdHCLcJug8EawQAtWje3uPznjKyx+M
	jHpLGfzbg6JnbNaguvQMUWFUTD+Ew31y/qJgB7uvlQAJQOoSt4H6K1lArgRJ6gqCBCqMIINsF15
	u1aukXI5Z5s5DU4YPmU3lZmws=
X-Google-Smtp-Source: AGHT+IH6LramvrAethqSEJ43co3nUgcdaI6Hl8zlyi/Cxvas2W6mO2vl5zZ/oeJPP/4J6sjTcPIlLBCdsQ==
X-Received: from wmbfl17.prod.google.com ([2002:a05:600c:b91:b0:43c:f5f7:f76a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1ca0:b0:43c:f5e4:895e
 with SMTP id 5b1f17b1804b1-43cf5e48a1dmr101433505e9.1.1741802313446; Wed, 12
 Mar 2025 10:58:33 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:58:17 +0000
In-Reply-To: <20250312175824.1809636-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250312175824.1809636-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250312175824.1809636-5-tabba@google.com>
Subject: [PATCH v6 04/10] KVM: guest_memfd: Allow host to map guest_memfd() pages
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

Add support for mmap() and fault() for guest_memfd backed memory
in the host for VMs that support in-place conversion between
shared and private. To that end, this patch adds the ability to
check whether the VM type supports in-place conversion, and only
allows mapping its memory if that's the case.

Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
indicates that the VM supports shared memory in guest_memfd, or
that the host can create VMs that support shared memory.
Supporting shared memory implies that memory can be mapped when
shared with the host.

This is controlled by the KVM_GMEM_SHARED_MEM configuration
option.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  11 +++++
 include/uapi/linux/kvm.h |   1 +
 virt/kvm/guest_memfd.c   | 102 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   4 ++
 4 files changed, 118 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3ad0719bfc4f..601bbcaa5e41 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
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
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b9..117937a895da 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -929,6 +929,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_GMEM_SHARED_MEM 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5fc414becae5..eea44e003ed1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -320,7 +320,109 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+static bool folio_offset_is_shared(const struct folio *folio, struct file *file, pgoff_t index)
+{
+	struct kvm_gmem *gmem = file->private_data;
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	/* For now, VMs that support shared memory share all their memory. */
+	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
+}
+
+static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
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
+	if (!folio_offset_is_shared(folio, vmf->vma->vm_file, vmf->pgoff)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	/*
+	 * Shared folios would not be marked as "guestmem" so far, and we only
+	 * expect shared folios at this point.
+	 */
+	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	/* No support for huge pages. */
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
+	.fault = kvm_gmem_fault,
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
+	file_accessed(file);
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
index ba0327e2d0d3..38f0f402ea46 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4830,6 +4830,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	case KVM_CAP_GMEM_SHARED_MEM:
+		return !kvm || kvm_arch_gmem_supports_shared_mem(kvm);
 #endif
 	default:
 		break;
-- 
2.49.0.rc0.332.g42c0ae87b1-goog


