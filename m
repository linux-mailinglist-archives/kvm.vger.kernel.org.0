Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D72E53C2AF
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbiFCArS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239980AbiFCAof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DDD2250E
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i17-20020a259d11000000b0064cd3084085so5598573ybp.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=FLfNaN4AMYS/YpahD61k9EPS8BL7sEKjsl8i5J/emZI=;
        b=cf51+piYsCKe+6tdn1Nmhaci4rLfeoYHyZ4KCrfj0eRiJJPi01bFAplygN236exDXL
         goiIkY5ZX+g2O9UnnxRl2rSN9dwLbqd/B+t3OP7mnsESw6XG35Fc6zDhofG7qH7o5t4M
         15clQtSkpnRgF45hk/QlJU2mTw5zxSsVpDDsN31z1Ig3Z/eBE3J1dO5exSXnwJkL5gfr
         VU6yJNDhEZ8Gw/VU3imr2DFTZtGu3XpzzNESWMUcDyPrnOTZJ3hl/MQop0uy3JpxcamM
         CJbr127Mshb6V31bONLYBheR8fII6nQpgiCv3drEUa2Es30dHKqrR6r7PI0iUXntofI2
         +SMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=FLfNaN4AMYS/YpahD61k9EPS8BL7sEKjsl8i5J/emZI=;
        b=4//xSa3AqAEfKIExTnVCoZIPrlZPF3tLJFDwc5JfEtII2oVDSD6NaEocUVgQcNwBXP
         XQUDMflzvHDH3tSKpz6lNllUl6BLoqJFNE9ihgdKjGraP2Qy9TApWbrI0JWKu9WjkHAB
         FQ4TK9tMO0H1ziMbbTm2TIaINy22h3JOZE8s+lBirH44Zz5lXp3zfhOTIy9CMGLGkiRa
         BfmNGMvoun8bs0Qd54OuMpZ0f2cErDAM4MhIBVsQVBMHttgn3XIV0nv55IqYhpGsGKAq
         pPB76hL6WPjX16ejqjJutmHCufGAouTFy8l0EPxZDOQQVL3AXStbpNwlvtl7sYaILA4h
         jMsg==
X-Gm-Message-State: AOAM533ELHCKklue9XhIN0919SL6XUKh1LI1vGHSXA/Jwm1udIJSYAAo
        l5EuWNpE3V3jSJa1ZgnSVmH/vCzD4Ig=
X-Google-Smtp-Source: ABdhPJyEVY5GTGSM2ki2udgbeZ3Ukuf0TmeDDvc3PK+JTizpkDWhm/hIO+0QyD17ghBtrGjGw77seZtosDU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a0d:ef03:0:b0:2fa:245:adf3 with SMTP id
 y3-20020a0def03000000b002fa0245adf3mr8911991ywe.100.1654217072961; Thu, 02
 Jun 2022 17:44:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:38 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-32-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 031/144] KVM: selftests: Simplify KVM_ENABLE_CAP helper APIs
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

Rework the KVM_ENABLE_CAP helpers to take the cap and arg0; literally
every current user, and likely every future user, wants to set 0 or 1
arguments and nothing else.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 11 +------
 .../selftests/kvm/dirty_log_perf_test.c       |  9 ++----
 tools/testing/selftests/kvm/dirty_log_test.c  |  5 +--
 .../selftests/kvm/include/kvm_util_base.h     | 18 +++++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    |  6 +---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  8 ++---
 .../kvm/x86_64/emulator_error_test.c          |  6 +---
 .../selftests/kvm/x86_64/fix_hypercall_test.c |  6 ++--
 .../selftests/kvm/x86_64/hyperv_features.c    | 16 ++--------
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  5 +--
 .../kvm/x86_64/max_vcpuid_cap_test.c          | 12 ++-----
 .../selftests/kvm/x86_64/platform_info_test.c | 14 ++-------
 .../kvm/x86_64/pmu_event_filter_test.c        |  5 +--
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 14 ++-------
 .../kvm/x86_64/triple_fault_event_test.c      |  7 +----
 .../kvm/x86_64/userspace_msr_exit_test.c      | 31 +++++++------------
 16 files changed, 47 insertions(+), 126 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 024a84064f1f..1a351f3f443d 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -156,15 +156,6 @@ static void host_test_cpu_on(void)
 	kvm_vm_free(vm);
 }
 
