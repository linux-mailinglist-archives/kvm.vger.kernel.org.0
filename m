Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E933A53C2B0
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbiFCAoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239940AbiFCAns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:43:48 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE58344CC
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c191-20020a621cc8000000b0051bd765ffc5so896839pfc.21
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=e9pGt9aqXwSO3dcgHU1r00dOmAi9mOGpgibN3wMXmec=;
        b=NLZFfZrM44P39C36s+IJzqK9FlQnWkc8ze9pB5ampM0MLA8l5FbtVokj+SVIGlRP5q
         rYv3eD3XaE9tghYZ/eX4AAPpScrBkLQuyibPTdI+4hZ8wFTw817nlUy9V4A7zxH/a+CP
         H7ubhKsBswcSfyqq9df5evfPJvskCykFU5LlBlHdI9pbl92lqptRQaf5SGvLULvIqfns
         8G1l1oiVt2+nWewA/A2O5OrZMhnILY2r9HvOuI0whFER3QsqbvzRM1ffSvwxIXQzuzU+
         qzIPhtJmCLJLzgZgTqW97Tnk4xo3W2xoSdtMXMNx2UZ/kqVsvidYJ09PDZmKxR97VqoJ
         dE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=e9pGt9aqXwSO3dcgHU1r00dOmAi9mOGpgibN3wMXmec=;
        b=iHUyj6ca9ahQQU3/ECSzo964VYUiOir4uwTVPCaDh2gt6LeFM/ppFQ4f2PksjnUtcA
         8RloB9orri4sWlWlXletC2KF+bEC4oDD0hUnoEGCo5KOWvle9l1jrfpbAh3mEgZ5oUwP
         prfTLmyO/8DOYwPofjr8d0V8zoQuPnlLTD3p0wVPWPtem8oSj+gR+MsaQyNjuhXtF8ML
         yOw8MSGkr5RxmvT7T+uA+YhblJjrywJUqDGlmOHlW1Xf1NYIUmRsiqC+d2lH1eTPlws7
         WwyPGjfyMB3Ff6X6MJ714rF3B9pUZu/o6MpFB5UZ2cLhtMjKIh73Ak0kIQQcqYCsqWrY
         3YDg==
X-Gm-Message-State: AOAM530D/Vd3wxDbyD86g93AkJtqmuXvASOGX3Mxg3a84wsskbEAQ64X
        XZmRtbpxkXaDUBY8IzI3/AQBJpDhD80=
X-Google-Smtp-Source: ABdhPJw/7BXWrZy8ytEHB7MoInxJMn6jH97e7+ZxXF2V804IG7yn+b8l+4XP4nbFUNcullBBC6ubr7UwKzg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:24c1:b0:518:c52f:f5 with SMTP id
 d1-20020a056a0024c100b00518c52f00f5mr7810266pfv.15.1654217025915; Thu, 02 Jun
 2022 17:43:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:12 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 005/144] KVM: selftests: Always open VM file descriptors
 with O_RDWR
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Drop the @perm param from vm_create() and always open VM file descriptors
with O_RDWR.  There's no legitimate use case for other permissions, and
if a selftest wants to do oddball negative testing it can open code the
necessary bits instead of forcing a bunch of tests to provide useless
information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      |  2 +-
 .../testing/selftests/kvm/aarch64/psci_test.c |  2 +-
 .../selftests/kvm/aarch64/vcpu_width_config.c |  6 +++---
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
 .../selftests/kvm/hardware_disable_test.c     |  2 +-
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++--
 .../selftests/kvm/kvm_binary_stats_test.c     |  2 +-
 .../selftests/kvm/kvm_create_max_vcpus.c      |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 20 +++++++++----------
 .../selftests/kvm/set_memory_region_test.c    |  4 ++--
 tools/testing/selftests/kvm/x86_64/amx_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  2 +-
 .../kvm/x86_64/max_vcpuid_cap_test.c          |  2 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  2 +-
 .../selftests/kvm/x86_64/set_sregs_test.c     |  2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |  8 ++++----
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/state_test.c |  2 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  2 +-
 19 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index d3a7dbfcbb3d..dd549cc75869 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -416,7 +416,7 @@ static void run_test(struct vcpu_config *c)
 
 	check_supported(c);
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
 	finalize_vcpu(vm, 0, c);
diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 88541de21c41..de3b5e176d04 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -78,7 +78,7 @@ static struct kvm_vm *setup_vm(void *guest_code)
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	kvm_vm_elf_load(vm, program_invocation_name);
 	ucall_init(vm, NULL);
 
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
index 6e9402679229..d48129349213 100644
--- a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -24,7 +24,7 @@ static int add_init_2vcpus(struct kvm_vcpu_init *init1,
 	struct kvm_vm *vm;
 	int ret;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	vm_vcpu_add(vm, 0);
 	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
@@ -49,7 +49,7 @@ static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
 	struct kvm_vm *vm;
 	int ret;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	vm_vcpu_add(vm, 0);
 	vm_vcpu_add(vm, 1);
@@ -86,7 +86,7 @@ int main(void)
 	}
 
 	/* Get the preferred target type and copy that to init2 for later use */
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init1);
 	kvm_vm_free(vm);
 	init2 = init1;
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3fcd89e195c7..11bf606e3165 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -679,7 +679,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
+	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
 	kvm_vm_elf_load(vm, program_invocation_name);
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index b21c69a56daa..1c9e2295c75b 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -104,7 +104,7 @@ static void run_test(uint32_t run)
 	for (i = 0; i < VCPU_NUM; i++)
 		CPU_SET(i, &cpu_set);
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	kvm_vm_elf_load(vm, program_invocation_name);
 	vm_create_irqchip(vm);
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 47b77ebda6a3..89b633b40247 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -110,9 +110,9 @@ int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
+struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages);
 void kvm_vm_free(struct kvm_vm *vmp);
-void kvm_vm_restart(struct kvm_vm *vmp, int perm);
+void kvm_vm_restart(struct kvm_vm *vmp);
 void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log);
 void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 17f65d514915..6217f4630e6c 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -230,7 +230,7 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
 	for (i = 0; i < max_vm; ++i) {
 		vms[i] = vm_create(VM_MODE_DEFAULT,
-				DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+				DEFAULT_GUEST_PHY_PAGES);
 		for (j = 0; j < max_vcpu; ++j)
 			vm_vcpu_add(vms[i], j);
 	}
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index aed9dc3ca1e9..bb69b75eac23 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -28,7 +28,7 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 	pr_info("Testing creating %d vCPUs, with IDs %d...%d.\n",
 		num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	for (i = first_vcpu_id; i < first_vcpu_id + num_vcpus; i++)
 		/* This asserts that the vCPU was created. */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1665a220abcb..da7e3369f4b8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -173,9 +173,9 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 	vm->dirty_ring_size = ring_size;
 }
 
-static void vm_open(struct kvm_vm *vm, int perm)
+static void vm_open(struct kvm_vm *vm)
 {
-	vm->kvm_fd = _open_kvm_dev_path_or_exit(perm);
+	vm->kvm_fd = _open_kvm_dev_path_or_exit(O_RDWR);
 
 	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
 		print_skip("immediate_exit not available");
@@ -240,7 +240,6 @@ _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params)
  * Input Args:
  *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
  *   phy_pages - Physical memory pages
- *   perm - permission
  *
  * Output Args: None
  *
@@ -253,12 +252,12 @@ _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params)
  * descriptor to control the created VM is created with the permissions
  * given by perm (e.g. O_RDWR).
  */
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
+struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
 {
 	struct kvm_vm *vm;
 
-	pr_debug("%s: mode='%s' pages='%ld' perm='%d'\n", __func__,
-		 vm_guest_mode_string(mode), phy_pages, perm);
+	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
+		 vm_guest_mode_string(mode), phy_pages);
 
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
@@ -340,7 +339,7 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
 #endif
 
-	vm_open(vm, perm);
+	vm_open(vm);
 
 	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
@@ -366,7 +365,7 @@ struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
 {
 	struct kvm_vm *vm;
 
-	vm = vm_create(mode, pages, O_RDWR);
+	vm = vm_create(mode, pages);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
@@ -458,7 +457,6 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
  *
  * Input Args:
  *   vm - VM that has been released before
- *   perm - permission
  *
  * Output Args: None
  *
@@ -466,12 +464,12 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
  * global state, such as the irqchip and the memory regions that are mapped
  * into the guest.
  */
-void kvm_vm_restart(struct kvm_vm *vmp, int perm)
+void kvm_vm_restart(struct kvm_vm *vmp)
 {
 	int ctr;
 	struct userspace_mem_region *region;
 
-	vm_open(vmp, perm);
+	vm_open(vmp);
 	if (vmp->has_irqchip)
 		vm_create_irqchip(vmp);
 
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 73bc297dabe6..d97cfd6866c3 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -314,7 +314,7 @@ static void test_zero_memory_regions(void)
 
 	pr_info("Testing KVM_RUN with zero added memory regions\n");
 
-	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, 0);
 	vm_vcpu_add(vm, VCPU_ID);
 
 	TEST_ASSERT(!ioctl(vm_get_fd(vm), KVM_SET_NR_MMU_PAGES, 64),
@@ -354,7 +354,7 @@ static void test_add_max_memory_regions(void)
 		    "KVM_CAP_NR_MEMSLOTS should be greater than 0");
 	pr_info("Allowed number of memory slots: %i\n", max_mem_slots);
 
-	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, 0);
 
 	/* Check it can be added memory slots up to the maximum allowed */
 	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 76f65c22796f..2f01247da0b5 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -431,7 +431,7 @@ int main(int argc, char *argv[])
 		kvm_vm_release(vm);
 
 		/* Restore state in a new VM.  */
