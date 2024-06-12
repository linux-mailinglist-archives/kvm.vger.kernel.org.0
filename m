Return-Path: <kvm+bounces-19503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77001905D1B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 22:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B7561C22E8E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 20:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8604B85654;
	Wed, 12 Jun 2024 20:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EWfrPZnM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE855C3E
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 20:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718225271; cv=none; b=ONq0B5EHemq04qB8FvDaLUa0iqM5O8OGQZO/6r0M4pirBqYhLXOWep5DyaOcjhQOWIDme8A17ExMn5iFcrHvTB+p0aalbFSUB4B5PdTL2OKs0w02oh7zqIsWn1dsbB8ZpIulSHkDkwcCP5f+QDSxz/yu0zg/2pySd2WgTpNxX9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718225271; c=relaxed/simple;
	bh=aC5PaSjQFR+x1s9oqkemFF89YR3d70O6ds2KXWq0yGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C6AQXXGY6llgp5h6XazS9uHhFoS9Dd0yD+Fn+rzxosLr1c4OA1WAuUvUuWTsnZDBrApUzj05X6HAO5Cx6wIpbW5ho1knNV64iq0BKnIQ7eZ9csVA49QBnODPR1zksDgJlC0ht8j/jrjOfuCHXKqjp3Fvzd2GecHnz0V6oy2FNfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EWfrPZnM; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfe71fc2ab1so485588276.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 13:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718225268; x=1718830068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=15xNRufoy8zQ0ly/BFY7+H/LjnHWUIf8CQqsanVt6QU=;
        b=EWfrPZnM3JZTkWFkiVNf3uQvHcmRhN4wFSzZg4GmwLeK6QJ4qx6DrqbaJ4Xixi3FJa
         /A/YuZYQsyImpdVA8MLTI+z8rp+c8U4Q7JLtk/FxSi9t6f4Ra3YbpTkjUReJN+g9vp3T
         x1sbYkcTKGnNmzij9kB0aJaS6A0jgHgG6G0FspmbG3abFwQZncvaS4pMR/1srs5FflCD
         zjS9HyeiWLQMk0Iu7FaPStGxSbfPvmgDb28enQlXSE9yqj7iyENsQ8ftS82uAW7lN7Fa
         MRqVrOtKrWtKdLB5iboQ3oHREzsgzi1BHw82CEHzA3BQACUv4ykM75pwao4gVsIKgMdO
         OKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718225268; x=1718830068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15xNRufoy8zQ0ly/BFY7+H/LjnHWUIf8CQqsanVt6QU=;
        b=AAGBc66eBJOAVFLuTzcOZW7Y/B00hceVBsIrDdP32r1rxEFxoPmWuVtt8gDsh2h+sb
         VtTf0WQhGz1dipz8HMkZDzOPztg3thVJ6xkxFI+A4Fqc/Kgwxc7fRvIqpEJ4GvJUTMXz
         ++FkAY+8jSVAj/klYpFo+QnOoE1KsMHtM6iRNxlEOIhD1rwWIm1a/Y9QUzRoB76GA1U/
         qNnRSJ3uHGRLWX+YOuB9LlF74idcfOlgiIPeLZ9cITjvJyQg8M/4fdlg7zwHZ3hfOxpH
         EZuf3khDr1WDSX2SsWSOBEHXbLhgnnG/d8/DmRobWrKHogZRaclqnl7yjAmekvAsmLsn
         zrKw==
X-Forwarded-Encrypted: i=1; AJvYcCW5G/xsjgyyCJWvbUBIBcMvIve54CSSF3zr1lBEzyQD2JqSu1nKu228omQhcleg1ZFsETg6/yCwp4nHjQTfnIA9Kv27
X-Gm-Message-State: AOJu0YxQgsIH55kVj5sOD8j+whqVkugnUsDtv2n535S8ZOY9O2++rBD9
	8d/dgq5Y333G4wzCBtdaVxLDIZ7H0w+ygKpA3uRksGiv9RzQqc8HLe2qDJxpNTo8I3tcsVUjGUu
	Tzw==
X-Google-Smtp-Source: AGHT+IFWA3DPmtvbwokGO6/4cy3yrfWAzwswtvxH000akBt4qO6CwDNwUoiUsaOPjGaCUrlzkGUbk8LJtck=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1544:b0:dfb:20e:2901 with SMTP id
 3f1490d57ef6-dfe6676c7cfmr707011276.6.1718225267795; Wed, 12 Jun 2024
 13:47:47 -0700 (PDT)
Date: Wed, 12 Jun 2024 13:47:46 -0700
In-Reply-To: <9477c21a-4b18-4539-9f82-11046e43063c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419085927.3648704-1-pbonzini@redhat.com> <20240419085927.3648704-4-pbonzini@redhat.com>
 <9477c21a-4b18-4539-9f82-11046e43063c@intel.com>
