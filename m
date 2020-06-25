Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C845209B0E
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 10:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390700AbgFYIES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 04:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390506AbgFYIDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 04:03:33 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632E7C061573;
        Thu, 25 Jun 2020 01:03:33 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1483D3FA; Thu, 25 Jun 2020 10:03:30 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/4] KVM: SVM: Add svm_ prefix to set/clr/is_intercept()
Date:   Thu, 25 Jun 2020 10:03:24 +0200
Message-Id: <20200625080325.28439-4-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625080325.28439-1-joro@8bytes.org>
References: <20200625080325.28439-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Make clear the symbols belong to the SVM code when they are built-in.

No functional changes.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/svm.c    | 88 +++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.h    |  6 +--
 3 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9845fab381bc..8fc59ce75182 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -258,7 +258,7 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm)
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
 	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
-	    is_intercept(svm, INTERCEPT_VINTR)) {
+	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
 		/*
 		 * In order to request an interrupt window, L0 is usurping
 		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4d9e19bb888f..e0b0321d95d4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1002,38 +1002,38 @@ static void init_vmcb(struct vcpu_svm *svm)
 	if (enable_vmware_backdoor)
 		set_exception_intercept(svm, GP_VECTOR);
 
-	set_intercept(svm, INTERCEPT_INTR);
-	set_intercept(svm, INTERCEPT_NMI);
-	set_intercept(svm, INTERCEPT_SMI);
-	set_intercept(svm, INTERCEPT_SELECTIVE_CR0);
-	set_intercept(svm, INTERCEPT_RDPMC);
-	set_intercept(svm, INTERCEPT_CPUID);
-	set_intercept(svm, INTERCEPT_INVD);
-	set_intercept(svm, INTERCEPT_INVLPG);
-	set_intercept(svm, INTERCEPT_INVLPGA);
-	set_intercept(svm, INTERCEPT_IOIO_PROT);
-	set_intercept(svm, INTERCEPT_MSR_PROT);
-	set_intercept(svm, INTERCEPT_TASK_SWITCH);
-	set_intercept(svm, INTERCEPT_SHUTDOWN);
-	set_intercept(svm, INTERCEPT_VMRUN);
-	set_intercept(svm, INTERCEPT_VMMCALL);
-	set_intercept(svm, INTERCEPT_VMLOAD);
-	set_intercept(svm, INTERCEPT_VMSAVE);
-	set_intercept(svm, INTERCEPT_STGI);
-	set_intercept(svm, INTERCEPT_CLGI);
-	set_intercept(svm, INTERCEPT_SKINIT);
-	set_intercept(svm, INTERCEPT_WBINVD);
-	set_intercept(svm, INTERCEPT_XSETBV);
-	set_intercept(svm, INTERCEPT_RDPRU);
-	set_intercept(svm, INTERCEPT_RSM);
+	svm_set_intercept(svm, INTERCEPT_INTR);
+	svm_set_intercept(svm, INTERCEPT_NMI);
+	svm_set_intercept(svm, INTERCEPT_SMI);
+	svm_set_intercept(svm, INTERCEPT_SELECTIVE_CR0);
+	svm_set_intercept(svm, INTERCEPT_RDPMC);
+	svm_set_intercept(svm, INTERCEPT_CPUID);
+	svm_set_intercept(svm, INTERCEPT_INVD);
+	svm_set_intercept(svm, INTERCEPT_INVLPG);
+	svm_set_intercept(svm, INTERCEPT_INVLPGA);
+	svm_set_intercept(svm, INTERCEPT_IOIO_PROT);
+	svm_set_intercept(svm, INTERCEPT_MSR_PROT);
+	svm_set_intercept(svm, INTERCEPT_TASK_SWITCH);
+	svm_set_intercept(svm, INTERCEPT_SHUTDOWN);
+	svm_set_intercept(svm, INTERCEPT_VMRUN);
+	svm_set_intercept(svm, INTERCEPT_VMMCALL);
+	svm_set_intercept(svm, INTERCEPT_VMLOAD);
+	svm_set_intercept(svm, INTERCEPT_VMSAVE);
+	svm_set_intercept(svm, INTERCEPT_STGI);
+	svm_set_intercept(svm, INTERCEPT_CLGI);
+	svm_set_intercept(svm, INTERCEPT_SKINIT);
+	svm_set_intercept(svm, INTERCEPT_WBINVD);
+	svm_set_intercept(svm, INTERCEPT_XSETBV);
+	svm_set_intercept(svm, INTERCEPT_RDPRU);
+	svm_set_intercept(svm, INTERCEPT_RSM);
 
 	if (!kvm_mwait_in_guest(svm->vcpu.kvm)) {
-		set_intercept(svm, INTERCEPT_MONITOR);
-		set_intercept(svm, INTERCEPT_MWAIT);
+		svm_set_intercept(svm, INTERCEPT_MONITOR);
+		svm_set_intercept(svm, INTERCEPT_MWAIT);
 	}
 
 	if (!kvm_hlt_in_guest(svm->vcpu.kvm))
-		set_intercept(svm, INTERCEPT_HLT);
+		svm_set_intercept(svm, INTERCEPT_HLT);
 
 	control->iopm_base_pa = __sme_set(iopm_base);
 	control->msrpm_base_pa = __sme_set(__pa(svm->msrpm));
@@ -1077,7 +1077,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
-		clr_intercept(svm, INTERCEPT_INVLPG);
+		svm_clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, PF_VECTOR);
 		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
@@ -1094,9 +1094,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->pause_filter_count = pause_filter_count;
 		if (pause_filter_thresh)
 			control->pause_filter_thresh = pause_filter_thresh;
-		set_intercept(svm, INTERCEPT_PAUSE);
+		svm_set_intercept(svm, INTERCEPT_PAUSE);
 	} else {
-		clr_intercept(svm, INTERCEPT_PAUSE);
+		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
 	if (kvm_vcpu_apicv_active(&svm->vcpu))
@@ -1107,14 +1107,14 @@ static void init_vmcb(struct vcpu_svm *svm)
 	 * in VMCB and clear intercepts to avoid #VMEXIT.
 	 */
 	if (vls) {
-		clr_intercept(svm, INTERCEPT_VMLOAD);
-		clr_intercept(svm, INTERCEPT_VMSAVE);
+		svm_clr_intercept(svm, INTERCEPT_VMLOAD);
+		svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 	}
 
 	if (vgif) {
-		clr_intercept(svm, INTERCEPT_STGI);
-		clr_intercept(svm, INTERCEPT_CLGI);
+		svm_clr_intercept(svm, INTERCEPT_STGI);
+		svm_clr_intercept(svm, INTERCEPT_CLGI);
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
@@ -1356,7 +1356,7 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 
 	/* The following fields are ignored when AVIC is enabled */
 	WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));
