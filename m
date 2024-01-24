Return-Path: <kvm+bounces-6798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C420B83A2C0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CA9728C80C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C38D179AB;
	Wed, 24 Jan 2024 07:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Oom3th1Z"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440B717996
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080749; cv=none; b=l2gyRAyhCzXBOqdegKudrBFgPw301Uf/kHvtpwijhf33DDzhTJvovH4/mfwkUXHbPFUUtBe73TUc05iduEEHPHoPEuaoeREYTAiL+Rrcvr9WYDOljQ5rym8AX1ymF1+Wa+i2WyxbLV9cakSYn8QyfGwOBwshBasfhE08T4xbwWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080749; c=relaxed/simple;
	bh=m60uDdPImC6rpNMPUvAiXNIi+HOrTC+6Pb81bECFi7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=UO+b9mi6zO/zLojmS4bEJfFGXpXYoCApYRfoEpzfX06/X0p5gczXKfD5MTXGUeyDiugZ3E/adFmvhqepLUnNeE3aQD/O2WhtZl9HBC3CH6X1b4mfSXjNwZ22hTD0h5vSCn5bzmY0QP3N0XyUY8JLSLptOKtuGDCZ18PfPn4N9Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Oom3th1Z; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W5ER7zGbWaZyAzUw+ka7UlCkT928S+9fT/vtRRe0CWE=;
	b=Oom3th1ZdlbFeciRdA8JC9HShXEx9JE21xyagN5Fz+caCeVEuAU1q3Fx4hJv/5GMdXokM1
	RdbG/vOu109JqOoO//e6EN+H2l3Uad/ZV3rEb7UG4xj1zAEbcUtQmvExqeT38r1Uo1P5vu
	liXR15bRH6/HM0GHaiX4MSANW9KFAYw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 19/24] riscv: Enable the MMU in secondaries
Date: Wed, 24 Jan 2024 08:18:35 +0100
Message-ID: <20240124071815.6898-45-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Set each secondary satp to the same as the primary's and enable the
MMU when starting. We also change the memalign() to alloc_pages()
to prepare for enabling vmalloc_ops. We always want an address
for the stack where its virtual address is the same as its physical
address, but vmalloc_ops.memalign wouldn't provide that.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm-offsets.c | 1 +
 lib/riscv/asm/smp.h     | 1 +
 lib/riscv/smp.c         | 7 +++++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index f5beeeb45e09..a2a32438e075 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -53,6 +53,7 @@ int main(void)
 	OFFSET(PT_ORIG_A0, pt_regs, orig_a0);
 	DEFINE(PT_SIZE, sizeof(struct pt_regs));
 
+	OFFSET(SECONDARY_SATP, secondary_data, satp);
 	OFFSET(SECONDARY_STVEC, secondary_data, stvec);
 	OFFSET(SECONDARY_FUNC, secondary_data, func);
 	DEFINE(SECONDARY_DATA_SIZE, sizeof(struct secondary_data));
diff --git a/lib/riscv/asm/smp.h b/lib/riscv/asm/smp.h
index 931766dc3969..b3ead4e86433 100644
--- a/lib/riscv/asm/smp.h
+++ b/lib/riscv/asm/smp.h
@@ -15,6 +15,7 @@ static inline int smp_processor_id(void)
 typedef void (*secondary_func_t)(void);
 
 struct secondary_data {
+	unsigned long satp;
 	unsigned long stvec;
 	secondary_func_t func;
 } __attribute__((aligned(16)));
diff --git a/lib/riscv/smp.c b/lib/riscv/smp.c
index ed7984e75608..7e4bb5b76903 100644
--- a/lib/riscv/smp.c
+++ b/lib/riscv/smp.c
@@ -5,9 +5,10 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
-#include <alloc.h>
+#include <alloc_page.h>
 #include <cpumask.h>
 #include <asm/csr.h>
+#include <asm/mmu.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
@@ -23,6 +24,7 @@ secondary_func_t secondary_cinit(struct secondary_data *data)
 {
 	struct thread_info *info;
 
+	__mmu_enable(data->satp);
 	thread_info_init();
 	info = current_thread_info();
 	set_cpu_online(info->cpu, true);
@@ -33,10 +35,11 @@ secondary_func_t secondary_cinit(struct secondary_data *data)
 
 static void __smp_boot_secondary(int cpu, secondary_func_t func)
 {
-	struct secondary_data *sp = memalign(16, SZ_8K) + SZ_8K - 16;
+	struct secondary_data *sp = alloc_pages(1) + SZ_8K - 16;
 	struct sbiret ret;
 
 	sp -= sizeof(struct secondary_data);
+	sp->satp = csr_read(CSR_SATP);
 	sp->stvec = csr_read(CSR_STVEC);
 	sp->func = func;
 
-- 
2.43.0


