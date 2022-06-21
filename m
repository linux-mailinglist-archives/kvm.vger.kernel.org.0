Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28C4553573
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352387AbiFUPKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352344AbiFUPJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41B912872C
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6RxoWDQZEfB5inmogmfuRCsiEMBnChH++ZuB43pWms=;
        b=bdt+4BuabVDsnGQrvTk2mzm52WEwMbx/Qupib1TmN9DS60zubuJnLi0qAyK7mX1S83T7y6
        uRt2uziND6B+sjv1ThgZuat4Bxd6vSO5AjFux89VBpQmwsx2bUvCo6ut2lfyfUVWrw9HD6
        TCHfx47En3pXWTcY0xnhikW703zDSqU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-mRT5HXJxPvmWCrCKmJg9Og-1; Tue, 21 Jun 2022 11:09:51 -0400
X-MC-Unique: mRT5HXJxPvmWCrCKmJg9Og-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 841FB2999B2D;
        Tue, 21 Jun 2022 15:09:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D56DA10725;
        Tue, 21 Jun 2022 15:09:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 11/11] KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM
Date:   Tue, 21 Jun 2022 18:09:02 +0300
Message-Id: <20220621150902.46126-12-mlevitsk@redhat.com>
In-Reply-To: <20220621150902.46126-1-mlevitsk@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/kvm_emulate.h | 13 ++++++++++---
 arch/x86/kvm/x86.c         | 12 ++++++++++++
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7a3a042d6b862a..d4ede5216491ad 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2443,7 +2443,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 			     struct kvm_smram_state_32 *smstate)
 {
 	struct desc_ptr dt;
-	int i;
+	int i, r;
 
 	ctxt->eflags =  smstate->eflags | X86_EFLAGS_FIXED;
 	ctxt->_eip =  smstate->eip;
@@ -2478,8 +2478,16 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 
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
@@ -2528,6 +2536,9 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	rsm_load_seg_64(ctxt, &smstate->fs, VCPU_SREG_FS);
 	rsm_load_seg_64(ctxt, &smstate->gs, VCPU_SREG_GS);
 
+	ctxt->ops->set_int_shadow(ctxt, 0);
+	ctxt->interruptibility = (u8)smstate->int_shadow;
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 7015728da36d5f..11928306439c77 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -232,6 +232,7 @@ struct x86_emulate_ops {
 	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
 
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
+	void (*set_int_shadow)(struct x86_emulate_ctxt *ctxt, u8 shadow);
 
 	unsigned (*get_hflags)(struct x86_emulate_ctxt *ctxt);
 	void (*exiting_smm)(struct x86_emulate_ctxt *ctxt);
@@ -520,7 +521,9 @@ struct kvm_smram_state_32 {
 	u32 reserved1[62];			/* FE00 - FEF7 */
 	u32 smbase;				/* FEF8 */
 	u32 smm_revision;			/* FEFC */
-	u32 reserved2[5];			/* FF00-FF13 */
+	u32 reserved2[4];			/* FF00-FF0F*/
+	/* int_shadow is KVM extension*/
+	u32 int_shadow;				/* FF10 */
 	/* CR4 is not present in Intel/AMD SMRAM image*/
 	u32 cr4;				/* FF14 */
 	u32 reserved3[5];			/* FF18 */
@@ -592,13 +595,17 @@ struct kvm_smram_state_64 {
 	struct kvm_smm_seg_state_64 idtr;	/* FE80 (R/O) */
 	struct kvm_smm_seg_state_64 tr;		/* FE90 (R/O) */
 
-	/* I/O restart and auto halt restart are not implemented by KVM */
+	/*
+	 * I/O restart and auto halt restart are not implemented by KVM
+	 * int_shadow is KVM's extension
+	 */
+
 	u64 io_restart_rip;			/* FEA0 (R/O) */
 	u64 io_restart_rcx;			/* FEA8 (R/O) */
 	u64 io_restart_rsi;			/* FEB0 (R/O) */
 	u64 io_restart_rdi;			/* FEB8 (R/O) */
 	u32 io_restart_dword;			/* FEC0 (R/O) */
-	u32 reserved1;				/* FEC4 */
+	u32 int_shadow;				/* FEC4 (R/O) */
 	u8 io_instruction_restart;		/* FEC8 (R/W) */
 	u8 auto_halt_restart;			/* FEC9 (R/W) */
 	u8 reserved2[6];			/* FECA-FECF */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1b138f0815d30..665134b1096b25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7887,6 +7887,11 @@ static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
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
@@ -7967,6 +7972,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
 	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
+	.set_int_shadow      = emulator_set_int_shadow,
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
 	.leave_smm           = emulator_leave_smm,
@@ -9744,6 +9750,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, struct kvm_smram_stat
 	smram->cr4 = kvm_read_cr4(vcpu);
 	smram->smm_revision = 0x00020000;
 	smram->smbase = vcpu->arch.smbase;
+
+	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 }
 
 #ifdef CONFIG_X86_64
@@ -9792,6 +9800,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, struct kvm_smram_stat
 	enter_smm_save_seg_64(vcpu, &smram->ds, VCPU_SREG_DS);
 	enter_smm_save_seg_64(vcpu, &smram->fs, VCPU_SREG_FS);
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
+
+	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 }
 #endif
 
@@ -9828,6 +9838,8 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0x8000);
 
+	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
+
 	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
 	vcpu->arch.cr0 = cr0;
-- 
2.26.3

