Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5794547CA
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbhKQNxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237910AbhKQNxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:53:03 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E315C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:05 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r8so4836277wra.7
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NDbaTNjaYe2ZbbVXbg4qiUbDCW3z4/3XSwkXTX6R+aU=;
        b=JWKBefPSeZl0AkyzexEfNx7NY/HZcQAPzRVuPARGTgYatGU6R+xhD7EEwtOQ6IyNZI
         ZVIOOPSed9h6Vyi1BdErU0qVKPuXrwF7KNUexjGKkVwc8clAfKH9M66VI7HECXarKyeN
         JgdRAH28J+SeRfuw6FKlKFVJmpiNvMVsEmLUuEAOAVUlsmYNIIrd4a+p0Bw0+RhgEH2N
         Vvk8/zbjo7VrLzGuw0II82MJfuPYw2A9RDZnphweI0q3isXIk5RrRVnY9DhDmZS0nBAi
         +hdpWNWK7e47Ae6iX2bHLxYhQEzEGsL8Q3jRQrs788CXv0ZuzeUUQjTuw5+FGu0O3cna
         1Kjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NDbaTNjaYe2ZbbVXbg4qiUbDCW3z4/3XSwkXTX6R+aU=;
        b=OSdYCD4/VNcmYbzdky4xNIwaTCzQFAf6alUghdznjgHYPLcZZsktTUdADdXRQEK2pl
         sw8GnUq0F6G8rCSDW0JzO8IevF3kDmibOC+LoUt9u5r4ythkfgxdGaqdCd4JL6xMav/G
         On49GA/YYx3quCRAsI4OdZ7q8YtSEDjby1o9wnhFdYiD8c6VN8ZTrciLawerJ9x8jeNw
         E4uehLsi+NlKyZIO/zair63ry5qpcSe9Vq9Z0CQwgi5felNfO8Q8A8ISo+myZcjdwBPt
         aL0zDYGP+G/+VZ7AmbXZE7zo2zklwxk51O+LUPXk9X1NvvYbl8LEUBXS4llocSY4G/fw
         6jNA==
X-Gm-Message-State: AOAM533BV+AxavwV1Lf3KKIHycP+rbh6FbA/zZBOtrELRTIdehvJBxEX
        /8uJ9gPOf3t6uXSigo74YAiRDQ+9CEidzA==
X-Google-Smtp-Source: ABdhPJyP2OvzCF308cy0nx4pay3p0z55KUQv9UHTaBx85LFvDesh5hnbZsqQfEt2IQI90kkRr7QXBA==
X-Received: by 2002:adf:fc90:: with SMTP id g16mr19956549wrr.53.1637157003401;
        Wed, 17 Nov 2021 05:50:03 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:50:02 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 11/12] x86: AMD SEV-ES: Handle IOIO #VC
Date:   Wed, 17 Nov 2021 14:47:51 +0100
Message-Id: <20211117134752.32662-12-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using Linux's IOIO #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 146 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 28203df..bb912e4 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -201,6 +201,149 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
@@ -221,6 +364,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_MSR:
 		result = vc_handle_msr(ghcb, ctxt);
 		break;
+	case SVM_EXIT_IOIO:
+		result = vc_handle_ioio(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.32.0

