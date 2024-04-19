Return-Path: <kvm+bounces-15340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E750B8AB32C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1473F1C2254A
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937551369AA;
	Fri, 19 Apr 2024 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nl5xXH1b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6A01353E8
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543405; cv=none; b=e7UlXljU6qzJBMugzBN536aXcJh3ycFEgzjnuXQKK6FVZ+t91T74SmtrQUMMKGrF4+tmqpXrCjwfOpRr0ptewm1nbZVtldapZgjW0l3Vt3Fn162nmBoSQ/gJf0n4BmQgIt+6xsmMhG5Kz+ZcVgHRRd+tANCeh743VxodOgg2i0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543405; c=relaxed/simple;
	bh=YuFDJE/wvFIMDYGI3Kr0F1RU/i0Mx/EO9bllQc/g96Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BK1qEK1Rui//lTEzvsRCpbq0cfVu0HlCbTdCIRhqE4zSjqbFSiJ4Iljevj7C4M9VBJLnGiH792hjiAZK3QJ5NQbEbRoqkwP1H15bg+fUIyEik+NKY5X1/QK46IMh2G+4Q3Ivn4AUb2lqpuyCGiKG5Y1jK8jhqY7TJ2vdQVmaVCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nl5xXH1b; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-419d320b8a2so1218525e9.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543400; x=1714148200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtxdt+LBIR9Einmre3CMmnSZ5hxztcXuD5FZkUy/AlQ=;
        b=nl5xXH1bH6iwdCl1EWubFlQ5+2KJYLhZ+y/a6GDbm5QbLIeaVuJ4RlHz9kgYZC6Mz4
         HYhMip51W6BzX6gOfM17mA5OJi1gOY1CHmNEYgDDODEcDhsjEvTx+S0+cAvKQ2taPDJG
         TiJIEq8RtZXvUzk98pTaBL0W40ZlAmx3UKhbnAMGGG1fHqYNYfe34Bo2zSDBAnEP9YzI
         jX6McDnpGu/JURIomWnItRMKzKT2pB6vyF+mtemXSIHVCR2VMApIHmDCZxFlqG6FERh5
         bSuDsc7rt0khp1bEdc9IKvZVVv/OWNc03zmoPFxCfCGQdDAyL9B3JPYg9mOrX//tTt+A
         D1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543400; x=1714148200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtxdt+LBIR9Einmre3CMmnSZ5hxztcXuD5FZkUy/AlQ=;
        b=VH5qHG/aAufOhzYBfmJyDuEvmT20fMJ4aD9xEAGaBrRlm/YbjwO9GG7epDdVU1BOiU
         bdbk2FKk30mNfRdLxSxhIeU2IcRgI2BPEaXuzOli7CUSVw4kARV+dK0g6PSgVaSFtGg1
         LCjyPUCoKzLR73UyZHh8grhQjXBYNehJJKSCYn4cDmhPi+kE70zMH1bCjTghuNYD5deJ
         3EvZ3peIjEZpErefauGhIz/j8228wumh1dhrxlH3QW5kBpV3dGm4E72oQGOXjtKZzG2b
         sdyt9y8xcqLnNpPlcaPGeKA463DnSFIcveSnll/vFk6oek5jONkYV5+dfFh4Y8nYu3tf
         drMA==
X-Gm-Message-State: AOJu0YyI6WNC8o0WJbPsdO+PIOK+d77z8iF6QL6z8WEOgvx2IZQvDnAW
	A8ojI7AUrJlXjjPIWWcAT7yxF21LIj8knRRgDwtV68avP6iANdoV0zZhQ0Ai
X-Google-Smtp-Source: AGHT+IEc4AVV7uNIoKNdtllMLnb/if5TDg/34HriKxEVhOdrzCxbWo/YYOoZUepZ4ujeT/YNGiJi0w==
X-Received: by 2002:a05:600c:4587:b0:417:d43e:8372 with SMTP id r7-20020a05600c458700b00417d43e8372mr1860430wmo.16.1713543400070;
        Fri, 19 Apr 2024 09:16:40 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:39 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>,
	Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v7 10/11] x86: AMD SEV-ES: Handle IOIO #VC
