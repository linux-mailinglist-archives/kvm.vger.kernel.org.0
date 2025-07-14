Return-Path: <kvm+bounces-52338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B494DB0422A
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF1AB1A634B9
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47711259CAF;
	Mon, 14 Jul 2025 14:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cphnF2fP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27D67262A
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752504664; cv=none; b=lxK3WoiyIAfDSiCL6NWUe9OV4Bz+TiirGrQfaaJwV2lhDZIXG6Ca76liPQ3SWkpPy5Nkw/H8naV7zB5/72PiI+i2V3qnCWEK46Jl5880kUPRjAa+5Rgp2ncbpq4IZ/4ndYCywkqcSHj78sWqi+wfFfaVNi2IPfDu+wNP+uv59Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752504664; c=relaxed/simple;
	bh=TpRjwZhFaB4hUyHwO85TEJZ9oWPA3B/qZb/0ol8ov4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V5mhz79s++6ZNcsOpU5sM6DboQYHuvEJa+C0VZSceL/hgAUuqhQDidUxsLrZ0XAjr1SDxIXRVTZI6PB6SRpNpay/eppPl5vQHfu2KnlzcSWDp2Up+JEN9Of7ug60sC/0x/2C+OlPKTF2IMX46MUWXequEMbnTe5wJxf45iiCYes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cphnF2fP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752504661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=077iID017x5hekrx8ZJxn5xmRJvz5gqq3mLhkRXv4F0=;
	b=cphnF2fPNbUC2DNTkeAk2rMqpQMNWlEyUfJC4gtD6vX+dpTDWrJLmiXVv3YhXKOVncqM2H
	BiPVbh+QmEh+k5HfkSKL0THfunxIN1iSIHxhiIPfEo8PQTBsVyoOoV27CjD8rDLR+Hq7cB
	v/sgy6CKwODmfBG+PeU6IT5RFX2GEzg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-vrPzNYbiOQKhd7KwcHHQQw-1; Mon,
 14 Jul 2025 10:51:00 -0400
X-MC-Unique: vrPzNYbiOQKhd7KwcHHQQw-1
X-Mimecast-MFC-AGG-ID: vrPzNYbiOQKhd7KwcHHQQw_1752504659
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38F9E18001D6
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 14:50:59 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 51D9B1956094;
	Mon, 14 Jul 2025 14:50:58 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: [PATCH v2] x86: add HPET counter read micro benchmark and enable/disable torture tests
Date: Mon, 14 Jul 2025 16:50:55 +0200
Message-ID: <20250714145055.1487738-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

test is to be used for benchmarking/validating HPET main counter reading

how to run:
   QEMU=/foo/qemu-system-x86_64 x86/run x86/hpet_read_test.flat -smp X
where X is desired (max) number of logical CPUs on host

it will 1st execute concurrent read benchmark
and after that it will run torture test enabling/disabling HPET counter,
while running readers in parallel. Goal is to verify counter that always
goes up.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
v2:
   * fix broken timer going backwards check
   * report # of fails
   * warn if number of vcpus is not sufficient for torture test and skip
     it
   * style fixups
---
 x86/Makefile.common  |  2 ++
 x86/hpet_read_test.c | 73 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)
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
index 00000000..a14194e6
--- /dev/null
+++ b/x86/hpet_read_test.c
@@ -0,0 +1,73 @@
+#include "libcflat.h"
+#include "smp.h"
+#include "asm/barrier.h"
+#include "x86/atomic.h"
+
+#define HPET_ADDR         0xFED00000L
+#define HPET_COUNTER_ADDR ((uint8_t *)HPET_ADDR + 0xF0UL)
+#define HPET_CONFIG_ADDR  ((uint8_t *)HPET_ADDR + 0x10UL)
+#define HPET_ENABLE_BIT   0x01UL
+#define HPET_CLK_PERIOD   10
+
+static atomic_t fail;
+
+static void hpet_reader(void *data)
+{
+	uint64_t old_counter = 0, new_counter;
+	long cycles = (long)data;
+
+	while (cycles--) {
+		new_counter = *(volatile uint64_t *)HPET_COUNTER_ADDR;
+		if (new_counter < old_counter) {
+			atomic_inc(&fail);
+		}
+		old_counter = new_counter;
+	}
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
+	uint64_t start, end, time_ns;
+
+	ncpus = cpu_count();
+	do {
+		printf("* starting concurrent read bench on %d cpus\n", ncpus);
+		*(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
+		start = *(volatile uint64_t *)HPET_COUNTER_ADDR;
+		on_cpus(hpet_reader, (void *)cycles);
+		end = (*(volatile uint64_t *)HPET_COUNTER_ADDR);
+		time_ns = (end - start) * HPET_CLK_PERIOD;
+		report(time_ns && !atomic_read(&fail),
+			"read test took %lu ms, avg read: %lu ns\n", time_ns/1000000,  time_ns/cycles);
+	} while (0);
+
+	do {
+		printf("* starting enable/disable with concurent readers torture\n");
+		if (ncpus > 2) {
+			for (i = 2; i < ncpus; i++)
+			    on_cpu_async(i, hpet_reader, (void *)cycles);
+
+			on_cpu(1, hpet_writer, (void *)cycles);
+			report(!atomic_read(&fail), "torture test, fails: %u\n", atomic_read(&fail));
+		} else {
+			printf("SKIP: torture test: '-smp X' should be greater than 2\n");
+	}
+	} while (0);
+
+	return report_summary();
+}
-- 
2.47.1


