Return-Path: <kvm+bounces-25492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6710B965E8E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6A6DB23ADC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F011B1D64;
	Fri, 30 Aug 2024 10:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gbCvCGLP"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BE418FC93
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 10:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725012757; cv=none; b=jcJBVA4Q58vFzTKX51xQmLPlVeTefSG2d5TeiATJvsXx7HjVb0nGPslZD/ibvSVyrgvR43EJs4EPC9bsTRk7x0nZuP/cIFFBCyUrizA8EY5le9qNLR5x0Ljx3G5om7p5hNm+NB68C4Eavq4mIUGjnbMADrPem5lHNaOlFxngiQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725012757; c=relaxed/simple;
	bh=+g2CnwQZmAX+btJR7PuVwPL1cIW4Zd+8eq095bwLH/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqD5bY7K+mR4L2O+GDipOOZdxTHdUqTYyAUK5ddG4eZwuiF4H3ENEru+OViOwF7Br+buIld5YlRWEOViq2sj4euWPbfMld1FYf7gadpVaUofnOnPCYo6x1l5/a6KriABVaZYBriooOyZE6RjUXnbL4Zeu73++pxyNObCI4A/eZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gbCvCGLP; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725012753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xDy3dXhfhs76uE+qsYOO2EHperiy+X3slHufWL875k=;
	b=gbCvCGLPnTCv01Gr43cOKTR4LYwl0FpaQy5QFy28EG6+sklK2PK6r1wH8sMlOoAr0lq7Yq
	Vd9CjTCpq+ib0DyEedKHL3SwDj3PC3LWkYcQHn6laUoBEGkKgOu3T7Xe4iaA4X7R5A01sN
	ByIxlCuz3RjbwnEpzhWzJ0nTikmUqi0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 3/3] riscv: Introduce SBI IPI convenience functions
Date: Fri, 30 Aug 2024 12:12:25 +0200
Message-ID: <20240830101221.2202707-8-andrew.jones@linux.dev>
In-Reply-To: <20240830101221.2202707-5-andrew.jones@linux.dev>
References: <20240830101221.2202707-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The SBI IPI function interface is a bit painful to use since it
operates on hartids as opposed to cpuids and requires determining a
mask base and a mask. Provide functions allowing IPIs to be sent to
single cpus and to all cpus set in a cpumask in order to simplify
things for unit tests.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/sbi.h |  3 +++
 lib/riscv/sbi.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 4a35cf38da70..e032444dd760 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -13,6 +13,7 @@
 #define SBI_ERR_ALREADY_STOPPED		-8
 
 #ifndef __ASSEMBLY__
+#include <cpumask.h>
 
 enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
@@ -67,6 +68,8 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 void sbi_shutdown(void);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
 struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
+struct sbiret sbi_send_ipi_cpu(int cpu);
+struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
 struct sbiret sbi_set_timer(unsigned long stime_value);
 long sbi_probe(int ext);
 
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 07660e422cbb..ecc63acdebb7 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <libcflat.h>
+#include <cpumask.h>
+#include <limits.h>
 #include <asm/sbi.h>
+#include <asm/setup.h>
 
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
@@ -44,6 +47,46 @@ struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base
 	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI, hart_mask, hart_mask_base, 0, 0, 0, 0);
 }
 
+struct sbiret sbi_send_ipi_cpu(int cpu)
+{
+	return sbi_send_ipi(1UL, cpus[cpu].hartid);
+}
+
+struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask)
+{
+	struct sbiret ret;
+	cpumask_t tmp;
+
+	if (cpumask_full(mask))
+		return sbi_send_ipi(0, -1UL);
+
+	cpumask_copy(&tmp, mask);
+
+	while (!cpumask_empty(&tmp)) {
+		unsigned long base = ULONG_MAX;
+		unsigned long mask = 0;
+		int cpu;
+
+		for_each_cpu(cpu, &tmp) {
+			if (base > cpus[cpu].hartid)
+				base = cpus[cpu].hartid;
+		}
+
+		for_each_cpu(cpu, &tmp) {
+			if (cpus[cpu].hartid < base + BITS_PER_LONG) {
+				mask |= 1UL << (cpus[cpu].hartid - base);
+				cpumask_clear_cpu(cpu, &tmp);
+			}
+		}
+
+		ret = sbi_send_ipi(mask, base);
+		if (ret.error)
+			break;
+	}
+
+	return ret;
+}
+
 struct sbiret sbi_set_timer(unsigned long stime_value)
 {
 	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
-- 
2.45.2


