Return-Path: <kvm+bounces-41729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7CDCA6C5BE
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 23:17:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB9911B60483
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 22:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF8B233737;
	Fri, 21 Mar 2025 22:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7hDzANb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3177E1F03D9
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 22:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742595305; cv=none; b=LdGnq3sScOv364xc0WiaPDJjw1bq5MkolhOGgpaO+eA5OF+SWSA2hbjYP3tM2d52vHZG0QUawpHyripKQMV89DpgdwO9H22ypfP+cinBg8OsZYsozDXxd7nci9j8u9JPFhajp030qLxPvynJ9gz+lJQtbO66oap80/um3JZ21GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742595305; c=relaxed/simple;
	bh=HHDxIKcmzAzR/uoZwlg+nA4zaO6F0vAAN2EGrZqVmq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SPkMra/XZzOSITgrS7iykE/BJBY6kn14riUCBikXz/Eih6zX3OIOC5XzQevKvE3G0Kq36AMX66qgi0jedhBrZntZCB/p0dGnXhvkBvAQYbLg4kzUPzB4WGdytmJ0U2TKveJI713HzkkP9yw/IAAb29RPnL3453xg6Dk1ejTBuAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7hDzANb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff6af1e264so6752293a91.3
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 15:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742595303; x=1743200103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7kZHik3c6W9XM5SaTsdvyDWXohWRJFQwSa2CKHFFJM=;
        b=d7hDzANbt8arRezwhAyjK8osK91D8cp4EhUQOYICcoej0Kg1406ql+kHhIRls99Y0l
         hSOtO2Fo28V+ZgeN7WF1VYwNYUzruYYiMrgpwSuv/mv9qexrfRfE/Utzql1bxe031N2Q
         B/u/BdjCwzPwIpO1mAM4iteIn8sXaUe4fRGOB78cCaMrVrIinGpTP+yhVxa3rWmMVTeg
         T/gfLfNdatCOcdRljOveiwdlC811kjp/DI50+nzC8yU+kjZsaVrVLyUsKPtWC6GUPlCz
         x+/YL+xUqPmDZD9JNx57OW1i3fLfNCtCKWnWmOUeG3kPHU0D1kfCOSYpfeSBdhkGVcp3
         YTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742595303; x=1743200103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a7kZHik3c6W9XM5SaTsdvyDWXohWRJFQwSa2CKHFFJM=;
        b=Tm3oP6KLYOD9FSkVecQ+sMpm1MHbqbAE4yhhFWBZ1s1l1JZBdWQ3o3w6wLFFQE2r7K
         aSuepaVihdYO9xodtTxqaS+cHtA+1WG7RJKQ1DYW9sfZMzAbk8mULcVk0ewuPueNOa/M
         KgtdVGft8Xm/+PMBXwjz3vQhppICV9LMz3qjT9P1seeO1foxXnku6P3FdHCHHBEx6E1R
         5pLbmxn4ELyR2piSX4hC/bwhHuUUJpxWUJvibwmFr5DBUVF1Julkqrtnb4/lH9misZNd
         N4A2oAL3Ju1zSxzH1q/tIVuLeSXiUE1zKBECMjjzdFMG4bIDN2YpeTUVXeqFA42CSxS8
         QMdA==
X-Forwarded-Encrypted: i=1; AJvYcCUssi9SmW6nmsAvS35IMOZpDZpMaJcbWPikSwlqkM25pRmc82AIDInFO1iStt6pI5bkNcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYyXPfST66SW9Qwz+fyKZ6XpCcfCnkGWHMdcaxUdCNfELHAzyy
	s8Fooc1Sylqvqa78Ffagbirmb6RTVrm/IaSCS1/tqH4bdVOLm3q35QATiyBLmXEe0AbX/8dmGcm
	qD+UQFqNoDg==
