Return-Path: <kvm+bounces-14296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95EED8A1DDC
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 159E2B2E5FA
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1505A0FE;
	Thu, 11 Apr 2024 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyOgLhZz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC30558ACB
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856600; cv=none; b=DqQu3tnlBlGJsM75H0zUtwX1hUPr/qIL0aIWu3aH0r4w+0N3O6H1Dn3AMp9jDjM8oCVMBvvBUkavz7XzRZEN+BWL+zTQgp0s/BWnV29kc5pH/dtLltsgJvjt1ADhRzt2m6+3Ctyfg+TcjNJf0S1ovKNYMqiKt3G52n2GEBoPg1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856600; c=relaxed/simple;
	bh=rx8o9MhTCHf3Z/M1sxKAChYMwzayxeE3R80i+Va0lZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RmBQnMIah1Mj0PSUfgXOFSOV3blXpfFNL+UNHY+DbAtSPFgW3sfmkd9YP9UPgEGdSEu85OQAKqD851F31+HLx31KjwYc7uVrnTrbxfitmIAW5LoHdwi+9h4NZHusUL4yXvpH+2//KfEbZEwKd9ESZPQ1SOqFXjINuNvYwaOSN+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyOgLhZz; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56bdf81706aso27194a12.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856597; x=1713461397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=seLEOJnc0MG9WAZh3GEU5qlktF5sLbQAk9n8gxHen3Y=;
        b=CyOgLhZzGfOpzCSQMJZg6Eahdmv4gVm/v2CPoGqlZLadExfruhjISgqULmOMdkvuy/
         7LIUn6e2TF3mE0RODI5R9NoKbBPWSm0yvxLHByR+IOmc/uafauEOuJxwZ4gqcQ5SMyo9
         FEl9jKrIrmB6DqiJNIHeLx11xIjI/xxNtNewvDxv6LoOTmC2PBkEdQCYh3rrbP5g88lP
         xpc0khKQdk/7okTe6iHPf3abk190E+Se0ok0QVfq1bXfY+1+zaU5jFsLiCYc4jyOYvEy
         xbVaevi45TVc6NLMcN2u6uGXuLN7k/6ko3RXNQl7d3VcsoJqY393t5xUpOzMlQzdQoFs
         8BKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856597; x=1713461397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=seLEOJnc0MG9WAZh3GEU5qlktF5sLbQAk9n8gxHen3Y=;
        b=pysYB4JfxsHxsfOR9Pi00VjxgNRKoJPl/uEA21znRfKsj6v7iAiTzATQMqVdx+ytRU
         IgpUUJ8BgDxWjthtpPq5o+5tvcI3a3gga9JgUSh4JaLd7qYl/pG4a6zuuwRm8CzU2ZIg
         zeA4DG/OgQ+jCVLGq+1PDcA35Q9QtxJq5bF++LIH1WYjcpSPSk+pI/W/W/9kiviUaQT5
         qz9kWNEzlqFkOXsPCCmwyOHxLPFieMnYP1Pvr0NJJA40/kArTMH+W//M4VJgQ24GRNyM
         nsQ+WljnwI6X4Rm239tA/cbBB2vfVcrVJgMgPVmSYSq3jQLO0iAW4D+v/DxexR6BmIon
         +wOg==
X-Gm-Message-State: AOJu0YxFCE9keNcxOpOL3AxkMGIEPC1dclAg99iYdz3yt67MB0Cy9nJw
	P7s3Udm5oWxSGyYrbFOj0m/FUDPuDiaRP9yjOxPqhTHRfY0xeDhuASgSWoRq
X-Google-Smtp-Source: AGHT+IEh5j+s6Fz6C/OqeHXovmIygqLMe97gLPzOhEdPfRXazU6BTv9QDY5oU5mEQrFovnCuwVOCFA==
X-Received: by 2002:a50:9f08:0:b0:56c:2f3a:13a7 with SMTP id b8-20020a509f08000000b0056c2f3a13a7mr313091edf.25.1712856596473;
        Thu, 11 Apr 2024 10:29:56 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:55 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v6 06/11] x86: AMD SEV-ES: Prepare for #VC processing
Date: Thu, 11 Apr 2024 19:29:39 +0200
Message-Id: <20240411172944.23089-7-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411172944.23089-1-vsntk18@gmail.com>
References: <20240411172944.23089-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

Lay the groundwork for processing #VC exceptions in the handler.
This includes clearing the GHCB, decoding the insn that triggered
this #VC, and continuing execution after the exception has been
processed.

Based on Linux e8c39d0f57f358950356a8e44ee5159f57f86ec5

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev_vc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index f6227030..30b892f9 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -1,15 +1,102 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD SEV-ES #VC exception handling.
+ * Adapted from Linux@b320441c04:
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


