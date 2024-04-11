Return-Path: <kvm+bounces-14302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C29D8A1DDB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D5301C24C35
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC0D5D47A;
	Thu, 11 Apr 2024 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZR70dcA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8BB5DF3B
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856606; cv=none; b=pBmz6N6BQ7Wp5JOacQLdi0QB3T5syDLUQRXxvt4Kb91bS1CItfkoYm2NEx3UzGkhT09hAmt/4AUK/iz94GlWSOtC5MoazRFuh1IJebucEhQ8fC9178uBi8wRVWQmwUPjTMBSY6rnDJj4QrBueTHLXVEmwzUXr0vKepw9r7uyMl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856606; c=relaxed/simple;
	bh=sh0PZV/g72KQaq0W2lmfvw72SVzTXJwtX/DwYNPI0tI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a39E9LLxDFQJtFuCJpDuRdslQbM5O0OocwzmU4KvMjk442ObUdck71HBGQ3bf7ctL2m9SgriH3+MIkP/vqtOE9x4YzvcAl3DcfIQdQnMQT0V421bmSBzd/LjwhDlKcQA32rMbb7O80K14/v0HNod2rzu8uakfE5FI5TI6GK4fY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZR70dcA; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-56fd7df9ea9so49748a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856603; x=1713461403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNCVLIG2CMiyBOoYiM8IF0VeYwcjYl+48FesKHJM0yg=;
        b=JZR70dcAIhcZijxwBxU6/oEvQ7BZRJfj1VNnvbleA9FthgmjDPusUnvZHsbzlBdw0y
         7ONkpN0yfQxs4cAdLlBvN5yjkdLt6/9pqb3cEFdn1jfTXcNryavSYSfHY1BYLbxuvEzO
         2xsLErbsOap+rGtD7rzxXLj+jZ6Ektiz9t0htsKANp/raG1gREvEIxJd1BISjh0pTpbK
         u4exCe8l0YQAo2UL0NTYEHYSpfYCN8B6qFokFEYpEcOWk40pXvQadHuF6LVCOsb8lThr
         tcMCENLZOHMPZfi2tIUyfglqGCU8WKBy8duYLjs4TUahHlI2DWCAEQSpmEpOCl5JVmSr
         O1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856603; x=1713461403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNCVLIG2CMiyBOoYiM8IF0VeYwcjYl+48FesKHJM0yg=;
        b=dvPz/IU3/6nVhbhZa8Lp+C01OeXTnKTp8ZeqJTKvUt0UrYa4QJRpelj0Ut65cUay5i
         pD5VRh1pZbL1+mYdDzvojN7i1/5TIPF9p9RhSptpagsmWCgnlP96pp7YJ+jJfKaJ06c6
         TP/ZoqxPrcvtNFBid3bAgiEOterm15AEOBhBnBbbymXEzdJpyVNrLpDk5u50VJGsXb+I
         xhUrJTsbFn6nnBDAw3UitP+jRoEuVBgucelAtvF79PlCf35niqaePKl0KlonZl4/P4JQ
         TRdp8vtgLMbbcYxXxLlQwBgpwWxpZmQgXkbbI94c/7pcNY3Ctz60eMJr8ZwFGBjjoNvi
         pkVg==
X-Gm-Message-State: AOJu0Yxx4/5IHFp384PfVRm1sCoCeAnygPb6PCP/iZjGNcgqhiAkDn08
	7P+f08+Lrzmymm6iUAXUbKNqoyHPeA1K4Q8QLxr5mLnsGqdihcgYi/WITvuM
X-Google-Smtp-Source: AGHT+IG2qUkPb+juyQq/qiHSExDxbYsFaLEQdGncp0KKd0Lk7luf7wEvLuA1+qxicGpNAN+QyTsL8A==
X-Received: by 2002:a50:d7d8:0:b0:56b:ec47:a846 with SMTP id m24-20020a50d7d8000000b0056bec47a846mr287628edj.25.1712856602846;
        Thu, 11 Apr 2024 10:30:02 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:30:02 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v6 11/11] x86: AMD SEV-ES: Handle string IO for IOIO #VC
Date: Thu, 11 Apr 2024 19:29:44 +0200
Message-Id: <20240411172944.23089-12-vsntk18@gmail.com>
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
Tested-by: Marc Orr <marcorr@google.com>
---
 lib/x86/amd_sev_vc.c | 108 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 2a553db1..aca549b3 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -306,10 +306,46 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
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
@@ -317,7 +353,75 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ret;

 	if (exit_info_1 & IOIO_TYPE_STR) {
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
+		op_count    = (exit_info_1 & IOIO_REP) ? regs->rcx : 1;
+		exit_info_2 = op_count < ghcb_count ? op_count : ghcb_count;
+		exit_bytes  = exit_info_2 * io_bytes;
+
+		es_base = 0;
+
+		/* Read bytes of OUTS into the shared buffer */
+		if (!(exit_info_1 & IOIO_TYPE_IN)) {
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
+		if (exit_info_1 & IOIO_TYPE_IN) {
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
+		if (exit_info_1 & IOIO_REP)
+			regs->rcx -= exit_info_2;
+
+		ret = regs->rcx ? ES_RETRY : ES_OK;
 	} else {
 		/* IN/OUT into/from rAX */

--
2.34.1