X-Google-Smtp-Source: AGHT+IHAc9WV/hu5vKfs/Lqpx+fbzF9gJxAd87TudVOtNb5Cf1wOb+Y1LfEdkDtW4JdH2YOfbBHbULWFoamBnA==
X-Received: from pjbsc2.prod.google.com ([2002:a17:90b:5102:b0:2ff:611c:bae8])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a44:b0:2f4:4003:f3d4 with SMTP id 98e67ed59e1d1-3030ff08e4amr6660559a91.30.1742595303545;
 Fri, 21 Mar 2025 15:15:03 -0700 (PDT)
Date: Fri, 21 Mar 2025 15:14:31 -0700
In-Reply-To: <20250321221444.2449974-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250321221444.2449974-1-jmattson@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250321221444.2449974-3-jmattson@google.com>
Subject: [PATCH v3 2/2] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
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
 .../selftests/kvm/x86/aperfmperf_test.c       | 162 ++++++++++++++++++
 2 files changed, 163 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4277b983cace..bfee69b33310 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -116,6 +116,7 @@ TEST_GEN_PROGS_x86 += x86/amx_test
 TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
+TEST_GEN_PROGS_x86 += x86/aperfmperf_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/x86/aperfmperf_test.c b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
new file mode 100644
index 000000000000..7473afb7f6fa
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
@@ -0,0 +1,162 @@
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
+#include <pthread.h>
+#include <sched.h>
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
+static void pin_thread(int cpu)
+{
+	cpu_set_t cpuset;
+	int rc;
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(cpu, &cpuset);
+
+	rc = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
+	TEST_ASSERT(rc == 0, "%s: Can't set thread affinity", __func__);
+}
+
+static int open_dev_msr(int cpu)
+{
+	char path[PATH_MAX];
+	int msr_fd;
+
+	snprintf(path, sizeof(path), "/dev/cpu/%d/msr", cpu);
+	msr_fd = open(path, O_RDONLY);
+	__TEST_REQUIRE(msr_fd >= 0, "Can't open %s for read", path);
+
+	return msr_fd;
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
+	for (i = 0; i < NUM_ITERATIONS; i++) {
+		uint64_t aperf = rdmsr(MSR_IA32_APERF);
+		uint64_t mperf = rdmsr(MSR_IA32_MPERF);
+
+		GUEST_SYNC2(aperf, mperf);
+	}
+
+	GUEST_DONE();
+}
+
+static bool kvm_can_disable_aperfmperf_exits(struct kvm_vm *vm)
+{
+	int flags = vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS);
+
+	return flags & KVM_X86_DISABLE_EXITS_APERFMPERF;
+}
+
+int main(int argc, char *argv[])
+{
+	uint64_t host_aperf_before, host_mperf_before;
+	int cpu = sched_getcpu();
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int msr_fd;
+	int i;
+
+	pin_thread(cpu);
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
+	TEST_REQUIRE(kvm_can_disable_aperfmperf_exits(vm));
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
+				    "APERF: host_before (%lu) >= guest (%lu)",
+				    host_aperf_before, guest_aperf);
+			TEST_ASSERT(guest_aperf < host_aperf_after,
+				    "APERF: guest (%lu) >= host_after (%lu)",
+				    guest_aperf, host_aperf_after);
+			TEST_ASSERT(host_mperf_before < guest_mperf,
+				    "MPERF: host_before (%lu) >= guest (%lu)",
+				    host_mperf_before, guest_mperf);
+			TEST_ASSERT(guest_mperf < host_mperf_after,
+				    "MPERF: guest (%lu) >= host_after (%lu)",
+				    guest_mperf, host_mperf_after);
+
+			host_aperf_before = host_aperf_after;
+			host_mperf_before = host_mperf_after;
+
+			break;
+		}
+	}
+
+	TEST_ASSERT_EQ(i, NUM_ITERATIONS);
+
+	kvm_vm_free(vm);
+	close(msr_fd);
+
+	return 0;
+}
-- 
2.49.0.395.g12beb8f557-goog


