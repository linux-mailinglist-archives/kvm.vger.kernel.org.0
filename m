Return-Path: <kvm+bounces-25273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDC1962D8C
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AA702868DF
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6731A4B82;
	Wed, 28 Aug 2024 16:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UXhT3XsJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70611A3BA0
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724862131; cv=none; b=im1Q8BYd2ZtfBB5j322T+hMPLuy82IJQmWy+w1E8tLJXwQwuh+bYL/ueswbfvNBqkEGPu9KR24r5IdqLPL7GfIKRuGv77PpyEmOPWW/O5bbbAOwh7iT1Nw4fYTInYe6GH+ZRHUfGbLFE6TdlAzrpjm/XnOF22KnND/D2R+SNFt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724862131; c=relaxed/simple;
	bh=fuoEwOpVumRo8h+UC3R1unaQWJs7YIQYRjDaAgU3tK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJmKbWPGdJi8rio3hIGACkFBqH3i72J1fsUGPvyAPe0/NCCJTJCLqeZaBiz/OQgSXgfTCulE3mrRGPt+ZsJSIRiF0A2tdshrhASER/yjmpEfcQP9AL9AkmNN+WKgQOQ62IdH/K4Ox0kfULp6xxXwXr2Vgd+3bIi0t/kUf+yV8WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UXhT3XsJ; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724862126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8p/IIk0B7Z3/xGeHNl/FhStqLK9xsXc/qtKenXWl9uU=;
	b=UXhT3XsJTaw2cuprhvneey5UKwSRaeaoSpkgxP0e1QTLcYNp3xqan6/zW0APTi15K48Rpw
	1kNZ7DIxMHdsE9lyoahiX1gPoZOXwUg3RjKwk1cnfS6U5IJ8DClVqQKNzBDw7DDbMm6ZHU
	5HmLHCRgxQSlAvMnbi8jZICvAwG5gZQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/3] riscv: Introduce local_timer_init
Date: Wed, 28 Aug 2024 18:22:02 +0200
Message-ID: <20240828162200.1384696-6-andrew.jones@linux.dev>
In-Reply-To: <20240828162200.1384696-5-andrew.jones@linux.dev>
References: <20240828162200.1384696-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When Sstc is available make sure that even if we enable timer
interrupts nothing will happen. This is necessary for cases where
the unit tests actually intend to use the SBI TIME extension and
aren't thinking about Sstc at all, like the SBI TIME test in
riscv/sbi where we can now remove the initialization.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/timer.h |  1 +
 lib/riscv/setup.c     |  2 ++
 lib/riscv/smp.c       |  2 ++
 lib/riscv/timer.c     | 13 +++++++++++++
 riscv/sbi.c           |  5 -----
 5 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
index b3514d3f6a78..fd12251a3a6b 100644
--- a/lib/riscv/asm/timer.h
+++ b/lib/riscv/asm/timer.h
@@ -5,6 +5,7 @@
 #include <asm/csr.h>
 
 extern void timer_get_frequency(void);
+extern void local_timer_init(void);
 
 static inline uint64_t timer_get_cycles(void)
 {
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 9a16f00093d7..7c4321b1c30f 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -210,6 +210,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	cpu_init();
 	timer_get_frequency();
 	thread_info_init();
+	local_timer_init();
 	io_init();
 
 	ret = dt_get_bootargs(&bootargs);
@@ -276,6 +277,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	cpu_init();
 	timer_get_frequency();
 	thread_info_init();
+	local_timer_init();
 	io_init();
 	initrd_setup();
 
diff --git a/lib/riscv/smp.c b/lib/riscv/smp.c
index 4d373e0a29a8..18d0393c0cc2 100644
--- a/lib/riscv/smp.c
+++ b/lib/riscv/smp.c
@@ -14,6 +14,7 @@
 #include <asm/processor.h>
 #include <asm/sbi.h>
 #include <asm/smp.h>
+#include <asm/timer.h>
 
 cpumask_t cpu_present_mask;
 cpumask_t cpu_online_mask;
@@ -27,6 +28,7 @@ secondary_func_t secondary_cinit(struct secondary_data *data)
 
 	__mmu_enable(data->satp);
 	thread_info_init();
+	local_timer_init();
 	info = current_thread_info();
 	set_cpu_online(info->cpu, true);
 	smp_send_event();
diff --git a/lib/riscv/timer.c b/lib/riscv/timer.c
index d78d254c8eca..92826d6ec3fe 100644
--- a/lib/riscv/timer.c
+++ b/lib/riscv/timer.c
@@ -4,7 +4,11 @@
  */
 #include <libcflat.h>
 #include <devicetree.h>
+#include <limits.h>
+#include <asm/csr.h>
+#include <asm/isa.h>
 #include <asm/setup.h>
+#include <asm/smp.h>
 #include <asm/timer.h>
 
 void timer_get_frequency(void)
@@ -26,3 +30,12 @@ void timer_get_frequency(void)
 	data = (u32 *)prop->data;
 	timebase_frequency = fdt32_to_cpu(*data);
 }
+
+void local_timer_init(void)
+{
+	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
+		csr_write(CSR_STIMECMP, ULONG_MAX);
+		if (__riscv_xlen == 32)
+			csr_write(CSR_STIMECMPH, ULONG_MAX);
+	}
+}
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 01697aed3457..e8598fe721a6 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -258,11 +258,6 @@ static void check_time(void)
 
 	install_irq_handler(IRQ_S_TIMER, timer_irq_handler);
 	local_irq_enable();
-	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
-		csr_write(CSR_STIMECMP, ULONG_MAX);
-		if (__riscv_xlen == 32)
-			csr_write(CSR_STIMECMPH, ULONG_MAX);
-	}
 	timer_irq_enable();
 
 	timer_check_set_timer(false);
-- 
2.45.2


