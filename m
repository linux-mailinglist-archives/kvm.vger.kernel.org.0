Return-Path: <kvm+bounces-19462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17ED9905592
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B58222898AF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E429217FADD;
	Wed, 12 Jun 2024 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z09m3mTM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D6E17FABC
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203562; cv=none; b=mP8gGHYiHosl78Mxe1rN2wfGIU/MTSXfe0CaEE92zipvHzYjrdWRY8Omch1O0dJZE8fM5DESAxcArZIUM34Bcdle80QohVnoq28ebIwl/fjX3bvaw0Y6hzt9oxZtILpDgbnbXsSK8PnXoRaJQ1qq/Gnen04CfEiUvkwzpNPTjuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203562; c=relaxed/simple;
	bh=ADSy9qiOVZPb69AWewC4lMF1QZ1Yc+pUnevzFE6jw2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mDsJNY6w6bzo0sp4qhHIU7OI0h27eaEd8LnpGeyk3gqNmNbL7f1Q2PsKmNRx+/9URdFdvqGCorxGbawOfbTTb80vvveUK0WEtAQObkm+itSI6lCxZhvY/l/Qas8eXeOxGBMWLRPOCjHtAk5BPXTbf9kB4VFl3i/CrM1Mg8M9R0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z09m3mTM; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a6f09eaf420so464482266b.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203558; x=1718808358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmMu36s/tTTZOWVF+OkMRemw2+tCfV7gSSWNOOYUC5s=;
        b=Z09m3mTMFl+GXNwBPb2BRoOD7z952Ok2vTc1m4NUBsPLKpb/ugtRmoOeXdJkw2Getw
         88e1pyq72MGW/RE/BxdCqdF5+3NEUc6WlMIbIzFqxL+r1y13Q9WgQZX9XQGBZKGq04z1
         gTpF9cWaswvYfwNuvH08fjkntfSZBcrQ+ptAliF26120UX8w4iqjChgQoUrtaAHJ6Em1
         doni+bdbj64rIsehU2dCC/Bzl7MMbslFhh5jXlAaWz/+45sEorz/jghiwaOZoik1LdKi
         in5ZyGG6iFr9TM7iCsT6c4kDr/RkJNcWSeMeoUtIMqOqWK/u0i5sUJsNVc75FjnpamaV
         tuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203558; x=1718808358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LmMu36s/tTTZOWVF+OkMRemw2+tCfV7gSSWNOOYUC5s=;
        b=DNqrmo5fV5+XKgJ8TBvWtkW5LBmMn3kW7lCXIDXhuWNZNUCqbqSBfOz6iufs+iddYJ
         mPOeJATfgXBVOO242f4SBnnRdfmvS488KshdSUV792cULObGHeR2+uk+SUTzHKTn5pEL
         qnaQhU0YFwIxkL3q/+PQ+UK5FhIfHiiuH0WzrMCBL0oggn805sUVBEspwvym+9HqkI3Z
         VZJMXoqFGOh4kmYSRnFmkdodZ9CT+4oB39lfbyciv7d/MFBYU9QRGbQJZTobdmuQPWKs
         paWjWgqlh9NAgynTwoT4f42a0g2z6uvAqfVwXCuvKEKBZGh5dkZIf/O9qghldVAe1RJ2
         urjg==
X-Gm-Message-State: AOJu0YzV5Qm/0wPS3DdsjR/X5y4F/fzX8i+sHEZXYXuSurkGuqtypHGl
	xsWmDjstJFfFotUelkXEn7hjsHPoKnY/fr3xJX4fdOenuYaHExCoihrYfcuC
X-Google-Smtp-Source: AGHT+IEEszAid0vXSJ1DflYJuzp3wbER50YuS8o5noYd7Z/h1t/YaVjxkz74c8Q5zn24M1e/i1K1HQ==
X-Received: by 2002:a17:907:9485:b0:a6f:201a:299a with SMTP id a640c23a62f3a-a6f48013ba4mr151708066b.60.1718203558068;
        Wed, 12 Jun 2024 07:45:58 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:57 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 10/12] x86: AMD SEV-ES: Handle IOIO #VC
Date: Wed, 12 Jun 2024 16:45:37 +0200
Message-Id: <20240612144539.16147-11-vsntk18@gmail.com>
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

Using Linux's IOIO #VC processing logic.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev_vc.c | 150 +++++++++++++++++++++++++++++++++++++++++++
 lib/x86/processor.h  |   7 ++
 lib/x86/svm.h        |  19 ++++++
 3 files changed, 176 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 72253817..0cdb9c06 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -165,6 +165,153 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }

