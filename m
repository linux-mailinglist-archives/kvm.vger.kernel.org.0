Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C875FE96E
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 09:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJNHVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 03:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJNHVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 03:21:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B01193745
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 00:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665732074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYOkxg6OJq6CXCgwvELDYvgLwghtKYWzJ4qCZeosqgA=;
        b=PILPrJOYOL9d4iWu5aSg8fWmqSWr3EaO2m0O0iQtF/8AGGrj1FLKkdSwuJci8psI/48+Fx
        7c89u6+ZQq6qcifvEp3LnsCj2Pg0ymbVScPWCemNwpg7WXqlvUnXkUi8JfZwz3kjFtdC6t
        xQY/UiLkihLML7mguKAFjy7VVj2jY3k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-fBt_ZowANmaHQgMpFMxUDg-1; Fri, 14 Oct 2022 03:21:10 -0400
X-MC-Unique: fBt_ZowANmaHQgMpFMxUDg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE14F18E0952;
        Fri, 14 Oct 2022 07:20:34 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88894C42390;
        Fri, 14 Oct 2022 07:20:01 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
        pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
        oliver.upton@linux.dev, seanjc@google.com, peterx@redhat.com,
        maciej.szmigiero@oracle.com, ricarkol@google.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH 4/6] KVM: selftests: memslot_perf_test: Support variable guest page size
Date:   Fri, 14 Oct 2022 15:19:12 +0800
Message-Id: <20221014071914.227134-5-gshan@redhat.com>
In-Reply-To: <20221014071914.227134-1-gshan@redhat.com>
References: <20221014071914.227134-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test case is obviously broken on aarch64 because non-4KB guest
page size is supported. The guest page size on aarch64 could be 4KB,
16KB or 64KB.

This supports variable guest page size, mostly for aarch64.

  - The host determines the guest page size when virtual machine is
    created. The value is also passed to guest through the synchronization
    area.

  - The number of guest pages are unknown until the virtual machine
    is to be created. So all the related macros are dropped. Instead,
    their values are dynamically calculated based on the guest page
    size.

  - The static checks on memory sizes and pages becomes dependent
    on guest page size, which is unknown until the virtual machine
    is about to be created. So all the static checks are converted
    to dynamic checks, done in check_memory_sizes().

  - As the address passed to madvise() should be aligned to host page,
    the size of page chunk is automatically selected, other than one
    page.

  - All other changes included in this patch are almost mechanical
    replacing '4096' with 'guest_page_size'.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 191 +++++++++++-------
 1 file changed, 115 insertions(+), 76 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index d5aa9148f96f..d587bd952ff9 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -26,14 +26,11 @@
 #include <processor.h>
 
 #define MEM_SIZE		((512U << 20) + 4096)
-#define MEM_SIZE_PAGES		(MEM_SIZE / 4096)
 #define MEM_GPA		0x10000000UL
 #define MEM_AUX_GPA		MEM_GPA
 #define MEM_SYNC_GPA		MEM_AUX_GPA
 #define MEM_TEST_GPA		(MEM_AUX_GPA + 4096)
 #define MEM_TEST_SIZE		(MEM_SIZE - 4096)
-static_assert(MEM_SIZE % 4096 == 0, "invalid mem size");
-static_assert(MEM_TEST_SIZE % 4096 == 0, "invalid mem test size");
 
 /*
  * 32 MiB is max size that gets well over 100 iterations on 509 slots.
@@ -42,29 +39,16 @@ static_assert(MEM_TEST_SIZE % 4096 == 0, "invalid mem test size");
  * limited resolution).
  */
 #define MEM_SIZE_MAP		((32U << 20) + 4096)
-#define MEM_SIZE_MAP_PAGES	(MEM_SIZE_MAP / 4096)
 #define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - 4096)
-#define MEM_TEST_MAP_SIZE_PAGES (MEM_TEST_MAP_SIZE / 4096)
-static_assert(MEM_SIZE_MAP % 4096 == 0, "invalid map test region size");
-static_assert(MEM_TEST_MAP_SIZE % 4096 == 0, "invalid map test region size");
-static_assert(MEM_TEST_MAP_SIZE_PAGES % 2 == 0, "invalid map test region size");
-static_assert(MEM_TEST_MAP_SIZE_PAGES > 2, "invalid map test region size");
 
 /*
  * 128 MiB is min size that fills 32k slots with at least one page in each
  * while at the same time gets 100+ iterations in such test
+ *
+ * 2 MiB chunk size like a typical huge page
  */
 #define MEM_TEST_UNMAP_SIZE		(128U << 20)
