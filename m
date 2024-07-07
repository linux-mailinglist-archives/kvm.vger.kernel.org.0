Return-Path: <kvm+bounces-21072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B31929762
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 12:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92A64B2105E
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 10:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED611C694;
	Sun,  7 Jul 2024 10:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrKJbYM3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129971C683
	for <kvm@vger.kernel.org>; Sun,  7 Jul 2024 10:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720347097; cv=none; b=saOKxx02Rayyjde2UwsxHKiaUGwUw/FO1RW+GhKnzhKfqe+BUZ/ZE16SFxCYmY2mTKyo1mtQfK4B0Rl13go2/QFhJP67CIkV/iITBSdohRYuSLcS8QPHNf0+rrNb7ZvGV5xcS7zWwYvD7MMVk+CX4cEs7DfyELREbqKOlI+u2U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720347097; c=relaxed/simple;
	bh=lGE+USdqNjMziXvZp/kYPHnuX11YNbIPgpcQnEsH8J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gC24acaN2aASdhvoKSq5ioaMdgx0s2GRWV2m++siULItt+BHc/dsd2S8hwnVi59t8a8mGaBcVroJI0xLRx616s3IerswKvYH+EANNWeDEZlUGRHoOIesHqJYbpERd8fHQPwDfe4QuMqyEcrt16MKTWk3ucFnq1gbLUdM9f/hr1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GrKJbYM3; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-70364a94255so530786a34.0
        for <kvm@vger.kernel.org>; Sun, 07 Jul 2024 03:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720347094; x=1720951894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1YuowzABJd7oIVhv9uqXg11jP/0gGS6biiYCgOOG9Os=;
        b=GrKJbYM3am0sdyu4eU7EB9xhATMoWeBXJatBUbIF+sPaCZt06N1N03PC6pAmK3kTn6
         4+7xK5zOvoERFmscdpERJTn4jnIs99jxRNmRATtssGaVU/UJBqScoQZTmX0m2/p/jWHl
         775ENfPFFBWJNbbAm3tcI0jH0B6cKxoMluYUpwB5A1Fq0OK6CJYy8Z17TkFQ1TlnZTEd
         hD3xxWcEPekr2ubk3umTXA7vT6sEkPAbeUpVA1eR+wn+aWByXczpoi/OOVk7mEvFQJpW
         LWcFNpbZ3xHu0a7RnB0RnWJd9aYFA5G35Hw0NgHy4BeMnr1FivMD2A8iz5CU2QiksBbn
         DiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720347094; x=1720951894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YuowzABJd7oIVhv9uqXg11jP/0gGS6biiYCgOOG9Os=;
        b=v3Z2TnC7lHRwojngwqULyLSZdStC8d85LFgoGrYjD4H4OVi3/1SLHlaRc0DPtbwmwb
         7n61skRj9JnhbMsugSFE71T19FSzJ2qjYLCfpDosMJwRGoy7zhHKQbFu5t/NE7suY9QV
         1PeZKMkJYFmyII1/16krxVHhFBuvhQJdGuas2KX7KQO2VcA7QYkvnGsz3rSzIbSCsv+e
         /XwJvqkxhMQLzsg9uNLtNzVc7YhuHwBaefhvlOWiF2uFrHl7g/Ip4smUzI75Ssrbf5Up
         t9sCcseXEDCoIRpwNr00UIkzYyYVcF+qkLEtidPqGfxUaHuROWFarKhoHmKbDKRitR21
         dL5g==
X-Gm-Message-State: AOJu0Yxeih4vVpd6rrkPEhct3og22kXX9On99IAgzRNJ8U6R287o1Uhx
	vYMIebF4wgbHUJXPSvfgFfgpUvLbWbNYf/7DSU+swutc2e0Ng4i5P7VhOiY0
X-Google-Smtp-Source: AGHT+IH3XCv/447aGOLZ/HQvEsaY9n8J9IdIdFTHzZ//qGlanRjIVmDuq5uPV+QQgFMnzycOHQdUWw==
X-Received: by 2002:a9d:7f0d:0:b0:703:668f:321c with SMTP id 46e09a7af769-703668f3360mr2536669a34.20.1720347094172;
        Sun, 07 Jul 2024 03:11:34 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1596818sm166648085ad.270.2024.07.07.03.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jul 2024 03:11:33 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 3/3] riscv: sbi: Add test for timer extension
Date: Sun,  7 Jul 2024 18:10:52 +0800
Message-ID: <20240707101053.74386-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240707101053.74386-1-jamestiotio@gmail.com>
References: <20240707101053.74386-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test for the set_timer function of the time extension. The test
checks that:
- The time extension is available
- The time counter monotonically increases
- The installed timer interrupt handler is called
- The timer interrupt is received within a reasonable time interval
- The timer interrupt pending bit is cleared after the set_timer SBI
  call is made
