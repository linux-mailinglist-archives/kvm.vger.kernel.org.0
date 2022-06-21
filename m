Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA47553543
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352258AbiFUPJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352238AbiFUPJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7141B240B1
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7zixe9sxx7e2CtFYoSN/QgMYHehGvy9kir+Nu6gJzM=;
        b=MasFwkBT2StAeuwZvyX8L/hzw93cAKh1z736BQjHBBKhLun0mo0+JhO00pz+cYARdOIWiP
        yVNqU/iprW2ZGYPHjM/xu/eNtqGXLuNaXKYgN12Ig3endOZI99nJPf0o4h6XMD3JnFjplQ
        U33dJAmSAKHPLIKGTf4fHh1yMi0IbBE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-XelTIXQgNRmBhCucK6-FvA-1; Tue, 21 Jun 2022 11:09:16 -0400
X-MC-Unique: XelTIXQgNRmBhCucK6-FvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83DF51044562;
        Tue, 21 Jun 2022 15:09:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13CDA1131D;
        Tue, 21 Jun 2022 15:09:11 +0000 (UTC)
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
Subject: [PATCH v2 02/11] KVM: x86: emulator: introduce update_emulation_mode
Date:   Tue, 21 Jun 2022 18:08:53 +0300
Message-Id: <20220621150902.46126-3-mlevitsk@redhat.com>
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

Some instructions update the cpu execution mode, which needs
to update the emulation mode.

Extract this code, and make assign_eip_far use it.

assign_eip_far now reads CS, instead of getting it via a parameter,
which is ok, because callers always assign CS to the
same value before calling it.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 85 ++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5aeb343ca8b007..2c0087df2d7e6a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -804,8 +804,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 			   ctxt->mode, linear);
 }
 
-static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst,
-			     enum x86emul_mode mode)
+static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
 	ulong linear;
 	int rc;
@@ -815,41 +814,71 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst,
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
-	rc = __linearize(ctxt, addr, &max_size, 1, false, true, mode, &linear);
+	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
 }
 
+static inline int update_emulation_mode(struct x86_emulate_ctxt *ctxt)
+{
+	u64 efer;
+	struct desc_struct cs;
+	u16 selector;
+	u32 base3;
+
+	ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
+
+	if (!ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE) {
+		/* Real mode. cpu must not have long mode active */
+		if (efer & EFER_LMA)
+			return X86EMUL_UNHANDLEABLE;
+		ctxt->mode = X86EMUL_MODE_REAL;
+		return X86EMUL_CONTINUE;
+	}
+
+	if (ctxt->eflags & X86_EFLAGS_VM) {
+		/* Protected/VM86 mode. cpu must not have long mode active */
+		if (efer & EFER_LMA)
+			return X86EMUL_UNHANDLEABLE;
+		ctxt->mode = X86EMUL_MODE_VM86;
+		return X86EMUL_CONTINUE;
+	}
+
+	if (!ctxt->ops->get_segment(ctxt, &selector, &cs, &base3, VCPU_SREG_CS))
+		return X86EMUL_UNHANDLEABLE;
+
+	if (efer & EFER_LMA) {
+		if (cs.l) {
+			/* Proper long mode */
+			ctxt->mode = X86EMUL_MODE_PROT64;
+		} else if (cs.d) {
+			/* 32 bit compatibility mode*/
+			ctxt->mode = X86EMUL_MODE_PROT32;
+		} else {
+			ctxt->mode = X86EMUL_MODE_PROT16;
+		}
+	} else {
+		/* Legacy 32 bit / 16 bit mode */
+		ctxt->mode = cs.d ? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
+	}
+
+	return X86EMUL_CONTINUE;
+}
+
 static inline int assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
-	return assign_eip(ctxt, dst, ctxt->mode);
+	return assign_eip(ctxt, dst);
 }
 
-static int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst,
-			  const struct desc_struct *cs_desc)
+static int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
-	enum x86emul_mode mode = ctxt->mode;
-	int rc;
+	int rc = update_emulation_mode(ctxt);
 
-#ifdef CONFIG_X86_64
-	if (ctxt->mode >= X86EMUL_MODE_PROT16) {
-		if (cs_desc->l) {
-			u64 efer = 0;
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
 
-			ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-			if (efer & EFER_LMA)
-				mode = X86EMUL_MODE_PROT64;
-		} else
-			mode = X86EMUL_MODE_PROT32; /* temporary value */
-	}
-#endif
-	if (mode == X86EMUL_MODE_PROT16 || mode == X86EMUL_MODE_PROT32)
-		mode = cs_desc->d ? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
-	rc = assign_eip(ctxt, dst, mode);
-	if (rc == X86EMUL_CONTINUE)
-		ctxt->mode = mode;
-	return rc;
+	return assign_eip(ctxt, dst);
 }
 
 static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
@@ -2184,7 +2213,7 @@ static int em_jmp_far(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val, &new_desc);
+	rc = assign_eip_far(ctxt, ctxt->src.val);
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -2262,7 +2291,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 				       &new_desc);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-	rc = assign_eip_far(ctxt, eip, &new_desc);
+	rc = assign_eip_far(ctxt, eip);
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -3482,7 +3511,7 @@ static int em_call_far(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val, &new_desc);
+	rc = assign_eip_far(ctxt, ctxt->src.val);
 	if (rc != X86EMUL_CONTINUE)
 		goto fail;
 
-- 
2.26.3

