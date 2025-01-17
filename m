Return-Path: <kvm+bounces-35815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7435A15451
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4CDD3A6A8A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8721A239F;
	Fri, 17 Jan 2025 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nXWlJ6Vk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDC919F464
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131424; cv=none; b=e/l79LZQtdOaaU4xk0TiPDWCNiFBSA5bSeEE4kQcc/Kw7RoeboMYMhFholq1+J8T97fm7evSsbndTAysf9NEjgRtZxm9Ylvyha4X5TR4IxoXi/T1VPejXFGrvoO8hcvgy13pf80KftkLoa+BTwUEBl8vUcjZF1hWmHu5moa50xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131424; c=relaxed/simple;
	bh=Tl0nJPPYuN0KRI0CU4MgAmSjC5la+BBbp2bCwXMtbdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RA+2m+800YSNPtEgmhYrYOUOQd2dAeZNGEPGImj9yb9peEZ+GpHurLt8jgOvLDIeTXAgDgOHKxMe0RVmu00udLZGJN1PkmXc5qV2yt6hXfj2h3y0ziRKSYOz/UUZY+hS06987DrYynjrkTXoZ6Sr7gFhno1B9nkw/CuIrX5gsz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nXWlJ6Vk; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43624b08181so12023325e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737131421; x=1737736221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OBxaOc1Oq/7r5hpyeIybyfEKVewLBSFq8w5fQigelgs=;
        b=nXWlJ6VkSi74SiJXSRLuSdDCo3s7B5hgHOTmI28iJ4R4V9J1VqYQOFiQj0yqQ14jH/
         Ilehpo7esHjJO5fWx3IoVjBnO44Crt8i7NvCxTAfCw18PSUD3YFndQQK6a4RKawsqzn7
         FheKA/Y5YgrN1E5/rQjFIEFe1CFQswmjUhhtckB8S1NeUw9oDDU0Si3ct0WFkxiuYjFc
         ScGo2bbLddJbYOeFiw3tgCNVAu1PKcCHWCZiFzmUY3DI8lrmg2zNREG9nOJwQq8ffOL7
         KNBToCNy8snCsVrR0k3avk2kZ3TZ6b+cvuBIJFads8qtUoa/oI+IftUMDKRzvtobQx4R
         B1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131421; x=1737736221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OBxaOc1Oq/7r5hpyeIybyfEKVewLBSFq8w5fQigelgs=;
        b=YO0Tma9lZmKLmvaVxeruycpeJoYmBzZlVfKN2TrrrqgaV0B5sw2ep6v/1Pe0bywP/k
         hJpI1AOdhPTLFxW69CSKDj+pdbbXhBtCdO7polN/a29e6/xmQVZAZVP9aIre2YGj29BQ
         ps/uQkcNflFaEilgViqAziLh0nHSqTYD34CV769Fjl5G+d/QkgIKc45w/zJp8ZxfLbK3
         MfnwwwsYNrBrULoDBPkpj2t6x7s4d6ko32yMCau6LZxoH8bEaU25in1kv/FVFEqzTmpM
         fKrgJrvgWRGNdapDC9bzr8ys1OaqH2tqUpOCStGSOUbLiRpbntdQK9SUmbvpPmR2GxUL
         Om2A==
X-Gm-Message-State: AOJu0Yzds15nZsv+pWr8kr5Xy5DobWkmt8A68ZzVhhH3ickc+rnV0EV2
	BW3fsW00SV5TP+ok/S5Djbb+aJZ/Uz6QA2U5szBcbzBUmL6Dz3rgZ4J1fXWl5NK1tMxW/XofjXa
	TP/fzUQ2Geru5OyHChPtIsZXMchFRlNTmT42m4RNBQm3H1xFpEGlhdjA+nJoAWBQzvCa5O7/Hd5
	tZlMSK2sfQXL9sJXVUhdjKYUw=
X-Google-Smtp-Source: AGHT+IFkVUsgGxCt8u55ieXPYflUnbcSMN6hxhrnCXAB/29entNP9EJfjs2xWohE/JZhqpVEKXf+xlIxAw==
X-Received: from wmqe20.prod.google.com ([2002:a05:600c:4e54:b0:434:f350:9fc])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8712:b0:436:1b0b:2633
 with SMTP id 5b1f17b1804b1-438918d9008mr33597535e9.9.1737131420833; Fri, 17
 Jan 2025 08:30:20 -0800 (PST)
