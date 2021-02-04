Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AAE30E843
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhBDAGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbhBDACw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:52 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DE0C061353
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:45 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id d194so1076611qke.3
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tcZGz/XctS2SK0DQJ0waWmDO5l1biFLI49kWF1s+1Nc=;
        b=XQtvLfosHf5vLuwF7V/crEvxxGWqSWGC6HVaB7OLInf979DgrVpIY2iaKEbR2Dkdq9
         MLstn2WG+7UWR7vax03RO88vq+ZSOLodxqLiOXmBNL4ypNWiQAkORgi28dbEhp4SQmJE
         tb01s6oiyRLEwfWV9QWc/23b3R2g7YSxDJ4a0/sRGgJ1xbUlDJs48oRkXCAhBZ/yMdkV
         p7/nixeYEGRBZnEOudWRQOuykit0BfFFBLe9BtTywXBMHO1ODuBkNr5yQtO94UO8wN2B
         6ExFX4rh0ksbuSU0fB75BV+lUaw+1IarBaHJcYFkPxLvk0O5kts69YzRmc3Bg/ZxYuwr
         CbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tcZGz/XctS2SK0DQJ0waWmDO5l1biFLI49kWF1s+1Nc=;
        b=d/r+xVaC3JZz3K++Jv7L7DrM7TQg6L2iqgEM8BcymIlLM59yfNl9qTD3xPtdqWcAiu
         +RQNdH/HH3obZ6TVE0dQRSYbPj3+bIH99hYmlgtjknsU4ARRIJJFUqmk4bAip7Z6iqT8
         ehepSW5bYwaljRPCaofEWgrGtv/Hw4b8eV0Q3KumajplT8MuikLtIaT5eBG8n3AMAkbB
         cojjZ9WrUmTzlH2IkegSI4RcBAbrHMq3WFX91PRNZS3jsuw72EtPA90yHH/ydIthzYBG
         dVoqgkR868LCO5xCfcv1PwJaLkE22XbhkZd8ly117dw3TyHPt59Aayg5zVEoNG8hXotO
         3ivA==
X-Gm-Message-State: AOAM53353zomVCECbPUPXqOTiN2FnlOcs/7EQi3Mwae+p0r9lcewf42S
        ygg/PeBtzZSL0STf4ZnsQTNQkxlmS3Q=
X-Google-Smtp-Source: ABdhPJzpYg7r7zJzlMBVnl/c5YIgFDUqh7JtC9IsnUMSxGbSjPOnKcKWYzZQWHovbMBLrajLTlfB4hte7L0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:a0c:b617:: with SMTP id f23mr5041685qve.44.1612396904641;
 Wed, 03 Feb 2021 16:01:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:13 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 08/12] KVM: x86: Use reserved_gpa_bits to calculate reserved
 PxE bits
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

Use reserved_gpa_bits, which accounts for exceptions to the maxphyaddr
rule, e.g. SEV's C-bit, for the page {table,directory,etc...} entry (PxE)
reserved bits checks.  For SEV, the C-bit is ignored by hardware when
walking pages tables, e.g. the APM states:

  Note that while the guest may choose to set the C-bit explicitly on
  instruction pages and page table addresses, the value of this bit is a
  don't-care in such situations as hardware always performs these as
  private accesses.

Such behavior is expected to hold true for other features that repurpose
GPA bits, e.g. KVM could theoretically emulate SME or MKTME, which both
allow non-zero repurposed bits in the page tables.  Conceptually, KVM
should apply reserved GPA checks universally, and any features that do
not adhere to the basic rule should be explicitly handled, i.e. if a GPA
bit is repurposed but not allowed in page tables for whatever reason.

Refactor __reset_rsvds_bits_mask() to take the pre-generated reserved
bits mask, and opportunistically clean up its code, e.g. to align lines
and comments.