-static void enable_system_suspend(struct kvm_vm *vm)
-{
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
-	};
-
-	vm_enable_cap(vm, &cap);
-}
-
 static void guest_test_system_suspend(void)
 {
 	uint64_t ret;
@@ -183,7 +174,7 @@ static void host_test_system_suspend(void)
 	struct kvm_vm *vm;
 
 	vm = setup_vm(guest_test_system_suspend);
-	enable_system_suspend(vm);
+	vm_enable_cap(vm, KVM_CAP_ARM_SYSTEM_SUSPEND, 0);
 
 	vcpu_power_off(vm, VCPU_ID_TARGET);
 	run = vcpu_state(vm, VCPU_ID_SOURCE);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 7b47ae4f952e..c9acf0c3f016 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -213,7 +213,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec get_dirty_log_total = (struct timespec){0};
 	struct timespec vcpu_dirty_total = (struct timespec){0};
 	struct timespec avg;
-	struct kvm_enable_cap cap = {};
 	struct timespec clear_dirty_log_total = (struct timespec){0};
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
@@ -229,11 +228,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	bitmaps = alloc_bitmaps(p->slots, pages_per_slot);
 
-	if (dirty_log_manual_caps) {
-		cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-		cap.args[0] = dirty_log_manual_caps;
-		vm_enable_cap(vm, &cap);
-	}
+	if (dirty_log_manual_caps)
+		vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
+			      dirty_log_manual_caps);
 
 	arch_setup_vm(vm, nr_vcpus);
 
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 5752486764c9..9dfc861a3cf3 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -217,16 +217,13 @@ static bool clear_log_supported(void)
 
 static void clear_log_create_vm_done(struct kvm_vm *vm)
 {
-	struct kvm_enable_cap cap = {};
 	u64 manual_caps;
 
 	manual_caps = kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
 	TEST_ASSERT(manual_caps, "MANUAL_CAPS is zero!");
 	manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
 			KVM_DIRTY_LOG_INITIALLY_SET);
-	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-	cap.args[0] = manual_caps;
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, manual_caps);
 }
 
 static void dirty_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f0afc1dce8ba..c9d94c9f2031 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -231,13 +231,17 @@ static inline int vm_check_cap(struct kvm_vm *vm, long cap)
 	return ret;
 }
 
