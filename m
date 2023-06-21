Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AC8738713
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 16:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjFUOeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 10:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjFUOd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 10:33:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71989170C
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:33:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 07B0621E07;
        Wed, 21 Jun 2023 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1687358035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRvJwkdfvdP/6bmTGpHx3R+bAAEzjogT73pCJKfoseE=;
        b=a3ePdYYnIpf9kBJmPBiN3Xg+bYZV4x6QM7zv/1lyw7fKlEYk0jbsTNtqmYs2xFWy5R5kLp
        xWTBxdyg+nIYWD3s7ZADRfnSYxMjPo5Ze2Y45DRXtAn8e4Dhb6ZfyB1Lf/dH8XbTbu8Z7A
        FAdQKm11wFP5mBPSOm7mVrdx9mUSasM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1687358035;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRvJwkdfvdP/6bmTGpHx3R+bAAEzjogT73pCJKfoseE=;
        b=FV/JDyA2eGXyHWt48FtKK5zhrcwYwKJw2jLnvhapGILQyLZv4ZJhJYlves30OnWULqbPry
        CmF15+gPDBq6vdBQ==
Received: from vasant-suse.fritz.box (unknown [10.163.24.134])
        by relay2.suse.de (Postfix) with ESMTP id 9079C2C143;
        Wed, 21 Jun 2023 14:33:54 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, drjones@redhat.com, erdemaktas@google.com,
        marcorr@google.com, rientjes@google.com, seanjc@google.com,
        zxwang42@gmail.com, papaluri@amd.com,
        Vasant Karasulli <vkarasulli@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v4 06/11] x86: AMD SEV-ES: Prepare for #VC processing
Date:   Wed, 21 Jun 2023 16:33:20 +0200
Message-Id: <20230621143325.25933-7-vkarasulli@suse.de>
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

Lay the groundwork for processing #VC exceptions in the handler.
This includes clearing the GHCB, decoding the insn that triggered
this #VC, and continuing execution after the exception has been
processed.

Based on Linux 6d7d0603ca7c397a07efc88e314e38b4242a3a8d.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev_vc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index f622703..1eefaf0 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -1,15 +1,102 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD SEV-ES #VC exception handling.
+ * Adapted from Linux@6d7d0603ca:
+ * - arch/x86/kernel/sev.c
+ * - arch/x86/kernel/sev-shared.c
+ */

 #include "amd_sev.h"
+#include "svm.h"

 extern phys_addr_t ghcb_addr;

+static void vc_ghcb_invalidate(struct ghcb *ghcb)
+{
+	ghcb->save.sw_exit_code = 0;
+	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
+}
+
+static bool vc_decoding_needed(unsigned long exit_code)
+{
+	/* Exceptions don't require to decode the instruction */
+	return !(exit_code >= SVM_EXIT_EXCP_BASE &&
+		 exit_code <= SVM_EXIT_LAST_EXCP);
+}
+
+static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
+{
+	unsigned char buffer[MAX_INSN_SIZE];
+	int ret;
+
+	memcpy(buffer, (unsigned char *)ctxt->regs->rip, MAX_INSN_SIZE);
+
+	ret = insn_decode(&ctxt->insn, buffer, MAX_INSN_SIZE, INSN_MODE_64);
+	if (ret < 0)
+		return ES_DECODE_FAILED;
+	else
+		return ES_OK;
+}
+
+static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
+				      struct ex_regs *regs,
+				      unsigned long exit_code)
+{
+	enum es_result ret = ES_OK;
+
+	memset(ctxt, 0, sizeof(*ctxt));
+	ctxt->regs = regs;
+
+	if (vc_decoding_needed(exit_code))
+		ret = vc_decode_insn(ctxt);
+
+	return ret;
+}
+
+static void vc_finish_insn(struct es_em_ctxt *ctxt)
+{
+	ctxt->regs->rip += ctxt->insn.length;
+}
+
+static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
+					 struct ghcb *ghcb,
+					 unsigned long exit_code)
+{
+	enum es_result result;
+
+	switch (exit_code) {
+	default:
+		/*
+		 * Unexpected #VC exception
+		 */
+		result = ES_UNSUPPORTED;
+	}
+
+	return result;
+}
+
 void handle_sev_es_vc(struct ex_regs *regs)
 {
 	struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
+	unsigned long exit_code = regs->error_code;
+	struct es_em_ctxt ctxt;
+	enum es_result result;

 	if (!ghcb) {
 		/* TODO: kill guest */
 		return;
 	}
+
+	vc_ghcb_invalidate(ghcb);
+	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
+	if (result == ES_OK)
+		result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
+	if (result == ES_OK) {
+		vc_finish_insn(&ctxt);
+	} else {
+		printf("Unable to handle #VC exitcode, exit_code=%lx result=%x\n",
+		       exit_code, result);
+	}
+
+	return;
 }
--
2.34.1

