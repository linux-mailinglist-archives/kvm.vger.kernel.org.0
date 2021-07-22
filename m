Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EFA3D22F4
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 13:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhGVLMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 07:12:23 -0400
Received: from 8bytes.org ([81.169.241.247]:44224 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231785AbhGVLMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 07:12:20 -0400
Received: from cap.home.8bytes.org (p4ff2b1ea.dip0.t-ipconnect.de [79.242.177.234])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 4BE43451;
        Thu, 22 Jul 2021 13:52:53 +0200 (CEST)
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
Subject: [PATCH v2 2/4] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Thu, 22 Jul 2021 13:52:43 +0200
Message-Id: <20210722115245.16084-3-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722115245.16084-1-joro@8bytes.org>
References: <20210722115245.16084-1-joro@8bytes.org>
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
 arch/x86/include/asm/kvm_host.h   | 10 ++++++-
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/include/asm/svm.h        |  1 -
 arch/x86/kvm/svm/sev.c            | 49 ++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c                |  5 +++-
 5 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..9afd9d33819a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -231,6 +231,11 @@ enum x86_intercept_stage;
 	KVM_GUESTDBG_INJECT_BP | \
 	KVM_GUESTDBG_INJECT_DB)
 
+enum ap_reset_hold_type {
+	AP_RESET_HOLD_NONE,
+	AP_RESET_HOLD_NAE_EVENT,
+	AP_RESET_HOLD_MSR_PROTO,
+};
 
 #define PFERR_PRESENT_BIT 0
 #define PFERR_WRITE_BIT 1
@@ -903,6 +908,8 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+
+	enum ap_reset_hold_type reset_hold_type;
 };
 
 struct kvm_lpage_info {
@@ -1647,7 +1654,8 @@ int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
-int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
+int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu,
+			      enum ap_reset_hold_type type);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
 void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 8540972cad04..04470aab421b 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -11,6 +11,7 @@
 #define GHCB_MSR_INFO_POS		0
 #define GHCB_DATA_LOW			12
 #define GHCB_MSR_INFO_MASK		(BIT_ULL(GHCB_DATA_LOW) - 1)
+#define GHCB_DATA_MASK			GENMASK_ULL(51, 0)
 
 #define GHCB_DATA(v)			\
 	(((unsigned long)(v) & ~GHCB_MSR_INFO_MASK) >> GHCB_DATA_LOW)
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e322676039f4..5a28f223a9a8 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -164,7 +164,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u8 reserved_sw[32];
 };
 
-
 #define TLB_CONTROL_DO_NOTHING 0
 #define TLB_CONTROL_FLUSH_ALL_ASID 1
 #define TLB_CONTROL_FLUSH_ASID 3
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d7b3557b8dbb..a32ef011025f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2210,6 +2210,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->vcpu.arch.reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->ghcb)
 		return;
 
@@ -2353,6 +2356,11 @@ static void set_ghcb_msr_cpuid_resp(struct vcpu_svm *svm, u64 reg, u64 value)
 	svm->vmcb->control.ghcb_gpa = msr;
 }
 
+static void set_ghcb_msr_ap_rst_resp(struct vcpu_svm *svm, u64 value)
+{
+	svm->vmcb->control.ghcb_gpa = GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
+}
+
 static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 {
 	svm->vmcb->control.ghcb_gpa = value;
@@ -2406,6 +2414,17 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ: {
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu, AP_RESET_HOLD_MSR_PROTO);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		set_ghcb_msr_ap_rst_resp(svm, 0);
+
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2491,7 +2510,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
-		ret = kvm_emulate_ap_reset_hold(vcpu);
+		ret = kvm_emulate_ap_reset_hold(vcpu, AP_RESET_HOLD_NAE_EVENT);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
@@ -2628,13 +2647,23 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
+		set_ghcb_msr_ap_rst_resp(svm, 1);
+		break;
+	default:
+		break;
+	}
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4fd10604f72..927ef55bdb2d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8504,10 +8504,13 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
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
2.31.1

