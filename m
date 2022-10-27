Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4568660FD6A
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbiJ0Qtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiJ0Qtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:49:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A802C672
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666889388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fbdILxnyrySIB5/Xdk+S5QCMZTtG4wDiXczoXJI+58I=;
        b=P3eKTboX8WBnteyiwZanRzjLYsMZIOoBrE7gvWz510WqTJFnokBHJ4++lapc5ZBElddwtG
        3p3606ENt1S0OIe3mTwYxmy1ULffDDqLYMEIkmY6hA/j4JD2IDoWRd+TEfvMEEzuPBHVKu
        WZsj/FQt+Qf2Ww3bGPDr1UE+7yW8Y98=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-eiyCTeIPPCWWrIA5YdCNQg-1; Thu, 27 Oct 2022 12:49:46 -0400
X-MC-Unique: eiyCTeIPPCWWrIA5YdCNQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BEB9800B23;
        Thu, 27 Oct 2022 16:49:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A569112132D;
        Thu, 27 Oct 2022 16:49:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 06/10] KVM: x86: compile out vendor-specific code if SMM is disabled
Date:   Thu, 27 Oct 2022 12:49:40 -0400
Message-Id: <20221027164944.3031588-7-pbonzini@redhat.com>
In-Reply-To: <20221027164944.3031588-1-pbonzini@redhat.com>
References: <20221027164944.3031588-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vendor-specific code that deals with SMI injection and saving/restoring
SMM state is not needed if CONFIG_KVM_SMM is disabled, so remove the
four callbacks smi_allowed, enter_smm, leave_smm and enable_smi_window.
The users in svm/nested.c and x86.c also have to be compiled out; the
amount of #ifdef'ed code is small and it's not worth moving it to
smm.c.

enter_smm is now used only within #ifdef CONFIG_KVM_SMM, and the stub
can therefore be removed.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220929172016.319443-7-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 ++
 arch/x86/include/asm/kvm_host.h    | 2 ++
 arch/x86/kvm/smm.h                 | 1 -
 arch/x86/kvm/svm/nested.c          | 2 ++
 arch/x86/kvm/svm/svm.c             | 4 ++++
 arch/x86/kvm/vmx/vmx.c             | 4 ++++
 arch/x86/kvm/x86.c                 | 4 ++++
 7 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 82ba4a564e58..ea58e67e9a67 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -110,10 +110,12 @@ KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
+#ifdef CONFIG_KVM_SMM
 KVM_X86_OP(smi_allowed)
 KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
+#endif
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 38451bf71b80..fe3ab5df6555 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1607,10 +1607,12 @@ struct kvm_x86_ops {
 
 	void (*setup_mce)(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_SMM
 	int (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
 	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
+#endif
 
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index 0e1bd8bd6dc4..8debe81494c6 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -27,7 +27,6 @@ void process_smi(struct kvm_vcpu *vcpu);
 #else
 static inline int kvm_inject_smi(struct kvm_vcpu *vcpu) { return -ENOTTY; }
 static inline bool is_smm(struct kvm_vcpu *vcpu) { return false; }
-static inline void enter_smm(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
 static inline void process_smi(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
 
 /*
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cc0fd75f7cba..b258d6988f5d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1378,6 +1378,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+#ifdef CONFIG_KVM_SMM
 	if (vcpu->arch.smi_pending && !svm_smi_blocked(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
@@ -1386,6 +1387,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		nested_svm_simple_vmexit(svm, SVM_EXIT_SMI);
 		return 0;
 	}
+#endif
 
 	if (vcpu->arch.nmi_pending && !svm_nmi_blocked(vcpu)) {
 		if (block_nested_events)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6f7ceb35d2ff..2200b8aa7273 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4408,6 +4408,7 @@ static void svm_setup_mce(struct kvm_vcpu *vcpu)
 	vcpu->arch.mcg_cap &= 0x1ff;
 }
 
+#ifdef CONFIG_KVM_SMM
 bool svm_smi_blocked(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4557,6 +4558,7 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 		/* We must be in SMM; RSM will cause a vmexit anyway.  */
 	}
 }
+#endif
 
 static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 					void *insn, int insn_len)
@@ -4832,10 +4834,12 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.pi_update_irte = avic_pi_update_irte,
 	.setup_mce = svm_setup_mce,
 
+#ifdef CONFIG_KVM_SMM
 	.smi_allowed = svm_smi_allowed,
 	.enter_smm = svm_enter_smm,
 	.leave_smm = svm_leave_smm,
 	.enable_smi_window = svm_enable_smi_window,
+#endif
 
 	.mem_enc_ioctl = sev_mem_enc_ioctl,
 	.mem_enc_register_region = sev_mem_enc_register_region,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2abe62d7cc0..ee2f51a886d9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7905,6 +7905,7 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 			~FEAT_CTL_LMCE_ENABLED;
 }
 
+#ifdef CONFIG_KVM_SMM
 static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
@@ -7959,6 +7960,7 @@ static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	/* RSM will cause a vmexit anyway.  */
 }
+#endif
 
 static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
@@ -8126,10 +8128,12 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.setup_mce = vmx_setup_mce,
 
+#ifdef CONFIG_KVM_SMM
 	.smi_allowed = vmx_smi_allowed,
 	.enter_smm = vmx_enter_smm,
 	.leave_smm = vmx_leave_smm,
 	.enable_smi_window = vmx_enable_smi_window,
+#endif
 
 	.can_emulate_instruction = vmx_can_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ec3d3632316..3f380fb4ed7a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9918,6 +9918,7 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 	 * in order to make progress and get back here for another iteration.
 	 * The kvm_x86_ops hooks communicate this by returning -EBUSY.
 	 */
+#ifdef CONFIG_KVM_SMM
 	if (vcpu->arch.smi_pending) {
 		r = can_inject ? static_call(kvm_x86_smi_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
@@ -9930,6 +9931,7 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		} else
 			static_call(kvm_x86_enable_smi_window)(vcpu);
 	}
+#endif
 
 	if (vcpu->arch.nmi_pending) {
 		r = can_inject ? static_call(kvm_x86_nmi_allowed)(vcpu, true) : -EBUSY;
@@ -12574,10 +12576,12 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	     static_call(kvm_x86_nmi_allowed)(vcpu, false)))
 		return true;
 
+#ifdef CONFIG_KVM_SMM
 	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
 	    (vcpu->arch.smi_pending &&
 	     static_call(kvm_x86_smi_allowed)(vcpu, false)))
 		return true;
+#endif
 
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
-- 
2.31.1


