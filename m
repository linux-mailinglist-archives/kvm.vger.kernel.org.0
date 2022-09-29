Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43115EFBC6
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiI2RUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 13:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiI2RUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 13:20:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BF91023AB
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664472020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HcFaK80T9K557/Wa2SaUlDPQ+F2xISZ2hAqyCg9mPNE=;
        b=KFOi7qmN3Mj+fe+u338d2uLCKpNgMLX5g1ZMaaU59qP9rdqi/7IJY4U5EMnnlpCb+8D2lC
        Ad4nukHWITBYK1xed93N4zEIgEXpAsztkTL7RCYe4TbbSrzgpYaKXd01LUquY7/8n1XnB2
        b/R1fYbGsmw6TSOycJLAbREkVRUpgq8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-Ph4mfmYNPUCgI8fiTCxsVw-1; Thu, 29 Sep 2022 13:20:18 -0400
X-MC-Unique: Ph4mfmYNPUCgI8fiTCxsVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB6D829324AA;
        Thu, 29 Sep 2022 17:20:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4AC742220;
        Thu, 29 Sep 2022 17:20:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, maciej.szmigiero@oracle.com
Subject: [PATCH v2 5/8] KVM: allow compiling out SMM support
Date:   Thu, 29 Sep 2022 13:20:13 -0400
Message-Id: <20220929172016.319443-6-pbonzini@redhat.com>
In-Reply-To: <20220929172016.319443-1-pbonzini@redhat.com>
References: <20220929172016.319443-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/Kconfig                          | 11 ++++++++++
 arch/x86/kvm/Makefile                         |  2 +-
 arch/x86/kvm/smm.h                            | 13 ++++++++++++
 arch/x86/kvm/svm/svm.c                        |  2 ++
 arch/x86/kvm/vmx/vmx.c                        |  2 ++
 arch/x86/kvm/x86.c                            | 21 +++++++++++++++++--
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 ++
 7 files changed, 50 insertions(+), 3 deletions(-)

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
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index ec6f7656254b..6cf40f668277 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -20,7 +20,7 @@ endif
 
 kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
-kvm-y			+= smm.o
+kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index b0602a92e511..4c699fee4492 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -8,6 +8,7 @@
 #define PUT_SMSTATE(type, buf, offset, val)                      \
 	*(type *)((buf) + (offset) - 0x7e00) = val
 
+#ifdef CONFIG_KVM_SMM
 static inline int kvm_inject_smi(struct kvm_vcpu *vcpu)
 {
 	kvm_make_request(KVM_REQ_SMI, vcpu);
@@ -23,5 +24,17 @@ void kvm_smm_changed(struct kvm_vcpu *vcpu, bool in_smm);
 void enter_smm(struct kvm_vcpu *vcpu);
 int emulator_leave_smm(struct x86_emulate_ctxt *ctxt);
 void process_smi(struct kvm_vcpu *vcpu);
+#else
+static inline int kvm_inject_smi(struct kvm_vcpu *vcpu) { return -ENOTTY; }
+static inline bool is_smm(struct kvm_vcpu *vcpu) { return false; }
+static inline void kvm_smm_changed(struct kvm_vcpu *vcpu, bool in_smm) { WARN_ON_ONCE(1); }
+static inline void enter_smm(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
+static inline void process_smi(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
+
+/*
+ * emulator_leave_smm is used as a function pointer, so the
+ * stub is defined in x86.c.
+ */
+#endif
 
 #endif
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 496ee7d1ae2f..6f7ceb35d2ff 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4150,6 +4150,8 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
 	case MSR_IA32_SMBASE:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			return false;
 		/* SEV-ES guests do not support SMM, so report false */
 		if (kvm && sev_es_guest(kvm))
 			return false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 038809c68006..b22330a15adb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6841,6 +6841,8 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			return false;
 		/*
 		 * We cannot do SMM unless we can run the guest in big
 		 * real mode.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 97a871635986..a9e050aefea6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3636,7 +3636,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_IA32_SMBASE:
-		if (!msr_info->host_initiated)
+		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
 			return 1;
 		vcpu->arch.smbase = data;
 		break;
@@ -4052,7 +4052,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
 		break;
 	case MSR_IA32_SMBASE:
-		if (!msr_info->host_initiated)
+		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
 			return 1;
 		msr_info->data = vcpu->arch.smbase;
 		break;
@@ -4426,6 +4426,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r |= KVM_X86_DISABLE_EXITS_MWAIT;
 		break;
 	case KVM_CAP_X86_SMM:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			break;
+
 		/* SMBASE is usually relocated above 1M on modern chipsets,
 		 * and SMM handlers might indeed rely on 4G segment limits,
 		 * so do not report SMM to be available if real mode is
@@ -5176,6 +5179,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
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
@@ -8066,6 +8075,14 @@ static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
 	return emul_to_vcpu(ctxt)->arch.hflags;
 }
 
+#ifndef CONFIG_KVM_SMM
+static int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
+{
+	WARN_ON_ONCE(1);
+	return X86EMUL_UNHANDLEABLE;
+}
+#endif
+
 static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
 {
 	kvm_make_request(KVM_REQ_TRIPLE_FAULT, emul_to_vcpu(ctxt));
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


