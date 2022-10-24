Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D2460A237
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiJXLjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiJXLjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:39:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B98356CB;
        Mon, 24 Oct 2022 04:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611475; x=1698147475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4jBh95k+8xwo1JohtTSjVth9N3E+IK9boL8mgzWoN7E=;
  b=OKB6cXOJBYkJsTt5y34AAkO4QxMqO5Fq5IsnDz+DNQUqjATYN43tC8jz
   WBcclExBf6f2mK3nltTNmuxs8ctAFVCskdxOCZzJhfkLoskEKRKNo3G+d
   I3Gbef+YcNeD1VuK90ZwBaJiw2Et4sTirbde9O6fmPO4QR59cPtHjsc7R
   YYlRbxaeHWHWdXurWSaD8Z+SFNS6u5x5h8ovPhC9dZlUpyAu2UlKftCGN
   Jy1kdnVlDJHIkQgEd4RqkhSSYltcB9P6t36HwG5sCLwzCKEI534KjPVbk
   dIJY9HHX0cLLvsZs2tn72DpGPOYv7yedxK6eYcpUqsc2wZ2JtbS6Ou82p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462469"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462469"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773785039"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773785039"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:22 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 14/18] KVM: selftest/memslot_perf_test: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:41 +0800
Message-Id: <20221024113445.1022147-15-wei.w.wang@intel.com>
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

Remove the vcpu and vcpu_thread fields in the vm_data struct and reuse
the one in the kvm_vm strut. Rename vm_data to vcpu_thread_data and make
it be the vcpu thread's private data. Also use the helper functions to
create and join the vcpu thread.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 137 +++++++++---------
 1 file changed, 71 insertions(+), 66 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 44995446d942..bf37d1bb8d50 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -6,7 +6,6 @@
  *
  * Basic guest setup / host vCPU thread code lifted from set_memory_region_test.
  */
-#include <pthread.h>
 #include <sched.h>
 #include <semaphore.h>
 #include <stdatomic.h>
