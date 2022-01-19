Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FA6493FE0
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356745AbiASS2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356737AbiASS2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 13:28:33 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912A4C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:28:33 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id i6-20020a626d06000000b004c0abfd53b3so2044991pfc.12
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iSxUOXtoygGU8o/jZ4hSHjW4ZKLLKccQwPWLrYeSFxo=;
        b=BSE/+mZ+7qvXXEgIYeW6ZXgl/BFmjt34Xopf58X7S85GMtWRgALhEEODrBwS0hk95m
         HTgsQIQP+pkaRi5Lb2MLobkTR66n/7aGdPG1qt+JfeksW+BC2qwXgGPw7PMfAgkFzCEr
         nL8knQVodd46aG5g5XIIhW5ElovLWlnsekmEbR+ugVLqK4ERvmjwC3N9p3qwOv7fptP6
         3qDFSQv2R8n+SSHqRSZI/AGZ0F7tAZK//PzyMwMkn9DueryCDE3WhCKcymR2EIhRGSb3
         WHGzeCY4ZWgjE6aWWDG+74wZSR4x334Iy7p8B149FBsisHkJR32Dqby495RyAsIfLdYu
         OYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iSxUOXtoygGU8o/jZ4hSHjW4ZKLLKccQwPWLrYeSFxo=;
        b=AgTpRtadbMVdZGN9xckGiRFfA2QATBkdUWAIOWsWMPcx8Hsh6sOYRYubt6TFkypuJN
         S5m+d6lcBaejPPmsEwtvQElov/n2BEvS3az9+9fVilAKPBfpUfDW0LUGhZ0YI+iXkT0Z
         PGXugzPFaSAVWlSos1ASqChWmWMH6LGrWfCTIeKn/LG7agFroOJodCufZ7kgBD3hyWpv
         93ckGIK8keky2Vu4U/Be1CeQDQwbe2yHchNgFb8MSy/3bPtyEdLNU6JkOf9gTHNJo5AX
         jWhf3YplGX34QicMxY2JI8wUzdul1zHg6fZjyIjvgou4PKjq2XA9VAGoNOKYFeUsbBnZ
         Kg2A==
X-Gm-Message-State: AOAM533p/fjjNZrhPO3EZEXmvNxC+pwAoBJqcMKUv7tPsDCxldSdCDf/
        u/ia3VUzFuaRVIJD2iocKjBWNr5EtPLbadS31ixwB/0oZIS1LFXZa8hbXl3bqCoSaVJD2Qkr3Ms
        GutYyf9SBO19wAVYsg+iNHEJ7iLTC5Oo1ln8LHCIpGlbcznQDyV7AdE6ZXQfJmOYFrw==
X-Google-Smtp-Source: ABdhPJwPOSSXDpGyVuikRWpNzMCi/bqsSd0dc/WpYVAQBakfv/6Qt1ALwQ50oxeXQIxdTfROiipE8VgEjdUoqR0=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:902:e844:b0:14a:ef67:ed96 with SMTP
 id t4-20020a170902e84400b0014aef67ed96mr5408734plg.104.1642616912909; Wed, 19
 Jan 2022 10:28:32 -0800 (PST)
Date:   Wed, 19 Jan 2022 18:28:17 +0000
In-Reply-To: <20220119182818.3641304-1-daviddunn@google.com>
Message-Id: <20220119182818.3641304-2-daviddunn@google.com>
Mime-Version: 1.0
References: <20220119182818.3641304-1-daviddunn@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 2/3] Verify that the PMU event filter works as expected.
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note that the virtual PMU doesn't work as expected on AMD Zen CPUs (an
intercepted rdmsr is counted as a retired branch instruction), but the
PMU event filter does work.

This is a local application of change authored by Jim Mattson and sent
to kvm mailiong list on Jan 14, 2022.

Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 194 +++++++++++++++---
 1 file changed, 163 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 8ac99d4cbc73..aa104946e6e0 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -16,10 +16,38 @@
 #include "processor.h"
 
 /*
- * In lieue of copying perf_event.h into tools...
+ * In lieu of copying perf_event.h into tools...
  */
-#define ARCH_PERFMON_EVENTSEL_ENABLE	BIT(22)
-#define ARCH_PERFMON_EVENTSEL_OS	BIT(17)
+#define ARCH_PERFMON_EVENTSEL_OS			(1ULL << 17)
+#define ARCH_PERFMON_EVENTSEL_ENABLE			(1ULL << 22)
+
+union cpuid10_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid10_ebx {
+	struct {
+		unsigned int no_unhalted_core_cycles:1;
+		unsigned int no_instructions_retired:1;
+		unsigned int no_unhalted_reference_cycles:1;
+		unsigned int no_llc_reference:1;
+		unsigned int no_llc_misses:1;
+		unsigned int no_branch_instruction_retired:1;
+		unsigned int no_branch_misses_retired:1;
+	} split;
+	unsigned int full;
+};
+
+/* End of stuff taken from perf_event.h. */
+
+/* Oddly, this isn't in perf_event.h. */
+#define ARCH_PERFMON_BRANCHES_RETIRED		5
 
 #define VCPU_ID 0
 #define NUM_BRANCHES 42
