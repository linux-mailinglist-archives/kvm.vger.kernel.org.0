Return-Path: <kvm+bounces-36872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4F5A222C5
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:23:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB59C188456D
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5881DFE31;
	Wed, 29 Jan 2025 17:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dBJ4wAoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F8B1DF739
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171412; cv=none; b=uqvVFceG4+VyBoG1QGeN0fcM1jiZs0hqFUf6n1GS4xCB9kiCkMpTT+uFx6PyO15x3BnV2g8Gw0VBiB0fpkFhm03qgCallPt6PLJ9ZSZuGG/VGyhgDiDzr2kEIbVDoYQwMRjuNG/u6XzKwkXgh3X3L+Z6ejAJX+KN2tVhc8mPr54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171412; c=relaxed/simple;
	bh=HVcVTHFmQT/fykHPy7CdMOtBYayqFUquU8jKqytzw4Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uOqMr/hgs8jrEbcefBpXTaJr9aOL/EZcIDbVnxfI9bXRZZniw5KEat4zHaxWPxgdApmfIuL2SnlB130J0MCwcGDOe+EgfeuUzP0ai2NKXcDrqwfdAsYChyyyCV7KvEo0E9Fk/KVXp/lclHhAUxdqjy3j1KdXonvYd5QVPVSc0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dBJ4wAoO; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4361fc2b2d6so40502865e9.3
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171409; x=1738776209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RoVkPwaMvkLCkrMEK45Vw1CTJ2upgTYFUQnx7UT1Wys=;
        b=dBJ4wAoOtUQlUpm4N6y6A8mVtP2tAU0pufjesNjrBn1mVLrhWQZd+szsMNLVNhZt6j
         fRIWCUt05Ru5QufRS5dAeX5bywedZRMCo0BGSGVGZ4lr5xvt20GYWw59fz/P/ztgIkff
         s7oGvDevzq6RfovhiuB0IVSbpiuygSRN0L1cY6+DKLKX25b5/M+A4QuOiYqFzyPPCGYC
         5YFnt+D5f/Ki7Zsj2w5GIQbyYkytioVYVxKRupy/JonF0jCcqV1Fm9bO5iqJcydaEj4V
         nrkUjbZnpsahRz7yO6mCIxqf9fz0N9J1S2Wl0hCFXvkm7DJg91BFpx4kLCkWNUOdv+Am
         BrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171409; x=1738776209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RoVkPwaMvkLCkrMEK45Vw1CTJ2upgTYFUQnx7UT1Wys=;
        b=IwOUAEzFqrrsaHaKpZNX8IzEfhEIJb3hJ9ys2NsfUa0T2Ov+pMt93kpAtDnI7xz7mw
         iB70xwHD4ndtmR7Yje10P5h8IrxwJyteuFEl/EmEvGQuEMEZvwSWaJo4nF44JNCqpBs2
         42QQ2yEFBLyqtSxNyNzW5rkLb4pGikJ8Nh3Vzu73SuiY+DBZ5/J5rDE+fiojLZ2B0eo8
         PQ/3lw+VFE0Hqyu5jeYQNS2Kf7PP8+9arqygBvETu5QmkpFTihHDr8Xv64T/47xzzXMG
         EaAh/qVG0SuW16AyF5n7lBOLcmHrseG95aVZva4iVcT821D7oM+zSa3TuVvNA3yxlbBp
         hO9w==
X-Gm-Message-State: AOJu0Yw5gXcHk++tq2eWP5lDRn0A4+eoFqrEl0zkvw/leYhbfgLvKh9c
	2gNlDBjXKGThtQTsfr2PrLA7O4rhCvWEuxLinAP9lz/V+TGT+5yWPr/hLEB+cLJlhpnayDe9mJ3
	NI4T2V0KdqSEGJhU8KaPXmaFUtAg/oKjIW/tKW99cEkr2lQBeoBOVmpzoT/S8if7N0Wmx4KgyUd
	OJ2+7DjkGUiA3mt+/moP6pk38=
X-Google-Smtp-Source: AGHT+IFhvEin4XE4wsGkRNdDKMzEHI3B5ItG8XmtbU1PM70tgZsQHYBr2xJu8rB4jweNCcCb7JB0XXISUQ==
X-Received: from wmbez5.prod.google.com ([2002:a05:600c:83c5:b0:434:f9da:44af])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:154c:b0:38a:39ad:3e2f
 with SMTP id ffacd0b85a97d-38c5194c9femr3444938f8f.2.1738171408672; Wed, 29
 Jan 2025 09:23:28 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:12 +0000
In-Reply-To: <20250129172320.950523-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-4-tabba@google.com>
Subject: [RFC PATCH v2 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add support for mmap() and fault() for guest_memfd backed memory
in the host for VMs that support in-place conversion between
shared and private (shared memory). To that end, this patch adds
the ability to check whether the VM type has that support, and
only allows mapping its memory if that's the case.

Additionally, this behavior is gated with a new configuration
option, CONFIG_KVM_GMEM_SHARED_MEM.

Signed-off-by: Fuad Tabba <tabba@google.com>

---

This patch series will allow shared memory support for software
VMs in x86. It will also introduce a similar VM type for arm64
and allow shared memory support for that. In the future, pKVM
will also support shared memory.
---
 include/linux/kvm_host.h | 11 ++++++
 virt/kvm/Kconfig         |  4 +++
 virt/kvm/guest_memfd.c   | 77 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3..408429f13bf4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -717,6 +717,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
+ * private memory is enabled and it supports in-place shared/private conversion.
+ */
+#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
+static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 54e959e7d68f..4e759e8020c5 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config KVM_GMEM_SHARED_MEM
+       select KVM_PRIVATE_MEM
+       bool
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 47a9f68f7b24..86441581c9ae 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -307,7 +307,84 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
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
+		ret = VM_FAULT_SIGBUS;
+		goto out_filemap;
+	}
+
+	if (folio_test_hwpoison(folio)) {
+		ret = VM_FAULT_HWPOISON;
+		goto out_folio;
+	}
+
+	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	/* No support for huge pages. */
+	if (WARN_ON_ONCE(folio_nr_pages(folio) > 1)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		folio_mark_uptodate(folio);
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
-- 
2.48.1.262.g85cc9f2d1e-goog


