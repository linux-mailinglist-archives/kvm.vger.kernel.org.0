Return-Path: <kvm+bounces-30924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F6C9BE5C3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 169B31C21885
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4FD81DFD8D;
	Wed,  6 Nov 2024 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h1pBx/cW"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA501DF268
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 11:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730893110; cv=none; b=RFfngQwnwFbHJ/o+OW34DmtLgoLk6YSDg7KJ0vjsLZkEgBaTe1JimqrN4i498yMx5447g6kKSL1wH8zVyNHSL0ZeCZQInbVM1N9LENgzuVeobnzbcQGxCyBJ/nGj3hcP4DwN1MWy14b05AmiqvhvmIzHpAhc8e0gQrAv8Kb/N/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730893110; c=relaxed/simple;
	bh=lE9h260qN76Ms80BPwyPtMndX5EoEKYmNOxUrB9x+JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3XcLjoRDBRy6LPqyHM6MMMCm2G7xImSCfqVWK9ZWrOtNzclbfZqCDQaIJW8F5az3KVfQj2GKPUCRR3JnG0Lj6nia/jf0au0Xn7Ny45BDyywE32PdF42Dh5qp6C+4xcOH6GMjEj+XhCch4g9rA2BnsLQ85LWk+N0/lsJUOB0MO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h1pBx/cW; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730893106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVQZ+vtAuPPUPtcf7+iSeuuM3vx7C5aQKk0deTKTf1A=;
	b=h1pBx/cWxI8zDs59SGTH3rj39p+Vz3S38Wq5RcGJHtpPUqZeaXxmpBBil0q8IJM1wFjxZq
	hi8EHCRLcUUCvbTFPPssI7gUJgcqiTeBBu8LRfKmfyDadJiDSgl/pFHINt/0zgg7WUfhol
	KOj6xI5Tht7mCTJzwPNIvNHF7kgt9CU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: cade.richard@gmail.com,
	atishp@rivosinc.com,
	jamestiotio@gmail.com,
	Cade Richard <cade.richard@berkeley.edu>
Subject: [kvm-unit-tests PATCH v2 2/3] riscv: sbi: Add IPI extension tests
Date: Wed,  6 Nov 2024 12:38:17 +0100
Message-ID: <20241106113814.42992-7-andrew.jones@linux.dev>
In-Reply-To: <20241106113814.42992-5-andrew.jones@linux.dev>
References: <20241106113814.42992-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Cade Richard <cade.richard@gmail.com>

Ensure IPIs directed at single harts are received and also that all
harts receive IPIs on broadcast. Also check for invalid param errors
when the params result in hartids greater than the max.

Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
Co-developed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/cpumask.h       |  13 ++++
 riscv/sbi.c         | 147 +++++++++++++++++++++++++++++++++++++++++++-
 riscv/unittests.cfg |   1 +
 3 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/lib/cpumask.h b/lib/cpumask.h
index 37d360786573..b4cd83a66a56 100644
--- a/lib/cpumask.h
+++ b/lib/cpumask.h
@@ -72,6 +72,19 @@ static inline bool cpumask_subset(const struct cpumask *src1, const struct cpuma
 	return !lastmask || !((cpumask_bits(src1)[i] & ~cpumask_bits(src2)[i]) & lastmask);
 }
 
+static inline bool cpumask_equal(const struct cpumask *src1, const struct cpumask *src2)
+{
+	unsigned long lastmask = BIT_MASK(nr_cpus) - 1;
+	int i;
+
+	for (i = 0; i < BIT_WORD(nr_cpus); ++i) {
+		if (cpumask_bits(src1)[i] != cpumask_bits(src2)[i])
+			return false;
+	}
+
+	return !lastmask || (cpumask_bits(src1)[i] & lastmask) == (cpumask_bits(src2)[i] & lastmask);
+}
+
 static inline bool cpumask_empty(const cpumask_t *mask)
 {
 	unsigned long lastmask = BIT_MASK(nr_cpus) - 1;
diff --git a/riscv/sbi.c b/riscv/sbi.c
index c081953c877c..cdf8d13cc9cf 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,11 +6,15 @@
  */
 #include <libcflat.h>
 #include <alloc_page.h>
+#include <cpumask.h>
+#include <limits.h>
+#include <memregions.h>
+#include <on-cpus.h>
+#include <rand.h>
 #include <stdlib.h>
 #include <string.h>
-#include <limits.h>
 #include <vmalloc.h>
-#include <memregions.h>
+
 #include <asm/barrier.h>
 #include <asm/csr.h>
 #include <asm/delay.h>
@@ -46,6 +50,20 @@ static struct sbiret sbi_dbcn_write_byte(uint8_t byte)
 	return sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, byte, 0, 0, 0, 0, 0);
 }
 
+static int rand_online_cpu(prng_state *ps)
+{
+	int cpu, me = smp_processor_id();
+
+	for (;;) {
+		cpu = prng32(ps) % nr_cpus;
+		cpu = cpumask_next(cpu - 1, &cpu_present_mask);
+		if (cpu != nr_cpus && cpu != me && cpu_present(cpu))
+			break;
+	}
+
+	return cpu;
+}
+
 static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo)
 {
 	*lo = (unsigned long)paddr;
@@ -286,6 +304,130 @@ static void check_time(void)
 	report_prefix_popn(2);
 }
 
