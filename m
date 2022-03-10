Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0AA4D4FA5
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbiCJQrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243508AbiCJQq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:46:57 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD8B15F603
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:54 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id q8-20020a170902f78800b00151cc484688so2963220pln.20
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XkXBjRimFUoMH1vwPvQrnoC3f697jtIaVLXFmIHsGU8=;
        b=gpaGElbXViqunf8GjaCp/toD8XnxRtatZGb+DT2T8atyXuYTKEXuT18ZkiEKgL7cbh
         +IEp1FMjYeDO2pi14BP0oD4R/wjpGhd56bK3tlubHlPsEkzOx4dc3qqszwaTEh/qY9KT
         kK05oN5C+Abd2wY0r1nKrZGVYaJxG3EzIki/k4QV4Dc0ujKaIJwukr7yhsuUZUfK2Mmt
         w0dgaJ0D9tFxFxupySvDIbPNt6wn/WOGqUXHh4vradxg4B1oEijClWptJplgcPx46elW
         hHLnRZ+tgN9b1nn+Wvmo0Djz9HPInf4rSq9gNKwzwQiZpXHbzwh38jMwvFLtX/zpNxwm
         jbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XkXBjRimFUoMH1vwPvQrnoC3f697jtIaVLXFmIHsGU8=;
        b=gNue2Ds5BX4kvnY6tK+bVKUGd45MMTGNoKwmKQrRgehuV4ZIZpwSrAxCZHm5sq9iTH
         LStbu7exGQ4b2xR3DB+gCHmre1NEzTmHdJJsMaQBY6Tt0F/nj4MCGAZ4pkQ1vTDdoEDy
         dICI9yO9cKcetugHRBywpPf2ShdWlZI69FAlSw0ddiMeWbLK4MDlrd7FGxF2TI/JF19m
         /ZrXdzPj6sGkql5ASjqZBslS3cscqNs9ERSugh8WPpp4Y2emE/Bs6BQG6F0IkhJx+YyC
         TCWaJZPDHXGJo8ghQCKDVX6grrLGphvd71aqdKXi1XxlwtC/r3ycf3ICql6tuIl/UmDP
         EVIQ==
X-Gm-Message-State: AOAM532J46b0tju9RXVYH6V9cX0c/WiapPH7hNd7maxe5zJz17D3sLat
        oiuBjyzDK7xETPFRr6kvEq/ko2pX5Rh+
X-Google-Smtp-Source: ABdhPJzmBZT4bN2YKatPgWu5p34O+/TWn3u4BrAOlfMnXO9jDTOCx4218vWVnswgZf8Qwv+MyGysBOSf+yEG
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:b83:b0:4f7:374c:10ef with SMTP id
 g3-20020a056a000b8300b004f7374c10efmr5859634pfj.31.1646930753628; Thu, 10 Mar
 2022 08:45:53 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:22 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 03/13] selftests: KVM: Wrap memslot IDs in a struct for readability
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In many places in the KVM selftests, memslots are referred to by raw
integer IDs. This makes it very difficult to read which argument to
a function is which. Wrap the memslot ID in a struct and provide an easy
macro to create the structs. This should make the code much clearer and
points out where memslot 0 is tacitly used in many library functions.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       |  7 +-
 tools/testing/selftests/kvm/dirty_log_test.c  | 43 +++++----
 .../selftests/kvm/include/kvm_util_base.h     | 42 +++++----
 .../selftests/kvm/include/x86_64/vmx.h        |  4 +-
 .../selftests/kvm/kvm_page_table_test.c       |  9 +-
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 88 ++++++++++---------
 .../selftests/kvm/lib/kvm_util_internal.h     |  2 +-
 .../selftests/kvm/lib/perf_test_util.c        |  4 +-
 .../selftests/kvm/lib/riscv/processor.c       |  2 +-
 .../selftests/kvm/lib/s390x/processor.c       |  6 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  4 +-
 .../selftests/kvm/max_guest_memory_test.c     |  6 +-
 .../kvm/memslot_modification_stress_test.c    |  6 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 11 ++-
 .../selftests/kvm/set_memory_region_test.c    |  8 +-
 tools/testing/selftests/kvm/steal_time.c      |  3 +-
 .../kvm/x86_64/emulator_error_test.c          |  2 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |  3 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c | 10 +--
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  4 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  2 +-
 23 files changed, 151 insertions(+), 119 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 101759ac93a4..04817f65cf18 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -101,7 +101,7 @@ static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
 		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
 		int flags = enable ? KVM_MEM_LOG_DIRTY_PAGES : 0;
 
