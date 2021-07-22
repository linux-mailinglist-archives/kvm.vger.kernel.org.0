Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593813D22F3
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 13:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhGVLMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 07:12:23 -0400
Received: from 8bytes.org ([81.169.241.247]:44212 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231784AbhGVLMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 07:12:19 -0400
Received: from cap.home.8bytes.org (p4ff2b1ea.dip0.t-ipconnect.de [79.242.177.234])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id F07943D0;
        Thu, 22 Jul 2021 13:52:52 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v2 1/4] KVM: SVM: Get rid of *ghcb_msr_bits() functions
Date:   Thu, 22 Jul 2021 13:52:42 +0200
Message-Id: <20210722115245.16084-2-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722115245.16084-1-joro@8bytes.org>
References: <20210722115245.16084-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Replace the get function with macros and the set function with
hypercall specific setters. This will avoid preserving any previous
bits in the GHCB-MSR and improved code readability.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-common.h |  9 +++++++
 arch/x86/kvm/svm/sev.c            | 41 +++++++++++--------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

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
index 6710d9ee2e4b..d7b3557b8dbb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2342,16 +2342,15 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return true;
 }
 
-static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
-			      unsigned int pos)
+static void set_ghcb_msr_cpuid_resp(struct vcpu_svm *svm, u64 reg, u64 value)
 {
-	svm->vmcb->control.ghcb_gpa &= ~(mask << pos);
-	svm->vmcb->control.ghcb_gpa |= (value & mask) << pos;
-}
+	u64 msr;
 
-static u64 get_ghcb_msr_bits(struct vcpu_svm *svm, u64 mask, unsigned int pos)
-{
-	return (svm->vmcb->control.ghcb_gpa >> pos) & mask;
+	msr  = GHCB_MSR_CPUID_RESP;
+	msr |= (reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS;
+	msr |= (value & GHCB_MSR_CPUID_VALUE_MASK) << GHCB_MSR_CPUID_VALUE_POS;
+
+	svm->vmcb->control.ghcb_gpa = msr;
 }
 
 static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
@@ -2380,9 +2379,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 	case GHCB_MSR_CPUID_REQ: {
 		u64 cpuid_fn, cpuid_reg, cpuid_value;
 
-		cpuid_fn = get_ghcb_msr_bits(svm,
-					     GHCB_MSR_CPUID_FUNC_MASK,
-					     GHCB_MSR_CPUID_FUNC_POS);
+		cpuid_fn = GHCB_MSR_CPUID_FN(control->ghcb_gpa);
 
 		/* Initialize the registers needed by the CPUID intercept */
 		vcpu->arch.regs[VCPU_REGS_RAX] = cpuid_fn;
@@ -2394,9 +2391,8 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
@@ -2406,26 +2402,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		else
 			cpuid_value = vcpu->arch.regs[VCPU_REGS_RDX];
 
-		set_ghcb_msr_bits(svm, cpuid_value,
-				  GHCB_MSR_CPUID_VALUE_MASK,
-				  GHCB_MSR_CPUID_VALUE_POS);
+		set_ghcb_msr_cpuid_resp(svm, cpuid_reg, cpuid_value);
 
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
-- 
2.31.1

