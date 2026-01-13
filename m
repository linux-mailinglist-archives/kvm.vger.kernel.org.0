Return-Path: <kvm+bounces-67888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 069DAD1605C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:34:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DBF273028685
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB98C231858;
	Tue, 13 Jan 2026 00:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b0/plr7t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD33A261B8F
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264330; cv=none; b=Hc4ydDX6DQjekHX4CPewyTd/amF0WaOfFmO/u9LZpZLjWSJh4stt7GofajEyYcrEB86+5JPrDV/8/7anQw1yvO6hUo8jqeMywWYlo8H20Pdl2TOaLZrq1pxFXArP63PeCio/iX1Z48Qu+ALDHsFModQZV4S/9rpZ9EGbNek3L3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264330; c=relaxed/simple;
	bh=t+1zRp0OUO5ZNxI5CdmaoojQgpl1kUgc4oy7hjIuBAI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HDf4Kqpg+FDfNw6rDTg+gMBhkkcc5/a4+pOwsnucgoO1Yr3FUWsIoraAWZ5flwwyFDHQZMfg1w2qIbkUeF3oogbQcjZwsGY3ArMlQOSIC7Eif0WBOtgoxCqnEcaWm6PoCg3i7qZ/he5se/hB6adSPbZjdTVJCOUVrFieFw8wJ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b0/plr7t; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c6e05af6fso7112752a91.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264329; x=1768869129; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oiTojNlbDAzyVC3pSvqgDKiciei16bt0llNSK0nNKyg=;
        b=b0/plr7tzwsb3JyqXQh9QWXIH7+JsRu7wnDT3CxKseCk/zXWTANuTMK3GM7w5s3ih3
         gEdVCPXhVWvOFi6LJ6L2tKG3rWvYNB7TEPOtp43CSUYBll9QnxvWWGrp7kGwrdAxGgIZ
         iLzsJiv99/lxv1lZo/khLLYQ+sPLt29Jnrw2Kuv2E2QwJAjQn0cse3jk4UaSrVVrVm+p
         ggcR+cmyeS16NWQD9WOVPo3VooT/IJ/XsgOz8kHuCTwbmyS9ACk8zOPU5X7tsaTzcx5F
         cMOwIMzwW6uoqEQAOtFzlL5C9Y/wPpft363SN0Mz3GMiX3b3gWc8woA/kLQyJ2qWUi3R
         ih5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264329; x=1768869129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oiTojNlbDAzyVC3pSvqgDKiciei16bt0llNSK0nNKyg=;
        b=dwu9lGoZjaVkpn2dR1UxuU/W8ZNrV7NBDGC+GNlhVQ9KAechOFDYxh2lektk2F7XG4
         E7uGNx0xspZjN3Ln7HHAvsw/zy//BYDGdTMegxz7u+G6RPpweINKvX8JxrzemH+ygIny
         wCnDqkqvbsIzb8CsmirbBi/PYSs9PQeubOZzXxybHd5wYH5/5nroK88nvGVKHqDd0vY2
         0vZ/2xLXbgN67y4qH0s3wBxNbS2y8YN4Wqf0ZA34CA21T8qK//qekFSC832DPmIhNyuA
         QEupBnmTtMjhr8L7E6dScyOK5e7bZmKpCzbxGiBnzkF7TEXNI24HfciA0CGwY+y3dnl0
         x7Vw==
X-Gm-Message-State: AOJu0YwkT+7tLgmuHPfisUhMwLozX0wesMN5Emq7Ga4XrIiOxTLL63Wj
	f+U9AFZ+7oxgvHB1pkHp8XzGx8OyMeXiXv27Rmbr+tt6EoNL4xdAouZBGFe4v4H5PIoZGDhFHih
	vMMVeOfmox1AWodBpvyQbKg4AiIKgXncbsdN8cgQv3yVk2N5gAcZIimnSVDIlbfMoXkTuge9q2s
	235r3NZ4piT10G6s+atd/wfNm11BbsTdVd1R6rq5DeBxA=
X-Google-Smtp-Source: AGHT+IEqeGIc7Ouulf3Ph5RcARwrr2VtIVX+ovnLzkUV8x/BIrT5643xF6W/36+cB8b1e3cE2YKDTsEufsh1Zw==
X-Received: from pjbds14.prod.google.com ([2002:a17:90b:8ce:b0:34a:bee9:ef2])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1c87:b0:34c:635f:f855 with SMTP id 98e67ed59e1d1-34f68c33ab8mr19845816a91.7.1768264328905;
 Mon, 12 Jan 2026 16:32:08 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:49 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-8-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 07/10] x86/svm: Add NPT ignored bits test
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Bits 62:59 are ignored if memory protection keys are disabled via the
PKE CR4 bit. Verify that accesses are allowed when these bits are set
while memory protection keys are disabled.

Bits 52:58 are available so test that those are ignored as well.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm_npt.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 6ecaf32a8d75a..39e8b01965f25 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -372,6 +372,35 @@ static void npt_rwx_test(void)
 	npt_access_test_cleanup();
 }
 
+static void npt_ignored_bit(int bit)
+{
+	/* Set the bit. */
+	npt_access_allowed(0, 1ul << bit, OP_READ);
+	npt_access_allowed(0, 1ul << bit, OP_WRITE);
+	npt_access_allowed(0, 1ul << bit, OP_EXEC);
+
+	/* Clear the bit. */
+	npt_access_allowed(1ul << bit, 0, OP_READ);
+	npt_access_allowed(1ul << bit, 0, OP_WRITE);
+	npt_access_allowed(1ul << bit, 0, OP_EXEC);
+}
+
+static void npt_ignored_bits_test(void)
+{
+	ulong saved_cr4 = read_cr4();
+
+	/* Setup must be called first because it saves the original cr4 state */
+	npt_access_test_setup();
+
+	write_cr4(saved_cr4 & ~X86_CR4_PKE);
+
+	for (int i = 52; i <= 62; i++)
+		npt_ignored_bit(i);
+
+	write_cr4(saved_cr4);
+	npt_access_test_cleanup();
+}
+
 static void npt_rw_pfwalk_prepare(struct svm_test *test)
 {
 
@@ -833,6 +862,7 @@ static struct svm_test npt_tests[] = {
 	NPT_V2_TEST(npt_ro_test),
 	NPT_V2_TEST(npt_rw_test),
 	NPT_V2_TEST(npt_rwx_test),
+	NPT_V2_TEST(npt_ignored_bits_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.52.0.457.g6b5491de43-goog


