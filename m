Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0458588FC2
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbiHCPv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiHCPvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:51:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF51A48EAA
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pf511JrR0Yvb5ZevB6nKDQJWx2WgRXzliG96oOf4kx4=;
        b=dFu8Sb+UbOD2pWK7uQI5/+/6sGSTHIM0cbjRws+83saKVIWVEIM7Ui1ENQVnibwsQ47UXc
        P4SmxjtxOAvkAJK7jnTHoMEqAos1Pox9UG4DsX+/1gnwptOS8GzqhRfYM0sfqiceomB7ix
        ud/D10ef6wOSBjBGcMZJj8vGT6utLh4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-xxSHHQ6FP92ECrzMzO7Ppw-1; Wed, 03 Aug 2022 11:50:55 -0400
X-MC-Unique: xxSHHQ6FP92ECrzMzO7Ppw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 732F18041B5;
        Wed,  3 Aug 2022 15:50:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CECA51121315;
        Wed,  3 Aug 2022 15:50:50 +0000 (UTC)
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
Subject: [PATCH v3 09/13] KVM: x86: emulator/smm: use smram struct for 32 bit smram load/restore
Date:   Wed,  3 Aug 2022 18:50:07 +0300
Message-Id: <20220803155011.43721-10-mlevitsk@redhat.com>
In-Reply-To: <20220803155011.43721-1-mlevitsk@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_smram_state_32 struct to save/restore 32 bit SMM state
(used when X86_FEATURE_LM is not present in the guest CPUID).

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 81 +++++++++++++++---------------------------
 arch/x86/kvm/x86.c     | 75 +++++++++++++++++---------------------
 2 files changed, 60 insertions(+), 96 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 610978d00b52b0..3339d542a25439 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2371,25 +2371,17 @@ static void rsm_set_desc_flags(struct desc_struct *desc, u32 flags)
 	desc->type = (flags >>  8) & 15;
 }
 
