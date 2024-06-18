Return-Path: <kvm+bounces-19882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E952490DABA
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98CB91F244D2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBEAC14F118;
	Tue, 18 Jun 2024 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8gOOmbY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD80146D4D
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 17:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731948; cv=none; b=AG6hVA8+6cTLUvEP1XQ7v86BjBKFI9l/S0ciLjKspjEYG7usFfBOCdti86hICQlIrytlyt58Ca2Id/jy48vty+WyD4e6PJCkX5kuF/30THRe/ZpTIl8AIDAnGIn8KX7I3d2GZB3MMQhJChUK4L1VAqib0ee4pHHm6dm+uaPXDxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731948; c=relaxed/simple;
	bh=Hu+FYb6PXyf1xaV7Tf3xHtffCUNny7P9Dsa272vQ6fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ql7bBo4RX439lmKrHR0LYnwheRMgMch5KAVz17Y6JG+39qZovXGofaEYQEr2/WmTO6a9ZjApVL2NUKytTZJidBCe3SD3uqF0JqQhQnx9+9uVwaGfKi87YvnTc/JhYvcrIs9HpNTOvU5S4A7MlLu98IkOrb1PeZ1F9wM4w2rZsrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W8gOOmbY; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-6e4e6230f42so42386a12.0
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 10:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718731946; x=1719336746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJ0IRqtJQTxYM5sbu/JBOLam6TAEXhPiQOr+HxYnzUE=;
        b=W8gOOmbYfc3jUFde3EAEvht92PUXFEEgQ1SWrKC4bDJNM7Zemhy32Jb07M+q12gcA3
         RFfwzgTcMoNk/NLqgCF1+Js730G8zPKgAEZdloM4yGZvP6WIkpw4eEWSyVDBR719e43F
         cs0tU4UmypqwNzSi4ypvb/Rgd8CJpVFUOpLcybx7b8Bt2hDRmMKITsGbF3LMKtogMuML
         xXc8cm3ZLcVIRhFdGaWJgZH6wsdjjpufQHsIbFZmuwcLqKzuntBnLfsFyWmE7HXKBl5T
         mC67PMy7xAmAvfvAncHmxPmsjzIVD/B/KHUtMbu4PrINNBGZPWpU4HLLn0YlLhMHA60n
         wkig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731946; x=1719336746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uJ0IRqtJQTxYM5sbu/JBOLam6TAEXhPiQOr+HxYnzUE=;
        b=a5E7P7fXxlAKZd0FDRFN5GCT0lawEkqQqQ3WLcpj0MXYyfLMns+3j6mYjydRhEbb5S
         FroO+sQsnhNtfZcdyAN8JewF8J2wBXkbW4rga9JTMVQZGZQdCtrsGHldXewphvq7xCZs
         3xB2lxW0doe7y3zDbLGt040hfo72r6bf7oJonbm2F+DaXqI1HkqYKkYI7wUdPqICv3tl
         b1w7AGwewHO/j8a9aYHA+JZvczWILI39PayV9++DSpjyEDIzQ+7By/oDz8FGCVkJs7Uv
         Y9z1NxOitM3aYOOgEY28/OFy3A11kA8cyHioPZ/3lvnr+Cz+16o2slRwBmdNxQA9g9Qf
         Jdfw==
X-Gm-Message-State: AOJu0YzE7tw2tnQ//hjEn1r/gskx0KYhKfdh0Z7xRfCi1aU57GOHlwoo
	nsCop0/En8JindPmGWHO8M7QfQXdyJWVEW+vGmZIgag1zpjcp18nhXwM6S4r
X-Google-Smtp-Source: AGHT+IHkLL4UhbVsE2pTLofbKhxmfl27h0FIlAgw5Vx/t7KgFu3OHOmecQE0PalhWlfXeyW89WK2Kw==
X-Received: by 2002:a17:90a:6d24:b0:2c2:12d:fa01 with SMTP id 98e67ed59e1d1-2c6c951fa1bmr4819776a91.11.1718731945445;
        Tue, 18 Jun 2024 10:32:25 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75ee5a5sm13529305a91.17.2024.06.18.10.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 10:32:25 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 4/4] riscv: sbi: Add test for timer extension
