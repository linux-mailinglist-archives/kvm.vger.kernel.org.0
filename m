Return-Path: <kvm+bounces-8498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE6F84FFB4
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CFA0289A8B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A02C3613A;
	Fri,  9 Feb 2024 22:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OsOg8o9F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83663B19C
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517029; cv=none; b=c/6gBb+WK/TBJEwn2pdgoCL01490meVlu1RH9B8AwHzncFImtTQnBwfAMRgsQAbRHM2E8JOc+P7OX0GPGRctEC277jjLF6dFsQ3Qt9rx05tF+mjiRwaV4IdKK1XLa15alr5CJpL2jWwFso2d5pAighMiuNZmRDbpTEzj2V14hUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517029; c=relaxed/simple;
	bh=m+yWYZl+6lZDOPSuIdLV5f59M0wUnPDZJiBRg1Mk2Ys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R6zCFa8dJww8L49sRNOr/GQKlB70hdsdAoXEi22U7XCiylf5xe9MUwRzbziGP9yLTfY8NLbM28Ggjj7M6/GJSpccm5atRAgjV2JHCWZdfLwu/1d94aGwRFgo3yF3Ge9yY5hOUOFTmdfaxsp5RaEvkqbkLUqQm5IuKPl0Micm7hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OsOg8o9F; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso2291810276.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517027; x=1708121827; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mZnCItuDvbZkdQunBsA68aRkk/hge2O9/C7d+7lVbaA=;
        b=OsOg8o9FSAY+COwOunvTqVB6HEDwfvnuw8wuVq1CNyCzrkFAkyG2t6bPpkls2pIz02
         UjxPu9U/BKE6D4sHuQR1l0HJ7VxlDMatJtxZXvPKN0KkdiDUbLSjKBaUGVk3Nvx0LIPP
         X4JdP8Q0PW307h7lmZaUo7oSrHmmL3Rbl11K3Xm8PSiBE4MBl9InqIH0yCqP3fNleDvc
         cGZptsW2xIX5shNynInYQFwIYPPdLbGQfwUJAMQy6LFMjfdWSmCq9XshcrbYsKmck+Rc
         uthntkNCGsNAnhIV8wy8PdqUGL3mapKcnnTS5YRrU2cVclK2hJWgi66A43psmAAV2Cl+
         gKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517027; x=1708121827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZnCItuDvbZkdQunBsA68aRkk/hge2O9/C7d+7lVbaA=;
        b=FzAoEL8ePP1vEepVT69RkWpjRAy6g8i8x9+1LI7/hpSKjKewsaJvUgeY1IAoIygp8O
         d4e/HYXqwpnYhEegmNS8glF/q+cMnWpB+cBG5fgndMXnNFAczAq/HlGQ9btu335yccNM
         5IB6AZ/x1bxVjGCYXyF3N/vUs52WIZUxuIHbYwCHxngpoZ37ddYc4jpPRB8Wa0fihKLp
         mqWq3VJOeFGh6nGEWMOggAvJ2auJdhbvTux0d0rn9EAWlrFMG78qLlXHtTU1TUoqQ4kw
         qDGsnfgtCLPIamfq5stAU4H2Z1sbjU0KVDY3dibhbz5WaAvtidpDG5kOH0MvCR1wUYMF
         6rdQ==
X-Gm-Message-State: AOJu0YxA7b1zOGGGZO79i2T7BLIAsiLRXwl2sPhJ7ltMQT92AfJEtVux
	kMogMVulbFp16PWlm2T3tQwac7ZfVLC0aTsZNP5zUUOmomaB63Gc5PozcfIu4f5tXDgwTv36Y3A
	2xg==
X-Google-Smtp-Source: AGHT+IG7SXxnosYhngfLQSClff0kUEyE2VzBUkFxPSnvX7G5Tmbn2tgydx2K3G2DqXoPQ1DqOxXgJo1dEk4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9c08:0:b0:dc6:f21f:64ac with SMTP id
 c8-20020a259c08000000b00dc6f21f64acmr114763ybo.12.1707517026937; Fri, 09 Feb
 2024 14:17:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:16:59 -0800
In-Reply-To: <20240209221700.393189-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209221700.393189-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209221700.393189-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86: Move nEPT exit_qualification field from
 kvm_vcpu_arch to x86_exception
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the exit_qualification field that is used to track information about
in-flight nEPT violations from "struct kvm_vcpu_arch" to "x86_exception",
i.e. associate the information with the actual nEPT violation instead of
the vCPU.  To handle bits that are pulled from vmcs.EXIT_QUALIFICATION,
i.e. that are propagated from the "original" EPT violation VM-Exit, simply
grab them from the VMCS on-demand when injecting a nEPT Violation or a PML
Full VM-exit.

