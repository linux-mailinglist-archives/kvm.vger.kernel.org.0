Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD068434B74
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhJTMqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhJTMqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:46:51 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EA3C061749;
        Wed, 20 Oct 2021 05:44:37 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id ABBCC3C3;
        Wed, 20 Oct 2021 14:44:33 +0200 (CEST)
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
Subject: [PATCH v5 3/6] KVM: SVM: Move kvm_emulate_ap_reset_hold() to AMD specific code
Date:   Wed, 20 Oct 2021 14:44:13 +0200
Message-Id: <20211020124416.24523-4-joro@8bytes.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020124416.24523-1-joro@8bytes.org>
References: <20211020124416.24523-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The function is only used by the kvm-amd module. Move it to the AMD
specific part of the code and name it sev_emulate_ap_reset_hold().

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/sev.c          | 10 +++++++++-
 arch/x86/kvm/x86.c              | 11 ++---------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 80f4b8a9233c..b67f550616cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1682,8 +1682,8 @@ int kvm_emulate_monitor(struct kvm_vcpu *vcpu);
 int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
+int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason);
 int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
-int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
 void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9fb4d8fad1f4..9afa71cb36e6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2405,6 +2405,14 @@ static u64 ghcb_msr_version_info(void)
 	return msr;
 }
 
+static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm)
+{
+	int ret = kvm_skip_emulated_instruction(&svm->vcpu);
+
+	return __kvm_vcpu_halt(&svm->vcpu,
+			       KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2536,7 +2544,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
-		ret = kvm_emulate_ap_reset_hold(vcpu);
+		ret = sev_emulate_ap_reset_hold(svm);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c59b63c56af9..cc3a65d6821d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8651,7 +8651,7 @@ void kvm_arch_exit(void)
 #endif
 }
 
-static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
+int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
@@ -8662,6 +8662,7 @@ static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
 		return 0;
 	}
 }
+EXPORT_SYMBOL_GPL(__kvm_vcpu_halt);
 
 int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
@@ -8680,14 +8681,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
-int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
-{
-	int ret = kvm_skip_emulated_instruction(vcpu);
-
-	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
-
 #ifdef CONFIG_X86_64
 static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 			        unsigned long clock_type)
-- 
2.33.1