-static inline int __vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
+static inline int __vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 {
-	return __vm_ioctl(vm, KVM_ENABLE_CAP, cap);
+	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
+
+	return __vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
-static inline void vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
+static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 {
-	vm_ioctl(vm, KVM_ENABLE_CAP, cap);
+	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
+
+	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
@@ -363,9 +367,11 @@ void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid);
 
 static inline void vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
-				   struct kvm_enable_cap *cap)
+				   uint32_t cap, uint64_t arg0)
 {
-	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, cap);
+	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
+
+	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, &enable_cap);
 }
 
 static inline void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2d82b5720737..8f670cef6faa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -85,11 +85,7 @@ int kvm_check_cap(long cap)
 
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 {
-	struct kvm_enable_cap cap = { 0 };
-
-	cap.cap = KVM_CAP_DIRTY_LOG_RING;
-	cap.args[0] = ring_size;
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING, ring_size);
 	vm->dirty_ring_size = ring_size;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 14a9a0fd2e50..2ab3f13e221d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -46,12 +46,8 @@ int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id)
 {
 	uint16_t evmcs_ver;
 
-	struct kvm_enable_cap enable_evmcs_cap = {
-		.cap = KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
-		 .args[0] = (unsigned long)&evmcs_ver
-	};
-
-	vcpu_enable_cap(vm, vcpu_id, &enable_evmcs_cap);
+	vcpu_enable_cap(vm, vcpu_id, KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
+			(unsigned long)&evmcs_ver);
 
 	/* KVM should return supported EVMCS version range */
 	TEST_ASSERT(((evmcs_ver >> 8) >= (evmcs_ver & 0xff)) &&
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index aeb3850f81bd..9c156f9cfa15 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -161,10 +161,6 @@ static uint64_t process_ucall(struct kvm_vm *vm)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_enable_cap emul_failure_cap = {
-		.cap = KVM_CAP_EXIT_ON_EMULATION_FAILURE,
-		.args[0] = 1,
-	};
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_cpuid2 *cpuid;
 	struct kvm_vm *vm;
@@ -192,7 +188,7 @@ int main(int argc, char *argv[])
 
 	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
 	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
-	vm_enable_cap(vm, &emul_failure_cap);
+	vm_enable_cap(vm, KVM_CAP_EXIT_ON_EMULATION_FAILURE, 1);
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    MEM_REGION_GPA, MEM_REGION_SLOT,
diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index 1f5c32146f3d..81f9f5b1f655 100644
--- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -140,15 +140,13 @@ static void test_fix_hypercall(void)
 
 static void test_fix_hypercall_disabled(void)
 {
-	struct kvm_enable_cap cap = {0};
 	struct kvm_vm *vm;
 
 	vm = vm_create_default(VCPU_ID, 0, guest_main);
 	setup_ud_vector(vm);
 
-	cap.cap = KVM_CAP_DISABLE_QUIRKS2;
-	cap.args[0] = KVM_X86_QUIRK_FIX_HYPERCALL_INSN;
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2,
+		      KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
 
 	ud_expected = true;
 	sync_global_to_guest(vm, ud_expected);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 672915ce73d8..7ff6e4d70333 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -182,10 +182,6 @@ static void guest_test_msrs_access(void)
 	};
 	struct kvm_cpuid2 *best;
 	vm_vaddr_t msr_gva;
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
-		.args = {1}
-	};
 	struct msr_data *msr;
 
 	while (true) {
@@ -196,7 +192,7 @@ static void guest_test_msrs_access(void)
 		msr = addr_gva2hva(vm, msr_gva);
 
 		vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
-		vcpu_enable_cap(vm, VCPU_ID, &cap);
+		vcpu_enable_cap(vm, VCPU_ID, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
 
 		vcpu_set_hv_cpuid(vm, VCPU_ID);
 
@@ -337,9 +333,7 @@ static void guest_test_msrs_access(void)
 			 * Remains unavailable even with KVM_CAP_HYPERV_SYNIC2
 			 * capability enabled and guest visible CPUID bit unset.
 			 */
-			cap.cap = KVM_CAP_HYPERV_SYNIC2;
-			cap.args[0] = 0;
-			vcpu_enable_cap(vm, VCPU_ID, &cap);
+			vcpu_enable_cap(vm, VCPU_ID, KVM_CAP_HYPERV_SYNIC2, 0);
 			break;
 		case 22:
 			feat.eax |= HV_MSR_SYNIC_AVAILABLE;
@@ -518,10 +512,6 @@ static void guest_test_hcalls_access(void)
 	struct kvm_cpuid_entry2 dbg = {
 		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 	};
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
-		.args = {1}
-	};
 	vm_vaddr_t hcall_page, hcall_params;
 	struct hcall_data *hcall;
 	struct kvm_cpuid2 *best;
@@ -542,7 +532,7 @@ static void guest_test_hcalls_access(void)
 		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
 
 		vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
-		vcpu_enable_cap(vm, VCPU_ID, &cap);
+		vcpu_enable_cap(vm, VCPU_ID, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
 
 		vcpu_set_hv_cpuid(vm, VCPU_ID);
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 04ed975662c9..5eea3ac7958e 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -206,7 +206,6 @@ static void enter_guest(struct kvm_vm *vm)
 
 int main(void)
 {
-	struct kvm_enable_cap cap = {0};
 	struct kvm_cpuid2 *best;
 	struct kvm_vm *vm;
 
@@ -217,9 +216,7 @@ int main(void)
 
 	vm = vm_create_default(VCPU_ID, 0, guest_main);
 
-	cap.cap = KVM_CAP_ENFORCE_PV_FEATURE_CPUID;
-	cap.args[0] = 1;
-	vcpu_enable_cap(vm, VCPU_ID, &cap);
+	vcpu_enable_cap(vm, VCPU_ID, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 1);
 
 	best = kvm_get_supported_cpuid();
 	clear_kvm_cpuid_features(best);
diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
index c6fd36a31c8c..7211fd8d5d24 100644
--- a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -14,7 +14,6 @@
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	struct kvm_enable_cap cap = { 0 };
 	int ret;
 
 	vm = vm_create(0);
@@ -23,21 +22,16 @@ int main(int argc, char *argv[])
 	ret = vm_check_cap(vm, KVM_CAP_MAX_VCPU_ID);
 
 	/* Try to set KVM_CAP_MAX_VCPU_ID beyond KVM cap */
-	cap.cap = KVM_CAP_MAX_VCPU_ID;
-	cap.args[0] = ret + 1;
-	ret = __vm_enable_cap(vm, &cap);
+	ret = __vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, ret + 1);
 	TEST_ASSERT(ret < 0,
 		    "Setting KVM_CAP_MAX_VCPU_ID beyond KVM cap should fail");
 
 	/* Set KVM_CAP_MAX_VCPU_ID */
-	cap.cap = KVM_CAP_MAX_VCPU_ID;
-	cap.args[0] = MAX_VCPU_ID;
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, MAX_VCPU_ID);
 
 
 	/* Try to set KVM_CAP_MAX_VCPU_ID again */
-	cap.args[0] = MAX_VCPU_ID + 1;
-	ret = __vm_enable_cap(vm, &cap);
+	ret = __vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, MAX_VCPU_ID + 1);
 	TEST_ASSERT(ret < 0,
 		    "Setting KVM_CAP_MAX_VCPU_ID multiple times should fail");
 
diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index 1e89688cbbbf..e79c04581ca8 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -35,22 +35,12 @@ static void guest_code(void)
 	}
 }
 