Message-ID: <ZmoJciFSN_SALA1s@google.com>
Subject: Re: [PATCH 3/6] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 22, 2024, Xiaoyao Li wrote:
> On 4/19/2024 4:59 PM, Paolo Bonzini wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Extract out __kvm_mmu_do_page_fault() from kvm_mmu_do_page_fault().  The
> > inner function is to initialize struct kvm_page_fault and to call the fault
> > handler, and the outer function handles updating stats and converting
> > return code.
> 
> I don't see how the outer function converts return code.
> 
> > KVM_PRE_FAULT_MEMORY will call the KVM page fault handler.
> 
> I assume it means the inner function will be used by KVM_PRE_FAULT_MEMORY.
> 
> > This patch makes the emulation_type always set irrelevant to the return
> > code.  kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault(),
> > and references the value only when PF_RET_EMULATE is returned.  Therefore,
> > this adjustment doesn't affect functionality.
> 
> This paragraph needs to be removed, I think. It's not true.

It's oddly worded, but I do think it's correct.  kvm_arch_async_page_ready()
doesn't pass emulation_type, and kvm_mmu_page_fault() bails early for all other
return values:

	if (r < 0)
		return r;
	if (r != RET_PF_EMULATE)
		return 1;

That said, this belongs in a separate patch (if it's actually necessary). 

And _that_ said, rather than add an inner version, what if we instead shuffle the
stats code?  pf_taken, pf_spurious, and pf_emulate should _only_ ever be bumped
by kvm_mmu_page_fault(), i.e. should only track page faults that actually happened
in the guest.  And so handling them in kvm_mmu_do_page_fault() doesn't make any
sense, because there should only ever be one caller that passes prefetch=false.

Compile tested only, and kvm_mmu_page_fault() is a bit ugly (but that's solvable),
but I think this would provide better separation of concerns.

--
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Jun 2024 12:51:38 -0700
Subject: [PATCH 1/2] KVM: x86/mmu: Bump pf_taken stat only in the "real" page
 fault handler

Account stat.pf_taken in kvm_mmu_page_fault(), i.e. the actual page fault
handler, instead of conditionally bumping it in kvm_mmu_do_page_fault().
The "real" page fault handler is the only path that should ever increment
the number of taken page faults, as all other paths that "do page fault"
are by definition not handling faults that occurred in the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 2 ++
 arch/x86/kvm/mmu/mmu_internal.h | 8 --------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f2c9580d9588..3461b8c4aba2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5928,6 +5928,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
+		vcpu->stat.pf_taken++;
+
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ce2fcd19ba6b..8efd31b3856b 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -318,14 +318,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
-	/*
-	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
-	 * guest perspective and have already been counted at the time of the
-	 * original fault.
-	 */
-	if (!prefetch)
-		vcpu->stat.pf_taken++;
-
 	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
 		r = kvm_tdp_page_fault(vcpu, &fault);
 	else

base-commit: b7bc82a015e237862837bd1300d6ba1f5cd17466
-- 
2.45.2.505.gda0bf45e8d-goog

From 1dc69d38a8d51c9d8ad833475938cb925f7ea4cf Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Jun 2024 12:59:06 -0700
Subject: [PATCH 2/2] KVM: x86/mmu: Account pf_{fixed,emulate,spurious} in
 callers of "do page fault"

Move the accounting of the result of kvm_mmu_do_page_fault() to its
callers, as only pf_fixed is common to guest page faults and async #PFs,
and upcoming support KVM_PRE_FAULT_MEMORY won't bump _any_ stats.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 19 ++++++++++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h | 13 -------------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3461b8c4aba2..56373577a197 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4291,7 +4291,16 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code, true, NULL);
+	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,
+				  true, NULL);
+
+	/*
+	 * Account fixed page faults, otherwise they'll never be counted, but
+	 * ignore stats for all other return times.  Page-ready "faults" aren't
+	 * truly spurious and never trigger emulation
+	 */
+	if (r == RET_PF_FIXED)
+		vcpu->stat.pf_fixed++;
 }
 
 static inline u8 kvm_max_level_for_order(int order)
@@ -5938,6 +5947,14 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 
 	if (r < 0)
 		return r;
+
+	if (r == RET_PF_FIXED)
+		vcpu->stat.pf_fixed++;
+	else if (r == RET_PF_EMULATE)
+		vcpu->stat.pf_emulate++;
+	else if (r == RET_PF_SPURIOUS)
+		vcpu->stat.pf_spurious++;
+
 	if (r != RET_PF_EMULATE)
 		return 1;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8efd31b3856b..444f55a5eed7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -337,19 +337,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
 
-	/*
-	 * Similar to above, prefetch faults aren't truly spurious, and the
-	 * async #PF path doesn't do emulation.  Do count faults that are fixed
-	 * by the async #PF handler though, otherwise they'll never be counted.
-	 */
-	if (r == RET_PF_FIXED)
-		vcpu->stat.pf_fixed++;
-	else if (prefetch)
-		;
-	else if (r == RET_PF_EMULATE)
-		vcpu->stat.pf_emulate++;
-	else if (r == RET_PF_SPURIOUS)
-		vcpu->stat.pf_spurious++;
 	return r;
 }
 
-- 

