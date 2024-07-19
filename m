Return-Path: <kvm+bounces-21913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8216293728E
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 04:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38F46282411
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 02:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66CA282ED;
	Fri, 19 Jul 2024 02:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fniVNm6O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C6624211
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 02:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721356811; cv=none; b=rVRhPxOVV7SjxbO1+6VbQWqVa1IOMvP7pcMDGA4waJcuKU1X0CEOfxhBRBNZ8Uu3A5NqnfDXVbQStVsFaaryAXp7QQ+JDRxIJVzzSNMWcuO+LoosyfXBEP/YAwFjWe3Iw6QvBWCBrasBMBIPsJ/HChNa4hQMPiF5wDXxGzJzDaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721356811; c=relaxed/simple;
	bh=Ax1dMGxVr/ONvy+Urs64kTLGxnAIC0fKV6US+qUC4vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc0H6WTloPnCBazDMw0FDUv/Yr3plOLvIVgsu1Tz4zE1mHbBHqi5GmUVwMhPvI8y9LMzaW6jQJCZdw513aY3Ynww3Ln0N0MSsbp3E3ScggHF2kwyzfNo9qtA4wdT7hi9FoFfiYkjMgIjQk+wKaYtvWaAJkHyIHQvYvMLZlmsA24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fniVNm6O; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70ce3d66a8bso328343b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721356808; x=1721961608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TaC0dO2imr6IhANJQdTpTJ19aDUvOxzXzkwnIUYTqo=;
        b=fniVNm6OYPFu58P5lrKnlYWpM6H+aQIyx2sLbldmV2Ie1WZKWQMtC0IHDedmwfxUPv
         Fxxl4xlP6u4IBSuiyiH3ta6bbeq8D+uREsokRWE8WQuFb1NTkwvU8kzxf4Tc6TvrHTEZ
         l555iWZo/tacBwIuPggrp8/2bPQ2sVXLuEmh8GUTXGApDTQnztP9Ee4Dt8oxpSMuIRpT
         MWvjCnLhrSzI4O6meAkD6253Qvi2jLWgLKOaljJSNAwuktFfMmPNEJZeWCLcBEVkjmhD
         iQ15O78y8qdd3asgVi+bNhuyAzKGUFPXI+x3YKVGu/Mkr2SQnKUg48RlVfO0s7rRl1ty
         CPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721356808; x=1721961608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TaC0dO2imr6IhANJQdTpTJ19aDUvOxzXzkwnIUYTqo=;
        b=vDjneN2ykhjwNStzdn3evaRI0zNIoAmOZMYfEWyCV9kSW+PPaN5lVfFX31U3cMlcGz
         x3UV0jI72A9VfvfmPizN/g6S4UFnVQroE0klS7Qcvi/CZ2Q4yf9TCJw6jwzmZkQHNkKf
         RjT1sH7+4Uu0Pz4NpzUOrMZDJahlwysbDtXd2LBH8QeqFK5NgQ71sqEI96/ASnc2RivC
         YLN1JmsW8H1uJ5RNaBXvBPSbFU+4lMiojtQPmM/Mhjj1O+vumftucp1nPTu1MjG6PYEr
         peP1FsLWjfY6Sgg4p70lDWtDxf5Pbi603EZfF04KRgfcIcU+SHcKvxrSBxleP9WK3ESB
         E4Tg==
X-Gm-Message-State: AOJu0YxKW4Mtg3CWivhUzbKcioKeHyz/YfWTz0ASVQOt5VI4HtOfd3m5
	rm5/ZmaUyFP/HHako4YgUXlqK6oI8Lt8KF4qFKigr920Bi42Zj5r7RJOEsTT
X-Google-Smtp-Source: AGHT+IH0W7GQsvJBkVPcTYJD9e64AR+yP7+SG/6OtVyt5KUZNMHydxVWsFq2nN6tr9RCkcFbO2u2fQ==
X-Received: by 2002:a05:6a00:190c:b0:705:b81b:6ee2 with SMTP id d2e1a72fcca58-70cfc9a8468mr1744234b3a.19.1721356807742;
        Thu, 18 Jul 2024 19:40:07 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff491231sm234930b3a.31.2024.07.18.19.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 19:40:07 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 5/5] riscv: sbi: Add test for timer extension
Date: Fri, 19 Jul 2024 10:39:47 +0800
Message-ID: <20240719023947.112609-6-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240719023947.112609-1-jamestiotio@gmail.com>
References: <20240719023947.112609-1-jamestiotio@gmail.com>
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
error is 200 milliseconds.

This test has been verified on RV32 and RV64 with OpenSBI using QEMU.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h   |   8 +++
 lib/riscv/asm/sbi.h   |   5 ++
 lib/riscv/asm/timer.h |  10 ++++
 riscv/sbi.c           | 136 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 159 insertions(+)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index a9b1bd42..052c0412 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -4,13 +4,17 @@
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
 #define CSR_TIME		0xc01
+#define CSR_STIMECMP		0x14d
+#define CSR_STIMECMPH		0x15d
 
 #define SR_SIE			_AC(0x00000002, UL)
 
@@ -47,6 +51,10 @@
 #define IRQ_S_GEXT		12
 #define IRQ_PMU_OVF		13
 
