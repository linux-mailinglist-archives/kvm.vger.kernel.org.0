Return-Path: <kvm+bounces-19463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD7D905593
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C8E9289BCE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4955C1802AB;
	Wed, 12 Jun 2024 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k+k1fBzv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC59617FAD2
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203563; cv=none; b=qn4OXP0PPIOohvI/U20CF5SbvhaEDfLeNRSxPbeZdR0hVWOf0YNn+mCv3sOa5i8o4llOmx4NRkHXqWm2+vRL4n/UEBthc1YI8Dyxo6Spo7N40n91P6TxfF4HSm0jW18dWZ8e3FKRPI6BQ9mzah+jz8yZQN2WNaHG9mxPS2++LKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203563; c=relaxed/simple;
	bh=ib1JPsbUsbK8RoXIG46rQaPxg2Drwv+ltu0NArK18Yw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lRMhA1j8cQIC2wFxQDq9IvuF5FRFseVWsj68TnstoepC+vINRvL0fbFg+QQ4o+/sFNrCYwap2aIpDTY/ruBPnjBO1yQuaQccAw0HcEXCvQn53ksLEHTzGHQqiIrLqtwgrbXfsyQ1L1r26xfoe6Fs2VjJmzL5+OA9mosQLDNMGXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k+k1fBzv; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a6f0c3d0792so287260466b.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203559; x=1718808359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vBrtORPHJ7zoFoq2iM8wpE5czqyK4BpZzNU3+HrHvvg=;
        b=k+k1fBzveV9Y29Z2LMhDg3mU7Mo1/x4gHMuowUa4s2y0xM5sHoaMqopZLrzhHCQgCJ
         x0jmU6KrKfAHDUuuQ//UtRi3fUi8AX6wekLXQrYaRx43VUnRc1EIMwQBRZ4RjA/KJJCy
         9MEpt5RtHicEpiDKdm91/aNVjsFBM+PiDS+Gj4Xyih5sljJMGPT9QQe4wQT13w2QsFg9
         DLGvm7HF2lDsxR51Dsu6uHF5QUUXeLDQVRmF8m+B4zZz/dHHYg5exxcLNI1ZhtrItcF8
         tv+q1zbbn0MD6al3zAdibKa1Ve6NNHcj11Uikx/TeyfJQrfgjVJ2lvHVJEhyJcEPZhbY
         ylIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203559; x=1718808359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vBrtORPHJ7zoFoq2iM8wpE5czqyK4BpZzNU3+HrHvvg=;
        b=wRMIc/Rb1M7WtovLX5AAC+vOM6l/HgIrNPRqCQmYrsi0aaHVAw3ydVMhltFEw/+Rc8
         bzLfEUs3AF7TMJmwEe7jJWLTdIXdXr2XdgGUK6g5Y0xjerT1/blX2Rx8+Dk2CTXfeHVK
         T7/fBnVePmEWbE6ohgui/Yshdt4uEQX7B7h0TJ5gDyVOb3/LPITZAQbFrdMwFFKkZIml
         Ce2O0S/Dc8RF30EbPNg+r+lBpve/CLjrM6BH21aMYboQG7s4up5FyQLSlj46QEB8Ewlp
         9O2q1TkMIRBoe90N5w3Yoow49hPUF3avz8DZLykvRC56bQvjr0OacAgjYtrwUcbrybvt
         +43g==
X-Gm-Message-State: AOJu0YxwLhOImAAovkfUB2jAGT44OIc7dUL1JkhrT4kAcDCM0WNm4Qz7
	hDwsgxSKtJWnFkEFyp9ST6eZ5w8arXKDNKFLJTD088HMUpqLQuot2292DMlY
X-Google-Smtp-Source: AGHT+IGWWm12pu0UYVU5/K+mxAmEmZ8nlj36wQc69DmFhJNkBofURT7MltiDL0h9FXRBWGp/eEPAqA==
X-Received: by 2002:a17:906:c00d:b0:a6f:50ae:e09 with SMTP id a640c23a62f3a-a6f50ae0fa0mr18353166b.4.1718203559366;
        Wed, 12 Jun 2024 07:45:59 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:58 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 11/12] x86: AMD SEV-ES: Handle string IO for IOIO #VC