Date: Fri, 19 Apr 2024 18:16:22 +0200
Message-Id: <20240419161623.45842-11-vsntk18@gmail.com>
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

Using Linux's IOIO #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 lib/x86/amd_sev_vc.c | 169 +++++++++++++++++++++++++++++++++++++++++++
 lib/x86/processor.h  |   7 ++
 2 files changed, 176 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 6238f1ec..2a553db1 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -177,6 +177,172 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }

+#define IOIO_TYPE_STR  BIT(2)
+#define IOIO_TYPE_IN   1
+#define IOIO_TYPE_INS  (IOIO_TYPE_IN | IOIO_TYPE_STR)
+#define IOIO_TYPE_OUT  0
+#define IOIO_TYPE_OUTS (IOIO_TYPE_OUT | IOIO_TYPE_STR)
+
+#define IOIO_REP       BIT(3)
+
+#define IOIO_ADDR_64   BIT(9)
+#define IOIO_ADDR_32   BIT(8)
+#define IOIO_ADDR_16   BIT(7)
+
+#define IOIO_DATA_32   BIT(6)
+#define IOIO_DATA_16   BIT(5)
+#define IOIO_DATA_8    BIT(4)
+
+#define IOIO_SEG_ES    (0 << 10)
+#define IOIO_SEG_DS    (3 << 10)
+
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
+		*exitinfo |= IOIO_TYPE_INS;
+		*exitinfo |= IOIO_SEG_ES;
+		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		break;
+
+	/* OUTS opcodes */
+	case 0x6e:
+	case 0x6f:
+		*exitinfo |= IOIO_TYPE_OUTS;
+		*exitinfo |= IOIO_SEG_DS;
+		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		break;
+
+	/* IN immediate opcodes */
+	case 0xe4:
+	case 0xe5:
+		*exitinfo |= IOIO_TYPE_IN;
+		*exitinfo |= (u8)insn->immediate.value << 16;
+		break;
+
+	/* OUT immediate opcodes */
+	case 0xe6:
+	case 0xe7:
+		*exitinfo |= IOIO_TYPE_OUT;
+		*exitinfo |= (u8)insn->immediate.value << 16;
+		break;
+
+	/* IN register opcodes */
+	case 0xec:
+	case 0xed:
+		*exitinfo |= IOIO_TYPE_IN;
+		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		break;
+
+	/* OUT register opcodes */
+	case 0xee:
+	case 0xef:
+		*exitinfo |= IOIO_TYPE_OUT;
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
+		*exitinfo |= IOIO_DATA_8;
+		break;
+	default:
+		/* Length determined by instruction parsing */
+		*exitinfo |= (insn->opnd_bytes == 2) ? IOIO_DATA_16
+						     : IOIO_DATA_32;
+	}
+	switch (insn->addr_bytes) {
+	case 2:
+		*exitinfo |= IOIO_ADDR_16;
+		break;
+	case 4:
+		*exitinfo |= IOIO_ADDR_32;
+		break;
+	case 8:
+		*exitinfo |= IOIO_ADDR_64;
+		break;
+	}
+
+	if (insn_has_rep_prefix(insn))
+		*exitinfo |= IOIO_REP;
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
+	if (exit_info_1 & IOIO_TYPE_STR) {
+		ret = ES_VMM_ERROR;
+	} else {
+		/* IN/OUT into/from rAX */
+
+		int bits = (exit_info_1 & 0x70) >> 1;
+		u64 rax = 0;
+
+		if (!(exit_info_1 & IOIO_TYPE_IN))
+			rax = lower_bits(regs->rax, bits);
+
+		ghcb_set_rax(ghcb, rax);
+
+		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO, exit_info_1, 0);
+		if (ret != ES_OK)
+			return ret;
+
+		if (exit_info_1 & IOIO_TYPE_IN) {
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
@@ -190,6 +356,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
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
index d839308f..661ded31 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -835,6 +835,13 @@ static inline int test_bit(int nr, const volatile unsigned long *addr)
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
--
2.34.1