@@ -45,14 +73,15 @@
  * Preliminary Processor Programming Reference (PPR) for AMD Family
  * 17h Model 31h, Revision B0 Processors, and Preliminary Processor
  * Programming Reference (PPR) for AMD Family 19h Model 01h, Revision
- * B1 Processors Volume 1 of 2
+ * B1 Processors Volume 1 of 2.
  */
 
 #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
 
 /*
  * This event list comprises Intel's eight architectural events plus
- * AMD's "branch instructions retired" for Zen[123].
+ * AMD's "retired branch instructions" for Zen[123] (and possibly
+ * other AMD CPUs).
  */
 static const uint64_t event_list[] = {
 	EVENT(0x3c, 0),
@@ -66,11 +95,45 @@ static const uint64_t event_list[] = {
 	AMD_ZEN_BR_RETIRED,
 };
 
+/*
+ * If we encounter a #GP during the guest PMU sanity check, then the guest
+ * PMU is not functional. Inform the hypervisor via GUEST_SYNC(0).
+ */
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(0);
+}
+
+/*
+ * Check that we can write a new value to the given MSR and read it back.
+ * The caller should provide a non-empty set of bits that are safe to flip.
+ *
+ * Return on success. GUEST_SYNC(0) on error.
+ */
+static void check_msr(uint32_t msr, uint64_t bits_to_flip)
+{
+	uint64_t v = rdmsr(msr) ^ bits_to_flip;
+
+	wrmsr(msr, v);
+	if (rdmsr(msr) != v)
+		GUEST_SYNC(0);
+
+	v ^= bits_to_flip;
+	wrmsr(msr, v);
+	if (rdmsr(msr) != v)
+		GUEST_SYNC(0);
+}
+
 static void intel_guest_code(void)
 {
-	uint64_t br0, br1;
+	check_msr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
+	check_msr(MSR_P6_EVNTSEL0, 0xffff);
+	check_msr(MSR_IA32_PMC0, 0xffff);
+	GUEST_SYNC(1);
 
 	for (;;) {
+		uint64_t br0, br1;
+
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
@@ -83,15 +146,19 @@ static void intel_guest_code(void)
 }
 
 /*
- * To avoid needing a check for CPUID.80000001:ECX.PerfCtrExtCore[bit
- * 23], this code uses the always-available, legacy K7 PMU MSRs, which
- * alias to the first four of the six extended core PMU MSRs.
+ * To avoid needing a check for CPUID.80000001:ECX.PerfCtrExtCore[bit 23],
+ * this code uses the always-available, legacy K7 PMU MSRs, which alias to
+ * the first four of the six extended core PMU MSRs.
  */
 static void amd_guest_code(void)
 {
-	uint64_t br0, br1;
+	check_msr(MSR_K7_EVNTSEL0, 0xffff);
+	check_msr(MSR_K7_PERFCTR0, 0xffff);
+	GUEST_SYNC(1);
 
 	for (;;) {
+		uint64_t br0, br1;
+
 		wrmsr(MSR_K7_EVNTSEL0, 0);
 		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
@@ -102,7 +169,11 @@ static void amd_guest_code(void)
 	}
 }
 
-static uint64_t test_branches_retired(struct kvm_vm *vm)
+/*
+ * Run the VM to the next GUEST_SYNC(value), and return the value passed
+ * to the sync. Any other exit from the guest is fatal.
+ */
+static uint64_t run_vm_to_sync(struct kvm_vm *vm)
 {
 	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 	struct ucall uc;
@@ -118,6 +189,25 @@ static uint64_t test_branches_retired(struct kvm_vm *vm)
 	return uc.args[1];
 }
 
+/*
+ * In a nested environment or if the vPMU is disabled, the guest PMU
+ * might not work as architected (accessing the PMU MSRs may raise
+ * #GP, or writes could simply be discarded). In those situations,
+ * there is no point in running these tests. The guest code will perform
+ * a sanity check and then GUEST_SYNC(success). In the case of failure,
+ * the behavior of the guest on resumption is undefined.
+ */
+static bool sanity_check_pmu(struct kvm_vm *vm)
+{
+	bool success;
+
+	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
+	success = run_vm_to_sync(vm);
+	vm_install_exception_handler(vm, GP_VECTOR, NULL);
+
+	return success;
+}
+
 static struct kvm_pmu_event_filter *make_pmu_event_filter(uint32_t nevents)
 {
 	struct kvm_pmu_event_filter *f;
@@ -143,6 +233,10 @@ static struct kvm_pmu_event_filter *event_filter(uint32_t action)
 	return f;
 }
 
+/*
+ * Remove the first occurrence of 'event' (if any) from the filter's
+ * event list.
+ */
 static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 						 uint64_t event)
 {
@@ -160,9 +254,9 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 	return f;
 }
 
