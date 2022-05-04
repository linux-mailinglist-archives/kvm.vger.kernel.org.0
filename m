Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB40651B273
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379368AbiEDWzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379492AbiEDWyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:14 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C812B6B
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o8-20020a17090a9f8800b001dc9f554c7fso1081468pjp.4
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9jXKE0rUZ9kYyhb9BST26AERA1zvCEHsctDG79q5cW4=;
        b=ehV0EQzd7Mn7PTAoQXcuqVwKk1QUJjsyl6vxkjSb9ZFy2V9VsbqTeabBVDS0YXb4p9
         Tl46g6Cej/wgmg+YDaTSaMmgT2AkbkfULqUJ/MJYztGI/OSO5GM/bHwsiCQGI6F84Ia7
         BgMfd/h2+uiyYD125aQ56GrIDwAj95cOXJCEDSOcQlGtjDB0B74fWy6LDLROGfw7m7Ka
         fmSbOlGapGRQp/JzqKB/sNtJqEjn16uA6/33uunTLhAUJnb/MCLvTrn9jJemp0na+lwO
         faG2wxNw6xP9PxCbDRzX6c4LIXGL4pGpOn6BJiyT6yQok/2QI3BALFBdk8SOJhKjY3FS
         tgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9jXKE0rUZ9kYyhb9BST26AERA1zvCEHsctDG79q5cW4=;
        b=7jk7MFeT1JKpl0laKDZ7vqt/cv7CRhCY6GLS87E9n78x61hypr80xM1R6npguyxNOf
         jVjrEnoc3CCOKopVR/ucidjj/zuS/Aj53aXMWH8Se6bQALtF7JkU+gNIvEYNpgRNbiAW
         CbMfujHkEChTOhs7w2ruXJQCdkj5QKLg3TVBuejFQtXHONSgzsVZsTzQZ+i8NEDuzDB1
         cDxFcmJxSENc0I997yHclOWWFgcihgDoAArhygjJVy78P+X2ezM8IdlECbKlkFiud0Eq
         BU33og5ZAoL1lYto2RyWsPGONvxHu6rriBZu1RE+w4rcsj37fiKkEB9fIx84sFhmO6Zc
         j84Q==
X-Gm-Message-State: AOAM532mJwiHgS03meBjyreAEShYTtq6Wu5Bs4AYXkMK1i1jTeMHnrZy
        D4ATuQo2qNQOjYw+FkLIuH3CPyBqcrw=
X-Google-Smtp-Source: ABdhPJxKrO6FhJD0GBjJ37zsGyDmHvQ1m4srx0cCKwqAQuGA6FjOI7CtuFKltlYmmrFu8a4Axbk9eSeViQM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2284:b0:50a:40b8:28ff with SMTP id
 f4-20020a056a00228400b0050a40b828ffmr23096615pfe.17.1651704635443; Wed, 04
 May 2022 15:50:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:43 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-38-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 037/128] KVM: selftests: Make vm_create() a wrapper that
 specifies VM_MODE_DEFAULT
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

Add ____vm_create() to be the innermost helper, and turn vm_create() into
a wrapper the specifies VM_MODE_DEFAULT.  Most of the vm_create() callers
just want the default mode, or more accurately, don't care about the mode.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/psci_cpu_on_test.c   |  2 +-
 tools/testing/selftests/kvm/dirty_log_test.c   |  2 +-
 .../selftests/kvm/hardware_disable_test.c      |  2 +-
 .../selftests/kvm/include/kvm_util_base.h      | 18 +++++++++++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c     | 16 ++++++++--------
 .../kvm/x86_64/pmu_event_filter_test.c         |  2 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c     |  2 +-
 7 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 4dc04a12f527..d60c1ddf8870 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -76,7 +76,7 @@ int main(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index aa7eb01ad25f..66ee00b45847 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -677,7 +677,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
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
index 48a4000222c1..136b5428ae0e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -239,7 +239,6 @@ static inline void vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
 void kvm_vm_release(struct kvm_vm *vmp);
@@ -594,9 +593,21 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
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
@@ -628,9 +639,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				    uint32_t num_percpu_pages, void *guest_code,
 				    uint32_t vcpuids[]);
 
-/* Create a default VM without any vcpus. */
-struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t pages);
-
 /*
  * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
  * additional pages of guest memory.  Returns the VM and vCPU (via out param).
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 632912aeaeb9..73247afa7265 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -153,12 +153,12 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
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
@@ -255,20 +255,20 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
 
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
 
@@ -327,7 +327,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	vm = vm_create(mode, pages);
+	vm = __vm_create(mode, pages);
 
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index d80b0a408937..93af4ad728d8 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -340,7 +340,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 	if (!(r & KVM_PMU_CAP_DISABLE))
 		return;
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
 
 	cap.cap = KVM_CAP_PMU_CAPABILITY;
 	cap.args[0] = KVM_PMU_CAP_DISABLE;
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
2.36.0.464.gb9c8b46e94-goog

