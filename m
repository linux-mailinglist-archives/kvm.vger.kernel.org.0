Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862E14547C4
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbhKQNw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhKQNw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:52:56 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C03AC061766
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:58 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso4851829wmr.4
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qBTlha0CjsrMHt1g/w4Ous7VYPcZPCWrBblEAg0loqM=;
        b=jcmAgr3LawdurLRPoQpOQPoxa2BWCxwy4SsbC3unDwY630F7ATFvmZX1YTCu/VlukJ
         SSvSaN5d/5BQkv+wTWNVGeIrfxpEakXQgoMrxKaofz7xCUaiII+ZlokcrS1PsgkOBlMg
         rwE7NSeXpJKUHdSPpViHFZVWvWCjZczepKwdp6eaFZz+fG48i4mLKnUVpF6S1AlUS5NT
         aPegIiwZ9frWfhUHt/gAcZqU1Ff9dNAKGl0Jk/4GWMm39VCMKiA14yXYqNPY9s5MqYMw
         6XjGTaUfkQOKkuFakilTDOvx3LejW8oQpnvnOdyt7DqodZThmbZk09cP0SuB96e7ltb1
         kqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qBTlha0CjsrMHt1g/w4Ous7VYPcZPCWrBblEAg0loqM=;
        b=ZicBmgZfYU6oIsNeTJeh8VwTTJmsHmXOMAJRuLlmYrw7lBizSFlC1bPq7q6yh9eOiV
         MwebR2gaYNGt3UuXHLB/8UugF/b/129x7+YgS3WvcOj3LIj2kXqnQmK2bPoQ60uacxxX
         O4504NYTK1qAKMd5RFpKq0d718FQ3HvkOswCHANX0ozcBI1qPpjGMhQFqRt87oYFAZzx
         LRRMddznmJ1obspvCDHKzXyqRrwSn1YPc/C7eYXcMrdLaAlIcPxTAaYgoD1YsBXAD1L8
         9nwmMiJ0US9I9AV8yS3BfnRez9DkOKtoNBiacNkLL3dpYFqoSe0X9H8JrFaYmhvuW+EQ
         S9ww==
X-Gm-Message-State: AOAM531shVnnlEURR64MoEJvUgaGEEqXXDYCLeiXEheoP18WWhZSILwB
        g4EKU0Rbgv4mhPMBRZX96ROe1MoboMXQxg==
X-Google-Smtp-Source: ABdhPJyW03U4eYL/JP7TbBx3EM28d+BT3zWUNnSXFEKNjMJy2gi22OV2mgpxbRcLvZnP8xVnKNVZ4g==
X-Received: by 2002:a05:600c:364f:: with SMTP id y15mr17015834wmq.7.1637156996283;
        Wed, 17 Nov 2021 05:49:56 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:49:55 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 05/12] x86: AMD SEV-ES: Prepare for #VC processing
Date:   Wed, 17 Nov 2021 14:47:45 +0100
Message-Id: <20211117134752.32662-6-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

