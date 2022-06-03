Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6B953C2D4
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241009AbiFCAzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241430AbiFCAvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:51:06 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D1434B97
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:46 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h10-20020a170902f54a00b00166449db7f8so1563073plf.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HKE2QNYAlmUb/mlIyUuyBK2fl4XWFlXiXhq504LYE1E=;
        b=TPwexv+oA9/pziWEcJkkW6PKE1GS7EMq8rfcwtiYxwan8fZGrwhnH1tfGkPp7nnfym
         W5fNAa/jd7Txqd2M4eF8sK8p6YDjRs0n6PgrQCVzKU2WbZiPwqneiFf/lA2ws4jMXfiF
         nzs1SmG5X17pBep+dW2GY/b1R+vkfIJNVlcKGYlKrGVhUXQF+Zq1x3IfhfDXgQpMlA9j
         TkUa8pSFrHM81RfY5a4Y5wDcBCifzWCiNlyU/CIAmLCy4qPzqV2pht/k9rT+Vs13UD74
         KvIbw7R5boT6dS8bJZDP3Eg+0PgVBkVScQfgZkoXDUS3+D/+I45HumCh8cBUwBpBtW6c
         CSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HKE2QNYAlmUb/mlIyUuyBK2fl4XWFlXiXhq504LYE1E=;
        b=RemabKIijjSl3/uxIUiuHb20W9ZwU+iCTlno5wFlkcwlHk/61wG7UiN1S35CK+QNSo
         K7wbpBO3eZlHTL+n3Ymv5xLm86kTyPPmUudbjLWb0BIaRB4m1m3JdaTU9OBnEjNCNG2J
         d4tNKvPvhKZYZR00+C6vmy6gO9RJVKL0hbvq84mdl3YncTuI2Es7cSRP/kwTfYl3nyWM
         VRt4+eH2ycIu4ckmpiOUFIMybmYcfzeZaCsX2tQiHDqSvT8+g5z6OfUK4cGMtg4E+Vxy
         N4bBDpopv0nDrfX5H6Ean0QIYe9T/ZuVWA22VkhYa3JcUr1tbbqce8X6zp+YI4hJzCE2
         i2JA==
X-Gm-Message-State: AOAM533m/WZ66/XNdfwZ8E46UdQli0MLz2WFOva9ay4psJod1d50wrjD
        nq3vI8cr6I+R1IfS39T4x/YcZexZwjU=
X-Google-Smtp-Source: ABdhPJwPNcbxhSWKehOviLkABXsRR5wDj5/8Brl5wwA1Y5fqDWPATjf210fIgG9/5y2xnoSmquLiuqWAODI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c3:b0:166:303e:124a with SMTP id
 e3-20020a17090301c300b00166303e124amr7463156plh.7.1654217265777; Thu, 02 Jun
 2022 17:47:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:25 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-139-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 138/144] KVM: selftests: Move per-VM/per-vCPU nr pages
 calculation to __vm_create()
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

Handle all memslot0 size adjustments in __vm_create().  Currently, the
adjustments reside in __vm_create_with_vcpus(), which means tests that
call vm_create() or __vm_create() directly are left to their own devices.
Some tests just pass DEFAULT_GUEST_PHY_PAGES and don't bother with any
adjustments, while others mimic the per-vCPU calculations.

For vm_create(), and thus __vm_create(), take the number of vCPUs that
will be runnable to calculate that number of per-vCPU pages needed for
memslot0.  To give readers a hint that neither vm_create() nor
__vm_create() create vCPUs, name the parameter @nr_runnable_vcpus instead
of @nr_vcpus.  That also gives readers a hint as to why tests that create
larger numbers of vCPUs but never actually run those vCPUs can skip
straight to the vm_create_barebones() variant.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c |  2 +-
 .../testing/selftests/kvm/aarch64/vgic_init.c |  4 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  3 +-
 .../selftests/kvm/hardware_disable_test.c     |  2 +-
 .../selftests/kvm/include/kvm_util_base.h     |  9 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 56 ++++++++++++-------
 tools/testing/selftests/kvm/s390x/resets.c    |  2 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  5 +-
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  2 +-
 10 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 3e1bebe63adf..7928c62635fd 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -76,7 +76,7 @@ static struct kvm_vm *setup_vm(void *guest_code, struct kvm_vcpu **source,
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(2);
 	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 7ee10f02d4bf..56b76fbfffea 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -403,7 +403,7 @@ static void test_v3_typer_accesses(void)
 	uint32_t val;
 	int ret, i;
 
-	v.vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	v.vm = vm_create(NR_VCPUS);
 	(void)vm_vcpu_add(v.vm, 0, guest_code);
 
 	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
@@ -472,7 +472,7 @@ static struct vm_gic vm_gic_v3_create_with_vcpuids(int nr_vcpus,
 	struct vm_gic v;
 	int i;
 
-	v.vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	v.vm = vm_create(nr_vcpus);
 	for (i = 0; i < nr_vcpus; i++)
 		vm_vcpu_add(v.vm, vcpuids[i], guest_code);
 
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ca584b9bf5c0..8542f713a101 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -669,11 +669,10 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 				uint64_t extra_mem_pages, void *guest_code)
 {
 	struct kvm_vm *vm;
-	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = __vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
+	vm = __vm_create(mode, 1, extra_mem_pages);
 
 	log_mode_create_vm_done(vm);
 	*vcpu = vm_vcpu_add(vm, 0, guest_code);
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index f5eecd51fe70..5d58e52dc382 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -98,7 +98,7 @@ static void run_test(uint32_t run)
 	for (i = 0; i < VCPU_NUM; i++)
 		CPU_SET(i, &cpu_set);
 
-	vm  = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm  = vm_create(VCPU_NUM);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6143d45a02a7..db9c00a7af4e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -547,18 +547,21 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
+ * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
+ * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
 struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
+			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
 	return ____vm_create(VM_MODE_DEFAULT, 0);
 }
 
-static inline struct kvm_vm *vm_create(uint64_t nr_pages)
+static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
 {
-	return __vm_create(VM_MODE_DEFAULT, nr_pages);
+	return __vm_create(VM_MODE_DEFAULT, nr_runnable_vcpus, 0);
 }
 
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 508a5eafe15b..494bce490344 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -258,12 +258,45 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 	return vm;
 }
 
-struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
+static uint64_t vm_nr_pages_required(uint32_t nr_runnable_vcpus,
+				     uint64_t extra_mem_pages)
 {
+	uint64_t nr_pages;
+
+	TEST_ASSERT(nr_runnable_vcpus,
+		    "Use vm_create_barebones() for VMs that _never_ have vCPUs\n");
+
+	TEST_ASSERT(nr_runnable_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
+		    "nr_vcpus = %d too large for host, max-vcpus = %d",
+		    nr_runnable_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
+
+	nr_pages = DEFAULT_GUEST_PHY_PAGES;
+	nr_pages += nr_runnable_vcpus * DEFAULT_STACK_PGS;
+
+	/*
+	 * Account for the number of pages needed for the page tables.  The
+	 * maximum page table size for a memory region will be when the
+	 * smallest page size is used. Considering each page contains x page
+	 * table descriptors, the total extra size for page tables (for extra
+	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
+	 * than N/x*2.
+	 */
+	nr_pages += (nr_pages + extra_mem_pages) / PTES_PER_MIN_PAGE * 2;
+
+	TEST_ASSERT(nr_runnable_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
+		    "Host doesn't support %d vCPUs, max-vcpus = %d",
+		    nr_runnable_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
+
+	return vm_adjust_num_guest_pages(VM_MODE_DEFAULT, nr_pages);
+}
+
+struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
+			   uint64_t nr_extra_pages)
+{
+	uint64_t nr_pages = vm_nr_pages_required(nr_runnable_vcpus,
+						 nr_extra_pages);
 	struct kvm_vm *vm;
 
-	nr_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, nr_pages);
-
 	vm = ____vm_create(mode, nr_pages);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
@@ -297,27 +330,12 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
-	uint64_t vcpu_pages, extra_pg_pages, pages;
 	struct kvm_vm *vm;
 	int i;
 
 	TEST_ASSERT(!nr_vcpus || vcpus, "Must provide vCPU array");
 
-	/* The maximum page table size for a memory region will be when the
-	 * smallest pages are used. Considering each page contains x page
-	 * table descriptors, the total extra size for page tables (for extra
-	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
-	 * than N/x*2.
-	 */
-	vcpu_pages = nr_vcpus * DEFAULT_STACK_PGS;
-	extra_pg_pages = (DEFAULT_GUEST_PHY_PAGES + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
-	pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
-
-	TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
-		    "nr_vcpus = %d too large for host, max-vcpus = %d",
-		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
-
-	vm = __vm_create(mode, pages);
+	vm = __vm_create(mode, nr_vcpus, extra_mem_pages);
 
 	for (i = 0; i < nr_vcpus; ++i)
 		vcpus[i] = vm_vcpu_add(vm, i, guest_code);
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index 43fa71d90232..4ba866047401 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -205,7 +205,7 @@ static struct kvm_vm *create_vm(struct kvm_vcpu **vcpu)
 {
 	struct kvm_vm *vm;
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(1);
 
 	*vcpu = vm_vcpu_add(vm, ARBITRARY_NON_ZERO_VCPU_ID, guest_code_initial);
 
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 012741176ae4..ffa6a2f93de2 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -339,7 +339,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 	if (!(r & KVM_PMU_CAP_DISABLE))
 		return;
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(1);
 
 	vm_enable_cap(vm, KVM_CAP_PMU_CAPABILITY, KVM_PMU_CAP_DISABLE);
 
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index afc063178c6a..8bcaf4421dc5 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -78,13 +78,10 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 static struct kvm_vm *create_vm(uint32_t nr_vcpus, uint32_t bsp_vcpu_id,
 				struct kvm_vcpu *vcpus[])
 {
-	uint64_t vcpu_pages = (DEFAULT_STACK_PGS) * nr_vcpus;
-	uint64_t extra_pg_pages = vcpu_pages / PTES_PER_MIN_PAGE * nr_vcpus;
-	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 	struct kvm_vm *vm;
 	uint32_t i;
 
-	vm = vm_create(pages);
+	vm = vm_create(nr_vcpus);
 
 	vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)(unsigned long)bsp_vcpu_id);
 
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index e416af887ca0..4a962952212e 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -98,7 +98,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES + DEFAULT_STACK_PGS * NR_TEST_VCPUS);
+	vm = vm_create(NR_TEST_VCPUS);
 	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
 
 	pthread_spin_init(&create_lock, PTHREAD_PROCESS_PRIVATE);
-- 
2.36.1.255.ge46751e96f-goog

