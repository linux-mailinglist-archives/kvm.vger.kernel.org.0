Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE9630E844
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhBDAGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbhBDACv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:51 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21816C061351
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:43 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id v13so808000qvm.10
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ngo4Ulx+Y4zNOoFYw+YT9FfKDadr2Ha0EmFigfRIUTY=;
        b=TnvAOi72CulyML4J/gF2okdzoQOWWKtPxRliwaThw8oHxMkWEci/gH9WJqwzK4ksF2
         p/EWL0Z3b7hrvMIIQMrn0kuiJrIQksgsASTUDTCAEqLYoRKnX1hiy6Xf6/rmkOOsE+ua
         5Tn2mVZVvzZAiZIr+WMKMggk5Qto9Zbd18d8/aIvWXTn2zFEkGB5xQN43hBNGvMuo7dI
         /te7785DtG3eHAd8OM8PWvrZEv7jb1Un5SIAyGvub66HPh8K9DIAnUX3xv+i3SVGCKKQ
         VHgCIQz1/mNlwRAXePAKHgCdfjnks4Hul1739qrfo+HHeM+kWHatHkS28A86Zm49qsgc
         MlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ngo4Ulx+Y4zNOoFYw+YT9FfKDadr2Ha0EmFigfRIUTY=;
        b=WF73PjtvkKL5Dxt0069YKfgIapoO+CESYnU0N7hLHtKZTVH8xK0Vt6UQaU2ztd4m1C
         PQORcZ7eSo1KtOYbP2oZEXYRigzU3sv8ZGkcibauvp876Z6Mikb7QcAHlfcIcm2I2OjI
         uY/xKxoR2yoo2mg1VyybzajOjvVyoB8F7tNY8YVBDDIpaT5XPPLtAkh5E/PnS+7njNgU
         fE38ctEPIuOjpTy5Tueu6Imzkry1Br/tKuAU7bGYhiTN5E/3VrL0ZTTCicNMNaiTexh0
         3j3EfOKhebb4h/mTTCaLg7xyDlccfvR8N6QcqAjVD2cManprvAbe1mPOOkaklblqOa1P
         UD2A==
X-Gm-Message-State: AOAM531t104sYDsNWNjggy3u1cIKAq/XD9OSAdVKrKkRgrQFGlxr6uaD
        41eMcq+WUD2pnYqvGeT1c1gKS5T0vcI=
X-Google-Smtp-Source: ABdhPJxP5fc8jRQVqOicTZftbOXqRAgoRGmROKvvw84X4EKuL0PW+BqQtVr5NcdD8FlmQtxinOnkSB5HhAQ=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:ad4:4348:: with SMTP id q8mr5415162qvs.36.1612396902309;
 Wed, 03 Feb 2021 16:01:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:12 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit regardless
 of vCPU mode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename cr3_lm_rsvd_bits to reserved_gpa_bits, and use it for all GPA
legality checks.  AMD's APM states:

  If the C-bit is an address bit, this bit is masked from the guest
  physical address when it is translated through the nested page tables.

Thus, any access that can conceivably be run through NPT should ignore
the C-bit when checking for validity.

For features that KVM emulates in software, e.g. MTRRs, there is no
clear direction in the APM for how the C-bit should be handled.  For
such cases, follow the SME behavior inasmuch as possible, since SEV is
is essentially a VM-specific variant of SME.  For SME, the APM states:

  In this case the upper physical address bits are treated as reserved
  when the feature is enabled except where otherwise indicated.

Collecting the various relavant SME snippets in the APM and cross-
referencing the omissions with Linux kernel code, this leaves MTTRs and
APIC_BASE as the only flows that KVM emulates that should _not_ ignore
the C-bit.

Note, this means the reserved bit checks in the page tables are
technically broken.  This will be remedied in a future patch.

Although the page table checks are technically broken, in practice, it's
all but guaranteed to be irrelevant.  NPT is required for SEV, i.e.
shadowing page tables isn't needed in the common case.  Theoretically,
the checks could be in play for nested NPT, but it's extremely unlikely
that anyone is running nested VMs on SEV, as doing so would require L1
to expose sensitive data to L0, e.g. the entire VMCB.  And if anyone is
running nested VMs, L0 can't read the guest's encrypted memory, i.e. L1
would need to put its NPT in shared memory, in which case the C-bit will
never be set.  Or, L1 could use shadow paging, but again, if L0 needs to
read page tables, e.g. to load PDPTRs, the memory can't be encrypted if
L1 has any expectation of L0 doing the right thing.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/cpuid.c            | 2 +-
 arch/x86/kvm/cpuid.h            | 2 +-
 arch/x86/kvm/svm/nested.c       | 2 +-
 arch/x86/kvm/svm/svm.c          | 2 +-
 arch/x86/kvm/x86.c              | 7 +++----
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 915f716e78e6..1653d49a66ff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -654,7 +654,7 @@ struct kvm_vcpu_arch {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
 
-	unsigned long cr3_lm_rsvd_bits;
+	u64 reserved_gpa_bits;
 	int maxphyaddr;
 	int max_tdp_level;
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 944f518ca91b..7bd1331c1bbc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -194,7 +194,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
-	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
+	vcpu->arch.reserved_gpa_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
 	/* Invoke the vendor callback only after the above state is updated. */
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index a9d55ab51e3c..f673f45bdf52 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -38,7 +38,7 @@ static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
-	return !(gpa >> cpuid_maxphyaddr(vcpu));
+	return !(gpa & vcpu->arch.reserved_gpa_bits);
 }
 
 static inline bool kvm_vcpu_is_illegal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ac662964cee5..add3cd4295e1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -241,7 +241,7 @@ static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
 	 */
 	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
 		if (!(save->cr4 & X86_CR4_PAE) || !(save->cr0 & X86_CR0_PE) ||
-		    (save->cr3 & vcpu->arch.cr3_lm_rsvd_bits))
+		    kvm_vcpu_is_illegal_gpa(vcpu, save->cr3))
 			return false;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f53e6377a933..50ad5a3bf880 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4079,7 +4079,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (sev_guest(vcpu->kvm)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
 		if (best)
-			vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
+			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
 	if (!kvm_vcpu_apicv_active(vcpu))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e6fbf2f574a6..1da7ed093650 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1082,8 +1082,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 0;
 	}
 
-	if (is_long_mode(vcpu) &&
-	    (cr3 & vcpu->arch.cr3_lm_rsvd_bits))
+	if (is_long_mode(vcpu) && kvm_vcpu_is_illegal_gpa(vcpu, cr3))
 		return 1;
 	else if (is_pae_paging(vcpu) &&
 		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
@@ -9712,7 +9711,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		 */
 		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
 			return false;
-		if (sregs->cr3 & vcpu->arch.cr3_lm_rsvd_bits)
+		if (kvm_vcpu_is_illegal_gpa(vcpu, sregs->cr3))
 			return false;
 	} else {
 		/*
@@ -10091,7 +10090,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
+	vcpu->arch.reserved_gpa_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 
-- 
2.30.0.365.g02bc693789-goog

