Return-Path: <kvm+bounces-47567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C12AC20FA
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75525188B6B8
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BFC23C4F6;
	Fri, 23 May 2025 10:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="F4BLMmvU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C76522A1FA
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 10:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747995746; cv=none; b=t8KJa0jzSwiuS9u3Y0RNOS1yQ+AxfUWzyOqTdeTzmGKYXWPTbyi1T3f22Ij3p+DMAEVOy1cTWz1kxp48b+h7nbpygYFc8pjnKgv6h0Uo49R8DDD/2/aabcnK8jFmYouOL3J1scSGeapUXAk2vK1Syys2kiDbIZ8uvzNokh4CRJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747995746; c=relaxed/simple;
	bh=ViCP/GXPR6c4TqOEA6RHPSeoT6XgmF7w9rLMCocIqJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KD9ljSSzQVVS+t/3bTD2gJctD2pakW/KVeXjrwrh3GvQelcgARseJ0t5KgtRhW/1HzB5gaGaey2HatCeu0UUKey7nPsk8MdQaBabPlrKJqKxKeJW/yTMxV3UduRWb0fPW4Smbmg2EOg6XsGgv7NUuvqDMaGrBbWWHSwNhRox/3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=F4BLMmvU; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-742c3d06de3so7019759b3a.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 03:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747995744; x=1748600544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJlHvKZgzBuDLrZteqciLWVF8ALRj3f5YDjK6RzEUVA=;
        b=F4BLMmvUragUW4s7HyKp0BYbTKVW3t5KE14GnKOGodHwi/oOQ9epFFGVDSTCc2EGCE
         unmJMniOabLV+9iCUQEtm36SHxTUHyF9g2kgDZzMfbcD0Zg312zo+BlS5wNhUZh8FePs
         1PqZfkN7IMu6extAbRIVX+t4fRXYmB9dxV4gQnmBJqsFJfaPEvGvWiHuaHCE7tb6KDfi
         iGVxa4AhX+H73k/AGzcJof9GS1RUMkdo6kanbzU6BNBaNPPNxgPEjEFB7UGybGaaJhOG
         CxDoBBO1hc/KeOAnOTbzJZ1S6Uy0S7kGYFclirqXqGhizlUCand9GvD1h2U9OVROTB5G
         X4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747995744; x=1748600544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJlHvKZgzBuDLrZteqciLWVF8ALRj3f5YDjK6RzEUVA=;
        b=pNXUT9gjRjGubLKBw6i127gWEXM0ak0HUc0xeEPaJfsy0JwNNRfEiRQcWm3b06SYcM
         Obzk7sgTaZEszjYKYUhzdcxpPncw15DoQBJFkVP/xV06WGkMsVWw+/oVy1x07vX+Zz/2
         AsCj45IKQCwEW9niGE79tbc6vrsKF2i68aRlRmgbGR/DAejSQGzJqqLd7E8bRo8uVGUK
         +xVZXeekZk610InN9eX6/pAysJ0n920lU6+6MvFswVtjX0ZalT9yh2X5EU17swcLE3D7
         WMqFvZHUpeefaQflOnRfR5MDP6xeITZTSJv5BiBxVWDiz34dj5NWdv1RQC8OtY3hAzK5
         EULA==
X-Forwarded-Encrypted: i=1; AJvYcCUhkgL2mye1L13XVw5iCekafnxKs4Sn7JMC/eMKSIxkNTmXGEnbXK6n/5g0SDwoP3iVa2c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCcZ8rD6hNKDcUy+Hta4zSXR7RgnH9QM7k9lfR8PPBXxfxCJTg
	mBey6m56yyef0cP9p7xBZ5+iBkNWq4C4PFXLNWAryebtRK/ju82ICxM+LsipwzQ4Oac=
X-Gm-Gg: ASbGnctN11MbofYc+5/T4So84yTaOTNxXboyZAtIR0cD9t2jB4E7SbeXP30NxVWeI2z
	vtorDYu2cgBMfSBx8yeRPOn2tCcXXKcdxBSPv3o3Pub8qQs4RwJ3PpI8ZRvC7EPVCZGxriSKWer
	3xbi/UXlIeLbTgao6wZVZAsfahnafgU9ZJoG/HrdM2iZ0gz3AywtsfrcnRFh8WM/mEbLvwUKtRG
	sYQH7Cs1kXAm2yHU+Mx9OB2KLz9eQdEKlz3qdAYbZ11hdLOMuGeyTWlKf0n9U0XotZW8mLOYBqt
	1yHauIgk0CXehmhetbOK3qnSLZkhdT0HR6y/+t2jY1zR02wEYj5X
X-Google-Smtp-Source: AGHT+IGKDj0Vt3rsaPKYZL2nBjHo4cZKOOLzPGlgQIfiludDyBY6vduzzuNU0u8N497C+aWPSTsTOQ==
X-Received: by 2002:a05:6a00:3e0b:b0:736:34a2:8a18 with SMTP id d2e1a72fcca58-742acd75e6amr44078224b3a.24.1747995744354;
        Fri, 23 May 2025 03:22:24 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829ce8sm12466688b3a.118.2025.05.23.03.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 03:22:23 -0700 (PDT)
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
	Deepak Gupta <debug@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [PATCH v8 10/14] riscv: misaligned: add a function to check misalign trap delegability
Date: Fri, 23 May 2025 12:19:27 +0200
Message-ID: <20250523101932.1594077-11-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523101932.1594077-1-cleger@rivosinc.com>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Checking for the delegability of the misaligned access trap is needed
for the KVM FWFT extension implementation. Add a function to get the
delegability of the misaligned trap exception.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/cpufeature.h  |  6 ++++++
 arch/riscv/kernel/traps_misaligned.c | 17 +++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index 2bfa4ef383ed..fbd0e4306c93 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -81,6 +81,12 @@ static inline bool unaligned_ctl_available(void)
 
 #if defined(CONFIG_RISCV_MISALIGNED)
 DECLARE_PER_CPU(long, misaligned_access_speed);
+bool misaligned_traps_can_delegate(void);
+#else
+static inline bool misaligned_traps_can_delegate(void)
+{
+	return false;
+}
 #endif
 
 bool __init check_vector_unaligned_access_emulated_all_cpus(void);
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 7ecaa8103fe7..93043924fe6c 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -724,10 +724,10 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
 }
 #endif
 
-#ifdef CONFIG_RISCV_SBI
-
 static bool misaligned_traps_delegated;
 
+#ifdef CONFIG_RISCV_SBI
+
 static int cpu_online_sbi_unaligned_setup(unsigned int cpu)
 {
 	if (sbi_fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0) &&
@@ -763,6 +763,7 @@ static int cpu_online_sbi_unaligned_setup(unsigned int cpu __always_unused)
 {
 	return 0;
 }
+
 #endif
 
 int cpu_online_unaligned_access_init(unsigned int cpu)
@@ -775,3 +776,15 @@ int cpu_online_unaligned_access_init(unsigned int cpu)
 
 	return cpu_online_check_unaligned_access_emulated(cpu);
 }
+
+bool misaligned_traps_can_delegate(void)
+{
+	/*
+	 * Either we successfully requested misaligned traps delegation for all
+	 * CPUs, or the SBI does not implement the FWFT extension but delegated
+	 * the exception by default.
+	 */
+	return misaligned_traps_delegated ||
+	       all_cpus_unaligned_scalar_access_emulated();
+}
+EXPORT_SYMBOL_GPL(misaligned_traps_can_delegate);
-- 
2.49.0