-#define MEM_TEST_UNMAP_SIZE_PAGES	(MEM_TEST_UNMAP_SIZE / 4096)
-/* 2 MiB chunk size like a typical huge page */
-#define MEM_TEST_UNMAP_CHUNK_PAGES	(2U << (20 - 12))
-static_assert(MEM_TEST_UNMAP_SIZE <= MEM_TEST_SIZE,
-	      "invalid unmap test region size");
-static_assert(MEM_TEST_UNMAP_SIZE % 4096 == 0,
-	      "invalid unmap test region size");
-static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
-	      (2 * MEM_TEST_UNMAP_CHUNK_PAGES) == 0,
-	      "invalid unmap test region size");
+#define MEM_TEST_UNMAP_CHUNK_SIZE	(2U << 20)
 
 /*
  * For the move active test the middle of the test area is placed on
@@ -77,8 +61,7 @@ static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
  * for the total size of 25 pages.
  * Hence, the maximum size here is 50 pages.
  */
-#define MEM_TEST_MOVE_SIZE_PAGES	(50)
-#define MEM_TEST_MOVE_SIZE		(MEM_TEST_MOVE_SIZE_PAGES * 4096)
+#define MEM_TEST_MOVE_SIZE		0x32000
 #define MEM_TEST_MOVE_GPA_DEST		(MEM_GPA + MEM_SIZE)
 static_assert(MEM_TEST_MOVE_SIZE <= MEM_TEST_SIZE,
 	      "invalid move test region size");
@@ -100,6 +83,7 @@ struct vm_data {
 };
 
 struct sync_area {
+	uint32_t    guest_page_size;
 	atomic_bool start_flag;
 	atomic_bool exit_flag;
 	atomic_bool sync_flag;
@@ -192,14 +176,15 @@ static void *vm_gpa2hva(struct vm_data *data, uint64_t gpa, uint64_t *rempages)
 	uint64_t gpage, pgoffs;
 	uint32_t slot, slotoffs;
 	void *base;
+	uint32_t guest_page_size = data->vm->page_size;
 
 	TEST_ASSERT(gpa >= MEM_GPA, "Too low gpa to translate");
-	TEST_ASSERT(gpa < MEM_GPA + data->npages * 4096,
+	TEST_ASSERT(gpa < MEM_GPA + data->npages * guest_page_size,
 		    "Too high gpa to translate");
 	gpa -= MEM_GPA;
 
-	gpage = gpa / 4096;
-	pgoffs = gpa % 4096;
+	gpage = gpa / guest_page_size;
+	pgoffs = gpa % guest_page_size;
 	slot = min(gpage / data->pages_per_slot, (uint64_t)data->nslots - 1);
 	slotoffs = gpage - (slot * data->pages_per_slot);
 
@@ -217,14 +202,16 @@ static void *vm_gpa2hva(struct vm_data *data, uint64_t gpa, uint64_t *rempages)
 	}
 
 	base = data->hva_slots[slot];
-	return (uint8_t *)base + slotoffs * 4096 + pgoffs;
+	return (uint8_t *)base + slotoffs * guest_page_size + pgoffs;
 }
 
 static uint64_t vm_slot2gpa(struct vm_data *data, uint32_t slot)
 {
+	uint32_t guest_page_size = data->vm->page_size;
+
 	TEST_ASSERT(slot < data->nslots, "Too high slot number");
 
-	return MEM_GPA + slot * data->pages_per_slot * 4096;
+	return MEM_GPA + slot * data->pages_per_slot * guest_page_size;
 }
 
 static struct vm_data *alloc_vm(void)
@@ -242,33 +229,34 @@ static struct vm_data *alloc_vm(void)
 }
 
 static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
-		       void *guest_code, uint64_t mempages,
+		       void *guest_code, uint64_t mem_size,
 		       struct timespec *slot_runtime)
 {
-	uint64_t rempages;
+	uint64_t mempages, rempages;
 	uint64_t guest_addr;
-	uint32_t slot;
+	uint32_t slot, guest_page_size;
 	struct timespec tstart;
 	struct sync_area *sync;
 
-	TEST_ASSERT(mempages > 1,
-		    "Can't test without any memory");
+	guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
+	mempages = mem_size / guest_page_size;
+
+	data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
+	ucall_init(data->vm, NULL);
 
 	data->npages = mempages;
+	TEST_ASSERT(data->npages > 1, "Can't test without any memory");
 	data->nslots = nslots;
-	data->pages_per_slot = mempages / data->nslots;
+	data->pages_per_slot = data->npages / data->nslots;
 	if (!data->pages_per_slot) {
-		*maxslots = mempages + 1;
+		*maxslots = data->npages + 1;
 		return false;
 	}
 
-	rempages = mempages % data->nslots;
+	rempages = data->npages % data->nslots;
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-	data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
-	ucall_init(data->vm, NULL);
-
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		data->nslots, data->pages_per_slot, rempages);
 
