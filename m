Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD832738719
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 16:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjFUOeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 10:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjFUOd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 10:33:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FCE11C
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:33:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 93FE91FEC0;
        Wed, 21 Jun 2023 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1687358037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5DEdQ8wFn6vuWrQa20x4lbqNXiT8CjmnzqnAm1WjdM=;
        b=SY+dEmv8fYPOIfFUI2fw5zHNmMdAInguI7Cd2zVNAOdL5yIjyHX1GoT0VItDDz6tQZFEYl
        wMQmGyjl7XJ404afrnuUjG4vbWA6QK58/nAVc5rLUVGYvnD9qwjC557/dw1dlmErwqJwGt
        yjM7yinrnBi8z0QCywoo1OGXrIwbpvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1687358037;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5DEdQ8wFn6vuWrQa20x4lbqNXiT8CjmnzqnAm1WjdM=;
        b=M0fHmfHSLa4ajmQgLBu7+IzlhTK8g4+13dCs5AXkL1QRI4iN3ZBSWS3gg5PvP+YXELRr/I
        e7JeLNUNbfTcWbDg==
Received: from vasant-suse.fritz.box (unknown [10.163.24.134])
        by relay2.suse.de (Postfix) with ESMTP id 24AFA2C141;
        Wed, 21 Jun 2023 14:33:57 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, drjones@redhat.com, erdemaktas@google.com,
        marcorr@google.com, rientjes@google.com, seanjc@google.com,
        zxwang42@gmail.com, papaluri@amd.com,
        Vasant Karasulli <vkarasulli@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v4 11/11] x86: AMD SEV-ES: Handle string IO for IOIO #VC
Date:   Wed, 21 Jun 2023 16:33:25 +0200
Message-Id: <20230621143325.25933-12-vkarasulli@suse.de>
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

Using Linux's IOIO #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Reviewed-by: Marc Orr <marcorr@google.com>
Tested-by: Marc Orr <marcorr@google.com>
---
 lib/x86/amd_sev_vc.c | 108 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index e8fc042..1d75a32 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -300,10 +300,46 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 	return ES_OK;
 }

+static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
+					  void *src, unsigned char *buf,
+					  unsigned int data_size,
+					  unsigned int count,
+					  bool backwards)
+{
+	int i, b = backwards ? -1 : 1;
+
+	for (i = 0; i < count; i++) {
+		void *s = src + (i * data_size * b);
+		unsigned char *d = buf + (i * data_size);
+
+		memcpy(d, s, data_size);
+	}
+
+	return ES_OK;
+}
+
+static enum es_result vc_insn_string_write(struct es_em_ctxt *ctxt,
+					   void *dst, unsigned char *buf,
+					   unsigned int data_size,
+					   unsigned int count,
+					   bool backwards)
+{
+	int i, s = backwards ? -1 : 1;
+
+	for (i = 0; i < count; i++) {
+		void *d = dst + (i * data_size * s);
+		unsigned char *b = buf + (i * data_size);
+
+		memcpy(d, b, data_size);
+	}
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct ex_regs *regs = ctxt->regs;
-	u64 exit_info_1;
+	u64 exit_info_1, exit_info_2;
 	enum es_result ret;

 	ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
@@ -311,7 +347,75 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ret;

 	if (exit_info_1 & IOIO_TYPE_STR) {
-		ret = ES_VMM_ERROR;
+		/* (REP) INS/OUTS */
+
+		bool df = ((regs->rflags & X86_EFLAGS_DF) == X86_EFLAGS_DF);
+		unsigned int io_bytes, exit_bytes;
+		unsigned int ghcb_count, op_count;
+		unsigned long es_base;
+		u64 sw_scratch;
+
+		/*
+		 * For the string variants with rep prefix the amount of in/out
+		 * operations per #VC exception is limited so that the kernel
+		 * has a chance to take interrupts and re-schedule while the
+		 * instruction is emulated.
+		 */
+		io_bytes   = (exit_info_1 >> 4) & 0x7;
+		ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;
+
+		op_count    = (exit_info_1 & IOIO_REP) ? regs->rcx : 1;
+		exit_info_2 = op_count < ghcb_count ? op_count : ghcb_count;
+		exit_bytes  = exit_info_2 * io_bytes;
+
+		es_base = 0;
+
+		/* Read bytes of OUTS into the shared buffer */
+		if (!(exit_info_1 & IOIO_TYPE_IN)) {
+			ret = vc_insn_string_read(ctxt,
+					       (void *)(es_base + regs->rsi),
+					       ghcb->shared_buffer, io_bytes,
+					       exit_info_2, df);
+			if (ret)
+				return ret;
+		}
+
+		/*
+		 * Issue an VMGEXIT to the HV to consume the bytes from the
+		 * shared buffer or to have it write them into the shared buffer
+		 * depending on the instruction: OUTS or INS.
+		 */
+		sw_scratch = __pa(ghcb) + offsetof(struct ghcb, shared_buffer);
+		ghcb_set_sw_scratch(ghcb, sw_scratch);
+		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO,
+					  exit_info_1, exit_info_2);
+		if (ret != ES_OK)
+			return ret;
+
+		/* Read bytes from shared buffer into the guest's destination. */
+		if (exit_info_1 & IOIO_TYPE_IN) {
+			ret = vc_insn_string_write(ctxt,
+						   (void *)(es_base + regs->rdi),
+						   ghcb->shared_buffer, io_bytes,
+						   exit_info_2, df);
+			if (ret)
+				return ret;
+
+			if (df)
+				regs->rdi -= exit_bytes;
+			else
+				regs->rdi += exit_bytes;
+		} else {
+			if (df)
+				regs->rsi -= exit_bytes;
+			else
+				regs->rsi += exit_bytes;
+		}
+
+		if (exit_info_1 & IOIO_REP)
+			regs->rcx -= exit_info_2;
+
+		ret = regs->rcx ? ES_RETRY : ES_OK;
 	} else {
 		/* IN/OUT into/from rAX */

--
2.34.1

