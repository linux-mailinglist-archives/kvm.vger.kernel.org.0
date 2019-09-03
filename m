Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0541DA6375
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 10:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbfICID4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 04:03:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbfICIDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 04:03:55 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A129106E28C;
        Tue,  3 Sep 2019 08:03:54 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37E9B60BE0;
        Tue,  3 Sep 2019 08:03:51 +0000 (UTC)
Date:   Tue, 3 Sep 2019 10:03:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/10] arm64: Stolen time support
Message-ID: <20190903080348.5whavgrjki7zrtmd@kamzik.brq.redhat.com>
References: <20190830084255.55113-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830084255.55113-1-steven.price@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 03 Sep 2019 08:03:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 09:42:45AM +0100, Steven Price wrote:
> This series add support for paravirtualized time for arm64 guests and
> KVM hosts following the specification in Arm's document DEN 0057A:
> 
> https://developer.arm.com/docs/den0057/a
> 
> It implements support for stolen time, allowing the guest to
> identify time when it is forcibly not executing.
> 
> It doesn't implement support for Live Physical Time (LPT) as there are
> some concerns about the overheads and approach in the above
> specification, and I expect an updated version of the specification to
> be released soon with just the stolen time parts.
> 
> NOTE: Patches 8 and 9 will conflict with Mark Rutland's series[1] cleaning
> up the SMCCC conduit. I do feel that the addition of an _invoke() call
> makes a number of call sites cleaner and it should be possible to
> integrate both this and Mark's other cleanups.
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20190809132245.43505-1-mark.rutland@arm.com/
> 
> Also available as a git tree:
> git://linux-arm.org/linux-sp.git stolen_time/v4
> 
> Changes from v3:
> https://lore.kernel.org/lkml/20190821153656.33429-1-steven.price@arm.com/
>  * There's no longer a PV_TIME device, instead there are attributes on
>    the VCPU. This allows the stolen time structures to be places
>    arbitrarily by user space (subject to 64 byte alignment).
>  * Split documentation between information on the hypercalls and the
>    attributes on the VCPU
>  * Fixed the type of SMCCC functions to return long not int
> 
> Changes from v2:
> https://lore.kernel.org/lkml/20190819140436.12207-1-steven.price@arm.com/
>  * Switched from using gfn_to_hva_cache to a new macro kvm_put_guest()
>    that can provide the single-copy atomicity required (on arm64). This
>    macro is added in patch 4.
>  * Tidied up the locking for kvm_update_stolen_time().
>    pagefault_disable() was unnecessary and the caller didn't need to
>    take kvm->srcu as the function does it itself.
>  * Removed struct kvm_arch_pvtime from the arm implementation, replaced
>    instead with inline static functions which are empty for arm.
>  * Fixed a few checkpatch --strict warnings.
> 
> Changes from v1:
> https://lore.kernel.org/lkml/20190802145017.42543-1-steven.price@arm.com/
>  * Host kernel no longer allocates the stolen time structure, instead it
>    is allocated by user space. This means the save/restore functionality
>    can be removed.
>  * Refactored the code so arm has stub implementations and to avoid
>    initcall
>  * Rebased to pick up Documentation/{virt->virtual} change
>  * Bunch of typo fixes
> 
> Christoffer Dall (1):
>   KVM: arm/arm64: Factor out hypercall handling from PSCI code
> 
> Steven Price (9):
>   KVM: arm64: Document PV-time interface
>   KVM: arm64: Implement PV_FEATURES call
>   KVM: Implement kvm_put_guest()
>   KVM: arm64: Support stolen time reporting via shared structure
>   KVM: Allow kvm_device_ops to be const
>   KVM: arm64: Provide VCPU attributes for stolen time
>   arm/arm64: Provide a wrapper for SMCCC 1.1 calls
>   arm/arm64: Make use of the SMCCC 1.1 wrapper
>   arm64: Retrieve stolen time as paravirtualized guest
> 
>  Documentation/virt/kvm/arm/pvtime.txt   |  64 ++++++++++
>  Documentation/virt/kvm/devices/vcpu.txt |  14 +++
>  arch/arm/include/asm/kvm_host.h         |  26 +++++
>  arch/arm/kvm/Makefile                   |   2 +-
>  arch/arm/kvm/handle_exit.c              |   2 +-
>  arch/arm/mm/proc-v7-bugs.c              |  13 +--
>  arch/arm64/include/asm/kvm_host.h       |  30 ++++-
>  arch/arm64/include/asm/paravirt.h       |   9 +-
>  arch/arm64/include/asm/pvclock-abi.h    |  17 +++
>  arch/arm64/include/uapi/asm/kvm.h       |   2 +
>  arch/arm64/kernel/cpu_errata.c          |  80 +++++--------
>  arch/arm64/kernel/paravirt.c            | 148 ++++++++++++++++++++++++
>  arch/arm64/kernel/time.c                |   3 +
>  arch/arm64/kvm/Kconfig                  |   1 +
>  arch/arm64/kvm/Makefile                 |   2 +
>  arch/arm64/kvm/guest.c                  |   9 ++
>  arch/arm64/kvm/handle_exit.c            |   4 +-
>  include/kvm/arm_hypercalls.h            |  43 +++++++
>  include/kvm/arm_psci.h                  |   2 +-
>  include/linux/arm-smccc.h               |  58 ++++++++++
>  include/linux/cpuhotplug.h              |   1 +
>  include/linux/kvm_host.h                |  26 ++++-
>  include/linux/kvm_types.h               |   2 +
>  include/uapi/linux/kvm.h                |   2 +
>  virt/kvm/arm/arm.c                      |  11 ++
>  virt/kvm/arm/hypercalls.c               |  68 +++++++++++
>  virt/kvm/arm/psci.c                     |  84 +-------------
>  virt/kvm/arm/pvtime.c                   | 124 ++++++++++++++++++++
>  virt/kvm/kvm_main.c                     |   6 +-
>  29 files changed, 699 insertions(+), 154 deletions(-)
>  create mode 100644 Documentation/virt/kvm/arm/pvtime.txt
>  create mode 100644 arch/arm64/include/asm/pvclock-abi.h
>  create mode 100644 include/kvm/arm_hypercalls.h
>  create mode 100644 virt/kvm/arm/hypercalls.c
>  create mode 100644 virt/kvm/arm/pvtime.c
> 
> -- 
> 2.20.1
>

