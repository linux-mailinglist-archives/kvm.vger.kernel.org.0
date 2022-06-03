Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8274853C1DB
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbiFCApm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240051AbiFCAo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55878344D8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j8-20020a17090a3e0800b001e3425c05c4so3422306pjc.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=M+/q5phNROnbGTj/bDsHN/eJ+COHhpA9RgQ9xBHSrro=;
        b=IGmcfHfV6Cd0auhXIHl3IabYdJmc3qBgunUseszDWwswKWs4akUdojoweJRht0DkVE
         NRezA/oZ1GYP0V3Lm6it5a0RoMTRPRk6nHMDcA+HOX42cQDKAbE/sv32G+PCY3nJiaX3
         /TwGuus7h8a2xmxUHwmQCP02rQ2SnIuQWusoAfjt5x4qjlD1rf96iHDbb4YSnrdvZhml
         fCKMonNFYJAh2fO2gM7HxIRXKVLjac7I8wAFZ3mQoKDiGmjDO1aeaU4Q28gNLzDAUu1G
         M1Li2oSZxBgqd5mPpeIk/nESS4w3U98J2UBfs4Y5miHAkPZyf1z5TZAunnI3gU1eDJr5
         pAoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=M+/q5phNROnbGTj/bDsHN/eJ+COHhpA9RgQ9xBHSrro=;
        b=hRgHN998lSFgsCbeTv8Q3WcUQ4Up6J+OoR9l4CHJqamfXrctIHgGRBYZM/tdaSfDAf
         Ri4LYY7MQUxBoHUNWcaTZV6hbrBy/v4ri4Ysb0e7W9uHULKlE8Iz7QdJ93VYUH5xOOih
         SjW87168rwV/RwFIo/n4NPdNqunvfgYZEZVXUoTWt5kDuHwAmwTfScfvCfEaWH4LVQp7
         IrMtE1rduVv3JLW0Q5cnZtPPk7twuGg5q3fH26A6z03OotQAmOEF6guARTPUAAZmyYjG
         xpwYGzNAg+TrpPhFEkdabvX0ki65ID185II5Bh7wQL5czk9xWlFDJjN3E9DprBHbl6IG
         3phQ==
X-Gm-Message-State: AOAM5325Qn6p9/055osGA3gdp5enGfN/uNDHtGof56Ph0JWRKp2KWsVc
        S1YluCowxsQTWc2pqJxXs/BLjc3e5Us=
X-Google-Smtp-Source: ABdhPJyYAYm1gmiDLJXUDlNpkk8+CqGKqyqlbVR4P0/t4GDvr9bs+7xrlq+Y8Hxo55vpKzJ5klXs9VWx2m8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7844:b0:1e6:9145:4df with SMTP id
 y4-20020a17090a784400b001e6914504dfmr5072255pjl.193.1654217095818; Thu, 02
 Jun 2022 17:44:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:50 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-44-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 043/144] KVM: selftests: Rename vm_create() =>
 vm_create_barebones(), drop param
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename vm_create() to vm_create_barebones() and drop the @phys_pages
param.  Pass '0' for the number of pages even though some callers pass
'DEFAULT_GUEST_PHY_PAGES', as the intent behind creating truly barebones
VMs is purely to create a VM, i.e. there aren't vCPUs, there's no guest
code loaded, etc..., and so there is nothing that will ever need or
consume guest memory.

Freeing up the name vm_create() will allow using the name for an inner
helper to the other VM creators, which need a "full" VM.

Opportunisticaly rewrite the function comment for addr_gpa2alias() to
focus on what the _function_ does, not what its _sole caller_ does.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      |  2 +-
 .../selftests/kvm/aarch64/vcpu_width_config.c |  6 ++--
 .../selftests/kvm/include/kvm_util_base.h     |  6 +++-
 .../selftests/kvm/kvm_binary_stats_test.c     |  2 +-
 .../selftests/kvm/kvm_create_max_vcpus.c      |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++----------------
 .../selftests/kvm/set_memory_region_test.c    |  4 +--
 .../kvm/x86_64/max_vcpuid_cap_test.c          |  2 +-
 .../selftests/kvm/x86_64/set_sregs_test.c     |  2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |  8 ++---
 10 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index ecfb773ec41e..d0c37a1b2a1f 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -416,7 +416,7 @@ static void run_test(struct vcpu_config *c)
 
 	check_supported(c);
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create_barebones();
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
 	finalize_vcpu(vm, 0, c);
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
index 4145c28a245a..1757f44dd3e2 100644
--- a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -24,7 +24,7 @@ static int add_init_2vcpus(struct kvm_vcpu_init *init1,
 	struct kvm_vm *vm;
 	int ret;
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create_barebones();
 
 	vm_vcpu_add(vm, 0);
 	ret = __vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
@@ -49,7 +49,7 @@ static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
 	struct kvm_vm *vm;
 	int ret;
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create_barebones();
 
 	vm_vcpu_add(vm, 0);
 	vm_vcpu_add(vm, 1);
@@ -86,7 +86,7 @@ int main(void)
 	}
 
 	/* Get the preferred target type and copy that to init2 for later use */
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create_barebones();
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init1);
 	kvm_vm_free(vm);
 	init2 = init1;
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c46c03750043..c119726ba018 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -248,7 +248,6 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
 struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages);
-struct kvm_vm *vm_create(uint64_t phy_pages);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
 void kvm_vm_release(struct kvm_vm *vmp);