+static bool ipi_received[NR_CPUS];
+static bool ipi_timeout[NR_CPUS];
+static cpumask_t ipi_done;
+
+static void ipi_timeout_handler(struct pt_regs *regs)
+{
+	timer_stop();
+	ipi_timeout[smp_processor_id()] = true;
+}
+
+static void ipi_irq_handler(struct pt_regs *regs)
+{
+	ipi_ack();
+	ipi_received[smp_processor_id()] = true;
+}
+
+static void ipi_hart_wait(void *data)
+{
+	unsigned long timeout = (unsigned long)data;
+	int me = smp_processor_id();
+
+	install_irq_handler(IRQ_S_SOFT, ipi_irq_handler);
+	install_irq_handler(IRQ_S_TIMER, ipi_timeout_handler);
+	local_ipi_enable();
+	timer_irq_enable();
+	local_irq_enable();
+
+	timer_start(timeout);
+	while (!READ_ONCE(ipi_received[me]) && !READ_ONCE(ipi_timeout[me]))
+		cpu_relax();
+	local_irq_disable();
+	timer_stop();
+	local_ipi_disable();
+	timer_irq_disable();
+
+	cpumask_set_cpu(me, &ipi_done);
+}
+
+static void ipi_hart_check(cpumask_t *mask)
+{
+	int cpu;
+
+	for_each_cpu(cpu, mask) {
+		if (ipi_timeout[cpu]) {
+			const char *rec = ipi_received[cpu] ? "but was still received"
+							    : "and has still not been received";
+			report_fail("ipi timed out on cpu%d %s", cpu, rec);
+		}
+
+		ipi_timeout[cpu] = false;
+		ipi_received[cpu] = false;
+	}
+}
+
+static void check_ipi(void)
+{
+	unsigned long d = getenv("SBI_IPI_TIMEOUT") ? strtol(getenv("SBI_IPI_TIMEOUT"), NULL, 0) : 200000;
+	int nr_cpus_present = cpumask_weight(&cpu_present_mask);
+	int me = smp_processor_id();
+	unsigned long max_hartid = 0;
+	cpumask_t ipi_receivers;
+	static prng_state ps;
+	struct sbiret ret;
+	int cpu;
+
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
+	if (nr_cpus_present < 2) {
+		report_skip("At least 2 cpus required");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("random hart");
+	cpumask_clear(&ipi_done);
+	cpumask_clear(&ipi_receivers);
+	cpu = rand_online_cpu(&ps);
+	cpumask_set_cpu(cpu, &ipi_receivers);
+	on_cpu_async(cpu, ipi_hart_wait, (void *)d);
+	ret = sbi_send_ipi_cpu(cpu);
+	report(ret.error == SBI_SUCCESS, "ipi returned success");
+	while (!cpumask_equal(&ipi_done, &ipi_receivers))
+		cpu_relax();
+	ipi_hart_check(&ipi_receivers);
+	report_prefix_pop();
+
+	report_prefix_push("broadcast");
+	cpumask_clear(&ipi_done);
+	cpumask_copy(&ipi_receivers, &cpu_present_mask);
+	cpumask_clear_cpu(me, &ipi_receivers);
+	on_cpumask_async(&ipi_receivers, ipi_hart_wait, (void *)d);
+	ret = sbi_send_ipi_broadcast();
+	report(ret.error == SBI_SUCCESS, "ipi returned success");
+	while (!cpumask_equal(&ipi_done, &ipi_receivers))
+		cpu_relax();
+	ipi_hart_check(&ipi_receivers);
+	report_prefix_pop();
+
+	report_prefix_push("invalid parameters");
+
+	for_each_present_cpu(cpu) {
+		if (cpus[cpu].hartid > max_hartid)
+			max_hartid = cpus[cpu].hartid;
+	}
+
+	/* Try the next higher hartid than the max */
+	ret = sbi_send_ipi(2, max_hartid);
+	report_kfail(true, ret.error == SBI_ERR_INVALID_PARAM, "hart_mask got expected error (%ld)", ret.error);
+	ret = sbi_send_ipi(1, max_hartid + 1);
+	report_kfail(true, ret.error == SBI_ERR_INVALID_PARAM, "hart_mask_base got expected error (%ld)", ret.error);
+
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 #define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
 #define DBCN_WRITE_BYTE_TEST_BYTE	((u8)'a')
 
@@ -437,6 +579,7 @@ int main(int argc, char **argv)
 	report_prefix_push("sbi");
 	check_base();
 	check_time();
+	check_ipi();
 	check_dbcn();
 
 	return report_summary();
diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
index cbd36bf63e14..2eb760eca24e 100644
--- a/riscv/unittests.cfg
+++ b/riscv/unittests.cfg
@@ -16,4 +16,5 @@ groups = selftest
 # Set $FIRMWARE_OVERRIDE to /path/to/firmware to select the SBI implementation.
 [sbi]
 file = sbi.flat
+smp = $MAX_SMP
 groups = sbi
-- 
2.47.0


