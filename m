Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F6E4AF716
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 17:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiBIQob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 11:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237019AbiBIQo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 11:44:27 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A014C0612BE
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 08:44:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 18400210F1;
        Wed,  9 Feb 2022 16:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644425069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qBTlha0CjsrMHt1g/w4Ous7VYPcZPCWrBblEAg0loqM=;
        b=Cd1dLj9HUJGJAcFYer7Adm69rbAWXIuxc5aFQGLRk2+/a96YFcKI5qL7ZBygKTML8nIOaR
        CuhAhrsI5SRNHdDTytmA7mgsVtiq8L454sTvj+XJUnrZye7CTzM46Dlt3RzMSQF4nupGTI
        AqQUKMN6zZ9dI6FRDap48fLrHDN7lr4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 57AB313D4F;
        Wed,  9 Feb 2022 16:44:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UBYTE2zvA2LfNgAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Wed, 09 Feb 2022 16:44:28 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2 05/10] x86: AMD SEV-ES: Prepare for #VC processing
Date:   Wed,  9 Feb 2022 17:44:15 +0100
Message-Id: <20220209164420.8894-6-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220209164420.8894-1-varad.gautam@suse.com>
References: <20220209164420.8894-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lay the groundwork for processing #VC exceptions in the handler.
This includes clearing the GHCB, decoding the insn that triggered
this #VC, and continuing execution after the exception has been
processed.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 8226121..142f2cd 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -1,14 +1,92 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
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
+
 	if (!ghcb) {
 		/* TODO: kill guest */
 		return;
 	}
+
+	vc_ghcb_invalidate(ghcb);
+	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
+	if (result == ES_OK)
+		result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
+	if (result == ES_OK)
+		vc_finish_insn(&ctxt);
+
+	return;
 }
-- 
2.32.0

