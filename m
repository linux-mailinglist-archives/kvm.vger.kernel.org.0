Return-Path: <kvm+bounces-19461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67DC5905591
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CD041C2164B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD1016F0DC;
	Wed, 12 Jun 2024 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HoKKT/Y7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BC917F373
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203560; cv=none; b=ZTZMmV6IxGwbIwi9KgkkkeSSBMQbVkna8S74WY0NqrnZMYhwxJjP+Ba07OAVCEF43RYSTBrMzRhQbhOY6XTBLNu7W+zEofVgO4KiIrkr6EFljsssU56QZIolMA24tn1Lg5vcDTTD6ZSUQq2GRaxpjoHD4UeF+QMWEfx6Gxg1Y3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203560; c=relaxed/simple;
	bh=vYy996Id7SG5T+Tpak3oFN1dudkcN2xdXRo6iswSjZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ll9JXZN6x5/H1eKYxGS3gcKszLtIFLiHHu/MosJ33XWyxztcfvCejsD/AtrNevW921ev6JqlPwxjni91MXQ2V2tYq+ux5/T6KfStc32qadi/r4YzsUPaKMTg4jRGWNXitHpDl4Zw2HQuiB0bOpmC7fFRfdGsWD4msOv59Q/sCss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HoKKT/Y7; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a6f13dddf7eso495234666b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203557; x=1718808357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aM2Ct0cQV1dfF+w9k5l+MMyl+fTONNWbkjb0FsBk8bY=;
        b=HoKKT/Y7wVo/0OuScRoStWIB8LnrRGTA+K/3M5huDNAX3omTre6lUch996ZODUbaT3
         OB7Wo6DE7tNe60f9g9BwxEV+Rr/6ILUoF6MLg4NuQsk1rojovdHV0LOzPO2LzTmnj8nq
         MYMqDTy33FM27lt0rCgO6f/IX8C7zjr92CYR8tIt/DOz+rV1pfZc1hyV5xRkpws/+Z9g
         attXmjxjFOkMz61dsys1jDLcSQ82sZSGm3f4W/Iym/BMGmJl8XIgKKbHqBD/y9QCaXIK
         wt4BKHJF5vJ2M3ChFWiFu5kLSHVC4Sjidw5sOH2nTTdefDpSnJ2OBN6JbRd8KSFjpN0S
         nRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203557; x=1718808357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aM2Ct0cQV1dfF+w9k5l+MMyl+fTONNWbkjb0FsBk8bY=;
        b=YSlNn2gW6StI7v5/q/tXxJkPpdF9TZ1apq88ogZ9gWjjj8o9DV3jlrQhFSfkEZxyE2
         j7kSTIlTlX18rfnS1KrwFe9sKchlbcsPkh4PTXzri3wTXGpTX8Jg6ODqu2o0eWCS6Lkq
         FTIxBZus9n3D/EB80kl9LliWeHamwpbm5i1WyKv4Vi7fOQX48TOqzqHggQZNvMF4UOLe
         zKVukFB+E1oO+4OqGbpxz7wDKFSq/KcR4oM/wEz7oiOcdUKtcnrax3KBFiKERpzD4m5a
         Z1GhTYxdjrIi18T/vgHsjxExh3/czCGZHwTe0ImNnVDpWEwwI55ZEpaXR9Hqt/GDIhuM
         9UPQ==
X-Gm-Message-State: AOJu0Yz0CMYhcAY5x+s6wLJKWRBcz+1oDz/IGMYjon4orgQfBKJoc+AR
	CAD5Xyab4RhtS0t9rXgp5Q9tvBaYrF3p9l2Ro14trasQ/EgO8bIbsuLD8hKH
X-Google-Smtp-Source: AGHT+IERv9S86t7ARxGw6B6q1B8cyEvIp/c+sJ30vC1u4q9Tf5KsAU185AyArehzT9PEJdCxvwXu+w==
X-Received: by 2002:a17:906:aac6:b0:a6f:153b:6613 with SMTP id a640c23a62f3a-a6f47f52e23mr131378366b.16.1718203557077;
        Wed, 12 Jun 2024 07:45:57 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:56 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 09/12] x86: AMD SEV-ES: Handle MSR #VC
Date: Wed, 12 Jun 2024 16:45:36 +0200
Message-Id: <20240612144539.16147-10-vsntk18@gmail.com>
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

Using Linux's MSR #VC processing logic.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev_vc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 39bca09e..72253817 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -140,6 +140,31 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
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
@@ -150,6 +175,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
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