-static void test_no_filter(struct kvm_vm *vm)
+static void test_without_filter(struct kvm_vm *vm)
 {
-	uint64_t count = test_branches_retired(vm);
+	uint64_t count = run_vm_to_sync(vm);
 
 	if (count != NUM_BRANCHES)
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
@@ -174,7 +268,7 @@ static uint64_t test_with_filter(struct kvm_vm *vm,
 				 struct kvm_pmu_event_filter *f)
 {
 	vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
-	return test_branches_retired(vm);
+	return run_vm_to_sync(vm);
 }
 
 static void test_member_deny_list(struct kvm_vm *vm)
@@ -231,40 +325,70 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
 	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
 }
 
+/*
+ * Check for a non-zero PMU version, at least one general-purpose
+ * counter per logical processor, an EBX bit vector of length greater
+ * than 5, and EBX[5] clear.
+ */
+static bool check_intel_pmu_leaf(struct kvm_cpuid_entry2 *entry)
+{
+	union cpuid10_eax eax = { .full = entry->eax };
+	union cpuid10_ebx ebx = { .full = entry->ebx };
+
+	return eax.split.version_id && eax.split.num_counters > 0 &&
+		eax.split.mask_length > ARCH_PERFMON_BRANCHES_RETIRED &&
+		!ebx.split.no_branch_instruction_retired;
+}
+
 /*
  * Note that CPUID leaf 0xa is Intel-specific. This leaf should be
  * clear on AMD hardware.
  */
-static bool vcpu_supports_intel_br_retired(void)
+static bool use_intel_pmu(void)
 {
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_cpuid2 *cpuid;
 
 	cpuid = kvm_get_supported_cpuid();
 	entry = kvm_get_supported_cpuid_index(0xa, 0);
-	return entry &&
-		(entry->eax & 0xff) &&
-		(entry->eax >> 24) > 5 &&
-		!(entry->ebx & BIT(5));
+	return is_intel_cpu() && entry && check_intel_pmu_leaf(entry);
+}
+
+static bool is_zen1(uint32_t eax)
+{
+	return x86_family(eax) == 0x17 && x86_model(eax) <= 0x0f;
+}
+
+static bool is_zen2(uint32_t eax)
+{
+	return x86_family(eax) == 0x17 &&
+		x86_model(eax) >= 0x30 && x86_model(eax) <= 0x3f;
+}
+
+static bool is_zen3(uint32_t eax)
+{
+	return x86_family(eax) == 0x19 && x86_model(eax) <= 0x0f;
 }
 
 /*
  * Determining AMD support for a PMU event requires consulting the AMD
- * PPR for the CPU or reference material derived therefrom.
+ * PPR for the CPU or reference material derived therefrom. The AMD
+ * test code herein has been verified to work on Zen1, Zen2, and Zen3.
+ *
+ * Feel free to add more AMD CPUs that are documented to support event
+ * select 0xc2 umask 0 as "retired branch instructions."
  */
-static bool vcpu_supports_amd_zen_br_retired(void)
+static bool use_amd_pmu(void)
 {
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_cpuid2 *cpuid;
 
 	cpuid = kvm_get_supported_cpuid();
 	entry = kvm_get_supported_cpuid_index(1, 0);
-	return entry &&
-		((x86_family(entry->eax) == 0x17 &&
-		  (x86_model(entry->eax) == 1 ||
-		   x86_model(entry->eax) == 0x31)) ||
-		 (x86_family(entry->eax) == 0x19 &&
-		  x86_model(entry->eax) == 1));
+	return is_amd_cpu() && entry &&
+		(is_zen1(entry->eax) ||
+		 is_zen2(entry->eax) ||
+		 is_zen3(entry->eax));
 }
 
 int main(int argc, char *argv[])
@@ -282,19 +406,27 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	if (vcpu_supports_intel_br_retired())
+	if (use_intel_pmu())
 		guest_code = intel_guest_code;
-	else if (vcpu_supports_amd_zen_br_retired())
+	else if (use_amd_pmu())
 		guest_code = amd_guest_code;
 
 	if (!guest_code) {
-		print_skip("Branch instructions retired not supported");
+		print_skip("Don't know how to test this guest PMU");
 		exit(KSFT_SKIP);
 	}
 
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 
-	test_no_filter(vm);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	if (!sanity_check_pmu(vm)) {
+		print_skip("Guest PMU is not functional");
+		exit(KSFT_SKIP);
+	}
+
+	test_without_filter(vm);
 	test_member_deny_list(vm);
 	test_member_allow_list(vm);
 	test_not_member_deny_list(vm);
-- 
2.34.1.703.g22d0c6ccf7-goog

