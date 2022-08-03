Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9B5588FC0
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbiHCPvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237878AbiHCPvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:51:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C898D48EA8
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ettadgLRKmvccYSAapUAqdb423AILH63PoRVJ2j6Fq4=;
        b=WiQYEvCE+GJEslMO4/popTnproiOIRhHiHnq5qCyLK1ueNGL5dFjcaZ3w2tA1u7oeni/Wm
        pAucCmYfRmvrfJPAiR6Z6Wu7Cx6Ry0MGA3gPW19Z8S2SfaZOv6xlhSxnHL+9bsl4GnPR82
        anPAqlQBovKoobNmOzdPqB8JTRPGyVM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-ka6fNQMCN9-3bGd7DD0WxA-1; Wed, 03 Aug 2022 11:50:59 -0400
X-MC-Unique: ka6fNQMCN9-3bGd7DD0WxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78C4D185A7B2;
        Wed,  3 Aug 2022 15:50:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2CE71121314;
        Wed,  3 Aug 2022 15:50:54 +0000 (UTC)
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
Subject: [PATCH v3 10/13] KVM: x86: emulator/smm: use smram struct for 64 bit smram load/restore
Date:   Wed,  3 Aug 2022 18:50:08 +0300
Message-Id: <20220803155011.43721-11-mlevitsk@redhat.com>
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

Use kvm_smram_state_64 struct to save/restore the 64 bit SMM state
(used when X86_FEATURE_LM is present in the guest CPUID,
regardless of 32-bitness of the guest).

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 88 ++++++++++++++----------------------------
 arch/x86/kvm/x86.c     | 75 ++++++++++++++++-------------------
 2 files changed, 62 insertions(+), 101 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3339d542a25439..4bdbc5893a1657 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2385,24 +2385,16 @@ static void rsm_load_seg_32(struct x86_emulate_ctxt *ctxt,
 }
 
 #ifdef CONFIG_X86_64
-static int rsm_load_seg_64(struct x86_emulate_ctxt *ctxt, const char *smstate,
-			   int n)
+static void rsm_load_seg_64(struct x86_emulate_ctxt *ctxt,
+			    const struct kvm_smm_seg_state_64 *state,
+			    int n)
 {
 	struct desc_struct desc;
-	int offset;
-	u16 selector;
-	u32 base3;
-
-	offset = 0x7e00 + n * 16;
-
-	selector =                GET_SMSTATE(u16, smstate, offset);
-	rsm_set_desc_flags(&desc, GET_SMSTATE(u16, smstate, offset + 2) << 8);
-	set_desc_limit(&desc,     GET_SMSTATE(u32, smstate, offset + 4));
-	set_desc_base(&desc,      GET_SMSTATE(u32, smstate, offset + 8));
-	base3 =                   GET_SMSTATE(u32, smstate, offset + 12);
 
-	ctxt->ops->set_segment(ctxt, selector, &desc, base3, n);
-	return X86EMUL_CONTINUE;
+	rsm_set_desc_flags(&desc, state->attributes << 8);
+	set_desc_limit(&desc,     state->limit);
+	set_desc_base(&desc,      (u32)state->base);
+	ctxt->ops->set_segment(ctxt, state->selector, &desc, state->base >> 32, n);
 }
 #endif
 
@@ -2496,71 +2488,49 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 
 #ifdef CONFIG_X86_64
 static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
-			     const char *smstate)
+			     const struct kvm_smram_state_64 *smstate)
 {
-	struct desc_struct desc;
 	struct desc_ptr dt;
-	u64 val, cr0, cr3, cr4;
-	u32 base3;
-	u16 selector;
 	int i, r;
 
 	for (i = 0; i < 16; i++)
-		*reg_write(ctxt, i) = GET_SMSTATE(u64, smstate, 0x7ff8 - i * 8);
+		*reg_write(ctxt, i) = smstate->gprs[15 - i];
 
-	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);
-	ctxt->eflags = GET_SMSTATE(u32, smstate, 0x7f70) | X86_EFLAGS_FIXED;
+	ctxt->_eip   = smstate->rip;
+	ctxt->eflags = smstate->rflags | X86_EFLAGS_FIXED;
 
-	val = GET_SMSTATE(u64, smstate, 0x7f68);
-
-	if (ctxt->ops->set_dr(ctxt, 6, val))
+	if (ctxt->ops->set_dr(ctxt, 6, smstate->dr6))
 		return X86EMUL_UNHANDLEABLE;
-
-	val = GET_SMSTATE(u64, smstate, 0x7f60);
-
-	if (ctxt->ops->set_dr(ctxt, 7, val))
+	if (ctxt->ops->set_dr(ctxt, 7, smstate->dr7))
 		return X86EMUL_UNHANDLEABLE;
 
-	cr0 =                       GET_SMSTATE(u64, smstate, 0x7f58);
-	cr3 =                       GET_SMSTATE(u64, smstate, 0x7f50);
-	cr4 =                       GET_SMSTATE(u64, smstate, 0x7f48);
-	ctxt->ops->set_smbase(ctxt, GET_SMSTATE(u32, smstate, 0x7f00));
-	val =                       GET_SMSTATE(u64, smstate, 0x7ed0);
+	ctxt->ops->set_smbase(ctxt, smstate->smbase);
 
