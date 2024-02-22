Return-Path: <kvm+bounces-9399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C43885FDB5
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3CB51C21479
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8597A1534F9;
	Thu, 22 Feb 2024 16:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="soxU7XzP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AED1534E3
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618260; cv=none; b=KX7sPk9D1oCJEScHxOdGHMTZChdM/zjwQZ5swDRH3gq56VbZkbRxHKtnUyR+F/hWpqwbd2K8LVHfDJVCEeMmbXl/0lsIbnE6BdOOpPnZviyuSvVtHxUUuMGs7M3j+NcWeq54CbD23JrW43T/QFTsa2XGGf6ylImZW9TrtWPSyD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618260; c=relaxed/simple;
	bh=us7/QCjxe2pxBhm9N56dE2zxrpgAV3//d0wRLBscLX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VvVuwiKjrUKs8vhAcFpLc9VbI10ho6iT9ywjubqNOF+EgCouAIDCrcC0tEK8nCFyxiF2FwLbENVFo0U8hwr4ouHMGHZIvdyM3tzdPF/JnGYnyUyu9T4FLXKOM+B00QleFfWR5Sukc5tacPOuFTHpfwYlkuyAJmpJMUtcL/d7ouM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=soxU7XzP; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dccc49ef73eso9747252276.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618258; x=1709223058; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yE4jGMdyyWeWXwgLR+PwPglC0gS24rScRzYQNSe4bRs=;
        b=soxU7XzP+FYP2AmkWYNlcE5Tk3bugMU9GFUK3lOYh3X6AVQzkXu/J7s9gcr7c/Nzyh
         zgQjFM02/QfftF++wcTjMT3VUfdYp3ZZszktNf51QZQbWPc4j2wVnfUxRRzNR/jqSSq8
         vs6ted1ExqIIaLbjHhPCRMdjwzAiJ6HTl56Ml4bokKRLKAHkgxniKijUNR1LyG8dzuI8
         hH1SpkC4wcOdmNNuaLYyS7qdmWvmu9bZZnzmyMhHlNYo0vAnus9y6WuzuNU+1QFP1DwC
         +HMJHIJNaUFq+BwsaiktSGt2m95gEvO97hZwzRBjUTb3WBUHWU5flGF9RlpGry1vak1X
         TVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618258; x=1709223058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yE4jGMdyyWeWXwgLR+PwPglC0gS24rScRzYQNSe4bRs=;
        b=Av/nwKTtHndO+2HsvGXE/1zuMzE19nZZkqPZN8hvrdvAIxL6Qm6/D7/GvbZHgDcbar
         wsso1nTLZUQ3fkdgc2jUpXLEVrAERwA1ttJwhl7HFm59kSXRXm34nXAd2ndTUxHmq2wF
         QSfRScrxrkazPiySjsN8xERR4V9XypojiB9UebE3/VkK8VV6hnsG/08wcko4Oh3JN/nm
         iU6pH8VcYoYOLczJ19iIfGUrhPe2Xi3s4KJ9p4d4qKWRaDNvENqRvw53QQZg0fM0n9hH
         5yBLeiADtUW/FZyt7txJ9yQdpj0vscSUkDs3751b7hNKiq1CNQexZBErjGHj8OnoMTeL
         bpLg==
X-Gm-Message-State: AOJu0YwXLZ3sEFb1B4PMZKes1yBiNBc7kw6zA6/eXxF0fkDwdtIyAvYA
	ONtWTSO+ZluX38TZpg1/IZuRqsDcy0v2bcZIQ8hiQ3PNBCZ+RR1AQdZRXxbHkR6Cwnbu4YmlJtr
	zFQEWCwpqF5fN/OagZKlKwQARIaVyRs3CGXm8PufRbEaEsobYQRExZ+/ZPSLydE8eoKtlbop9Qt
	0s+AhZugHjuAqbBY8t6dpLtKo=
