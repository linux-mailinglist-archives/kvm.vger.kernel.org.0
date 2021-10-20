Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DD8434B79
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhJTMq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:46:58 -0400
Received: from 8bytes.org ([81.169.241.247]:33512 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhJTMqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:46:51 -0400
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 17825450;
        Wed, 20 Oct 2021 14:44:34 +0200 (CEST)
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
Subject: [PATCH v5 4/6] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Wed, 20 Oct 2021 14:44:14 +0200
Message-Id: <20211020124416.24523-5-joro@8bytes.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020124416.24523-1-joro@8bytes.org>
References: <20211020124416.24523-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/sev.c          | 52 ++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h          |  8 +++++
 3 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b67f550616cf..5c6b1469cc3b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -237,7 +237,6 @@ enum x86_intercept_stage;
 	KVM_GUESTDBG_INJECT_DB | \
 	KVM_GUESTDBG_BLOCKIRQ)
 
-
 #define PFERR_PRESENT_BIT 0
 #define PFERR_WRITE_BIT 1
 #define PFERR_USER_BIT 2
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9afa71cb36e6..10af4ac83971 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2246,6 +2246,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->ghcb)
 		return;
 
@@ -2405,14 +2408,21 @@ static u64 ghcb_msr_version_info(void)
 	return msr;
 }
 
-static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm)
+static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm, enum ap_reset_hold_type type)
 {
 	int ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
+	svm->reset_hold_type = type;
+
 	return __kvm_vcpu_halt(&svm->vcpu,
 			       KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
 }
 
+static u64 ghcb_msr_ap_rst_resp(u64 value)
+{
+	return (u64)GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2459,6 +2469,16 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		ret = sev_emulate_ap_reset_hold(svm, AP_RESET_HOLD_MSR_PROTO);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(0);
+
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2544,7 +2564,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
-		ret = sev_emulate_ap_reset_hold(svm);
+		ret = sev_emulate_ap_reset_hold(svm, AP_RESET_HOLD_NAE_EVENT);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
@@ -2679,13 +2699,23 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		return;
 	}
 
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->ghcb)
-		return;
-
-	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+	/* Subsequent SIPI */
+	switch (svm->reset_hold_type) {
+	case AP_RESET_HOLD_NAE_EVENT:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
+		 */
+		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+		break;
+	case AP_RESET_HOLD_MSR_PROTO:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set GHCB data field to a non-zero value.
+		 */
+		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(1);
+		break;
+	default:
+		break;
+	}
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 68e5f16a0554..bf9379f1cfb8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -69,6 +69,12 @@ enum {
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
+enum ap_reset_hold_type {
+	AP_RESET_HOLD_NONE,
+	AP_RESET_HOLD_NAE_EVENT,
+	AP_RESET_HOLD_MSR_PROTO,
+};
+
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
@@ -199,6 +205,8 @@ struct vcpu_svm {
 	bool ghcb_sa_free;
 
 	bool guest_state_loaded;
+
+	enum ap_reset_hold_type reset_hold_type;
 };
 
 struct svm_cpu_data {
-- 
2.33.1

