Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17DD409317
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244807AbhIMORk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:17:40 -0400
Received: from 8bytes.org ([81.169.241.247]:56626 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245044AbhIMOPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 10:15:13 -0400
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id C99D6364;
        Mon, 13 Sep 2021 16:13:55 +0200 (CEST)
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
Subject: [PATCH v3 1/4] KVM: SVM: Get rid of set_ghcb_msr() and *ghcb_msr_bits() functions
Date:   Mon, 13 Sep 2021 16:13:42 +0200
Message-Id: <20210913141345.27175-2-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913141345.27175-1-joro@8bytes.org>
References: <20210913141345.27175-1-joro@8bytes.org>
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
index 75e0b21ad07c..f368390a5563 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2346,21 +2346,15 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
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
@@ -2377,16 +2371,14 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
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
@@ -2398,9 +2390,8 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
@@ -2410,26 +2401,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
@@ -2605,9 +2589,9 @@ void sev_es_create_vcpu(struct vcpu_svm *svm)
 	 * Set the GHCB MSR value as per the GHCB specification when creating
 	 * a vCPU for an SEV-ES guest.
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
2.33.0

