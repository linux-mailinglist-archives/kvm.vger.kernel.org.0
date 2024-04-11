Return-Path: <kvm+bounces-14300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F4AB8A1DD8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 811F11C24BE5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FBD5578A;
	Thu, 11 Apr 2024 17:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Miom5+eB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48C55A781
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856604; cv=none; b=k6CAybnU6PnSBdQjnVNjBpMAihD+e7fUoqy/pzRD2VMSN0Y66Rr7eiXLg0T/plot1qWIXifNiMoiRFKpsb/+y/2g2HbcE3T42bAypQKgneAZorZ7myQMGq6ZrUzI2RxBZuOY6nNxy5kxccgrL2UgpHteett333xsKpXzGDaubCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856604; c=relaxed/simple;
	bh=1GxL/oJpcyYuX9NtGVsxli4LDXyGM2BL9sO0AZ8FiUA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZB8roPA9upspAJnZCbbV/Scd9j+gUZ8FLUJ5TmZMbHvFtrQI1MteJzbHXMc82i3ltIzYhSHdMNxiQu9Ob22SkjvoqdOm/7lsDmR2OcukBGW6mfZLG87sXx4Eu8dCw+C7LHwnE6iyR3WW4+yNJgG8qp9hS2Rmb7amrxViYl3CkF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Miom5+eB; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-56e32b439c5so11816a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856600; x=1713461400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jDE00WwzhDb1yJIkvlhhPiHlKzyZ8ykUSnJN0b3SuA=;
        b=Miom5+eByVMYPwoT+qq+HEjIrVq1Y79wqWzC87B5js9LGxKeggCZiJub8IL1uB+G3i
         /3IREynVVffhqo0HkVH4KveA2buUl7MNkOWM94cydwXs3Yjaj+HWp3HxFugF/HY3KwxC
         kbhojXAJHEWS7d/b5ia2EwdU9YxWq9S4LLPTSVxpcPcrI8oy00M4i4USGsI5o1YMe1ZV
         49ydMXFdv5LLVDfprLqH+wJJKMN7mi9ZuitYNTnSsFmhM4o14UHq/zmZR1EIemG2GjUk
         HYVi687OTop62IAiVOqAz2yBHcNq3KPreCMab+pFFlLUPkqXH7fyGVmrFjnkhhP3M2Yb
         GNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856600; x=1713461400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jDE00WwzhDb1yJIkvlhhPiHlKzyZ8ykUSnJN0b3SuA=;
        b=ueHMtbivddA5Th6NWiBVu4ISzbjW312UWEiPFSLsDqo2dc7isxhTk4jejnGz/w3S0v
         isp4SvHV6VVqxECsnPjHdAkzYUsnq3H7mHhELkl9dNDisGqCm7aAO3Asm4NJGlIj3p1W
         b6Rz0yTQfhipOcMgqk2Vmdh3rJh0KM1+zNyL1PMTnc46CIbbr1/L2SPsTTiUZbIYG4Vp
         KTChJe1Y8xEjhZcv+oQlBPyEe/j3LEIdjCpcBOaju4pDD3DMdy+Z0WG1T/tUx3iIAAaw
         zOUGUit0rglS0L5w4eaIjo1knw8Z0qiz5BSXn7r2L0rwzuuWrNGfrYZuNpzyNQCtgPSf
         eSKg==
X-Gm-Message-State: AOJu0YwHbm6ZBMcQsyOJ7KHcBJZbMtA07afSG1pqPNAppMXKKlKtlWKq
	FVw9VBHTWUU+xjiXhelpHoV9O9P4VraBVB3KTNnXyivCSuqex/mhFOTiVYaP
X-Google-Smtp-Source: AGHT+IH2GKH87BuV7n8+G94bf8A9sZlWL3XKSHF+JFEnG1J47lBWubaNh7lubTMg86cRjh3BjZCKQg==
X-Received: by 2002:a50:aa97:0:b0:56d:eef4:28f0 with SMTP id q23-20020a50aa97000000b0056deef428f0mr400197edc.20.1712856600480;
        Thu, 11 Apr 2024 10:30:00 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:59 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v6 09/11] x86: AMD SEV-ES: Handle MSR #VC
Date: Thu, 11 Apr 2024 19:29:42 +0200
Message-Id: <20240411172944.23089-10-vsntk18@gmail.com>
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


