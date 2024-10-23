Return-Path: <kvm+bounces-29514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C509ACB16
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9326282444
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1882E1AB6ED;
	Wed, 23 Oct 2024 13:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FdSutKbr"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BC31AE00B
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689706; cv=none; b=rOM8lrDHuIGuwWYz6p4E9RUWOyv/iaJa8GzisT6zMQ8BmoAn1vmw2/2DjQYrCLXjq73RQsD3sQMJfRfdP/wtA+Aox92YH2KDCOpmZbLe4WWPTj8twzmX/tZ7o40J83//HMyHhI1XuAWyTfM/V7Zw1kVJaLs5ANFrDT3fngvCIHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689706; c=relaxed/simple;
	bh=q/5dHEBagCDK99UL3gUlS2h98GdDCGGJRpsxT6/3e3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogI2vpbSArrWoBOqMgyuZSPPmLPooSWGDzbExA6lpSaVR2gPD/DklU1hwZDnBaQlMkcIBh8gX1HGzOIHv4+K2xvRQiwqGcQeh1chTm3JK/ZMwdfOjxi37VHNBt4su3WipqCB7Bhs3hQDrP2+rFjIYtp7eh9BlX0GtkulHxGqmY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FdSutKbr; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v4n6iXUzuE7MoPSEF0ddVeFcFHlzBfHTUGSIQ/G9qu4=;
	b=FdSutKbr+n7M6TgBthyAaF8qcxESYQIgxvYeGZ+VnbE5FGkNMTj03ppIQK0dBEhU0SJX8c
	GcO3or5UYcOlpvUf9pjn4G14pI3zsdoptmz/+ffm7JvRD46wRwZaEflil76u3t8Ru/4uV4
	WzTzSm5NZStcGTGjB2xES9P1eBCwaYU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/4] riscv: Filter unmanaged harts from present mask
Date: Wed, 23 Oct 2024 15:21:33 +0200
Message-ID: <20241023132130.118073-8-andrew.jones@linux.dev>
In-Reply-To: <20241023132130.118073-6-andrew.jones@linux.dev>
References: <20241023132130.118073-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We use SBI to manage harts and SBI may have a different idea of which
harts it should manage than our hardware description. Filter out all
harts which fail an SBI HSM status call from the present mask to
ensure we don't try to use them.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/setup.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index f347ad6352d7..211945448b0f 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -19,6 +19,7 @@
 #include <asm/mmu.h>
 #include <asm/page.h>
 #include <asm/processor.h>
+#include <asm/sbi.h>
 #include <asm/setup.h>
 #include <asm/timer.h>
 
@@ -51,7 +52,9 @@ static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
 
 	cpus[cpu].cpu = cpu;
 	cpus[cpu].hartid = regval;
-	set_cpu_present(cpu, true);
+
+	if (!sbi_hart_get_status(cpus[cpu].hartid).error)
+		set_cpu_present(cpu, true);
 }
 
 static void cpu_init_acpi(void)
@@ -61,7 +64,7 @@ static void cpu_init_acpi(void)
 
 static void cpu_init(void)
 {
-	int ret;
+	int ret, me;
 
 	nr_cpus = 0;
 	if (dt_available()) {
@@ -71,7 +74,9 @@ static void cpu_init(void)
 		cpu_init_acpi();
 	}
 
-	set_cpu_online(hartid_to_cpu(csr_read(CSR_SSCRATCH)), true);
+	me = hartid_to_cpu(csr_read(CSR_SSCRATCH));
+	assert(cpu_present(me));
+	set_cpu_online(me, true);
 	cpu0_calls_idle = true;
 }
 
-- 
2.47.0