-	if (ctxt->ops->set_msr(ctxt, MSR_EFER, val & ~EFER_LMA))
+	if (ctxt->ops->set_msr(ctxt, MSR_EFER, smstate->efer & ~EFER_LMA))
 		return X86EMUL_UNHANDLEABLE;
 
-	selector =                  GET_SMSTATE(u32, smstate, 0x7e90);
-	rsm_set_desc_flags(&desc,   GET_SMSTATE(u32, smstate, 0x7e92) << 8);
-	set_desc_limit(&desc,       GET_SMSTATE(u32, smstate, 0x7e94));
-	set_desc_base(&desc,        GET_SMSTATE(u32, smstate, 0x7e98));
-	base3 =                     GET_SMSTATE(u32, smstate, 0x7e9c);
-	ctxt->ops->set_segment(ctxt, selector, &desc, base3, VCPU_SREG_TR);
+	rsm_load_seg_64(ctxt, &smstate->tr, VCPU_SREG_TR);
 
-	dt.size =                   GET_SMSTATE(u32, smstate, 0x7e84);
-	dt.address =                GET_SMSTATE(u64, smstate, 0x7e88);
+	dt.size =                   smstate->idtr.limit;
+	dt.address =                smstate->idtr.base;
 	ctxt->ops->set_idt(ctxt, &dt);
 
-	selector =                  GET_SMSTATE(u32, smstate, 0x7e70);
-	rsm_set_desc_flags(&desc,   GET_SMSTATE(u32, smstate, 0x7e72) << 8);
-	set_desc_limit(&desc,       GET_SMSTATE(u32, smstate, 0x7e74));
-	set_desc_base(&desc,        GET_SMSTATE(u32, smstate, 0x7e78));
-	base3 =                     GET_SMSTATE(u32, smstate, 0x7e7c);
-	ctxt->ops->set_segment(ctxt, selector, &desc, base3, VCPU_SREG_LDTR);
+	rsm_load_seg_64(ctxt, &smstate->ldtr, VCPU_SREG_LDTR);
 
-	dt.size =                   GET_SMSTATE(u32, smstate, 0x7e64);
-	dt.address =                GET_SMSTATE(u64, smstate, 0x7e68);
+	dt.size =                   smstate->gdtr.limit;
+	dt.address =                smstate->gdtr.base;
 	ctxt->ops->set_gdt(ctxt, &dt);
 
-	r = rsm_enter_protected_mode(ctxt, cr0, cr3, cr4);
+	r = rsm_enter_protected_mode(ctxt, smstate->cr0, smstate->cr3, smstate->cr4);
 	if (r != X86EMUL_CONTINUE)
 		return r;
 
-	for (i = 0; i < 6; i++) {
-		r = rsm_load_seg_64(ctxt, smstate, i);
-		if (r != X86EMUL_CONTINUE)
-			return r;
-	}
+	rsm_load_seg_64(ctxt, &smstate->es, VCPU_SREG_ES);
+	rsm_load_seg_64(ctxt, &smstate->cs, VCPU_SREG_CS);
+	rsm_load_seg_64(ctxt, &smstate->ss, VCPU_SREG_SS);
+	rsm_load_seg_64(ctxt, &smstate->ds, VCPU_SREG_DS);
+	rsm_load_seg_64(ctxt, &smstate->fs, VCPU_SREG_FS);
+	rsm_load_seg_64(ctxt, &smstate->gs, VCPU_SREG_GS);
 
 	return X86EMUL_CONTINUE;
 }
@@ -2635,7 +2605,7 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 
 #ifdef CONFIG_X86_64
 	if (emulator_has_longmode(ctxt))
-		ret = rsm_load_state_64(ctxt, (const char *)&smram);
+		ret = rsm_load_state_64(ctxt, &smram.smram64);
 	else
 #endif
 		ret = rsm_load_state_32(ctxt, &smram.smram32);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6abe35f7687e2c..4e3ef63baf83df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9848,20 +9848,17 @@ static void enter_smm_save_seg_32(struct kvm_vcpu *vcpu,
 }
 
 #ifdef CONFIG_X86_64
-static void enter_smm_save_seg_64(struct kvm_vcpu *vcpu, char *buf, int n)
+static void enter_smm_save_seg_64(struct kvm_vcpu *vcpu,
+				  struct kvm_smm_seg_state_64 *state,
+				  int n)
 {
 	struct kvm_segment seg;
-	int offset;
-	u16 flags;
 
 	kvm_get_segment(vcpu, &seg, n);
-	offset = 0x7e00 + n * 16;
-
-	flags = enter_smm_get_segment_flags(&seg) >> 8;
-	put_smstate(u16, buf, offset, seg.selector);
-	put_smstate(u16, buf, offset + 2, flags);
-	put_smstate(u32, buf, offset + 4, seg.limit);
-	put_smstate(u64, buf, offset + 8, seg.base);
+	state->selector = seg.selector;
+	state->attributes = enter_smm_get_segment_flags(&seg) >> 8;
+	state->limit = seg.limit;
+	state->base = seg.base;
 }
 #endif
 