-		vm_mem_region_set_flags(vm, slot, flags);
+		vm_mem_region_set_flags(vm, MEMSLOT(slot), flags);
 	}
 }
 
@@ -122,7 +122,7 @@ static void get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots
 	for (i = 0; i < slots; i++) {
 		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
 
-		kvm_vm_get_dirty_log(vm, slot, bitmaps[i]);
+		kvm_vm_get_dirty_log(vm, MEMSLOT(slot), bitmaps[i]);
 	}
 }
 
@@ -134,7 +134,8 @@ static void clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
 	for (i = 0; i < slots; i++) {
 		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
 
-		kvm_vm_clear_dirty_log(vm, slot, bitmaps[i], 0, pages_per_slot);
+		kvm_vm_clear_dirty_log(vm, MEMSLOT(slot), bitmaps[i], 0,
+				       pages_per_slot);
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3fcd89e195c7..1241c9a2729c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -26,7 +26,7 @@
 #define VCPU_ID				1
 
 /* The memory slot index to track dirty pages */
-#define TEST_MEM_SLOT_INDEX		1
+#define TEST_MEMSLOT			MEMSLOT(1)
 
 /* Default guest test virtual memory offset */
 #define DEFAULT_GUEST_TEST_MEM		0xc0000000
@@ -229,17 +229,19 @@ static void clear_log_create_vm_done(struct kvm_vm *vm)
 	vm_enable_cap(vm, &cap);
 }
 
-static void dirty_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void dirty_log_collect_dirty_pages(struct kvm_vm *vm,
+					  struct kvm_memslot memslot,
 					  void *bitmap, uint32_t num_pages)
 {
-	kvm_vm_get_dirty_log(vm, slot, bitmap);
+	kvm_vm_get_dirty_log(vm, memslot, bitmap);
 }
 
-static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void clear_log_collect_dirty_pages(struct kvm_vm *vm,
+					  struct kvm_memslot memslot,
 					  void *bitmap, uint32_t num_pages)
 {
-	kvm_vm_get_dirty_log(vm, slot, bitmap);
-	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
+	kvm_vm_get_dirty_log(vm, memslot, bitmap);
+	kvm_vm_clear_dirty_log(vm, memslot, bitmap, 0, num_pages);
 }
 
 /* Should only be called after a GUEST_SYNC */
@@ -293,7 +295,7 @@ static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
 }
 
 static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
-				       int slot, void *bitmap,
+				       struct kvm_memslot memslot, void *bitmap,
 				       uint32_t num_pages, uint32_t *fetch_index)
 {
 	struct kvm_dirty_gfn *cur;
@@ -303,8 +305,9 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
 			break;
-		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
-			    "%u != %u", cur->slot, slot);
+		TEST_ASSERT(cur->slot == memslot.id,
+			    "Slot number didn't match: %u != %u",
+			    cur->slot, memslot.id);
 		TEST_ASSERT(cur->offset < num_pages, "Offset overflow: "
 			    "0x%llx >= 0x%x", cur->offset, num_pages);
 		//pr_info("fetch 0x%x page %llu\n", *fetch_index, cur->offset);
@@ -331,7 +334,8 @@ static void dirty_ring_continue_vcpu(void)
 	sem_post(&sem_vcpu_cont);
 }
 
-static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm,
+					   struct kvm_memslot memslot,
 					   void *bitmap, uint32_t num_pages)
 {
 	/* We only have one vcpu */
@@ -352,7 +356,7 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
 
 	/* Only have one vcpu */
 	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vm, VCPU_ID),
-				       slot, bitmap, num_pages, &fetch_index);
+				       memslot, bitmap, num_pages, &fetch_index);
 
 	cleared = kvm_vm_reset_dirty_ring(vm);
 
@@ -408,8 +412,9 @@ struct log_mode {
 	/* Hook when the vm creation is done (before vcpu creation) */
 	void (*create_vm_done)(struct kvm_vm *vm);
 	/* Hook to collect the dirty pages into the bitmap provided */
-	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
-				     void *bitmap, uint32_t num_pages);
+	void (*collect_dirty_pages)(struct kvm_vm *vm,
+				    struct kvm_memslot memslot,
+				    void *bitmap, uint32_t num_pages);
 	/* Hook to call when after each vcpu run */
 	void (*after_vcpu_run)(struct kvm_vm *vm, int ret, int err);
 	void (*before_vcpu_join) (void);