- The timer interrupt can be cleared either by requesting a timer
  interrupt infinitely far into the future or by masking the timer
  interrupt

The timer interrupt delay can be set using the TIMER_DELAY environment
variable in microseconds. The default delay value is 1 second. Since the
interrupt can arrive a little later than the specified delay, allow some
margin of error. This margin of error can be specified via the
TIMER_MARGIN environment variable in microseconds. The default margin of
error is 1 second.

This test has been verified on RV32 and RV64 with OpenSBI using QEMU.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h   |   7 +++
 lib/riscv/asm/sbi.h   |   5 ++
 lib/riscv/asm/setup.h |   1 +
 lib/riscv/asm/timer.h |  30 ++++++++++++
 lib/riscv/processor.c |   6 +++
 lib/riscv/setup.c     |  24 ++++++++++
 riscv/sbi.c           | 108 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 181 insertions(+)
 create mode 100644 lib/riscv/asm/timer.h

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index b3c48e8e..dc05bfc9 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -4,12 +4,15 @@
 #include <linux/const.h>
 
 #define CSR_SSTATUS		0x100
+#define CSR_SIE			0x104
 #define CSR_STVEC		0x105
 #define CSR_SSCRATCH		0x140
 #define CSR_SEPC		0x141
 #define CSR_SCAUSE		0x142
 #define CSR_STVAL		0x143
+#define CSR_SIP			0x144
 #define CSR_SATP		0x180
+#define CSR_TIME		0xc01
 
 #define SR_SIE			_AC(0x00000002, UL)
 
@@ -50,6 +53,10 @@
 #define IRQ_S_GEXT		12
 #define IRQ_PMU_OVF		13
 
+#define IE_TIE			(_AC(0x1, UL) << IRQ_S_TIMER)
+
+#define IP_TIP			IE_TIE
+
 #ifndef __ASSEMBLY__
 
 #define csr_swap(csr, val)					\
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index d82a384d..84ce1bff 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -16,6 +16,7 @@
 
 enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
+	SBI_EXT_TIME = 0x54494d45,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
 };
@@ -37,6 +38,10 @@ enum sbi_ext_hsm_fid {
 	SBI_EXT_HSM_HART_SUSPEND,
 };
 
+enum sbi_ext_time_fid {
+	SBI_EXT_TIME_SET_TIMER = 0,
+};
+
 struct sbiret {
 	long error;
 	long value;
diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index 7f81a705..5be252df 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -7,6 +7,7 @@
 #define NR_CPUS 16
 extern struct thread_info cpus[NR_CPUS];
 extern int nr_cpus;
+extern uint64_t tb_hz;
 int hartid_to_cpu(unsigned long hartid);
 
 void io_init(void);
diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
new file mode 100644
index 00000000..3eeb8344
--- /dev/null
+++ b/lib/riscv/asm/timer.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_TIMER_H_
+#define _ASMRISCV_TIMER_H_
+
+#include <asm/csr.h>
+#include <asm/processor.h>
+
+extern uint64_t usec_to_cycles(uint64_t usec);
+
+static inline void timer_irq_enable(void)
+{
+	csr_set(CSR_SIE, IE_TIE);
+}
+
+static inline void timer_irq_disable(void)
+{
+	csr_clear(CSR_SIE, IE_TIE);
+}
+
+static inline uint64_t timer_get_cycles(void)
+{
+	return csr_read(CSR_TIME);
+}
+
+static inline bool timer_irq_pending(void)
+{
+	return csr_read(CSR_SIP) & IP_TIP;
+}
+
+#endif /* _ASMRISCV_TIMER_H_ */
diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
index 0dffadc7..082b9d80 100644
--- a/lib/riscv/processor.c
+++ b/lib/riscv/processor.c
@@ -7,6 +7,7 @@
 #include <asm/isa.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
+#include <asm/timer.h>
 
 extern unsigned long ImageBase;
 
@@ -82,3 +83,8 @@ void thread_info_init(void)
 	isa_init(&cpus[cpu]);
 	csr_write(CSR_SSCRATCH, &cpus[cpu]);
 }
+
+uint64_t usec_to_cycles(uint64_t usec)
+{
+	return (tb_hz * usec) / 1000000;
+}
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 50ffb0d0..b659c14e 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -20,6 +20,7 @@
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
+#include <asm/timer.h>
 
 #define VA_BASE			((phys_addr_t)3 * SZ_1G)
 #if __riscv_xlen == 64
@@ -38,6 +39,7 @@ u32 initrd_size;
 
 struct thread_info cpus[NR_CPUS];
 int nr_cpus;
