Return-Path: <kvm+bounces-19460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42703905590
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B9731C20336
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA7317FAC2;
	Wed, 12 Jun 2024 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlEassWS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3143417F514
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203559; cv=none; b=axr/WB3yQXGl5exgQr8RsJVGsSeb9OmdQOSAr4vrx8K5FH5BRma8aLEUO/Y2UmdP9LETBoHQEsds5jiEaoWDKZ+9imVCUtvT7e0PLrqkZrpWMqyJZJnFr2oRm0Mz1YJb5wTisQOX+kqu1EkHj8bzi51pxkGh8HZkGsKkz30ZeCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203559; c=relaxed/simple;
	bh=pWEo4rehcTpG5+D1JR3lXzd0VUms7x1yeKkMzdClPaE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t3hiJAam9kupMZHU9mZ/A1so5DXUZ+u2kw9eE8n6NhT1NMcShL9mY3/TEqa96QNZXM3KhMJjf+EAh67BpxeHb0q+NTzneYCpqCDVcFjDmXskvDHufrs/tthjfon82ZLa2W2PUtVxrtZqN+QAYWOycypeY0cBlXeo9vG9ZQJbjmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlEassWS; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a6f3efa1cc7so179301466b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203556; x=1718808356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPmf+ULw9UxGqX77U4KfH0lMoJbFqr1mImBQcazrTZk=;
        b=FlEassWS/fRwqgvqRLGm03fNyPAbT0JSlVDXtMT+gz4DHPPHmMvspWvg9Tzh5CwN/C
         P3x+bvS+98SKjJAOCmiNfae3n6mCfQeovtFp8EvztqGCisrbq52nqfEm2C07/7Qf+uNc
         yo5qiWpLcMd9R3uduwf1Yh6APpv6/EcVrwYxMqG1n3EZzNizY75eso+imU6upCK756+s
         D1W3DebYjX85vF3wLkewC7WE3JazzjcC8IQXk1XgUfx4TBA2sMqWrPCF4NnEaolRCSDM
         xh/ATu95JJKzId2/xdibrT2+2Y6UgaIIlCa27UZq9ND/WfRUWGYu0LqLzAO5WI5EB4mG
         fUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203556; x=1718808356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPmf+ULw9UxGqX77U4KfH0lMoJbFqr1mImBQcazrTZk=;
        b=ZUl8E6ELQXpurXRT1K8HEMz7ynuRmSE4buv9ch8PzAb+0Zh513sYc4B45f9SdAkizp
         BFcOE0uowQMntP/d/BUqGh7q2+Hw7vBV1l3sAXrTQTqQyxe3X7TlbOnaHef3x924JHUX
         RBH0eruTEvUFtMizbtQlQm0FHqi8ePc/Nf2bdIwDpjjpYe15YBr1p5X4nSCXf++49u9x
         X/maysIyg2E2/lxErSRLTHrxMc/vmA/AjmMLkjutDzFQWBuYRfbvWQWV2IlBYefIfWmn
         Rugy8YFFN7NwtotNGkk/Ahg56Wxy0+KNWnVyu1Ybx5Sf0nTNkbCsoehP8TtINL2gYvCr
         ap4A==
X-Gm-Message-State: AOJu0YzFUsvu90qijz0Q6P3qtFnLhILKC/mDJSUf15fbGX4W77QqHcWT
	bZVdPS09DkwMV5nThDFuSXpuhrC16zSo+AR36snp13E2cjMZVE8yaYVr8IPs
X-Google-Smtp-Source: AGHT+IHgyh+3DozoxpWdiGogxIKvfwBWYPSgnUbnEigcpdB/MdyPoWhFal9G9AzFsz1t4A2XkLIyaQ==
X-Received: by 2002:a17:906:328f:b0:a6f:4ebd:1463 with SMTP id a640c23a62f3a-a6f4ebd1d37mr46815266b.20.1718203555952;
        Wed, 12 Jun 2024 07:45:55 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:55 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 08/12] x86: AMD SEV-ES: Handle CPUID #VC
Date: Wed, 12 Jun 2024 16:45:35 +0200
Message-Id: <20240612144539.16147-9-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240612144539.16147-1-vsntk18@gmail.com>
References: <20240612144539.16147-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

Using Linux's CPUID #VC processing logic.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev.h    |  5 ++-
 lib/x86/amd_sev_vc.c | 85 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 1 deletion(-)

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
index 30b892f9..39bca09e 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -58,6 +58,88 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->rip += ctxt->insn.length;
 }

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
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, __pa(ghcb));
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
@@ -65,6 +147,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
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