@@ -473,14 +478,15 @@ static void log_mode_create_vm_done(struct kvm_vm *vm)
 		mode->create_vm_done(vm);
 }
 
-static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void log_mode_collect_dirty_pages(struct kvm_vm *vm,
+					 struct kvm_memslot memslot,
 					 void *bitmap, uint32_t num_pages)
 {
 	struct log_mode *mode = &log_modes[host_log_mode];
 
 	TEST_ASSERT(mode->collect_dirty_pages != NULL,
 		    "collect_dirty_pages() is required for any log mode!");
-	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
+	mode->collect_dirty_pages(vm, memslot, bitmap, num_pages);
 }
 
 static void log_mode_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
@@ -755,8 +761,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    guest_test_phys_mem,
-				    TEST_MEM_SLOT_INDEX,
-				    guest_num_pages,
+				    TEST_MEMSLOT, guest_num_pages,
 				    KVM_MEM_LOG_DIRTY_PAGES);
 
 	/* Do mapping for the dirty track memory slot */
@@ -786,8 +791,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	while (iteration < p->iterations) {
 		/* Give the vcpu thread some time to dirty some pages */
 		usleep(p->interval * 1000);
-		log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
-					     bmap, host_num_pages);
+		log_mode_collect_dirty_pages(vm, TEST_MEMSLOT, bmap,
+					     host_num_pages);
 
 		/*
 		 * See vcpu_sync_stop_requested definition for details on why
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 09ee70c0df26..69a6b5e509ab 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -27,6 +27,14 @@
  */
 struct kvm_vm;
 
+/* Simple int wrapper to represent memslots for callers of kvm_util. */
+struct kvm_memslot {
+	uint32_t id;
+};
+
+#define MEMSLOT(_id)	((struct kvm_memslot){ .id = _id })
+
+
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
@@ -114,9 +122,10 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp, int perm);
 void kvm_vm_release(struct kvm_vm *vmp);
-void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log);
-void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
-			    uint64_t first_page, uint32_t num_pages);
+void kvm_vm_get_dirty_log(struct kvm_vm *vm, struct kvm_memslot memslot,
+			  void *log);
+void kvm_vm_clear_dirty_log(struct kvm_vm *vm, struct kvm_memslot memslot,
+			    void *log, uint64_t first_page, uint32_t num_pages);
 uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
 
 int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
@@ -148,14 +157,15 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
 
 void vm_create_irqchip(struct kvm_vm *vm);
 
-void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-			       uint64_t gpa, uint64_t size, void *hva);
-int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				uint64_t gpa, uint64_t size, void *hva);
+void vm_set_user_memory_region(struct kvm_vm *vm, struct kvm_memslot memslot,
+			       uint32_t flags, uint64_t gpa, uint64_t size,
+			       void *hva);
+int __vm_set_user_memory_region(struct kvm_vm *vm, struct kvm_memslot memslot,
+				uint32_t flags, uint64_t gpa, uint64_t size,
+				void *hva);
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
-	enum vm_mem_backing_src_type src_type,
-	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-	uint32_t flags);
+	enum vm_mem_backing_src_type src_type, uint64_t guest_paddr,
+	struct kvm_memslot memslot, uint64_t npages, uint32_t flags);
 
 void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
@@ -165,9 +175,11 @@ void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 int _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
 void kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
-void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
-void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
-void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
+void vm_mem_region_set_flags(struct kvm_vm *vm, struct kvm_memslot memslot,
+			     uint32_t flags);
+void vm_mem_region_move(struct kvm_vm *vm, struct kvm_memslot memslot,
+			uint64_t new_gpa);
+void vm_mem_region_delete(struct kvm_vm *vm, struct kvm_memslot memslot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
@@ -307,9 +319,9 @@ void virt_pgd_alloc(struct kvm_vm *vm);
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot);
+			     struct kvm_memslot memslot);
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot);
+			      vm_paddr_t paddr_min, struct kvm_memslot memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
 /*
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..cc1dd1f82a1d 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -612,9 +612,9 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
 void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
-			uint32_t memslot);
+			struct kvm_memslot memslot);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint32_t eptp_memslot);
+		  struct kvm_memslot eptp_memslot);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index ba1fdc3dcf4a..74687be63e8a 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -22,7 +22,7 @@
 #include "processor.h"
 #include "guest_modes.h"
 
-#define TEST_MEM_SLOT_INDEX             1
+#define TEST_MEMSLOT			MEMSLOT(1)
 
 /* Default size(1GB) of the memory for testing */
 #define DEFAULT_TEST_MEM_SIZE		(1 << 30)
