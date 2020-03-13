Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B066B184BD3
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 16:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCMP5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 11:57:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45213 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726406AbgCMP5E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 11:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584115022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SwGD4cUDubbzoAg824KAcSz4xiQKVW2otRnFzO/Scqk=;
        b=dDsYrff1UJnRErwyu25Tubs70QBQKsU+pI+vFEPecvdCdvZ/nINDAlhbgQjT2wN5E+ZSZ0
        WcD/TCnuv7cdExrYjo9jNZ5bG8njpQWmetk73d0LMADMLsQLWl8EA7JNUCTzU+S85FByBH
        ufqC/dIeqoKB/Uhr3EfveEppEXSMYqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-LptqPYu6PKSEOZqSRp2oKA-1; Fri, 13 Mar 2020 11:56:58 -0400
X-MC-Unique: LptqPYu6PKSEOZqSRp2oKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E054B100550D
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 15:56:57 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54BC89496D;
        Fri, 13 Mar 2020 15:56:54 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/2] KVM: selftests: Introduce steal-time test
Date:   Fri, 13 Mar 2020 16:56:44 +0100
Message-Id: <20200313155644.29779-3-drjones@redhat.com>
In-Reply-To: <20200313155644.29779-1-drjones@redhat.com>
References: <20200313155644.29779-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The steal-time test confirms what is reported to the guest as stolen
time is consistent with the run_delay reported for the VCPU thread
on the host. Both x86_64 and AArch64 have the concept of steal/stolen
time so this test is introduced for both architectures.

While adding the test we ensure .gitignore has all tests listed
(it was missing s390x/resets) and that the Makefile has all tests
listed in alphabetical order (not really necessary, but it almost
was already...). We also extend the common API with a new num-guest-
pages call and a new timespec call.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   2 +
 tools/testing/selftests/kvm/Makefile          |  12 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 .../testing/selftests/kvm/include/test_util.h |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   7 +
 tools/testing/selftests/kvm/lib/test_util.c   |  15 +
 tools/testing/selftests/kvm/steal_time.c      | 352 ++++++++++++++++++
 7 files changed, 385 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/steal_time.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selft=
ests/kvm/.gitignore
index 8bc104d39e78..16877c3daabf 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,4 +1,5 @@
 /s390x/memop
+/s390x/resets
 /s390x/sync_regs_test
 /x86_64/cr4_cpuid_sync_test
 /x86_64/evmcs_test
@@ -20,3 +21,4 @@
 /demand_paging_test
 /dirty_log_test
 /kvm_create_max_vcpus
+/steal_time
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
index a871184ebb6d..712a2ddd2a27 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -21,28 +21,30 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/set_memory_region_t=
est
 TEST_GEN_PROGS_x86_64 +=3D x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/smm_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/state_test
+TEST_GEN_PROGS_x86_64 +=3D x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/xss_msr_test
-TEST_GEN_PROGS_x86_64 +=3D x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 +=3D clear_dirty_log_test
-TEST_GEN_PROGS_x86_64 +=3D dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D demand_paging_test
+TEST_GEN_PROGS_x86_64 +=3D dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D kvm_create_max_vcpus
+TEST_GEN_PROGS_x86_64 +=3D steal_time
=20
 TEST_GEN_PROGS_aarch64 +=3D clear_dirty_log_test
-TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
 TEST_GEN_PROGS_aarch64 +=3D demand_paging_test
+TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
 TEST_GEN_PROGS_aarch64 +=3D kvm_create_max_vcpus
+TEST_GEN_PROGS_aarch64 +=3D steal_time
=20
 TEST_GEN_PROGS_s390x =3D s390x/memop
-TEST_GEN_PROGS_s390x +=3D s390x/sync_regs_test
 TEST_GEN_PROGS_s390x +=3D s390x/resets
-TEST_GEN_PROGS_s390x +=3D dirty_log_test
+TEST_GEN_PROGS_s390x +=3D s390x/sync_regs_test
 TEST_GEN_PROGS_s390x +=3D demand_paging_test
+TEST_GEN_PROGS_s390x +=3D dirty_log_test
 TEST_GEN_PROGS_s390x +=3D kvm_create_max_vcpus
=20
 TEST_GEN_PROGS +=3D $(TEST_GEN_PROGS_$(UNAME_M))
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index 3aa4d1e52284..a99b875f50d2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -255,6 +255,7 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned int vm_get_max_gfn(struct kvm_vm *vm);
=20
+unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t siz=
e);
 unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num=
_guest_pages);
 unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int nu=
