Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E9F4547C9
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbhKQNxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237913AbhKQNxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:53:02 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3E8C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:03 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 133so2327677wme.0
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M1MEse5p7/fJYVVFUEj965Jy3nzW7hAymJpv/qrLcpM=;
        b=OrLjQ3+CR74fLTt56/e1sQqgLOnwoAvGA0c30S11sh1ZB4b8sqmzUVtbmo3MAuvUqG
         TbhZ4NXVcpxDAwDAg3a0s1CstkLmad3trxZ1Mdj8kqjCityElIOg5mbhXEKVrXsOp183
         pI3v7IiwQoZsLUqX5uHu8PjBHM2KNkg/nQO41Wo5O1zxKNDCeLiTBzIlNc/viv+O9DVi
         hYCKBW7Jtx1rpMtE1vzlhrt1lJffpkG3dkSXB9laCC9Lj9F23fRcYu1vjsQSZ/ZjPdYk
         8zoqGsfNG3splDTCvNLGSIrnsE+Kyeez+DWZECgnS+FzaB27NKyz2OfcIxZl69LsIzEH
         14Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1MEse5p7/fJYVVFUEj965Jy3nzW7hAymJpv/qrLcpM=;
        b=dkjN/UnnzCZbGQg8w3EySum4g1n52FdXHmLEYY7+Ivv46uMzXYv+1jmyAXEsGUyYvr
         3ai96GySBkQuwDFDMwbtjzFrZ5dAKBlc0s/5l0CLxBX1UtLXhlEhrfZoTMpAJj2XFjOJ
         E+5yfp3N/SALML45Xo2zy4034DQ1XtDWVDwp6I3vp8ZNzcsuMZ0SFZnHcCwGUIVwtXaQ
         TxqKphRs3ZNoc8eEGz3ezOtTFX9qQAFvBf2UKR4oofEt9ltLSeTMw30VVcVofNGTlSqH
         Uh+grzkQwvQLhb3p0Qmp5c0KSKfHZ0OCUoYen6xocqz9Nfa3hbJ1tKcyN2inWoePv2d8
         L5Hg==
X-Gm-Message-State: AOAM532u5yWcHImoMma/lySpDezXZzybhWW6D9Zqexhr7iNck8VCfpb2
        AjgYQkNbpgs1PPLHHtFTQZFrq5s9NgIPsw==
X-Google-Smtp-Source: ABdhPJzNVev0paZ6aj/z+ac237mOEp5QG5fYTeeexELMegr2ny6X44mB27WIyB3DhREMuyddAV3ytg==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr80047876wma.85.1637157002159;
        Wed, 17 Nov 2021 05:50:02 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:50:01 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 10/12] x86: AMD SEV-ES: Handle MSR #VC
Date:   Wed, 17 Nov 2021 14:47:50 +0100
Message-Id: <20211117134752.32662-11-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using Linux's MSR #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 45b7ad1..28203df 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -176,6 +176,31 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	return ES_OK;
 }
 
+static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	struct ex_regs *regs = ctxt->regs;
+	enum es_result ret;
+	u64 exit_info_1;
+
+	/* Is it a WRMSR? */
+	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
+
+	ghcb_set_rcx(ghcb, regs->rcx);
+	if (exit_info_1) {
+		ghcb_set_rax(ghcb, regs->rax);
+		ghcb_set_rdx(ghcb, regs->rdx);
+	}
+
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MSR, exit_info_1, 0);
+
+	if ((ret == ES_OK) && (!exit_info_1)) {
+		regs->rax = ghcb->save.rax;
+		regs->rdx = ghcb->save.rdx;
+	}
+
+	return ret;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -193,6 +218,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_RDTSCP:
 		result = vc_handle_rdtsc(ghcb, ctxt, exit_code);
 		break;
+	case SVM_EXIT_MSR:
+		result = vc_handle_msr(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.32.0