@@ -300,7 +300,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 
 	/* Add an extra memory slot with specified backing src type */
 	vm_userspace_mem_region_add(vm, src_type, guest_test_phys_mem,
-				    TEST_MEM_SLOT_INDEX, guest_num_pages, 0);
+				    TEST_MEMSLOT, guest_num_pages, 0);
 
 	/* Do mapping(GVA->GPA) for the testing memory slot */
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
@@ -398,8 +398,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
 	/* Test the stage of KVM updating mappings */
-	vm_mem_region_set_flags(vm, TEST_MEM_SLOT_INDEX,
-				KVM_MEM_LOG_DIRTY_PAGES);
+	vm_mem_region_set_flags(vm, TEST_MEMSLOT, KVM_MEM_LOG_DIRTY_PAGES);
 
 	*current_stage = KVM_UPDATE_MAPPINGS;
 
@@ -411,7 +410,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
 	/* Test the stage of KVM adjusting mappings */
-	vm_mem_region_set_flags(vm, TEST_MEM_SLOT_INDEX, 0);
+	vm_mem_region_set_flags(vm, TEST_MEMSLOT, 0);
 
 	*current_stage = KVM_ADJUST_MAPPINGS;
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9343d82519b4..a9e505e351e0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -80,7 +80,7 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
 			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, MEMSLOT(0));
 		vm->pgd = paddr;
 		vm->pgd_created = true;
 	}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1d3493d7fd55..97d1badaba8b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -357,7 +357,7 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	vm->vpages_mapped = sparsebit_alloc();
 	if (phy_pages != 0)
 		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, phy_pages, 0);
+					    0, MEMSLOT(0), phy_pages, 0);
 
 	return vm;
 }
@@ -488,9 +488,10 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
 	}
 }
 
-void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
+void kvm_vm_get_dirty_log(struct kvm_vm *vm, struct kvm_memslot memslot,
+			  void *log)
 {
-	struct kvm_dirty_log args = { .dirty_bitmap = log, .slot = slot };
+	struct kvm_dirty_log args = { .dirty_bitmap = log, .slot = memslot.id };
 	int ret;
 
 	ret = ioctl(vm->fd, KVM_GET_DIRTY_LOG, &args);
@@ -498,11 +499,11 @@ void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
 		    __func__, strerror(-ret));
 }
 
-void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
-			    uint64_t first_page, uint32_t num_pages)
+void kvm_vm_clear_dirty_log(struct kvm_vm *vm, struct kvm_memslot memslot,
+			    void *log, uint64_t first_page, uint32_t num_pages)
 {
 	struct kvm_clear_dirty_log args = {
-		.dirty_bitmap = log, .slot = slot,
+		.dirty_bitmap = log, .slot = memslot.id,
 		.first_page = first_page,
 		.num_pages = num_pages
 	};
@@ -861,11 +862,12 @@ static void vm_userspace_mem_region_hva_insert(struct rb_root *hva_tree,
 }
 
 
-int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				uint64_t gpa, uint64_t size, void *hva)
+int __vm_set_user_memory_region(struct kvm_vm *vm, struct kvm_memslot memslot,
+				uint32_t flags, uint64_t gpa, uint64_t size,
+				void *hva)
 {
 	struct kvm_userspace_memory_region region = {
-		.slot = slot,
+		.slot = memslot.id,
 		.flags = flags,
 		.guest_phys_addr = gpa,
 		.memory_size = size,
@@ -875,10 +877,11 @@ int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 	return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region);
 }
 
-void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-			       uint64_t gpa, uint64_t size, void *hva)
+void vm_set_user_memory_region(struct kvm_vm *vm, struct kvm_memslot memslot,
+			       uint32_t flags, uint64_t gpa, uint64_t size,
+			       void *hva)
 {
-	int ret = __vm_set_user_memory_region(vm, slot, flags, gpa, size, hva);
+	int ret = __vm_set_user_memory_region(vm, memslot, flags, gpa, size, hva);
 
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed, errno = %d (%s)",
 		    errno, strerror(errno));
@@ -892,7 +895,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
  *   src_type - Storage source for this region.
  *              NULL to use anonymous memory.
  *   guest_paddr - Starting guest physical address
- *   slot - KVM region slot
+ *   memslot - KVM region slot
  *   npages - Number of physical pages
  *   flags - KVM memory region flags (e.g. KVM_MEM_LOG_DIRTY_PAGES)
  *