Date: Fri, 17 Jan 2025 16:29:54 +0000
In-Reply-To: <20250117163001.2326672-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117163001.2326672-9-tabba@google.com>
Subject: [RFC PATCH v5 08/15] KVM: guest_memfd: Add guest_memfd support to kvm_(read|/write)_guest_page()
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

Make kvm_(read|/write)_guest_page() capable of accessing guest
memory for slots that don't have a userspace address, but only if
the memory is mappable, which also indicates that it is
accessible by the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/kvm_main.c | 133 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 114 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fffff01cebe7..53692feb6213 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3184,23 +3184,110 @@ int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
 	return r;
 }
 
+static int __kvm_read_guest_memfd_page(struct kvm *kvm,
+				       struct kvm_memory_slot *slot,
+				       gfn_t gfn, void *data, int offset,
+				       int len)
+{
+	struct page *page;
+	u64 pfn;
+	int r;
+
+	/*
+	 * Holds the folio lock until after checking whether it can be faulted
+	 * in, to avoid races with paths that change a folio's mappability.
+	 */
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, &page, NULL);
+	if (r)
+		return r;
+
+	if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
+		r = -EPERM;
+		goto unlock;
+	}
+	memcpy(data, page_address(page) + offset, len);
+unlock:
+	unlock_page(page);
+	if (r)
+		put_page(page);
+	else
+		kvm_release_page_clean(page);
+
+	return r;
+}
+
+static int __kvm_write_guest_memfd_page(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					gfn_t gfn, const void *data,
+					int offset, int len)
+{
+	struct page *page;
+	u64 pfn;
+	int r;
+
+	/*
+	 * Holds the folio lock until after checking whether it can be faulted
+	 * in, to avoid races with paths that change a folio's mappability.
+	 */
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, &page, NULL);
+	if (r)
+		return r;
+
+	if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
+		r = -EPERM;
+		goto unlock;
+	}
+	memcpy(page_address(page) + offset, data, len);
+unlock:
+	unlock_page(page);
+	if (r)
+		put_page(page);
+	else
+		kvm_release_page_dirty(page);
+
+	return r;
+}
+#else
+static int __kvm_read_guest_memfd_page(struct kvm *kvm,
+				       struct kvm_memory_slot *slot,
+				       gfn_t gfn, void *data, int offset,
+				       int len)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
+
+static int __kvm_write_guest_memfd_page(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					gfn_t gfn, const void *data,
+					int offset, int len)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_GMEM_MAPPABLE */
 
 /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+
+static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t gfn, void *data, int offset, int len)
 {
-	int r;
 	unsigned long addr;
 
 	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
 		return -EFAULT;
 
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
+	    kvm_slot_can_be_private(slot) &&
+	    !slot->userspace_addr) {
+		return __kvm_read_guest_memfd_page(kvm, slot, gfn, data,
+						   offset, len);
+	}
+
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_from_user(data, (void __user *)addr + offset, len);
-	if (r)
+	if (__copy_from_user(data, (void __user *)addr + offset, len))
 		return -EFAULT;
 	return 0;
 }
@@ -3210,7 +3297,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -3219,7 +3306,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -3296,22 +3383,30 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
-				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  const void *data, int offset, int len)
 {
-	int r;
-	unsigned long addr;
-
 	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
 		return -EFAULT;
 
-	addr = gfn_to_hva_memslot(memslot, gfn);
-	if (kvm_is_error_hva(addr))
-		return -EFAULT;
-	r = __copy_to_user((void __user *)addr + offset, data, len);
-	if (r)
-		return -EFAULT;
-	mark_page_dirty_in_slot(kvm, memslot, gfn);
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
+	    kvm_slot_can_be_private(slot) &&
+	    !slot->userspace_addr) {
+		int r = __kvm_write_guest_memfd_page(kvm, slot, gfn, data,
+						     offset, len);
+
+		if (r)
+			return r;
+	} else {
+		unsigned long addr = gfn_to_hva_memslot(slot, gfn);
+
+		if (kvm_is_error_hva(addr))
+			return -EFAULT;
+		if (__copy_to_user((void __user *)addr + offset, data, len))
+			return -EFAULT;
+	}
+
+	mark_page_dirty_in_slot(kvm, slot, gfn);
 	return 0;
 }
 
-- 
2.48.0.rc2.279.g1de40edade-goog


