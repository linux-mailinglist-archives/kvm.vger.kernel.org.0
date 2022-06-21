Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981D2553544
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352265AbiFUPJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiFUPJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C81026119
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zQl5JSo1Y4BZzSR3riOjtyKbeCnCX/uu2DqkGjxut8c=;
        b=LhdvB5cDiGDI6yRjAZ88gEDAUxiP+lDGy0YJS3IoPYvj6n6lRGLfPNbxMciq2EXdFFz8Iq
        sLTUVRya4MLHzLvDSnnJrxnqgM1GFWo/3M3lLWLLiXyMYD4YFqS0UVQQF7Ph2N+QEyLk2M
        CXRT13TNmUqO7uC61lHq/FWPID1TGlo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-H5i8OxydPByztx_MuGin9Q-1; Tue, 21 Jun 2022 11:09:20 -0400
X-MC-Unique: H5i8OxydPByztx_MuGin9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CB6A3C10233;
        Tue, 21 Jun 2022 15:09:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE8A29D7F;
        Tue, 21 Jun 2022 15:09:15 +0000 (UTC)
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
Subject: [PATCH v2 03/11] KVM: x86: emulator: remove assign_eip_near/far
Date:   Tue, 21 Jun 2022 18:08:54 +0300
Message-Id: <20220621150902.46126-4-mlevitsk@redhat.com>
In-Reply-To: <20220621150902.46126-1-mlevitsk@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now the assign_eip_far just updates the emulation mode in addition to
updating the rip, it doesn't make sense to keep that function.

Move mode update to the callers and remove these functions.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 47 +++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2c0087df2d7e6a..334a06e6c9b093 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -866,24 +866,9 @@ static inline int update_emulation_mode(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
-static inline int assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst)
-{
-	return assign_eip(ctxt, dst);
-}
-
-static int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst)
-{
-	int rc = update_emulation_mode(ctxt);
-
-	if (rc != X86EMUL_CONTINUE)
-		return rc;
-
-	return assign_eip(ctxt, dst);
-}
-
 static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
 {
-	return assign_eip_near(ctxt, ctxt->_eip + rel);
+	return assign_eip(ctxt, ctxt->_eip + rel);
 }
 
 static int linear_read_system(struct x86_emulate_ctxt *ctxt, ulong linear,
@@ -2213,7 +2198,12 @@ static int em_jmp_far(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val);
+	rc = update_emulation_mode(ctxt);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	rc = assign_eip(ctxt, ctxt->src.val);
+
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -2223,7 +2213,7 @@ static int em_jmp_far(struct x86_emulate_ctxt *ctxt)
 
 static int em_jmp_abs(struct x86_emulate_ctxt *ctxt)
 {
-	return assign_eip_near(ctxt, ctxt->src.val);
+	return assign_eip(ctxt, ctxt->src.val);
 }
 
 static int em_call_near_abs(struct x86_emulate_ctxt *ctxt)
@@ -2232,7 +2222,7 @@ static int em_call_near_abs(struct x86_emulate_ctxt *ctxt)
 	long int old_eip;
 
 	old_eip = ctxt->_eip;
-	rc = assign_eip_near(ctxt, ctxt->src.val);
+	rc = assign_eip(ctxt, ctxt->src.val);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	ctxt->src.val = old_eip;
@@ -2270,7 +2260,7 @@ static int em_ret(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	return assign_eip_near(ctxt, eip);
+	return assign_eip(ctxt, eip);
 }
 
 static int em_ret_far(struct x86_emulate_ctxt *ctxt)
@@ -2291,7 +2281,13 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 				       &new_desc);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-	rc = assign_eip_far(ctxt, eip);
+
+	rc = update_emulation_mode(ctxt);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	rc = assign_eip(ctxt, eip);
+
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -3511,7 +3507,12 @@ static int em_call_far(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val);
+	rc = update_emulation_mode(ctxt);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	rc = assign_eip(ctxt, ctxt->src.val);
+
 	if (rc != X86EMUL_CONTINUE)
 		goto fail;
 
@@ -3544,7 +3545,7 @@ static int em_ret_near_imm(struct x86_emulate_ctxt *ctxt)
 	rc = emulate_pop(ctxt, &eip, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-	rc = assign_eip_near(ctxt, eip);
+	rc = assign_eip(ctxt, eip);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	rsp_increment(ctxt, ctxt->src.val);
-- 
2.26.3