@@ -283,7 +271,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 		vm_userspace_mem_region_add(data->vm, VM_MEM_SRC_ANONYMOUS,
 					    guest_addr, slot, npages,
 					    0);
-		guest_addr += npages * 4096;
+		guest_addr += npages * guest_page_size;
 	}
 	*slot_runtime = timespec_elapsed(tstart);
 
@@ -300,12 +288,12 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 			    "vm_phy_pages_alloc() failed\n");
 
 		data->hva_slots[slot - 1] = addr_gpa2hva(data->vm, guest_addr);
-		memset(data->hva_slots[slot - 1], 0, npages * 4096);
+		memset(data->hva_slots[slot - 1], 0, npages * guest_page_size);
 
-		guest_addr += npages * 4096;
+		guest_addr += npages * guest_page_size;
 	}
 
-	virt_map(data->vm, MEM_GPA, MEM_GPA, mempages);
+	virt_map(data->vm, MEM_GPA, MEM_GPA, data->npages);
 
 	sync = (typeof(sync))vm_gpa2hva(data, MEM_SYNC_GPA, NULL);
 	atomic_init(&sync->start_flag, false);
@@ -404,6 +392,7 @@ static bool guest_perform_sync(void)
 static void guest_code_test_memslot_move(void)
 {
 	struct sync_area *sync = (typeof(sync))MEM_SYNC_GPA;
+	uint32_t page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
 	uintptr_t base = (typeof(base))READ_ONCE(sync->move_area_ptr);
 
 	GUEST_SYNC(0);
@@ -414,7 +403,7 @@ static void guest_code_test_memslot_move(void)
 		uintptr_t ptr;
 
 		for (ptr = base; ptr < base + MEM_TEST_MOVE_SIZE;
-		     ptr += 4096)
+		     ptr += page_size)
 			*(uint64_t *)ptr = MEM_TEST_VAL_1;
 
 		/*
@@ -432,6 +421,7 @@ static void guest_code_test_memslot_move(void)
 static void guest_code_test_memslot_map(void)
 {
 	struct sync_area *sync = (typeof(sync))MEM_SYNC_GPA;
+	uint32_t page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
 
 	GUEST_SYNC(0);
 
@@ -441,14 +431,16 @@ static void guest_code_test_memslot_map(void)
 		uintptr_t ptr;
 
 		for (ptr = MEM_TEST_GPA;
-		     ptr < MEM_TEST_GPA + MEM_TEST_MAP_SIZE / 2; ptr += 4096)
+		     ptr < MEM_TEST_GPA + MEM_TEST_MAP_SIZE / 2;
+		     ptr += page_size)
 			*(uint64_t *)ptr = MEM_TEST_VAL_1;
 
 		if (!guest_perform_sync())
 			break;
 
 		for (ptr = MEM_TEST_GPA + MEM_TEST_MAP_SIZE / 2;
-		     ptr < MEM_TEST_GPA + MEM_TEST_MAP_SIZE; ptr += 4096)
+		     ptr < MEM_TEST_GPA + MEM_TEST_MAP_SIZE;
+		     ptr += page_size)
 			*(uint64_t *)ptr = MEM_TEST_VAL_2;
 
 		if (!guest_perform_sync())
@@ -495,6 +487,9 @@ static void guest_code_test_memslot_unmap(void)
 
 static void guest_code_test_memslot_rw(void)
 {
+	struct sync_area *sync = (typeof(sync))MEM_SYNC_GPA;
+	uint32_t page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
+
 	GUEST_SYNC(0);
 
 	guest_spin_until_start();
@@ -503,14 +498,14 @@ static void guest_code_test_memslot_rw(void)
 		uintptr_t ptr;
 
 		for (ptr = MEM_TEST_GPA;
-		     ptr < MEM_TEST_GPA + MEM_TEST_SIZE; ptr += 4096)
+		     ptr < MEM_TEST_GPA + MEM_TEST_SIZE; ptr += page_size)
 			*(uint64_t *)ptr = MEM_TEST_VAL_1;
 
 		if (!guest_perform_sync())
 			break;
 
-		for (ptr = MEM_TEST_GPA + 4096 / 2;
-		     ptr < MEM_TEST_GPA + MEM_TEST_SIZE; ptr += 4096) {
+		for (ptr = MEM_TEST_GPA + page_size / 2;
+		     ptr < MEM_TEST_GPA + MEM_TEST_SIZE; ptr += page_size) {
 			uint64_t val = *(uint64_t *)ptr;
 
 			GUEST_ASSERT_1(val == MEM_TEST_VAL_2, val);
@@ -528,6 +523,8 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 				      struct sync_area *sync,
 				      uint64_t *maxslots, bool isactive)
 {
+	uint32_t guest_page_size = data->vm->page_size;
+	uint64_t move_pages = MEM_TEST_MOVE_SIZE / guest_page_size;
 	uint64_t movesrcgpa, movetestgpa;
 
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
@@ -536,7 +533,7 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 		uint64_t lastpages;
 
 		vm_gpa2hva(data, movesrcgpa, &lastpages);
-		if (lastpages < MEM_TEST_MOVE_SIZE_PAGES / 2) {
+		if (lastpages < move_pages / 2) {
 			*maxslots = 0;
 			return false;
 		}
@@ -582,8 +579,9 @@ static void test_memslot_do_unmap(struct vm_data *data,
 				  uint64_t offsp, uint64_t count)
 {
 	uint64_t gpa, ctr;
+	uint32_t guest_page_size = data->vm->page_size;
 
-	for (gpa = MEM_TEST_GPA + offsp * 4096, ctr = 0; ctr < count; ) {
+	for (gpa = MEM_TEST_GPA + offsp * guest_page_size, ctr = 0; ctr < count; ) {
 		uint64_t npages;
 		void *hva;
 		int ret;
@@ -591,12 +589,12 @@ static void test_memslot_do_unmap(struct vm_data *data,
 		hva = vm_gpa2hva(data, gpa, &npages);
 		TEST_ASSERT(npages, "Empty memory slot at gptr 0x%"PRIx64, gpa);
 		npages = min(npages, count - ctr);
-		ret = madvise(hva, npages * 4096, MADV_DONTNEED);
+		ret = madvise(hva, npages * guest_page_size, MADV_DONTNEED);
 		TEST_ASSERT(!ret,
 			    "madvise(%p, MADV_DONTNEED) on VM memory should not fail for gptr 0x%"PRIx64,
 			    hva, gpa);
 		ctr += npages;
-		gpa += npages * 4096;
+		gpa += npages * guest_page_size;
 	}
 	TEST_ASSERT(ctr == count,
 		    "madvise(MADV_DONTNEED) should exactly cover all of the requested area");
@@ -607,11 +605,12 @@ static void test_memslot_map_unmap_check(struct vm_data *data,
 {
 	uint64_t gpa;
 	uint64_t *val;
+	uint32_t guest_page_size = data->vm->page_size;
 
 	if (!map_unmap_verify)
 		return;
 
-	gpa = MEM_TEST_GPA + offsp * 4096;
+	gpa = MEM_TEST_GPA + offsp * guest_page_size;
 	val = (typeof(val))vm_gpa2hva(data, gpa, NULL);
 	TEST_ASSERT(*val == valexp,
 		    "Guest written values should read back correctly before unmap (%"PRIu64" vs %"PRIu64" @ %"PRIx64")",
@@ -621,12 +620,14 @@ static void test_memslot_map_unmap_check(struct vm_data *data,
 
 static void test_memslot_map_loop(struct vm_data *data, struct sync_area *sync)
 {
+	uint32_t guest_page_size = data->vm->page_size;
+	uint64_t guest_pages = MEM_TEST_MAP_SIZE / guest_page_size;
+
 	/*
 	 * Unmap the second half of the test area while guest writes to (maps)
 	 * the first half.
 	 */