Date: Wed, 19 Jun 2024 01:30:53 +0800
Message-ID: <20240618173053.364776-5-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618173053.364776-1-jamestiotio@gmail.com>
References: <20240618173053.364776-1-jamestiotio@gmail.com>
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
- The timer interrupt is received within a reasonable time frame

The timer interrupt delay can be set using the TIMER_DELAY environment
variable. If the variable is not set, the default delay value is
1000000. The time interval used to validate the timer interrupt is
between the specified delay and double the delay. Because of this, the
test might fail if the delay is too short. Hence, we set the default
delay value as the minimum value.

This test has been verified on RV32 and RV64 with OpenSBI using QEMU.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h |  6 ++++
 lib/riscv/asm/sbi.h |  5 +++
 riscv/sbi.c         | 87 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index da58b0ce..c4435650 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -12,6 +12,7 @@
 #define CSR_STVAL		0x143
 #define CSR_SIP			0x144
 #define CSR_SATP		0x180
+#define CSR_TIME		0xc01
 
 #define SSTATUS_SIE		(_AC(1, UL) << 1)
 
@@ -108,5 +109,10 @@
 				: "memory");			\
 })
 
+#define wfi()							\
+({								\
+	__asm__ __volatile__("wfi" ::: "memory");		\
+})
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMRISCV_CSR_H_ */
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index d82a384d..eb4c77ef 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -18,6 +18,7 @@ enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
+	SBI_EXT_TIME = 0x54494D45,
 };
 
 enum sbi_ext_base_fid {
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
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 762e9711..6ad1dff6 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,8 +6,13 @@
  */
 #include <libcflat.h>
 #include <stdlib.h>
+#include <asm/csr.h>
+#include <asm/interrupt.h>
+#include <asm/processor.h>
 #include <asm/sbi.h>
 
+static bool timer_work;
+
 static void help(void)
 {
 	puts("Test SBI\n");
@@ -19,6 +24,18 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
 	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret __time_sbi_ecall(int fid, unsigned long arg0)
+{
+	return sbi_ecall(SBI_EXT_TIME, fid, arg0, 0, 0, 0, 0, 0);
+}
+
+static void timer_interrupt_handler(struct pt_regs *regs)
+{
+	timer_work = true;
+	toggle_timer_interrupt(false);
+	local_irq_disable();
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -112,6 +129,75 @@ static void check_base(void)
 	report_prefix_pop();
 }
 
+static void check_time(void)
+{
+	struct sbiret ret;
+	unsigned long begin, end, duration;
+	const unsigned long default_delay = 1000000;
+	unsigned long delay = getenv("TIMER_DELAY")
+				? MAX(strtol(getenv("TIMER_DELAY"), NULL, 0), default_delay)
+				: default_delay;
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
+	begin = csr_read(CSR_TIME);
+	end = csr_read(CSR_TIME);
+	if (begin >= end) {
+		report_fail("time counter has decreased");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("set_timer");
+
+	install_irq_handler(IRQ_SUPERVISOR_TIMER, timer_interrupt_handler);
+	local_irq_enable();
+
+	begin = csr_read(CSR_TIME);
+	ret = __time_sbi_ecall(SBI_EXT_TIME_SET_TIMER, csr_read(CSR_TIME) + delay);
+
+	if (ret.error) {
+		report_fail("setting timer failed");
+		install_irq_handler(IRQ_SUPERVISOR_TIMER, NULL);
+		report_prefix_pop();
+		report_prefix_pop();
+		return;
+	}
+
+	toggle_timer_interrupt(true);
+
+	while ((!timer_work) && (csr_read(CSR_TIME) <= (begin + delay)))
+		wfi();
+
+	end = csr_read(CSR_TIME);
+	report(timer_work, "timer interrupt received");
+
+	install_irq_handler(IRQ_SUPERVISOR_TIMER, NULL);
+	__time_sbi_ecall(SBI_EXT_TIME_SET_TIMER,  -1);
+
+	duration = end - begin;
+	if (timer_work)
+		report((duration >= delay) && (duration <= (delay + delay)), "timer delay honored");
+
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 
@@ -122,6 +208,7 @@ int main(int argc, char **argv)
 
 	report_prefix_push("sbi");
 	check_base();
+	check_time();
 
 	return report_summary();
 }
-- 
2.43.0