@@ -596,6 +595,11 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+static inline struct kvm_vm *vm_create_barebones(void)
+{
+	return __vm_create(VM_MODE_DEFAULT, 0);
+}
+
 /*
  * Create a VM with reasonable defaults
  *
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 0a27b0f85009..edeb08239036 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -221,7 +221,7 @@ int main(int argc, char *argv[])
 	vms = malloc(sizeof(vms[0]) * max_vm);
 	TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
 	for (i = 0; i < max_vm; ++i) {
-		vms[i] = vm_create(DEFAULT_GUEST_PHY_PAGES);
+		vms[i] = vm_create_barebones();
 		for (j = 0; j < max_vcpu; ++j)
 			vm_vcpu_add(vms[i], j);
 	}
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index 9de5e1376c49..acc92703f563 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -28,7 +28,7 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 	pr_info("Testing creating %d vCPUs, with IDs %d...%d.\n",
 		num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create_barebones();
 
 	for (i = first_vcpu_id; i < first_vcpu_id + num_vcpus; i++)
 		/* This asserts that the vCPU was created. */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6b0b65c26d4d..ec2dfaa83af3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -258,26 +258,6 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
 	return vm;
 }
 
-/*
- * VM Create
- *
- * Input Args:
- *   phy_pages - Physical memory pages
- *
- * Output Args: None
- *
- * Return:
- *   Pointer to opaque structure that describes the created VM.
- *
- * Creates a VM with the default physical/virtual address widths and page size.
- * When phy_pages is non-zero, a memory region of phy_pages physical pages
- * is created and mapped starting at guest physical address 0.
- */
-struct kvm_vm *vm_create(uint64_t phy_pages)
-{
-	return __vm_create(VM_MODE_DEFAULT, phy_pages);
-}
-
 struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
 {
 	struct kvm_vm *vm;
@@ -1421,11 +1401,10 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
  *   (without failing the test) if the guest memory is not shared (so
  *   no alias exists).
  *
- * When vm_create() and related functions are called with a shared memory
- * src_type, we also create a writable, shared alias mapping of the
- * underlying guest memory. This allows the host to manipulate guest memory
- * without mapping that memory in the guest's address space. And, for
- * userfaultfd-based demand paging, we can do so without triggering userfaults.
+ * Create a writable, shared virtual=>physical alias for the specific GPA.
+ * The primary use case is to allow the host selftest to manipulate guest
+ * memory without mapping said memory in the guest's address space. And, for
+ * userfaultfd-based demand paging, to do so without triggering userfaults.
  */
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
 {
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index e66deb8ba7e0..c33402ba7587 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -314,7 +314,7 @@ static void test_zero_memory_regions(void)
 
 	pr_info("Testing KVM_RUN with zero added memory regions\n");
 
-	vm = vm_create(0);
+	vm = vm_create_barebones();
 	vm_vcpu_add(vm, VCPU_ID);
 
 	vm_ioctl(vm, KVM_SET_NR_MMU_PAGES, (void *)64ul);
@@ -353,7 +353,7 @@ static void test_add_max_memory_regions(void)
 		    "KVM_CAP_NR_MEMSLOTS should be greater than 0");
 	pr_info("Allowed number of memory slots: %i\n", max_mem_slots);
 
-	vm = vm_create(0);
+	vm = vm_create_barebones();
 
 	/* Check it can be added memory slots up to the maximum allowed */
 	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
index 7211fd8d5d24..3cc4b86832fe 100644
--- a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -16,7 +16,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	int ret;
 
-	vm = vm_create(0);
+	vm = vm_create_barebones();
 
 	/* Get KVM_CAP_MAX_VCPU_ID cap supported in KVM */
 	ret = vm_check_cap(vm, KVM_CAP_MAX_VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 4dc7fd925023..f5e65db9f451 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -95,7 +95,7 @@ int main(int argc, char *argv[])
 	 * use it to verify all supported CR4 bits can be set prior to defining
 	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
 	 */
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create_barebones();
 	vm_vcpu_add(vm, VCPU_ID);
 
 	vcpu_sregs_get(vm, VCPU_ID, &sregs);
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index e814748bf7ba..245fd0755390 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -53,7 +53,7 @@ static struct kvm_vm *sev_vm_create(bool es)
 	struct kvm_sev_launch_start start = { 0 };
 	int i;
 
-	vm = vm_create(0);
+	vm = vm_create_barebones();
 	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
 		vm_vcpu_add(vm, i);
@@ -70,7 +70,7 @@ static struct kvm_vm *aux_vm_create(bool with_vcpus)
 	struct kvm_vm *vm;
 	int i;
 
-	vm = vm_create(0);
+	vm = vm_create_barebones();
 	if (!with_vcpus)
 		return vm;
 
@@ -168,7 +168,7 @@ static void test_sev_migrate_parameters(void)
 		*sev_es_vm_no_vmsa;
 	int ret;
 
-	vm_no_vcpu = vm_create(0);
+	vm_no_vcpu = vm_create_barebones();
 	vm_no_sev = aux_vm_create(true);
 	ret = __sev_migrate_from(vm_no_vcpu, vm_no_sev);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
@@ -180,7 +180,7 @@ static void test_sev_migrate_parameters(void)
 
 	sev_vm = sev_vm_create(/* es= */ false);
 	sev_es_vm = sev_vm_create(/* es= */ true);
-	sev_es_vm_no_vmsa = vm_create(0);
+	sev_es_vm_no_vmsa = vm_create_barebones();
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
 	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
 
-- 
2.36.1.255.ge46751e96f-goog

