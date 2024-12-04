Return-Path: <kvm+bounces-33073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C589E46A2
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 22:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77D34B3F0E3
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08B91C3C11;
	Wed,  4 Dec 2024 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JPNoCfaY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0DB1F5436
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339665; cv=none; b=pu/8xT4Vojzd4mhjQyTVs252c5aYKkXBv+RYbb0ic6NiavkJyK8chXTdPfCRVLTrLjNGIuyrivg3zImHVbu0N92sQam8p5Nk7kT/VeTwnh/hm2hodTfhRNz71ssRxuPaJSGtHFEBb7tO1qa/9UqtOK70mmu8VAtZ1K+pr9+fYCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339665; c=relaxed/simple;
	bh=7uKPJu5MZttnLGZHU4AcApt1HeYqG3NuIftXyYnBeQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hrA4Xk5IH0qKYB7vCDSHaK41CiiKulLpHq77XjlFyZZkCoZvZ8zJEUH4ReuA9cS2956/LagKLrImK3b0ajVqObyfe40hj4iCSlfXnOFZDDyH1vrbTAO3g0Tl6h+pQj0cW9EBcA2M2IEK7fAIZ2T33MIrtFblG2muHiKt9DWuf6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JPNoCfaY; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-7b68b264f71so15104685a.3
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339661; x=1733944461; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3LkXqlJAd4fQvrkyb/GIMYTRcu+OGHQVMPLjSgCJbVo=;
        b=JPNoCfaY5nuJ94PckOEx0Hov6Dil/1/XKbDK88WvHtYQ+sXLAShjjzstxZ8gtplxf8
         0WB/9hlsxv9yIrXYE/5PSiyy8mrGpIlWMsaoN1Y2xaojf3FQTYjSBWH5hhK5t6hMm3Ri
         yafWI5m+DVPPc9lLjVLrFkR4fcHKcWtjRndprEwkipUwvmJVUAdyHGi/k3d5sR35gKsc
         OiFCqGjYvYsdPAg6Xpj8jdJG8p2ZOSgoy4qG4gEWxRu55IlBoANsI3BnhprViMF6IGqH
         TDNuRJlfKqgNAKPOcDfC6kifvYOOpLpUz1E5tUyDPOe4OHjoJLXPszDFwhMVPwoowdRQ
         aP3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339661; x=1733944461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3LkXqlJAd4fQvrkyb/GIMYTRcu+OGHQVMPLjSgCJbVo=;
        b=Nk+kOyFeD/dIBx+EWnKhyAp7lT3+lI+RQHCbWeA6cpZrSLCGq7NpELpYraimH8WUw/
         PyDCr28odxvPos3TANyYCzlDDYo4Yjza4LXqYNvfiJLWq/XwlpfwayvYSTqSXNZ1HHoz
         ggXAAgf4K3uQtlyiAWeInzIlZy0Sm+BOMfpcevWqTWafX9lvyFoJDn+Y1skEjXqA7V/3
         yhfNRqwJKy7uH8wANL6t1P1RxB3MbfY03ZXCTzniqxMmoIiBc17DND3eqNgQohylyBxK
         7XtCmTl++7lbpIH9LRgee2me68GOyQL3UkEY3OMhe/T9ma9d4UNVa0nHyIGNxvGaUJ/x
         h19Q==
X-Forwarded-Encrypted: i=1; AJvYcCWzxxPaH0Cd/heBs3l+Pj/PN6p6DJlmgyAnVa+NRw0eI7jhwLB1UiE2Pjov85OX9Wx57Ro=@vger.kernel.org
X-Gm-Message-State: AOJu0YzImS488ScI61MhUdkNdBmvk9iUGAtnfurNTwfLlVKQ/kxMImkW
	4B300GD+7k4CUCnVwNLkzRZcBLdd8tu+xBGCKlp70qyyc2BmtetHcP1CLtM4zvEq8KX+xrfJWHe
	lkMWcESZXh59OGC1K/Q==
X-Google-Smtp-Source: AGHT+IG2YC7xA0GwWXk+cMxHq3A6sTNXchADXjRqs7ScJbz/ng/FU66WmJEiNslyAxyIF4C+tDiCnDtGEeEHeuoK
X-Received: from uah9.prod.google.com ([2002:a05:6130:5209:b0:856:f0b0:717])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:40c2:b0:7b6:6b07:e80d with SMTP id af79cd13be357-7b6abbb7350mr835946485a.57.1733339661300;
 Wed, 04 Dec 2024 11:14:21 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:41 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-7-jthoughton@google.com>
Subject: [PATCH v1 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Adhering to the requirements of KVM Userfault:

1. When it is toggled (either on or off), zap the second stage with
   kvm_arch_flush_shadow_memslot(). This is to (1) respect
   userfault-ness and (2) to reconstruct block mappings.
2. While KVM_MEM_USERFAULT is enabled, restrict new second-stage mappings
   to be PAGE_SIZE, just like when dirty logging is enabled.

Signed-off-by: James Houghton <jthoughton@google.com>
---
  I'm not 100% sure if kvm_arch_flush_shadow_memslot() is correct in
  this case (like if the host does not have S2FWB).
---
 arch/arm64/kvm/Kconfig |  1 +
 arch/arm64/kvm/mmu.c   | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..d89b4088b580 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select HAVE_KVM_USERFAULT
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a71fe6f6bd90..53cee0bacb75 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1482,7 +1482,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active) {
+	if (logging_active || kvm_memslot_userfault(memslot)) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1571,6 +1571,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	if (kvm_gfn_userfault(kvm, memslot, gfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn << PAGE_SHIFT,
+					      PAGE_SIZE, write_fault,
+					      exec_fault, false, true);
+		return -EFAULT;
+	}
+
 	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
 				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
@@ -2062,6 +2069,20 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 changed_flags = (new ? new->flags : 0) ^ (old ? old->flags : 0);
+
+	/*
+	 * If KVM_MEM_USERFAULT changed, drop all the stage-2 mappings so that
+	 * we can (1) respect userfault-ness or (2) create block mappings.
+	 */
+	if ((changed_flags & KVM_MEM_USERFAULT) && change == KVM_MR_FLAGS_ONLY)
+		kvm_arch_flush_shadow_memslot(kvm, old);
+
+	/*
+	 * Nothing left to do if not toggling dirty logging.
+	 */
+	if (!(changed_flags & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
 
 	/*
 	 * At this point memslot has been committed and there is an
-- 
2.47.0.338.g60cca15819-goog


