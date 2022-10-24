Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33B060A218
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiJXLir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiJXLiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:38:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2DCF02B;
        Mon, 24 Oct 2022 04:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611467; x=1698147467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xM7HXxH+B48BG++NWUWJKnJ1CNJFnMO26T4ZGCyIuOg=;
  b=FksJcDXWvdP6ERPx+dsjiApPoiDY8EAvyj2y5RctRECnaFCFAkB8eAF9
   0bSKz8+UxESa5BrGQt9Cwzen8FNRhf0nsUJsZhwMoP0GwTgwWu3B8s4Qa
   9lGDfqucjhdKoenpjCCXIElDP3npVv/D+Qi6GElT0yAMNYmJXBErTn8a5
   X5SEJWefkuWud9tYJ925vTerZeJSkuNCDvlSQCUccw3WlBp/Z3yGXN/8W
   GL0OxVnW9Jwhtnl7jiPn41zJ4SPwr7LG/QpnCLQZ8sDfsPgzZit1d0nP3
   0NdoawiaL1TDOd7h8EgbgOl1CLCNVXwg9uMUjgmi+rb4Lj6R6WsNXs3Xg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462464"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462464"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773785028"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773785028"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:19 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 13/18] KVM: selftests/perf_test_util: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:40 +0800
Message-Id: <20221024113445.1022147-14-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221024113445.1022147-1-wei.w.wang@intel.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peform vcpu related code consolidation in lib/perf_test_util.c and its
users. To be more precise:
For the lib, perf_test_util.c:
- remove the globally defined *vcpus[] array, as it is a duplicate of
  vm->vcpus[i], and accordingly, remove the "*vcpus[]" input parameters
  from the related APIs (e.g. perf_test_setup_vcpus);
- remove the globally defined vcpu_thread array, as the vcpu thread has
  been included into the kvm_vcpu struct, and simplify the implementation
  in perf_test_start_vcpu_threads by using the related helper functions;
- remove the redundant fields in "struct vcpu_thread" (e.g. vcpu_idx), as
  they are already part of the vcpu struct. Also rename it to "struct
  vcpu_thread_data" and change it to the vcpu thread's private_data, which
  is passed to the vcpu threads' start_routine (i.e. vcpu_thread_main).
- remove perf_test_join_vcpu_threads as we have a helper function to join
  the vcpu threads (i.e. vm_vcpu_threads_join), and put it in
  perf_test_destroy_vm so that users don't need to call threads_join
  and destroy_vm separately.
- change vcpu_fn (per-user vcpu hread's callback routine) to use
  "struct kvm_vcpu" as an interface, as it is easier to get the related
  info from vcpu (e.g. vcpu->id);

For the users, access_tracking_perf_test.c, demand_paging_test.c, and
memslot_modification_stress_test.c, dirty_log_perf_test.c:
- change the input parameters of the functions (e.g. vcpu_thread_main)
  to use "struct kvm_vcpu" as an interface to match the change in the lib;

Finally, have the lib and user changes in one patch to ensure the
interface and its users are updated together, so that the compilation
doesn't complain with errors.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../selftests/kvm/access_tracking_perf_test.c | 18 +++--
 .../selftests/kvm/demand_paging_test.c        |  9 +--
 .../selftests/kvm/dirty_log_perf_test.c       | 11 ++-
 .../selftests/kvm/include/perf_test_util.h    |  9 ++-
 .../selftests/kvm/lib/perf_test_util.c        | 68 +++++++------------
 .../selftests/kvm/lib/x86_64/perf_test_util.c | 11 +--
 .../kvm/memslot_modification_stress_test.c    |  9 +--
 7 files changed, 53 insertions(+), 82 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 76c583a07ea2..878b9189774c 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -125,10 +125,10 @@ static void mark_page_idle(int page_idle_fd, uint64_t pfn)
 		    "Set page_idle bits for PFN 0x%" PRIx64, pfn);
 }
 
