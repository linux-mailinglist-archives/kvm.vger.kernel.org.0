Return-Path: <kvm+bounces-14299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6403D8A1DD7
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3D201F26759
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFCDB5CDFA;
	Thu, 11 Apr 2024 17:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KF3mYi+U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7B5A11A
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856603; cv=none; b=lFIHWM+ciAKbnNzxm0xf3AlCF2bcsT9bUu9WVvB9/YlE9RkAS59CgmG3hFK/3s7zIYmzTKpcCpZw/jf6RXbU+X+yYYEvZLg9Mf59ndnFaxPraJOCdEid8yT8YuFNCNzD4PujdCkZ4Y2Hy+Vm2J1jY2N35dLIh41apkDxWdqhOnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856603; c=relaxed/simple;
	bh=AxZZDRgU+eSEcOZlh/drCYT330YOmbapHB+yjoCaw38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PzXHDzlg2O9Tq8DrgfETIv2/FtOGKf2g8EjSIagBiIJtI5U9EvNWbtwN3ABKkc9+9iZ5WcokOd0+RzpSdtTPgg0QSob8PPv4x3pdt+7JeMEPOKaJFcG5dqHu4+G9vLLJHxicC/2kobZTz0a4Yl1ORO1zOJ1yDiB4gG6m6bBze10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KF3mYi+U; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a51aac16b6eso2371666b.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856599; x=1713461399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUnKZMKowfp4Qt8gTrzPZ01sKLkncud3ZosKL3Vtlpo=;
        b=KF3mYi+UyXbG7SB6S0BvRyOdJJQ4CgwlbCzz5FGyzyiL23P5pzGkDghiRL9/h18TTy
         0DzvAJPAmPDhQhcvBBTJFHPkQLKioFZoqDx8Fzfu1vvDsyoSI374VLgX+XuLlzF60OK5
         JzcSWE+Q9QJa8AoZ9z7TsjQV2VGrWSLtzSBNj6qVwp2VrB3jjUAXrqgVof9J4IXEOXjW
         9zk7LlIEbDhtvStHQdLXiUAh01gv+YXGh6yeByjpS0JxD2lQHIRSKqEP95LZ0tXaap97
         OPClNpLNeMzyKQxXcKdGbiC53GjG34hE7pjdRH0pbjlgQoes1C7OGsp8MWV9PL0udekT
         xJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856599; x=1713461399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dUnKZMKowfp4Qt8gTrzPZ01sKLkncud3ZosKL3Vtlpo=;
        b=ZqldwlswZ712A70Im72M89/NLyBsq/3pujZuxUN4oxvhzYvKgOnNmdFu9ORoWkt2hF
         9p0FH9OTSr3da2+PUXmFVUWs2f5wc8W9UfeIOF0KuAjLj758I8zGIdHlOkxxDS/7D4bK
         ttRAG9FyPhAvJcOhfStOAUPilu583G4FQObhCEQYG4Q3IvKBZaKSk2hP7ayR9wrgDWTU
         Ko0YHVGZGqE8wU2Q6MZaHH/JjKuHhOPOl6cV75ezmRGG6D5Sj8LRlNgHVlYvLAqdsVCX
         pSxg3Cs40IOy6xYB+/EhFa3Fow4nVbAJDxbOp1ASnGipS7Za+QGlRvp2XMmoImnWE/P6
         T7Xw==
X-Gm-Message-State: AOJu0YzWgn1n8BFskyJ4EvCidok8nUv2tLfV/Y7sApwMWCoKV2mP47dM
	fWGJoEbBsEEo2KgVoNBcPA4E7zpXCZ7TzdHCJpdPWNVWPweChHrTL/4mR+Wj
X-Google-Smtp-Source: AGHT+IEzBR8PHq4IWwMyiGKMgBX4NLqcT48CgE5sxw9XekZQcIsa+ULdLkvRupreasCe1ySNHWrGCg==
X-Received: by 2002:a50:9f4b:0:b0:56e:3109:5c7f with SMTP id b69-20020a509f4b000000b0056e31095c7fmr388349edf.26.1712856599126;
        Thu, 11 Apr 2024 10:29:59 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:58 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v6 08/11] x86: AMD SEV-ES: Handle CPUID #VC
Date: Thu, 11 Apr 2024 19:29:41 +0200
Message-Id: <20240411172944.23089-9-vsntk18@gmail.com>
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

Using Linux's CPUID #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev.h    |  5 ++-
 lib/x86/amd_sev_vc.c | 97 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index b6b7a13f..efd439fb 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -71,7 +71,7 @@ struct ghcb {
 	u8 shared_buffer[GHCB_SHARED_BUF_SIZE];

 	u8 reserved_0xff0[10];
-	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
+	u16 version;	/* version of the GHCB data structure */
 	u32 ghcb_usage;
 } __packed;

@@ -79,6 +79,9 @@ struct ghcb {
 #define GHCB_PROTOCOL_MAX	1ULL
 #define GHCB_DEFAULT_USAGE	0ULL

+/* Version of the GHCB data structure */
+#define GHCB_VERSION		1
+
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }

 enum es_result {
diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 30b892f9..3a5e593c 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -8,6 +8,7 @@

 #include "amd_sev.h"
 #include "svm.h"
+#include "x86/xsave.h"

 extern phys_addr_t ghcb_addr;

@@ -58,6 +59,99 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->rip += ctxt->insn.length;
 }

+static inline void sev_es_wr_ghcb_msr(u64 val)
+{
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
+}
+
+static inline u64 sev_es_rd_ghcb_msr(void)
+{
+	return rdmsr(MSR_AMD64_SEV_ES_GHCB);
+}
+
+
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
+{
+	enum es_result ret;
+
+	/* Fill in protocol and format specifiers */
+	ghcb->version = GHCB_VERSION;
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
+		xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0);
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
@@ -65,6 +159,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
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


