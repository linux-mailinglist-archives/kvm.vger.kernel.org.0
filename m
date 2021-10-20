Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29B434B76
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhJTMqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhJTMqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:46:51 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0985C061746;
        Wed, 20 Oct 2021 05:44:36 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id DC791344;
        Wed, 20 Oct 2021 14:44:32 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v5 1/6] KVM: SVM: Get rid of set_ghcb_msr() and *ghcb_msr_bits() functions
Date:   Wed, 20 Oct 2021 14:44:11 +0200
Message-Id: <20211020124416.24523-2-joro@8bytes.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020124416.24523-1-joro@8bytes.org>
References: <20211020124416.24523-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Replace the get_ghcb_msr_bits() function with macros and open code the
GHCB MSR setters with hypercall specific helper macros and functions.
This will avoid preserving any previous bits in the GHCB-MSR and
improves code readability.

Also get rid of the set_ghcb_msr() function and open-code it at its
call-sites for better code readability.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/sev-common.h |  9 +++++
 arch/x86/kvm/svm/sev.c            | 56 +++++++++++--------------------
 2 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 2cef6c5a52c2..8540972cad04 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -50,6 +50,10 @@
 		(GHCB_MSR_CPUID_REQ | \
 		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
 		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
+#define GHCB_MSR_CPUID_FN(msr)		\
+	(((msr) >> GHCB_MSR_CPUID_FUNC_POS) & GHCB_MSR_CPUID_FUNC_MASK)
+#define GHCB_MSR_CPUID_REG(msr)		\
+	(((msr) >> GHCB_MSR_CPUID_REG_POS) & GHCB_MSR_CPUID_REG_MASK)
 
 /* AP Reset Hold */
 #define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
@@ -67,6 +71,11 @@
 #define GHCB_SEV_TERM_REASON(reason_set, reason_val)						  \
 	(((((u64)reason_set) &  GHCB_MSR_TERM_REASON_SET_MASK) << GHCB_MSR_TERM_REASON_SET_POS) | \
 	((((u64)reason_val) & GHCB_MSR_TERM_REASON_MASK) << GHCB_MSR_TERM_REASON_POS))
+#define GHCB_MSR_TERM_REASON_SET(msr)	\
+	(((msr) >> GHCB_MSR_TERM_REASON_SET_POS) & GHCB_MSR_TERM_REASON_SET_MASK)
+#define GHCB_MSR_TERM_REASON(msr)	\
+	(((msr) >> GHCB_MSR_TERM_REASON_POS) & GHCB_MSR_TERM_REASON_MASK)
+
 
 #define GHCB_SEV_ES_REASON_GENERAL_REQUEST	0
 #define GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED	1
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3e2769855e51..2e3ecab6f1c8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2378,21 +2378,15 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return true;
 }
 
-static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
-			      unsigned int pos)
+static u64 ghcb_msr_cpuid_resp(u64 reg, u64 value)
 {
-	svm->vmcb->control.ghcb_gpa &= ~(mask << pos);
-	svm->vmcb->control.ghcb_gpa |= (value & mask) << pos;
-}
+	u64 msr;
 
-static u64 get_ghcb_msr_bits(struct vcpu_svm *svm, u64 mask, unsigned int pos)
-{
-	return (svm->vmcb->control.ghcb_gpa >> pos) & mask;
-}
+	msr  = GHCB_MSR_CPUID_RESP;
+	msr |= (reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS;
+	msr |= (value & GHCB_MSR_CPUID_VALUE_MASK) << GHCB_MSR_CPUID_VALUE_POS;
 
-static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
-{
-	svm->vmcb->control.ghcb_gpa = value;
+	return msr;
 }
 
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
@@ -2409,16 +2403,14 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
-		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
-						    GHCB_VERSION_MIN,
-						    sev_enc_bit));
+		svm->vmcb->control.ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+								GHCB_VERSION_MIN,
+								sev_enc_bit);
 		break;
 	case GHCB_MSR_CPUID_REQ: {
 		u64 cpuid_fn, cpuid_reg, cpuid_value;
 
-		cpuid_fn = get_ghcb_msr_bits(svm,
-					     GHCB_MSR_CPUID_FUNC_MASK,
-					     GHCB_MSR_CPUID_FUNC_POS);
+		cpuid_fn = GHCB_MSR_CPUID_FN(control->ghcb_gpa);
 
 		/* Initialize the registers needed by the CPUID intercept */
 		vcpu->arch.regs[VCPU_REGS_RAX] = cpuid_fn;
@@ -2430,9 +2422,8 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 			break;
 		}
 
-		cpuid_reg = get_ghcb_msr_bits(svm,
-					      GHCB_MSR_CPUID_REG_MASK,
-					      GHCB_MSR_CPUID_REG_POS);
+		cpuid_reg = GHCB_MSR_CPUID_REG(control->ghcb_gpa);
+
 		if (cpuid_reg == 0)
 			cpuid_value = vcpu->arch.regs[VCPU_REGS_RAX];
 		else if (cpuid_reg == 1)
@@ -2442,26 +2433,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		else
 			cpuid_value = vcpu->arch.regs[VCPU_REGS_RDX];
 
-		set_ghcb_msr_bits(svm, cpuid_value,
-				  GHCB_MSR_CPUID_VALUE_MASK,
-				  GHCB_MSR_CPUID_VALUE_POS);
+		svm->vmcb->control.ghcb_gpa = ghcb_msr_cpuid_resp(cpuid_reg, cpuid_value);
 
-		set_ghcb_msr_bits(svm, GHCB_MSR_CPUID_RESP,
-				  GHCB_MSR_INFO_MASK,
-				  GHCB_MSR_INFO_POS);
 		break;
 	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
-		reason_set = get_ghcb_msr_bits(svm,
-					       GHCB_MSR_TERM_REASON_SET_MASK,
-					       GHCB_MSR_TERM_REASON_SET_POS);
-		reason_code = get_ghcb_msr_bits(svm,
-						GHCB_MSR_TERM_REASON_MASK,
-						GHCB_MSR_TERM_REASON_POS);
+		reason_set  = GHCB_MSR_TERM_REASON_SET(control->ghcb_gpa);
+		reason_code = GHCB_MSR_TERM_REASON(control->ghcb_gpa);
+
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
+
 		fallthrough;
 	}
 	default:
@@ -2637,9 +2621,9 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
 	 * vCPU RESET for an SEV-ES guest.
 	 */
-	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
-					    GHCB_VERSION_MIN,
-					    sev_enc_bit));
+	svm->vmcb->control.ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+							GHCB_VERSION_MIN,
+							sev_enc_bit);
 }
 
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
-- 
2.33.1