-	set_intercept(svm, INTERCEPT_VINTR);
+	svm_set_intercept(svm, INTERCEPT_VINTR);
 
 	/*
 	 * This is just a dummy VINTR to actually cause a vmexit to happen.
@@ -1373,7 +1373,7 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 static void svm_clear_vintr(struct vcpu_svm *svm)
 {
 	const u32 mask = V_TPR_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK | V_INTR_MASKING_MASK;
-	clr_intercept(svm, INTERCEPT_VINTR);
+	svm_clr_intercept(svm, INTERCEPT_VINTR);
 
 	/* Drop int_ctl fields related to VINTR injection.  */
 	svm->vmcb->control.int_ctl &= mask;
@@ -2000,8 +2000,8 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
 		 * again while processing KVM_REQ_EVENT if needed.
 		 */
 		if (vgif_enabled(svm))
-			clr_intercept(svm, INTERCEPT_STGI);
-		if (is_intercept(svm, INTERCEPT_VINTR))
+			svm_clr_intercept(svm, INTERCEPT_STGI);
+		if (svm_is_intercept(svm, INTERCEPT_VINTR))
 			svm_clear_vintr(svm);
 
 		enable_gif(svm);
@@ -2162,7 +2162,7 @@ static int cpuid_interception(struct vcpu_svm *svm)
 static int iret_interception(struct vcpu_svm *svm)
 {
 	++svm->vcpu.stat.nmi_window_exits;
-	clr_intercept(svm, INTERCEPT_IRET);
+	svm_clr_intercept(svm, INTERCEPT_IRET);
 	svm->vcpu.arch.hflags |= HF_IRET_MASK;
 	svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
@@ -3019,7 +3019,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	set_intercept(svm, INTERCEPT_IRET);
+	svm_set_intercept(svm, INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3096,10 +3096,10 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
 	if (masked) {
 		svm->vcpu.arch.hflags |= HF_NMI_MASK;
-		set_intercept(svm, INTERCEPT_IRET);
+		svm_set_intercept(svm, INTERCEPT_IRET);
 	} else {
 		svm->vcpu.arch.hflags &= ~HF_NMI_MASK;
-		clr_intercept(svm, INTERCEPT_IRET);
+		svm_clr_intercept(svm, INTERCEPT_IRET);
 	}
 }
 
@@ -3179,7 +3179,7 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 
 	if (!gif_set(svm)) {
 		if (vgif_enabled(svm))
-			set_intercept(svm, INTERCEPT_STGI);
+			svm_set_intercept(svm, INTERCEPT_STGI);
 		return; /* STGI will cause a vm exit */
 	}
 
@@ -3863,7 +3863,7 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)
 
 	if (!gif_set(svm)) {
 		if (vgif_enabled(svm))
-			set_intercept(svm, INTERCEPT_STGI);
+			svm_set_intercept(svm, INTERCEPT_STGI);
 		/* STGI will cause a vm exit */
 	} else {
 		/* We must be in SMM; RSM will cause a vmexit anyway.  */
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 76116f5b0d01..003e89008331 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -293,7 +293,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
-static inline void set_intercept(struct vcpu_svm *svm, int bit)
+static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
@@ -302,7 +302,7 @@ static inline void set_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
-static inline void clr_intercept(struct vcpu_svm *svm, int bit)
+static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
@@ -311,7 +311,7 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
-static inline bool is_intercept(struct vcpu_svm *svm, int bit)
+static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 {
 	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
 }
-- 
2.27.0