@@ -907,9 +910,8 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
  * region is created with the flags given by flags.
  */
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
-	enum vm_mem_backing_src_type src_type,
-	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-	uint32_t flags)
+	enum vm_mem_backing_src_type src_type, uint64_t guest_paddr,
+	struct kvm_memslot memslot, uint64_t npages, uint32_t flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -949,15 +951,15 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 
 	/* Confirm no region with the requested slot already exists. */
 	hash_for_each_possible(vm->regions.slot_hash, region, slot_node,
-			       slot) {
-		if (region->region.slot != slot)
+			       memslot.id) {
+		if (region->region.slot != memslot.id)
 			continue;
 
 		TEST_FAIL("A mem region with the requested slot "
 			"already exists.\n"
 			"  requested slot: %u paddr: 0x%lx npages: 0x%lx\n"
 			"  existing slot: %u paddr: 0x%lx size: 0x%lx",
-			slot, guest_paddr, npages,
+			memslot.id, guest_paddr, npages,
 			region->region.slot,
 			(uint64_t) region->region.guest_phys_addr,
 			(uint64_t) region->region.memory_size);
@@ -1024,7 +1026,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-	region->region.slot = slot;
+	region->region.slot = memslot.id;
 	region->region.flags = flags;
 	region->region.guest_phys_addr = guest_paddr;
 	region->region.memory_size = npages * vm->page_size;
@@ -1034,13 +1036,13 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		"  rc: %i errno: %i\n"
 		"  slot: %u flags: 0x%x\n"
 		"  guest_phys_addr: 0x%lx size: 0x%lx",
-		ret, errno, slot, flags,
+		ret, errno, memslot.id, flags,
 		guest_paddr, (uint64_t) region->region.memory_size);
 
 	/* Add to quick lookup data structures */
 	vm_userspace_mem_region_gpa_insert(&vm->regions.gpa_tree, region);
 	vm_userspace_mem_region_hva_insert(&vm->regions.hva_tree, region);
-	hash_add(vm->regions.slot_hash, &region->slot_node, slot);
+	hash_add(vm->regions.slot_hash, &region->slot_node, memslot.id);
 
 	/* If shared memory, create an alias. */
 	if (region->fd >= 0) {
@@ -1072,17 +1074,17 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
  *   memory slot ID).
  */
 struct userspace_mem_region *
-memslot2region(struct kvm_vm *vm, uint32_t memslot)
+memslot2region(struct kvm_vm *vm, struct kvm_memslot memslot)
 {
 	struct userspace_mem_region *region;
 
 	hash_for_each_possible(vm->regions.slot_hash, region, slot_node,
-			       memslot)
-		if (region->region.slot == memslot)
+			       memslot.id)
+		if (region->region.slot == memslot.id)
 			return region;
 
 	fprintf(stderr, "No mem region with the requested slot found,\n"
-		"  requested slot: %u\n", memslot);
+		"  requested slot: %u\n", memslot.id);
 	fputs("---- vm dump ----\n", stderr);
 	vm_dump(stderr, vm, 2);
 	TEST_FAIL("Mem region not found");
@@ -1103,12 +1105,13 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
  * Sets the flags of the memory region specified by the value of slot,
  * to the values given by flags.
  */
-void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
+void vm_mem_region_set_flags(struct kvm_vm *vm, struct kvm_memslot memslot,
+			     uint32_t flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
 
-	region = memslot2region(vm, slot);
+	region = memslot2region(vm, memslot);
 
 	region->region.flags = flags;
 
@@ -1116,7 +1119,7 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 
 	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
 		"  rc: %i errno: %i slot: %u flags: 0x%x",
-		ret, errno, slot, flags);
+		ret, errno, memslot.id, flags);
 }
 
 /*
@@ -1124,7 +1127,7 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
  *
  * Input Args:
  *   vm - Virtual Machine
- *   slot - Slot of the memory region to move
+ *   memslot - Memslot of the memory region to move
  *   new_gpa - Starting guest physical address
  *
  * Output Args: None
@@ -1133,12 +1136,13 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
  *
  * Change the gpa of a memory region.
  */
