Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673145EC78E
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 17:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiI0PXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 11:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiI0PXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 11:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2DC167062
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 08:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664292186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+wxxaQvAmOhXqvbiroKphZbmEyl3ZzPK5pDgkODGqhg=;
        b=a/7yp6CGazCwsblyjcZXqwtjolyxbMRhGxhxCgbxq7J/Ck8Clz0IiOIsiRtymj0NZE9gBQ
        74QGOgWNj8G+CrQUYyxa59RXAA3DnBqAvTFB8tPPYrlIuEkH3rPIflbaXaOGydWLRPWV15
        51/v6ht/tN68T9vV9OTQb+NPrB0YtVo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-6kT8QB9CNNWEUYegk9Uxmg-1; Tue, 27 Sep 2022 11:22:42 -0400
X-MC-Unique: 6kT8QB9CNNWEUYegk9Uxmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13C3C185A7A8;
        Tue, 27 Sep 2022 15:22:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E039E2166B2A;
        Tue, 27 Sep 2022 15:22:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: allow compiling out SMM support
Date:   Tue, 27 Sep 2022 11:22:41 -0400
Message-Id: <20220927152241.194900-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some users of KVM implement the UEFI variable store through a paravirtual device
that does not require the "SMM lockbox" component of edk2; allow them to
compile out system management mode, which is not a full implementation
especially in how it interacts with nested virtualization.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	The patch isn't pretty.  I could skip all the changes to add WARNs
	to called functions, but the point of adding the config symbol is
	to make sure that those functions, and all the baggage they bring,
	are dead.

 arch/x86/kvm/Kconfig                          | 11 +++++++
 arch/x86/kvm/emulate.c                        |  3 +-
 arch/x86/kvm/kvm_cache_regs.h                 |  2 +-
 arch/x86/kvm/lapic.c                          |  2 ++
 arch/x86/kvm/svm/svm.c                        | 13 ++++++++
 arch/x86/kvm/vmx/vmx.c                        | 12 +++++++
 arch/x86/kvm/x86.c                            | 33 ++++++++++++++++---
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 ++
 8 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a107df22ffee..1679f9b4e96d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -88,6 +88,17 @@ config KVM_INTEL
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-intel.
 
+config KVM_SMM
+	bool "System Management Mode emulation"
+	default y
+	depends on KVM
+	help
+	  Provides support for KVM to emulate System Management Mode (SMM)
+	  in virtual machines.  This can be used by the virtual machine
+	  firmware to implement UEFI secure boot.
+
+	  If unsure, say Y.
+
 config X86_SGX_KVM
 	bool "Software Guard eXtensions (SGX) Virtualization"
 	depends on X86_SGX && KVM_INTEL
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b6180032dfd6..7c1f772ec69f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2557,7 +2557,8 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 	u64 smbase;
 	int ret;
 
-	if ((ctxt->ops->get_hflags(ctxt) & X86EMUL_SMM_MASK) == 0)
+	if (!IS_ENABLED(CONFIG_KVM_SMM) ||
+	    (ctxt->ops->get_hflags(ctxt) & X86EMUL_SMM_MASK) == 0)
 		return emulate_ud(ctxt);
 
 	smbase = ctxt->ops->get_smbase(ctxt);
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 3febc342360c..a9e46dcac4bb 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -202,7 +202,7 @@ static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
 
 static inline bool is_smm(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.hflags & HF_SMM_MASK;
+	return IS_ENABLED(CONFIG_KVM_SMM) && (vcpu->arch.hflags & HF_SMM_MASK);
 }
 
 #endif
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7639d126e6c..d2d08a202b75 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1171,8 +1171,10 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 	case APIC_DM_SMI:
 		result = 1;
+#ifdef CONFIG_KVM_SMM
 		kvm_make_request(KVM_REQ_SMI, vcpu);
 		kvm_vcpu_kick(vcpu);
+#endif
 		break;
 
 	case APIC_DM_NMI:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..2b60a0123ae7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4149,6 +4149,8 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
 	case MSR_IA32_SMBASE:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			return false;
 		/* SEV-ES guests do not support SMM, so report false */
 		if (kvm && sev_es_guest(kvm))
 			return false;
@@ -4409,6 +4411,8 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	WARN_ON_ONCE(!IS_ENABLED(CONFIG_KVM_SMM));
+
 	/* Per APM Vol.2 15.22.2 "Response to SMI" */
 	if (!gif_set(svm))
 		return true;
@@ -4438,6 +4442,9 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	struct kvm_host_map map_save;
 	int ret;
 