Hi Steven,

I had some fun testing this series with the KVM selftests framework. It
looks like it works to me, so you may add

Tested-by: Andrew Jones <drjones@redhat.com>

if you like. And below is the test I came up with.

Thanks,
drew


From: Andrew Jones <drjones@redhat.com>
Date: Tue, 3 Sep 2019 03:45:08 -0400
Subject: [PATCH] selftests: kvm: aarch64 stolen-time test

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/stolen-time.c       | 208 ++++++++++++++++++
 2 files changed, 209 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/stolen-time.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ba7849751989..3151264039ad 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -28,6 +28,7 @@ TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 
+TEST_GEN_PROGS_aarch64 += aarch64/stolen-time
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/aarch64/stolen-time.c b/tools/testing/selftests/kvm/aarch64/stolen-time.c
new file mode 100644
index 000000000000..36df2f6baa17
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/stolen-time.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AArch64 PV stolen time test
+ *
+ * Copyright (C) 2019, Red Hat, Inc.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <time.h>
+#include <sched.h>
+#include <pthread.h>
+#include <sys/syscall.h>
+#include "kvm_util.h"
+
+#define ST_IPA_BASE		(1 << 30)
+#define MIN_STOLEN_TIME		200000
+
+struct st_time {
+	uint32_t rev;
+	uint32_t attr;
+	uint64_t st_time;
+};
+
+static uint64_t st_ipa_offset[4];
+static uint64_t guest_stolen_time[4];
+
+static void guest_code(void)
+{
+	struct st_time *st_time;
+	uint64_t cpu;
+	int64_t ipa;
+	int32_t ret;
+
+	asm volatile("mrs %0, mpidr_el1" : "=r" (cpu));
+	cpu &= 0x3;
+
+	asm volatile(
+		"mov	x0, %1\n"
+		"mov	x1, %2\n"
+		"hvc	#0\n"
+		"mov	%0, x0\n"
+	: "=r" (ret) : "r" (0x80000001), "r" (0xc5000020) :
+	  "x0", "x1", "x2", "x3");
+
+	GUEST_ASSERT(ret == 0);
+
+	asm volatile(
+		"mov	x0, %1\n"
+		"mov	x1, %2\n"
+		"hvc	#0\n"
+		"mov	%0, x0\n"
+	: "=r" (ret) : "r" (0xc5000020), "r" (0xc5000022) :
+	  "x0", "x1", "x2", "x3");
+
+	GUEST_ASSERT(ret == 0);
+
+	asm volatile(
+		"mov	x0, %1\n"
+		"hvc	#0\n"
+		"mov	%0, x0\n"
+	: "=r" (ipa) : "r" (0xc5000022) :
+	  "x0", "x1", "x2", "x3");
+
+	GUEST_ASSERT(ipa == ST_IPA_BASE + st_ipa_offset[cpu]);
+
+	st_time = (struct st_time *)ipa;
+	GUEST_ASSERT(st_time->rev == 0);
+	GUEST_ASSERT(st_time->attr == 0);
+
+	guest_stolen_time[cpu] = st_time->st_time;
+	GUEST_SYNC(0);
+
+	guest_stolen_time[cpu] = st_time->st_time;
+	GUEST_DONE();
+}
+
+static long get_run_delay(void)
+{
+	char path[64];
+	long val[2];
+	FILE *fp;
+
+	sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
+	fp = fopen(path, "r");
+	fscanf(fp, "%ld %ld ", &val[0], &val[1]);
+	fclose(fp);
+
+	return val[1];
+}
+
+static void *steal_time(void *arg)
+{
+	uint64_t nsecs_per_sec = 1000000000ul;
+	uint64_t sec, nsec;
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	sec = ts.tv_sec;
+	nsec = ts.tv_nsec + MIN_STOLEN_TIME;
+	if (nsec > nsecs_per_sec) {
+		sec += 1;
+		nsec -= nsecs_per_sec;
+	}
+
+	while (1) {
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+		if (ts.tv_sec > sec || (ts.tv_sec == sec && ts.tv_nsec >= nsec))
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
+	vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
+
+	switch (get_ucall(vm, vcpuid, &uc)) {
+	case UCALL_SYNC:
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
+			    __FILE__, uc.args[1]);
+	default:
+		TEST_ASSERT(false, "Unexpected exit: %s",
+			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+	}
+}
+
+int main(int ac, char **av)
+{
+	struct kvm_device_attr dev = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_SET_IPA,
+	};
+	uint64_t pvtime_memslot_size;
+	struct kvm_vm *vm;
+	pthread_attr_t attr;
+	pthread_t thread;
+	cpu_set_t cpuset;
+	long stolen_time;
+	int i;
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(0, &cpuset);
+	pthread_attr_init(&attr);
+	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpuset);
+	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
+
+	pvtime_memslot_size = 64 * 1024; /* one maximum-sized host page */
+
+	/* create a one-vcpu guest and the pvtime memslot */
+	vm = vm_create_default(0, 0, guest_code);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_IPA_BASE, 1,
+				    16 /* vm uses 4k pages */, 0);
+	virt_map(vm, ST_IPA_BASE, ST_IPA_BASE, pvtime_memslot_size, 0);
+	ucall_init(vm, UCALL_MMIO, NULL);
+
+	/* add 3 more vcpus */
+	for (i = 1; i < 4; ++i) {
+		vm_vcpu_add_default(vm, i, guest_code);
+		st_ipa_offset[i] = i * 64;
+		sync_global_to_guest(vm, st_ipa_offset[i]);
+	}
+
+	/* add pvtime to each vcpu */
+	for (i = 0; i < 4; ++i) {
+		uint64_t st_ipa = ST_IPA_BASE + st_ipa_offset[i];
+		dev.addr = (uint64_t)&st_ipa;
+		vcpu_ioctl(vm, i, KVM_HAS_DEVICE_ATTR, &dev);
+		vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
+	}
+
+	/* run the tests on each vcpu */
+	for (i = 0; i < 4; ++i) {
+		/* first vcpu run */
+		run_vcpu(vm, i);
+		sync_global_from_guest(vm, guest_stolen_time[i]);
+		TEST_ASSERT(guest_stolen_time[i] == 0, "Expected stolen_time = 0");
+
+		/* steal time from the vcpu */
+		stolen_time = get_run_delay();
+		pthread_create(&thread, &attr, steal_time, NULL);
+		pthread_yield();
+		pthread_join(thread, NULL);
+		stolen_time = get_run_delay() - stolen_time;
+		TEST_ASSERT(stolen_time >= MIN_STOLEN_TIME,
+			    "Expected stolen time >= %ld, got %ld",
+			    MIN_STOLEN_TIME, stolen_time);
+
+		/* run vcpu again and check the stolen time */
+		run_vcpu(vm, i);
+		sync_global_from_guest(vm, guest_stolen_time[i]);
+		TEST_ASSERT(guest_stolen_time[i] >= stolen_time,
+			    "Expected stolen_time >= %ld, got %ld",
+			    stolen_time, guest_stolen_time[i]);
+
+		printf("CPU%d: %ld", i, guest_stolen_time[i]);
+		if (stolen_time == guest_stolen_time[i])
+			printf(" (BONUS: guest stolen_time even exactly matches run_delay)");
+		printf("\n");
+	}
+
+	return 0;
+}
-- 
2.18.1

