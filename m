Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE15588FC7
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238266AbiHCPwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbiHCPvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:51:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 497EF4D806
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PD5y4cQGbEfNPI2pCjHVa112SuT0OnV1h5+PPA1jp5U=;
        b=aY9BVgqiA35uZwfPMnM1WKViMfyOGSYBNBTCt4nY7n3mLaJXyXIQNwUmqDg5YfzNGFlBAo
        gboFcu8oklJNr5TQWsyBtNfd0iG/MHU4L3bDtXgm7gAl/uX8gFpv7DOK68i6dI6TUukyUb
        9u+3bSnODj+OaViSJ5LNtpvh33sO9pk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-ENQY38BNMcuj35Ofl0mepA-1; Wed, 03 Aug 2022 11:51:11 -0400
X-MC-Unique: ENQY38BNMcuj35Ofl0mepA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F7E6185A79C;
        Wed,  3 Aug 2022 15:51:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD6ED1121314;
        Wed,  3 Aug 2022 15:51:06 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 13/13] KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM
Date:   Wed,  3 Aug 2022 18:50:11 +0300
Message-Id: <20220803155011.43721-14-mlevitsk@redhat.com>
In-Reply-To: <20220803155011.43721-1-mlevitsk@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When #SMI is asserted, the CPU can be in interrupt shadow
due to sti or mov ss.

It is not mandatory in  Intel/AMD prm to have the #SMI
blocked during the shadow, and on top of
that, since neither SVM nor VMX has true support for SMI
window, waiting for one instruction would mean single stepping
the guest.

Instead, allow #SMI in this case, but both reset the interrupt
window and stash its value in SMRAM to restore it on exit
from SMM.

This fixes rare failures seen mostly on windows guests on VMX,
when #SMI falls on the sti instruction which mainfest in
VM entry failure due to EFLAGS.IF not being set, but STI interrupt
window still being set in the VMCS.


Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c     | 17 ++++++++++++++---
 arch/x86/kvm/kvm_emulate.h | 10 ++++++----
 arch/x86/kvm/x86.c         | 12 ++++++++++++
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4bdbc5893a1657..b4bc45cec3249d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2447,7 +2447,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 			     const struct kvm_smram_state_32 *smstate)
 {
 	struct desc_ptr dt;
-	int i;
+	int i, r;
 
 	ctxt->eflags =  smstate->eflags | X86_EFLAGS_FIXED;
 	ctxt->_eip =  smstate->eip;
@@ -2482,8 +2482,16 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 
 	ctxt->ops->set_smbase(ctxt, smstate->smbase);
 
-	return rsm_enter_protected_mode(ctxt, smstate->cr0,
-					smstate->cr3, smstate->cr4);
+	r = rsm_enter_protected_mode(ctxt, smstate->cr0,
+				     smstate->cr3, smstate->cr4);
+
+	if (r != X86EMUL_CONTINUE)
+		return r;
+
+	ctxt->ops->set_int_shadow(ctxt, 0);
+	ctxt->interruptibility = (u8)smstate->int_shadow;
+
+	return X86EMUL_CONTINUE;
 }
 
 #ifdef CONFIG_X86_64
@@ -2532,6 +2540,9 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	rsm_load_seg_64(ctxt, &smstate->fs, VCPU_SREG_FS);
 	rsm_load_seg_64(ctxt, &smstate->gs, VCPU_SREG_GS);
 
