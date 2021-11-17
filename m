Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8A14547C5
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbhKQNw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhKQNw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:52:57 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B39C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:59 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id u1so4796455wru.13
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p8KeZQrCQfErvYWz185pteTDx7tPqAujEBCarpF244o=;
        b=ockIJ+JMLq68f2tM3H2s6fTrwl7/gpEg2nwHAn6wTbsQziBaYdaFeixUwtGIUoM8jZ
         hsbn7zHE3yyHMJlkv9MR/52OLg4nvY0gLWeLPb5abPqw9Qdvi7tE45XogPW4iWEyVoHw
         oOaxMxLkJcJqnQVOh+AXLH7ur4FMIgv2Tqgrq24IrbsKAAKgLo/xK1n0s6g8kDhlbT3r
         CgT4bL/kAu9HZZPVXlyE6vm3IKmSKJw0JfE/pis1p0FZGumPo7FEV75Un3cJDa9PT2Xs
         CBJA1NULlLnJ5tNFCftEioP48Djx4w+xOQOKDO45ZbFA1g6fuElPNKrXe9aIlwHEI8ch
         ux/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p8KeZQrCQfErvYWz185pteTDx7tPqAujEBCarpF244o=;
        b=vdDSzvknVcLaikrY6ki4g/iGij7nbgIVb6POWMQjVUiO79TOM+TollrmvawKDJuwnu
         y8JoUdmfZ+98FwS9alfvaAWsoiQHwq5+CCbv3Js+aU9GAyqBaOnhbT/BbLH4HHbaHz5P
         a+OG3QAtyuRrbR/Q1mdv0HBG1TNUoN6gmN0u/oqC++9Lns4/1026+YHcGawtQJFBtOew
         1CipsQVqjDSxL4MKQV0ae0tnqSfc3jNrG5mUQwk8caQtgamybyquJFZPZXJJj7QkXd45
         VbnbG9RS7Itsn47r9VnZj+lvEou3AC7SU44I6Pb8W0tK1t3w14J6beGV/RoHDE3zA1hQ
         BXrQ==
X-Gm-Message-State: AOAM533DpazXD8Xc/gI9iSPg6YNwmVBJyy8YqdTV743e/YIW1Ysrbg8j
        3lWJ6vV4+0iFra5Vg4Q8U7NS0mC79S7/yg==
X-Google-Smtp-Source: ABdhPJxcup74c2MG6X2N2/YapFwXpEayi9NlNxPRA+TcsYE8pW7cUUuz/On0LKS1KQl2X42/4EbfZA==
X-Received: by 2002:a5d:604a:: with SMTP id j10mr20665738wrt.93.1637156997481;
        Wed, 17 Nov 2021 05:49:57 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:49:56 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 06/12] x86: AMD SEV-ES: Handle WBINVD #VC
Date:   Wed, 17 Nov 2021 14:47:46 +0100
Message-Id: <20211117134752.32662-7-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Linux's sev_es_ghcb_hv_call helper to allow VMGEXIT from the #VC
handler, and handle SVM_EXIT_WBINVD using this.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 142f2cd..27a3ed0 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -52,6 +52,69 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->rip += ctxt->insn.length;
 }
 
+static inline u64 lower_bits(u64 val, unsigned int bits)
+{
+	u64 mask = (1ULL << bits) - 1;
+
+	return (val & mask);
+}
+
+static inline void sev_es_wr_ghcb_msr(u64 val)
+{
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
+}
+
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
+{
+	enum es_result ret;
+
+	/* Fill in protocol and format specifiers */
+	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
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
+		info = ghcb->save.sw_exit_info_2;
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
+static enum es_result vc_handle_wbinvd(struct ghcb *ghcb,
+				       struct es_em_ctxt *ctxt)
+{
+	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -59,6 +122,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	enum es_result result;
 
 	switch (exit_code) {
+	case SVM_EXIT_WBINVD:
+		result = vc_handle_wbinvd(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.32.0

