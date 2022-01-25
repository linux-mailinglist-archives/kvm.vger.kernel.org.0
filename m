Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1323249B60C
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578525AbiAYOUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:20:08 -0500
Received: from 8bytes.org ([81.169.241.247]:46326 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1387260AbiAYOQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 09:16:53 -0500
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 33DB02C2;
        Tue, 25 Jan 2022 15:16:32 +0100 (CET)
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
Subject: [PATCH v6 1/7] KVM: SVM: Get rid of set_ghcb_msr() and *ghcb_msr_bits() functions
Date:   Tue, 25 Jan 2022 15:16:20 +0100
Message-Id: <20220125141626.16008-2-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125141626.16008-1-joro@8bytes.org>
References: <20220125141626.16008-1-joro@8bytes.org>
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
 arch/x86/kvm/svm/sev.c            | 55 +++++++++++--------------------
 2 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 1b2fd32b42fe..d49ebec1252a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -53,6 +53,11 @@
 	/* GHCBData[63:32] */				\
 	(((unsigned long)fn) << 32))
 
+#define GHCB_MSR_CPUID_FN(msr)		\
+	(((msr) >> GHCB_MSR_CPUID_FUNC_POS) & GHCB_MSR_CPUID_FUNC_MASK)
+#define GHCB_MSR_CPUID_REG(msr)		\
+	(((msr) >> GHCB_MSR_CPUID_REG_POS) & GHCB_MSR_CPUID_REG_MASK)
+
 /* AP Reset Hold */
 #define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
 #define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
@@ -72,6 +77,10 @@
 	(((((u64)reason_set) &  0xf) << 12) |		\
 	 /* GHCBData[23:16] */				\
 	((((u64)reason_val) & 0xff) << 16))
+#define GHCB_MSR_TERM_REASON_SET(msr)	\
+	(((msr) >> GHCB_MSR_TERM_REASON_SET_POS) & GHCB_MSR_TERM_REASON_SET_MASK)
+#define GHCB_MSR_TERM_REASON(msr)	\
+	(((msr) >> GHCB_MSR_TERM_REASON_POS) & GHCB_MSR_TERM_REASON_MASK)
 
 #define GHCB_SEV_ES_GEN_REQ		0
 #define GHCB_SEV_ES_PROT_UNSUPPORTED	1
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6a22798eaaee..7632fc463458 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2625,21 +2625,15 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return false;
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
@@ -2656,16 +2650,14 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
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
@@ -2677,9 +2669,8 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
@@ -2689,24 +2680,16 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -2897,9 +2880,9 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
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
2.34.1