-	test_memslot_do_unmap(data, MEM_TEST_MAP_SIZE_PAGES / 2,
-			      MEM_TEST_MAP_SIZE_PAGES / 2);
+	test_memslot_do_unmap(data, guest_pages / 2, guest_pages / 2);
 
 	/*
 	 * Wait for the guest to finish writing the first half of the test
@@ -637,10 +638,8 @@ static void test_memslot_map_loop(struct vm_data *data, struct sync_area *sync)
 	 */
 	host_perform_sync(sync);
 	test_memslot_map_unmap_check(data, 0, MEM_TEST_VAL_1);
-	test_memslot_map_unmap_check(data,
-				     MEM_TEST_MAP_SIZE_PAGES / 2 - 1,
-				     MEM_TEST_VAL_1);
-	test_memslot_do_unmap(data, 0, MEM_TEST_MAP_SIZE_PAGES / 2);
+	test_memslot_map_unmap_check(data, guest_pages / 2 - 1, MEM_TEST_VAL_1);
+	test_memslot_do_unmap(data, 0, guest_pages / 2);
 
 
 	/*
@@ -653,16 +652,16 @@ static void test_memslot_map_loop(struct vm_data *data, struct sync_area *sync)
 	 * the test area.
 	 */
 	host_perform_sync(sync);
