Return-Path: <kvm+bounces-22588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75CDA940832
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 819631C22515
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 06:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4100416728B;
	Tue, 30 Jul 2024 06:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3AwMcEX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4E518FC85
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 06:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722320321; cv=none; b=DnEa0uE0SuEcSC1YVQtudRV9p/xHv0Vgh8JSqs9v8cXIDWqCKqHudtbJ3q/3RIZxEQ7dLIxV5ql7VBoNZ13uUBqzi6Uhx9Mi5ndDpJZniqEFNAfMe8fxYYBSwtiG8tJwVUDjWb1ar18P9ZMpXP8eDHsKZdsQHinsSMVSbJxhfP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722320321; c=relaxed/simple;
	bh=1i7CBN3jOe218/OcDlClAJcZNUqGkBYiPKY7XxKDLZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctLVK0F3gyDA5mq/cRfRZ/IsXhxYVDYPLCyNaVUr8cuSnHGr0lsd/ufps4Z+bEvCy1Usw8WaWl7a+c2B838pLIz42FICJS8+f5w9h7BZBIDrFBHsEypjGajhceQKdv6RoPCIhOlDtKCj9vxFJDas+zRmIRq0eiMRE9uXJC/83oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3AwMcEX; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70d18112b60so2943801b3a.1
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 23:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722320319; x=1722925119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9aR+63uT7v78VjbRv6DJCJHpLF+0X46I4y0U041o2c=;
        b=N3AwMcEX/pj4M8q2J2dsvuT81ezVtP606OwGF1+e8nGdaNVDO7sWwbHfjzPlJxWofR
         fVZ1RpXTaUFe9yfpZQle7AVxZDNaObRpuamukz/lIP19yq3YweDpH5GqPYzsNf9zOFdB
         m1sRPTZJUuLEMPJ/FoTWnfsq9g1SVLj2fAHDqWNTL6kPFCVoGxmgzT/LWHZazzpgrQLa
         DgkVE4eNqM2U+Jd7uJlLAJy9z13ZXtvO1CVZkbj2XUTr1UkNoe1RXGqsj8FvN84Eok0g
         4+Sn37KoaBLxUmIanuTqr1UfjHcwo9sNxEMsTCkKgukC3mN9hafN8MLTgnuts2nGKnbG
         x2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722320319; x=1722925119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b9aR+63uT7v78VjbRv6DJCJHpLF+0X46I4y0U041o2c=;
        b=k1/joeWs5sEIaPgpnXIEbwLopg5s1Bx2KkftURhqZMcfitKMYk3GOm6JSn0ukVnaVH
         gpmjGWIISEYXUxk7WE8h95rPaF2oNSn5prZYKc4PQnea1PePnqcYR11tDiW41ojEd4hT
         LrO5Kosdx/i6y4xUZZvsT6YwAGTa48AsDr8JgjU8Kccex22T/vMWbayjXHDpjAGEDcco
         hQVKSSlsvqAIJL0TWzHzyfb13Ash//NGm3pdSCWUlyNMWPSltW8VZke0GK+JQA1iK5HI
         KCRQqPGHiMnsGDKYknM9XCMUtIUDOzGF2bgoLWB+S3eTi0r6L6lAUHaSp7FXVwTLMWZA
         VRog==
X-Gm-Message-State: AOJu0Ywl6Wtnz8mWFFqa3YTEAP8nAMGZA+YETT6RCUqUEcfjQTkikrdw
	RRaMZCEVcgOJbqeduQCNi6Erv4oivrtMf7SifTtLXQaQvHPUGX5Ljj5dyd3Qbxw=
X-Google-Smtp-Source: AGHT+IEAIFl8b07iaWFTucQrr8o5u8AfL9aHdpepBAosSPFLueK4FRXeZIiIZifwd3D2tPdwPtlgDA==
X-Received: by 2002:aa7:8257:0:b0:70e:ce95:b87 with SMTP id d2e1a72fcca58-70efe2a2430mr1637242b3a.0.1722320318624;
        Mon, 29 Jul 2024 23:18:38 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead6e161dsm7732781b3a.42.2024.07.29.23.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 23:18:38 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v6 5/5] riscv: sbi: Add test for timer extension
Date: Tue, 30 Jul 2024 14:18:20 +0800
Message-ID: <20240730061821.43811-6-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240730061821.43811-1-jamestiotio@gmail.com>
References: <20240730061821.43811-1-jamestiotio@gmail.com>
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
- The installed timer interrupt handler is called
- The timer interrupt is received within a reasonable time interval
- The timer interrupt pending bit is cleared after the set_timer SBI
  call is made
- The timer interrupt can be cleared either by requesting a timer
  interrupt infinitely far into the future or by masking the timer
  interrupt

The timer interrupt delay can be set using the TIMER_DELAY environment
variable in microseconds. The default delay value is 200 milliseconds.
Since the interrupt can arrive a little later than the specified delay,
allow some margin of error. This margin of error can be specified via
the TIMER_MARGIN environment variable in microseconds. The default
margin of error is 200 milliseconds.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h   |   8 +++
 lib/riscv/asm/sbi.h   |   5 ++
 lib/riscv/asm/timer.h |  10 ++++
 riscv/sbi.c           | 127 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 150 insertions(+)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index a9b1bd42..24b333e0 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -4,11 +4,15 @@
 #include <linux/const.h>
 
 #define CSR_SSTATUS		0x100
