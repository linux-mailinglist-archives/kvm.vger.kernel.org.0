Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8306D51B32F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379557AbiEDW4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379162AbiEDWxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724DD53A67
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:44 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gg5-20020a17090b0a0500b001d9852bd129so1315403pjb.9
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BalRb3q6SpihL13zmwJdIKwo8UdKEV0Rb+YQQjr96N4=;
        b=UrQJuk0GymDF/lNvyCIxWtBNHrgtXxbCyquWPpxyuWMgjEKexPLV1yoEVVMGftPJtI
         AAL7PXDuzv+tuedExZLpkhCEmof9Hnr2UO+GxqH5luFzj7uWNgDk/lM+MqlKRHp+IC94
         O/c76QZuxrIhJlyFHJmwFbr7Rfc8sZGs2rUHydadXWD6uxwl8tlojvq0O0SiX/PRNFnF
         LArtDKC+IweczI+y0+67H6XcbA9RqeixIRegzfLRv+t4cuZSU6HoXI5c1XlSp4HPp2sC
         7TJB7C0MqynJkpIEUTFcdi4icpgCRUxHdEZifsNRtX3OkafR3FWKj/W5xVmq0FjCa6Vl
         NoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BalRb3q6SpihL13zmwJdIKwo8UdKEV0Rb+YQQjr96N4=;
        b=J0kl3245v+ZeR+mLsZU/ovQh229p7088Mpj8NLLAoT4YjfW9dsiXSz+L2Rwl1fVUNS
         ThGj095Bj9NtJMdfXWD0j+3v6LClkFhMu6rPWzrn/eYv4F7tm0ziE1MdT2jPD4pZuLN7
         vm+A9rLmJhQ5ZrFvz4qKXSr6lMhBmT9psCqkZEQfKq1jNG9i9DXd356Rv4MEj8Pgv9v9
         +CBErasKCVyYk4ZBcPQBDJfanDD2iexE3b8rGaw4xNX6gGSNKqhPDvX2iKaXgBP9WKL7
         FtL+CP3DgI/VnNmSYLh8uYhHTrj4dJl9LtstYQ4Ljn5LREckpKT7Ga+FKIHTlXXLsYr2
         1mwA==
X-Gm-Message-State: AOAM530GnYFjiIFbB0Vv8mfQ1ygRA5QNjLpbaQLWznLNUC4ceZgZSFWe
        k4TXTFSPSbHt/Bk9JpusaG55mf7A/tw=
X-Google-Smtp-Source: ABdhPJyRKUk82euyO6yrwvLemirtUtG3Zh+JmJJF1iaeQRixDpoLyoUr/xpjUa4ao1oyEY5Gw7yc3V6HHnk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a8d:b0:510:510f:d8e1 with SMTP id
 e13-20020a056a001a8d00b00510510fd8e1mr2510174pfv.83.1651704583807; Wed, 04
 May 2022 15:49:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:13 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 007/128] KVM: selftests: Drop @mode from common vm_create() helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop @mode from vm_create() and have it use VM_MODE_DEFAULT.  Add and use
