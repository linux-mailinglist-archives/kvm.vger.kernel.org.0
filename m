Return-Path: <kvm+bounces-25026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1593395E93B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 08:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 639B4B20D05
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 06:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941548286F;
	Mon, 26 Aug 2024 06:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZXarhqwx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B7B770E5
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 06:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724655084; cv=none; b=d9NgCPpvKPD2YfvF66vwHDZbOnhZNev0L/Nj9mkh+koRDJsltnRWYxlwk+piiJ73lsPvUpMjidW1DCra6mZXC/ymBZuBR3nMT4ATzeLNcCoBMZqEWUMKcopGb+cdcDc8GJ0tkoAkRhAvJ7XppH5hq5gQhfZ1LrYBbZIFCtLRl7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724655084; c=relaxed/simple;
	bh=KKvj3w7etfqc1K2X6SVEUh5AaT8Gup8kLuWSr1hIA64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DGdXIJbB1hPjTSuE+XZiaiO2vfESpRCea6dSuITdmZiC4tzK4tESDE3MyZ3IykMqoFgiKguouTfey+ASughWVJCStlOafa4Hd8u6Z5bREsRBQxbOpVWXEdgpgPZdnn0JdJN233A7sw/RkVKlDj3KwCkToB013O7qfJGNP03Cg+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZXarhqwx; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d3badec49eso402154a91.1
        for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 23:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724655081; x=1725259881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=se3mdb/risauRFxkHzcN/FTMa2DFSjwMuWTE+xfJYIM=;
        b=ZXarhqwxPXXD+VybNzb+sDNFE7tY79P3ZK6fZJ2bxhbzp4BoIxFp0IR/M0EBdGVu8P
         raXdmILk1453gWuE6oUB26/ibJ2EM5rMaHf+2LTwRJTmskG8Ig3LT0Re8DEdBunjDKIa
         fzqY12zftaBxQuwm8JrWYZ2/1lnSmWbzSdx5A/d9H+oa7uphquZzcsnSFtEqMzD/HNlw
         iQueLupX4isoaU+aNBPXRegkK65VndC/FiTfjMhNnrLgqmqtQzz9XP/PFHiy94oRWhUF
         SwPuQCLM159micoaOVVAxuHeaFAC3IGJRdgnI7JTw78RiFCjfw7BDc6SD6c5sCE/3O98
         Ohyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724655081; x=1725259881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=se3mdb/risauRFxkHzcN/FTMa2DFSjwMuWTE+xfJYIM=;
        b=q/xM0MOtLH4tmgzvqJ+txFaANtw6zCVavWYucMPSMEDWAOrjgoKWo9OtMLT2nSy52s
         9Bz1HCBDOBYnDlJipWAOnfToB3ZtqdN6ehFPlY9TDh81VFqfZVhfovYpjAaW8bSnbxTT
         wXqwra7KyeocdaUNoZs8eJnFnZBmDXRL9PZ5I8IliWU5OxMgPENfTVJKkU1VxUai83Ic
         0jbSB9M79rpx7Z0GD7fY2KkpsuReYWG51j8ugdn13kEJY2i5dcgePi+ciQEGGsv3RYEp
         lapWQ2rPYYLTk+lDOAEfpyRJn2hA7w4wk+zew3Y/xLMfWW68w8OKslMSaHlhKZD5qbt7
         BqXA==
X-Gm-Message-State: AOJu0Yw3Hgyi0K8jfR6m3AECD6gpPzY4n4N9tqMzdBl3116adVBk2RVI
	uIOdyYzK0wtwYLchUkduhPLOhYxyzXosxXiguAnwdJDWOsDcH2aLKzMNwbsc
X-Google-Smtp-Source: AGHT+IErqxGzx8oG3Odc2gUEgyjMPkAaxDOv/RCNyQ+GkGfYEkA6EeHxY5AIY4gcwX1FiDnQC4oBpg==
X-Received: by 2002:a05:6a20:1589:b0:1c6:ecf5:4418 with SMTP id adf61e73a8af0-1cc8a01c07bmr8221239637.4.1724655081306;
        Sun, 25 Aug 2024 23:51:21 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-75-144.hsd1.ca.comcast.net. [73.185.75.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038557f121sm62477125ad.89.2024.08.25.23.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 23:51:20 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2] riscv: sbi: add IPI extension tests.
