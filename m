Return-Path: <kvm+bounces-14301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B78F8A1DDA
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F0F81C24C24
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62AF95FB9B;
	Thu, 11 Apr 2024 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDvKekNp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99BA5C90A
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856606; cv=none; b=jLSZTulz80A/k5L/HsE0yG4pMwAJ5tFsYidp2ItYjCmaJqt4utFFAXSq1UQNTQNq+jt6jbGk1kHaYfVAF3wWI/mxsCyCqNDUBTzZgVPXXn5kHnWlud9AMOvmlBb8T8rUPRjW84lCiampM03woQMl1smDtOzYLUk2lWL8RXQPVLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856606; c=relaxed/simple;
	bh=YuFDJE/wvFIMDYGI3Kr0F1RU/i0Mx/EO9bllQc/g96Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gb/uNHevt5smgvS7ct+nZWV0KjiI0d4G9NryIwaqzgobNCpvSlk35HC1saDWDKnAgtT7q0gmCNWiwjTFvwcdxmhwXjUB8fTs6hVDP7L1cPiQroHicdxZ9e18XkUylJJQGXy6ajMNZ0gBOvTfjj51DTkrSYBf6s9j2IbbmIn+BZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDvKekNp; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56fe8093c9eso17219a12.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856602; x=1713461402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtxdt+LBIR9Einmre3CMmnSZ5hxztcXuD5FZkUy/AlQ=;
        b=RDvKekNpTjKMUXusw5SbZFoidmBpHAP6/3Ofq7SD09nIkp86p73VcL0s5Z/LEWxMCG
         +92PCz5QxAh78HGadplg1ba/y9zHzy+qloYcznIssmXub70ZQm60VsIXMcgq4F4DroJV
         jt2okhiO52Lng6sMgI2fLEL9IQVRJzVsm8Yq+UvD7Dg+1vQ2d5ObSGj8QcZeiDHZW803
         MmdeYPW/YTL17DlfY5YMdc/DN3Q1Jco97L2HG91urq4i5a9oNg1xVWKNkMBk4og7I1dI
         A3MUZG81yAAV8S82oERf8qpCuoaFrWFCqmyXMHEh+wI5a2i73379UjuXwUtnMLxI+tkH
         ZnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856602; x=1713461402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtxdt+LBIR9Einmre3CMmnSZ5hxztcXuD5FZkUy/AlQ=;
        b=gPqXxUNp7DEd+YY4dhRyJWzC93NWV0OP+oHku7PQsH57lgG6p0asXC1Y/WBVsnM1UC
         qT7C9Z3985yNDjl+qH43wKlsPyoloPnxXBzSNL/8A4pAd78uBM1h41nJjU8WW4lkeDg7
         UegffUDRJmIu8COTf1pYsHnCUuHNhJlhpMemvcHnsEGBxzMuGMmagIRz5TBhucucEK2n
         5yWjQLR/gpli4BjVPUn+JOiU8fk/Qhs7L5l9tpfl/BVUAfCqJvZ3vIGNR5of2mfV8fc5
         fG3xfuCKiAB5WdOU2acRtLMnuw1FFA/ZhzxFRSR2vzNKASlY4zHu2PtIHA9+wphEkRW/
         1lDw==
X-Gm-Message-State: AOJu0YyeOT/B8lxFtVgNNEAaMhssJ0DwY2XpDfh86n7zc21GHLeCv0De
	crkUTe5X7r6XH1GvUE17NHV3OPU5tj+MPjkAZTKzcfisnpgDYSDNQDvplWXI
X-Google-Smtp-Source: AGHT+IEYXkHTyM2O7PDaCNyEMJpxjUJOUyjBAJSrLrrC2ow3qnMEQa+OGV1m4N0J32C7psKuN+gFCw==
X-Received: by 2002:a50:8759:0:b0:56e:309f:4cb3 with SMTP id 25-20020a508759000000b0056e309f4cb3mr271854edv.16.1712856601675;
        Thu, 11 Apr 2024 10:30:01 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:30:01 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>,
	Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v6 10/11] x86: AMD SEV-ES: Handle IOIO #VC
Date: Thu, 11 Apr 2024 19:29:43 +0200
Message-Id: <20240411172944.23089-11-vsntk18@gmail.com>
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


