Return-Path: <kvm+bounces-25592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43657966D47
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB8C31F24739
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE8F28387;
	Sat, 31 Aug 2024 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2+Irigdr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C462374C
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063359; cv=none; b=Nuo8gpo0I5DkEG/uOJ1NWOSk9W9/Bj3i21bfBPbLmbGfDaPf/LNNECMDLtansu+wqzf7Nrw7wrUz3BvTUrVlOcbXy9L1JTw59F0o/Gr27jqLVnn2RHXu6MMecXM674+wmy9cPAB+MilG6bWaC9Qeh70RJCnn0dMjus2Tm8YbmEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063359; c=relaxed/simple;
	bh=okOHlfjWRjUaRWCJVIfP0FRC3jaPnRUhU2Ljs35GXBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T7Aw9zkjvNZoQIBrzAjV5fftuOHHPm/pMx1INz+6TaTm7OvES9+Hj3cKglVdUDw7O2jgy3QAjK3ct4W0mlt6IwdDCibvSaHOJky9lt0Rh+GmVVVk9NKcgDLBpgU31cQpRHEtU609SPgh59Z6N5Icg1p4PB8rDQnU9Ln5eGelYEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2+Irigdr; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d4daca4a4bso9714527b3.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063357; x=1725668157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=20uh8Karf7HaNxExXLYXZVv2s3Odzh3UmkqbAlerb3Y=;
        b=2+Irigdr4bQIlzbvJeSbXDfosSil53gPtkW8kI4SodSmmNdyfHLwsU9F0nJNdZCafS
         VoEThpBorLnNYrx/JOkNpUlQssXapauDaudrOHW7T65sEaAwbKRJhLsw3oEHDp+F0g5N
         QnVxXbUf9yBGqhpEqWNNIHSZQK+P7GiRFCcuERb4vJjzZmgtwpG42eurHaUTZH15vyps
         KIKCEUgpMHrIMrJnYJ2v0RUwPHq5WIAnK2K7QA91CPSW+QNAu05mHVqlZbimWCh0ndky
         BUAQqEngDj0sS83iD5ycFmnIgCSvuybpR1/KjtzQ/wrYyRkA3YWibrV7LqIe4ITePh8f
         uOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063357; x=1725668157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20uh8Karf7HaNxExXLYXZVv2s3Odzh3UmkqbAlerb3Y=;
        b=wHByjnSLUyQQBeaxheu5CG1skkj5H8Mpcs0/AaMvgQXYX+Ml9nkyibOotweVEzaoDa
         4z+mzCsJusOjj2Agx3H9UlgwoSPzlii3h0/1UUzkNobVENmLIjvM+38jLHKlWzt1GXPF
         1ZYUAvNSoQAA8+23T1Ty/8Nyi+LJ/QmD2abhS8aRKe0xGtpfWnWXMYRtWCQ0ChBbb3hh
         hqbzo4lGF+OZz1D1Y+zPdpvbm7N9xHoNhhavgCW9byVQJNE/kGU/pIrM9VwySqLaGzBt
         5gQ1OEq1/PYwZi9e1V2FFXeZaD/5LTsBF1q5rwf8OQ9/UUQ0W6ofKnBbY/C+2E5SADJK
         WzFw==
X-Gm-Message-State: AOJu0Ywr1JyA2eWqAJUZ8SmyhcYxlNSOwt2NksZRrCRF9yoPxbvKvPpj
	W0TgCJkTby+sqULKS+r3L+vcJm7rjK+DB/sJ8tcviubc03JebV/jjyx86Yd9jM2N4T2rux6S64a
	o8Q==
X-Google-Smtp-Source: AGHT+IEtVf5oWPZeuNHrdt0XXTW0hZJaLnTQjVDPanMWRsjlMz9p2OLeYpGnhxaOIzgFrBVl4hdpYEQgBiU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8d02:0:b0:e1a:7eff:f66b with SMTP id
 3f1490d57ef6-e1a7efff840mr25477276.5.1725063356829; Fri, 30 Aug 2024 17:15:56
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:23 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-9-seanjc@google.com>
Subject: [PATCH v2 08/22] KVM: x86/mmu: Apply retry protection to "fast nTDP
 unprotect" path
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the anti-infinite-loop protection provided by last_retry_{eip,addr}
into kvm_mmu_write_protect_fault() so that it guards unprotect+retry that
never hits the emulator, as well as reexecute_instruction(), which is the
last ditch "might as well try it" logic that kicks in when emulation fails
on an instruction that faulted on a write-protected gfn.