-static void mark_vcpu_memory_idle(struct kvm_vm *vm,
-				  struct perf_test_vcpu_args *vcpu_args)
+static void mark_vcpu_memory_idle(struct kvm_vm *vm, int vcpu_idx)
 {
-	int vcpu_idx = vcpu_args->vcpu_idx;
+	struct perf_test_vcpu_args *vcpu_args =
+				&perf_test_args.vcpu_args[vcpu_idx];
 	uint64_t base_gva = vcpu_args->gva;
 	uint64_t pages = vcpu_args->pages;
 	uint64_t page;
@@ -220,11 +220,10 @@ static bool spin_wait_for_next_iteration(int *current_iteration)
 	return true;
 }
 
-static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
+static void vcpu_thread_main(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
-	struct kvm_vm *vm = perf_test_args.vm;
-	int vcpu_idx = vcpu_args->vcpu_idx;
+	struct kvm_vm *vm = vcpu->vm;
+	int vcpu_idx = vcpu->id;
 	int current_iteration = 0;
 
 	while (spin_wait_for_next_iteration(&current_iteration)) {
@@ -234,7 +233,7 @@ static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
 			assert_ucall(vcpu, UCALL_SYNC);
 			break;
 		case ITERATION_MARK_IDLE:
-			mark_vcpu_memory_idle(vm, vcpu_args);
+			mark_vcpu_memory_idle(vm, vcpu_idx);
 			break;
 		};
 
@@ -306,7 +305,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = perf_test_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
 				 params->backing_src, !overlap_memory_access);
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
+	perf_test_start_vcpu_threads(vm, vcpu_thread_main);
 
 	pr_info("\n");
 	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
@@ -324,7 +323,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Set done to signal the vCPU threads to exit */
 	done = true;
 
