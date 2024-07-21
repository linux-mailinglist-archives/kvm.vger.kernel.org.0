Return-Path: <kvm+bounces-22021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C999383AC
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 09:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85554280DCF
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 07:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81D733E1;
	Sun, 21 Jul 2024 07:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWWlUbaf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501AD944E
	for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 07:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545583; cv=none; b=jRPdMtXMW0XjjGfFrFskQslC/T3vyTiTQnRbpxtdPV2PMl6aEExovOiJOOFPieaXJ+XcYzowTwDfl1/h59VSJ8XYcfD9ex+vfLblfv+9vY0oxKvbDTpCRHY2eYfxcfETpvfz4miEZ3jYlStYTKJD0X4xg0ylB6258YJqxBjxljE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545583; c=relaxed/simple;
	bh=fL4r++2W3tafZl6nvytDiibtTrUAUThm1AYpEfEoKn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEHKt/P73/Tw3CaZcdo+JFhoztDPFmnqPrc+HYjM8aKdo9NLWE+k5Zp4g4jWLkioeirokSYP9XV5Wc9SshBcCaZbhas7g2ynGW+FeXr+em8ywwmWV2vdgG8WPC7Sl/3dNFsGqXhU5vrWjjZnEDAzejtaBWT6fMC0nQQrRU0b3Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWWlUbaf; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70b0e7f6f8bso1881074b3a.3
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 00:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721545581; x=1722150381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBE6A/bNNTAy6FniqPADMXl7o6XMR7KLE4bnhlWkgK4=;
        b=cWWlUbafS/wNzU+gtwvfrYQ1yoLeUl4qg9Znrk1CwiZCNGbHSRzORI8xzxBzky2aJs
         rY+qtM4YQbLCQ4VKSpRrCmDrXUH4JWnDMaA7AL7woiyNC5Bm2vio7gRKL/UoT9lW8W88
         ZOhE97U2QM6G/Ff8YvF0SomPHY7W6EypVOTWYs3EfncCDfxBVnlY3ImpMNotXygp+mSa
         AcwfmrgduWBfg6YyE/BDLewRwBvHRGyiGqIuMUtBxQ+KLWDPs/caOkdVCLynurmtOGND
         +Ntt1dyvbNiQArNqgysk/6JqE8iJm+pk6fUM4Bs6ROnJaKE8ZhcvUcgdXn+kNg6NYs6e
         94FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721545581; x=1722150381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBE6A/bNNTAy6FniqPADMXl7o6XMR7KLE4bnhlWkgK4=;
        b=n2LPP2maMBhDXbxG++eXrSxBpuI1ZNKUavzKMcn/5fCkLJJNwPLx45IaObu5ZuogL4
         0qroeXPlf89xYPf7mbX5X7d1sD7QW8nNcxdmUqpMH1Py9y/2KGzSz50fnXNHIwItzOQC
         l0ZYlBus6o4e3+srL5XQlzLmy1KpYRYUgy6/4RXS0pt48lBB/HHHFjJTW8sah5eV78MS
         noEkY2kkGJErT7nTpZLW1wo1wIy+jxWHP+C68CC5UOR32AA4vRqX+w4uskJYiNYiw5b5
         nNGMsfr42mba1ca/ZeI7Ms4zYO+gvouHBhHvo+aBSngXSFQTn9TpDxP9Lb1oSOibrhaZ
         K+Qw==
X-Gm-Message-State: AOJu0YyJtTj6tCOSlUdzZ1YFILdOGn3HTk6+6Ckv/46sBLYu9vsK2SKR
	ItCf/bzoN3glYY+WZTFA8epau0yzPgFFmky4cyHQTxAs0s1DQ3hiKeZp6Vt9
X-Google-Smtp-Source: AGHT+IFLtXv3i3p8jfevPC2wvq0SjkTMoC845xtDvLoXQgWuVrCSGCrbi5aw1SstRh3N/CYv3N0OfA==
X-Received: by 2002:a05:6a21:c8a:b0:1c3:ce0f:bfb2 with SMTP id adf61e73a8af0-1c4285d55a7mr4598852637.23.1721545580432;
        Sun, 21 Jul 2024 00:06:20 -0700 (PDT)
Received: from JRT-PC.. ([180.255.73.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb77492bc6sm4891461a91.1.2024.07.21.00.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 00:06:19 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 5/5] riscv: sbi: Add test for timer extension
Date: Sun, 21 Jul 2024 15:06:00 +0800
Message-ID: <20240721070601.88639-6-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240721070601.88639-1-jamestiotio@gmail.com>
References: <20240721070601.88639-1-jamestiotio@gmail.com>
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

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h   |   8 +++
 lib/riscv/asm/sbi.h   |   5 ++
 lib/riscv/asm/timer.h |  10 ++++
 riscv/sbi.c           | 132 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 155 insertions(+)

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
index 762e9711..fe2fe771 100644
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
@@ -19,6 +33,34 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
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
+	if (timer_irq_count < ULONG_MAX)
+		++timer_irq_count;
+
+	timer_works = true;
+	if (timer_irq_pending())
+		timer_irq_set = true;
+
+	if (mask_timer_irq) {
+		timer_irq_disable();
+	} else {
+		__time_sbi_ecall(ULONG_MAX);
+		if (!timer_irq_pending())
+			timer_irq_cleared = true;
+	}
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -112,6 +154,95 @@ static void check_base(void)
 	report_prefix_pop();
 }
 
+static void check_time(void)
+{
+	struct sbiret ret;
+	unsigned long begin, end, duration;
+	unsigned long d = getenv("TIMER_DELAY") ? strtol(getenv("TIMER_DELAY"), NULL, 0)
+						: 200000;
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
 
@@ -122,6 +253,7 @@ int main(int argc, char **argv)
 
 	report_prefix_push("sbi");
 	check_base();
+	check_time();
 
 	return report_summary();
 }
-- 
2.43.0


