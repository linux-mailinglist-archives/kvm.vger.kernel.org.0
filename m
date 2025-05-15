Return-Path: <kvm+bounces-46663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39545AB8082
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:27:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5AD24C7C0F
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5372980AC;
	Thu, 15 May 2025 08:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="HGtgdR7N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C641296D22
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297438; cv=none; b=Y5eePPR34z6bbP4rLLb1MB+RvN0p1BBxbqA75ZrBNIEV/+jV7nDQKTYlX+yy69X0DnKKJGWR7krkmJOD5EriChQojjjzuVLY6veQdtbygWkGwD/GtGEg27uox+n3UHw2Qc1m9hrtINozj7X6T2MW0F8lesQbEaE3PrP2HvjVJms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297438; c=relaxed/simple;
	bh=gz6VvvjTGk7E1cSwi96lm1FYuCpqd61naCtEyUpjT8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ViBroo9jhQUYsZlbAySa5DD7w+EBK0q7xhY9/j0Yz7CGK/bOXCvIDiLZyAe3VZvBdym6fX+qLX4JwIDyWZfBkPhkQBguZ21N8YvFXLE1SzT2UbL1B9jqzCy02V0khBLEhEAmH9lElLAYkOVM+g2Ng+IOjtJ73PFsLXeU6XnftEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=HGtgdR7N; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43edecbfb46so5034765e9.0
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 01:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747297435; x=1747902235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJAkm6pLaRGxiRfDXZi/YHgW/rz4khqaVw2vC12MUOY=;
        b=HGtgdR7N2fze2+HwtHUQlSYc0h6MLpSFAam2Wgs3kHeB+t1Pw7bmegiEWXH201YXmz
         2W7rY/dBuTk6Q+ypIOFetOCBMl/Zkz2nEbIP2wjW2Xm2Hae6LbIBkiVnb2KAW2Du7RXv
         qjldTeZnZcw9995U2hNh98kaHAxF22lmiGAVBsX1Rd9U+iNmqVzNQB+PwfzapWzQPS4u
         /coCS2w/8djBi5IyG1/xAjuu5AzkRsF3B85yWFK5MxZLeHXnWJXcYR6iYhXqnuY5tNLQ
         h9mwKny1ZYXWNL1yBW5VDbQTqrrFloUmFUQTA8Vy/iInX0PA20FARmG0WhepAqlHdx3A
         yJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747297435; x=1747902235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pJAkm6pLaRGxiRfDXZi/YHgW/rz4khqaVw2vC12MUOY=;
        b=q6fpi+6OZRJMq5wWHyF0fhdyiGRPv/NPl67BDVCVeBlzZZpTDaRiICEDWj74HKGoLv
         /zegr7aAVw7+DcFPH2Cw7LmJ/4YuQNCKFJQyj0lmC42NT//fT1y/UCZJydzcCRWeMfZE
         N0lqrCCBdyJmeP8vytICorxcbOVsp2tbNQ/4zosWTnY2H+L6uRf7oQYR7d8b7HFhvTdX
         qcydMzLS5IfC4pLGRzcCYCsnzpY4znMEbegh5QriXBDl1eeij9CxIcrSMcZIiQ4fv0o0
         W+3dmSEWIvQFur+/9tUD6hpsQ34WNqSIRbKDy9IMGtm81emW200fRX/YcrlCVF4Y//Pt
         PNsg==
X-Forwarded-Encrypted: i=1; AJvYcCUIkJkfiO8txZRt6DcFjMy1wKRTNm4QlTRK95w2LvHox/7KqSModpHNQHZ0YslfOgJGQ08=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq+Fbwaasu5LLe5SFPDsnq69OFesBN1TdpgZ6FlViPaYllK5cS
	DRaybmdC1QYOEMDwkzM5J+jM8V7F6iHknvF6SUxiuMmRS8b/BSbEYwfRoVZzVIc=
X-Gm-Gg: ASbGnctVK3XASlBeJ183Tw5yNekMSHzdxvp7q1X0Eb3rRbhCcDR/OviHScpn1N2ooz+
	J2NETjca2OKlcrfYoPeTNuHeVLX7fRpyKn/e+T0f2vh+O5iUZPg1pALHeDJuy2vUUk6t2cwHiBV
	Hmxgpzd6Pp7KEf5yXkgagclgnHLuKFrexc1BIpO1awqIFpRTfkwNAy3OiEhSBOnPD+rGeucHMp2
	GCOTj3uanaKscD9kZcS6e498wZA0OpGMlCNUMf5pkPkDfXkEEPvMMeYSVqx3kfL4iAWjpa+tFmW
	L8Y+TL/6cZrfuBtv6IRA5G7Di2C3kY/FZVxkUFnThHpfvkH51sk=
X-Google-Smtp-Source: AGHT+IECzWumV9cA1BxSf0fk65MG1v936xTUBe9wcvvYI0imqbHM4JGZ7JFwZqaAyEUGXVqmxzPHUA==
X-Received: by 2002:a05:600c:6612:b0:43d:db5:7b1a with SMTP id 5b1f17b1804b1-442f96e75eamr14059925e9.12.1747297434909;
        Thu, 15 May 2025 01:23:54 -0700 (PDT)
Received: from carbon-x1.. ([91.197.138.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f395166fsm59310785e9.18.2025.05.15.01.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 01:23:53 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: [PATCH v7 09/14] riscv: misaligned: move emulated access uniformity check in a function
Date: Thu, 15 May 2025 10:22:10 +0200
Message-ID: <20250515082217.433227-10-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515082217.433227-1-cleger@rivosinc.com>
References: <20250515082217.433227-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Split the code that check for the uniformity of misaligned accesses
performance on all cpus from check_unaligned_access_emulated_all_cpus()
to its own function which will be used for delegation check. No
functional changes intended.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/traps_misaligned.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index e551ba17f557..287ec37021c8 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -647,6 +647,18 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
 }
 #endif
 
+static bool all_cpus_unaligned_scalar_access_emulated(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		if (per_cpu(misaligned_access_speed, cpu) !=
+		    RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
+			return false;
+
+	return true;
+}
+
 #ifdef CONFIG_RISCV_SCALAR_MISALIGNED
 
 static bool unaligned_ctl __read_mostly;
@@ -685,8 +697,6 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
 
 bool __init check_unaligned_access_emulated_all_cpus(void)
 {
-	int cpu;
-
 	/*
 	 * We can only support PR_UNALIGN controls if all CPUs have misaligned
 	 * accesses emulated since tasks requesting such control can run on any
@@ -694,10 +704,8 @@ bool __init check_unaligned_access_emulated_all_cpus(void)
 	 */
 	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
 
-	for_each_online_cpu(cpu)
-		if (per_cpu(misaligned_access_speed, cpu)
-		    != RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
-			return false;
+	if (!all_cpus_unaligned_scalar_access_emulated())
+		return false;
 
 	unaligned_ctl = true;
 	return true;
-- 
2.49.0