-static int rsm_load_seg_32(struct x86_emulate_ctxt *ctxt, const char *smstate,
+static void rsm_load_seg_32(struct x86_emulate_ctxt *ctxt,
+			   const struct kvm_smm_seg_state_32 *state,
+			   u16 selector,
 			   int n)
 {
 	struct desc_struct desc;
-	int offset;
-	u16 selector;
-
-	selector = GET_SMSTATE(u32, smstate, 0x7fa8 + n * 4);
-
-	if (n < 3)
-		offset = 0x7f84 + n * 12;
-	else
-		offset = 0x7f2c + (n - 3) * 12;
 
-	set_desc_base(&desc,      GET_SMSTATE(u32, smstate, offset + 8));
-	set_desc_limit(&desc,     GET_SMSTATE(u32, smstate, offset + 4));
-	rsm_set_desc_flags(&desc, GET_SMSTATE(u32, smstate, offset));
+	set_desc_base(&desc,      state->base);
+	set_desc_limit(&desc,     state->limit);
+	rsm_set_desc_flags(&desc, state->flags);
 	ctxt->ops->set_segment(ctxt, selector, &desc, 0, n);
-	return X86EMUL_CONTINUE;
 }
 
 #ifdef CONFIG_X86_64
@@ -2460,63 +2452,46 @@ static int rsm_enter_protected_mode(struct x86_emulate_ctxt *ctxt,
 }
 
 static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
-			     const char *smstate)
+			     const struct kvm_smram_state_32 *smstate)
 {
-	struct desc_struct desc;
 	struct desc_ptr dt;
-	u16 selector;
-	u32 val, cr0, cr3, cr4;
 	int i;
 
-	cr0 =                      GET_SMSTATE(u32, smstate, 0x7ffc);
-	cr3 =                      GET_SMSTATE(u32, smstate, 0x7ff8);
-	ctxt->eflags =             GET_SMSTATE(u32, smstate, 0x7ff4) | X86_EFLAGS_FIXED;
-	ctxt->_eip =               GET_SMSTATE(u32, smstate, 0x7ff0);
+	ctxt->eflags =  smstate->eflags | X86_EFLAGS_FIXED;
+	ctxt->_eip =  smstate->eip;
 
 	for (i = 0; i < 8; i++)
-		*reg_write(ctxt, i) = GET_SMSTATE(u32, smstate, 0x7fd0 + i * 4);
-
-	val = GET_SMSTATE(u32, smstate, 0x7fcc);
+		*reg_write(ctxt, i) = smstate->gprs[i];
 
-	if (ctxt->ops->set_dr(ctxt, 6, val))
+	if (ctxt->ops->set_dr(ctxt, 6, smstate->dr6))
 		return X86EMUL_UNHANDLEABLE;
-
-	val = GET_SMSTATE(u32, smstate, 0x7fc8);
-
-	if (ctxt->ops->set_dr(ctxt, 7, val))
+	if (ctxt->ops->set_dr(ctxt, 7, smstate->dr7))
 		return X86EMUL_UNHANDLEABLE;
 
-	selector =                 GET_SMSTATE(u32, smstate, 0x7fc4);
-	set_desc_base(&desc,       GET_SMSTATE(u32, smstate, 0x7f64));
-	set_desc_limit(&desc,      GET_SMSTATE(u32, smstate, 0x7f60));
-	rsm_set_desc_flags(&desc,  GET_SMSTATE(u32, smstate, 0x7f5c));
-	ctxt->ops->set_segment(ctxt, selector, &desc, 0, VCPU_SREG_TR);
+	rsm_load_seg_32(ctxt, &smstate->tr, smstate->tr_sel, VCPU_SREG_TR);
+	rsm_load_seg_32(ctxt, &smstate->ldtr, smstate->ldtr_sel, VCPU_SREG_LDTR);
 
-	selector =                 GET_SMSTATE(u32, smstate, 0x7fc0);
-	set_desc_base(&desc,       GET_SMSTATE(u32, smstate, 0x7f80));
-	set_desc_limit(&desc,      GET_SMSTATE(u32, smstate, 0x7f7c));
-	rsm_set_desc_flags(&desc,  GET_SMSTATE(u32, smstate, 0x7f78));
-	ctxt->ops->set_segment(ctxt, selector, &desc, 0, VCPU_SREG_LDTR);
 
-	dt.address =               GET_SMSTATE(u32, smstate, 0x7f74);
-	dt.size =                  GET_SMSTATE(u32, smstate, 0x7f70);
+	dt.address =               smstate->gdtr.base;
+	dt.size =                  smstate->gdtr.limit;
 	ctxt->ops->set_gdt(ctxt, &dt);
 
-	dt.address =               GET_SMSTATE(u32, smstate, 0x7f58);
-	dt.size =                  GET_SMSTATE(u32, smstate, 0x7f54);
+	dt.address =               smstate->idtr.base;
+	dt.size =                  smstate->idtr.limit;
 	ctxt->ops->set_idt(ctxt, &dt);
 
-	for (i = 0; i < 6; i++) {
-		int r = rsm_load_seg_32(ctxt, smstate, i);
-		if (r != X86EMUL_CONTINUE)
-			return r;
-	}
+	rsm_load_seg_32(ctxt, &smstate->es, smstate->es_sel, VCPU_SREG_ES);
+	rsm_load_seg_32(ctxt, &smstate->cs, smstate->cs_sel, VCPU_SREG_CS);
+	rsm_load_seg_32(ctxt, &smstate->ss, smstate->ss_sel, VCPU_SREG_SS);
 
-	cr4 = GET_SMSTATE(u32, smstate, 0x7f14);
+	rsm_load_seg_32(ctxt, &smstate->ds, smstate->ds_sel, VCPU_SREG_DS);
+	rsm_load_seg_32(ctxt, &smstate->fs, smstate->fs_sel, VCPU_SREG_FS);
+	rsm_load_seg_32(ctxt, &smstate->gs, smstate->gs_sel, VCPU_SREG_GS);
 
-	ctxt->ops->set_smbase(ctxt, GET_SMSTATE(u32, smstate, 0x7ef8));
+	ctxt->ops->set_smbase(ctxt, smstate->smbase);
 
-	return rsm_enter_protected_mode(ctxt, cr0, cr3, cr4);
+	return rsm_enter_protected_mode(ctxt, smstate->cr0,
+					smstate->cr3, smstate->cr4);
 }
 
 #ifdef CONFIG_X86_64
@@ -2663,7 +2638,7 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 		ret = rsm_load_state_64(ctxt, (const char *)&smram);
 	else
 #endif
-		ret = rsm_load_state_32(ctxt, (const char *)&smram);
+		ret = rsm_load_state_32(ctxt, &smram.smram32);
 
 	if (ret != X86EMUL_CONTINUE)
 		goto emulate_shutdown;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cbbe49bdc58787..6abe35f7687e2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9833,22 +9833,18 @@ static u32 enter_smm_get_segment_flags(struct kvm_segment *seg)
 	return flags;
 }
 
-static void enter_smm_save_seg_32(struct kvm_vcpu *vcpu, char *buf, int n)
+static void enter_smm_save_seg_32(struct kvm_vcpu *vcpu,
+					 struct kvm_smm_seg_state_32 *state,
+					 u32 *selector,
+					 int n)
 {
 	struct kvm_segment seg;
-	int offset;
 
 	kvm_get_segment(vcpu, &seg, n);
-	put_smstate(u32, buf, 0x7fa8 + n * 4, seg.selector);
-
-	if (n < 3)
-		offset = 0x7f84 + n * 12;
-	else
-		offset = 0x7f2c + (n - 3) * 12;
-
-	put_smstate(u32, buf, offset + 8, seg.base);
-	put_smstate(u32, buf, offset + 4, seg.limit);
-	put_smstate(u32, buf, offset, enter_smm_get_segment_flags(&seg));
+	*selector = seg.selector;
+	state->base = seg.base;
+	state->limit = seg.limit;
+	state->flags = enter_smm_get_segment_flags(&seg);
 }
 
 #ifdef CONFIG_X86_64