-	test_memslot_map_unmap_check(data, MEM_TEST_MAP_SIZE_PAGES / 2,
-				     MEM_TEST_VAL_2);
-	test_memslot_map_unmap_check(data, MEM_TEST_MAP_SIZE_PAGES - 1,
-				     MEM_TEST_VAL_2);
+	test_memslot_map_unmap_check(data, guest_pages / 2, MEM_TEST_VAL_2);
+	test_memslot_map_unmap_check(data, guest_pages - 1, MEM_TEST_VAL_2);
 }
 
 static void test_memslot_unmap_loop_common(struct vm_data *data,
 					   struct sync_area *sync,
 					   uint64_t chunk)
 {
+	uint32_t guest_page_size = data->vm->page_size;
+	uint64_t guest_pages = MEM_TEST_UNMAP_SIZE / guest_page_size;
 	uint64_t ctr;
 
 	/*
@@ -674,42 +673,49 @@ static void test_memslot_unmap_loop_common(struct vm_data *data,
 	 */
 	host_perform_sync(sync);
 	test_memslot_map_unmap_check(data, 0, MEM_TEST_VAL_1);
-	for (ctr = 0; ctr < MEM_TEST_UNMAP_SIZE_PAGES / 2; ctr += chunk)
+	for (ctr = 0; ctr < guest_pages / 2; ctr += chunk)
 		test_memslot_do_unmap(data, ctr, chunk);
 
 	/* Likewise, but for the opposite host / guest areas */
 	host_perform_sync(sync);
-	test_memslot_map_unmap_check(data, MEM_TEST_UNMAP_SIZE_PAGES / 2,
-				     MEM_TEST_VAL_2);
-	for (ctr = MEM_TEST_UNMAP_SIZE_PAGES / 2;
-	     ctr < MEM_TEST_UNMAP_SIZE_PAGES; ctr += chunk)
+	test_memslot_map_unmap_check(data, guest_pages / 2, MEM_TEST_VAL_2);
+	for (ctr = guest_pages / 2; ctr < guest_pages; ctr += chunk)
 		test_memslot_do_unmap(data, ctr, chunk);
 }
 
 static void test_memslot_unmap_loop(struct vm_data *data,
 				    struct sync_area *sync)
 {
-	test_memslot_unmap_loop_common(data, sync, 1);
+	uint32_t host_page_size = getpagesize();
+	uint32_t guest_page_size = data->vm->page_size;
+	uint64_t guest_chunk_pages = guest_page_size >= host_page_size ?
+					1 : host_page_size / guest_page_size;
+
+	test_memslot_unmap_loop_common(data, sync, guest_chunk_pages);
 }
 
 static void test_memslot_unmap_loop_chunked(struct vm_data *data,
 					    struct sync_area *sync)
 {
-	test_memslot_unmap_loop_common(data, sync, MEM_TEST_UNMAP_CHUNK_PAGES);
+	uint32_t guest_page_size = data->vm->page_size;
+	uint64_t guest_chunk_pages = MEM_TEST_UNMAP_CHUNK_SIZE / guest_page_size;
+
+	test_memslot_unmap_loop_common(data, sync, guest_chunk_pages);
 }
 
 static void test_memslot_rw_loop(struct vm_data *data, struct sync_area *sync)
 {
 	uint64_t gptr;
+	uint32_t guest_page_size = data->vm->page_size;
 
-	for (gptr = MEM_TEST_GPA + 4096 / 2;
-	     gptr < MEM_TEST_GPA + MEM_TEST_SIZE; gptr += 4096)
+	for (gptr = MEM_TEST_GPA + guest_page_size / 2;
+	     gptr < MEM_TEST_GPA + MEM_TEST_SIZE; gptr += guest_page_size)
 		*(uint64_t *)vm_gpa2hva(data, gptr, NULL) = MEM_TEST_VAL_2;
 
 	host_perform_sync(sync);
 
 	for (gptr = MEM_TEST_GPA;
-	     gptr < MEM_TEST_GPA + MEM_TEST_SIZE; gptr += 4096) {
+	     gptr < MEM_TEST_GPA + MEM_TEST_SIZE; gptr += guest_page_size) {
 		uint64_t *vptr = (typeof(vptr))vm_gpa2hva(data, gptr, NULL);
 		uint64_t val = *vptr;
 
@@ -738,7 +744,7 @@ static bool test_execute(int nslots, uint64_t *maxslots,
 			 struct timespec *slot_runtime,
 			 struct timespec *guest_runtime)
 {
-	uint64_t mem_size = tdata->mem_size ? : MEM_SIZE_PAGES;
+	uint64_t mem_size = tdata->mem_size ? : MEM_SIZE;
 	struct vm_data *data;
 	struct sync_area *sync;
 	struct timespec tstart;
@@ -753,6 +759,7 @@ static bool test_execute(int nslots, uint64_t *maxslots,
 
 	sync = (typeof(sync))vm_gpa2hva(data, MEM_SYNC_GPA, NULL);
 
+	sync->guest_page_size = data->vm->page_size;
 	if (tdata->prepare &&
 	    !tdata->prepare(data, sync, maxslots)) {
 		ret = false;
@@ -786,19 +793,19 @@ static bool test_execute(int nslots, uint64_t *maxslots,
 static const struct test_data tests[] = {
 	{
 		.name = "map",
-		.mem_size = MEM_SIZE_MAP_PAGES,
+		.mem_size = MEM_SIZE_MAP,
 		.guest_code = guest_code_test_memslot_map,
 		.loop = test_memslot_map_loop,
 	},
 	{
 		.name = "unmap",
-		.mem_size = MEM_TEST_UNMAP_SIZE_PAGES + 1,
+		.mem_size = MEM_TEST_UNMAP_SIZE + 4096,
 		.guest_code = guest_code_test_memslot_unmap,
 		.loop = test_memslot_unmap_loop,
 	},
 	{
 		.name = "unmap chunked",
-		.mem_size = MEM_TEST_UNMAP_SIZE_PAGES + 1,
+		.mem_size = MEM_TEST_UNMAP_SIZE + 4096,
 		.guest_code = guest_code_test_memslot_unmap,
 		.loop = test_memslot_unmap_loop_chunked,
 	},
@@ -856,6 +863,35 @@ static void help(char *name, struct test_args *targs)
 		pr_info("%d: %s\n", ctr, tests[ctr].name);
 }
 
+static bool check_memory_sizes(void)
+{
+	uint32_t guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
+
+	if (MEM_SIZE % guest_page_size ||
+	    MEM_TEST_SIZE % guest_page_size) {
+		pr_info("invalid MEM_SIZE or MEM_TEST_SIZE\n");
+		return false;
+	}
+
+	if (MEM_SIZE_MAP % guest_page_size		||
+	    MEM_TEST_MAP_SIZE % guest_page_size		||
+	    (MEM_TEST_MAP_SIZE / guest_page_size) <= 2	||
+	    (MEM_TEST_MAP_SIZE / guest_page_size) % 2) {
+		pr_info("invalid MEM_SIZE_MAP or MEM_TEST_MAP_SIZE\n");
+		return false;
+	}
+
+	if (MEM_TEST_UNMAP_SIZE > MEM_TEST_SIZE		||
+	    MEM_TEST_UNMAP_SIZE % guest_page_size	||
+	    (MEM_TEST_UNMAP_SIZE / guest_page_size) %
+	    (MEM_TEST_UNMAP_CHUNK_SIZE / guest_page_size)) {
+		pr_info("invalid MEM_TEST_UNMAP_SIZE or MEM_TEST_UNMAP_CHUNK_SIZE\n");
+		return false;
+	}
+
+	return true;
+}
+
 static bool parse_args(int argc, char *argv[],
 		       struct test_args *targs)
 {
@@ -1012,6 +1048,9 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
+	if (!check_memory_sizes())
+		return -1;
+
 	if (!parse_args(argc, argv, &targs))
 		return -1;
 
-- 
2.23.0

