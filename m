Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784857DA0DA
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346491AbjJ0SqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbjJ0SqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:46:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4401700
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:23 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc29f3afe0so4669045ad.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698431003; x=1699035803; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jQSVyWKl4uOIPgy0IGoz6RV6+SA994mJdxIjj30CSy8=;
        b=1fkcR/pNStTP0a9yNMVsn/3cCTRRESEtqEVmx3tVaqZEW2X4isYKK8yzhoZsx27kbN
         lAHySulYZo36ul3Up/+x072l9FzK3lAgS54Szy8bYxi9TAvylig0b3CZotDyHlYqEm2M
         Crt8cHBLkhE0qQZ+/W0iRNtDpL0FZYR7wR03PQ2vvO72IsfnY1+Twdhgc5HOarvpqKfu
         7ZM+SdDaTeAW5Ja2R2KuVlWwiHmxtz5ZN+JtdqwRPQyKln3uCpsakARjsDYL1S7OhzGe
         PBWaDRrzKciV+g8ZRY2VS5yzwnfzPsZEO3oPbk1HgHR967D2lwVNwO45pfdso8oTl5Yz
         +HsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698431003; x=1699035803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQSVyWKl4uOIPgy0IGoz6RV6+SA994mJdxIjj30CSy8=;
        b=vvU/gdJp2EMl5A1Fqf4/FDEVt10RVaYmj7wrR95H7bKbae89QjjtFxv3vj3mw4mPN4
         1PiHWUGtpJpTcMKGGcvvFtRtKPAASISxFugsrkL5p4vSi18TP4J/eppM7abeAlPDJ0zK
         0fHzFDw5JjKYxXa6immD+sRR6SiWVxZu7dh4fjqz61pJB6zWS3/b1hQawxOx7BUDoNdN
         wnNalFj1eNj45J9cdFwjgw0B+UPvP5sukgjbhFFj47quaVmUyp3g7oFbeqHq6m3kgjHm
         fho6QdAUuTJVFI3xfo+Nm1nr51Pty0nn9u9u5tpo5HDwI+Lgy9iU2VZVkivVClEOWtJA
         EZ/w==
X-Gm-Message-State: AOJu0YzQPS3auWkhgGKj0hYGvKWdncQu0kdmLKV1lCD99gDTywavSolB
        FH/G8w4F7O8PepRH/Prl79xoOgZDPQQ=
X-Google-Smtp-Source: AGHT+IEPiReV3cx4w9TLV/sbeNO6eERW1W7R7I/92aij3c451hoquFxemYBSOe8iuKYscw30iX2x6gNTTBQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:18d:b0:1cc:2183:b380 with SMTP id
 z13-20020a170903018d00b001cc2183b380mr55116plg.8.1698431003083; Fri, 27 Oct
 2023 11:23:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:22:11 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-30-seanjc@google.com>
Subject: [PATCH v13 29/35] KVM: selftests: Introduce VM "shape" to allow tests
 to specify the VM type
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        David Matlack <dmatlack@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a "vm_shape" structure to encapsulate the selftests-defined "mode",
along with the KVM-defined "type" for use when creating a new VM.  "mode"
tracks physical and virtual address properties, as well as the preferred
backing memory type, while "type" corresponds to the VM type.

Taking the VM type will allow adding tests for KVM_CREATE_GUEST_MEMFD,
a.k.a. guest private memory, without needing an entirely separate set of
helpers.  Guest private memory is effectively usable only by confidential
VM types, and it's expected that x86 will double down and require unique
VM types for TDX and SNP guests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
 .../selftests/kvm/include/kvm_util_base.h     | 54 +++++++++++++++----
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 43 +++++++--------
 tools/testing/selftests/kvm/lib/memstress.c   |  3 +-
 .../kvm/x86_64/ucna_injection_test.c          |  2 +-
 6 files changed, 72 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 936f3a8d1b83..6cbecf499767 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -699,7 +699,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = __vm_create(mode, 1, extra_mem_pages);