Date: Sun, 25 Aug 2024 23:51:06 -0700
Message-ID: <20240826065106.20281-1-cade.richard@berkeley.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests for the RISC-V OpenSBI inter-processor interrupt extension.

Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
---
 lib/riscv/asm/sbi.h |   5 ++
 riscv/sbi.c         | 141 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/unittests.cfg |   1 +
 3 files changed, 147 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 47e91025..dd0ce9a1 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -17,6 +17,7 @@
 enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
 	SBI_EXT_TIME = 0x54494d45,
+	SBI_EXT_IPI = 0x735049,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
@@ -32,6 +33,10 @@ enum sbi_ext_base_fid {
 	SBI_EXT_BASE_GET_MIMPID,
 };
 
+enum sbi_ext_ipi_fid {
+	SBI_EXT_IPI_SEND = 0,
+};
+
 enum sbi_ext_hsm_fid {
 	SBI_EXT_HSM_HART_START = 0,
 	SBI_EXT_HSM_HART_STOP,
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 36ddfd48..d0c33a72 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,11 +6,15 @@
  */
 #include <libcflat.h>
 #include <alloc_page.h>
+#include <cpumask.h>
+#include <cpumask.h>
 #include <stdlib.h>
 #include <string.h>
 #include <limits.h>
 #include <vmalloc.h>
 #include <memregions.h>
+#include <on-cpus.h>
+#include <rand.h>
 #include <asm/barrier.h>
 #include <asm/csr.h>
 #include <asm/delay.h>
@@ -19,10 +23,16 @@
 #include <asm/mmu.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
+#include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
+static prng_state ps;
+static bool ipi_received[__riscv_xlen];
+static bool ipi_timeout[__riscv_xlen];
+static bool ipi_received[__riscv_xlen];
+static bool ipi_timeout[__riscv_xlen];
 
 static void help(void)
 {
@@ -45,6 +55,11 @@ static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long
 	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
 }
 
+static struct sbiret __ipi_sbi_ecall(unsigned long hart_mask, unsigned long hart_mask_base)
+{
+	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND, hart_mask, hart_mask_base, 0, 0, 0, 0);
+}
+
 static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo)
 {
 	*lo = (unsigned long)paddr;
@@ -420,6 +435,131 @@ static void check_dbcn(void)
 	report_prefix_pop();
 }
 
