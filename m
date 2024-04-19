Return-Path: <kvm+bounces-15338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79AFB8AB32A
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABFCC1C21094
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F39131193;
	Fri, 19 Apr 2024 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fgpGm9ps"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1001350C9
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543403; cv=none; b=FHb6KVBajAoD/N7dPLQVM9tow402bICUctiLwJNH6uiaRMOuJxAOZMMztckg8RqLumAwGnbj/uYk71U2gFX53vYUJ7KjkxEfFvTMNBn7MUVpT86wmPE8HrLpUv6rC7iRtDa8ImSbcLHXw1XFLfwXimRtQ+IhWGzDAxxgmFCePto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543403; c=relaxed/simple;
	bh=1GxL/oJpcyYuX9NtGVsxli4LDXyGM2BL9sO0AZ8FiUA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oEX1wzkjL3QeHt8vELL8sVp4aNivACx48s4N5mVDaivzedkopt5blcm4L6JRumjP2ixfsIKDy1udIi0MZxj14V87zUnwvbNNQq6lFHui88/MMkXfXWRmBW3sXRD2PGrKNQlvUs/F8os9w5aXIGt9/sPrnpg4lldpzfG1JU7qGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fgpGm9ps; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2db9b517b8fso20900541fa.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543399; x=1714148199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jDE00WwzhDb1yJIkvlhhPiHlKzyZ8ykUSnJN0b3SuA=;
        b=fgpGm9psdOrVID7yDqLVLvDVKS++1MQYiCjUucaDL5pDB0M7qjn10QNJ1V3iaLTDsL
         yEhGc/Gfkvr/LIxiMYww7lIFS/bULSQXV2LKjOX+i0gSB8hFUnq/ueEZjIv13IUL8Xqs
         NMW+SdoOLbOnKqsSglgCOmPYaIUnrD3he2pwRg5tUENlzgWtAjPDHPEdzU09AyHPNvhE
         ugJ2lxQcLSgzIKc4jgRBkJ5foahgYTSOWG6gaWNGuc6Q7/UAtd8gvCnmvlw7iFqPMz1E
         VDQoWP69wSLOh5O/wPz3b8kyeciie1x8cnLT0Yz46NK+k2ZyMGieQ9ObMxh16OGFq8aq
         tkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543399; x=1714148199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jDE00WwzhDb1yJIkvlhhPiHlKzyZ8ykUSnJN0b3SuA=;
        b=QylD0eI9CP051wwLkRSZ0E6ZfzyeafWJgs98lzr8yh3yfh5jxdsAF52KF6sg+plyxO
         qPcKMUogf3Nq87JHfKMd7ewWELN2nMfD45bEVvFvcTAHLRTYXexxPveZA/Ezu3B3ZB5d
         pMyhan3Ld1neTTyVllF7XeZOEXq7KLcRplB5t2Gc3J5V2mOPsUmMHIANsXRIvFGd2mAL
         PRIiwjL+mfVihbW+2ubdNtHib2OBraETG/+aet6FRyerKHJ4rUoVcFY7TMAoRzB3Avij
         t8t82ffCgi9NIuOfqKVdArMhzWEKp2amh6WY4uWMnNg2wXbA0tqrCRp6oCVidFkI1Jar
         ge5w==
X-Gm-Message-State: AOJu0YzPlLQJZkVZsM6gWBl5hEtshSkjmWae9ON4gQ5VwbJsyXCwn1wu
	qQvGk8UVfgWbkKqGi3FB9vONIv9Y8E9j7D27ZOVi8fE14X1QKEi1n7fzl+ND
X-Google-Smtp-Source: AGHT+IHCBbA1DAEIXS65vkzy2LOP16fHdQPOqOmJeqpjq30AeBuK58xCDn69G4TC6VOyXvulXNiQ4Q==
X-Received: by 2002:a2e:740f:0:b0:2da:38f:b09c with SMTP id p15-20020a2e740f000000b002da038fb09cmr1601243ljc.18.1713543398801;
        Fri, 19 Apr 2024 09:16:38 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:38 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v7 09/11] x86: AMD SEV-ES: Handle MSR #VC
Date: Fri, 19 Apr 2024 18:16:21 +0200
Message-Id: <20240419161623.45842-10-vsntk18@gmail.com>
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

Using Linux's MSR #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 lib/x86/amd_sev_vc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 3a5e593c..6238f1ec 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -152,6 +152,31 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
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
@@ -162,6 +187,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_CPUID:
 		result = vc_handle_cpuid(ghcb, ctxt);
 		break;
+	case SVM_EXIT_MSR:
+		result = vc_handle_msr(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
--
2.34.1