-void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
+void vm_mem_region_move(struct kvm_vm *vm, struct kvm_memslot memslot,
+			uint64_t new_gpa)
 {
 	struct userspace_mem_region *region;
 	int ret;
 
-	region = memslot2region(vm, slot);
+	region = memslot2region(vm, memslot);
 
 	region->region.guest_phys_addr = new_gpa;
 
@@ -1146,7 +1150,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
 
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed\n"
 		    "ret: %i errno: %i slot: %u new_gpa: 0x%lx",
-		    ret, errno, slot, new_gpa);
+		    ret, errno, memslot.id, new_gpa);
 }
 
 /*
@@ -1154,7 +1158,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
  *
  * Input Args:
  *   vm - Virtual Machine
- *   slot - Slot of the memory region to delete
+ *   memslot - Memslot of the memory region to delete
  *
  * Output Args: None
  *
@@ -1162,9 +1166,9 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
  *
  * Delete a memory region.
  */
-void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
+void vm_mem_region_delete(struct kvm_vm *vm, struct kvm_memslot memslot)
 {
-	__vm_mem_region_delete(vm, memslot2region(vm, slot), true);
+	__vm_mem_region_delete(vm, memslot2region(vm, memslot), true);
 }
 
 /*
@@ -1356,7 +1360,8 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 
 	virt_pgd_alloc(vm);
 	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
+					      KVM_UTIL_MIN_PFN * vm->page_size,
+					      MEMSLOT(0));
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -2377,7 +2382,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  * not enough pages are available at or above paddr_min.
  */
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+			      vm_paddr_t paddr_min, struct kvm_memslot memslot)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -2404,7 +2409,7 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	if (pg == 0) {
 		fprintf(stderr, "No guest physical page available, "
 			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-			paddr_min, vm->page_size, memslot);
+			paddr_min, vm->page_size, memslot.id);
 		fputs("---- vm dump ----\n", stderr);
 		vm_dump(stderr, vm, 2);
 		abort();
@@ -2417,7 +2422,7 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 }
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot)
+			     struct kvm_memslot memslot)
 {
 	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
 }
@@ -2427,7 +2432,8 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 {
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				 MEMSLOT(0));
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index a03febc24ba6..386ad653391c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -123,6 +123,6 @@ void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent);
 void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent);
 
 struct userspace_mem_region *
-memslot2region(struct kvm_vm *vm, uint32_t memslot);
+memslot2region(struct kvm_vm *vm, struct kvm_memslot memslot);
 
 #endif /* SELFTEST_KVM_UTIL_INTERNAL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 722df3a28791..e19bb2b66bc5 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -169,8 +169,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 		vm_paddr_t region_start = pta->gpa + region_pages * pta->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
-					    PERF_TEST_MEM_SLOT_INDEX + i,
-					    region_pages, 0);
+				MEMSLOT(PERF_TEST_MEM_SLOT_INDEX + i),
+				region_pages, 0);
 	}
 
 	/* Do mapping for the demand paging memory slot */
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d377f2603d98..7a0ff26b9f8d 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -59,7 +59,7 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
 			page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, MEMSLOT(0));
 		vm->pgd = paddr;
 		vm->pgd_created = true;
 	}
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index f87c7137598e..1c873a26e6de 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -22,7 +22,8 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 		return;
 
 	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				   MEMSLOT(0));
 	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	vm->pgd = paddr;
@@ -39,7 +40,8 @@ static uint64_t virt_alloc_region(struct kvm_vm *vm, int ri)
 	uint64_t taddr;
 
 	taddr = vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				   MEMSLOT(0));
 	memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	return (taddr & REGION_ENTRY_ORIGIN)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index d089d8b850b5..7ea9455b3e71 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -505,7 +505,7 @@ void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  * physical pages in VM.
  */
 void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
-			uint32_t memslot)
+			struct kvm_memslot memslot)
 {
 	sparsebit_idx_t i, last;
 	struct userspace_mem_region *region =
@@ -526,7 +526,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 }
 
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint32_t eptp_memslot)
+		  struct kvm_memslot eptp_memslot)
 {
 	vmx->eptp = (void *)vm_vaddr_alloc_page(vm);
 	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 3875c4b23a04..a946a90604ea 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -239,7 +239,8 @@ int main(int argc, char *argv[])
 		if ((gpa - start_gpa) >= max_mem)
 			break;
 
-		vm_set_user_memory_region(vm, slot, 0, gpa, slot_size, mem);
+		vm_set_user_memory_region(vm, MEMSLOT(slot),
+					  0, gpa, slot_size, mem);
 
 #ifdef __x86_64__
 		/* Identity map memory in the guest using 1gb pages. */
@@ -277,7 +278,8 @@ int main(int argc, char *argv[])
 	 * references to the removed regions.
 	 */
 	for (slot = (slot - 1) & ~1ull; slot >= first_slot; slot -= 2)
-		vm_set_user_memory_region(vm, slot, 0, 0, 0, NULL);
+		vm_set_user_memory_region(vm, MEMSLOT(slot),
+					  0, 0, 0, NULL);
 
 	munmap(mem, slot_size / 2);
 
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 1410d0a9141a..465f24ac7b88 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -26,7 +26,7 @@
 #include "test_util.h"
 #include "guest_modes.h"
 
-#define DUMMY_MEMSLOT_INDEX 7
+#define DUMMY_MEMSLOT MEMSLOT(7)
 
 #define DEFAULT_MEMSLOT_MODIFICATION_ITERATIONS 10
 
@@ -81,9 +81,9 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 	for (i = 0; i < nr_modifications; i++) {
 		usleep(delay);
 		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa,
-					    DUMMY_MEMSLOT_INDEX, pages, 0);
+					    DUMMY_MEMSLOT, pages, 0);
 