+static int rand_online_cpu(prng_state* ps)
+{
+	int me = smp_processor_id();
+	int num_iters = prng32(ps) % NR_CPUS;
+	int rand_cpu = cpumask_next(me, &cpu_online_mask);
+
+	/*
+	 *	TODO: Not sure if cpumask_next should wrap or not. Get this checked.
+	 */
+	for (int i = 0; i < num_iters; i++) {
+		rand_cpu = cpumask_next(rand_cpu, &cpu_online_mask);
+	}
+
+	return rand_cpu;
+}
+
+static void ipi_timeout_handler(struct pt_regs *regs)
+{
+	int me = smp_processor_id();
+	ipi_timeout[me] = true;
+}
+
+static void ipi_irq_handler(struct pt_regs *regs)
+{
+	int me = smp_processor_id();
+	ipi_received[me] = true;
+}
+
+static void ipi_hart_init(void *irq_func)
+{
+	int me = smp_processor_id();
+	install_irq_handler(IRQ_S_IPI, (void *)ipi_irq_handler);
+	install_irq_handler(IRQ_S_TIMER, (void *)ipi_timeout_handler);
+	local_irq_enable();
+	timer_irq_enable();
+
+	while (!ipi_received[me] && !ipi_timeout[me])
+		cpu_relax();
+	timer_irq_disable();
+	local_irq_disable();
+
+	if (ipi_timeout[me])
+		report_fail("ipi timed out on hart %d", me);
+	if (ipi_received[me])
+		report_pass("ipi received on hart %d", me);
+}
+
+static void check_ipi(void)
+{
+	int cpu = smp_processor_id();
+	unsigned long me = (unsigned long)cpu;
+	struct sbiret ret;
+	ps = prng_init(0xDEADBEEF);
+
+	report_prefix_push("ipi");
+
+	if (!sbi_probe(SBI_EXT_IPI)) {
+		report_skip("ipi extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	if (cpumask_weight(&cpu_online_mask) <= 1) {
+		report_skip("smp not enabled");
+		report_prefix_pop();
+		return;
+	}
+
+	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
+		csr_write(CSR_STIMECMP, ULONG_MAX);
+		if (__riscv_xlen == 32)
+			csr_write(CSR_STIMECMPH, ULONG_MAX);
+	}
+
+	report_prefix_push("send to one random hart");
+	int rand_hartid = rand_online_cpu(&ps);
+	cpumask_t rand_mask;
+	cpumask_set_cpu(rand_hartid, &rand_mask);
+	on_cpu(rand_hartid, (void *)ipi_hart_init, NULL);
+	unsigned long ipi_rand_mask = 1 << rand_hartid;
+
+	memset(ipi_received, 0, sizeof(ipi_received));
+	memset(ipi_timeout, 0, sizeof(ipi_timeout));
+	ret = __ipi_sbi_ecall((unsigned long)cpumask_bits(&rand_mask), 0);
+	report(ret.error == SBI_SUCCESS, "send to one randomly chosen hart");
+	report_prefix_pop();
+
+	report_prefix_push("broadcast");
+	report_prefix_push("with hart_mask");
+	on_cpus((void *)ipi_hart_init, NULL);
+	unsigned long ipi_broadcast_mask;
+	memcpy(&ipi_broadcast_mask, &cpu_online_mask, sizeof(ipi_broadcast_mask));
+	
+	memset(ipi_received, 0, sizeof(ipi_received));
+	memset(ipi_timeout, 0, sizeof(ipi_timeout));
+	ret = __ipi_sbi_ecall(ipi_broadcast_mask, me);
+	report(ret.error == SBI_SUCCESS, "ipi sent");
+	report_prefix_pop();
+
+	report_prefix_push("by setting hart_mask_base to -1");
+	on_cpus((void *)ipi_hart_init, NULL);
+
+	memset(ipi_received, 0, sizeof(ipi_received));
+	memset(ipi_timeout, 0, sizeof(ipi_timeout));
+	ret = __ipi_sbi_ecall(0, -1);
+	report(ret.error == SBI_SUCCESS, "ipi sent");
+	report_prefix_pop();
+	report_prefix_pop();
+
+	report_prefix_push("invalid parameters");
+	unsigned long invalid_hart_mask_base = NR_CPUS;
+	ret = __ipi_sbi_ecall(ipi_rand_mask, invalid_hart_mask_base);
+	report(ret.error == SBI_ERR_INVALID_PARAM, "hart_mask_base");
+
+	cpumask_t invalid_mask;
+	cpumask_set_cpu(NR_CPUS, &invalid_mask);
+	unsigned long invalid_mask_bits = (unsigned long)cpumask_bits(&invalid_mask);
+	ret = __ipi_sbi_ecall(invalid_mask_bits, me);
+	report(ret.error == SBI_ERR_INVALID_PARAM, "hart_mask");
+	report_prefix_pop();
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 	if (argc > 1 && !strcmp(argv[1], "-h")) {
@@ -431,6 +571,7 @@ int main(int argc, char **argv)
 	check_base();
 	check_time();
 	check_dbcn();
+	check_ipi();
 
 	return report_summary();
 }
diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
index cbd36bf6..2eb760ec 100644
--- a/riscv/unittests.cfg
+++ b/riscv/unittests.cfg
@@ -16,4 +16,5 @@ groups = selftest
 # Set $FIRMWARE_OVERRIDE to /path/to/firmware to select the SBI implementation.
 [sbi]
 file = sbi.flat
+smp = $MAX_SMP
 groups = sbi
-- 
2.43.0


