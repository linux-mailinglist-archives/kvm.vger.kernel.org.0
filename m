Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C031A1A4C85
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgDJXRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:20816 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgDJXRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:11 -0400
IronPort-SDR: 4gC9OP0LIaOTwQBfA30+H2lMw/KMINSBs9h0tJiniWGTMZU6tQGxYPuPCNu1oXBYI5/7ss8oin
 4lht3xuf6hwg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:11 -0700
IronPort-SDR: SPP0h1p+pm01MTve1RtMkBZka/MX73aQLNG7zGtk1p0WuzqA1IdCCK2QQFLo1S+gRO0vdydpap
 I/q3epAVXnAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542236"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH 05/10] KVM: sefltests: Add explicit synchronization to move mem region test
Date:   Fri, 10 Apr 2020 16:17:02 -0700
Message-Id: <20200410231707.7128-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use sem_post() and sem_timedwait() to synchronize test stages between
the vCPU thread and the main thread instead of using usleep() to wait
for the vCPU thread and hoping for the best.

Opportunistically refactor the code to make it suck less in general,
and to prepare for adding more testcases.

Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 .../kvm/x86_64/set_memory_region_test.c       | 117 +++++++++++++++---
 1 file changed, 99 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
index c6691cff4e19..629dd8579b73 100644
--- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
@@ -3,6 +3,7 @@
 #include <fcntl.h>
 #include <pthread.h>
 #include <sched.h>
+#include <semaphore.h>
 #include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -26,18 +27,20 @@
 #define MEM_REGION_SIZE		0x200000
 #define MEM_REGION_SLOT		10
 
-static void guest_code(void)
+static const uint64_t MMIO_VAL = 0xbeefull;
+
+static sem_t vcpu_ready;
+
+static inline uint64_t guest_spin_on_val(uint64_t spin_val)
 {
 	uint64_t val;
 
 	do {
 		val = READ_ONCE(*((uint64_t *)MEM_REGION_GPA));
-	} while (!val);
+	} while (val == spin_val);
 
-	if (val != 1)
-		ucall(UCALL_ABORT, 1, val);
-
-	GUEST_DONE();
+	GUEST_SYNC(0);
+	return val;
 }
 
 static void *vcpu_worker(void *data)
@@ -49,25 +52,60 @@ static void *vcpu_worker(void *data)
 
 	/*
 	 * Loop until the guest is done.  Re-enter the guest on all MMIO exits,
-	 * which will occur if the guest attempts to access a memslot while it
-	 * is being moved.
+	 * which will occur if the guest attempts to access a memslot after it
+	 * has been deleted or while it is being moved .
 	 */
 	run = vcpu_state(vm, VCPU_ID);
-	do {
+
+	while (1) {
 		vcpu_run(vm, VCPU_ID);
-	} while (run->exit_reason == KVM_EXIT_MMIO);
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason = %d", run->exit_reason);
+		if (run->exit_reason == KVM_EXIT_IO) {
+			cmd = get_ucall(vm, VCPU_ID, &uc);
+			if (cmd != UCALL_SYNC)
+				break;
+
+			sem_post(&vcpu_ready);
+			continue;
+		}
+
+		if (run->exit_reason != KVM_EXIT_MMIO)
+			break;
+
+		TEST_ASSERT(!run->mmio.is_write, "Unexpected exit mmio write");
+		TEST_ASSERT(run->mmio.len == 8,
+			    "Unexpected exit mmio size = %u", run->mmio.len);
+
+		TEST_ASSERT(run->mmio.phys_addr == MEM_REGION_GPA,
+			    "Unexpected exit mmio address = 0x%llx",
+			    run->mmio.phys_addr);
+		memcpy(run->mmio.data, &MMIO_VAL, 8);
+	}
+
+	if (run->exit_reason == KVM_EXIT_IO && cmd == UCALL_ABORT)
+		TEST_FAIL("%s at %s:%ld, val = %lu", (const char *)uc.args[0],
+			  __FILE__, uc.args[1], uc.args[2]);
 
-	cmd = get_ucall(vm, VCPU_ID, &uc);
-	TEST_ASSERT(cmd == UCALL_DONE, "Unexpected val in guest = %lu", uc.args[0]);
 	return NULL;
 }
 
-static void test_move_memory_region(void)
+static void wait_for_vcpu(void)
+{
+	struct timespec ts;
+
+	TEST_ASSERT(!clock_gettime(CLOCK_REALTIME, &ts),
+		    "clock_gettime() failed: %d\n", errno);
+
+	ts.tv_sec += 2;
+	TEST_ASSERT(!sem_timedwait(&vcpu_ready, &ts),
+		    "sem_timedwait() failed: %d\n", errno);
+
+	/* Wait for the vCPU thread to reenter the guest. */
+	usleep(100000);
+}
+
+static struct kvm_vm *spawn_vm(pthread_t *vcpu_thread, void *guest_code)
 {
-	pthread_t vcpu_thread;
 	struct kvm_vm *vm;
 	uint64_t *hva;
 	uint64_t gpa;
@@ -93,10 +131,45 @@ static void test_move_memory_region(void)
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, 2 * 4096);
 
-	pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
+	pthread_create(vcpu_thread, NULL, vcpu_worker, vm);
 
 	/* Ensure the guest thread is spun up. */
-	usleep(100000);
+	wait_for_vcpu();
+
+	return vm;
+}
+
+
+static void guest_code_move_memory_region(void)
+{
+	uint64_t val;
+
+	GUEST_SYNC(0);
+
+	/*
+	 * Spin until the memory region is moved to a misaligned address.  This
+	 * may or may not trigger MMIO, as the window where the memslot is
+	 * invalid is quite small.
+	 */
+	val = guest_spin_on_val(0);
+	GUEST_ASSERT_1(val == 1 || val == MMIO_VAL, val);
+
+	/* Spin until the memory region is realigned. */
+	val = guest_spin_on_val(MMIO_VAL);
+	GUEST_ASSERT_1(val == 1, val);
+
+	GUEST_DONE();
+}
+
+static void test_move_memory_region(void)
+{
+	pthread_t vcpu_thread;
+	struct kvm_vm *vm;
+	uint64_t *hva;
+
+	vm = spawn_vm(&vcpu_thread, guest_code_move_memory_region);
+
+	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 
 	/*
 	 * Shift the region's base GPA.  The guest should not see "2" as the
@@ -106,6 +179,11 @@ static void test_move_memory_region(void)
 	vm_mem_region_move(vm, MEM_REGION_SLOT, MEM_REGION_GPA - 4096);
 	WRITE_ONCE(*hva, 2);
 
+	/*
+	 * The guest _might_ see an invalid memslot and trigger MMIO, but it's
+	 * a tiny window.  Spin and defer the sync until the memslot is
+	 * restored and guest behavior is once again deterministic.
+	 */
 	usleep(100000);
 
 	/*
@@ -116,6 +194,9 @@ static void test_move_memory_region(void)
 
 	/* Restore the original base, the guest should see "1". */
 	vm_mem_region_move(vm, MEM_REGION_SLOT, MEM_REGION_GPA);
+	wait_for_vcpu();
+	/* Defered sync from when the memslot was misaligned (above). */
+	wait_for_vcpu();
 
 	pthread_join(vcpu_thread, NULL);
 
-- 
2.26.0