-static void set_msr_platform_info_enabled(struct kvm_vm *vm, bool enable)
-{
-	struct kvm_enable_cap cap = {};
-
-	cap.cap = KVM_CAP_MSR_PLATFORM_INFO;
-	cap.flags = 0;
-	cap.args[0] = (int)enable;
-	vm_enable_cap(vm, &cap);
-}
-
 static void test_msr_platform_info_enabled(struct kvm_vm *vm)
 {
 	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 	struct ucall uc;
 
-	set_msr_platform_info_enabled(vm, true);
+	vm_enable_cap(vm, KVM_CAP_MSR_PLATFORM_INFO, true);
 	vcpu_run(vm, VCPU_ID);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			"Exit_reason other than KVM_EXIT_IO: %u (%s),\n",
@@ -69,7 +59,7 @@ static void test_msr_platform_info_disabled(struct kvm_vm *vm)
 {
 	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 
-	set_msr_platform_info_enabled(vm, false);
+	vm_enable_cap(vm, KVM_CAP_MSR_PLATFORM_INFO, false);
 	vcpu_run(vm, VCPU_ID);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
 			"Exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s)\n",
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 269033af43ce..4f4519c0cdb1 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -334,7 +334,6 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 {
 	int r;
 	struct kvm_vm *vm;
-	struct kvm_enable_cap cap = { 0 };
 
 	r = kvm_check_cap(KVM_CAP_PMU_CAPABILITY);
 	if (!(r & KVM_PMU_CAP_DISABLE))
@@ -342,9 +341,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 
 	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
-	cap.cap = KVM_CAP_PMU_CAPABILITY;
-	cap.args[0] = KVM_PMU_CAP_DISABLE;
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_PMU_CAPABILITY, KVM_PMU_CAP_DISABLE);
 
 	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
 	vm_init_descriptor_tables(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index f127f2fccca6..e814748bf7ba 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -82,12 +82,7 @@ static struct kvm_vm *aux_vm_create(bool with_vcpus)
 
 static int __sev_migrate_from(struct kvm_vm *dst, struct kvm_vm *src)
 {
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM,
-		.args = { src->fd }
-	};
-
-	return __vm_enable_cap(dst, &cap);
+	return __vm_enable_cap(dst, KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM, src->fd);
 }
 
 
@@ -223,12 +218,7 @@ static void test_sev_migrate_parameters(void)
 
 static int __sev_mirror_create(struct kvm_vm *dst, struct kvm_vm *src)
 {
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_VM_COPY_ENC_CONTEXT_FROM,
-		.args = { src->fd }
-	};
-
-	return __vm_enable_cap(dst, &cap);
+	return __vm_enable_cap(dst, KVM_CAP_VM_COPY_ENC_CONTEXT_FROM, src->fd);
 }
 
 
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
index 66378140764d..68e0f1c5ec5a 100644
--- a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -46,11 +46,6 @@ int main(void)
 	vm_vaddr_t vmx_pages_gva;
 	struct ucall uc;
 
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_X86_TRIPLE_FAULT_EVENT,
-		.args = {1}
-	};
-
 	if (!nested_vmx_supported()) {
 		print_skip("Nested VMX not supported");
 		exit(KSFT_SKIP);
@@ -62,7 +57,7 @@ int main(void)
 	}
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_X86_TRIPLE_FAULT_EVENT, 1);
 
 	run = vcpu_state(vm, VCPU_ID);
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index e3e20e8848d0..23e9292580c9 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -550,11 +550,8 @@ static void run_guest_then_process_ucall_done(struct kvm_vm *vm)
 	process_ucall_done(vm);
 }
 