+	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_KVM_SMM)))
+		return 0;
+
 	if (!is_guest_mode(vcpu))
 		return 0;
 
@@ -4487,6 +4494,9 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	struct vmcb *vmcb12;
 	int ret;
 
+	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_KVM_SMM)))
+		return 0;
+
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
 		return 0;
 
@@ -4546,6 +4556,9 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_KVM_SMM)))
+		return;
+
 	if (!gif_set(svm)) {
 		if (vgif)
 			svm_set_intercept(svm, INTERCEPT_STGI);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..c8d2c0d3bacf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6840,6 +6840,8 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			return false;
 		/*
 		 * We cannot do SMM unless we can run the guest in big
 		 * real mode.
@@ -7904,6 +7906,8 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 
 static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
+	WARN_ON_ONCE(!IS_ENABLED(CONFIG_KVM_SMM));
+
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
@@ -7914,6 +7918,9 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_KVM_SMM)))
+		return 0;
+
 	/*
 	 * TODO: Implement custom flows for forcing the vCPU out/in of L2 on
 	 * SMI and RSM.  Using the common VM-Exit + VM-Enter routines is wrong
@@ -7936,6 +7943,9 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int ret;
 
+	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_KVM_SMM)))
+		return 0;
+
 	if (vmx->nested.smm.vmxon) {
 		vmx->nested.vmxon = true;
 		vmx->nested.smm.vmxon = false;
@@ -7954,6 +7964,8 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 
 static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
+	WARN_ON_ONCE(!IS_ENABLED(CONFIG_KVM_SMM));
+
 	/* RSM will cause a vmexit anyway.  */
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb9d2c23fb04..90d82086a890 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3637,7 +3637,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_IA32_SMBASE:
-		if (!msr_info->host_initiated)
+		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
 			return 1;
 		vcpu->arch.smbase = data;
 		break;
@@ -4053,7 +4053,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
 		break;
 	case MSR_IA32_SMBASE:
-		if (!msr_info->host_initiated)
+		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
 			return 1;
 		msr_info->data = vcpu->arch.smbase;
 		break;
@@ -4427,6 +4427,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r |= KVM_X86_DISABLE_EXITS_MWAIT;
 		break;
 	case KVM_CAP_X86_SMM:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			break;
+
 		/* SMBASE is usually relocated above 1M on modern chipsets,
 		 * and SMM handlers might indeed rely on 4G segment limits,
 		 * so do not report SMM to be available if real mode is
@@ -4885,8 +4888,8 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
 {
-	kvm_make_request(KVM_REQ_SMI, vcpu);
-
+	if (IS_ENABLED(CONFIG_KVM_SMM))
+		kvm_make_request(KVM_REQ_SMI, vcpu);
 	return 0;
 }
 
@@ -5186,6 +5189,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.apic->sipi_vector = events->sipi_vector;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
+		if (!IS_ENABLED(CONFIG_KVM_SMM) &&
+		    (events->smi.smm ||
+		     events->smi.pending ||
+		     events->smi.smm_inside_nmi))
+			return -EINVAL;
+
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
 			kvm_x86_ops.nested_ops->leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
@@ -8109,12 +8118,20 @@ static void emulator_exiting_smm(struct x86_emulate_ctxt *ctxt)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 
+	if (!IS_ENABLED(CONFIG_KVM_SMM)) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 	kvm_smm_changed(vcpu, false);
 }
 
 static int emulator_leave_smm(struct x86_emulate_ctxt *ctxt,
 				  const char *smstate)
 {
+	if (!IS_ENABLED(CONFIG_KVM_SMM)) {
+		WARN_ON_ONCE(1);
+		return 0;
+	}
 	return static_call(kvm_x86_leave_smm)(emul_to_vcpu(ctxt), smstate);
 }
 
@@ -10162,6 +10179,11 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	unsigned long cr0;
 	char buf[512];
 
+	if (!IS_ENABLED(CONFIG_KVM_SMM)) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	memset(buf, 0, 512);
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
@@ -10236,6 +10258,9 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 
 static void process_smi(struct kvm_vcpu *vcpu)
 {
+	if (!IS_ENABLED(CONFIG_KVM_SMM))
+		return;
+
 	vcpu->arch.smi_pending = true;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 1f136a81858e..cb38a478e1f6 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -137,6 +137,8 @@ int main(int argc, char *argv[])
 	struct kvm_x86_state *state;
 	int stage, stage_reported;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_SMM));
+
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-- 
2.31.1