+#define CSR_SIE			0x104
 #define CSR_STVEC		0x105
 #define CSR_SSCRATCH		0x140
 #define CSR_SEPC		0x141
 #define CSR_SCAUSE		0x142
 #define CSR_STVAL		0x143
+#define CSR_SIP			0x144
+#define CSR_STIMECMP		0x14d
+#define CSR_STIMECMPH		0x15d
 #define CSR_SATP		0x180
 #define CSR_TIME		0xc01
 
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
index f7504f84..b3514d3f 100644
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
index 762e9711..9fc099df 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,7 +6,25 @@
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
+struct timer_info {
+	bool timer_works;
+	bool mask_timer_irq;
+	bool timer_irq_set;
+	bool timer_irq_cleared;
+	unsigned long timer_irq_count;
+};
+
+static struct timer_info timer_info;
 
 static void help(void)
 {
@@ -19,6 +37,78 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
 	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret __time_sbi_ecall(unsigned long stime_value)
+{
+	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
+}
+
+static bool timer_irq_pending(void)
+{
+	return csr_read(CSR_SIP) & IP_TIP;
+}
+
+static void timer_irq_handler(struct pt_regs *regs)
+{
+	if (timer_info.timer_irq_count < ULONG_MAX)
+		++timer_info.timer_irq_count;
+
+	timer_info.timer_works = true;
+	if (timer_irq_pending())
+		timer_info.timer_irq_set = true;
+
+	if (timer_info.mask_timer_irq) {
+		timer_irq_disable();
+		__time_sbi_ecall(0);
+	} else {
+		__time_sbi_ecall(ULONG_MAX);
+	}
+
+	if (!timer_irq_pending())
+		timer_info.timer_irq_cleared = true;
+}
+
+static void execute_set_timer_test(bool mask_timer_irq)
+{
+	struct sbiret ret;
+	unsigned long begin, end, duration;
+	const char *mask_test_str = mask_timer_irq ? " for mask irq test" : "";
+	const char *clear_irq_bit_str = mask_timer_irq ? "masking timer irq"
+						       : "setting timer to -1";
+	unsigned long d = getenv("TIMER_DELAY") ? strtol(getenv("TIMER_DELAY"), NULL, 0)
+						: 200000;
+	unsigned long margin = getenv("TIMER_MARGIN") ? strtol(getenv("TIMER_MARGIN"), NULL, 0)
+						      : 200000;
+
+	d = usec_to_cycles(d);
+	margin = usec_to_cycles(margin);
+
+	timer_info = (struct timer_info){ .mask_timer_irq = mask_timer_irq };
+	begin = timer_get_cycles();
+	ret = __time_sbi_ecall(begin + d);
+
+	report(!ret.error, "set timer%s", mask_test_str);
+	if (ret.error)
+		report_info("set timer%s failed with %ld\n", mask_test_str, ret.error);
+
+	while ((end = timer_get_cycles()) <= (begin + d + margin) && !timer_info.timer_works)
+		cpu_relax();
+
+	report(timer_info.timer_works, "timer interrupt received%s", mask_test_str);
+	report(timer_info.timer_irq_set, "pending timer interrupt bit set in irq handler%s",
+	       mask_test_str);
+	report(timer_info.timer_irq_set && timer_info.timer_irq_cleared,
+	       "pending timer interrupt bit cleared by %s", clear_irq_bit_str);
+
+	if (timer_info.timer_works) {
+		duration = end - begin;
+		report(duration >= d && duration <= (d + margin), "timer delay honored%s",
+		       mask_test_str);
+	}
+
+	if (timer_info.timer_irq_count > 1)
+		report_fail("timer interrupt received multiple times%s", mask_test_str);
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -112,6 +202,42 @@ static void check_base(void)
 	report_prefix_pop();
 }
 
+static void check_time(void)
+{
+	report_prefix_push("time");
+
+	if (!sbi_probe(SBI_EXT_TIME)) {
+		report_skip("time extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("set_timer");
+
+	install_irq_handler(IRQ_S_TIMER, timer_irq_handler);
+	local_irq_enable();
+	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
+		csr_write(CSR_STIMECMP, ULONG_MAX);
+#if __riscv_xlen == 32
+		csr_write(CSR_STIMECMPH, ULONG_MAX);
+#endif
+	}
+	timer_irq_enable();
+
+	execute_set_timer_test(false);
+
+	if (csr_read(CSR_SIE) & IE_TIE)
+		execute_set_timer_test(true);
+	else
+		report_skip("timer irq enable bit is not writable, skipping mask irq test");
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
 
@@ -122,6 +248,7 @@ int main(int argc, char **argv)
 
 	report_prefix_push("sbi");
 	check_base();
+	check_time();
 
 	return report_summary();
 }
-- 
2.43.0