Practically speaking, this is change is a likely a glorified nop given
the current KVM code base.  SEV's C-bit is the only repurposed GPA bit,
and KVM doesn't support shadowing encrypted page tables (which is
theoretically possible via SEV debug APIs).

Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   |  10 ++--
 arch/x86/kvm/mmu/mmu.c | 104 ++++++++++++++++++++---------------------
 arch/x86/kvm/x86.c     |   3 +-
 3 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7bd1331c1bbc..d313b1804278 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -188,16 +188,20 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_update_pv_runtime(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	kvm_mmu_reset_context(vcpu);
+	vcpu->arch.reserved_gpa_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
-	vcpu->arch.reserved_gpa_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
-
 	/* Invoke the vendor callback only after the above state is updated. */
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
+
+	/*
+	 * Except for the MMU, which needs to be reset after any vendor
+	 * specific adjustments to the reserved GPA bits.
+	 */
+	kvm_mmu_reset_context(vcpu);
 }
 
 static int is_efer_nx(void)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e8bfff9acd5e..d462db3bc742 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3985,20 +3985,27 @@ static inline bool is_last_gpte(struct kvm_mmu *mmu,
 static void
 __reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 			struct rsvd_bits_validate *rsvd_check,
-			int maxphyaddr, int level, bool nx, bool gbpages,
+			u64 pa_bits_rsvd, int level, bool nx, bool gbpages,
 			bool pse, bool amd)
 {
-	u64 exb_bit_rsvd = 0;
 	u64 gbpages_bit_rsvd = 0;
 	u64 nonleaf_bit8_rsvd = 0;
+	u64 high_bits_rsvd;
 
 	rsvd_check->bad_mt_xwr = 0;
 
-	if (!nx)
-		exb_bit_rsvd = rsvd_bits(63, 63);
 	if (!gbpages)
 		gbpages_bit_rsvd = rsvd_bits(7, 7);
 
+	if (level == PT32E_ROOT_LEVEL)
+		high_bits_rsvd = pa_bits_rsvd & rsvd_bits(0, 62);
+	else
+		high_bits_rsvd = pa_bits_rsvd & rsvd_bits(0, 51);
+
+	/* Note, NX doesn't exist in PDPTEs, this is handled below. */
+	if (!nx)
+		high_bits_rsvd |= rsvd_bits(63, 63);
+
 	/*
 	 * Non-leaf PML4Es and PDPEs reserve bit 8 (which would be the G bit for
 	 * leaf entries) on AMD CPUs only.
@@ -4027,45 +4034,39 @@ __reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 			rsvd_check->rsvd_bits_mask[1][1] = rsvd_bits(13, 21);
 		break;
 	case PT32E_ROOT_LEVEL:
-		rsvd_check->rsvd_bits_mask[0][2] =
-			rsvd_bits(maxphyaddr, 63) |
-			rsvd_bits(5, 8) | rsvd_bits(1, 2);	/* PDPTE */
-		rsvd_check->rsvd_bits_mask[0][1] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 62);	/* PDE */
-		rsvd_check->rsvd_bits_mask[0][0] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 62); 	/* PTE */
-		rsvd_check->rsvd_bits_mask[1][1] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 62) |
-			rsvd_bits(13, 20);		/* large page */
+		rsvd_check->rsvd_bits_mask[0][2] = rsvd_bits(63, 63) |
+						   high_bits_rsvd |
+						   rsvd_bits(5, 8) |
+						   rsvd_bits(1, 2);	/* PDPTE */
+		rsvd_check->rsvd_bits_mask[0][1] = high_bits_rsvd;	/* PDE */
+		rsvd_check->rsvd_bits_mask[0][0] = high_bits_rsvd;	/* PTE */
+		rsvd_check->rsvd_bits_mask[1][1] = high_bits_rsvd |
+						   rsvd_bits(13, 20);	/* large page */
 		rsvd_check->rsvd_bits_mask[1][0] =
 			rsvd_check->rsvd_bits_mask[0][0];
 		break;
 	case PT64_ROOT_5LEVEL:
