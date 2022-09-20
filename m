Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766DA5BDB95
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiITE0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiITE0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:26:11 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9CF550AB
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:26:05 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id s18-20020aa78292000000b0054d1a2ee8cbso953070pfm.14
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=xFXNCs/Kv3LqJyXaP78XR5noApoFVHzXabQ5XyxTcYs=;
        b=boTu4aZyzKJAAM2/SyI7gkLbHWPtO90xFeZFzDxLIt+h041USKeB4fU2oi5Pb1EKN1
         oMLoFEu8S4vZ+ePZNUDQW+q4dLsV3FgLf2p4Pm8zS1mjwtewbKIKE39NLou7AAlhanmr
         FtUIWuH9zzLoUvFu9IDXiCfq34i98g4Kn2f/CI4FQ0QGcLeZ9I/u64cabdtwVNCW8k2y
         AgkvnYcYINyo/6ZdRgtNa6Ex+VwcTDGBwwyc5e/2yy+xU/U3o3Y5plCk2aj6RQJ2xQIB
         JWhuaFNZOyh/KEKz/uko3Z3jbM08VikO2ZvHH7n+hoC4dczET/6hzsVb9REkeHUh+oCl
         ODDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=xFXNCs/Kv3LqJyXaP78XR5noApoFVHzXabQ5XyxTcYs=;
        b=M43wc3ayXqxtPZ6u4q8KjnR/BgAoPUoiNkxnagRWswchX/2CDFhkdAJcINRUpaifur
         T7ObBluv7quhii02XC3XcW0+6pSdeAF1b/kC2h2SXJwWMsPxPU0lW3N3mt4uvbPmdxfQ
         jn8Ney8heOJQn+0QrCyHut+m8n56ytg1q+4Ohn3HJ64tacHOYoinX1P12XjJxwaJfBKs
         GaO7HxpiU2RVj/k6XYF+Cd6HYq4syJ4ODy7WWAkK3QggdVSN5JUFll1UY8bOR0YWtlYi
         OciZJy/xuzPiYoEgjF6UKnL3EUU68a/r3hbUpuldJkEK4KH1W+fDIKALJnfx+Ro0e5VK
         hbRA==
X-Gm-Message-State: ACrzQf3IEjdO4D1zHIebpM157DJbrSDi9znCmh4OCKWuT01KiUZ1JgnL
        W4u2E5UWN5VvpVe36xxN62oxG4U3Z9pVY3nOigPyKLFs3AaYEJhENRasxx14ykwaJy541RStlE4
        XWUrxDo4L/PRrgVeJ311zGThqzRKNdazMHuGbEciAND1BHvPFB3Fz7cGdBVVDB+o=
X-Google-Smtp-Source: AMsMyM6eajy2Gv6f1FBxsk6rskaRM89s5Q5ua7loarIpZKxMIfM847FBN351K04KPhj5AQXEvOXcUq6aVHCTmw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:3b81:b0:202:597a:c71d with SMTP
 id pc1-20020a17090b3b8100b00202597ac71dmr1746899pjb.105.1663647964858; Mon,
 19 Sep 2022 21:26:04 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:25:45 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-8-ricarkol@google.com>
Subject: [PATCH v7 07/13] KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vm_create() helpers are hardcoded to place most page types (code,
page-tables, stacks, etc) in the same memslot #0, and always backed with
anonymous 4K.  There are a couple of issues with that.  First, tests willing to
differ a bit, like placing page-tables in a different backing source type must
replicate much of what's already done by the vm_create() functions.  Second,
the hardcoded assumption of memslot #0 holding most things is spreaded
everywhere; this makes it very hard to change.

Fix the above issues by having selftests specify how they want memory to be
laid out. Start by changing ____vm_create() to not create memslot #0; a future
commit will add test that specifies all memslots used by the VM.  Then, add the
vm->memslots[] array to specify the right memslot for different memory
allocators, e.g.,: lib/elf should use the vm->[MEM_REGION_CODE] memslot.  This
will be used as a way to specify the page-tables memslots (to be backed by huge
pages for example).

There is no functional change intended. The current commit lays out memory
exactly as before. The next commit will change the allocators to get the region
they should be using, e.g.,: like the page table allocators using the pt
memslot.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 25 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 18 +++++++------
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b2dbe253d4d0..26187b8a66c6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -65,6 +65,13 @@ struct userspace_mem_regions {
 	DECLARE_HASHTABLE(slot_hash, 9);
 };
 
+enum kvm_mem_region_type {
+	MEM_REGION_CODE,
+	MEM_REGION_PT,
+	MEM_REGION_DATA,
+	NR_MEM_REGIONS,
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -93,6 +100,13 @@ struct kvm_vm {
 	int stats_fd;
 	struct kvm_stats_header stats_header;
 	struct kvm_stats_desc *stats_desc;
+
+	/*
+	 * KVM region slots. These are the default memslots used by page
+	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
+	 * memslot.
+	 */
+	uint32_t memslots[NR_MEM_REGIONS];
 };
 
 
@@ -105,6 +119,13 @@ struct kvm_vm {
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
+inline struct userspace_mem_region *
+vm_get_mem_region(struct kvm_vm *vm, enum kvm_mem_region_type mrt)
+{
+	assert(mrt < NR_MEM_REGIONS);
+	return memslot2region(vm, vm->memslots[mrt]);
+}
+
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
@@ -643,13 +664,13 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+struct kvm_vm *____vm_create(enum vm_guest_mode mode);
 struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
-	return ____vm_create(VM_MODE_DEFAULT, 0);
+	return ____vm_create(VM_MODE_DEFAULT);
 }
 
 static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5a9f080ff888..2e36d6323518 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -143,13 +143,10 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
+struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 {
 	struct kvm_vm *vm;
 
-	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), nr_pages);
-
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
 
@@ -245,9 +242,6 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
-	if (nr_pages != 0)
-		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, nr_pages, 0);
 
 	return vm;
 }
@@ -293,8 +287,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct kvm_vm *vm;
+	int i;
+
+	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
+		 vm_guest_mode_string(mode), nr_pages);
+
+	vm = ____vm_create(mode);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
 
-	vm = ____vm_create(mode, nr_pages);
+	for (i = 0; i < NR_MEM_REGIONS; i++)
+		vm->memslots[i] = 0;
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
-- 
2.37.3.968.ga6b4b080e4-goog

