Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99558738716
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 16:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjFUOeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 10:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjFUOd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 10:33:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608B0E7D
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:33:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 14CF821E0D;
        Wed, 21 Jun 2023 14:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1687358036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7/omLGUpUSzY16b3LdECxmlugxay7EKYFGZWGrm9oA=;
        b=12S9fACy2pDiz3TNH9Bqi1/OqlheTFbMDPWKpW+Ixz2SNzUkyzvk4zmsnsnSKgIGDxFqoa
        wyng+Dony5RANcAB/5PqecSUTwT+RSvtsdaZGqPGB0yz7E7oDOt41Wr3FGPbV1ZFVsyHYo
        0dhvsPKCnZ7PswllVk6DpoVkgKPdGOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1687358036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7/omLGUpUSzY16b3LdECxmlugxay7EKYFGZWGrm9oA=;
        b=VxSQAdt6eDQ9nrezwwSzUdE4AIdDtOCKg3yRu7MH2q7V8YXhghBqKYnDo1Y8z46kGLWxYk
        4CYcWciYz6L6TYCw==
Received: from vasant-suse.fritz.box (unknown [10.163.24.134])
        by relay2.suse.de (Postfix) with ESMTP id 8E71B2C142;
        Wed, 21 Jun 2023 14:33:55 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, drjones@redhat.com, erdemaktas@google.com,
        marcorr@google.com, rientjes@google.com, seanjc@google.com,
        zxwang42@gmail.com, papaluri@amd.com,
        Vasant Karasulli <vkarasulli@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v4 08/11] x86: AMD SEV-ES: Handle CPUID #VC
Date:   Wed, 21 Jun 2023 16:33:22 +0200
Message-Id: <20230621143325.25933-9-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621143325.25933-1-vkarasulli@suse.de>
References: <20230621143325.25933-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using Linux's CPUID #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev_vc.c | 91 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 1eefaf0..57bfe31 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -8,6 +8,7 @@

 #include "amd_sev.h"
 #include "svm.h"
+#include "x86/xsave.h"

 extern phys_addr_t ghcb_addr;

@@ -58,6 +59,93 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->rip += ctxt->insn.length;
 }

+static inline void sev_es_wr_ghcb_msr(u64 val)
+{
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
+}
+
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
+{
+	enum es_result ret;
+
+	/* Fill in protocol and format specifiers */
+	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
+	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
+
+	ghcb_set_sw_exit_code(ghcb, exit_code);
+	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
+		u64 info = ghcb->save.sw_exit_info_2;
+		unsigned long v;
+
+		v = info & SVM_EVTINJ_VEC_MASK;
+
+		/* Check if exception information from hypervisor is sane. */
+		if ((info & SVM_EVTINJ_VALID) &&
+		    ((v == GP_VECTOR) || (v == UD_VECTOR)) &&
+		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
+			ctxt->fi.vector = v;
+			if (info & SVM_EVTINJ_VALID_ERR)
+				ctxt->fi.error_code = info >> 32;
+			ret = ES_EXCEPTION;
+		} else {
+			ret = ES_VMM_ERROR;
+		}
+	} else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
+		ret = ES_VMM_ERROR;
+	} else {
+		ret = ES_OK;
+	}
+
+	return ret;
+}
+
+static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt)
+{
+	struct ex_regs *regs = ctxt->regs;
+	u32 cr4 = read_cr4();
+	enum es_result ret;
+
+	ghcb_set_rax(ghcb, regs->rax);
+	ghcb_set_rcx(ghcb, regs->rcx);
+
+	if (cr4 & X86_CR4_OSXSAVE) {
+		/* Safe to read xcr0 */
+		u64 xcr0;
+		xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0);
+		ghcb_set_xcr0(ghcb, xcr0);
+	} else {
+		/* xgetbv will cause #GP - use reset value for xcr0 */
+		ghcb_set_xcr0(ghcb, 1);
+	}
+
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (!(ghcb_rax_is_valid(ghcb) &&
+	      ghcb_rbx_is_valid(ghcb) &&
+	      ghcb_rcx_is_valid(ghcb) &&
+	      ghcb_rdx_is_valid(ghcb)))
+		return ES_VMM_ERROR;
+
+	regs->rax = ghcb->save.rax;
+	regs->rbx = ghcb->save.rbx;
+	regs->rcx = ghcb->save.rcx;
+	regs->rdx = ghcb->save.rdx;
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -65,6 +153,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	enum es_result result;

 	switch (exit_code) {
+	case SVM_EXIT_CPUID:
+		result = vc_handle_cpuid(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
--
2.34.1