-		vm_mem_region_delete(vm, DUMMY_MEMSLOT_INDEX);
+		vm_mem_region_delete(vm, DUMMY_MEMSLOT);
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 1727f75e0c2c..a18e3a7a19c8 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -293,7 +293,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 			npages += rempages;
 
 		vm_userspace_mem_region_add(data->vm, VM_MEM_SRC_ANONYMOUS,
-					    guest_addr, slot, npages,
+					    guest_addr, MEMSLOT(slot), npages,
 					    0);
 		guest_addr += npages * 4096;
 	}
@@ -308,7 +308,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 			npages += rempages;
 
 		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr,
-					 slot + 1);
+					 MEMSLOT(slot + 1));
 		TEST_ASSERT(gpa == guest_addr,
 			    "vm_phy_pages_alloc() failed\n");
 
@@ -586,9 +586,12 @@ static void test_memslot_move_loop(struct vm_data *data, struct sync_area *sync)
 	uint64_t movesrcgpa;
 
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
-	vm_mem_region_move(data->vm, data->nslots - 1 + 1,
+	vm_mem_region_move(data->vm,
+			   MEMSLOT(data->nslots - 1 + 1),
 			   MEM_TEST_MOVE_GPA_DEST);
-	vm_mem_region_move(data->vm, data->nslots - 1 + 1, movesrcgpa);
+	vm_mem_region_move(data->vm,
+			   MEMSLOT(data->nslots - 1 + 1),
+			   movesrcgpa);
 }
 
 static void test_memslot_do_unmap(struct vm_data *data,
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 73bc297dabe6..aca694607165 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -31,7 +31,7 @@
  * Somewhat arbitrary location and slot, intended to not overlap anything.
  */
 #define MEM_REGION_GPA		0xc0000000
-#define MEM_REGION_SLOT		10
+#define MEM_REGION_SLOT		MEMSLOT(10)
 
 static const uint64_t MMIO_VAL = 0xbeefull;
 
@@ -282,7 +282,7 @@ static void test_delete_memory_region(void)
 	 * Delete the primary memslot.  This should cause an emulation error or
 	 * shutdown due to the page tables getting nuked.
 	 */
-	vm_mem_region_delete(vm, 0);
+	vm_mem_region_delete(vm, MEMSLOT(0));
 
 	pthread_join(vcpu_thread, NULL);
 
@@ -367,7 +367,7 @@ static void test_add_max_memory_regions(void)
 	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
 
 	for (slot = 0; slot < max_mem_slots; slot++)
-		vm_set_user_memory_region(vm, slot, 0,
+		vm_set_user_memory_region(vm, MEMSLOT(slot), 0,
 					  ((uint64_t)slot * MEM_REGION_SIZE),
 					  MEM_REGION_SIZE,
 					  mem_aligned + (uint64_t)slot * MEM_REGION_SIZE);
@@ -377,7 +377,7 @@ static void test_add_max_memory_regions(void)
 			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	TEST_ASSERT(mem_extra != MAP_FAILED, "Failed to mmap() host");
 
-	ret = __vm_set_user_memory_region(vm, max_mem_slots, 0,
+	ret = __vm_set_user_memory_region(vm, MEMSLOT(max_mem_slots), 0,
 					  (uint64_t)max_mem_slots * MEM_REGION_SIZE,
 					  MEM_REGION_SIZE, mem_extra);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 62f2eb9ee3d5..a3d5c0407506 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -276,7 +276,8 @@ int main(int ac, char **av)
 	/* Create a one VCPU guest and an identity mapped memslot for the steal time structure */
 	vm = vm_create_default(0, 0, guest_code);
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE,
+				    MEMSLOT(1), gpages, 0);
 	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
 	ucall_init(vm, NULL);
 
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index f070ff0224fa..fe2d78313878 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -17,7 +17,7 @@
 
 #define MEM_REGION_GVA	0x0000123456789000
 #define MEM_REGION_GPA	0x0000000700000000
-#define MEM_REGION_SLOT	10
+#define MEM_REGION_SLOT	MEMSLOT(10)
 #define MEM_REGION_SIZE PAGE_SIZE
 
 static void guest_code(void)
diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
index da2325fcad87..9ff6bc4c278d 100644
--- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
@@ -66,7 +66,8 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
 	 * KVM x86 zaps all shadow pages on memslot deletion.
 	 */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    MMIO_GPA << 1, 10, 1, 0);
+				    MMIO_GPA << 1,
+				    MEMSLOT(10), 1, 0);
 
 	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
 	vm_init_descriptor_tables(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index a626d40fdb48..3de2958106f7 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -24,7 +24,7 @@
 #define PAGE_SIZE  4096
 
 #define SMRAM_SIZE 65536
-#define SMRAM_MEMSLOT ((1 << 16) | 1)
+#define SMRAM_MEMSLOT MEMSLOT((1 << 16) | 1)
 #define SMRAM_PAGES (SMRAM_SIZE / PAGE_SIZE)
 #define SMRAM_GPA 0x1000000
 #define SMRAM_STAGE 0xfe
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index 68f26a8b4f42..9adba67c1e1c 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -20,7 +20,7 @@
 #define VCPU_ID				1
 
 /* The memory slot index to track dirty pages */
-#define TEST_MEM_SLOT_INDEX		1
+#define TEST_MEMSLOT			MEMSLOT(1)
 #define TEST_MEM_PAGES			3
 
 /* L1 guest test virtual memory offset */
@@ -89,7 +89,7 @@ int main(int argc, char *argv[])
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    GUEST_TEST_MEM,
-				    TEST_MEM_SLOT_INDEX,
+				    TEST_MEMSLOT,
 				    TEST_MEM_PAGES,
 				    KVM_MEM_LOG_DIRTY_PAGES);
 