@@ -9869,54 +9865,47 @@ static void enter_smm_save_seg_64(struct kvm_vcpu *vcpu, char *buf, int n)
 }
 #endif
 
-static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, char *buf)
+static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, struct kvm_smram_state_32 *smram)
 {
 	struct desc_ptr dt;
-	struct kvm_segment seg;
 	unsigned long val;
 	int i;
 
-	put_smstate(u32, buf, 0x7ffc, kvm_read_cr0(vcpu));
-	put_smstate(u32, buf, 0x7ff8, kvm_read_cr3(vcpu));
-	put_smstate(u32, buf, 0x7ff4, kvm_get_rflags(vcpu));
-	put_smstate(u32, buf, 0x7ff0, kvm_rip_read(vcpu));
+	smram->cr0     = kvm_read_cr0(vcpu);
+	smram->cr3     = kvm_read_cr3(vcpu);
+	smram->eflags  = kvm_get_rflags(vcpu);
+	smram->eip     = kvm_rip_read(vcpu);
 
 	for (i = 0; i < 8; i++)
-		put_smstate(u32, buf, 0x7fd0 + i * 4, kvm_register_read_raw(vcpu, i));
+		smram->gprs[i] = kvm_register_read_raw(vcpu, i);
 
 	kvm_get_dr(vcpu, 6, &val);
-	put_smstate(u32, buf, 0x7fcc, (u32)val);
+	smram->dr6     = (u32)val;
 	kvm_get_dr(vcpu, 7, &val);
-	put_smstate(u32, buf, 0x7fc8, (u32)val);
+	smram->dr7     = (u32)val;
 
-	kvm_get_segment(vcpu, &seg, VCPU_SREG_TR);
-	put_smstate(u32, buf, 0x7fc4, seg.selector);
-	put_smstate(u32, buf, 0x7f64, seg.base);
-	put_smstate(u32, buf, 0x7f60, seg.limit);
-	put_smstate(u32, buf, 0x7f5c, enter_smm_get_segment_flags(&seg));
-
-	kvm_get_segment(vcpu, &seg, VCPU_SREG_LDTR);
-	put_smstate(u32, buf, 0x7fc0, seg.selector);
-	put_smstate(u32, buf, 0x7f80, seg.base);
-	put_smstate(u32, buf, 0x7f7c, seg.limit);
-	put_smstate(u32, buf, 0x7f78, enter_smm_get_segment_flags(&seg));
+	enter_smm_save_seg_32(vcpu, &smram->tr, &smram->tr_sel, VCPU_SREG_TR);
+	enter_smm_save_seg_32(vcpu, &smram->ldtr, &smram->ldtr_sel, VCPU_SREG_LDTR);
 
 	static_call(kvm_x86_get_gdt)(vcpu, &dt);
-	put_smstate(u32, buf, 0x7f74, dt.address);
-	put_smstate(u32, buf, 0x7f70, dt.size);
+	smram->gdtr.base = dt.address;
+	smram->gdtr.limit = dt.size;
 
 	static_call(kvm_x86_get_idt)(vcpu, &dt);
-	put_smstate(u32, buf, 0x7f58, dt.address);
-	put_smstate(u32, buf, 0x7f54, dt.size);
+	smram->idtr.base = dt.address;
+	smram->idtr.limit = dt.size;
 
-	for (i = 0; i < 6; i++)
-		enter_smm_save_seg_32(vcpu, buf, i);
+	enter_smm_save_seg_32(vcpu, &smram->es, &smram->es_sel, VCPU_SREG_ES);
+	enter_smm_save_seg_32(vcpu, &smram->cs, &smram->cs_sel, VCPU_SREG_CS);
+	enter_smm_save_seg_32(vcpu, &smram->ss, &smram->ss_sel, VCPU_SREG_SS);
 
-	put_smstate(u32, buf, 0x7f14, kvm_read_cr4(vcpu));
+	enter_smm_save_seg_32(vcpu, &smram->ds, &smram->ds_sel, VCPU_SREG_DS);
+	enter_smm_save_seg_32(vcpu, &smram->fs, &smram->fs_sel, VCPU_SREG_FS);
+	enter_smm_save_seg_32(vcpu, &smram->gs, &smram->gs_sel, VCPU_SREG_GS);
 
-	/* revision id */
-	put_smstate(u32, buf, 0x7efc, 0x00020000);
-	put_smstate(u32, buf, 0x7ef8, vcpu->arch.smbase);
+	smram->cr4 = kvm_read_cr4(vcpu);
+	smram->smm_revision = 0x00020000;
+	smram->smbase = vcpu->arch.smbase;
 }
 
 #ifdef CONFIG_X86_64
@@ -9987,7 +9976,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 		enter_smm_save_state_64(vcpu, (char *)&smram);
 	else
 #endif
-		enter_smm_save_state_32(vcpu, (char *)&smram);
+		enter_smm_save_state_32(vcpu, &smram.smram32);
 
 	/*
 	 * Give enter_smm() a chance to make ISA-specific changes to the vCPU
-- 
2.26.3