-		kvm_vm_restart(vm, O_RDWR);
+		kvm_vm_restart(vm);
 		vm_vcpu_add(vm, VCPU_ID);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index e161c6dd7a02..78668605f673 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -183,7 +183,7 @@ static void save_restore_vm(struct kvm_vm *vm)
 	kvm_vm_release(vm);
 
 	/* Restore state in a new VM.  */
-	kvm_vm_restart(vm, O_RDWR);
+	kvm_vm_restart(vm);
 	vm_vcpu_add(vm, VCPU_ID);
 	vcpu_set_hv_cpuid(vm, VCPU_ID);
 	vcpu_enable_evmcs(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
index 3f6c1ad86cc6..28cc316c5dbe 100644
--- a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -18,7 +18,7 @@ int main(int argc, char *argv[])
 	struct kvm_enable_cap cap = { 0 };
 	int ret;
 
-	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, 0);
 
 	/* Get KVM_CAP_MAX_VCPU_ID cap supported in KVM */
 	ret = vm_check_cap(vm, KVM_CAP_MAX_VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index ae76436af0cc..2fe893ccedd0 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -88,7 +88,7 @@ static struct kvm_vm *create_vm(void)
 	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
 	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
-	vm = vm_create(VM_MODE_DEFAULT, pages, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, pages);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 	vm_create_irqchip(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 318be0bf77ab..44711ab735c3 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -95,7 +95,7 @@ int main(int argc, char *argv[])
 	 * use it to verify all supported CR4 bits can be set prior to defining
 	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
 	 */
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	vm_vcpu_add(vm, VCPU_ID);
 
 	vcpu_sregs_get(vm, VCPU_ID, &sregs);
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index d1dc1acf997c..b0c052443c44 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -54,7 +54,7 @@ static struct kvm_vm *sev_vm_create(bool es)
 	struct kvm_sev_launch_start start = { 0 };
 	int i;
 
-	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, 0);
 	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
 		vm_vcpu_add(vm, i);
@@ -71,7 +71,7 @@ static struct kvm_vm *aux_vm_create(bool with_vcpus)
 	struct kvm_vm *vm;
 	int i;
 
-	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, 0);
 	if (!with_vcpus)
 		return vm;
 
@@ -174,7 +174,7 @@ static void test_sev_migrate_parameters(void)
 		*sev_es_vm_no_vmsa;
 	int ret;
 
-	vm_no_vcpu = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	vm_no_vcpu = vm_create(VM_MODE_DEFAULT, 0);
 	vm_no_sev = aux_vm_create(true);
 	ret = __sev_migrate_from(vm_no_vcpu->fd, vm_no_sev->fd);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
@@ -186,7 +186,7 @@ static void test_sev_migrate_parameters(void)
 
 	sev_vm = sev_vm_create(/* es= */ false);
 	sev_es_vm = sev_vm_create(/* es= */ true);
-	sev_es_vm_no_vmsa = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	sev_es_vm_no_vmsa = vm_create(VM_MODE_DEFAULT, 0);
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
 	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
 
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index b4e0c860769e..dd2c1522ab90 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -204,7 +204,7 @@ int main(int argc, char *argv[])
 
 		state = vcpu_save_state(vm, VCPU_ID);
 		kvm_vm_release(vm);
-		kvm_vm_restart(vm, O_RDWR);
+		kvm_vm_restart(vm);
 		vm_vcpu_add(vm, VCPU_ID);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 2e0a92da8ff5..41f7faaef2ac 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -213,7 +213,7 @@ int main(int argc, char *argv[])
 		kvm_vm_release(vm);
 
 		/* Restore state in a new VM.  */
-		kvm_vm_restart(vm, O_RDWR);
+		kvm_vm_restart(vm);
 		vm_vcpu_add(vm, VCPU_ID);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index ff92e25b6f1e..f5b4ae914131 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -239,7 +239,7 @@ int main(int argc, char *argv[])
 		kvm_vm_release(vm);
 
 		/* Restore state in a new VM.  */
-		kvm_vm_restart(vm, O_RDWR);
+		kvm_vm_restart(vm);
 		vm_vcpu_add(vm, VCPU_ID);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
-- 
2.36.1.255.ge46751e96f-goog