@@ -9909,57 +9906,51 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, struct kvm_smram_stat
 }
 
 #ifdef CONFIG_X86_64
-static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
+static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, struct kvm_smram_state_64 *smram)
 {
 	struct desc_ptr dt;
-	struct kvm_segment seg;
 	unsigned long val;
 	int i;
 
 	for (i = 0; i < 16; i++)
-		put_smstate(u64, buf, 0x7ff8 - i * 8, kvm_register_read_raw(vcpu, i));
+		smram->gprs[15 - i] = kvm_register_read_raw(vcpu, i);
+
+	smram->rip    = kvm_rip_read(vcpu);
+	smram->rflags = kvm_get_rflags(vcpu);
 
-	put_smstate(u64, buf, 0x7f78, kvm_rip_read(vcpu));
-	put_smstate(u32, buf, 0x7f70, kvm_get_rflags(vcpu));
 
 	kvm_get_dr(vcpu, 6, &val);
-	put_smstate(u64, buf, 0x7f68, val);
+	smram->dr6 = val;
 	kvm_get_dr(vcpu, 7, &val);
-	put_smstate(u64, buf, 0x7f60, val);
-
-	put_smstate(u64, buf, 0x7f58, kvm_read_cr0(vcpu));
-	put_smstate(u64, buf, 0x7f50, kvm_read_cr3(vcpu));
-	put_smstate(u64, buf, 0x7f48, kvm_read_cr4(vcpu));
+	smram->dr7 = val;
 
-	put_smstate(u32, buf, 0x7f00, vcpu->arch.smbase);
+	smram->cr0 = kvm_read_cr0(vcpu);
+	smram->cr3 = kvm_read_cr3(vcpu);
+	smram->cr4 = kvm_read_cr4(vcpu);
 
-	/* revision id */
-	put_smstate(u32, buf, 0x7efc, 0x00020064);
+	smram->smbase = vcpu->arch.smbase;
+	smram->smm_revison = 0x00020064;
 
-	put_smstate(u64, buf, 0x7ed0, vcpu->arch.efer);
+	smram->efer = vcpu->arch.efer;
 
-	kvm_get_segment(vcpu, &seg, VCPU_SREG_TR);
-	put_smstate(u16, buf, 0x7e90, seg.selector);
-	put_smstate(u16, buf, 0x7e92, enter_smm_get_segment_flags(&seg) >> 8);
-	put_smstate(u32, buf, 0x7e94, seg.limit);
-	put_smstate(u64, buf, 0x7e98, seg.base);
+	enter_smm_save_seg_64(vcpu, &smram->tr, VCPU_SREG_TR);
 
 	static_call(kvm_x86_get_idt)(vcpu, &dt);
-	put_smstate(u32, buf, 0x7e84, dt.size);
-	put_smstate(u64, buf, 0x7e88, dt.address);
+	smram->idtr.limit = dt.size;
+	smram->idtr.base = dt.address;
 
-	kvm_get_segment(vcpu, &seg, VCPU_SREG_LDTR);
-	put_smstate(u16, buf, 0x7e70, seg.selector);
-	put_smstate(u16, buf, 0x7e72, enter_smm_get_segment_flags(&seg) >> 8);
-	put_smstate(u32, buf, 0x7e74, seg.limit);
-	put_smstate(u64, buf, 0x7e78, seg.base);
+	enter_smm_save_seg_64(vcpu, &smram->ldtr, VCPU_SREG_LDTR);
 
 	static_call(kvm_x86_get_gdt)(vcpu, &dt);
-	put_smstate(u32, buf, 0x7e64, dt.size);
-	put_smstate(u64, buf, 0x7e68, dt.address);
+	smram->gdtr.limit = dt.size;
+	smram->gdtr.base = dt.address;
 
-	for (i = 0; i < 6; i++)
-		enter_smm_save_seg_64(vcpu, buf, i);
+	enter_smm_save_seg_64(vcpu, &smram->es, VCPU_SREG_ES);
+	enter_smm_save_seg_64(vcpu, &smram->cs, VCPU_SREG_CS);
+	enter_smm_save_seg_64(vcpu, &smram->ss, VCPU_SREG_SS);
+	enter_smm_save_seg_64(vcpu, &smram->ds, VCPU_SREG_DS);
+	enter_smm_save_seg_64(vcpu, &smram->fs, VCPU_SREG_FS);
+	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
 }
 #endif
 
@@ -9973,7 +9964,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	memset(smram.bytes, 0, sizeof(smram.bytes));
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-		enter_smm_save_state_64(vcpu, (char *)&smram);
+		enter_smm_save_state_64(vcpu, &smram.smram64);
 	else
 #endif
 		enter_smm_save_state_32(vcpu, &smram.smram32);
-- 
2.26.3