Aside from being ugly, having an exit_qualification field in kvm_vcpu_arch
is outright dangerous, e.g. see commit d7f0a00e438d ("KVM: VMX: Report
up-to-date exit qualification to userspace").

Opportunstically add a comment to call out that PML Full and EPT Violation
VM-Exits use the same bit to report NMI blocking information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/kvm_emulate.h      |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  | 14 +++++++-------
 arch/x86/kvm/vmx/nested.c       | 14 ++++++++++++--
 arch/x86/kvm/vmx/vmx.c          |  2 --
 5 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad5319a503f0..7ef4715d43d6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -993,9 +993,6 @@ struct kvm_vcpu_arch {
 
 	u64 msr_kvm_poll_control;
 
-	/* set at EPT violation at this point */
-	unsigned long exit_qualification;
-
 	/* pv related host specific info */
 	struct {
 		bool pv_unhalted;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 4351149484fb..b5791a66637e 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -26,6 +26,7 @@ struct x86_exception {
 	bool nested_page_fault;
 	u64 address; /* cr2 or nested page fault gpa */
 	u8 async_page_fault;
+	unsigned long exit_qualification;
 };
 
 /*
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4d4e98fe4f35..7a87097cb45b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -497,21 +497,21 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	 * The other bits are set to 0.
 	 */
 	if (!(errcode & PFERR_RSVD_MASK)) {
-		vcpu->arch.exit_qualification &= (EPT_VIOLATION_GVA_IS_VALID |
-						  EPT_VIOLATION_GVA_TRANSLATED);
+		walker->fault.exit_qualification = 0;
+
 		if (write_fault)
-			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_WRITE;
+			walker->fault.exit_qualification |= EPT_VIOLATION_ACC_WRITE;
 		if (user_fault)
-			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_READ;
+			walker->fault.exit_qualification |= EPT_VIOLATION_ACC_READ;
 		if (fetch_fault)
-			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_INSTR;
+			walker->fault.exit_qualification |= EPT_VIOLATION_ACC_INSTR;
 
 		/*
 		 * Note, pte_access holds the raw RWX bits from the EPTE, not
 		 * ACC_*_MASK flags!
 		 */
-		vcpu->arch.exit_qualification |= (pte_access & VMX_EPT_RWX_MASK) <<
-						 EPT_VIOLATION_RWX_SHIFT;
+		walker->fault.exit_qualification |= (pte_access & VMX_EPT_RWX_MASK) <<
+						     EPT_VIOLATION_RWX_SHIFT;
 	}
 #endif
 	walker->fault.address = addr;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1eebed84bb65..4d0561136e70 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -409,18 +409,28 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long exit_qualification;
 	u32 vm_exit_reason;
-	unsigned long exit_qualification = vcpu->arch.exit_qualification;
 
 	if (vmx->nested.pml_full) {
 		vm_exit_reason = EXIT_REASON_PML_FULL;
 		vmx->nested.pml_full = false;
-		exit_qualification &= INTR_INFO_UNBLOCK_NMI;
+
+		/*
+		 * PML Full and EPT Violation VM-Exits both use bit 12 to report
+		 * "NMI unblocking due to IRET", i.e. the bit can be propagated
+		 * as-is from the original EXIT_QUALIFICATION.
+		 */
+		exit_qualification = vmx_get_exit_qual(vcpu) & INTR_INFO_UNBLOCK_NMI;
 	} else {
 		if (fault->error_code & PFERR_RSVD_MASK) {
 			vm_exit_reason = EXIT_REASON_EPT_MISCONFIG;
 			exit_qualification = 0;
 		} else {
+			exit_qualification = fault->exit_qualification;
+			exit_qualification |= vmx_get_exit_qual(vcpu) &
+					      (EPT_VIOLATION_GVA_IS_VALID |
+					       EPT_VIOLATION_GVA_TRANSLATED);
 			vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
 		}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4e6625e0a9a..a24fba6b7741 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5771,8 +5771,6 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
-	vcpu->arch.exit_qualification = exit_qualification;
-
 	/*
 	 * Check that the GPA doesn't exceed physical memory limits, as that is
 	 * a guest page fault.  We have to emulate the instruction here, because
-- 
2.43.0.687.g38aa6559b0-goog