-		rsvd_check->rsvd_bits_mask[0][4] = exb_bit_rsvd |
-			nonleaf_bit8_rsvd | rsvd_bits(7, 7) |
-			rsvd_bits(maxphyaddr, 51);
+		rsvd_check->rsvd_bits_mask[0][4] = high_bits_rsvd |
+						   nonleaf_bit8_rsvd |
+						   rsvd_bits(7, 7);
 		rsvd_check->rsvd_bits_mask[1][4] =
 			rsvd_check->rsvd_bits_mask[0][4];
 		fallthrough;
 	case PT64_ROOT_4LEVEL:
-		rsvd_check->rsvd_bits_mask[0][3] = exb_bit_rsvd |
-			nonleaf_bit8_rsvd | rsvd_bits(7, 7) |
-			rsvd_bits(maxphyaddr, 51);
-		rsvd_check->rsvd_bits_mask[0][2] = exb_bit_rsvd |
-			gbpages_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51);
-		rsvd_check->rsvd_bits_mask[0][1] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51);
-		rsvd_check->rsvd_bits_mask[0][0] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51);
+		rsvd_check->rsvd_bits_mask[0][3] = high_bits_rsvd |
+						   nonleaf_bit8_rsvd |
+						   rsvd_bits(7, 7);
+		rsvd_check->rsvd_bits_mask[0][2] = high_bits_rsvd |
+						   gbpages_bit_rsvd;
+		rsvd_check->rsvd_bits_mask[0][1] = high_bits_rsvd;
+		rsvd_check->rsvd_bits_mask[0][0] = high_bits_rsvd;
 		rsvd_check->rsvd_bits_mask[1][3] =
 			rsvd_check->rsvd_bits_mask[0][3];
-		rsvd_check->rsvd_bits_mask[1][2] = exb_bit_rsvd |
-			gbpages_bit_rsvd | rsvd_bits(maxphyaddr, 51) |
-			rsvd_bits(13, 29);
-		rsvd_check->rsvd_bits_mask[1][1] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51) |
-			rsvd_bits(13, 20);		/* large page */
+		rsvd_check->rsvd_bits_mask[1][2] = high_bits_rsvd |
+						   gbpages_bit_rsvd |
+						   rsvd_bits(13, 29);
+		rsvd_check->rsvd_bits_mask[1][1] = high_bits_rsvd |
+						   rsvd_bits(13, 20); /* large page */
 		rsvd_check->rsvd_bits_mask[1][0] =
 			rsvd_check->rsvd_bits_mask[0][0];
 		break;
