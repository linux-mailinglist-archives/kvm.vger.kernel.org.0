Return-Path: <kvm+bounces-23754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D9F94D6D0
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66338B220EA
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D611684BE;
	Fri,  9 Aug 2024 19:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cVCJjKqV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFE7166311
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230214; cv=none; b=L/qg9dO74rMAYPFiuANy9aUiXIpiJ+1EhNXRMGnS/zpwcimgB6tvAic+dyQ7rYOSGaqBhcefX8iVCtizVDMKqWIuzKIO26LHJ5MvhEPuSXjs16dFDWgftT8OBAxKNXOEaVuKxlsqn6BwE6xuDkxD/2A21i5Alh3MyX9XChdeP/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230214; c=relaxed/simple;
	bh=Tp+lr11Yh7ehyhJwxgWROxZWPiF2r5kHK9R10+ISb28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h4K+Hyrixkk6bmaO8KM63W8e1ug3N4MGVYB6gfptLeLArkW6o0b9niJJYkvJT7kdxPViCTtx6DALtG84FL83umUZroyjgscc/nO+x/5eTl6V4Nht6qqi97aj60LTdVe8f7/e3mHhX/UnL4MTEFbLV69tF0O2e0IgXOJomENb7mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cVCJjKqV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d1469f5e1so2727019b3a.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230212; x=1723835012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q+FRSzKgzmzlpy3KAiAZeqdbkMvFgdEpyfJ8A8CS9Hc=;
        b=cVCJjKqV6sMP4cfvdSeVUgBlASouMcV5bFJtif7ONxi77H4hsswecOFjsUi3WOBxtS
         Q6UbHyEmgiF21+KU9cpU0BRTHdFRnjMBsXgD0mLNL7cCZJhYCgV8BtSVIRJ0Q2wOppFA
         bHc6DCvB1RsOyqzkaHpVR5uv6k5K+X3nY2o/nWs5otxUZNgQQZPdxasbTMgQSfPuhvKr
         UHQ5BdPIOctKUfeKbGRp73m17EB52cstBgMo2465Q3oG5mpV4UBEPBAa4jXrKLg+68JN
         Q1hoV8SvT8yg3dX2W36RR4kK5IRfgY+DwTi/1damIU4kOxScq5+bvJ8k7rFvCTmYcVbw
         t11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230212; x=1723835012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+FRSzKgzmzlpy3KAiAZeqdbkMvFgdEpyfJ8A8CS9Hc=;
        b=Hdvr1AOyBkT9TAqgJ8vxLxr67hNk+0+U94mj0r4PA2Q9y3JALqvJGaaKGEUrDkMGbx
         ba3aMN0oKZ2w52U2hAqgXMgUVCQLfRNrRwjdxh6gQjAARmoSa5ISMhKSPrKpevyUzIPv
         AzsU5A9EkEBrY2WHCDuz+L+3JFh/yctmkT9RJXoO20JdU4qFfEx64vjx7xu+pw7yRdoF
         +Ja7qiJseA/cxqtWYKzFzsXkNxq7qskRWkk3+5Pbpr/e4eQI1O9ILq7xyOsyUMh3qmNY
         1LyosmK348/pDYOukrHRIY/lXv3AdZkwQ+zguKBI0bOMsSw3sVb5tpx9qR324Nx656fM
         k/Og==
X-Gm-Message-State: AOJu0YxC/9SJpkV6uhQGhZga7AzkgnO5F7AdOIB4ncxcFG4MMTVeFriM
	BysbZFt5O/ey3188JrqEZHjgs1BWtgb0PE+rqlwzmPyOAUga3udsAe5Ckjb4/s94V55hFF09Izn
	Nvg==
X-Google-Smtp-Source: AGHT+IHxQ+GgudCpTB9fCFij4ArNeNlFVa8zm1S935oIh/wd+bm22sj5O3d+Nthc3rB2/1PkOghLapua7zM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:138b:b0:70f:84b6:8634 with SMTP id
 d2e1a72fcca58-710dc2cfb49mr128985b3a.0.1723230212170; Fri, 09 Aug 2024
 12:03:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:00 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-4-seanjc@google.com>
Subject: [PATCH 03/22] KVM: x86/mmu: Trigger unprotect logic only on
 write-protection page faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Trigger KVM's various "unprotect gfn" paths if and only if the page fault
was a write to a write-protected gfn.  To do so, add a new page fault
return code, RET_PF_WRITE_PROTECTED, to explicitly and precisely track
such page faults.

If a page fault requires emulation for any MMIO (or any reason besides
write-protection), trying to unprotect the gfn is pointless and risks
putting the vCPU into an infinite loop.  E.g. KVM will put the vCPU into
an infinite loop if the vCPU manages to trigger MMIO on a page table walk.

Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 78 +++++++++++++++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h |  3 ++
 arch/x86/kvm/mmu/mmutrace.h     |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 +--
 5 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..e3aa04c498ea 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2914,10 +2914,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 		trace_kvm_mmu_set_spte(level, gfn, sptep);
 	}
 
-	if (wrprot) {
-		if (write_fault)
-			ret = RET_PF_EMULATE;
-	}
+	if (wrprot && write_fault)
+		ret = RET_PF_WRITE_PROTECTED;
 
 	if (flush)
 		kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, level);
@@ -4549,7 +4547,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_RETRY;
 
 	if (page_fault_handle_page_track(vcpu, fault))