-	perf_test_join_vcpu_threads(nr_vcpus);
 	perf_test_destroy_vm(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 779ae54f89c4..7b8aaf3a5d57 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -14,7 +14,6 @@
 #include <stdlib.h>
 #include <time.h>
 #include <poll.h>
-#include <pthread.h>
 #include <linux/userfaultfd.h>
 #include <sys/syscall.h>
 
@@ -42,10 +41,9 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 static size_t demand_paging_size;
 static char *guest_data_prototype;
 
-static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
+static void vcpu_worker(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
-	int vcpu_idx = vcpu_args->vcpu_idx;
+	int vcpu_idx = vcpu->id;
 	struct kvm_run *run = vcpu->run;
 	struct timespec start;
 	struct timespec ts_diff;
@@ -336,10 +334,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	perf_test_start_vcpu_threads(vm, vcpu_worker);
 	pr_info("Started all vCPUs\n");
 
-	perf_test_join_vcpu_threads(nr_vcpus);
 	ts_diff = timespec_elapsed(start);
 	pr_info("All vCPU threads joined\n");
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..808d3d768c82 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -11,7 +11,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
-#include <pthread.h>
 #include <linux/bitmap.h>
 
 #include "kvm_util.h"
@@ -67,10 +66,11 @@ static bool host_quit;
 static int iteration;
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
 
-static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
+static void vcpu_worker(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
-	int vcpu_idx = vcpu_args->vcpu_idx;
+	int vcpu_idx = vcpu->id;
+	struct perf_test_vcpu_args *vcpu_args =
+				&perf_test_args.vcpu_args[vcpu_idx];
 	uint64_t pages_count = 0;
 	struct kvm_run *run;
 	struct timespec start;
@@ -248,7 +248,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	for (i = 0; i < nr_vcpus; i++)
 		vcpu_last_completed_iteration[i] = -1;
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	perf_test_start_vcpu_threads(vm, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
 	pr_debug("Starting iteration %d - Populating\n", iteration);
@@ -329,7 +329,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 * wait for them to exit.
 	 */
 	host_quit = true;
-	perf_test_join_vcpu_threads(nr_vcpus);
 
 	avg = timespec_div(get_dirty_log_total, p->iterations);
 	pr_info("Get dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index eaa88df0555a..43816756c1da 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -24,8 +24,7 @@ struct perf_test_vcpu_args {
 	uint64_t gva;
 	uint64_t pages;
 
-	/* Only used by the host userspace part of the vCPU thread */
-	struct kvm_vcpu *vcpu;
+	/* For guest to check if data is corrupted */
 	int vcpu_idx;
 };
 
@@ -53,11 +52,11 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
 
-void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
-void perf_test_join_vcpu_threads(int vcpus);
+void perf_test_start_vcpu_threads(struct kvm_vm *vm,
+				  void (*vcpu_fn)(struct kvm_vcpu *vcpu));
 void perf_test_guest_code(uint32_t vcpu_id);
 
 uint64_t perf_test_nested_pages(int nr_vcpus);
-void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
+void perf_test_setup_nested(struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..94c0f496c9c1 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -16,28 +16,17 @@ struct perf_test_args perf_test_args;
  */
 static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 
-struct vcpu_thread {
-	/* The index of the vCPU. */
-	int vcpu_idx;
-
-	/* The pthread backing the vCPU. */
-	pthread_t thread;
-
+struct vcpu_thread_data {
 	/* Set to true once the vCPU thread is up and running. */
 	bool running;
 };
 
-/* The vCPU threads involved in this test. */
-static struct vcpu_thread vcpu_threads[KVM_MAX_VCPUS];
-
 /* The function run by each vCPU thread, as provided by the test. */
-static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
+static void (*vcpu_thread_fn)(struct kvm_vcpu *);
 
 /* Set to true once all vCPU threads are up and running. */
 static bool all_vcpu_threads_running;
 
-static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
-
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -71,7 +60,6 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 }
 
 void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
-			   struct kvm_vcpu *vcpus[],
 			   uint64_t vcpu_memory_bytes,
 			   bool partition_vcpu_memory_access)
 {
@@ -82,7 +70,6 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 	for (i = 0; i < nr_vcpus; i++) {
 		vcpu_args = &pta->vcpu_args[i];
 
-		vcpu_args->vcpu = vcpus[i];
 		vcpu_args->vcpu_idx = i;
 
 		if (partition_vcpu_memory_access) {
@@ -98,7 +85,7 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			vcpu_args->gpa = pta->gpa;
 		}
 
-		vcpu_args_set(vcpus[i], 1, i);
+		vcpu_args_set(vm->vcpus[i], 1, i);
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
 			 i, vcpu_args->gpa, vcpu_args->gpa +
@@ -153,7 +140,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
 	vm = __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_num_pages,
-				    perf_test_guest_code, vcpus);
+				    perf_test_guest_code, NULL);
 
 	pta->vm = vm;
 
@@ -201,12 +188,12 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	/* Do mapping for the demand paging memory slot */
 	virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages);
 
-	perf_test_setup_vcpus(vm, nr_vcpus, vcpus, vcpu_memory_bytes,
+	perf_test_setup_vcpus(vm, nr_vcpus, vcpu_memory_bytes,
 			      partition_vcpu_memory_access);
 
 	if (pta->nested) {
 		pr_info("Configuring vCPUs to run in L2 (nested).\n");
-		perf_test_setup_nested(vm, nr_vcpus, vcpus);
+		perf_test_setup_nested(vm);
 	}
 
 	ucall_init(vm, NULL);
@@ -219,6 +206,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 void perf_test_destroy_vm(struct kvm_vm *vm)
 {
+	vm_vcpu_threads_join(vm);
+	pr_info("All vCPU threads joined\n");
+
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
 }
@@ -234,7 +224,7 @@ uint64_t __weak perf_test_nested_pages(int nr_vcpus)
 	return 0;
 }
 
-void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu **vcpus)
+void __weak perf_test_setup_nested(struct kvm_vm *vm)
 {
 	pr_info("%s() not support on this architecture, skipping.\n", __func__);
 	exit(KSFT_SKIP);
@@ -242,9 +232,11 @@ void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_v
 
 static void *vcpu_thread_main(void *data)
 {
-	struct vcpu_thread *vcpu = data;
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+	struct vcpu_thread_data *thread_data =
+		(struct vcpu_thread_data *)vcpu->private_data;
 
-	WRITE_ONCE(vcpu->running, true);
+	WRITE_ONCE(thread_data->running, true);
 
 	/*
 	 * Wait for all vCPU threads to be up and running before calling the test-
@@ -255,40 +247,30 @@ static void *vcpu_thread_main(void *data)
 	while (!READ_ONCE(all_vcpu_threads_running))
 		;
 
-	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_idx]);
+	vcpu_thread_fn(vcpu);
 
 	return NULL;
 }
 
-void perf_test_start_vcpu_threads(int nr_vcpus,
-				  void (*vcpu_fn)(struct perf_test_vcpu_args *))
+void perf_test_start_vcpu_threads(struct kvm_vm *vm,
+				  void (*vcpu_fn)(struct kvm_vcpu *))
 {
 	int i;
+	struct kvm_vcpu *vcpu;
+	struct vcpu_thread_data *thread_data;
 
 	vcpu_thread_fn = vcpu_fn;
 	WRITE_ONCE(all_vcpu_threads_running, false);
 
-	for (i = 0; i < nr_vcpus; i++) {
-		struct vcpu_thread *vcpu = &vcpu_threads[i];
-
-		vcpu->vcpu_idx = i;
-		WRITE_ONCE(vcpu->running, false);
+	/* thread_data->running already false-initialized on allocation */
+	vm_vcpu_threads_create(vm, vcpu_thread_main,
+				sizeof(struct vcpu_thread_data));
 
-		pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
-	}
-
-	for (i = 0; i < nr_vcpus; i++) {
-		while (!READ_ONCE(vcpu_threads[i].running))
+	vm_iterate_over_vcpus(vm, vcpu, i) {
+		thread_data = (struct vcpu_thread_data *)vcpu->private_data;
+		while (!READ_ONCE(thread_data->running))
 			;
 	}
 
 	WRITE_ONCE(all_vcpu_threads_running, true);
 }
-
-void perf_test_join_vcpu_threads(int nr_vcpus)
-{
-	int i;
-
-	for (i = 0; i < nr_vcpus; i++)
-		pthread_join(vcpu_threads[i].thread, NULL);
-}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
index 0f344a7c89c4..8c4c87df5b8d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
@@ -77,16 +77,17 @@ void perf_test_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 	nested_identity_map_1g(vmx, vm, start, end - start);
 }
 
-void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
+void perf_test_setup_nested(struct kvm_vm *vm)
 {
 	struct vmx_pages *vmx, *vmx0 = NULL;
 	struct kvm_regs regs;
 	vm_vaddr_t vmx_gva;
 	int vcpu_id;
+	struct kvm_vcpu *vcpu;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
-	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
+	vm_iterate_over_vcpus(vm, vcpu, vcpu_id) {
 		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
 
 		if (vcpu_id == 0) {
@@ -103,9 +104,9 @@ void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 		 * Override the vCPU to run perf_test_l1_guest_code() which will
 		 * bounce it into L2 before calling perf_test_guest_code().
 		 */
-		vcpu_regs_get(vcpus[vcpu_id], &regs);
+		vcpu_regs_get(vcpu, &regs);
 		regs.rip = (unsigned long) perf_test_l1_guest_code;
-		vcpu_regs_set(vcpus[vcpu_id], &regs);
-		vcpu_args_set(vcpus[vcpu_id], 2, vmx_gva, vcpu_id);
+		vcpu_regs_set(vcpu, &regs);
+		vcpu_args_set(vcpu, 2, vmx_gva, vcpu->id);
 	}
 }
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index bb1d17a1171b..d41d2b989a91 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -16,7 +16,6 @@
 #include <asm/unistd.h>
 #include <time.h>
 #include <poll.h>
-#include <pthread.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/userfaultfd.h>
@@ -36,9 +35,8 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
 static bool run_vcpus = true;
 
-static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
+static void vcpu_worker(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	struct kvm_run *run;
 	int ret;
 
@@ -103,7 +101,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pr_info("Finished creating vCPUs\n");
 
-	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
+	perf_test_start_vcpu_threads(vm, vcpu_worker);
 
 	pr_info("Started all vCPUs\n");
 
@@ -112,9 +110,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	run_vcpus = false;
 
-	perf_test_join_vcpu_threads(nr_vcpus);
-	pr_info("All vCPU threads joined\n");
-
 	perf_test_destroy_vm(vm);
 }
 
-- 
2.27.0

