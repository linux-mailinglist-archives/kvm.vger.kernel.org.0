Return-Path: <kvm+bounces-19457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F9390558D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58A521C218D0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE2317F51B;
	Wed, 12 Jun 2024 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hM0s90M3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0732217E8EB
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203557; cv=none; b=YGALJa5FGcpLUPk7J2NgnuBLvlfudZKOdSm7My7hIgKj68QB9VHi9LF7szBEQOJT1KdbaavJLGjtFMl8qBayOrnuKcsLZtY77ootBgsWyF20whwqQChefgiUD5OUyvA9JCigosJRHS6wIjz0LNmv0AP3NcMO+HMXbeZvrlPfti0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203557; c=relaxed/simple;
	bh=/k9TRSW7avGLBg0Xf94hpP3GMPSzLyyZ4nKJ+0FZy5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pb8m/1VlTobTxwaTTFXZUY/0U0YXTJspz4gOikK9qK2MwAbLBklxnUq7mJ+QYx74yZ3VC3K48+37CBIDZXpig6amu56L0ib9EPlUHvpZBE3NT5WZr1CnAfb++bMmKl00SGutCtuuHyvlgp/bHjhJ+0rtaeyIhXD/V+aiZjwEQDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hM0s90M3; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a6f0c3d0792so287249766b.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203554; x=1718808354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shE8lsjbK4iNnGN91vjLHfsdXySp8yV1+reUcv8/w/0=;
        b=hM0s90M3215cVnLPQm6mGHUAQ4t84QDZorWvfwGdbFHg/tXm1z/uD2o0ba/FV/bqCv
         wXjhTe2iokdngC/Ww4K4O+oKIBFbYvJj5ehEB58ws841w/Eqw91J/j+Glx+zWraRua6x
         KRbcBS7HsngEEEHOQrSjHbHoKbrM1erjMrF5fK9sx9mgboBhzXiPs01P3Y1NTlhg6fIA
         hUudpiQZRb+Fm7EOAAYFBxjCVVc9NB1N1XC83MNJ7GocQ2rWK9uwxJ5gIVV+oaM4Uz1T
         XUhEE8ztY2mK1iiji2L2w6eY7+83sP2dO9w2CNaqze8to2HUewGnxzogIWO8P3tVF4Hx
         xlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203554; x=1718808354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shE8lsjbK4iNnGN91vjLHfsdXySp8yV1+reUcv8/w/0=;
        b=d3e2RvrpV8XT+DRmjqD5rMqdTLqW0lEVD6ty4pW/BEfsohvlVhvcSy8GQInFQ4l3YB
         gitvbGynfnxZQStZ/9HWnrjkBJRYQmSRLDL6d3Xnj/ffaaKfv7zXb+u7/M9wEyv6bv/K
         hH7sPCe13iKOiX+wqLmJRIkiVCbrFg4ddEp6HGxr/3DuEyMGQjEVIN173u/dQX1ruhI6
         IMPzdXx805Dn6nqrlXip/Gt9oGlCGTPJYj9TgwmDiL5zyTCzMAqszsmTdLV+U8/MAhtn
         is9f5jEhyVzPpDzP+KkKk7t73Ut1XPjGyIBf5we1U0Fg7iQ9chpxsfwLo31ZCzt5mBrb
         T8cA==
X-Gm-Message-State: AOJu0YwklfmyA3Th5jKZxXhQc22j6dJBqvtS9Kl9nT3MMi29odCgKHDA
	8ao/JRrpfTtGxH7zzQ47CU6W+uBSqKDBAUd3Or0phVy5RhmMwPbz+EXlKooG
X-Google-Smtp-Source: AGHT+IExI8ssESZtiR0F3hiSwB7uZxMUvEXnITqLnnkNQEU+aoTvkJ65XDavWIdOioIK+R+MHL4JbQ==
X-Received: by 2002:a17:906:d9c7:b0:a6f:4e58:ffda with SMTP id a640c23a62f3a-a6f4e590048mr50247866b.50.1718203553694;
        Wed, 12 Jun 2024 07:45:53 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:52 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 06/12] x86: AMD SEV-ES: Prepare for #VC processing
Date: Wed, 12 Jun 2024 16:45:33 +0200
Message-Id: <20240612144539.16147-7-vsntk18@gmail.com>
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

Lay the groundwork for processing #VC exceptions in the handler.
This includes clearing the GHCB, decoding the insn that triggered
this #VC, and continuing execution after the exception has been
processed.

Based on Linux e8c39d0f57f358950356a8e44ee5159f57f86ec5

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/amd_sev_vc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index f6227030..30b892f9 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -1,15 +1,102 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD SEV-ES #VC exception handling.
+ * Adapted from Linux@b320441c04:
+ * - arch/x86/kernel/sev.c
+ * - arch/x86/kernel/sev-shared.c
+ */

 #include "amd_sev.h"
+#include "svm.h"

 extern phys_addr_t ghcb_addr;

+static void vc_ghcb_invalidate(struct ghcb *ghcb)
+{
+	ghcb->save.sw_exit_code = 0;
+	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
+}
+
+static bool vc_decoding_needed(unsigned long exit_code)
+{
+	/* Exceptions don't require to decode the instruction */
+	return !(exit_code >= SVM_EXIT_EXCP_BASE &&
+		 exit_code <= SVM_EXIT_LAST_EXCP);
+}
+
+static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
+{
+	unsigned char buffer[MAX_INSN_SIZE];
+	int ret;
+
+	memcpy(buffer, (unsigned char *)ctxt->regs->rip, MAX_INSN_SIZE);
+
+	ret = insn_decode(&ctxt->insn, buffer, MAX_INSN_SIZE, INSN_MODE_64);
+	if (ret < 0)
+		return ES_DECODE_FAILED;
+	else
+		return ES_OK;
+}
+
+static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
+				      struct ex_regs *regs,
+				      unsigned long exit_code)
+{
+	enum es_result ret = ES_OK;
+
+	memset(ctxt, 0, sizeof(*ctxt));
+	ctxt->regs = regs;
+
+	if (vc_decoding_needed(exit_code))
+		ret = vc_decode_insn(ctxt);
+
+	return ret;
+}
+
+static void vc_finish_insn(struct es_em_ctxt *ctxt)
+{
+	ctxt->regs->rip += ctxt->insn.length;
+}
+
+static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
+					 struct ghcb *ghcb,
+					 unsigned long exit_code)
+{
+	enum es_result result;
+
+	switch (exit_code) {
+	default:
+		/*
+		 * Unexpected #VC exception
+		 */
+		result = ES_UNSUPPORTED;
+	}
+
+	return result;
+}
+
 void handle_sev_es_vc(struct ex_regs *regs)
 {
 	struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
+	unsigned long exit_code = regs->error_code;
+	struct es_em_ctxt ctxt;
+	enum es_result result;

 	if (!ghcb) {
 		/* TODO: kill guest */
 		return;
 	}
+
+	vc_ghcb_invalidate(ghcb);
+	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
+	if (result == ES_OK)
+		result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
+	if (result == ES_OK) {
+		vc_finish_insn(&ctxt);
+	} else {
+		printf("Unable to handle #VC exitcode, exit_code=%lx result=%x\n",
+		       exit_code, result);
+	}
+
+	return;
 }
--
2.34.1


