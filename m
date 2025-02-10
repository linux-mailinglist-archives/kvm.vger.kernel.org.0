Return-Path: <kvm+bounces-37739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71405A2FC42
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2226A16712B
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A468253347;
	Mon, 10 Feb 2025 21:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Ad1Y6Cpq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3257124E4A4
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 21:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223374; cv=none; b=Avwc92gyZwaZ0hIcxf31S4TplSnS0Yqlb6dSviu5I4xP6kPLX95lAmsUX2qzlClLK1rMYIwpngaXEZ7fXdmuCVbLyFprFgYofmfDfV1S04EsnNzGM98tLqlR0vvGzK1Zda7jj6gOyZbod8NuyA6TjhtoqMtXXxAfvLgQijtUPF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223374; c=relaxed/simple;
	bh=1WSsOfDqC/YRkJ6qwFFGvVm3x8WirtJHzlN8jSnSP0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpsmUSS3h9lzUuqw7C0jlEuO2x07f1dkQYl27zN9pmygN53sNCsF3niXHK4TrIC7SrEwK/j2tKypDJHfEEQqd3035SmqV6hR2WuSseoQWaSVFsLNesqOZU+N1wyZJRwzCV5itpd0wAmbNEYP/jtqij6ARcGm0ndstUMXb73IH2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Ad1Y6Cpq; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4394036c0efso10719955e9.2
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739223370; x=1739828170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqqX7ElFp9wIqiTogqx4ZkugO9mCs5sfeq9wlnFties=;
        b=Ad1Y6CpqcJAlCk55SlnhFVAlvw2UzXWSbQNI9u8KPnSts0r3F23jiswtS93DJ3H+CC
         qRSXcclNgiNP23VGBxIQ1UfE6vWstXTy2k5h0sdO3yJyR+EpPv27LTb+dQVt2wk/h/nL
         wzM0YWYMM1MP3+XiMra64wjMeMsRUKQsps6DliNapXNmMtsiCMVmhsHeHK0C+nTBrsw8
         LKRJqZbx1IN/9LCpf0fYcahNxR9kCQQl6N4JxSj2ujtZiyCy0y7xIHSKu1mO7R5C95ye
         h6alidzdw8XieAhzMuBAziyoWJB8JDQUorHcPcIOC6vpDtJxT7YExo8eSXVhhaI0JJXZ
         GWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739223370; x=1739828170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FqqX7ElFp9wIqiTogqx4ZkugO9mCs5sfeq9wlnFties=;
        b=nfjGiqpgyu3otvrZAhaXT3GoziCvieDa7OGH45SDJf7Zx3kT0FOltF44fYxSjGT/wU
         v39Soktz2EaK6otcjLCLOf/zDJKGC/LQ7IW2dlMdoC4eWzjkCaIr7nrWK658frwrK8LJ
         iiZUddLxjNmoNCDRHXPgGURcZHATGpIVTGsKGZhpGHjTji40/WxsvJgvUZupzgRDmnot
         EkxgQE7Z8tws0Ltl8LJKpHmcaUevhZB2tSB9Fza1JzEleXjoBdZE8i5ObR903jRHi/gV
         lugB0071r96/Ql05UTB+GmFezBfg/0KOK+ZnubLm3WOV4s6cgLH1J5VO7O5gzeyECC6S
         1v0g==
X-Forwarded-Encrypted: i=1; AJvYcCXh2Tz1PNFwA6xomeIO2Ahqra2icOmOFQBM3buhwsvZahekHuNoxRlXbV915ui3A6oikwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxC3zplaxBKzeYKPIU6WvcQr5/fv895Mli58GjDnfbO8lRUqcwb
	ikPNWphRcXC7Mao/jdlXcH5rO4XtyxuXThMFChaFX3MmHewGeZ2usP5OteMRXIo=
X-Gm-Gg: ASbGnctptcdOlmwH20ojkV8PGMB+wFidgK4jbWXn5uORiWJ409epC1V9Ts1utDEyNF6
	wAZMtUMkUtIvaqcDuRwnHSUQGdEhZ+2eLI9wO7FP9QMnSCQCfpqkAsx0FNfcxyUNHeJTVxEZgAp
	CPNYBoO8T9fo2yLlrTZfIMsNhZWwCTal7n2phIsQjt65HSaMdsImRqJUQA/NugxvWFsUa4LuCRX
	Cjq4WVvPGNQEQgdXV8sFfqEmKeU13nHj+VjAuL8ne6K5jz/kmdgPTGVo+JdFihc6kkaeswnYY04
	6UKSIrU630oAxl/J
X-Google-Smtp-Source: AGHT+IEI+PbDSd+iZWI542rdQ+gdbkP59WcT5edYepFvbp4hadsR2YRTr4AHJJDYEwdy2nUI6Xz3fQ==
X-Received: by 2002:a05:600c:8706:b0:439:350a:ab52 with SMTP id 5b1f17b1804b1-439350aacbemr92952605e9.30.1739223370401;
        Mon, 10 Feb 2025 13:36:10 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394376118esm47541515e9.40.2025.02.10.13.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:36:09 -0800 (PST)
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
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 05/15] riscv: misaligned: move emulated access uniformity check in a function
Date: Mon, 10 Feb 2025 22:35:38 +0100
Message-ID: <20250210213549.1867704-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250210213549.1867704-1-cleger@rivosinc.com>
References: <20250210213549.1867704-1-cleger@rivosinc.com>
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
---
 arch/riscv/kernel/traps_misaligned.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 57ded7e74dd8..7d6185deea33 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -673,10 +673,20 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
 	return 0;
 }
 
-bool check_unaligned_access_emulated_all_cpus(void)
+static bool all_cpus_unaligned_scalar_access_emulated(void)
 {
 	int cpu;
 
+	for_each_online_cpu(cpu)
+		if (per_cpu(misaligned_access_speed, cpu) !=
+		    RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
+			return false;
+
+	return true;
+}
+
+bool check_unaligned_access_emulated_all_cpus(void)
+{
 	/*
 	 * We can only support PR_UNALIGN controls if all CPUs have misaligned
 	 * accesses emulated since tasks requesting such control can run on any
@@ -684,10 +694,8 @@ bool check_unaligned_access_emulated_all_cpus(void)
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
2.47.2


