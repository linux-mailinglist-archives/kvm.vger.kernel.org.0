Return-Path: <kvm+bounces-15337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F248AB329
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBFAE1C2296F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4F4131BA0;
	Fri, 19 Apr 2024 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hs0tcLVx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AA9132478
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543401; cv=none; b=lY7zr/yQM+PA9Sn93qVXjx616AWIXVisYQur/3rX27Nb4e6TKkQ8YQeTjl7tuOnQR0BIRuSLBzC4ShxezsLtLg0uOErV3p0lpMTnaoVuxKHIrU1r7dUw+++Xm3IgMTl8+K1T+wiXyEjJA9t/VBrtxRGL/49oSDDoKNhLeQ6OmpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543401; c=relaxed/simple;
	bh=AxZZDRgU+eSEcOZlh/drCYT330YOmbapHB+yjoCaw38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zpg7WuUwq42huqJ5USPy7lqoqse2DaIA94gCcu7wURg3QSV3hD2/M7fgAQN3SsdjCfZ8myenu6RJ76tRpaDc+5pR3Rs5Q3AfEB3KJn1zTmwtvDWwjf4Gs0ap0oCV7N2Qk0fNUbqO26+Sp3xdmlu9TIgpAeTbkwgMd6gsM4n1I5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hs0tcLVx; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-419ca3f3dd0so3685245e9.2
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543397; x=1714148197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUnKZMKowfp4Qt8gTrzPZ01sKLkncud3ZosKL3Vtlpo=;
        b=Hs0tcLVxMLwPDJvkr3qMK2xO/aKKC3JiDseyLtERk4lI3OSQHPI5o4cxtLS7i78+CZ
         x2zGl6Qy8pkcaoxeld55aP/Hfox8PWhmZyQhV8ee0qqdyAmTd23wfd5xTEXE4Gjz8oM/
         Whd00OCwD2jD3iPczSY3OcjCDUJRE/Qgiro4/cStl7nqagSC0IaeZTxnkotz33dae8Ui
         Po7hcr0IE6L+p1ccmVbTqrTdGXZeszb4gEL3myFM3hiFQzxyD1PjKBSUACjryJ5iT7nC
         NbicwO0o2ZvkHOgJnGGQS4deLpsWL81FYR4xYc2GhgSYDEPddf8KGkxgP2gFn8W03oUn
         Dk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543397; x=1714148197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dUnKZMKowfp4Qt8gTrzPZ01sKLkncud3ZosKL3Vtlpo=;
        b=NQl1RdhMdXrqCOP/pHmCtMYSWFkgdoNtkbYXIQ43U7/LkcwYMI2EAHyFgd7GeTbqqZ
         /hBszt4S41t4ALJrLNXDXngrpcHvH57rr/TY0JOmQJbmq/UYx1GWflK81TbVHZXx+IVE
         V9OkI/45KB6/M6I3cP5i5egP46qhgosLmNoWzT17j0ZNa1grH6LKDC7LwmLu6r57z0ZO
         2KZtoMU0MeioVizIQvx99ylqWai0T/VOPA92lTfGfDgYerfDfNljlykYWwNFGCjKv3p4
         T2N2n0RBITz2KjkcK9kNsX1IWiiFhSZVk0jdmLlbccCMMUmv6zPlciu3sMEhkrpUJig4
         OFCA==
X-Gm-Message-State: AOJu0Yx6OVZfRLyQYwZzSyaMJOLS2U1tMbCq/0/Oy7hxu9OpTsMXrs1s
	G5GdT6j5OXfraJy2tI98plcxfkbjS2kFklVLaqbqurIj0tlTk2drt2GAb30a
X-Google-Smtp-Source: AGHT+IGPst9aGGXzQfBL3g6+33Y+s4z9cVTejBjfLm/tOFB8gmXR3/BnoupwQh7jKi2XtF7u1savhw==
X-Received: by 2002:a05:600c:1f81:b0:418:5e80:a722 with SMTP id je1-20020a05600c1f8100b004185e80a722mr1947459wmb.24.1713543397354;
        Fri, 19 Apr 2024 09:16:37 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:37 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v7 08/11] x86: AMD SEV-ES: Handle CPUID #VC
Date: Fri, 19 Apr 2024 18:16:20 +0200
Message-Id: <20240419161623.45842-9-vsntk18@gmail.com>
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