-static void test_msr_filter_allow(void) {
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_X86_USER_SPACE_MSR,
-		.args[0] = KVM_MSR_EXIT_REASON_FILTER,
-	};
+static void test_msr_filter_allow(void)
+{
 	struct kvm_vm *vm;
 	int rc;
 
@@ -564,7 +561,7 @@ static void test_msr_filter_allow(void) {
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_X86_USER_SPACE_MSR, KVM_MSR_EXIT_REASON_FILTER);
 
 	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
 	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
@@ -673,13 +670,8 @@ static void handle_wrmsr(struct kvm_run *run)
 	}
 }
 
-static void test_msr_filter_deny(void) {
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_X86_USER_SPACE_MSR,
-		.args[0] = KVM_MSR_EXIT_REASON_INVAL |
-			   KVM_MSR_EXIT_REASON_UNKNOWN |
-			   KVM_MSR_EXIT_REASON_FILTER,
-	};
+static void test_msr_filter_deny(void)
+{
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	int rc;
@@ -691,7 +683,9 @@ static void test_msr_filter_deny(void) {
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_X86_USER_SPACE_MSR, KVM_MSR_EXIT_REASON_INVAL |
+						      KVM_MSR_EXIT_REASON_UNKNOWN |
+						      KVM_MSR_EXIT_REASON_FILTER);
 
 	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
 	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
@@ -726,11 +720,8 @@ static void test_msr_filter_deny(void) {
 	kvm_vm_free(vm);
 }
 
-static void test_msr_permission_bitmap(void) {
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_X86_USER_SPACE_MSR,
-		.args[0] = KVM_MSR_EXIT_REASON_FILTER,
-	};
+static void test_msr_permission_bitmap(void)
+{
 	struct kvm_vm *vm;
 	int rc;
 
@@ -740,7 +731,7 @@ static void test_msr_permission_bitmap(void) {
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
-	vm_enable_cap(vm, &cap);
+	vm_enable_cap(vm, KVM_CAP_X86_USER_SPACE_MSR, KVM_MSR_EXIT_REASON_FILTER);
 
 	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
 	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
-- 
2.36.1.255.ge46751e96f-goog

