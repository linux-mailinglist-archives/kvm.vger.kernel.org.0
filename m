Return-Path: <kvm+bounces-52914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76038B0A80F
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56C54A40810
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B222E612C;
	Fri, 18 Jul 2025 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fm1Bo2wZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71DA2E11BA
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752854269; cv=none; b=td54N0ODnSzthSxBwA+o+O2AICV3qtEOp8h3f2py/RP5eY8eQ8El49pdmVG5kmhW7O6qUTQGFDU1LSFAwq+1JMhz7yt+Z0O1B96iDAXXeD3qQ+3Pggfof2nyfkERgWUIwDQzwo6AGjcWnzKmKD1/Zy9GeLjU6mWkBwlYaqRGcDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752854269; c=relaxed/simple;
	bh=bKO27ZSFTdurBTUJsn6iNijYWMNAIFAB0DtrAM9SDpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RLApDcCvd4h9ufOMclgDPakqGhWxrp4TeeLTa3adMbKDeiIysqKhrRDJXmMU0kYe/mHjipfp3T3+6tBNfBPFjBYU00OwKe3LW8BLQnwxhIlzKKMNmi7Al+JZIhDkNSKYUBaaiTXEdvPub8cLeOy7x09B2PhPuc5o02/pMaX1JEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fm1Bo2wZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752854266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0cstcSZsuyMvbUdHm5ffDNjI7mYUFo/B6feTNH1JH/0=;
	b=Fm1Bo2wZqYsLrrSljbWVyiKfsRfHt9XEF2fQuaFPC/FihRb15FZcNWkqmaTNa+PdN2zSf0
	nEf5W3l6O4XbWLs7V1dX3D+vvSHJG5b0decUgyQcXCTDbxv0J0w9guhGByJHbk7uf24pvJ
	wEGAiB7YwMqK0hWrWvDES+d27ccOQTc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-CWo361yeNUibIobzd7epsg-1; Fri,
 18 Jul 2025 11:57:45 -0400
X-MC-Unique: CWo361yeNUibIobzd7epsg-1
X-Mimecast-MFC-AGG-ID: CWo361yeNUibIobzd7epsg_1752854264
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 547811800371
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:57:44 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 862D7195608D;
	Fri, 18 Jul 2025 15:57:43 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/2] x86: add HPET counter read micro benchmark and enable/disable torture tests
Date: Fri, 18 Jul 2025 17:57:38 +0200
Message-ID: <20250718155738.1540072-3-imammedo@redhat.com>
In-Reply-To: <20250718155738.1540072-1-imammedo@redhat.com>
References: <20250718155738.1540072-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

test is to be used for benchmarking/validating HPET main counter reading

how to run:
   QEMU=/foo/qemu-system-x86_64 x86/run x86/hpet_read_test.flat -smp X
where X is max number of logical CPUs on host

it will 1st execute concurrent read benchmark
and after that it will run torture test enabling/disabling HPET counter,
while running readers in parallel. Goal is to verify counter that always
goes up.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
v3:
   * measure lat inside threads so that, threads startup time wouldn't
     throw off results
   * fix BSP iterrupting itself by running read test and stalling
     other cpus as result. (fix it by exiting read test earlier if
     it's running on BSP)
v2:
   * fix broken timer going backwards check
   * report # of fails
   * warn if number of vcpus is not sufficient for torture test and skip
     it
   * style fixups
---
 x86/Makefile.common  |  2 +
 x86/hpet_read_test.c | 96 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 x86/hpet_read_test.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 5663a65d..ef0e09a6 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -101,6 +101,8 @@ tests-common += $(TEST_DIR)/realmode.$(exe) \
 realmode_bits := $(if $(call cc-option,-m16,""),16,32)
 endif
 
+tests-common += $(TEST_DIR)/hpet_read_test.$(exe)
+
 test_cases: $(tests-common) $(tests)
 
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
diff --git a/x86/hpet_read_test.c b/x86/hpet_read_test.c
new file mode 100644
index 00000000..a4b007ab
--- /dev/null
+++ b/x86/hpet_read_test.c
@@ -0,0 +1,96 @@
+#include "libcflat.h"
+#include "smp.h"
+#include "apic.h"
+#include "asm/barrier.h"
+#include "x86/atomic.h"
+#include "vmalloc.h"
+#include "alloc.h"
+
+#define HPET_ADDR         0xFED00000L
+#define HPET_COUNTER_ADDR ((uint8_t *)HPET_ADDR + 0xF0UL)
+#define HPET_CONFIG_ADDR  ((uint8_t *)HPET_ADDR + 0x10UL)
+#define HPET_ENABLE_BIT   0x01UL
+#define HPET_CLK_PERIOD   10
+
+static atomic_t fail;
+static uint64_t *latency;
+
+static void hpet_reader(void *data)
+{
+	uint64_t old_counter = 0, new_counter;
+	long cycles = (long)data;
+
+	/*
+	 * on_cpus() will interrupt to run handler as well,
+	 * exit without running bench so that on_cpus() would continue spawning
+	 * other threads
+	 */
+	if (!apic_id())
+		return;
+
+	latency[apic_id()] = *(volatile uint64_t *)HPET_COUNTER_ADDR;
+	while (cycles--) {
+		new_counter = *(volatile uint64_t *)HPET_COUNTER_ADDR;
+		if (new_counter < old_counter)
+			atomic_inc(&fail);
+		old_counter = new_counter;
+	}
+	/* claculate job latency in ns */
+	latency[apic_id()] = (*(volatile uint64_t *)HPET_COUNTER_ADDR - latency[apic_id()])
+		* HPET_CLK_PERIOD
+		/(long)data;
+}
+
+static void hpet_writer(void *data)
+{
+	int i;
+	long cycles = (long)data;
+
+	for (i = 0; i < cycles; ++i)
+		if (i % 2)
+			*(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
+		else
+			*(volatile uint64_t *)HPET_CONFIG_ADDR &= ~HPET_ENABLE_BIT;
+}
+
+int main(void)
+{
+	long cycles = 100000;
+	int i;
+	int ncpus;
+	uint64_t start, end, time_ns, lat = 0;
+
+	ncpus = cpu_count();
+	latency = malloc(sizeof(*latency) * ncpus);
+	do {
+		printf("* starting concurrent read bench on %d cpus\n", ncpus);
+		*(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
+		start = *(volatile uint64_t *)HPET_COUNTER_ADDR;
+		on_cpus(hpet_reader, (void *)cycles);
+		end = (*(volatile uint64_t *)HPET_COUNTER_ADDR);
+		time_ns = (end - start) * HPET_CLK_PERIOD;
+
+		for (i = 1; i < ncpus; i++)
+			lat += latency[i];
+		lat = lat/ncpus;
+
+		report(time_ns && !atomic_read(&fail),
+			"read test took %lu ms, avg read: %lu ns\n", time_ns/1000000,  lat);
+	} while (0);
+
+	do {
+		printf("* starting enable/disable with concurrent readers torture\n");
+		if (ncpus > 2) {
+			for (i = 2; i < ncpus; i++)
+				on_cpu_async(i, hpet_reader, (void *)cycles);
+
+			on_cpu(1, hpet_writer, (void *)cycles);
+			report(!atomic_read(&fail), "torture test, fails: %u\n",
+							atomic_read(&fail));
+		} else {
+			printf("SKIP: torture test: '-smp X' should be greater than 2\n");
+		}
+	} while (0);
+
+	return report_summary();
+}
-- 
2.47.1