@@ -86,10 +85,7 @@ static_assert(MEM_TEST_MOVE_SIZE <= MEM_TEST_SIZE,
 #define MEM_TEST_VAL_1 0x1122334455667788
 #define MEM_TEST_VAL_2 0x99AABBCCDDEEFF00
 
-struct vm_data {
-	struct kvm_vm *vm;
-	struct kvm_vcpu *vcpu;
-	pthread_t vcpu_thread;
+struct vcpu_thread_data {
 	uint32_t nslots;
 	uint64_t npages;
 	uint64_t pages_per_slot;
@@ -126,7 +122,7 @@ static bool verbose;
 			pr_info(__VA_ARGS__);	\
 	} while (0)
 
-static void check_mmio_access(struct vm_data *data, struct kvm_run *run)
+static void check_mmio_access(struct vcpu_thread_data *data, struct kvm_run *run)
 {
 	TEST_ASSERT(data->mmio_ok, "Unexpected mmio exit");
 	TEST_ASSERT(run->mmio.is_write, "Unexpected mmio read");
@@ -140,8 +136,9 @@ static void check_mmio_access(struct vm_data *data, struct kvm_run *run)
 
 static void *vcpu_worker(void *__data)
 {
-	struct vm_data *data = __data;
-	struct kvm_vcpu *vcpu = data->vcpu;
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)__data;
+	struct vcpu_thread_data *data =
+		(struct vcpu_thread_data *)vcpu->private_data;
 	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
@@ -187,7 +184,8 @@ static void wait_for_vcpu(void)
 		    "sem_timedwait() failed: %d\n", errno);
 }
 
-static void *vm_gpa2hva(struct vm_data *data, uint64_t gpa, uint64_t *rempages)
+static void *vm_gpa2hva(struct vcpu_thread_data *data,
+			  uint64_t gpa, uint64_t *rempages)
 {
 	uint64_t gpage, pgoffs;
 	uint32_t slot, slotoffs;
@@ -220,31 +218,19 @@ static void *vm_gpa2hva(struct vm_data *data, uint64_t gpa, uint64_t *rempages)
 	return (uint8_t *)base + slotoffs * 4096 + pgoffs;
 }
 
-static uint64_t vm_slot2gpa(struct vm_data *data, uint32_t slot)
+static uint64_t vm_slot2gpa(struct vcpu_thread_data *data, uint32_t slot)
 {
 	TEST_ASSERT(slot < data->nslots, "Too high slot number");
 
 	return MEM_GPA + slot * data->pages_per_slot * 4096;
 }
 
-static struct vm_data *alloc_vm(void)
-{
-	struct vm_data *data;
-
-	data = malloc(sizeof(*data));
-	TEST_ASSERT(data, "malloc(vmdata) failed");
-
-	data->vm = NULL;
-	data->vcpu = NULL;
-	data->hva_slots = NULL;
-
-	return data;
-}
-
-static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
-		       void *guest_code, uint64_t mempages,
-		       struct timespec *slot_runtime)
+static bool prepare_vm(struct kvm_vm **out_vm, int nslots, uint64_t *maxslots,
+	void *guest_code, uint64_t mempages,  struct timespec *slot_runtime)
 {
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct vcpu_thread_data *data;
 	uint32_t max_mem_slots;
 	uint64_t rempages;
 	uint64_t guest_addr;
@@ -263,6 +249,11 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 
 	TEST_ASSERT(mempages > 1,
 		    "Can't test without any memory");
+	vm = __vm_create_with_one_vcpu(&vcpu, mempages, guest_code);
+	*out_vm = vm;
+	vm_vcpu_threads_private_data_alloc(vm,
+					sizeof(struct vcpu_thread_data));
+	data = (struct vcpu_thread_data *)vcpu->private_data;
 
 	data->npages = mempages;
 	data->nslots = max_mem_slots - 1;
@@ -276,8 +267,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-	data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
-	ucall_init(data->vm, NULL);
+	ucall_init(vm, NULL);
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		max_mem_slots - 1, data->pages_per_slot, rempages);
@@ -290,7 +280,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 		if (slot == max_mem_slots - 1)
 			npages += rempages;
 
-		vm_userspace_mem_region_add(data->vm, VM_MEM_SRC_ANONYMOUS,
+		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 					    guest_addr, slot, npages,
 					    0);
 		guest_addr += npages * 4096;
@@ -305,18 +295,18 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 		if (slot == max_mem_slots - 2)
 			npages += rempages;
 
-		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr,
+		gpa = vm_phy_pages_alloc(vm, npages, guest_addr,
 					 slot + 1);
 		TEST_ASSERT(gpa == guest_addr,
 			    "vm_phy_pages_alloc() failed\n");
 
-		data->hva_slots[slot] = addr_gpa2hva(data->vm, guest_addr);
+		data->hva_slots[slot] = addr_gpa2hva(vm, guest_addr);
 		memset(data->hva_slots[slot], 0, npages * 4096);
 
 		guest_addr += npages * 4096;
 	}
 
-	virt_map(data->vm, MEM_GPA, MEM_GPA, mempages);
+	virt_map(vm, MEM_GPA, MEM_GPA, mempages);
 
 	sync = (typeof(sync))vm_gpa2hva(data, MEM_SYNC_GPA, NULL);
 	atomic_init(&sync->start_flag, false);
@@ -328,26 +318,22 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	return true;
 }
 
-static void launch_vm(struct vm_data *data)
+static void launch_vm(struct kvm_vm *vm)
 {
 	pr_info_v("Launching the test VM\n");
 
-	pthread_create(&data->vcpu_thread, NULL, vcpu_worker, data);
+	vm_vcpu_threads_create(vm, vcpu_worker, 0);
 
 	/* Ensure the guest thread is spun up. */
 	wait_for_vcpu();
 }
 
