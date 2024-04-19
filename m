Return-Path: <kvm+bounces-15335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF2D8AB327
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 065701F2251B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0860134CD3;
	Fri, 19 Apr 2024 16:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gcZu9vaw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB051327E6
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543400; cv=none; b=bAoq0rVyYhZfigswIuMTlg3ZCzgeeWehl0IihGegajAokQAMLr13LwBQwLEozcVF2rcogYSekL+GQ6999jJZ47zMVj1rEGnWew8koUaWMcWTUTbysLeW2iTxHOv2ZSm5uExoE3vRl0K5K+AXXt5KvydCU1gIb+0j+A6PL55/3bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543400; c=relaxed/simple;
	bh=rx8o9MhTCHf3Z/M1sxKAChYMwzayxeE3R80i+Va0lZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YUtAzV1sSsBO1IsnS8KqagEczYSDwc29yBNYYQpbs6llks2iNEcz+X61tw11i1aJ3D4tS5tcRJVptvzKKSDH7mJ7+GOyv/LNedqiqVwpkbbnGaAFFL4bP33QTi3VFJLJRy/APQhqY2F6NWQZ9WOw93iZyYiQl3lLUvpHJo2RoNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gcZu9vaw; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-418c2bf2f90so12902095e9.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543395; x=1714148195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=seLEOJnc0MG9WAZh3GEU5qlktF5sLbQAk9n8gxHen3Y=;
        b=gcZu9vawxx77X9YHBd1ycF5/MRX2uXaFTJU+nDIdXDDUb39lDvQqBTotfrEtE0wXfK
         ASLZugyVCDTw7FpLWjPXIS1fyiZHtMOyZNnIKU+KC4Btp/0n1qtElXpDKZ9Pyi7t6lo/
         vXfYPE40UfJiLodzrCla5yp6OP877oiD5xMT8T/9U/k8FBi1BZQTPFFoVkMMxQjbXN9u
         oyXZVZYRIQlBzymF8I8lYoC5lF6G0hXX93O0gWg4k5qml2Ns5sVqDNRzpQUsqS5N0O4B
         2VEE5fQ87BVSMYTaEzjZ5+k+jRnE4R+Agp6+5qjS2Pe57VRCUDQE9oYl9pW2tHvB19Ja
         BfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543395; x=1714148195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=seLEOJnc0MG9WAZh3GEU5qlktF5sLbQAk9n8gxHen3Y=;
        b=Jr2/53Ppo0MMQir1lxVcKjy5CAuyxI11eSGda0pEGCtD5EizgIEdVE6CwldcpJbeXC
         O1euAKuypmKWWVcQtTO+Z89Nvo0yJyl6Q5DWttbrUMVtedGeacvmjf/xK2GdKw1oNtlZ
         N6YQJxtwxczbFXej9Q8aT/Q8zjWce1MBZRfzMdIS5VHuhFksS4sbnkDB1G0zBcc6Qh9i
         B+54PVoXja9kVblsW+d96jQg0ZYCODTZJC2lW7CvhUOuBPXUerbQkNQ9kotsGIROdn/k
         ytHRRNM/WD5R0c/o/TeOCZQTC8sVxG1eXGCY0h6G2h616H2o9FqlD5E5Hw0oduXzJiy1
         b+Ng==
X-Gm-Message-State: AOJu0YwKmnqzXL2WiI3mSU5JhtU3EiMI5YxUtneI/Z4bXoWJPOF0OmSx
	jCjDpnNHnABQW8LOlRZ2q9HVqlhrcFo7k8FVgW3Q+hKl/6FrLOBTimvCGgXW
X-Google-Smtp-Source: AGHT+IEgKcul+SVDAqyC5H/7T2nrZfj6stpZxHwd5IO4cQeduXJArJRvEbBAR6WUypa/NiZhvjtsQw==
X-Received: by 2002:a05:600c:1ca9:b0:418:e790:5626 with SMTP id k41-20020a05600c1ca900b00418e7905626mr2173204wms.2.1713543395412;
        Fri, 19 Apr 2024 09:16:35 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:34 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v7 06/11] x86: AMD SEV-ES: Prepare for #VC processing
Date: Fri, 19 Apr 2024 18:16:18 +0200
Message-Id: <20240419161623.45842-7-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419161623.45842-1-vsntk18@gmail.com>
References: <20240419161623.45842-1-vsntk18@gmail.com>
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


