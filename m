Return-Path: <kvm+bounces-48119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6FBAC95DA
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 20:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69C8617BEE8
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 18:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B1227BF95;
	Fri, 30 May 2025 18:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="knUKkQM4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DAF27A92F
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 18:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748631177; cv=none; b=oHEDHe3XXX7t+KxpfwL/h0qGJqwEOPJRLWeCZPSkUBmylkuc6v1GjZOLKv3dnkTYh+C94QmLJTiNTEvwTu8LaAVlZJb+avtr34TwpaSh44Tz5QSMZG32ekjh7rz0kJEO74SoeJwk61IoVGFZBwTgqwqOh2BBLyBUIw9285G2pkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748631177; c=relaxed/simple;
	bh=mhgEUlAtkWDdE5BIbN7qMPFDGIrHHNY/5plu1NKbztw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Si/oZWvGVvMEbahQMxt5r/7KCePzP/J7tnk/7CrJGEWOdSpfwJYY1yJ+ZN1NPd83hqHA8vZGNiiXMO2BdKVTLQ4HzPAymb/XewQcmkiQjpwYGxOWCubBaoOg0+ZLpYA5E9nwLTUKm8CRWfkRjLI0n0hk1zF/dPRYeVeACPQJrBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=knUKkQM4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c37558eccso1638841a12.1
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 11:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748631175; x=1749235975; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DM1PeXelXOrCQthfhESdwyT2BuwrcpH6F3C9kXkDTdw=;
        b=knUKkQM493mWtdIBtNYvDGiHbZXh94lPlQy9mucGuf6sJvG+mb47BCpaczP5kCn7Jr
         0bhRhXCxQ9HFfoERs9c8tVBB9fyIwKhxfulVmMqpyhUT6x+V5wn5LDuq0EsU9e/ziQ+j
         ZWR0+KCpeOIiQ9aNiEKCHCmz0nHbS4JarrBAmOMfTZmj+I+yUIwCbEM+I0zrVH1telKm
         zi5iyGJAHZ0tDgXZLEjfs6KdU2dxTC3d2rVnxMUM0g9QdwkYpWDhPwTjwBgZiH3syKKl
         TLWF38rIyqEqrKfkcjVGvo5iX9XD/Op+PCR48QYlZZO4tbo75sCZXTm/BYjL0F0s9GJQ
         +irg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748631175; x=1749235975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DM1PeXelXOrCQthfhESdwyT2BuwrcpH6F3C9kXkDTdw=;
        b=AL97qdHkkK8aGPXcViKFM1Aki8WMTtH2INAN8+fVF7Mxx7fWRKFAFOTWHfxatIlU1M
         LOYXF+o7KFdQDWIWkPqqFyW8WdzmWT9okhGrZA6BHkNOE0Mr1rRNunUqhLEe6etKRyF9
         D49jE+3NCPChdsrJaFdb4yg//CfNSTen0yAvHAilJ6hXxcxVVvMiCD0brYqQUNPIQEkK
         HgXmJ6Sny1i1KsmP6rcvtT3Zhxbc+F4gtOaZPvuZlyNMXpDPzuCfpasEZmc1o6BPKFVE
         xKhYLA0NlivMtMDFXOVqNqvcIT/73PwkREqrE3cYkCvFEfD0UOb8OEVd/tNIEvJdSaMK
         oQ8A==
X-Forwarded-Encrypted: i=1; AJvYcCXdlFpoEzFwoRX/ny0gr3y54EJQKKtIZmUbXrSIkOATD9FWj4xl4VI36sOgzTec35e8nLE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvQhpdnuBzaWwXLtLsL5/GNsgjB6qhyuQtH6ZuTT4Y6MqXBlGl
	Tq82UIm1kWQUCY7TQuIAV1ewGize//GxnpJvu+plBlCPMLOU4osU7t4nskGYCHybC8r5M+7/yDk
	nKWf1QCtRT4g4eQ==
X-Google-Smtp-Source: AGHT+IGJy575wE5okiwZRZEZxyJYX3DS6QneORxGJCc2vLIidcgnpO9oZlLrQP9p7hgo6MrAXFbbDzTbr2mhIQ==
X-Received: from pjbcz16.prod.google.com ([2002:a17:90a:d450:b0:311:c20d:676d])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3b90:b0:311:eb85:96df with SMTP id 98e67ed59e1d1-31241531935mr7475336a91.17.1748631174984;
 Fri, 30 May 2025 11:52:54 -0700 (PDT)
Date: Fri, 30 May 2025 11:52:25 -0700
In-Reply-To: <20250530185239.2335185-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250530185239.2335185-4-jmattson@google.com>
Subject: [PATCH v4 3/3] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
From: Jim Mattson <jmattson@google.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

For a VCPU thread pinned to a single LPU, verify that interleaved host
and guest reads of IA32_[AM]PERF return strictly increasing values when
APERFMPERF exiting is disabled.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +++
 .../selftests/kvm/x86/aperfmperf_test.c       | 132 ++++++++++++++++++
 4 files changed, 152 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 3e786080473d..8d42a3bd0dd8 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -131,6 +131,7 @@ TEST_GEN_PROGS_x86 += x86/amx_test
 TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
