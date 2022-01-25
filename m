Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2AC49B609
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578502AbiAYOUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:20:04 -0500
Received: from 8bytes.org ([81.169.241.247]:46324 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1452917AbiAYOQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 09:16:53 -0500
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id E77526AE;
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
Subject: [PATCH v6 3/7] KVM: SVM: Move kvm_emulate_ap_reset_hold() to AMD specific code
Date:   Tue, 25 Jan 2022 15:16:22 +0100
Message-Id: <20220125141626.16008-4-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125141626.16008-1-joro@8bytes.org>
References: <20220125141626.16008-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The function is only used by the kvm-amd module. Move it to the AMD
specific part of the code and name it sev_emulate_ap_reset_hold().

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/sev.c          | 10 +++++++++-
 arch/x86/kvm/x86.c              | 12 ++----------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1384517d7709..9a1591878ff4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1701,7 +1701,7 @@ int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu);
-int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
+int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
 void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d6147137a7da..bec5b6f4f75d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2656,6 +2656,14 @@ static u64 ghcb_msr_version_info(void)
 	return msr;
 }
 
+static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm)
+{
+	int ret = kvm_skip_emulated_instruction(&svm->vcpu);
+
+	return __kvm_emulate_halt(&svm->vcpu,
+				  KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2792,7 +2800,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
-		ret = kvm_emulate_ap_reset_hold(vcpu);
+		ret = sev_emulate_ap_reset_hold(svm);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e43d756312f..c9cb89b2136b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8814,7 +8814,7 @@ void kvm_arch_exit(void)
 #endif
 }
 
-static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
+int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	/*
 	 * The vCPU has halted, e.g. executed HLT.  Update the run state if the
@@ -8832,6 +8832,7 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 		return 0;
 	}
 }
+EXPORT_SYMBOL_GPL(__kvm_emulate_halt);
 
 int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
 {
@@ -8850,15 +8851,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
-int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
-{
-	int ret = kvm_skip_emulated_instruction(vcpu);
-
-	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
-					KVM_EXIT_AP_RESET_HOLD) && ret;
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
-
 #ifdef CONFIG_X86_64
 static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 			        unsigned long clock_type)
-- 
2.34.1