Date: Wed, 12 Jun 2024 16:45:38 +0200
Message-Id: <20240612144539.16147-12-vsntk18@gmail.com>
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
 lib/x86/amd_sev_vc.c | 108 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 0cdb9c06..77892edd 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -275,10 +275,46 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 	return ES_OK;
 }

+static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
+					  void *src, unsigned char *buf,
+					  unsigned int data_size,
+					  unsigned int count,
+					  bool backwards)
+{
+	int i, b = backwards ? -1 : 1;
+
+	for (i = 0; i < count; i++) {
+		void *s = src + (i * data_size * b);
+		unsigned char *d = buf + (i * data_size);
+
+		memcpy(d, s, data_size);
+	}
+
+	return ES_OK;
+}
+
+static enum es_result vc_insn_string_write(struct es_em_ctxt *ctxt,
+					   void *dst, unsigned char *buf,
+					   unsigned int data_size,
+					   unsigned int count,
+					   bool backwards)
+{
+	int i, s = backwards ? -1 : 1;
+
+	for (i = 0; i < count; i++) {
+		void *d = dst + (i * data_size * s);
+		unsigned char *b = buf + (i * data_size);
+
+		memcpy(d, b, data_size);
+	}
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct ex_regs *regs = ctxt->regs;
-	u64 exit_info_1;
+	u64 exit_info_1, exit_info_2;
 	enum es_result ret;

 	ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
@@ -286,7 +322,75 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ret;

 	if (exit_info_1 & SVM_IOIO_TYPE_STR) {
-		ret = ES_VMM_ERROR;
+		/* (REP) INS/OUTS */
+
+		bool df = ((regs->rflags & X86_EFLAGS_DF) == X86_EFLAGS_DF);
+		unsigned int io_bytes, exit_bytes;
+		unsigned int ghcb_count, op_count;
+		unsigned long es_base;
+		u64 sw_scratch;
+
+		/*
+		 * For the string variants with rep prefix the amount of in/out
+		 * operations per #VC exception is limited so that the kernel
+		 * has a chance to take interrupts and re-schedule while the
+		 * instruction is emulated.
+		 */
+		io_bytes   = (exit_info_1 >> 4) & 0x7;
+		ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;
+
+		op_count    = (exit_info_1 & SVM_IOIO_REP) ? regs->rcx : 1;
+		exit_info_2 = op_count < ghcb_count ? op_count : ghcb_count;
+		exit_bytes  = exit_info_2 * io_bytes;
+
+		es_base = 0;
+
+		/* Read bytes of OUTS into the shared buffer */
+		if (!(exit_info_1 & SVM_IOIO_TYPE_IN)) {
+			ret = vc_insn_string_read(ctxt,
+					       (void *)(es_base + regs->rsi),
+					       ghcb->shared_buffer, io_bytes,
+					       exit_info_2, df);
+			if (ret)
+				return ret;
+		}
+
+		/*
+		 * Issue an VMGEXIT to the HV to consume the bytes from the
+		 * shared buffer or to have it write them into the shared buffer
+		 * depending on the instruction: OUTS or INS.
+		 */
+		sw_scratch = __pa(ghcb) + offsetof(struct ghcb, shared_buffer);
+		ghcb_set_sw_scratch(ghcb, sw_scratch);
+		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO,
+					  exit_info_1, exit_info_2);
+		if (ret != ES_OK)
+			return ret;
+
+		/* Read bytes from shared buffer into the guest's destination. */
+		if (exit_info_1 & SVM_IOIO_TYPE_IN) {
+			ret = vc_insn_string_write(ctxt,
+						   (void *)(es_base + regs->rdi),
+						   ghcb->shared_buffer, io_bytes,
+						   exit_info_2, df);
+			if (ret)
+				return ret;
+
+			if (df)
+				regs->rdi -= exit_bytes;
+			else
+				regs->rdi += exit_bytes;
+		} else {
+			if (df)
+				regs->rsi -= exit_bytes;
+			else
+				regs->rsi += exit_bytes;
+		}
+
+		if (exit_info_1 & SVM_IOIO_REP)
+			regs->rcx -= exit_info_2;
+
+		ret = regs->rcx ? ES_RETRY : ES_OK;
 	} else {
 		/* IN/OUT into/from rAX */

--
2.34.1