+	ctxt->ops->set_int_shadow(ctxt, 0);
+	ctxt->interruptibility = (u8)smstate->int_shadow;
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 76c0b8e7890b5d..a7313add0f2a58 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -234,6 +234,7 @@ struct x86_emulate_ops {
 	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
 
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
+	void (*set_int_shadow)(struct x86_emulate_ctxt *ctxt, u8 shadow);
 
 	unsigned (*get_hflags)(struct x86_emulate_ctxt *ctxt);
 	void (*exiting_smm)(struct x86_emulate_ctxt *ctxt);
@@ -518,7 +519,8 @@ struct kvm_smram_state_32 {
 	u32 reserved1[62];
 	u32 smbase;
 	u32 smm_revision;
-	u32 reserved2[5];
+	u32 reserved2[4];
+	u32 int_shadow; /* KVM extension */
 	u32 cr4; /* CR4 is not present in Intel/AMD SMRAM image */
 	u32 reserved3[5];
 
@@ -566,6 +568,7 @@ static inline void __check_smram32_offsets(void)
 	__CHECK_SMRAM32_OFFSET(smbase,		0xFEF8);
 	__CHECK_SMRAM32_OFFSET(smm_revision,	0xFEFC);
 	__CHECK_SMRAM32_OFFSET(reserved2,	0xFF00);
+	__CHECK_SMRAM32_OFFSET(int_shadow,	0xFF10);
 	__CHECK_SMRAM32_OFFSET(cr4,		0xFF14);
 	__CHECK_SMRAM32_OFFSET(reserved3,	0xFF18);
 	__CHECK_SMRAM32_OFFSET(ds,		0xFF2C);
@@ -625,7 +628,7 @@ struct kvm_smram_state_64 {
 	u64 io_restart_rsi;
 	u64 io_restart_rdi;
 	u32 io_restart_dword;
-	u32 reserved1;
+	u32 int_shadow;
 	u8 io_inst_restart;
 	u8 auto_hlt_restart;
 	u8 reserved2[6];
@@ -663,7 +666,6 @@ struct kvm_smram_state_64 {
 	u64 gprs[16]; /* GPRS in a reversed "natural" X86 order (R15/R14/../RCX/RAX.) */
 };
 
-
 static inline void __check_smram64_offsets(void)
 {
 #define __CHECK_SMRAM64_OFFSET(field, offset) \
@@ -684,7 +686,7 @@ static inline void __check_smram64_offsets(void)
 	__CHECK_SMRAM64_OFFSET(io_restart_rsi,		0xFEB0);
 	__CHECK_SMRAM64_OFFSET(io_restart_rdi,		0xFEB8);
 	__CHECK_SMRAM64_OFFSET(io_restart_dword,	0xFEC0);
-	__CHECK_SMRAM64_OFFSET(reserved1,		0xFEC4);
+	__CHECK_SMRAM64_OFFSET(int_shadow,		0xFEC4);
 	__CHECK_SMRAM64_OFFSET(io_inst_restart,		0xFEC8);
 	__CHECK_SMRAM64_OFFSET(auto_hlt_restart,	0xFEC9);
 	__CHECK_SMRAM64_OFFSET(reserved2,		0xFECA);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4e3ef63baf83df..ae4c20cec7a9fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8041,6 +8041,11 @@ static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
 	static_call(kvm_x86_set_nmi_mask)(emul_to_vcpu(ctxt), masked);
 }
 
+static void emulator_set_int_shadow(struct x86_emulate_ctxt *ctxt, u8 shadow)
+{
+	 static_call(kvm_x86_set_interrupt_shadow)(emul_to_vcpu(ctxt), shadow);
+}
+
 static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
 {
 	return emul_to_vcpu(ctxt)->arch.hflags;
@@ -8121,6 +8126,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
 	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
+	.set_int_shadow      = emulator_set_int_shadow,
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
 	.leave_smm           = emulator_leave_smm,
@@ -9903,6 +9909,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, struct kvm_smram_stat
 	smram->cr4 = kvm_read_cr4(vcpu);
 	smram->smm_revision = 0x00020000;
 	smram->smbase = vcpu->arch.smbase;
+
+	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 }
 
 #ifdef CONFIG_X86_64
@@ -9951,6 +9959,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, struct kvm_smram_stat
 	enter_smm_save_seg_64(vcpu, &smram->ds, VCPU_SREG_DS);
 	enter_smm_save_seg_64(vcpu, &smram->fs, VCPU_SREG_FS);
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
+
+	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 }
 #endif
 
@@ -9987,6 +9997,8 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0x8000);
 
+	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
+
 	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
 	vcpu->arch.cr0 = cr0;
-- 
2.26.3