@@ -106,8 +106,8 @@ int main(int argc, char *argv[])
 	 * Note that prepare_eptp should be called only L1's GPA map is done,
 	 * meaning after the last call to virt_map.
 	 */
-	prepare_eptp(vmx, vm, 0);
-	nested_map_memslot(vmx, vm, 0);
+	prepare_eptp(vmx, vm, MEMSLOT(0));
+	nested_map_memslot(vmx, vm, MEMSLOT(0));
 	nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
 	nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
 
@@ -132,7 +132,7 @@ int main(int argc, char *argv[])
 			 * The nested guest wrote at offset 0x1000 in the memslot, but the
 			 * dirty bitmap must be filled in according to L1 GPA, not L2.
 			 */
-			kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
+			kvm_vm_get_dirty_log(vm, TEST_MEMSLOT, bmap);
 			if (uc.args[1]) {
 				TEST_ASSERT(test_bit(0, bmap), "Page 0 incorrectly reported clean\n");
 				TEST_ASSERT(host_test_mem[0] == 1, "Page 0 not written by guest\n");
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index d9d9d1deec45..37f173a0f189 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -22,11 +22,11 @@
 
 #define SHINFO_REGION_GVA	0xc0000000ULL
 #define SHINFO_REGION_GPA	0xc0000000ULL
-#define SHINFO_REGION_SLOT	10
+#define SHINFO_REGION_SLOT	MEMSLOT(10)
 #define PAGE_SIZE		4096
 
 #define DUMMY_REGION_GPA	(SHINFO_REGION_GPA + (2 * PAGE_SIZE))
-#define DUMMY_REGION_SLOT	11
+#define DUMMY_REGION_SLOT	MEMSLOT(11)
 
 #define SHINFO_ADDR	(SHINFO_REGION_GPA)
 #define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index adc94452b57c..edf5f5600766 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -14,7 +14,7 @@
 #define VCPU_ID		5
 
 #define HCALL_REGION_GPA	0xc0000000ULL
-#define HCALL_REGION_SLOT	10
+#define HCALL_REGION_SLOT	MEMSLOT(10)
 #define PAGE_SIZE		4096
 
 static struct kvm_vm *vm;
-- 
2.35.1.616.g0bdcbb4464-goog