+#define IE_TIE			(_AC(0x1, UL) << IRQ_S_TIMER)
+
+#define IP_TIP			IE_TIE
+
 #ifndef __ASSEMBLY__
 
 #define csr_swap(csr, val)					\
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 5e1a674a..73ab5438 100644
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
diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
index 2e319391..cd20262f 100644
--- a/lib/riscv/asm/timer.h
+++ b/lib/riscv/asm/timer.h
@@ -11,4 +11,14 @@ static inline uint64_t timer_get_cycles(void)
 	return csr_read(CSR_TIME);
 }
 
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
 #endif /* _ASMRISCV_TIMER_H_ */
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 762e9711..9798b989 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,7 +6,21 @@
  */
 #include <libcflat.h>
 #include <stdlib.h>
+#include <limits.h>
+#include <asm/barrier.h>
+#include <asm/csr.h>
+#include <asm/delay.h>
+#include <asm/isa.h>
+#include <asm/processor.h>
 #include <asm/sbi.h>
+#include <asm/smp.h>
+#include <asm/timer.h>
+
+static bool timer_works;
+static bool mask_timer_irq;
+static bool timer_irq_set;
+static bool timer_irq_cleared;
+static unsigned long timer_irq_count;
 
 static void help(void)
 {
@@ -19,6 +33,33 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
 	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret __time_sbi_ecall(unsigned long stime_value)
+{
+	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
+}
+
+static inline bool timer_irq_pending(void)
+{
+	return csr_read(CSR_SIP) & IP_TIP;
+}
+
+static void timer_irq_handler(struct pt_regs *regs)
+{
+	timer_irq_count = (timer_irq_count == ULONG_MAX) ? ULONG_MAX : timer_irq_count + 1;
+
+	timer_works = true;
+	if (timer_irq_pending())
+		timer_irq_set = true;
+
+	if (mask_timer_irq)
+		timer_irq_disable();
+	else {
+		__time_sbi_ecall(ULONG_MAX);
+		if (!timer_irq_pending())
+			timer_irq_cleared = true;
+	}
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -112,6 +153,100 @@ static void check_base(void)
 	report_prefix_pop();
 }
 
+static void check_time(void)
+{
+	struct sbiret ret;
+	unsigned long begin, end, duration;
+	unsigned long d = getenv("TIMER_DELAY") ? strtol(getenv("TIMER_DELAY"), NULL, 0)
+						: 1000000;
+	unsigned long margin = getenv("TIMER_MARGIN") ? strtol(getenv("TIMER_MARGIN"), NULL, 0)
+						      : 200000;
+
+	d = usec_to_cycles(d);
+	margin = usec_to_cycles(margin);
+
+	report_prefix_push("time");
+
+	if (!sbi_probe(SBI_EXT_TIME)) {
+		report_skip("time extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	begin = timer_get_cycles();
+	delay(d);
+	end = timer_get_cycles();
+	assert(begin + d <= end);
+
+	report_prefix_push("set_timer");
+
+	install_irq_handler(IRQ_S_TIMER, timer_irq_handler);
+	local_irq_enable();
+	if (cpu_has_extension(smp_processor_id(), ISA_SSTC))
+#if __riscv_xlen == 64
+		csr_write(CSR_STIMECMP, ULONG_MAX);
+#else
+		csr_write(CSR_STIMECMPH, ULONG_MAX);
+#endif
+	timer_irq_enable();
+
+	begin = timer_get_cycles();
+	ret = __time_sbi_ecall(begin + d);
+
+	report(!ret.error, "set timer");
+	if (ret.error)
+		report_info("set timer failed with %ld\n", ret.error);
+
+	report(!timer_irq_pending(), "pending timer interrupt bit cleared");
+
+	while ((end = timer_get_cycles()) <= (begin + d + margin) && !timer_works)
+		cpu_relax();
+
+	report(timer_works, "timer interrupt received");
+	report(timer_irq_set, "pending timer interrupt bit set in irq handler");
+	report(timer_irq_cleared, "pending timer interrupt bit cleared by setting timer to -1");
+
+	if (timer_works) {
+		duration = end - begin;
+		report(duration >= d && duration <= (d + margin), "timer delay honored");
+	}
+
+	if (timer_irq_count > 1)
+		report_fail("timer interrupt received multiple times");
+
+	timer_works = false;
+	timer_irq_set = false;
+	timer_irq_count = 0;
+	mask_timer_irq = true;
+	begin = timer_get_cycles();
+	ret = __time_sbi_ecall(begin + d);
+
+	report(!ret.error, "set timer for mask irq test");
+	if (ret.error)
+		report_info("set timer for mask irq test failed with %ld\n", ret.error);
+
+	while ((end = timer_get_cycles()) <= (begin + d + margin) && !timer_works)
+		cpu_relax();
+
+	report(timer_works, "timer interrupt received for mask irq test");
+	report(timer_irq_set, "pending timer interrupt bit set in irq handler for mask irq test");
+
+	if (timer_works) {
+		duration = end - begin;
+		report(duration >= d && duration <= (d + margin),
+		       "timer delay honored for mask irq test");
+	}
+
+	if (timer_irq_count > 1)
+		report_fail("timer interrupt received multiple times for mask irq test");
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
 
@@ -122,6 +257,7 @@ int main(int argc, char **argv)
 
 	report_prefix_push("sbi");
 	check_base();
+	check_time();
 
 	return report_summary();
 }
-- 
2.43.0