-		return RET_PF_EMULATE;
+		return RET_PF_WRITE_PROTECTED;
 
 	r = fast_page_fault(vcpu, fault);
 	if (r != RET_PF_INVALID)
@@ -4642,7 +4640,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, fault))
-		return RET_PF_EMULATE;
+		return RET_PF_WRITE_PROTECTED;
 
 	r = fast_page_fault(vcpu, fault);
 	if (r != RET_PF_INVALID)
@@ -4726,6 +4724,9 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
 	case RET_PF_EMULATE:
 		return -ENOENT;
 
+	case RET_PF_WRITE_PROTECTED:
+		return -EPERM;
+
 	case RET_PF_RETRY:
 	case RET_PF_CONTINUE:
 	case RET_PF_INVALID:
@@ -5960,6 +5961,41 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
+static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+				       u64 error_code, int *emulation_type)
+{
+	bool direct = vcpu->arch.mmu->root_role.direct;
+
+	/*
+	 * Before emulating the instruction, check if the error code
+	 * was due to a RO violation while translating the guest page.
+	 * This can occur when using nested virtualization with nested
+	 * paging in both guests. If true, we simply unprotect the page
+	 * and resume the guest.
+	 */
+	if (direct &&
+	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
+		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
+		return RET_PF_FIXED;
+	}
+
+	/*
+	 * The gfn is write-protected, but if emulation fails we can still
+	 * optimistically try to just unprotect the page and let the processor
+	 * re-execute the instruction that caused the page fault.  Do not allow
+	 * retrying MMIO emulation, as it's not only pointless but could also
+	 * cause us to enter an infinite loop because the processor will keep
+	 * faulting on the non-existent MMIO address.  Retrying an instruction
+	 * from a nested guest is also pointless and dangerous as we are only
+	 * explicitly shadowing L1's page tables, i.e. unprotecting something
+	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
+	 */
+	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
+		*emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
+
+	return RET_PF_EMULATE;
+}
+
 int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
@@ -6005,6 +6041,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (r < 0)
 		return r;
 
+	if (r == RET_PF_WRITE_PROTECTED)
+		r = kvm_mmu_write_protect_fault(vcpu, cr2_or_gpa, error_code,
+						&emulation_type);
+
 	if (r == RET_PF_FIXED)
 		vcpu->stat.pf_fixed++;
 	else if (r == RET_PF_EMULATE)
@@ -6015,32 +6055,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (r != RET_PF_EMULATE)
 		return 1;
 
-	/*
-	 * Before emulating the instruction, check if the error code
-	 * was due to a RO violation while translating the guest page.
-	 * This can occur when using nested virtualization with nested
-	 * paging in both guests. If true, we simply unprotect the page
-	 * and resume the guest.
-	 */
-	if (vcpu->arch.mmu->root_role.direct &&
-	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
-		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
-		return 1;
-	}
-
-	/*
-	 * vcpu->arch.mmu.page_fault returned RET_PF_EMULATE, but we can still
-	 * optimistically try to just unprotect the page and let the processor
-	 * re-execute the instruction that caused the page fault.  Do not allow
-	 * retrying MMIO emulation, as it's not only pointless but could also
-	 * cause us to enter an infinite loop because the processor will keep
-	 * faulting on the non-existent MMIO address.  Retrying an instruction
-	 * from a nested guest is also pointless and dangerous as we are only
-	 * explicitly shadowing L1's page tables, i.e. unprotecting something
-	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
-	 */
-	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
-		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
 emulate:
 	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
 				       insn_len);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..50d2624111f8 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -258,6 +258,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
  * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
  * RET_PF_RETRY: let CPU fault again on the address.
  * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
+ * RET_PF_WRITE_PROTECTED: the gfn is write-protected, either unprotected the
+ *                         gfn and retry, or emulate the instruction directly.
  * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
  * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
@@ -274,6 +276,7 @@ enum {
 	RET_PF_CONTINUE = 0,
 	RET_PF_RETRY,
 	RET_PF_EMULATE,
+	RET_PF_WRITE_PROTECTED,
 	RET_PF_INVALID,
 	RET_PF_FIXED,
 	RET_PF_SPURIOUS,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 195d98bc8de8..f35a830ce469 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -57,6 +57,7 @@
 TRACE_DEFINE_ENUM(RET_PF_CONTINUE);
 TRACE_DEFINE_ENUM(RET_PF_RETRY);
 TRACE_DEFINE_ENUM(RET_PF_EMULATE);
+TRACE_DEFINE_ENUM(RET_PF_WRITE_PROTECTED);
 TRACE_DEFINE_ENUM(RET_PF_INVALID);
 TRACE_DEFINE_ENUM(RET_PF_FIXED);
 TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 69941cebb3a8..a722a3c96af9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -805,7 +805,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	if (page_fault_handle_page_track(vcpu, fault)) {
 		shadow_page_table_clear_flood(vcpu, fault->addr);
-		return RET_PF_EMULATE;
+		return RET_PF_WRITE_PROTECTED;
 	}
 
 	r = mmu_topup_memory_caches(vcpu, true);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c7dc49ee7388..8bf44ac9372f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1046,10 +1046,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	 * protected, emulation is needed. If the emulation was skipped,
 	 * the vCPU would have the same fault again.
 	 */
-	if (wrprot) {
-		if (fault->write)
-			ret = RET_PF_EMULATE;
-	}
+	if (wrprot && fault->write)
+		ret = RET_PF_WRITE_PROTECTED;
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
 	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
-- 
2.46.0.76.ge559c4bf1a-goog