+/**
+ * insn_has_rep_prefix() - Determine if instruction has a REP prefix
+ * @insn:       Instruction containing the prefix to inspect
+ *
+ * Returns:
+ *
+ * 1 if the instruction has a REP prefix, 0 if not.
+ */
+static int insn_has_rep_prefix(struct insn *insn)
+{
+	insn_byte_t p;
+	int i;
+
+	insn_get_prefixes(insn);
+
+	for_each_insn_prefix(insn, i, p) {
+		if (p == 0xf2 || p == 0xf3)
+			return 1;
+	}
+
+	return 0;
+}
+
+static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
+{
+	struct insn *insn = &ctxt->insn;
+	*exitinfo = 0;
+
+	switch (insn->opcode.bytes[0]) {
+	/* INS opcodes */
+	case 0x6c:
+	case 0x6d:
+		*exitinfo |= SVM_IOIO_TYPE_INS;
+		*exitinfo |= SVM_IOIO_SEG_ES;
+		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		break;
+
+	/* OUTS opcodes */
+	case 0x6e:
+	case 0x6f:
+		*exitinfo |= SVM_IOIO_TYPE_OUTS;
+		*exitinfo |= SVM_IOIO_SEG_DS;
+		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		break;
+
+	/* IN immediate opcodes */
+	case 0xe4:
+	case 0xe5:
+		*exitinfo |= SVM_IOIO_TYPE_IN;
+		*exitinfo |= (u8)insn->immediate.value << 16;
+		break;
+
+	/* OUT immediate opcodes */
+	case 0xe6:
+	case 0xe7:
+		*exitinfo |= SVM_IOIO_TYPE_OUT;
+		*exitinfo |= (u8)insn->immediate.value << 16;
+		break;
+
+	/* IN register opcodes */
+	case 0xec:
+	case 0xed:
+		*exitinfo |= SVM_IOIO_TYPE_IN;
+		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		break;
+
+	/* OUT register opcodes */
+	case 0xee:
+	case 0xef:
+		*exitinfo |= SVM_IOIO_TYPE_OUT;
+		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		break;
+
+	default:
+		return ES_DECODE_FAILED;
+	}
+
+	switch (insn->opcode.bytes[0]) {
+	case 0x6c:
+	case 0x6e:
+	case 0xe4:
+	case 0xe6:
+	case 0xec:
+	case 0xee:
+		/* Single byte opcodes */
+		*exitinfo |= SVM_IOIO_DATA_8;
+		break;
+	default:
+		/* Length determined by instruction parsing */
+		*exitinfo |= (insn->opnd_bytes == 2) ? SVM_IOIO_DATA_16
+						     : SVM_IOIO_DATA_32;
+	}
+	switch (insn->addr_bytes) {
+	case 2:
+		*exitinfo |= SVM_IOIO_ADDR_16;
+		break;
+	case 4:
+		*exitinfo |= SVM_IOIO_ADDR_32;
+		break;
+	case 8:
+		*exitinfo |= SVM_IOIO_ADDR_64;
+		break;
+	}
+
+	if (insn_has_rep_prefix(insn))
+		*exitinfo |= SVM_IOIO_REP;
+
+	return ES_OK;
+}
+
+static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	struct ex_regs *regs = ctxt->regs;
+	u64 exit_info_1;
+	enum es_result ret;
+
+	ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
+	if (ret != ES_OK)
+		return ret;
+
+	if (exit_info_1 & SVM_IOIO_TYPE_STR) {
+		ret = ES_VMM_ERROR;
+	} else {
+		/* IN/OUT into/from rAX */
+
+		int bits = (exit_info_1 & 0x70) >> 1;
+		u64 rax = 0;
+
+		if (!(exit_info_1 & SVM_IOIO_TYPE_IN))
+			rax = lower_bits(regs->rax, bits);
+
+		ghcb_set_rax(ghcb, rax);
+
+		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO, exit_info_1, 0);
+		if (ret != ES_OK)
+			return ret;
+
+		if (exit_info_1 & SVM_IOIO_TYPE_IN) {
+			if (!ghcb_rax_is_valid(ghcb))
+				return ES_VMM_ERROR;
+			regs->rax = lower_bits(ghcb->save.rax, bits);
+		}
+	}
+
+	return ret;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -178,6 +325,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_MSR:
 		result = vc_handle_msr(ghcb, ctxt);
 		break;
+	case SVM_EXIT_IOIO:
+		result = vc_handle_ioio(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index e85f9e0e..a7dd3de3 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -853,6 +853,13 @@ static inline int test_bit(int nr, const volatile unsigned long *addr)
 	return (*word & mask) != 0;
 }

+static inline u64 lower_bits(u64 val, unsigned int bits)
+{
+	u64 mask = (1ULL << bits) - 1;
+
+	return (val & mask);
+}
+
 static inline void flush_tlb(void)
 {
 	ulong cr4;
diff --git a/lib/x86/svm.h b/lib/x86/svm.h
index 01404010..96e17dc3 100644
--- a/lib/x86/svm.h
+++ b/lib/x86/svm.h
@@ -151,6 +151,25 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)

+#define SVM_IOIO_TYPE_STR  BIT(2)
+#define SVM_IOIO_TYPE_IN   1
+#define SVM_IOIO_TYPE_INS  (SVM_IOIO_TYPE_IN | SVM_IOIO_TYPE_STR)
+#define SVM_IOIO_TYPE_OUT  0
+#define SVM_IOIO_TYPE_OUTS (SVM_IOIO_TYPE_OUT | SVM_IOIO_TYPE_STR)
+
+#define SVM_IOIO_REP       BIT(3)
+
+#define SVM_IOIO_ADDR_64   BIT(9)
+#define SVM_IOIO_ADDR_32   BIT(8)
+#define SVM_IOIO_ADDR_16   BIT(7)
+
+#define SVM_IOIO_DATA_32   BIT(6)
+#define SVM_IOIO_DATA_16   BIT(5)
+#define SVM_IOIO_DATA_8    BIT(4)
+
+#define SVM_IOIO_SEG_ES    (0 << 10)
+#define SVM_IOIO_SEG_DS    (3 << 10)
+
 #define SVM_VM_CR_VALID_MASK	0x001fULL
 #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
--
2.34.1