X-Google-Smtp-Source: AGHT+IFQNtSID3YHaARgbjVSrCLasDYkP7ccSohNQiPNyCa1y1SXwVIunIxS8EvvGL64GrHD6XE4b9xaKA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:154f:b0:dc6:d890:1a97 with SMTP id
 r15-20020a056902154f00b00dc6d8901a97mr139007ybu.9.1708618257741; Thu, 22 Feb
 2024 08:10:57 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:24 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-4-tabba@google.com>
Subject: [RFC PATCH v1 03/26] KVM: Add restricted support for mapping guestmem
 by the host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Allow guestmem-backed memory to be mapped by the host if the
configuration option is enabled, and the (newly added) KVM memory
attribute KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE isn't set.

This new attribute is a kernel attribute, which cannot be
modified by userspace. This will be used in future patches so
that KVM can decide whether to allow the host to map guest memory
based on certain criteria, e.g., that the memory is shared with
the host.

This attribute has negative polarity (i.e., as opposed to being
an ALLOW attribute), to simplify the code, since it will usually
apply to memory marked as KVM_MEMORY_ATTRIBUTE_PRIVATE (i.e.,
already has an entry in the xarray). Its absence implies that
there are no restrictions for mapping that memory by the host.

An invariant that future patches will maintain is that memory
that is private for the guest, regardless whether it's marked
with the PRIVATE attribute, must always be NOT_MAPPABLE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 13 ++++++++
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig         |  4 +++
 virt/kvm/guest_memfd.c   | 68 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b96abeeb2b65..fad296baa84e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2402,4 +2402,17 @@ static inline int kvm_gmem_get_pfn_locked(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE
+static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn)
+{
+	return !(kvm_get_memory_attributes(kvm, gfn) &
+		 KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE);
+}
+#else
+static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn)
+{
+	return false;
+}
+#endif /* CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE */
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0862d6cc3e66..b8db8fb88bbe 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2227,6 +2227,7 @@ struct kvm_memory_attributes {
 
 #define KVM_MEMORY_ATTRIBUTES_KERNEL_SHIFT     (16)
 #define KVM_MEMORY_ATTRIBUTES_KERNEL_MASK      GENMASK(63, KVM_MEMORY_ATTRIBUTES_KERNEL_SHIFT)
+#define KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE      (1ULL << KVM_MEMORY_ATTRIBUTES_KERNEL_SHIFT)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 184dab4ee871..457019de9e6d 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -108,3 +108,7 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config KVM_GENERIC_PRIVATE_MEM_MAPPABLE
+       bool
+       depends on KVM_GENERIC_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7e3ea7a3f086..ca3a5d8b1fa7 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -248,7 +248,75 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
+#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE
+static bool kvm_gmem_isfaultable(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct kvm_gmem *gmem = vma->vm_file->private_data;
+	pgoff_t pgoff = vmf->pgoff;
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = gmem->kvm;
+	unsigned long index;
+
+	xa_for_each_range(&gmem->bindings, index, slot, pgoff, pgoff) {
+		pgoff_t base_gfn = slot->base_gfn;
+		pgoff_t gfn_pgoff = slot->gmem.pgoff;
+		pgoff_t gfn = base_gfn + max(gfn_pgoff, pgoff) - gfn_pgoff;
+
+		if (!kvm_gmem_is_mappable(kvm, gfn))
+			return false;
+	}
+
+	return true;
+}
+
+static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
+{
+	struct folio *folio;
+
+	folio = kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->pgoff);
+	if (!folio)
+		return VM_FAULT_SIGBUS;
+
+	/*
+	 * Check if the page is allowed to be faulted to the host, with the
+	 * folio lock held to ensure that the check and incrementing the page
+	 * count are protected by the same folio lock.
+	 */
+	if (!kvm_gmem_isfaultable(vmf)) {
+		folio_unlock(folio);
+		return VM_FAULT_SIGBUS;
+	}
+
+	vmf->page = folio_file_page(folio, vmf->pgoff);
+
+	return VM_FAULT_LOCKED;
+}
+
+static const struct vm_operations_struct kvm_gmem_vm_ops = {
+	.fault = kvm_gmem_fault,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	/* No support for private mappings to avoid COW.  */
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
+#endif /* CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE */
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
-- 
2.44.0.rc1.240.g4c46232300-goog


