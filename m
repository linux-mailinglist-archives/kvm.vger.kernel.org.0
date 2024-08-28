Return-Path: <kvm+bounces-25275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6B2962D8E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:22:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09E0F1C22DAE
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7171A3BC1;
	Wed, 28 Aug 2024 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H4yDbrMg"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9861F1A3BA0
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724862135; cv=none; b=ZnvMG9hLb3kLTtIyzM87S5o68+LxzDVWnnuFtkTgMlpi3VFCUht7N4woe8FYoQUp9jUR04Jbs6Genod9JXbYZ4d7qBRL8jcyFbuLEZbjnK2S33tuSHGBjXbiVZmdEi7DuyyERvIlDEpUUilsLhFqYasXj6xMpjovn6HnAWLrbg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724862135; c=relaxed/simple;
	bh=+eqc5rKCxMwQx/83edrPN/kBuQx0Y97/SDXlDMV2dVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiukeE6ugjTCcLPACy7PMvuaNwmmjBs3kJNgrgDFZWete7q+btYg23zRR1aAsQcOsFnPsbzktm2TEQtENe859jilGRxudXORqiVjGQjhcZDN0ldx+ls9WKly2QjLJCc2EB2AxquD/W6crkyPxrhPJ25lpIaYJxqyL3Gug5NgxiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H4yDbrMg; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724862131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e++uBn8BLrdi0jP9yB3jWjkyW9E9kfTvv2nMDoQy5Wo=;
	b=H4yDbrMgC+l/SUK5t5e+3dg7hwe6qoKCcmy8lrMc9vJZjJNSZNs3CcWlBBY4rh0pX9+wTf
	0qicxm/USNOgoxvKXiKeLIPrRkYr+45P9Qtqj8InERgfHOXO7XzMu0WKL6o/S8HndZ57rp
	CE6yMLv6ffRhdqYa3k4qN6+/J4ikn7s=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 3/3] riscv: Provide timer_start and timer_stop
Date: Wed, 28 Aug 2024 18:22:04 +0200
Message-ID: <20240828162200.1384696-8-andrew.jones@linux.dev>
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

For unit tests that need a timer but don't care if they use Sstc or
SBI TIME, provide timer_start and timer_stop which will try Sstc
first and fallback to SBI TIME.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/timer.h |  2 ++
 lib/riscv/timer.c     | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
index fd12251a3a6b..9e790a97bd24 100644
--- a/lib/riscv/asm/timer.h
+++ b/lib/riscv/asm/timer.h
@@ -6,6 +6,8 @@
 
 extern void timer_get_frequency(void);
 extern void local_timer_init(void);
+extern void timer_start(unsigned long duration_us);
+extern void timer_stop(void);
 
 static inline uint64_t timer_get_cycles(void)
 {
diff --git a/lib/riscv/timer.c b/lib/riscv/timer.c
index 92826d6ec3fe..67fd031ab95f 100644
--- a/lib/riscv/timer.c
+++ b/lib/riscv/timer.c
@@ -6,7 +6,9 @@
 #include <devicetree.h>
 #include <limits.h>
 #include <asm/csr.h>
+#include <asm/delay.h>
 #include <asm/isa.h>
+#include <asm/sbi.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
@@ -39,3 +41,34 @@ void local_timer_init(void)
 			csr_write(CSR_STIMECMPH, ULONG_MAX);
 	}
 }
+
+void timer_start(unsigned long duration_us)
+{
+	uint64_t next = timer_get_cycles() + usec_to_cycles((uint64_t)duration_us);
+
+	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
+		csr_write(CSR_STIMECMP, (unsigned long)next);
+		if (__riscv_xlen == 32)
+			csr_write(CSR_STIMECMPH, (unsigned long)(next >> 32));
+	} else if (sbi_probe(SBI_EXT_TIME)) {
+		struct sbiret ret = sbi_set_timer(next);
+		assert(ret.error == SBI_SUCCESS);
+		assert(!(next >> 32));
+	} else {
+		assert_msg(false, "No timer to start!");
+	}
+}
+
+void timer_stop(void)
+{
+	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
+		csr_write(CSR_STIMECMP, ULONG_MAX);
+		if (__riscv_xlen == 32)
+			csr_write(CSR_STIMECMPH, ULONG_MAX);
+	} else if (sbi_probe(SBI_EXT_TIME)) {
+		struct sbiret ret = sbi_set_timer(ULONG_MAX);
+		assert(ret.error == SBI_SUCCESS);
+	} else {
+		assert_msg(false, "No timer to stop!");
+	}
+}
-- 
2.45.2


