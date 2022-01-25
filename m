Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A50349B63C
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242327AbiAYO1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578345AbiAYOSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 09:18:49 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB72BC06175A;
        Tue, 25 Jan 2022 06:18:48 -0800 (PST)
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 9EA317FA;
        Tue, 25 Jan 2022 15:16:33 +0100 (CET)
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
Subject: [PATCH v6 5/7] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Tue, 25 Jan 2022 15:16:24 +0100
Message-Id: <20220125141626.16008-6-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125141626.16008-1-joro@8bytes.org>
References: <20220125141626.16008-1-joro@8bytes.org>
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
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/sev.c | 52 +++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5ece46eca87f..1219c1771895 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2656,9 +2656,34 @@ static u64 ghcb_msr_version_info(void)
 	return msr;
 }
 
-static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm)
+
+static u64 ghcb_msr_ap_rst_resp(u64 value)
+{
+	return (u64)GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
+}
+
+static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm, u64 hold_type)
 {
 	int ret = kvm_skip_emulated_instruction(&svm->vcpu);
+	if (hold_type == GHCB_MSR_AP_RESET_HOLD_REQ) {
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(0);
+		svm->reset_hold_msr_protocol = true;
+	} else {
+		WARN_ON_ONCE(hold_type != SVM_VMGEXIT_AP_HLT_LOOP);
+		svm->reset_hold_msr_protocol = false;
+	}
+
+	/*
+	 * Ensure the writes to ghcb_gpa and reset_hold_msr_protocol are visible
+	 * before the MP state change so that the INIT-SIPI doesn't misread
+	 * reset_hold_msr_protocol or write ghcb_gpa before this.  Pairs with
+	 * the smp_rmb() in sev_vcpu_reset().
+	 */
+	smp_wmb();
 
 	return __kvm_emulate_halt(&svm->vcpu,
 				  KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
@@ -2710,6 +2735,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		ret = sev_emulate_ap_reset_hold(svm, GHCB_MSR_AP_RESET_HOLD_REQ);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2800,7 +2828,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
-		ret = sev_emulate_ap_reset_hold(svm);
+		ret = sev_emulate_ap_reset_hold(svm, SVM_VMGEXIT_AP_HLT_LOOP);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
@@ -2905,11 +2933,23 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm, bool init_event)
 	if (init_event) {
 		/*
 		 * If the vCPU is in a "reset" hold, signal via SW_EXIT_INFO_2
-		 * that, assuming it receives a SIPI, the vCPU was "released".
+		 * (or the GHCB_GPA for the MSR protocol) that, assuming it
+		 * receives a SIPI, the vCPU was "released".
 		 */
-		if (svm->vcpu.arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD &&
-		    svm->sev_es.ghcb)
-			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		if (svm->vcpu.arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD) {
+			/*
+			 * Ensure mp_state is read before reset_hold_msr_protocol
+			 * and before writing ghcb_gpa to ensure KVM conumes the
+			 * correct protocol.  Pairs with the smp_wmb() in
+			 * sev_emulate_ap_reset_hold().
+			 */
+			smp_rmb();
+			if (svm->reset_hold_msr_protocol)
+				svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(1);
+			else if (svm->sev_es.ghcb)
+				ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+			svm->reset_hold_msr_protocol = false;
+		}
 		return;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 17812418d346..dbecafc25574 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -243,6 +243,7 @@ struct vcpu_svm {
 	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
+	bool reset_hold_msr_protocol;
 };
 
 struct svm_cpu_data {
-- 
2.34.1

