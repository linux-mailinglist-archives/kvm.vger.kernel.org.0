Return-Path: <kvm+bounces-6782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7490983A2AD
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07769B23563
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48702171B6;
	Wed, 24 Jan 2024 07:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZHMpF8mn"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD36168D7
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080708; cv=none; b=rI8Xem8YP56E3AkHWoZFDh8jHG7FNbHQq4uaNBXjWIrlGLkk+CPNcpKiI8//gnPe6h7ex4TOy2wUsr3Judd8hcYM9bnLewlITSiFEBIFwHpZpYNYBzuVwgki3lKTw9ur7G6ZpsUHMh+KzFT08rN8agzfabY3CrBeI61lD1kFQW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080708; c=relaxed/simple;
	bh=RXgAnScc6I9djSFdg0bDi6Oz2kU8NZXl6gGyk/D4LIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=BoAUmWRM+Ys1wjpmDU/SB1I/UwUoyEB8qSKetHzneh4Fp74ziAIvne1twDMGIeyRzdjbOsIFjQXAq/73273ViTcdQiSf6gEKmS+Hd4Sh0dhLs7IdA+tbpRL18r9icpidd4XsdAzpUDLMb+mz7fO24vZMUYg9T33/G1ZCIiQQ1lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZHMpF8mn; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xI4jn2uo7jv52onia1pxVcqGHnwLAyu94nkuAXQ3iEo=;
	b=ZHMpF8mnHdXZ4ba8MeNLbNCTdDNn3CsdHuH/q2sh7u8a7/qaxoPNZ40YyLvoBowhxkgYRp
	OIUkxrfMqufWl+f32ZIz/aozAFLq6rqX18aC7ObtEMpVWwpESi9AQ/9PYhPkZmr8eoCur0
	4IWbMo8gjzHuC5LnoeMpXoAC7Amnp6g=
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
Subject: [kvm-unit-tests PATCH 03/24] arm/arm64: Move cpumask.h to common lib
Date: Wed, 24 Jan 2024 08:18:19 +0100
Message-ID: <20240124071815.6898-29-andrew.jones@linux.dev>
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

RISC-V will also make use of cpumask.h, so move it to the arch-common
directory.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/asm/gic-v2.h        | 2 +-
 lib/arm/asm/gic-v3.h        | 2 +-
 lib/arm/asm/gic.h           | 2 +-
 lib/arm/asm/smp.h           | 2 +-
 lib/arm/mmu.c               | 2 +-
 lib/arm/smp.c               | 2 +-
 lib/arm64/asm/cpumask.h     | 1 -
 lib/{arm/asm => }/cpumask.h | 9 ++++-----
 8 files changed, 10 insertions(+), 12 deletions(-)
 delete mode 100644 lib/arm64/asm/cpumask.h
 rename lib/{arm/asm => }/cpumask.h (94%)

diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
index 1fcfd43c8075..ff11afb15d30 100644
--- a/lib/arm/asm/gic-v2.h
+++ b/lib/arm/asm/gic-v2.h
@@ -18,7 +18,7 @@
 #define GICC_IAR_INT_ID_MASK		0x3ff
 
 #ifndef __ASSEMBLY__
-#include <asm/cpumask.h>
+#include <cpumask.h>
 
 struct gicv2_data {
 	void *dist_base;
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index b4ce130e56c6..a1cc62a298b8 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -67,10 +67,10 @@
 #include <asm/arch_gicv3.h>
 
 #ifndef __ASSEMBLY__
+#include <cpumask.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/delay.h>
-#include <asm/cpumask.h>
 #include <asm/smp.h>
 #include <asm/io.h>
 
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 189840014b02..dc8cc18c0fbd 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -47,7 +47,7 @@
 #define SPI(irq)			((irq) + GIC_FIRST_SPI)
 
 #ifndef __ASSEMBLY__
-#include <asm/cpumask.h>
+#include <cpumask.h>
 
 enum gic_irq_state {
 	GIC_IRQ_STATE_INACTIVE,
diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index dee4c1a883e7..bb3e71a55e8c 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -5,8 +5,8 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <cpumask.h>
 #include <asm/thread_info.h>
-#include <asm/cpumask.h>
 
 #define smp_processor_id()		(current_thread_info()->cpu)
 
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 2f4ec815a35d..b16517a3200d 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -5,9 +5,9 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <cpumask.h>
 #include <asm/setup.h>
 #include <asm/thread_info.h>
-#include <asm/cpumask.h>
 #include <asm/mmu.h>
 #include <asm/setup.h>
 #include <asm/page.h>
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 1d470d1aab45..78fc1656cefa 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -7,9 +7,9 @@
  */
 #include <libcflat.h>
 #include <auxinfo.h>
+#include <cpumask.h>
 #include <asm/thread_info.h>
 #include <asm/spinlock.h>
-#include <asm/cpumask.h>
 #include <asm/barrier.h>
 #include <asm/mmu.h>
 #include <asm/psci.h>
diff --git a/lib/arm64/asm/cpumask.h b/lib/arm64/asm/cpumask.h
deleted file mode 100644
index d1421e7abe31..000000000000
--- a/lib/arm64/asm/cpumask.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../arm/asm/cpumask.h"
diff --git a/lib/arm/asm/cpumask.h b/lib/cpumask.h
similarity index 94%
rename from lib/arm/asm/cpumask.h
rename to lib/cpumask.h
index 3fa57bfb17c6..d30e14cda09e 100644
--- a/lib/arm/asm/cpumask.h
+++ b/lib/cpumask.h
@@ -1,12 +1,11 @@
-#ifndef _ASMARM_CPUMASK_H_
-#define _ASMARM_CPUMASK_H_
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Simple cpumask implementation
  *
  * Copyright (C) 2015, Red Hat Inc, Andrew Jones <drjones@redhat.com>
- *
- * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#ifndef _CPUMASK_H_
+#define _CPUMASK_H_
 #include <asm/setup.h>
 #include <bitops.h>
 
@@ -120,4 +119,4 @@ static inline int cpumask_next(int cpu, const cpumask_t *mask)
 			(cpu) < nr_cpus; 			\
 			(cpu) = cpumask_next(cpu, mask))
 
-#endif /* _ASMARM_CPUMASK_H_ */
+#endif /* _CPUMASK_H_ */
-- 
2.43.0


