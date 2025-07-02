Return-Path: <kvm+bounces-51309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E64CAF5BA6
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:51:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 437231C437F4
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791293093B4;
	Wed,  2 Jul 2025 14:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cjaawW8j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87A8309DD2
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467895; cv=none; b=T6W0nE0jIS1+2Vq9bJjpkUz3ERi8BvDdDxuZ6ldUroqVW6sluTNJ0yyYXo/MSJ8usbqcb4Ihxr80L7V1KOmO0UQbFPbW6tqoUbHEhofgu0enY1dxx3gsI6cCIYk09PxTssHmWeyRbiapbUgBmkkUvqfJfM5KAy/ug1HJ3fdcKkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467895; c=relaxed/simple;
	bh=090XyJcYXn++2OKbX5G3BQ2Ex0sAP4ydQYxInsBY24c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Oz6/Hi2MX+EhPwDChdZ/aBKhwsKlj1F/7mXvOk4+o5qqSQjNmgO5jl1wHmJO+XeXgFMqv/a/ct0xXBfbcu/dO6YBW/UsIzXo29dc+jkvMh6aORimDPuBJo1gpk8hHIyq/91DKYyt9uB8reQN84iAXqfYoQ8cZtzv7JtH49KQHEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cjaawW8j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751467892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AsPOBLkA6NZmktS+bKvYSVK66SOrHCtVCHiwLCy6xUo=;
	b=cjaawW8jY9rwnB8BhnoMC0f9yUnlccajpY0RpmCTYM8qXOQgmLHMypVF0UQXN8Iqk9MnR/
	TOqYeB14qw5Ppb0Klixb/5xYKBXLqOWt15nOq7MgRWfLivChRHRgDlHy+B8mG/6CWQksFO
	8bS8Xyh0aX8Fq6ZfAXh8U2Kb7TKIDOY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-98-NmD5rpldO0-U1z421FrVBg-1; Wed,
 02 Jul 2025 10:51:28 -0400
X-MC-Unique: NmD5rpldO0-U1z421FrVBg-1
X-Mimecast-MFC-AGG-ID: NmD5rpldO0-U1z421FrVBg_1751467887
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AF0D180028F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:51:27 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 62F1018003FC;
	Wed,  2 Jul 2025 14:51:26 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH] x86: add HPET counter read micro benchmark and enable/disable torture tests
Date: Wed,  2 Jul 2025 16:51:23 +0200
Message-ID: <20250702145123.1313738-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

test is to be used for benchmarking/validating HPET main counter read

how to run:
   QEMU=/foo/qemu-system-x86_64 x86/run x86/hpet_read_test.flat -smp X
where X is max number of logical CPUs on host

it will 1st execute concurrent read benchmark
and after that it will run torture test enabling/disabling HPET counter,
while running readers in parallel. Goal is to verify counter that always
goes up.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
this also will be used for testing upcomming HPET fain-grained
locking QEMU series  

---
 x86/Makefile.common  |  2 ++
 x86/hpet_read_test.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)
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
index 00000000..2f56ab6b
--- /dev/null
+++ b/x86/hpet_read_test.c
@@ -0,0 +1,66 @@
+#include "libcflat.h"
+#include "smp.h"
+
+#define HPET_ADDR         0xFED00000L
+#define HPET_COUNTER_ADDR ((uint8_t *)HPET_ADDR + 0xF0UL)
+#define HPET_CONFIG_ADDR  ((uint8_t *)HPET_ADDR + 0x10UL)
+#define HPET_ENABLE_BIT   0x01UL
+#define HPET_CLK_PERIOD   10
+
+static int fail = 0;
+static void hpet_reader(void *data)
+{
+    long cycles = (long)data;
+
+    while (cycles--) {
+        uint64_t old_counter = 0, new_counter;
+        new_counter = *(volatile uint64_t *)HPET_COUNTER_ADDR;
+        if (new_counter < old_counter) {
+            fail = 1;
+            report_abort("HPET counter jumped back");
+        }
+    }
+}
+
+
+static void hpet_writer(void *data)
+{
+    int i;
+    long cycles = (long)data;
+
+    for (i = 0; i < cycles; ++i)
+        if (i % 2)
+            *(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
+        else
+            *(volatile uint64_t *)HPET_CONFIG_ADDR &= ~HPET_ENABLE_BIT;
+}
+
+int main(void)
+{
+    long cycles = 100000;
+    int i;
+    int ncpus;
+    uint64_t start, end, time_ns;
+
+    ncpus = cpu_count();
+    do {
+        printf("starting concurrent read bench on %d cpus\n", ncpus);
+        *(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
+        start = *(volatile uint64_t *)HPET_COUNTER_ADDR;
+        on_cpus(hpet_reader, (void *)cycles);
+        end = (*(volatile uint64_t *)HPET_COUNTER_ADDR);
+        time_ns = (end - start) * HPET_CLK_PERIOD;
+        report(time_ns, "read test took %lu ms\n", time_ns/1000000);
+    } while (0);
+
+    do {
+        printf("starting enable/disable with concurent readers torture\n");
+        for (i = 2; i < ncpus; i++)
+            on_cpu_async(i, hpet_reader, (void *)cycles);
+
+        on_cpu(1, hpet_writer, (void *)cycles);
+    } while (0);
+
+    report(!fail, "passed torture test\n");
+    return report_summary();
+}
-- 
2.47.1


