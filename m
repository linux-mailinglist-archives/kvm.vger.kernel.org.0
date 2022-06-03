Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100A253C1C4
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbiFCAqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240193AbiFCApB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF22C2251B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:59 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a65624d000000b003fa74c57243so3040978pgv.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OtnB0qk+iHL7LWZoC6KIC/IWoBaMp3LgvsGvrwpciTI=;
        b=SM5hZsOCJnjzjmKXvwwuoO5XQ+Tb91+teZOF/lDAtfmI/lpiVFFiivLkMA1forFpem
         HMP3B3y/tNyKbkK0FJ3m0J4eLvIz3ccNt7t4FYCj1ba7+NuS6TMjP0R6x9cXXPcu4jYf
         +uvg5OvR7N+vFk59BM2TqGjzUAcaW42atTHlUo1NRRBf2VFcA60LuMPwzxPyI/NU8IIa
         HFnaNINKGsWb3UFQucBFxuqvvhQsGz0an+odi09ifwWgnJeiS0FHFEtSFmbAadqJbsI8
         OnRHCoGNGAHiUT1JdsaR9guR0WgnHFr+HhzLK5vveMdwwfCRz6y2UbHtsuOfrMGvXCJg
         DaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OtnB0qk+iHL7LWZoC6KIC/IWoBaMp3LgvsGvrwpciTI=;
        b=wyclp1gceC1KiXJGxblauMf9lolFLoIvMbZHtyDyzdQM/iHmcxkih1mncCo6ZTMAa4
         DbTiRnnv7aczh6ymNI2Q4oSlROCb5b73AQAy7UvivogSQuPVJFFBO8P6wpqlCvKH1tuQ
         jMYWPX2csnMOmnc/7G4Oq/8iV5JEwAeAdb6nFYOvMbv2jt9ZrHvE6ORDaKRFdt3dApGI
         Hcf8/S9ABLkHi+vETAQY3XEtOngjgTB3fVHlzeK8N59iyYWLQv4xOvNEiANVkRXAiG5r
         V+mi4qaCK4wEqwtwwkYGMEmx3QClEDu/+sm0lw+aEQhAVSNxrfe18xHh/mHYnCPSosd9
         pvyA==
X-Gm-Message-State: AOAM531jaTzTTC9Iog6qbTw2aECGivvaQjk5CNDBWoA9a2C23v4peQOo
        +4extTHkN+zq+lcosZnWdjcWBfDw0Fs=
X-Google-Smtp-Source: ABdhPJz5PHPfFJRawUL9QMmJ/p/TLAMrjh+Ke3TEZk/Ktj9HOT8z4NC6EhfF1CehkKlF2+tE0gqokaAcQ5c=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2396:b0:51b:3ee1:e46e with SMTP id
 f22-20020a056a00239600b0051b3ee1e46emr7862959pfc.17.1654217099317; Thu, 02
 Jun 2022 17:44:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:52 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-46-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 045/144] KVM: selftests: Make vm_create() a wrapper that
 specifies VM_MODE_DEFAULT
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

Add ____vm_create() to be the innermost helper, and turn vm_create() into
a wrapper the specifies VM_MODE_DEFAULT.  Most of the vm_create() callers
just want the default mode, or more accurately, don't care about the mode.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c  |  2 +-
 tools/testing/selftests/kvm/dirty_log_test.c   |  2 +-
 .../selftests/kvm/hardware_disable_test.c      |  2 +-
 .../selftests/kvm/include/kvm_util_base.h      | 18 +++++++++++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c     | 16 ++++++++--------
 .../kvm/x86_64/pmu_event_filter_test.c         |  2 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c     |  2 +-
 7 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index ffa0cdc0ab3d..fa4e6c3343d7 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -78,7 +78,7 @@ static struct kvm_vm *setup_vm(void *guest_code)
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index b921d0b45647..cf426a8ae816 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -674,7 +674,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
+	vm = __vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
 
 	log_mode_create_vm_done(vm);
 	vm_vcpu_add_default(vm, vcpuid, guest_code);
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 299862a85b8d..ccbbf8783e2d 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -104,7 +104,7 @@ static void run_test(uint32_t run)
 	for (i = 0; i < VCPU_NUM; i++)
 		CPU_SET(i, &cpu_set);
 
-	vm  = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm  = vm_create(DEFAULT_GUEST_PHY_PAGES);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b09ef551d61b..6418b1c04bc0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -247,7 +247,6 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
 void kvm_vm_release(struct kvm_vm *vmp);
@@ -595,9 +594,21 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+/*
+ * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
+ * loads the test binary into guest memory and creates an IRQ chip (x86 only).
+ */
+struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+
 static inline struct kvm_vm *vm_create_barebones(void)
 {
-	return __vm_create(VM_MODE_DEFAULT, 0);
+	return ____vm_create(VM_MODE_DEFAULT, 0);
+}
+
+static inline struct kvm_vm *vm_create(uint64_t nr_pages)
+{
+	return __vm_create(VM_MODE_DEFAULT, nr_pages);
 }
 
 /*
@@ -629,9 +640,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				    uint32_t num_percpu_pages, void *guest_code,
 				    uint32_t vcpuids[]);
 
-/* Create a default VM without any vcpus. */
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t pages);
-
 /*
  * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
  * additional pages of guest memory.  Returns the VM and vCPU (via out param).
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 227b306b6efe..76ac1c50c3e7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -149,12 +149,12 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
+struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 {
 	struct kvm_vm *vm;
 
 	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
-		 vm_guest_mode_string(mode), phy_pages);
+		 vm_guest_mode_string(mode), nr_pages);
 
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
@@ -251,20 +251,20 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
-	if (phy_pages != 0)
+	if (nr_pages != 0)
 		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, phy_pages, 0);
+					    0, 0, nr_pages, 0);
 
 	return vm;
 }
 
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t pages)
+struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 {
 	struct kvm_vm *vm;
 
-	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
+	nr_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, nr_pages);
 
-	vm = __vm_create(mode, pages);
+	vm = ____vm_create(mode, nr_pages);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
@@ -323,7 +323,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	vm = vm_create(mode, pages);
+	vm = __vm_create(mode, pages);
 
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 7eb325466fbc..640b1a1ab3df 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -339,7 +339,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 	if (!(r & KVM_PMU_CAP_DISABLE))
 		return;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 
 	vm_enable_cap(vm, KVM_CAP_PMU_CAPABILITY, KVM_PMU_CAP_DISABLE);
 
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 6bc13cf17220..9ba3cd4e7f20 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -86,7 +86,7 @@ static struct kvm_vm *create_vm(void)
 	uint64_t extra_pg_pages = vcpu_pages / PTES_PER_MIN_PAGE * N_VCPU;
 	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
-	return vm_create(VM_MODE_DEFAULT, pages);
+	return vm_create(pages);
 }
 
 static void add_x86_vcpu(struct kvm_vm *vm, uint32_t vcpuid, bool bsp_code)
-- 
2.36.1.255.ge46751e96f-goog