+	vm = __vm_create(VM_SHAPE(mode), 1, extra_mem_pages);
 
 	log_mode_create_vm_done(vm);
 	*vcpu = vm_vcpu_add(vm, 0, guest_code);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 1441fca6c273..157508c071f3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -188,6 +188,23 @@ enum vm_guest_mode {
 	NUM_VM_MODES,
 };
 
+struct vm_shape {
+	enum vm_guest_mode mode;
+	unsigned int type;
+};
+
+#define VM_TYPE_DEFAULT			0
+
+#define VM_SHAPE(__mode)			\
+({						\
+	struct vm_shape shape = {		\
+		.mode = (__mode),		\
+		.type = VM_TYPE_DEFAULT		\
+	};					\
+						\
+	shape;					\
+})
+
 #if defined(__aarch64__)
 
 extern enum vm_guest_mode vm_mode_default;
@@ -220,6 +237,8 @@ extern enum vm_guest_mode vm_mode_default;
 
 #endif
 
+#define VM_SHAPE_DEFAULT	VM_SHAPE(VM_MODE_DEFAULT)
+
 #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
 #define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
 
@@ -784,21 +803,21 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode);
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
+struct kvm_vm *____vm_create(struct vm_shape shape);
+struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
-	return ____vm_create(VM_MODE_DEFAULT);
+	return ____vm_create(VM_SHAPE_DEFAULT);
 }
 
 static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
 {
-	return __vm_create(VM_MODE_DEFAULT, nr_runnable_vcpus, 0);
+	return __vm_create(VM_SHAPE_DEFAULT, nr_runnable_vcpus, 0);
 }
 
-struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
 				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[]);
 
@@ -806,17 +825,27 @@ static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
 						  void *guest_code,
 						  struct kvm_vcpu *vcpus[])
 {
-	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, 0,
+	return __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus, 0,
 				      guest_code, vcpus);
 }
 
+
+struct kvm_vm *__vm_create_shape_with_one_vcpu(struct vm_shape shape,
+					       struct kvm_vcpu **vcpu,
+					       uint64_t extra_mem_pages,
+					       void *guest_code);
+
 /*
  * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
  * additional pages of guest memory.  Returns the VM and vCPU (via out param).
  */
-struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
-					 uint64_t extra_mem_pages,
-					 void *guest_code);
+static inline struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
+						       uint64_t extra_mem_pages,
+						       void *guest_code)
+{
+	return __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, vcpu,
+					       extra_mem_pages, guest_code);
+}
 
 static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						     void *guest_code)
@@ -824,6 +853,13 @@ static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 	return __vm_create_with_one_vcpu(vcpu, 0, guest_code);
 }
 
+static inline struct kvm_vm *vm_create_shape_with_one_vcpu(struct vm_shape shape,
+							   struct kvm_vcpu **vcpu,
+							   void *guest_code)
+{
+	return __vm_create_shape_with_one_vcpu(shape, vcpu, 0, guest_code);
+}
+
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
 void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 69f26d80c821..e37dc9c21888 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -254,7 +254,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 
 	/* Create a VM with enough guest pages */
 	guest_num_pages = test_mem_size / guest_page_size;
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages,
+	vm = __vm_create_with_vcpus(VM_SHAPE(mode), nr_vcpus, guest_num_pages,
 				    guest_code, test_args.vcpus);
 
 	/* Align down GPA of the testing memslot */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a140aee8d0f5..52b131e3aca5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -209,7 +209,7 @@ __weak void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
 		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
 }
 
