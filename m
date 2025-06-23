Return-Path: <kvm+bounces-50345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D20BAE41D9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE4863AC60E
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC68B252917;
	Mon, 23 Jun 2025 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="APj+c1v1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DFB2459FF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684322; cv=none; b=W6RN5EIVJ+aRErgyewUMB46I86jmZeP4XCUZdvstyh2B9UdClHPOiM9bdJHW+DI7uwQWjLmIXXacJaN8DwU2v/T7Kby+oF9VmSbopsBJ6iNljOY6EHuU6V9JE1zjHQ892W24YOctBNdsu258XFpMzqst0x6MjwtANqrUFJg6Ytw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684322; c=relaxed/simple;
	bh=Qm56zszMrZJXbDrPs1w5qOA+/sGaKwz5ZuPWngrLpGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5uj3J6eKrTlokzt+J7spT82BZPOm8c8Uq6OI7+HU2ZWjz07nrkwK5TZmd52i4iBBIab/34trEX6OOGJUYmmT1cLEzGxOhASr90eSyUiVVpuCuLEAmko7BAbyx7x+al4wv08Za64dITXbDSRkmy3tV4ksRtzJxysqvACICpVd9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=APj+c1v1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-237311f5a54so39972915ad.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 06:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750684319; x=1751289119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wO40UEYL1TOuOO8GH3Tf8VplVaUYok6E8UthE4M71c=;
        b=APj+c1v1CJ1fRJniGcuTP0QfCeyflgztnyh5nffcZ/j4yT6dK2vOqO+v7rRW/RGgXw
         Cto3PsCBYL0TBfLyrr24Kulntv+l8kQiHQVz/IcXMF0RMiCeHH6SEVyf3AX/1Wd8WX20
         XiBWuTu2O3Z3WIwmPgKhp2/XsiCJCSCWjKEv2jIzjyDsnd1HQAxQpZa+uWbHVOX6BH87
         l1UTxLB590hcvh37ghwFQKkXyHYyLy27jiBQcMlz4ZE1nuSawRKe5DHSJa6jLaByZEtH
         tNNd6kwlBbySWPeVU0WKa9e0n+q9FfybfTAVFUNLr+yoGp9sSqKx286Eg6biy8q5FhQ3
         GyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750684319; x=1751289119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wO40UEYL1TOuOO8GH3Tf8VplVaUYok6E8UthE4M71c=;
        b=CI3aD/E0Hl620axFvY6g1B2pwJlBsdKszxwSlJhJsU7ZCKsFM0iIMqPEo4ORtg5/Ro
         Qz1zluNQEunyNpubK+5Je1Kib8nNlXyYHSsEOJa96zDE6JCto+Ab/pN6jZ/7DVkAYEIn
         txcqMRQBBzz26E1VJtTbjQ+KRAWcEn/XNlDYiIiuQDfawnlaE0x4FWBqRRJ8KioLFnHm
         zWmnnO0VDzgapiIEA0gsQmqtcyhOfdt1ftMEl8Nlb5VG+CVZgBKEesq28gS9nEglcr0q
         0FUlg6INvdC3B3OW54j0HLSx2SLRZMbjef87SVkz7T8fcY6WkC0lptM0P95hEzfKYBOk
         c8/Q==
X-Gm-Message-State: AOJu0Yy2D/6CdB+7vmA4NLsyOLe96C9jlJkW70ETvx505wYmM7gA9UJK
	2BUnqsdx/TTEgphKwYQoZjQT4p/bXvpzfTpxYRkgOkrF8Myyt4oLMv/5bg1RjizTveD5v3XFl6X
	6oU9DSgk=
X-Gm-Gg: ASbGncsxLyb65+pmKSVHoTarTrwhWxS8zZA8wTuzWhCHJXOYet8KhfBk2IU190k/Zka
	w99H6GxtmP3X7+8PW3X47WTITCE6obB0vTo6WgUxrOPRXBMP2b3YqyHZocC85NdXTvuXkxLnAXI
	eKNxlGKjM4ON96Se9BuU+eCV2/TpE8ynfZNwCY7RB0Zk8ySFYRFxHunP/zdq7IsfEj76YYEVT18
	NohBXeaSfZBr3cPAz9kUFQENGQBN2yZmWV0qwlVrz7vuTGAGCPwbcqzErZwuN0iy4K65C/wLfNn
	TtNX5uD7Vv1auxbrwYjAXStfx2o2TfKxPbT8TUh35ZtRjhb/iNvcdD+xilYljbTGkXw=
X-Google-Smtp-Source: AGHT+IHGnWg7T8K3upw5rqWnwqHw9IUwaNFs5TOMJRCFjVb/HqcR57ibOi0eIALkq+iQYSGfCurjdw==
X-Received: by 2002:a17:903:1a08:b0:235:f45f:ed41 with SMTP id d9443c01a7336-237d9918352mr184336675ad.19.1750684319204;
        Mon, 23 Jun 2025 06:11:59 -0700 (PDT)
Received: from carbon-x1.home ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8673d1asm84314385ad.172.2025.06.23.06.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 06:11:58 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [kvm-unit-tests PATCH 3/3] riscv: sbi: sse: Use READ_ONCE()/WRITE_ONCE() for shared variables
Date: Mon, 23 Jun 2025 15:11:25 +0200
Message-ID: <20250623131127.531783-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623131127.531783-1-cleger@rivosinc.com>
References: <20250623131127.531783-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use READ_ONCE() and WRITE_ONCE() for variables that are shared between
the SSE handler and the main process.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/sbi-sse.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
index 5bfc7a07..0dfabacb 100644
--- a/riscv/sbi-sse.c
+++ b/riscv/sbi-sse.c
@@ -918,15 +918,16 @@ static void sse_low_priority_test_handler(void *arg, struct pt_regs *regs,
 					  unsigned int hartid)
 {
 	struct priority_test_arg *targ = arg;
-	struct priority_test_arg *next = targ->next_event_arg;
+	struct priority_test_arg *next = READ_ONCE(targ->next_event_arg);
 
-	targ->called = true;
+	WRITE_ONCE(targ->called, true);
 
 	if (next) {
 		sbi_sse_inject(next->event_id, current_thread_info()->hartid);
 
 		report(sse_event_pending(next->event_id), "Lower priority event is pending");
-		report(!next->called, "Lower priority event %s was not handled before %s",
+		report(!READ_ONCE(next->called),
+		       "Lower priority event %s was not handled before %s",
 		       sse_event_name(next->event_id), sse_event_name(targ->event_id));
 	}
 }
@@ -977,9 +978,9 @@ static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
 		event_arg->stack = stack;
 
 		if (i < (args_size - 1))
-			arg->next_event_arg = args[i + 1];
+			WRITE_ONCE(arg->next_event_arg, args[i + 1]);
 		else
-			arg->next_event_arg = NULL;
+			WRITE_ONCE(arg->next_event_arg, NULL);
 
 		/* Be sure global events are targeting the current hart */
 		if (sbi_sse_event_is_global(event_id)) {
@@ -1019,7 +1020,8 @@ static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
 	/* Check that all handlers have been called */
 	for (i = 0; i < args_size; i++) {
 		arg = args[i];
-		report(arg->called, "Event %s handler called", sse_event_name(arg->event_id));
+		report(READ_ONCE(arg->called), "Event %s handler called",
+		       sse_event_name(arg->event_id));
 	}
 
 err:
-- 
2.50.0


