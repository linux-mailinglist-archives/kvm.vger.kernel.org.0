Return-Path: <kvm+bounces-53440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19239B11B47
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 11:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B00E177536
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 09:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D6E2D3A85;
	Fri, 25 Jul 2025 09:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVyzFiFq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905ED2D59E3
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753437287; cv=none; b=XWqtz4FBxprdRfFS55kGfKNtn5twQuTyauLHlgTyzgMSRQFV1yCmMygOfiwOZlHJlRfQu5wkm3GTf8xRZS+JyYVoIFw6DIAqfrl2aGs/EFjqKCa+MOL/muSz+R1Z7nNlUrG7ZOaG4nVl4wFEAKGJ9TEYOOyCL8qqKPUX9bOnUbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753437287; c=relaxed/simple;
	bh=KQiWoYwE4DtgGub2KVDrTmPEBdDunx+CvhNc03f/X8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DWUBtPBVDXbeEG29zGrBuDI7a3Q3bZedlxmd68sJofnyrqaRCe7egmXZfcHw9soNa5N9LSn2z8fmjW2xbClMRZlZcrTqEtuS1QwGIoiFj168ETS2ORJ0xUE2HSPERm5Q7w1eIMiD0+28LoC8gouGgjnYzH9KH1MlF0EVSywY0Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EVyzFiFq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753437284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PgepI28mSFaDGrO5jO+/MtZDNqSsfZIqo5y5RNjR59U=;
	b=EVyzFiFqHAycMlKrLj2KqB4npWTVp1YNMT+0dPDJXgTWVtyyZyaDuI6D+z8y+DsCBI1spe
	rbvupyP3dNwKmlxjAfISFtukObJasZfOzXBXKTNpAIeSfceokRl+YuNGP+/gL0RP3WOlZj
	mFPr81RxjoftgRfUHXj8V9hfZWR6x5w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-B8Wjw5u7PF29wgmtWrU0zg-1; Fri,
 25 Jul 2025 05:54:41 -0400
X-MC-Unique: B8Wjw5u7PF29wgmtWrU0zg-1
X-Mimecast-MFC-AGG-ID: B8Wjw5u7PF29wgmtWrU0zg_1753437280
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A2DE1800873
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:40 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E5E019560AA;
	Fri, 25 Jul 2025 09:54:38 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	peterx@redhat.com
Subject: [kvm-unit-tests PATCH v4 5/5] x86: add HPET counter read micro benchmark and enable/disable torture tests
Date: Fri, 25 Jul 2025 11:54:29 +0200
Message-ID: <20250725095429.1691734-6-imammedo@redhat.com>
In-Reply-To: <20250725095429.1691734-1-imammedo@redhat.com>
References: <20250725095429.1691734-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

test is to be used for benchmarking/validating HPET main counter reading

how to run:
   QEMU=/foo/qemu-system-x86_64 x86/run x86/hpet_read_test.flat -smp X
where X is desired number of logical CPUs to test with

it will 1st execute concurrent read benchmark
and after that it will run torture test enabling/disabling HPET counter,
while running readers in parallel. Goal is to verify counter that always
goes up.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
v4:
   * use global for test cycles and siplify code a bit
   * use cpu number instead of APCI ID as index into latency array
   * report failure if a cpu measured 0 latency
   * replace on_cpus() with on_cpu_async() to avoid BSP
     interrupting itself
   * drop volatile

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
 x86/hpet_read_test.c | 93 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)
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
index 00000000..a44cdac2
--- /dev/null
+++ b/x86/hpet_read_test.c
@@ -0,0 +1,93 @@
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
+#define TEST_CYCLES 100000
+
+static atomic_t fail;
+static uint64_t latency[MAX_TEST_CPUS];
+
+static void hpet_reader(void *data)
+{
+	long i;
+	uint64_t old_counter = 0, new_counter;
+	long id = (long)data;
+
+	latency[id] = *(uint64_t *)HPET_COUNTER_ADDR;
+	for (i = 0; i < TEST_CYCLES; ++i) {
+		new_counter = *(uint64_t *)HPET_COUNTER_ADDR;
+		if (new_counter < old_counter)
+			atomic_inc(&fail);
+		old_counter = new_counter;
+	}
+	/* claculate job latency in ns */
+	latency[id] = (*(uint64_t *)HPET_COUNTER_ADDR - latency[id])
+		* HPET_CLK_PERIOD / TEST_CYCLES;
+}
+
+static void hpet_writer(void *data)
+{
+	int i;
+
+	for (i = 0; i < TEST_CYCLES; ++i)
+		if (i % 2)
+			*(uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
+		else
+			*(uint64_t *)HPET_CONFIG_ADDR &= ~HPET_ENABLE_BIT;
+}
+
+int main(void)
+{
+	unsigned long cpu, time_ns, lat = 0;
+	uint64_t start, end;
+	int ncpus = cpu_count();
+
+	do {
+		printf("* starting concurrent read bench on %d cpus\n", ncpus);
+		*(uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
+		start = *(uint64_t *)HPET_COUNTER_ADDR;
+
+		for (cpu = cpu_count() - 1; cpu > 0; --cpu)
+			on_cpu_async(cpu, hpet_reader, (void *)cpu);
+		while (cpus_active() > 1)
+			pause();
+
+		end = (*(uint64_t *)HPET_COUNTER_ADDR);
+		time_ns = (end - start) * HPET_CLK_PERIOD;
+
+		for (cpu = 1; cpu < ncpus; cpu++)
+			if (latency[cpu])
+				lat += latency[cpu];
+			else
+				report_fail("cpu %lu reported invalid latency (0)\n", cpu);
+		lat = lat / ncpus;
+
+		report(time_ns && !atomic_read(&fail),
+			"read test took %lu ms, avg read: %lu ns\n", time_ns/1000000,  lat);
+	} while (0);
+
+	do {
+		printf("* starting enable/disable with concurrent readers torture\n");
+		if (ncpus > 2) {
+			for (cpu = 2; cpu < ncpus; cpu++)
+				on_cpu_async(cpu, hpet_reader, (void *)TEST_CYCLES);
+
+			on_cpu(1, hpet_writer, (void *)TEST_CYCLES);
+			report(!atomic_read(&fail), "torture test, fails: %u\n",
+				atomic_read(&fail));
+		} else
+			printf("SKIP: torture test: '-smp X' should be greater than 2\n");
+	} while (0);
+
+	return report_summary();
+}
-- 
2.47.1


