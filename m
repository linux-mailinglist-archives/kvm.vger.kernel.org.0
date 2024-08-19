Return-Path: <kvm+bounces-24480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D8E9560FE
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 04:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DEACB21FEC
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 02:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8BC1CF83;
	Mon, 19 Aug 2024 02:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3wwMANQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD682868B
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 02:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724032899; cv=none; b=isCCB1M0ZKJ8zvZd2Sxie5m3epeKk0qFJugFVggy0eLf6f0EdPkFfMhmqT7HroXoN7vOWLNaYRglCkL9ZP5UbglnpfDA4oSUuPn2bh0QRAPqlXZ1srFmnYJ/pLIU2bA407EC5RTTDWeiHuCZ3b/0G3o6B0OF4oRjuGeIWmuz/1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724032899; c=relaxed/simple;
	bh=4wRaM24W7t0aEkuh5D5falSREO+LGukyHgUD7ypB0zM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SIJwdXxXS0zJ4oun/vlyVYtmREHG6PVt8cdiHnHtGE+rkbJLFzbWnyqIixwyU87uWX1hFn8C+rajQyNdLJ1i+VjLoMGYUS8HGl03LaEY89KgWqR3V8Zv7q2UKwdx5BqSMdT1DV9vUB/Pi9NssgM7nxC22pzPxGJnVfLsJAzefNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3wwMANQ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7bcf8077742so2891588a12.0
        for <kvm@vger.kernel.org>; Sun, 18 Aug 2024 19:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724032896; x=1724637696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SuVOPQxv5sxQHAxF11qxHLkDDNYe+vMKbWKMzCBMM5o=;
        b=N3wwMANQjxUoG8BWkossQ6kam2JcLdniq6UCIVYni2V5JL6qEmc2+KiZ8HVcNZhN1t
         LAV3mSGNhlGgClpt7GHwK9sbNEg6Jpvmsx1r9a7vznFWnjXQWuPvVzIHKVaptpgnFTcA
         1XvscuWkCZHMiBQ3/yNvvFxPgwb9qaGSryjgOPDWv9CVF57f/Ou5i0Xz4EfqMzOoTpK2
         qwGyRFyDax7obZd9dOm9L1RpSbkrSCbm+PSq6IKnsGrTjQ/58Sjjn2NfMjhKbVGbxqqy
         Cea7g6aJ+AiRLbv4jXPU+Sl6a1zO+uXL8eDUIbdBJRzdwV78krV/H545LsmUp6/iogKu
         Uycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724032896; x=1724637696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SuVOPQxv5sxQHAxF11qxHLkDDNYe+vMKbWKMzCBMM5o=;
        b=TaFpRUsVmfD3KoDyfUMoLxGY2lPBKZuZQIns0zp/Lj5TVlfXYbXmtkA2IANoclUDyg
         xU/gQ5MridlcufuPVcVbmCjo1k3IIukShsumk0DjkLmVEXz6iTJ2ETZovhBtb5pJ+u+l
         khzgObx2qe7ijlK2Le911WcS2teQU//ZkXLf/fztAkdcAF97btfgmqFfqBtlt9WuwaUx
         fG7CmY8wzQe2OwBaDo54wgLwfT+hfiRwX7eoUxYil3+e/Yw1oNm9LBm1RNXtc8Is/gNd
         OXhbJUpDRrVUJ6VtdDk3xCipWBN1F9neyGBzDfD5qgwWoZlo030nlVz1skn+u/itIlhs
         9YAg==
X-Gm-Message-State: AOJu0YwiU4q6XRPr0hgsOtuoqvaq4LkBuUn/m/bFRYDuSXwugrLbAQNg
	kgOX/5hDH7CeTK5fPz5wL2X6LEiVW8VvONEkR89dYNG+94z3nKqXRJRN5e8y
X-Google-Smtp-Source: AGHT+IHurZNRdGJVAwIUGml3i1ty+NZNFBQLI22yX8T7e7GMSCZE6QoKHOYPBEvhxPFD/clNZRrIDA==
X-Received: by 2002:a05:6a20:9c93:b0:1be:c929:e269 with SMTP id adf61e73a8af0-1c90501fb2dmr13466463637.34.1724032896353;
        Sun, 18 Aug 2024 19:01:36 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-75-144.hsd1.ca.comcast.net. [73.185.75.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127ae06b42sm5748582b3a.51.2024.08.18.19.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 19:01:35 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH] riscv: sbi: Add IPI extension tests.