@@ -4076,8 +4077,8 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu *context)
 {
 	__reset_rsvds_bits_mask(vcpu, &context->guest_rsvd_check,
-				cpuid_maxphyaddr(vcpu), context->root_level,
-				context->nx,
+				vcpu->arch.reserved_gpa_bits,
+				context->root_level, context->nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
 				is_pse(vcpu),
 				guest_cpuid_is_amd_or_hygon(vcpu));
@@ -4085,27 +4086,22 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 
 static void
 __reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
-			    int maxphyaddr, bool execonly)
+			    u64 pa_bits_rsvd, bool execonly)
 {
+	u64 high_bits_rsvd = pa_bits_rsvd & rsvd_bits(0, 51);
 	u64 bad_mt_xwr;
 
-	rsvd_check->rsvd_bits_mask[0][4] =
-		rsvd_bits(maxphyaddr, 51) | rsvd_bits(3, 7);
-	rsvd_check->rsvd_bits_mask[0][3] =
-		rsvd_bits(maxphyaddr, 51) | rsvd_bits(3, 7);
-	rsvd_check->rsvd_bits_mask[0][2] =
-		rsvd_bits(maxphyaddr, 51) | rsvd_bits(3, 6);
-	rsvd_check->rsvd_bits_mask[0][1] =
-		rsvd_bits(maxphyaddr, 51) | rsvd_bits(3, 6);
-	rsvd_check->rsvd_bits_mask[0][0] = rsvd_bits(maxphyaddr, 51);
+	rsvd_check->rsvd_bits_mask[0][4] = high_bits_rsvd | rsvd_bits(3, 7);
+	rsvd_check->rsvd_bits_mask[0][3] = high_bits_rsvd | rsvd_bits(3, 7);
+	rsvd_check->rsvd_bits_mask[0][2] = high_bits_rsvd | rsvd_bits(3, 6);
+	rsvd_check->rsvd_bits_mask[0][1] = high_bits_rsvd | rsvd_bits(3, 6);
+	rsvd_check->rsvd_bits_mask[0][0] = high_bits_rsvd;
 
 	/* large page */
 	rsvd_check->rsvd_bits_mask[1][4] = rsvd_check->rsvd_bits_mask[0][4];
 	rsvd_check->rsvd_bits_mask[1][3] = rsvd_check->rsvd_bits_mask[0][3];
-	rsvd_check->rsvd_bits_mask[1][2] =
-		rsvd_bits(maxphyaddr, 51) | rsvd_bits(12, 29);
-	rsvd_check->rsvd_bits_mask[1][1] =
-		rsvd_bits(maxphyaddr, 51) | rsvd_bits(12, 20);
+	rsvd_check->rsvd_bits_mask[1][2] = high_bits_rsvd | rsvd_bits(12, 29);
+	rsvd_check->rsvd_bits_mask[1][1] = high_bits_rsvd | rsvd_bits(12, 20);
 	rsvd_check->rsvd_bits_mask[1][0] = rsvd_check->rsvd_bits_mask[0][0];
 
 	bad_mt_xwr = 0xFFull << (2 * 8);	/* bits 3..5 must not be 2 */
@@ -4124,7 +4120,7 @@ static void reset_rsvds_bits_mask_ept(struct kvm_vcpu *vcpu,
 		struct kvm_mmu *context, bool execonly)
 {
 	__reset_rsvds_bits_mask_ept(&context->guest_rsvd_check,
-				    cpuid_maxphyaddr(vcpu), execonly);
+				    vcpu->arch.reserved_gpa_bits, execonly);
 }
 
 /*
@@ -4146,7 +4142,7 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 	 */
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(vcpu, shadow_zero_check,
-				shadow_phys_bits,
+				rsvd_bits(shadow_phys_bits, 63),
 				context->shadow_root_level, uses_nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
 				is_pse(vcpu), true);
@@ -4183,13 +4179,13 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(vcpu, shadow_zero_check,
-					shadow_phys_bits,
+					rsvd_bits(shadow_phys_bits, 63),
 					context->shadow_root_level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					true, true);
 	else
 		__reset_rsvds_bits_mask_ept(shadow_zero_check,
-					    shadow_phys_bits,
+					    rsvd_bits(shadow_phys_bits, 63),
 					    false);
 
 	if (!shadow_me_mask)
@@ -4210,7 +4206,7 @@ reset_ept_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 				struct kvm_mmu *context, bool execonly)
 {
 	__reset_rsvds_bits_mask_ept(&context->shadow_zero_check,
-				    shadow_phys_bits, execonly);
+				    rsvd_bits(shadow_phys_bits, 63), execonly);
 }
 
 #define BYTE_MASK(access) \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1da7ed093650..82a70511c0d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -761,8 +761,7 @@ static int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
 {
-	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63) | rsvd_bits(5, 8) |
-	       rsvd_bits(1, 2);
+	return vcpu->arch.reserved_gpa_bits | rsvd_bits(5, 8) | rsvd_bits(1, 2);
 }
 
 /*
-- 
2.30.0.365.g02bc693789-goog

