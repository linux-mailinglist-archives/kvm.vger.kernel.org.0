Return-Path: <kvm+bounces-23759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE22394D6DA
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 859E628449F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89BD1990D7;
	Fri,  9 Aug 2024 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="edZOanDY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B036C19884C
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230224; cv=none; b=odDJ/X2M0gYMv3lFzBTG3RVcQtf1vCSG1Xrtvu+TusxXAaCRvrKMMn8Nn7GZr3b1UfUJm0zpxVt7fBXPVenradPfLkKArW5S+L76r3VYVlrmORcFoi3p5k0RRuUHK3b/SWUUsrRYjSn9IsGO6WZ5MBtIfjFQnyvCCMjwdiXV4oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230224; c=relaxed/simple;
	bh=/ZfmRIYXnF67feXuVaBMt5yLUsLq1ywXFEJMJjRy+jg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PRaVfvxFjj4mSgvE0L9QdzaHgUnTj5tbnwpTXDZ4vJKt+C9Po7hA5eyfAVWzuo7Y5xGmuobRslIhzpRrFL8uB01Eyz9bB6GmnXNU9xHFzVd6FBErOki94HaxQgHEzIDVvuRkmxrnOA25DdYy77NM8Ar27bbbY3HY4c77Di0KRko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=edZOanDY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb63abe6f7so2944889a91.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230222; x=1723835022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J1R1XfNeOqF5tGdf3uHftS07JnGIcD76EsjpdvLzH1c=;
        b=edZOanDYrrfy3P3xSjTabgH8QXAIQJxSOrzaUQy7T/y4on4vNzPk7EY3+KpGt/P4dJ
         BoIh+YuydrOZmYOmXw3mhv1WPLONP/D3Epfrrwr/UdxK/Y7KgqvggjWlJDQCliC/oixs
         do57R+CE5wtLl54hgzMBgepKvMUNS2VQZOvQKXoGQ1JCBgbP9D1caJR93eJCef+CoRfy
         gBzHF7gl0MiNzntcGTDhg44F4hKwqy7PEp+kvp7VezzNgxZDNYqK79Prl5e42S338/nn
         0NVDTYpG5A4HHdh0jwm5qNL/sItK6yum1/saN/5xofxFICBBplfsfHFDwAlmAA+ADuwJ
         vEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230222; x=1723835022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J1R1XfNeOqF5tGdf3uHftS07JnGIcD76EsjpdvLzH1c=;
        b=gjISYeHXqleTA8b7EC+m4lo/i6+NKxuHOgMED0KwUSb9tJOO6F6zsKcmdmOWpRRPWE
         OqJGtFYGluDlO82iSV2yfdl1zoRLldogBAzCxathPTxU239N9YgOCLWZOlefjRVUvhQG
         NigIWPKMIKloUmNmf7JT0YCn0PJ1jSiGUS+juqXtVWOxTjXVIGuGGcfbzkeU34Iw1vLB
         3Et7GAafXSoGa0/ZExtrE7t9HY6ScPPxxpoJthSbXKicGmKJOFIzSioPVhcR4oaSgzxv
         MuQ5AP/EKXmVFvpRkREe10hu4U12VIdr5cWnN8BQIPTOTxirI6wCMklTHxN7xK8RhuNp
         o5ww==
X-Gm-Message-State: AOJu0YzS0PvsGYQvOP7Q63gVy3FCXQksdC1PrCxN0xHDlH2s0iSl9WHp
	zfuUWZ6cK+/TUzLps7Enm223Zr6ZTBkhNEIh+b7V3FDdv2euRR+8g4zLyJO5gIsEWlt9AZ7xMRq
	EIw==
X-Google-Smtp-Source: AGHT+IHa9+G1paE0vB/FK76ehSmHJcxLcXIjNwSssE1mwAYWJibido2K20yHJjwk7mERqEVMW8GyutB6AoM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9cb:b0:2cf:6730:9342 with SMTP id
 98e67ed59e1d1-2d1e7fa3090mr13329a91.1.1723230221816; Fri, 09 Aug 2024
 12:03:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:05 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-9-seanjc@google.com>
Subject: [PATCH 08/22] KVM: x86/mmu: Apply retry protection to "fast nTDP
 unprotect" path
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
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
index 37c4a573e5fb..10b47c310ff9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2136,6 +2136,7 @@ int kvm_get_nr_pending_nmis(struct kvm_vcpu *vcpu);
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
+bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa);
 void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 			ulong roots_to_free);
 void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 95058ac4b78c..09a42dc1fe5a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2731,6 +2731,22 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
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
@@ -5966,6 +5982,27 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
 	 * Before emulating the instruction, check to see if the access may be
 	 * due to L1 accessing nested NPT/EPT entries used for L2, i.e. if the
@@ -5988,7 +6025,7 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 */
 	if (direct &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE &&
-	    kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
+	    kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa))
 		return RET_PF_FIXED;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c3493ffce0b..5377ca55161a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8934,27 +8934,13 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
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
 
@@ -8965,18 +8951,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
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
2.46.0.76.ge559c4bf1a-goog


