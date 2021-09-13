Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB1A409318
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344375AbhIMORm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:17:42 -0400
Received: from 8bytes.org ([81.169.241.247]:56642 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343515AbhIMOPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 10:15:14 -0400
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 91800E7C;
        Mon, 13 Sep 2021 16:13:56 +0200 (CEST)
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
Subject: [PATCH v3 2/4] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Mon, 13 Sep 2021 16:13:43 +0200
Message-Id: <20210913141345.27175-3-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913141345.27175-1-joro@8bytes.org>
References: <20210913141345.27175-1-joro@8bytes.org>
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
 arch/x86/include/asm/kvm_host.h | 10 ++++++-
 arch/x86/kvm/svm/sev.c          | 48 ++++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c              |  5 +++-
 3 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..2f84cda48cdf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -237,6 +237,11 @@ enum x86_intercept_stage;
 	KVM_GUESTDBG_INJECT_DB | \
 	KVM_GUESTDBG_BLOCKIRQ)
 
+enum ap_reset_hold_type {
+	AP_RESET_HOLD_NONE,
+	AP_RESET_HOLD_NAE_EVENT,
+	AP_RESET_HOLD_MSR_PROTO,
+};
 
 #define PFERR_PRESENT_BIT 0
 #define PFERR_WRITE_BIT 1
@@ -909,6 +914,8 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+
+	enum ap_reset_hold_type reset_hold_type;
 };
 
 struct kvm_lpage_info {
@@ -1675,7 +1682,8 @@ int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
-int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
+int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu,
+			      enum ap_reset_hold_type type);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
 void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f368390a5563..8cd1e4ebb4a8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2214,6 +2214,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->vcpu.arch.reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->ghcb)
 		return;
 
@@ -2357,6 +2360,11 @@ static u64 ghcb_msr_cpuid_resp(u64 reg, u64 value)
 	return msr;
 }
 
+static u64 ghcb_msr_ap_rst_resp(u64 value)
+{
+	return (u64)GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2405,6 +2413,16 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu, AP_RESET_HOLD_MSR_PROTO);
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
 
@@ -2490,7 +2508,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
-		ret = kvm_emulate_ap_reset_hold(vcpu);
+		ret = kvm_emulate_ap_reset_hold(vcpu, AP_RESET_HOLD_NAE_EVENT);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
@@ -2627,13 +2645,23 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
+	switch (vcpu->arch.reset_hold_type) {
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..412a195b07af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8516,10 +8516,13 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
-int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
+int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu,
+			      enum ap_reset_hold_type type)
 {
 	int ret = kvm_skip_emulated_instruction(vcpu);
 
+	vcpu->arch.reset_hold_type = type;
+
 	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
-- 
2.33.0