Add a new helper, kvm_mmu_unprotect_gfn_and_retry(), to set the retry
fields and deduplicate other code (with more to come).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 39 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              | 27 +----------------------
 3 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 62d19403d63c..2c3f28331118 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2135,6 +2135,7 @@ int kvm_get_nr_pending_nmis(struct kvm_vcpu *vcpu);
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
+bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa);
 void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 			ulong roots_to_free);
 void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b5f80f38a95..c34c8bbd61c8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2713,6 +2713,22 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	return r;
 }
 
+bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
+{
+	gpa_t gpa = cr2_or_gpa;
+	bool r;
+
+	if (!vcpu->arch.mmu->root_role.direct)
+		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
+
+	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+	if (r) {
+		vcpu->arch.last_retry_eip = kvm_rip_read(vcpu);
+		vcpu->arch.last_retry_addr = cr2_or_gpa;
+	}
+	return r;
+}
+
 static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa;
@@ -5958,6 +5974,27 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 {
 	bool direct = vcpu->arch.mmu->root_role.direct;
 
+	/*
+	 * Do not try to unprotect and retry if the vCPU re-faulted on the same
+	 * RIP with the same address that was previously unprotected, as doing
+	 * so will likely put the vCPU into an infinite.  E.g. if the vCPU uses
+	 * a non-page-table modifying instruction on the PDE that points to the
+	 * instruction, then unprotecting the gfn will unmap the instruction's
+	 * code, i.e. make it impossible for the instruction to ever complete.
+	 */
+	if (vcpu->arch.last_retry_eip == kvm_rip_read(vcpu) &&
+	    vcpu->arch.last_retry_addr == cr2_or_gpa)
+		return RET_PF_EMULATE;
+
+	/*
+	 * Reset the unprotect+retry values that guard against infinite loops.
+	 * The values will be refreshed if KVM explicitly unprotects a gfn and
+	 * retries, in all other cases it's safe to retry in the future even if
+	 * the next page fault happens on the same RIP+address.
+	 */
+	vcpu->arch.last_retry_eip = 0;
+	vcpu->arch.last_retry_addr = 0;
+
 	/*
 	 * Before emulating the instruction, check to see if the access was due
 	 * to a read-only violation while the CPU was walking non-nested NPT
@@ -5988,7 +6025,7 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * format) with L2's page tables (EPT format).
 	 */
 	if (direct && is_write_to_guest_page_table(error_code) &&
-	    kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
+	    kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa))
 		return RET_PF_RETRY;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c84f57e1a888..862eed96cfd5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8928,27 +8928,13 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 			      gpa_t cr2_or_gpa,  int emulation_type)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	unsigned long last_retry_eip, last_retry_addr;
-	gpa_t gpa = cr2_or_gpa;
-
-	last_retry_eip = vcpu->arch.last_retry_eip;
-	last_retry_addr = vcpu->arch.last_retry_addr;
 
 	/*
 	 * If the emulation is caused by #PF and it is non-page_table
 	 * writing instruction, it means the VM-EXIT is caused by shadow
 	 * page protected, we can zap the shadow page and retry this
 	 * instruction directly.
-	 *
-	 * Note: if the guest uses a non-page-table modifying instruction
-	 * on the PDE that points to the instruction, then we will unmap
-	 * the instruction and go to an infinite loop. So, we cache the
-	 * last retried eip and the last fault address, if we meet the eip
-	 * and the address again, we can break out of the potential infinite
-	 * loop.
 	 */
-	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
-
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
@@ -8959,18 +8945,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (x86_page_table_writing_insn(ctxt))
 		return false;
 
-	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2_or_gpa)
-		return false;
-
-	if (!vcpu->arch.mmu->root_role.direct)
-		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
-
-	if (!kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
-		return false;
-
-	vcpu->arch.last_retry_eip = kvm_rip_read(vcpu);
-	vcpu->arch.last_retry_addr = cr2_or_gpa;
-	return true;
+	return kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa);
 }
 
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
-- 
2.46.0.469.g59c65b2a67-goog


