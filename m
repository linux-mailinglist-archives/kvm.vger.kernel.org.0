Return-Path: <kvm+bounces-50344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A13AE41D6
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3D093B0929
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C7B252287;
	Mon, 23 Jun 2025 13:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rBOqBCli"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E349B24EA85
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684317; cv=none; b=ead/CpE61s4WXWvKlcoO8oamZOzCyMCLanY5UNcghOv7O6OCDRUjORnWrVhp0PlrjiJiusYbpF8Y5GYq2u8q1Z0p+qdL80Lq7fXgpZCUTm52V7I7Y/ROceXWxxzozMMlSPjEe3aTVj2JmSUerDuoEXTVAKb0eh6C1tdPHiLlQNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684317; c=relaxed/simple;
	bh=ZkpBU4yiLX6ydiAokQdQMkx3Mj/m64FCtOME2VSvluM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oud/fCEdNzgj9fG6sn8CQA0d++JSfLqmVwA+NDM5v/Vk9S1pRVXM9g9EgjCTW38/mERjKU1UheUX37pAy1vsdR9WhGlfPJWDE2yqaYT4UtjzgzYLIftjCePR2GOhpxP+5NKLUeJ+H+PLODLd9hsCfG9wEU9Tc9R28GlwAHF/xJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rBOqBCli; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-315c1b0623cso1049870a91.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 06:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750684315; x=1751289115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzRh29yHMbwbaz0+15/VXfFDPZCf6HyTmGmqDTmtI4M=;
        b=rBOqBCli87WDfMUuYKy3/TCq84ymGAEQFD8m6fmLJMDOZgXgwmOc353uhNt2WV//kr
         LKCPc3wGf3wEShH6CEn7DZXBoEADWYy5EZqbuqo+7qfyDD6+sK7JpCzpMec5W259dnl/
         akRWiocqtsnvJddZIDzkxxCrGAQYPfootG6zlxfX6ADWIOtVPXUTj4MSTeO8fCu86typ
         5MUSGc6WHr2DErJqV3g2S4GsGaSkQgMjfGlU+meXy/oG71/qeZZEY7l3h/1AYgLrMYKr
         dUHuUBWbp4iaNBUeL8CdzwUkqDeBMH3g0bZv+yTpn2CMVyY4P1cspT/AzVLlKKgL85OP
         YcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750684315; x=1751289115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RzRh29yHMbwbaz0+15/VXfFDPZCf6HyTmGmqDTmtI4M=;
        b=IpgAFzWAsnnnd+AlE/7hjl0IcGkXWSwSEaIUwAaSH+nhUKVgoi2IxUTYpbEbOepVdX
         eEyc8JVzyz2wwlFMiDpXg2VMua0/FDKcUZeEoFGDRmDpthshAGIX+dc1JHduU5FJrxXJ
         LYGYEvoj8QIkwAqnMQTxa30yFgwmH1u5mrBvGsHksJZgtZN2ZrUdfk2JIpa/1X4BQ9L8
         3Hcl6saTPxOdd5H3OfIrz4eGkTUu+0jZYM7HRlfwI/Sbu3usPi9whvPvzv59aVNu7rBc
         L+1kqn59Yx9y7imJQBc0HDfZlTppqvAkYZdsXjqCLSYrm/Sr+fOzzae8Y8vZGcTn4R1F
         7VIQ==
X-Gm-Message-State: AOJu0Yw+6MYjT868v0EUcompmZPpdra4mCGFMrRlaATH/oAQP+7y8m6j
	+wIkrvczRd0RVq+yWCqfYaynP+47w1RKVh7dyHmR+fvat4ehLRjWO+24Xtwfj2ITXApCniv1maq
	wATKzpuw=
X-Gm-Gg: ASbGncttzvFph6d0ydRLI2KAAeCKK+E2RuzsTlygfZziIzQhABPEYTEa0uXI6JrAc5j
	sj1ETJ1SGzRllNq2GCgqWvV7b3pZr+/zVoAsaKA0qFepjK19PeXfnUiZ+k2Ji9ELrpvo57aelg3
	N0dV4KD0KjfHwQ5EKtoT/N81fe/kxWRx+kipPgdRK5nz7X+UX3JgPt3EjmqBqkDU1qXpvCBUuiV
	/NnqpM6w0FaEuOU08txThsvfsETszKkiZaiuaiOLD9ObqRJhCp2E1n0TIQ55UIh9GI/pWjKG7Dr
	G4ot7d6qyRHw2EldZ0mernRJAVCaU5lSoG8ldU1GOBK2s5eJoAV0cuWMflCZZS9Olk0=
X-Google-Smtp-Source: AGHT+IHeptfHKHnYbF7JJ/8CGxqCXp80Tfkpvpum4dw9r887/gspr0Tf/mgthGDjug/fetFEjg/NQQ==
X-Received: by 2002:a17:90b:53c5:b0:315:6f2b:ce5a with SMTP id 98e67ed59e1d1-3159d63da58mr18945464a91.11.1750684314778;
        Mon, 23 Jun 2025 06:11:54 -0700 (PDT)
Received: from carbon-x1.home ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8673d1asm84314385ad.172.2025.06.23.06.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 06:11:54 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [kvm-unit-tests PATCH 2/3] riscv: sbi: sse: Add missing index for handler call check
Date: Mon, 23 Jun 2025 15:11:24 +0200
Message-ID: <20250623131127.531783-3-cleger@rivosinc.com>
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

The check for handler to be finished was actually missing the index,
leading to a single handler call being checked.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/sbi-sse.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
index 2bac5fff..5bfc7a07 100644
--- a/riscv/sbi-sse.c
+++ b/riscv/sbi-sse.c
@@ -1017,8 +1017,10 @@ static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
 	sbiret_report_error(&ret, SBI_SUCCESS, "injection");
 
 	/* Check that all handlers have been called */
-	for (i = 0; i < args_size; i++)
-		report(arg->called, "Event %s handler called", sse_event_name(args[i]->event_id));
+	for (i = 0; i < args_size; i++) {
+		arg = args[i];
+		report(arg->called, "Event %s handler called", sse_event_name(arg->event_id));
+	}
 
 err:
 	for (i = 0; i < args_size; i++) {
-- 
2.50.0