+uint64_t tb_hz;
 
 static struct mem_region riscv_mem_regions[NR_MEM_REGIONS + 1];
 
@@ -67,6 +69,26 @@ static void cpu_init_acpi(void)
 	assert_msg(false, "ACPI not available");
 }
 
+static int cpu_init_timer(const void *fdt)
+{
+	const struct fdt_property *prop;
+	u32 *data;
+	int cpus;
+
+	cpus = fdt_path_offset(fdt, "/cpus");
+	if (cpus < 0)
+		return cpus;
+
+	prop = fdt_get_property(fdt, cpus, "timebase-frequency", NULL);
+	if (prop == NULL)
+		return -1;
+
+	data = (u32 *)prop->data;
+	tb_hz = fdt32_to_cpu(*data);
+
+	return 0;
+}
+
 static void cpu_init(void)
 {
 	int ret;
@@ -75,6 +97,8 @@ static void cpu_init(void)
 	if (dt_available()) {
 		ret = dt_for_each_cpu_node(cpu_set_fdt, NULL);
 		assert(ret == 0);
+		ret = cpu_init_timer(dt_fdt());
+		assert(ret == 0);
 	} else {
 		cpu_init_acpi();
 	}
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 762e9711..a1a9ce84 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,7 +6,14 @@
  */
 #include <libcflat.h>
 #include <stdlib.h>
+#include <asm/barrier.h>
+#include <asm/csr.h>
+#include <asm/processor.h>
 #include <asm/sbi.h>
+#include <asm/timer.h>
+
+static bool timer_works;
+static bool mask_timer_irq;
 
 static void help(void)
 {
@@ -19,6 +26,27 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
 	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret __time_sbi_ecall(unsigned long stime_value)
+{
+	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
+}
+
+static void timer_irq_handler(struct pt_regs *regs)
+{
+	if (timer_works)
+		report_abort("timer interrupt received multiple times");
+
+	timer_works = true;
+	report(timer_irq_pending(), "pending timer interrupt bit set");
+
+	if (mask_timer_irq)
+		timer_irq_disable();
+	else {
+		__time_sbi_ecall(-1);
+		report(!timer_irq_pending(), "pending timer interrupt bit cleared");
+	}
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -112,6 +140,85 @@ static void check_base(void)
 	report_prefix_pop();
 }
 
+static void check_time(void)
+{
+	struct sbiret ret;
+	unsigned long begin, end, duration;
+	unsigned long delay = getenv("TIMER_DELAY")
+							? strtol(getenv("TIMER_DELAY"), NULL, 0)
+							: 1000000;
+	unsigned long margin = getenv("TIMER_MARGIN")
+							? strtol(getenv("TIMER_MARGIN"), NULL, 0)
+							: 1000000;
+
+	delay = usec_to_cycles(delay);
+	margin = usec_to_cycles(margin);
+
+	report_prefix_push("time");
+
+	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_TIME);
+
+	if (ret.error) {
+		report_fail("probing for time extension failed");
+		report_prefix_pop();
+		return;
+	}
+
+	if (!ret.value) {
+		report_skip("time extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	begin = timer_get_cycles();
+	while ((end = timer_get_cycles()) <= begin)
+		cpu_relax();
+	assert(begin < end);
+
+	report_prefix_push("set_timer");
+
+	install_irq_handler(IRQ_S_TIMER, timer_irq_handler);
+	local_irq_enable();
+	timer_irq_enable();
+
+	begin = timer_get_cycles();
+	ret = __time_sbi_ecall(begin + delay);
+
+	if (ret.error)
+		report_fail("setting timer failed");
+
+	report(!timer_irq_pending(), "pending timer interrupt bit cleared");
+
+	while ((end = timer_get_cycles()) <= (begin + delay + margin) && !timer_works)
+		cpu_relax();
+
+	report(timer_works, "timer interrupt received");
+
+	if (timer_works) {
+		duration = end - begin;
+		report(duration >= delay && duration <= (delay + margin), "timer delay honored");
+	}
+
+	timer_works = false;
+	mask_timer_irq = true;
+	begin = timer_get_cycles();
+	ret = __time_sbi_ecall(begin + delay);
+
+	if (ret.error)
+		report_fail("setting timer failed");
+
+	while ((end = timer_get_cycles()) <= (begin + delay + margin) && !timer_works)
+		cpu_relax();
+
+	report(timer_works, "timer interrupt received");
+
+	local_irq_disable();
+	install_irq_handler(IRQ_S_TIMER, NULL);
+
+	report_prefix_pop();
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 
@@ -122,6 +229,7 @@ int main(int argc, char **argv)
 
 	report_prefix_push("sbi");
 	check_base();
+	check_time();
 
 	return report_summary();
 }
-- 
2.43.0


