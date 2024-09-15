Return-Path: <kvm+bounces-26946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 530A597981C
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 20:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CE151C20AAF
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 18:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FE21C9EC6;
	Sun, 15 Sep 2024 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNVPwG5b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99901C9DF3
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726425310; cv=none; b=Xhkpqmy07y9sJzBWECAmpt1kJeLTSy/eQgkFrcfiMDMaJxnAQm+3KmjZ0lxe2W1VaXOMV9KxpN+AwtKJxH/IP/HI1CArNlU92djORMv4m5b3mTdP0FGIyFQdJANh7L5+ucf4NCUyCZ+MG96ygziFfc6UMx7zTwboresVuHK/CR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726425310; c=relaxed/simple;
	bh=i+LrkneODal7A0KUNklvU3HueYmU2j5tLZ4SiaMqtrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6ORKz6i0FxuNY06B1tdo6WoeopiPGzvuIiN5NXs6j/fzu6JklmA3rKcv4Qj5DFakMqRYdKC6b8LCPwDeHcATf8BnzaZNtxLZK07nOxmWwTH5BROC/Dfcdxs/sqJuBgYj9ua2bzKv1Q3veGy2/rAH5HQbzW+Mni8eiNdACueRi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNVPwG5b; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-718f4fd89e5so3473379b3a.0
        for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 11:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726425308; x=1727030108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LTSemqbVgb/sEkY5N+jEphbkR9WTsGrnAb88vyNg3M=;
        b=kNVPwG5bLURbqPitrxlLOwvSmRStV2wkwu+eu5JkPsmKhzpyKaS/1X3W6RbV1BTEnt
         WjbGiCjeOhRIr9M2OMEXvFozqDXa7ak2XrtfRcKZzaZhtGSS3Mt2SBM/PAEFy8ZRSbum
         0v4KtVIYhLus0LC4OyZA/KFxuXWV3/5m/ZGH3QwwMvRWR7U4cgP0l/AmItw9IAJ1Ll8h
         FOEJMaO3BHzbxgEcN9+PKjEC9gOVrR+fdr1/V+fMjUbluxg974usUcMUZPUiAI1AKq+J
         B4U/K9XjR3i8uVm1VPAoXkezh2wlq3ajn3Wn9Tdd8urI7NPKIV4/7xYwrbUWfn7ZKCdO
         CJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726425308; x=1727030108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9LTSemqbVgb/sEkY5N+jEphbkR9WTsGrnAb88vyNg3M=;
        b=OM42cWItyZaxEPp5XxjD+UTKC9FdbSupau9kaM8aTsha2kOCYeuXzexBViAi8eZ5UK
         FbtFXDzyo5XNq/PzDSp2U3CDF2RG0Wzppa4uEDH6Qho7xZuUlBGn6QPQyN8vcyFE7024
         +/u0OmIig8FrtuexYhC/nKmciozWxkGiNCHMdfLYYujpOpNnx7z03Uo6P6PErfU2kDK4
         cQuoQ3IzoMZQAKU0kqCnGJCTW9/dZCMNqcAn37ZCTFZaYbUZGGHfTkkTnKyOgCth2aDf
         jJvHs5cQaiON0Nw9eEullvwbNOX0OwHNvXk6WfZW6bRAzQN+R4BATwsfnNg5VqyEwjiv
         eMOA==
X-Gm-Message-State: AOJu0YzL/wVddNUNv8ZIbp1wITNfQPLRWGqxRGnoJ+20NYb1JVMcLjPi
	xJxhvQiQ7SOBkSu/yKjAEFtC//woZ4kgSmu797o9q3CA4K71kCscbqW5Iigl
X-Google-Smtp-Source: AGHT+IEJYx8snMnEK1Dol2k51jwYmO3tN2vK5II1BkhfqIXuTsrf0eGkZO3AURKnOYqGhKP8TJpMLA==
X-Received: by 2002:a05:6a00:b92:b0:717:8d81:e548 with SMTP id d2e1a72fcca58-7192606523bmr19627833b3a.1.1726425307601;
        Sun, 15 Sep 2024 11:35:07 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db498de2d5sm2358874a12.15.2024.09.15.11.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 11:35:06 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu
Subject: [kvm-unit-tests PATCH v4 1/3] riscv: Rewrite hartid_to_cpu in assembly
Date: Mon, 16 Sep 2024 02:34:57 +0800
Message-ID: <20240915183459.52476-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240915183459.52476-1-jamestiotio@gmail.com>
References: <20240915183459.52476-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <andrew.jones@linux.dev>

Some SBI HSM tests run without a stack being setup so they can't
run C code. Those tests still need to know the corresponding cpuid
for the hartid on which they are running. Give those tests
hartid_to_cpu() by reimplementing it in assembly.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm-offsets.c |  5 +++++
 lib/riscv/setup.c       | 10 ----------
 riscv/cstart.S          | 23 +++++++++++++++++++++++
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index a2a32438..6c511c14 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <kbuild.h>
 #include <elf.h>
+#include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/smp.h>
 
@@ -58,5 +59,9 @@ int main(void)
 	OFFSET(SECONDARY_FUNC, secondary_data, func);
 	DEFINE(SECONDARY_DATA_SIZE, sizeof(struct secondary_data));
 
+	OFFSET(THREAD_INFO_CPU, thread_info, cpu);
+	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
+	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
+
 	return 0;
 }
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 495db041..f347ad63 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -43,16 +43,6 @@ uint64_t timebase_frequency;
 
 static struct mem_region riscv_mem_regions[NR_MEM_REGIONS + 1];
 
-int hartid_to_cpu(unsigned long hartid)
-{
-	int cpu;
-
-	for_each_present_cpu(cpu)
-		if (cpus[cpu].hartid == hartid)
-			return cpu;
-	return -1;
-}
-
 static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
 {
 	int cpu = nr_cpus++;
diff --git a/riscv/cstart.S b/riscv/cstart.S
index 8f269997..6784d5e1 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -109,6 +109,29 @@ halt:
 1:	wfi
 	j	1b
 
+/*
+ * hartid_to_cpu
+ *   a0 is a hartid on entry
+ * returns the corresponding cpuid in a0
+ */
+.balign 4
+.global hartid_to_cpu
+hartid_to_cpu:
+	la	t0, cpus
+	la	t1, nr_cpus
+	lw	t1, 0(t1)
+	li	t2, 0
+1:	bne	t2, t1, 2f
+	li	a0, -1
+	ret
+2:	REG_L	t3, THREAD_INFO_HARTID(t0)
+	bne	a0, t3, 3f
+	lw	a0, THREAD_INFO_CPU(t0)
+	ret
+3:	addi	t0, t0, THREAD_INFO_SIZE
+	addi	t2, t2, 1
+	j	1b
+
 .balign 4
 .global secondary_entry
 secondary_entry:
-- 
2.43.0