m_host_pages);
 static inline unsigned int
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
index 1e1487a30402..f556ec5fe47b 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -59,5 +59,6 @@ size_t parse_size(const char *size);
=20
 int64_t timespec_to_ns(struct timespec ts);
 struct timespec timespec_diff(struct timespec start, struct timespec end=
);
+struct timespec timespec_add_ns(struct timespec ts, int64_t ns);
=20
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index e26917ba25bc..35bd42370c21 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1769,3 +1769,10 @@ vm_num_guest_pages(enum vm_guest_mode mode, unsign=
ed int num_host_pages)
 	return vm_calc_num_pages(num_host_pages, getpageshift(),
 				 vm_guest_mode_params[mode].page_shift, false);
 }
+
+unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t siz=
e)
+{
+	unsigned int n;
+	n =3D DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
+	return vm_adjust_num_guest_pages(mode, n);
+}
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
index 26fb3d73dc74..ee12c4b9ae05 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -71,6 +71,21 @@ struct timespec timespec_diff(struct timespec start, s=
truct timespec end)
 	return temp;
 }
=20
+struct timespec timespec_add_ns(struct timespec ts, int64_t ns)
+{
+	struct timespec res;
+
+	res.tv_sec =3D ts.tv_sec;
+	res.tv_nsec =3D ts.tv_nsec + ns;
+
+	if (res.tv_nsec > 1000000000UL) {
+		res.tv_sec +=3D 1;
+		res.tv_nsec -=3D 1000000000UL;
+	}
+
+	return res;
+}
+
 void print_skip(const char *fmt, ...)
 {
 	va_list ap;
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/sel=
ftests/kvm/steal_time.c
new file mode 100644
index 000000000000..f976ac5e896a
--- /dev/null
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -0,0 +1,352 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * steal/stolen time test
+ *
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <time.h>
+#include <sched.h>
+#include <pthread.h>
+#include <linux/kernel.h>
+#include <sys/syscall.h>
+#include <asm/kvm.h>
+#include <asm/kvm_para.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define NR_VCPUS		4
+#define ST_GPA_BASE		(1 << 30)
+#define MIN_RUN_DELAY_NS	200000UL
+
+static void *st_gva[NR_VCPUS];
+static uint64_t guest_stolen_time[NR_VCPUS];
+
+#if defined(__x86_64__)
+
+/* steal_time must have 64-byte alignment */
+#define STEAL_TIME_SIZE		((sizeof(struct kvm_steal_time) + 63) & ~63)
+
+static void check_status(struct kvm_steal_time *st)
+{
+	GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
+	GUEST_ASSERT(READ_ONCE(st->flags) =3D=3D 0);
+	GUEST_ASSERT(READ_ONCE(st->preempted) =3D=3D 0);
+}
+
+static void guest_code(int cpu)
+{
+	struct kvm_steal_time *st =3D st_gva[cpu];
+	uint32_t version;
+
+	GUEST_ASSERT(rdmsr(MSR_KVM_STEAL_TIME) =3D=3D ((uint64_t)st_gva[cpu] | =
KVM_MSR_ENABLED));
+
+	memset(st, 0, sizeof(*st));
+	GUEST_SYNC(0);
+
+	check_status(st);
+	WRITE_ONCE(guest_stolen_time[cpu], st->steal);
+	version =3D READ_ONCE(st->version);
+	check_status(st);
+	GUEST_SYNC(1);
+
+	check_status(st);
+	GUEST_ASSERT(version < READ_ONCE(st->version));
+	WRITE_ONCE(guest_stolen_time[cpu], st->steal);
+	check_status(st);
+	GUEST_DONE();
+}
+
+static void steal_time_init(struct kvm_vm *vm)
+{
+	int i;
+
+	if (!(kvm_get_supported_cpuid_entry(KVM_CPUID_FEATURES)->eax &
+	      KVM_FEATURE_STEAL_TIME)) {
+		print_skip("steal-time not supported");
+		exit(KSFT_SKIP);
+	}
+
+	for (i =3D 0; i < NR_VCPUS; ++i) {
+		int ret;
+
+		vcpu_set_cpuid(vm, i, kvm_get_supported_cpuid());
+
+		/* ST_GPA_BASE is identity mapped */
+		st_gva[i] =3D (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
+		sync_global_to_guest(vm, st_gva[i]);
+
+		ret =3D _vcpu_set_msr(vm, i, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KV=
M_STEAL_RESERVED_MASK);
+		TEST_ASSERT(ret =3D=3D 0, "Bad GPA didn't fail");
+
+		vcpu_set_msr(vm, i, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KVM_MSR_ENA=
BLED);
+	}
+}
+
+static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct kvm_steal_time *st =3D addr_gva2hva(vm, (ulong)st_gva[vcpuid]);
+	int i;
+
+	pr_info("VCPU%d:\n", vcpuid);
+	pr_info("    steal:     %lld\n", st->steal);
+	pr_info("    version:   %d\n", st->version);
+	pr_info("    flags:     %d\n", st->flags);
+	pr_info("    preempted: %d\n", st->preempted);
+	pr_info("    u8_pad:    ");
+	for (i =3D 0; i < 3; ++i)
+		pr_info("%d", st->u8_pad[i]);
+	pr_info("\n    pad:       ");
+	for (i =3D 0; i < 11; ++i)
+		pr_info("%d", st->pad[i]);
+	pr_info("\n");
+}
+
+#elif defined(__aarch64__)
+
+/* PV_TIME_ST must have 64-byte alignment */
+#define STEAL_TIME_SIZE		((sizeof(struct st_time) + 63) & ~63)
+
+#define SMCCC_ARCH_FEATURES	0x80000001
+#define PV_TIME_FEATURES	0xc5000020
+#define PV_TIME_ST		0xc5000021
+
+struct st_time {
+	uint32_t rev;
+	uint32_t attr;
+	uint64_t st_time;
+};
+
+static int64_t smccc(uint32_t func, uint32_t arg)
+{
+	unsigned long ret;
+
+	asm volatile(
+		"mov	x0, %1\n"
+		"mov	x1, %2\n"
+		"hvc	#0\n"
+		"mov	%0, x0\n"
+	: "=3Dr" (ret) : "r" (func), "r" (arg) :
+	  "x0", "x1", "x2", "x3");
+
+	return ret;
+}
+
+static void check_status(struct st_time *st)
+{
+	GUEST_ASSERT(READ_ONCE(st->rev) =3D=3D 0);
+	GUEST_ASSERT(READ_ONCE(st->attr) =3D=3D 0);
+}
+
+static void guest_code(int cpu)
+{
+	struct st_time *st;
+	int64_t status;
+
+	status =3D smccc(SMCCC_ARCH_FEATURES, PV_TIME_FEATURES);
+	GUEST_ASSERT(status =3D=3D 0);
+	status =3D smccc(PV_TIME_FEATURES, PV_TIME_FEATURES);
+	GUEST_ASSERT(status =3D=3D 0);
+	status =3D smccc(PV_TIME_FEATURES, PV_TIME_ST);
+	GUEST_ASSERT(status =3D=3D 0);
+
+	status =3D smccc(PV_TIME_ST, 0);
+	GUEST_ASSERT(status !=3D -1);
+	GUEST_ASSERT(status =3D=3D (ulong)st_gva[cpu]);
+
+	st =3D (struct st_time *)status;
+	GUEST_SYNC(0);
+
+	check_status(st);
+	WRITE_ONCE(guest_stolen_time[cpu], st->st_time);
+	GUEST_SYNC(1);
+
+	check_status(st);
+	WRITE_ONCE(guest_stolen_time[cpu], st->st_time);
+	GUEST_DONE();
+}
+
+static void steal_time_init(struct kvm_vm *vm)
+{
+	struct kvm_device_attr dev =3D {
+		.group =3D KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr =3D KVM_ARM_VCPU_PVTIME_IPA,
+	};
+	int i, ret;
+
+	ret =3D _vcpu_ioctl(vm, 0, KVM_HAS_DEVICE_ATTR, &dev);
+	if (ret !=3D 0 && errno =3D=3D ENXIO) {
+		print_skip("steal-time not supported");
+		exit(KSFT_SKIP);
+	}
+
+	for (i =3D 0; i < NR_VCPUS; ++i) {
+		uint64_t st_ipa;
+
+		vcpu_ioctl(vm, i, KVM_HAS_DEVICE_ATTR, &dev);
+
+		dev.addr =3D (uint64_t)&st_ipa;
+
+		/* ST_GPA_BASE is identity mapped */
+		st_gva[i] =3D (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
+		sync_global_to_guest(vm, st_gva[i]);
+
+		st_ipa =3D (ulong)st_gva[i] | 1;
+		ret =3D _vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
+		TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EINVAL, "Bad IPA didn't repo=
rt EINVAL");
+
+		st_ipa =3D (ulong)st_gva[i];
+		vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
+
+		ret =3D _vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
+		TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EEXIST, "Set IPA twice witho=
ut EEXIST");
+
+	}
+}
+
+static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct st_time *st =3D addr_gva2hva(vm, (ulong)st_gva[vcpuid]);
+
+	pr_info("VCPU%d:\n", vcpuid);
+	pr_info("    rev:     %d\n", st->rev);
+	pr_info("    attr:    %d\n", st->attr);
+	pr_info("    st_time: %ld\n", st->st_time);
+}
+
+#endif
+
+static long get_run_delay(void)
+{
+	char path[64];
+	long val[2];
+	FILE *fp;
+
+	sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
+	fp =3D fopen(path, "r");
+	fscanf(fp, "%ld %ld ", &val[0], &val[1]);
+	fclose(fp);
+
+	return val[1];
+}
+
+static void *do_steal_time(void *arg)
+{
+	struct timespec ts, stop;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	stop =3D timespec_add_ns(ts, MIN_RUN_DELAY_NS);
+
+	while (1) {
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+		if (ts.tv_sec > stop.tv_sec || ts.tv_nsec >=3D stop.tv_nsec)
+			break;
+	}
+
+	return NULL;
+}
+
+static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct ucall uc;
+
+	vcpu_args_set(vm, vcpuid, 1, vcpuid);
+
+	vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
+
+	switch (get_ucall(vm, vcpuid, &uc)) {
+	case UCALL_SYNC:
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
+			    __FILE__, uc.args[1]);
+	default:
+		TEST_ASSERT(false, "Unexpected exit: %s",
+			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+	}
+}
+
+int main(int ac, char **av)
+{
+	struct kvm_vm *vm;
+	pthread_attr_t attr;
+	pthread_t thread;
+	cpu_set_t cpuset;
+	unsigned int gpages;
+	long stolen_time;
+	long run_delay;
+	bool verbose;
+	int i;
+
+	verbose =3D ac > 1 && (!strncmp(av[1], "-v", 3) || !strncmp(av[1], "--v=
erbose", 10));
+
+	/* Set CPU affinity so we can force preemption of the VCPU */
+	CPU_ZERO(&cpuset);
+	CPU_SET(0, &cpuset);
+	pthread_attr_init(&attr);
+	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpuset);
+	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
+
+	/* Create a one VCPU guest and an identity mapped memslot for the steal=
 time structure */
+	vm =3D vm_create_default(0, 0, guest_code);
+	gpages =3D vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * N=
R_VCPUS);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, g=
pages, 0);
+	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages, 0);
+	ucall_init(vm, NULL);
+
+	/* Add the rest of the VCPUs */
+	for (i =3D 1; i < NR_VCPUS; ++i)
+		vm_vcpu_add_default(vm, i, guest_code);
+
+	steal_time_init(vm);
+
+	/* Run test on each VCPU */
+	for (i =3D 0; i < NR_VCPUS; ++i) {
+		/* First VCPU run initializes steal-time */
+		run_vcpu(vm, i);
+
+		/* Second VCPU run, expect guest stolen time to be <=3D run_delay */
+		run_vcpu(vm, i);
+		sync_global_from_guest(vm, guest_stolen_time[i]);
+		stolen_time =3D guest_stolen_time[i];
+		run_delay =3D get_run_delay();
+		TEST_ASSERT(stolen_time <=3D run_delay,
+			    "Expected stolen time <=3D %ld, got %ld",
+			    run_delay, stolen_time);
+
+		/* Steal time from the VCPU. The steal time thread has the same CPU af=
finity as the VCPUs. */
+		run_delay =3D get_run_delay();
+		pthread_create(&thread, &attr, do_steal_time, NULL);
+		do
+			pthread_yield();
+		while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS);
+		pthread_join(thread, NULL);
+		run_delay =3D get_run_delay() - run_delay;
+		TEST_ASSERT(run_delay >=3D MIN_RUN_DELAY_NS,
+			    "Expected run_delay >=3D %ld, got %ld",
+			    MIN_RUN_DELAY_NS, run_delay);
+
+		/* Run VCPU again to confirm stolen time is consistent with run_delay =
*/
+		run_vcpu(vm, i);
+		sync_global_from_guest(vm, guest_stolen_time[i]);
+		stolen_time =3D guest_stolen_time[i] - stolen_time;
+		TEST_ASSERT(stolen_time >=3D run_delay,
+			    "Expected stolen time >=3D %ld, got %ld",
+			    run_delay, stolen_time);
+
+		if (verbose) {
+			pr_info("VCPU%d: total-stolen-time=3D%ld test-stolen-time=3D%ld", i,
+				guest_stolen_time[i], stolen_time);
+			if (stolen_time =3D=3D run_delay)
+				pr_info(" (BONUS: guest test-stolen-time even exactly matches test-r=
un_delay)");
+			pr_info("\n");
+			steal_time_dump(vm, i);
+		}
+	}
+
+	return 0;
+}
--=20
2.21.1