an inner helper, __vm_create(), to service the handful of tests that want
something other than VM_MODE_DEFAULT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      |  2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |  2 +-
 .../selftests/kvm/aarch64/vcpu_width_config.c |  6 +--
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
 .../selftests/kvm/hardware_disable_test.c     |  2 +-
 .../selftests/kvm/include/kvm_util_base.h     |  3 +-
 .../selftests/kvm/kvm_binary_stats_test.c     |  3 +-
 .../selftests/kvm/kvm_create_max_vcpus.c      |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 42 ++++++++++---------
 .../selftests/kvm/set_memory_region_test.c    |  4 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  2 +-
 .../selftests/kvm/x86_64/set_sregs_test.c     |  2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |  8 ++--
 13 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index b3ecaea67bfc..bb71ed81b37a 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -411,7 +411,7 @@ static void run_test(struct vcpu_config *c)
 
 	check_supported(c);
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
 	finalize_vcpu(vm, 0, c);
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 15f4b3544ee5..bde7bae20a6e 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -76,7 +76,7 @@ int main(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 	kvm_vm_elf_load(vm, program_invocation_name);
 	ucall_init(vm, NULL);
 
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
index 271fa90e53fd..4145c28a245a 100644
--- a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -24,7 +24,7 @@ static int add_init_2vcpus(struct kvm_vcpu_init *init1,
 	struct kvm_vm *vm;
 	int ret;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 
 	vm_vcpu_add(vm, 0);
 	ret = __vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
@@ -49,7 +49,7 @@ static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
 	struct kvm_vm *vm;
 	int ret;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 
 	vm_vcpu_add(vm, 0);
 	vm_vcpu_add(vm, 1);
@@ -86,7 +86,7 @@ int main(void)
 	}
 
 	/* Get the preferred target type and copy that to init2 for later use */
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init1);
 	kvm_vm_free(vm);
 	init2 = init1;
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 11bf606e3165..01c01d40201f 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -679,7 +679,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
+	vm = __vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
 	kvm_vm_elf_load(vm, program_invocation_name);
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 1c9e2295c75b..81ba8645772a 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -104,7 +104,7 @@ static void run_test(uint32_t run)
 	for (i = 0; i < VCPU_NUM; i++)
 		CPU_SET(i, &cpu_set);
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 	kvm_vm_elf_load(vm, program_invocation_name);
 	vm_create_irqchip(vm);
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 00f3103dc85e..f6984b0c3816 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -110,7 +110,8 @@ int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages);
+struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages);
+struct kvm_vm *vm_create(uint64_t phy_pages);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
 void kvm_vm_release(struct kvm_vm *vmp);
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 6217f4630e6c..4b149b383678 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -229,8 +229,7 @@ int main(int argc, char *argv[])
 	vms = malloc(sizeof(vms[0]) * max_vm);
 	TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
 	for (i = 0; i < max_vm; ++i) {
-		vms[i] = vm_create(VM_MODE_DEFAULT,
-				DEFAULT_GUEST_PHY_PAGES);
+		vms[i] = vm_create(DEFAULT_GUEST_PHY_PAGES);
 		for (j = 0; j < max_vcpu; ++j)
 			vm_vcpu_add(vms[i], j);
 	}
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index bb69b75eac23..9de5e1376c49 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -28,7 +28,7 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 	pr_info("Testing creating %d vCPUs, with IDs %d...%d.\n",
 		num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 
 	for (i = first_vcpu_id; i < first_vcpu_id + num_vcpus; i++)
 		/* This asserts that the vCPU was created. */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fdcaf74b5959..bab4ab297fcc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -234,25 +234,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
-/*
- * VM Create
- *
- * Input Args:
- *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
- *   phy_pages - Physical memory pages
- *
- * Output Args: None
- *
- * Return:
- *   Pointer to opaque structure that describes the created VM.
- *
- * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K).
- * When phy_pages is non-zero, a memory region of phy_pages physical pages
- * is created and mapped starting at guest physical address 0.  The file
- * descriptor to control the created VM is created with the permissions
- * given by perm (e.g. O_RDWR).
- */
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
+struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
 {
 	struct kvm_vm *vm;
 
@@ -361,11 +343,31 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
 	return vm;
 }
 
+/*
+ * VM Create
+ *
+ * Input Args:
+ *   phy_pages - Physical memory pages
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Pointer to opaque structure that describes the created VM.
+ *
+ * Creates a VM with the default physical/virtual address widths and page size.
+ * When phy_pages is non-zero, a memory region of phy_pages physical pages
+ * is created and mapped starting at guest physical address 0.
+ */
+struct kvm_vm *vm_create(uint64_t phy_pages)
+{
+	return __vm_create(VM_MODE_DEFAULT, phy_pages);
+}
+
 struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
 {
 	struct kvm_vm *vm;
 
-	vm = vm_create(mode, pages);
+	vm = __vm_create(mode, pages);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index d97cfd6866c3..89b13f23c3ac 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -314,7 +314,7 @@ static void test_zero_memory_regions(void)
 
 	pr_info("Testing KVM_RUN with zero added memory regions\n");
 
-	vm = vm_create(VM_MODE_DEFAULT, 0);
+	vm = vm_create(0);
 	vm_vcpu_add(vm, VCPU_ID);
 
 	TEST_ASSERT(!ioctl(vm_get_fd(vm), KVM_SET_NR_MMU_PAGES, 64),
@@ -354,7 +354,7 @@ static void test_add_max_memory_regions(void)
 		    "KVM_CAP_NR_MEMSLOTS should be greater than 0");
 	pr_info("Allowed number of memory slots: %i\n", max_mem_slots);
 
-	vm = vm_create(VM_MODE_DEFAULT, 0);
+	vm = vm_create(0);
 
 	/* Check it can be added memory slots up to the maximum allowed */
 	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index ee3d058a9fe1..b4da92ddc1c6 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -88,7 +88,7 @@ static struct kvm_vm *create_vm(void)
 	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
 	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
-	vm = vm_create(VM_MODE_DEFAULT, pages);
+	vm = vm_create(pages);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 	vm_create_irqchip(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 44711ab735c3..4dc7fd925023 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -95,7 +95,7 @@ int main(int argc, char *argv[])
 	 * use it to verify all supported CR4 bits can be set prior to defining
 	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
 	 */
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 	vm_vcpu_add(vm, VCPU_ID);
 
 	vcpu_sregs_get(vm, VCPU_ID, &sregs);
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index b0c052443c44..7424bec5ae23 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -54,7 +54,7 @@ static struct kvm_vm *sev_vm_create(bool es)
 	struct kvm_sev_launch_start start = { 0 };
 	int i;
 
-	vm = vm_create(VM_MODE_DEFAULT, 0);
+	vm = vm_create(0);
 	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
 		vm_vcpu_add(vm, i);
@@ -71,7 +71,7 @@ static struct kvm_vm *aux_vm_create(bool with_vcpus)
 	struct kvm_vm *vm;
 	int i;
 
-	vm = vm_create(VM_MODE_DEFAULT, 0);
+	vm = vm_create(0);
 	if (!with_vcpus)
 		return vm;
 
@@ -174,7 +174,7 @@ static void test_sev_migrate_parameters(void)
 		*sev_es_vm_no_vmsa;
 	int ret;
 
-	vm_no_vcpu = vm_create(VM_MODE_DEFAULT, 0);
+	vm_no_vcpu = vm_create(0);
 	vm_no_sev = aux_vm_create(true);
 	ret = __sev_migrate_from(vm_no_vcpu->fd, vm_no_sev->fd);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
@@ -186,7 +186,7 @@ static void test_sev_migrate_parameters(void)
 
 	sev_vm = sev_vm_create(/* es= */ false);
 	sev_es_vm = sev_vm_create(/* es= */ true);
-	sev_es_vm_no_vmsa = vm_create(VM_MODE_DEFAULT, 0);
+	sev_es_vm_no_vmsa = vm_create(0);
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
 	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
 
-- 
2.36.0.464.gb9c8b46e94-goog