+TEST_GEN_PROGS_x86 += x86/aperfmperf_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 93013564428b..43a1bef10ec0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1158,4 +1158,6 @@ bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
 
 uint32_t guest_get_vcpuid(void);
 
+int pin_task_to_one_cpu(void);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5649cf2f40e8..b6c707ab92d7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -10,6 +10,7 @@
 #include "ucall_common.h"
 
 #include <assert.h>
+#include <pthread.h>
 #include <sched.h>
 #include <sys/mman.h>
 #include <sys/resource.h>
@@ -2321,3 +2322,19 @@ bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
 	pg = paddr >> vm->page_shift;
 	return sparsebit_is_set(region->protected_phy_pages, pg);
 }
+
+int pin_task_to_one_cpu(void)
+{
+	int cpu = sched_getcpu();
+	cpu_set_t cpuset;
+	int rc;
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(cpu, &cpuset);
+
+	rc = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
+	TEST_ASSERT(rc == 0, "%s: Can't set thread affinity", __func__);
+
+	return cpu;
+}
+
diff --git a/tools/testing/selftests/kvm/x86/aperfmperf_test.c b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
new file mode 100644
index 000000000000..64d976156693
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test for KVM_X86_DISABLE_EXITS_APERFMPERF
+ *
+ * Copyright (C) 2025, Google LLC.
+ *
+ * Test the ability to disable VM-exits for rdmsr of IA32_APERF and
+ * IA32_MPERF. When these VM-exits are disabled, reads of these MSRs
+ * return the host's values.
+ *
+ * Note: Requires read access to /dev/cpu/<lpu>/msr to read host MSRs.
+ */
+
+#include <fcntl.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <asm/msr-index.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define NUM_ITERATIONS 100
+
+static int open_dev_msr(int cpu)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "/dev/cpu/%d/msr", cpu);
+	return open_path_or_exit(path, O_RDONLY);
+}
+
+static uint64_t read_dev_msr(int msr_fd, uint32_t msr)
+{
+	uint64_t data;
+	ssize_t rc;
+
+	rc = pread(msr_fd, &data, sizeof(data), msr);
+	TEST_ASSERT(rc == sizeof(data), "Read of MSR 0x%x failed", msr);
+
+	return data;
+}
+
+static void guest_code(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_ITERATIONS; i++)
+		GUEST_SYNC2(rdmsr(MSR_IA32_APERF), rdmsr(MSR_IA32_MPERF));
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	uint64_t host_aperf_before, host_mperf_before;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int msr_fd;
+	int cpu;
+	int i;
+
+	cpu = pin_task_to_one_cpu();
+
+	msr_fd = open_dev_msr(cpu);
+
+	/*
+	 * This test requires a non-standard VM initialization, because
+	 * KVM_ENABLE_CAP cannot be used on a VM file descriptor after
+	 * a VCPU has been created.
+	 */
+	vm = vm_create(1);
+
+	TEST_REQUIRE(vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS) &
+		     KVM_X86_DISABLE_EXITS_APERFMPERF);
+
+	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
+		      KVM_X86_DISABLE_EXITS_APERFMPERF);
+
+	vcpu = vm_vcpu_add(vm, 0, guest_code);
+
+	host_aperf_before = read_dev_msr(msr_fd, MSR_IA32_APERF);
+	host_mperf_before = read_dev_msr(msr_fd, MSR_IA32_MPERF);
+
+	for (i = 0; i < NUM_ITERATIONS; i++) {
+		uint64_t host_aperf_after, host_mperf_after;
+		uint64_t guest_aperf, guest_mperf;
+		struct ucall uc;
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_DONE:
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		case UCALL_SYNC:
+			guest_aperf = uc.args[0];
+			guest_mperf = uc.args[1];
+
+			host_aperf_after = read_dev_msr(msr_fd, MSR_IA32_APERF);
+			host_mperf_after = read_dev_msr(msr_fd, MSR_IA32_MPERF);
+
+			TEST_ASSERT(host_aperf_before < guest_aperf,
+				    "APERF: host_before (0x%" PRIx64 ") >= guest (0x%" PRIx64 ")",
+				    host_aperf_before, guest_aperf);
+			TEST_ASSERT(guest_aperf < host_aperf_after,
+				    "APERF: guest (0x%" PRIx64 ") >= host_after (0x%" PRIx64 ")",
+				    guest_aperf, host_aperf_after);
+			TEST_ASSERT(host_mperf_before < guest_mperf,
+				    "MPERF: host_before (0x%" PRIx64 ") >= guest (0x%" PRIx64 ")",
+				    host_mperf_before, guest_mperf);
+			TEST_ASSERT(guest_mperf < host_mperf_after,
+				    "MPERF: guest (0x%" PRIx64 ") >= host_after (0x%" PRIx64 ")",
+				    guest_mperf, host_mperf_after);
+
+			host_aperf_before = host_aperf_after;
+			host_mperf_before = host_mperf_after;
+
+			break;
+		}
+	}
+
+	kvm_vm_free(vm);
+	close(msr_fd);
+
+	return 0;
+}
-- 
2.49.0.1204.g71687c7c1d-goog


