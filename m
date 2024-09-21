Return-Path: <kvm+bounces-27237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD0B97DCCB
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 12:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEE1A282046
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 10:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BD216EBE9;
	Sat, 21 Sep 2024 10:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmwQknQA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0597462
	for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 10:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726913317; cv=none; b=YRR+wKBmkwwerJPRt1b9wtRIPR9Kwyxhn5WR2iP0JRqxDYQAx/lI/P2VQa5dL+8ayx4fX3igWp/jjdTSuLimC3g7BFU9m6QxqXyV8UJQlCyOZl1Z9sZinZJLu+oZsaGojiIaWe4johlDOgT9Y75lVo/5S9Mmxwii0P8QXrmfIEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726913317; c=relaxed/simple;
	bh=Yq/HGWMi01YsA33uHiv+rVVdMQiUcIdwqs4TiAA/dRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7Cqipdd4trm5IorstGK55rNrCJSjPaqnbmTusEtAPKCFd2cUZAIilDHB3oKV5C5wryn5pkm3Jeqp+SJ2osgrEbA1Go5LCA+gb5jCwZzCx3qmGjjIA0TPP9CqOUjEkWqrmVIawu1ziOqBFL8dFJ4HBVJT2NZqueOA6GRABp6lnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmwQknQA; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2d86f713557so1965818a91.2
        for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 03:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726913314; x=1727518114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3+lWDZEHmN56oixuRbeFyTMvYNLchXuOs8thZyGBJ8A=;
        b=KmwQknQAmNRM7rsGFmdHkPvNxsFdLBhk8Rne4CwahcGoXJqZL+lUPetl7BsBj970u3
         VOCl3AhzS/OuhtBo3aBqjzJJF/oTIEVmnT/tabuYyHg0+b0bknotjfcLrmROy8mAOUUW
         XTaE+ZOJhjTgfmp2Ck6o1cngs0OFdrOjd2A7B1goVP7QiPwAmdCw+RwOB0QJk/hn+bjZ
         tp07A85I2TO2jZiR96fNg71A6Gp2paXQInELaZ6gd4MznHmk/osherxPbR6bWeTJQn+I
         oJhuThWAkcUz+F2ie2U5CBvGHm0x1xtOptYeRRxpOM1BG3jdjDVSb+UEP13ki5A8b/Z8
         3uMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726913314; x=1727518114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3+lWDZEHmN56oixuRbeFyTMvYNLchXuOs8thZyGBJ8A=;
        b=HeTMQ6yB2vN6R0sRsCLSCLtP1S4wt0rbsNb6O14hS9fIwpu+moR3ocH8l73eL4a9Ho
         BVppkKulmNmpKNNMfXa5kjfzh4ya0OBVgiqVLqFWeshBSfDdrA21s2X+8e16N+6RbKhn
         xIeQlC38jDdfY4eaoeK6SKy7TH7xlr2T2wP3ag6Y+ZQiqFcVQaiiwvalsn0S0EhdgZEA
         qxBbP+2DqOE61JnbM5RL+P1fIk4XySHm+Q6thReLeCzpXsh8EmFIfhQYL48ycYuieK77
         kQVCFy2CvTzoRfzbugs/yO+f/GubXbDPBdaH3AgySU391XKHEva4Rr9vmU+NgZn/GQd/
         ZKOw==
X-Gm-Message-State: AOJu0Yz6+MFLXsm00arbGCLjv5TZDIudaviKYHCy7p8sbzSto9KqtCgU
	+MJU8g9BRVrCTaB9Dxq1l06T1RXUgOpodwAaTR8pJNdk7LuYENKgVRu8j8/cYic=
X-Google-Smtp-Source: AGHT+IGKUsffdrHxIzE3d/DHgSZsNCzr99MSQUpTOnVUppTgmwqbTml2vivywG1w9+5uvpycTOzW0Q==
X-Received: by 2002:a17:90a:7e8f:b0:2d1:ca16:5555 with SMTP id 98e67ed59e1d1-2dd80ced348mr6893626a91.37.1726913314209;
        Sat, 21 Sep 2024 03:08:34 -0700 (PDT)
Received: from JRT-PC.. ([203.116.176.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee7c03fsm5680024a91.11.2024.09.21.03.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 03:08:33 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 1/5] riscv: Rewrite hartid_to_cpu in assembly
Date: Sat, 21 Sep 2024 18:08:19 +0800
Message-ID: <20240921100824.151761-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240921100824.151761-1-jamestiotio@gmail.com>
References: <20240921100824.151761-1-jamestiotio@gmail.com>
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
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm-offsets.c |  5 +++++
 lib/riscv/setup.c       | 10 ----------
 riscv/cstart.S          | 24 ++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 10 deletions(-)

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
index 8f269997..68717370 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -109,6 +109,30 @@ halt:
 1:	wfi
 	j	1b
 
+/*
+ * hartid_to_cpu
+ *   a0 is a hartid on entry
+ * Returns, in a0, the corresponding cpuid, or -1 if no
+ * thread_info struct with 'hartid' is found.
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