-static void free_vm(struct vm_data *data)
+static void vcpu_thread_data_free(struct vcpu_thread_data *data)
 {
-	kvm_vm_free(data->vm);
-	free(data->hva_slots);
-	free(data);
-}
-
-static void wait_guest_exit(struct vm_data *data)
-{
-	pthread_join(data->vcpu_thread, NULL);
+	if (data) {
+		free(data->hva_slots);
+		free(data);
+	}
 }
 
 static void let_guest_run(struct sync_area *sync)
@@ -535,7 +521,7 @@ static void guest_code_test_memslot_rw(void)
 	GUEST_DONE();
 }
 
-static bool test_memslot_move_prepare(struct vm_data *data,
+static bool test_memslot_move_prepare(struct vcpu_thread_data *data,
 				      struct sync_area *sync,
 				      uint64_t *maxslots, bool isactive)
 {
@@ -565,31 +551,33 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 	return true;
 }
 
-static bool test_memslot_move_prepare_active(struct vm_data *data,
+static bool test_memslot_move_prepare_active(struct vcpu_thread_data *data,
 					     struct sync_area *sync,
 					     uint64_t *maxslots)
 {
 	return test_memslot_move_prepare(data, sync, maxslots, true);
 }
 
-static bool test_memslot_move_prepare_inactive(struct vm_data *data,
+static bool test_memslot_move_prepare_inactive(struct vcpu_thread_data *data,
 					       struct sync_area *sync,
 					       uint64_t *maxslots)
 {
 	return test_memslot_move_prepare(data, sync, maxslots, false);
 }
 
-static void test_memslot_move_loop(struct vm_data *data, struct sync_area *sync)
+static void test_memslot_move_loop(struct kvm_vcpu *vcpu, struct sync_area *sync)
 {
 	uint64_t movesrcgpa;
+	struct vcpu_thread_data *data =
+			(struct vcpu_thread_data *)vcpu->private_data;
 
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
-	vm_mem_region_move(data->vm, data->nslots - 1 + 1,
+	vm_mem_region_move(vcpu->vm, data->nslots - 1 + 1,
 			   MEM_TEST_MOVE_GPA_DEST);
-	vm_mem_region_move(data->vm, data->nslots - 1 + 1, movesrcgpa);
+	vm_mem_region_move(vcpu->vm, data->nslots - 1 + 1, movesrcgpa);
 }
 
-static void test_memslot_do_unmap(struct vm_data *data,
+static void test_memslot_do_unmap(struct vcpu_thread_data *data,
 				  uint64_t offsp, uint64_t count)
 {
 	uint64_t gpa, ctr;
@@ -613,7 +601,7 @@ static void test_memslot_do_unmap(struct vm_data *data,
 		    "madvise(MADV_DONTNEED) should exactly cover all of the requested area");
 }
 
-static void test_memslot_map_unmap_check(struct vm_data *data,
+static void test_memslot_map_unmap_check(struct vcpu_thread_data *data,
 					 uint64_t offsp, uint64_t valexp)
 {
 	uint64_t gpa;
@@ -630,8 +618,11 @@ static void test_memslot_map_unmap_check(struct vm_data *data,
 	*val = 0;
 }
 
-static void test_memslot_map_loop(struct vm_data *data, struct sync_area *sync)
+static void test_memslot_map_loop(struct kvm_vcpu *vcpu,
+				  struct sync_area *sync)
 {
+	struct vcpu_thread_data *data =
+				(struct vcpu_thread_data *)vcpu->private_data;
 	/*
 	 * Unmap the second half of the test area while guest writes to (maps)
 	 * the first half.
@@ -670,7 +661,7 @@ static void test_memslot_map_loop(struct vm_data *data, struct sync_area *sync)
 				     MEM_TEST_VAL_2);
 }
 
-static void test_memslot_unmap_loop_common(struct vm_data *data,
+static void test_memslot_unmap_loop_common(struct vcpu_thread_data *data,
 					   struct sync_area *sync,
 					   uint64_t chunk)
 {
@@ -697,21 +688,30 @@ static void test_memslot_unmap_loop_common(struct vm_data *data,
 		test_memslot_do_unmap(data, ctr, chunk);
 }
 
-static void test_memslot_unmap_loop(struct vm_data *data,
+static void test_memslot_unmap_loop(struct kvm_vcpu *vcpu,
 				    struct sync_area *sync)
 {
+	struct vcpu_thread_data *data =
+			(struct vcpu_thread_data *)vcpu->private_data;
+
 	test_memslot_unmap_loop_common(data, sync, 1);
 }
 
-static void test_memslot_unmap_loop_chunked(struct vm_data *data,
+static void test_memslot_unmap_loop_chunked(struct kvm_vcpu *vcpu,
 					    struct sync_area *sync)
 {
+	struct vcpu_thread_data *data =
+			(struct vcpu_thread_data *)vcpu->private_data;
+
 	test_memslot_unmap_loop_common(data, sync, MEM_TEST_UNMAP_CHUNK_PAGES);
 }
 
-static void test_memslot_rw_loop(struct vm_data *data, struct sync_area *sync)
+static void test_memslot_rw_loop(struct kvm_vcpu *vcpu,
+				 struct sync_area *sync)
 {
 	uint64_t gptr;
+	struct vcpu_thread_data *data =
+			(struct vcpu_thread_data *)vcpu->private_data;
 
 	for (gptr = MEM_TEST_GPA + 4096 / 2;
 	     gptr < MEM_TEST_GPA + MEM_TEST_SIZE; gptr += 4096)
@@ -737,9 +737,9 @@ struct test_data {
 	const char *name;
 	uint64_t mem_size;
 	void (*guest_code)(void);
-	bool (*prepare)(struct vm_data *data, struct sync_area *sync,
+	bool (*prepare)(struct vcpu_thread_data *data, struct sync_area *sync,
 			uint64_t *maxslots);
-	void (*loop)(struct vm_data *data, struct sync_area *sync);
+	void (*loop)(struct kvm_vcpu *vcpu, struct sync_area *sync);
 };
 
 static bool test_execute(int nslots, uint64_t *maxslots,
@@ -750,18 +750,22 @@ static bool test_execute(int nslots, uint64_t *maxslots,
 			 struct timespec *guest_runtime)
 {
 	uint64_t mem_size = tdata->mem_size ? : MEM_SIZE_PAGES;
-	struct vm_data *data;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct vcpu_thread_data *data = NULL;
 	struct sync_area *sync;
 	struct timespec tstart;
 	bool ret = true;
 
-	data = alloc_vm();
-	if (!prepare_vm(data, nslots, maxslots, tdata->guest_code,
+	if (!prepare_vm(&vm, nslots, maxslots, tdata->guest_code,
 			mem_size, slot_runtime)) {
 		ret = false;
 		goto exit_free;
 	}
 
+	vcpu = vm->vcpus[0];
+	data = (struct vcpu_thread_data *)vcpu->private_data;
+
 	sync = (typeof(sync))vm_gpa2hva(data, MEM_SYNC_GPA, NULL);
 
 	if (tdata->prepare &&
@@ -770,7 +774,7 @@ static bool test_execute(int nslots, uint64_t *maxslots,
 		goto exit_free;
 	}
 
-	launch_vm(data);
+	launch_vm(vm);
 
 	clock_gettime(CLOCK_MONOTONIC, &tstart);
 	let_guest_run(sync);
@@ -780,16 +784,17 @@ static bool test_execute(int nslots, uint64_t *maxslots,
 		if (guest_runtime->tv_sec >= maxtime)
 			break;
 
-		tdata->loop(data, sync);
+		tdata->loop(vcpu, sync);
 
 		(*nloops)++;
 	}
 
 	make_guest_exit(sync);
-	wait_guest_exit(data);
+	vm_vcpu_threads_join(vm);
 
 exit_free:
-	free_vm(data);
+	vcpu_thread_data_free(data);
+	kvm_vm_free(vm);
 
 	return ret;
 }
-- 
2.27.0

