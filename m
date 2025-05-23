Return-Path: <kvm+bounces-47564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B94ADAC20F1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4373B18993E5
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA0D7238C11;
	Fri, 23 May 2025 10:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="yMrtqUMl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7888622A4F8
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 10:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747995717; cv=none; b=mO0HsXZdqDVWhp1dydlh1Dk95I9NDlTsrcA+5kPP3AtDE7/aDuyLYonK7nB7fdlV4E57bsSAqrVO/ggBzCXO+EFi5PtonUoNqivSrGFy7ieIyOiIwJkuUF1FzWWJjDBTx26uSSb/16K+JBddsNwpTuHNeo7qs5FSFn5AyjISjqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747995717; c=relaxed/simple;
	bh=MaIrwOKv+YVVxdhE/r+zc5gTHYqZ311Osy8lrbnqATY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nj8xs3Z1XhnOgBCUoku1k3K20OALKn5UqFYqobLPv9kWzOOB6NZbnM60o3CI1mqylVHIoEonNilNW0g4K7GeDMtGIQNEjvjmTiaTFk/Q6Umz/RYIPMa40OXpz284q1N44dvQnJNcBvxwv99csM5/wWu7NwVaDwGqFI64w3ttbc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=yMrtqUMl; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-74068f95d9fso7843284b3a.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 03:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747995715; x=1748600515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0iF+NUUhZJ5jxYVuPSRzuPMezDiacMrJKv4fNDBdRi4=;
        b=yMrtqUMlz+nxJOf9HsPSzCfSgeQVBPEsX1wp2SxYEMT5QIFZ6VAHO1pj6GnO62LQ0f
         DIHAff2AWzcjxCA2r8kBAOdlhJ9boIswRj/O+BUAkGwZPUGwssQWwZLd/bHfbCc7ytvU
         CrGCLDTUj+iYGk2/GCVfwjrO+W4CdnKsyc3/vTQVHGzUWTWriH5oPJFUn6el4DOruNyD
         I/AB7+e07zmpMO4H/6It1VZz1v7IMIgg/RLV1OeErz7O2mndvqyqjxt/Ujou4nawgB14
         GP6vpgUsaJhcLNi1wnzYfG7v1gUeXOM99XcgrvAJL6zRAKe0ESGRdesOxg6Bs8bnaugL
         MBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747995715; x=1748600515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0iF+NUUhZJ5jxYVuPSRzuPMezDiacMrJKv4fNDBdRi4=;
        b=nUryAoN3NRZD5M6ziMlM2hEDRXj6NIQAGQVIUpWc57ogV+hp5BpkwOD+B7blYAtY10
         PRpY/IFfPedEHtWjzR+VtvnqkN/UhCWvNi5oMsSIVzvWbnUfnLT1lLaZDSygmAFO4mVq
         Dtxa11R4VS5iv962ymA9sn7wI2xoRCn2j3ws7bRaLugg/BoaYc1jgoof1OAHi+TSaRKz
         nWhLGuYae7rjBWpzchjiDs4dXz3tAXT2A6XZGSt8BzGwqVMnbMZX+t/DGXIWXpiPDlBJ
         GBwRoI/RxeAOjatPr+KhRZ/054DWnEO/0deRtOLMETpPLFxAakPRughDw2F8qmpGr77f
         /DRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV16tHSRiCxrt+QTuftaZV1DPhTeTvGg5dqL17pj8zW3x0hgtpeutYX9KlNzlOs4fAcjzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHe4faZGqgfBQFiTSNV/Jc5cySUzHl7THHIkintugczJK0yk6j
	cPvv3uoiddnWaSTXQWlCtyW7tD57wHTmN4u1FgzQKM1zYMQdlTqLg9h9Zl7+PtzARtY=
X-Gm-Gg: ASbGncsAvVNWEd1I0bXE7bus6MGkpbkGCAZjSYOxC//VyOMwX+kjSnt/alg/TZi3xZQ
	xmM8aBYueDQCUnUd4kG4xR7iKL/YP11Qht90jGiuxgI3adI1ajANherWEFvepCkzBT6MsXdMgNG
	BcWDUw9n0xQoxpkiMQnCOtCtB8UuBcNlKu5wuv9vJQaITHViL7tIoNNI4Qaf0MaW9ZTX4fDx9Px
	1cKV60s9rzZYslFqHoPf2Zgo8DgjldGChdCXTrI47FZ1+QrgKyOB32/eIGyrLj6eZb7Q2TVEXMu
	M9OsklFl5THDqIj/bw8P3KLZ8opdmyYvG7lDLYVZjvLJHDjk5s09n84q0PTA3yw=
X-Google-Smtp-Source: AGHT+IGnAPommgiaP/CHramKAPhXT2HV8FVP99uDHVdDg9TxfQgHz5LyukuEd2GDLOcnoMCuXHDtSQ==
X-Received: by 2002:a05:6a00:858f:b0:73e:1566:5960 with SMTP id d2e1a72fcca58-742acd507c1mr36450146b3a.19.1747995715587;
        Fri, 23 May 2025 03:21:55 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829ce8sm12466688b3a.118.2025.05.23.03.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 03:21:55 -0700 (PDT)
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
Subject: [PATCH v8 07/14] riscv: misaligned: use on_each_cpu() for scalar misaligned access probing
Date: Fri, 23 May 2025 12:19:24 +0200
Message-ID: <20250523101932.1594077-8-cleger@rivosinc.com>
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

schedule_on_each_cpu() was used without any good reason while documented
as very slow. This call was in the boot path, so better use
on_each_cpu() for scalar misaligned checking. Vector misaligned check
still needs to use schedule_on_each_cpu() since it requires irqs to be
enabled but that's less of a problem since this code is ran in a kthread.
Add a comment to explicit that.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/traps_misaligned.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 592b1a28e897..34b4a4e9dfca 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -627,6 +627,10 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
 {
 	int cpu;
 
+	/*
+	 * While being documented as very slow, schedule_on_each_cpu() is used since
+	 * kernel_vector_begin() expects irqs to be enabled or it will panic()
+	 */
 	schedule_on_each_cpu(check_vector_unaligned_access_emulated);
 
 	for_each_online_cpu(cpu)
@@ -647,7 +651,7 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
 
 static bool unaligned_ctl __read_mostly;
 
-static void check_unaligned_access_emulated(struct work_struct *work __always_unused)
+static void check_unaligned_access_emulated(void *arg __always_unused)
 {
 	int cpu = smp_processor_id();
 	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
@@ -688,7 +692,7 @@ bool __init check_unaligned_access_emulated_all_cpus(void)
 	 * accesses emulated since tasks requesting such control can run on any
 	 * CPU.
 	 */
-	schedule_on_each_cpu(check_unaligned_access_emulated);
+	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
 
 	for_each_online_cpu(cpu)
 		if (per_cpu(misaligned_access_speed, cpu)
-- 
2.49.0


