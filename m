Return-Path: <kvm+bounces-43576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA03BA91C02
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50EFF7B18DC
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10B424CEFC;
	Thu, 17 Apr 2025 12:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="YxAnZnFd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F872472BD
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892722; cv=none; b=qx5EFb+WnszBhiMRDG63+NVy7+xCQMGvsX5d/Lg1dotFUPXX4FyJZRhUJjS/7vGW3OphGWWxTR6zf3A+vkmyDzoZN6WuPMJufa3LNPR7r038Woy6cU5lBODUaqkpEQzo4WHBFJCVzIEDr1U+Osw/mfJ0LCz+Do3wbhZ/cMC4+ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892722; c=relaxed/simple;
	bh=EovtyHw9idZFNwtsYlCnzb9BpVvdfog+V7fNy74G0ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBBYXpb2DUP0EY3eZGXGfDgtUEIRcFnYXlG5YSq+17jBoN326hsX2e9O5nMOPRY23tsh+8N7zrkOosdbfcN5raRu1vXjr2DiIlK+HolN3AGNthn7see0A4Dx4syzYJ7mGkcznY2DIy7tC3SfL+X+paFKpOEAZR0vK6HyNH4z/Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=YxAnZnFd; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22c336fcdaaso7957285ad.3
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 05:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1744892718; x=1745497518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZnuSlMP6ZuwANzL9lETdaARYZp01YtNV9fLw8GSKUw=;
        b=YxAnZnFdjVu5gHkkao1RamPbDun2+eJGZ96H+jcRzfY99EYkmBRdovrb/zuWmBuLGF
         /vm3UtI+rDHCd6jVWTThMHRmppDhiG2Uw73HbKc3uJnD0OEN7mJ/hfboLSwuBj/M1nvi
         0VTcokaXVSoRcweOfmOhXdyS01tRWi+PHt8I1h6eJPLOajaTV/egiXaZzEOSzPmapj25
         kg6yWyU27GGfh36Vl7z+YR3rMvYb+zbF/f/UJcEuRvXuhrZdRDN99ti7EAliF2m6egh6
         48BhqxVEQEupVYxsHAaMU/x+xGxMG1uGpQilEj72yYRLMQJz3POhj+LljvNa3NnJoMTw
         SHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744892718; x=1745497518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QZnuSlMP6ZuwANzL9lETdaARYZp01YtNV9fLw8GSKUw=;
        b=qjgiSVSsmGQkDtotEDjuRST3/u5Kmaczzg/Y8RyCFOBdbZ5mAl2bw5qgrT5lam1jaU
         hGIhW1Qw5caBrUetmAMM/4Md8qUVMLyoWiWuVUJqFKhHgYfZ4BqiGco3qcLmZ5PNMUCE
         0vbpybjZFwcWC6kl/15H6QgjvKemadWmasnQyTFegryk8hRmOCBREtunAHlSfsm+/4S5
         qchZlKucukQ8FPDH2QLSLI1eAPLLz2VXxJo6pWhvqWI4VDhj+9znTTBQAqsAhXDYuMRD
         EM6G8VGqe2mKxN1MMNi7o86giXc6ViKNxo+9zLO9oOOm0l7/TCRvjdBpCw4IztbVPWxz
         x+qA==
X-Forwarded-Encrypted: i=1; AJvYcCXB3D4z/6utGWN7u12D3zF4SRGRQVsL9TG2xSVYJZiMTmlm2E0Rz7D5pCh+p2aS8GfNKU8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5rC6yzNT+pQSkzB8f0AwKxooRbHu+lycttu9rrWFcee7mfAGN
	lAxkxguxB2r8D/LrvrBEBvhFdnfS1cDbRsblPFOYS45sPI1iE9Wa4dkVr64wN84=
X-Gm-Gg: ASbGncvxKnXmrwlITKPRwI+t7YrZ/ZHk8DSxVy2fYny0VbVYYLXj2mecyFW/XefGEA/
	v+TwRNDhKgilmXRaO1db5JjNic3LahzEKT7xXgObKd2wt8wmk+p4wM/lZHtC60ketewdUb046vW
	Sco/9W5yf93uSRfFgXx3FSYRqrLf6qUVVl7ctUjX5RJ3582AhuMyFIgZlU4AJAxpguUIHQeorkD
	5v3s9Gh2UIOE6I2cLYkWLhKnSfZVsYGCbI+nl0vHpwu9vhkkBevDlWkq/g4WD/TRUXSaEd6Qp9E
	HCo7Mq+Xk3qu62SZk8J3fE0ZGtLi2HiBZB4FgZx9FOu3LYpM/yYq
X-Google-Smtp-Source: AGHT+IFn+UkDwIOY/e3sKBsC4N9k8AEuCmWtLw7UPdTMPKcDNDFZ5/adGOe7oxZT/yFghuiQ5DQrlA==
X-Received: by 2002:a17:902:e808:b0:216:2bd7:1c2f with SMTP id d9443c01a7336-22c358db9abmr72649025ad.18.1744892718633;
        Thu, 17 Apr 2025 05:25:18 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c3ee1a78dsm18489415ad.253.2025.04.17.05.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 05:25:18 -0700 (PDT)
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
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v5 09/13] riscv: misaligned: add a function to check misalign trap delegability
Date: Thu, 17 Apr 2025 14:19:56 +0200
Message-ID: <20250417122337.547969-10-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417122337.547969-1-cleger@rivosinc.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
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
 arch/riscv/include/asm/cpufeature.h  |  5 +++++
 arch/riscv/kernel/traps_misaligned.c | 17 +++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index dbe5970d4fe6..3a87f612035c 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -72,12 +72,17 @@ int cpu_online_unaligned_access_init(unsigned int cpu);
 #if defined(CONFIG_RISCV_SCALAR_MISALIGNED)
 void unaligned_emulation_finish(void);
 bool unaligned_ctl_available(void);
+bool misaligned_traps_can_delegate(void);
 DECLARE_PER_CPU(long, misaligned_access_speed);
 #else
 static inline bool unaligned_ctl_available(void)
 {
 	return false;
 }
+static inline bool misaligned_traps_can_delegate(void)
+{
+	return false;
+}
 #endif
 
 bool __init check_vector_unaligned_access_emulated_all_cpus(void);
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index a0007552e7a5..7ff1e21f619e 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -709,10 +709,10 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
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
@@ -748,6 +748,7 @@ static int cpu_online_sbi_unaligned_setup(unsigned int cpu __always_unused)
 {
 	return 0;
 }
+
 #endif
 
 int cpu_online_unaligned_access_init(unsigned int cpu)
@@ -760,3 +761,15 @@ int cpu_online_unaligned_access_init(unsigned int cpu)
 
 	return cpu_online_check_unaligned_access_emulated(cpu);
 }
+
+bool misaligned_traps_can_delegate(void)
+{
+	/*
+	 * Either we successfully requested misaligned traps delegation for all
+	 * CPUS or the SBI does not implemented FWFT extension but delegated the
+	 * exception by default.
+	 */
+	return misaligned_traps_delegated ||
+	       all_cpus_unaligned_scalar_access_emulated();
+}
+EXPORT_SYMBOL_GPL(misaligned_traps_can_delegate);
-- 
2.49.0