Date: Sun, 18 Aug 2024 19:01:29 -0700
Message-ID: <20240819020129.26095-1-cade.richard@berkeley.edu>
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
 riscv/sbi.c         | 138 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 47e91025..d0abeefc 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -20,6 +20,7 @@ enum sbi_ext_id {
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
+	SBI_EXT_IPI = 0x735049,
 };
 
 enum sbi_ext_base_fid {
@@ -49,6 +50,10 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
+enum sbi_ext_ipi_fid {
+	SBI_EXT_IPI_SEND = 0,
+};
+
 struct sbiret {
 	long error;
 	long value;
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 36ddfd48..c339b330 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,11 +6,14 @@
  */
 #include <libcflat.h>
 #include <alloc_page.h>
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
@@ -23,6 +26,9 @@
 #include <asm/timer.h>
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
+static prng_state ps;
+static bool ipi_received[__riscv_xlen];
+static bool ipi_timeout[__riscv_xlen];
 
 static void help(void)
 {
@@ -45,6 +51,11 @@ static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long
 	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
 }
 
+static struct sbiret __ipi_sbi_ecall(unsigned long arg0, unsigned long arg1)
+{
+	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND, arg0, arg1, 0, 0, 0, 0);
+}
+
 static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo)
 {
 	*lo = (unsigned long)paddr;
@@ -420,6 +431,132 @@ static void check_dbcn(void)
 	report_prefix_pop();
 }
 
+static int rand_online_cpu(prng_state* ps) {
+	int me = smp_processor_id();
+	int num_iters = prng32(ps);
+	int rand_cpu = cpumask_next(me, &cpu_online_mask);
+
+	for (int i = 0; i < num_iters; i++) {
+		rand_cpu = cpumask_next(me, &cpu_online_mask);
+	}
+
+	return rand_cpu;
+}
+
+static void ipi_timeout_handler(struct pt_regs *regs) {
+	int me = smp_processor_id();
+	ipi_timeout[me] = true;
+	report_fail("ipi timed out on hart %d", me);
+}
+
+static void ipi_irq_handler(struct pt_regs *regs) {
+	int me = smp_processor_id();
+	ipi_received[me] = true;
+	report_pass("ipi received on hart %d", me);
+	
+}
+
+static void ipi_hart_init(void *irq_func) {
+	int me = smp_processor_id();
+	printf("Installing IPI IRQ handler on hart %d", me);
+	install_irq_handler(IRQ_S_IPI, (void *)ipi_irq_handler);
+	install_irq_handler(IRQ_S_TIMER, (void *)ipi_timeout_handler);
+	timer_irq_enable();
+	while (!ipi_received[me] && !ipi_timeout[me]) {
+		cpu_relax();
+	}
+}
+
+static int offline_cpu(void) {
+	for (int i = 0; i < __riscv_xlen; i++) {
+		if (!cpumask_test_cpu(i, &cpu_online_mask)) {
+			return i;
+		}
+	}
+	return -1;
+}
+
+static void print_bits(size_t const size, void const * const ptr)
+{
+    unsigned char *b = (unsigned char*) ptr;
+    unsigned char byte;
+    int i, j;
+    
+    for (i = size-1; i >= 0; i--) {
+        for (j = 7; j >= 0; j--) {
+            byte = (b[i] >> j) & 1;
+            printf("%u", byte);
+        }
+    }
+    puts("");
+}
+
+static void set_flags_false(bool arr[])
+{
+	for (int i = 0; i < __riscv_xlen; i++) {
+		arr[i] = 0;
+	}
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
+	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
+		csr_write(CSR_STIMECMP, ULONG_MAX);
+		if (__riscv_xlen == 32)
+			csr_write(CSR_STIMECMPH, ULONG_MAX);
+	}
+
+	report_prefix_push("send to one random hart");
+	set_flags_false(ipi_received);
+	set_flags_false(ipi_timeout);
+	int rand_hartid = rand_online_cpu(&ps);
+	on_cpu(rand_hartid, (void *)ipi_hart_init, NULL);
+	unsigned long ipi_rand_mask = 1 << rand_hartid;
+
+	ret = __ipi_sbi_ecall(ipi_rand_mask, me);
+	report(ret.error == SBI_SUCCESS, "send to one randomly chosen hart");
+	report_prefix_pop();
+
+	report_prefix_push("broadcast");
+	set_flags_false(ipi_received);
+	set_flags_false(ipi_timeout);
+	on_cpus((void *)ipi_hart_init, NULL);
+	unsigned long ipi_broadcast_mask = (unsigned long)(cpumask_bits(&cpu_online_mask)[me]);
+	puts("online cpu mask: ");
+	print_bits(CPUMASK_NR_LONGS*sizeof(long), &ipi_broadcast_mask);
+	puts("\n");
+
+	ret = __ipi_sbi_ecall(ipi_broadcast_mask, me);
+	report(ret.error == SBI_SUCCESS, "send to all available harts");
+	report_prefix_pop();
+
+	report_prefix_push("invalid parameters");
+	unsigned long invalid_hart_mask_base = offline_cpu();
+	ret = __ipi_sbi_ecall(ipi_rand_mask, invalid_hart_mask_base);
+	report(ret.error == SBI_ERR_INVALID_PARAM, "hart_mask_base");
+
+	unsigned long invalid_cpu_mask = 1 << invalid_hart_mask_base;
+	ret = __ipi_sbi_ecall(invalid_cpu_mask, me);
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
@@ -431,6 +568,7 @@ int main(int argc, char **argv)
 	check_base();
 	check_time();
 	check_dbcn();
+	check_ipi();
 
 	return report_summary();
 }
-- 
2.43.0


