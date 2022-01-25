Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D021B49B60A
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578514AbiAYOUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:20:07 -0500
Received: from 8bytes.org ([81.169.241.247]:46334 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1453146AbiAYOQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 09:16:53 -0500
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 49359740;
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
Subject: [PATCH v6 4/7] KVM: SVM: Set "released" on INIT-SIPI iff SEV-ES vCPU was in AP reset hold
Date:   Tue, 25 Jan 2022 15:16:23 +0100
Message-Id: <20220125141626.16008-5-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125141626.16008-1-joro@8bytes.org>
References: <20220125141626.16008-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Set ghcb->sw_exit_info_2 when releasing a vCPU from an AP reset hold if
and only if the vCPU is actually in a reset hold.  Move the handling to
INIT (was SIPI) so that KVM can check the current MP state; when SIPI is
received, the vCPU will be in INIT_RECEIVED and will have lost track of
whether or not the vCPU was in a reset hold.

Drop the received_first_sipi flag, which was a hack to workaround the
fact that KVM lost track of whether or not the vCPU was in a reset hold.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/sev.c | 34 ++++++++++++----------------------
 arch/x86/kvm/svm/svm.c | 13 ++++++++-----
 arch/x86/kvm/svm/svm.h |  4 +---
 3 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bec5b6f4f75d..5ece46eca87f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2900,8 +2900,19 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
-void sev_es_vcpu_reset(struct vcpu_svm *svm)
+void sev_es_vcpu_reset(struct vcpu_svm *svm, bool init_event)
 {
+	if (init_event) {
+		/*
+		 * If the vCPU is in a "reset" hold, signal via SW_EXIT_INFO_2
+		 * that, assuming it receives a SIPI, the vCPU was "released".
+		 */
+		if (svm->vcpu.arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD &&
+		    svm->sev_es.ghcb)
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
+		return;
+	}
+
 	/*
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
 	 * vCPU RESET for an SEV-ES guest.
@@ -2931,24 +2942,3 @@ void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
 	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
 }
-
-void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	/* First SIPI: Use the values as initially set by the VMM */
-	if (!svm->sev_es.received_first_sipi) {
-		svm->sev_es.received_first_sipi = true;
-		return;
-	}
-
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->sev_es.ghcb)
-		return;
-
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
-}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c99b18d76c0..1fd662c0ab14 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1146,9 +1146,6 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 	svm->tsc_ratio_msr = kvm_default_tsc_scaling_ratio;
-
-	if (sev_es_guest(vcpu->kvm))
-		sev_es_vcpu_reset(svm);
 }
 
 static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -1162,6 +1159,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	if (!init_event)
 		__svm_vcpu_reset(vcpu);
+
+	if (sev_es_guest(vcpu->kvm))
+		sev_es_vcpu_reset(svm, init_event);
 }
 
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
@@ -4345,10 +4345,13 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 
 static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 {
+	/*
+	 * SEV-ES (and later derivatives) use INIT-SIPI to bring up APs, but
+	 * the guest is responsible for transitioning to Real Mode and setting
+	 * CS:RIP, GPRs, etc...  KVM just needs to make the vCPU runnable.
+	 */
 	if (!sev_es_guest(vcpu->kvm))
 		return kvm_vcpu_deliver_sipi_vector(vcpu, vector);
-
-	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
 static void svm_vm_destroy(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 776be8ff9e50..17812418d346 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -170,7 +170,6 @@ struct vcpu_sev_es_state {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
-	bool received_first_sipi;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
@@ -615,8 +614,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
-void sev_es_vcpu_reset(struct vcpu_svm *svm);
-void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_es_vcpu_reset(struct vcpu_svm *svm, bool init_event);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
-- 
2.34.1