-struct kvm_vm *____vm_create(enum vm_guest_mode mode)
+struct kvm_vm *____vm_create(struct vm_shape shape)
 {
 	struct kvm_vm *vm;
 
@@ -221,13 +221,13 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 	vm->regions.hva_tree = RB_ROOT;
 	hash_init(vm->regions.slot_hash);
 
-	vm->mode = mode;
-	vm->type = 0;
+	vm->mode = shape.mode;
+	vm->type = shape.type;
 
-	vm->pa_bits = vm_guest_mode_params[mode].pa_bits;
-	vm->va_bits = vm_guest_mode_params[mode].va_bits;
-	vm->page_size = vm_guest_mode_params[mode].page_size;
-	vm->page_shift = vm_guest_mode_params[mode].page_shift;
+	vm->pa_bits = vm_guest_mode_params[vm->mode].pa_bits;
+	vm->va_bits = vm_guest_mode_params[vm->mode].va_bits;
+	vm->page_size = vm_guest_mode_params[vm->mode].page_size;
+	vm->page_shift = vm_guest_mode_params[vm->mode].page_shift;
 
 	/* Setup mode specific traits. */
 	switch (vm->mode) {
@@ -265,7 +265,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 		/*
 		 * Ignore KVM support for 5-level paging (vm->va_bits == 57),
 		 * it doesn't take effect unless a CR4.LA57 is set, which it
-		 * isn't for this VM_MODE.
+		 * isn't for this mode (48-bit virtual address space).
 		 */
 		TEST_ASSERT(vm->va_bits == 48 || vm->va_bits == 57,
 			    "Linear address width (%d bits) not supported",
@@ -285,10 +285,11 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 		vm->pgtable_levels = 5;
 		break;
 	default:
-		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
+		TEST_FAIL("Unknown guest mode: 0x%x", vm->mode);
 	}
 
 #ifdef __aarch64__
+	TEST_ASSERT(!vm->type, "ARM doesn't support test-provided types");
 	if (vm->pa_bits != 40)
 		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
 #endif
@@ -347,19 +348,19 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
+struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages)
 {
-	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
+	uint64_t nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
 	int i;
 
-	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), nr_pages);
+	pr_debug("%s: mode='%s' type='%d', pages='%ld'\n", __func__,
+		 vm_guest_mode_string(shape.mode), shape.type, nr_pages);
 
-	vm = ____vm_create(mode);
+	vm = ____vm_create(shape);
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
 	for (i = 0; i < NR_MEM_REGIONS; i++)
@@ -400,7 +401,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
  * extra_mem_pages is only used to calculate the maximum page table size,
  * no real memory allocation for non-slot0 memory in this function.
  */
-struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
 				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
@@ -409,7 +410,7 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 
 	TEST_ASSERT(!nr_vcpus || vcpus, "Must provide vCPU array");
 
-	vm = __vm_create(mode, nr_vcpus, extra_mem_pages);
+	vm = __vm_create(shape, nr_vcpus, extra_mem_pages);
 
 	for (i = 0; i < nr_vcpus; ++i)
 		vcpus[i] = vm_vcpu_add(vm, i, guest_code);
@@ -417,15 +418,15 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 	return vm;
 }
 
-struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
-					 uint64_t extra_mem_pages,
-					 void *guest_code)
+struct kvm_vm *__vm_create_shape_with_one_vcpu(struct vm_shape shape,
+					       struct kvm_vcpu **vcpu,
+					       uint64_t extra_mem_pages,
+					       void *guest_code)
 {
 	struct kvm_vcpu *vcpus[1];
 	struct kvm_vm *vm;
 
-	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, extra_mem_pages,
-				    guest_code, vcpus);
+	vm = __vm_create_with_vcpus(shape, 1, extra_mem_pages, guest_code, vcpus);
 
 	*vcpu = vcpus[0];
 	return vm;
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index df457452d146..d05487e5a371 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -168,7 +168,8 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_num_pages,
+	vm = __vm_create_with_vcpus(VM_SHAPE(mode), nr_vcpus,
+				    slot0_pages + guest_num_pages,
 				    memstress_guest_code, vcpus);
 
 	args->vm = vm;
diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
index 85f34ca7e49e..0ed32ec903d0 100644
--- a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
+++ b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
@@ -271,7 +271,7 @@ int main(int argc, char *argv[])
 
 	kvm_check_cap(KVM_CAP_MCE);
 
-	vm = __vm_create(VM_MODE_DEFAULT, 3, 0);
+	vm = __vm_create(VM_SHAPE_DEFAULT, 3, 0);
 
 	kvm_ioctl(vm->kvm_fd, KVM_X86_GET_MCE_CAP_SUPPORTED,
 		  &supported_mcg_caps);
-- 
2.42.0.820.g83a721a137-goog

