Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223C87D4403
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjJXA2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjJXA1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:27:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280C410C6
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:27:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9cafa90160so4643648276.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107220; x=1698712020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LVgGvnFW9q/mijlkpvY+O1Zix6lIKT3NeTV0IdzcrJI=;
        b=ZlsezbuSc+49AlP1bQ2PbpiZz+SvGIjUjkpTcqbur2L82OEZHm/v2oH9FbQMBa+nD8
         z9vwRJcPw9HE83O5eH8uKM3UKVoq8lIyZAUBZHtsROj5AV4Wia46Ii931l2owGabLBwO
         a3xJAhU2ROlfPTSvG6aNWeO80IVZjbde0stEmzzEd9ZJ9rzRP6tmBvX5A9hlE95QTQN/
         hgRxXwcsWQHWeeeaOHu9wj9ejFaCtAcmnBxYZb9CrlZEuoi5EP70JtQaCRcrVtK23xRQ
         6MYlBqp5+TEk+s0nNHJIWj3r/oW9Seik3JaNzL72Is4ch3OrpPifsTI7NbijX2G0Ce5W
         K4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107220; x=1698712020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LVgGvnFW9q/mijlkpvY+O1Zix6lIKT3NeTV0IdzcrJI=;
        b=Pn2aOxXn53pBy2rGjaGK5GGlBpPJPRkgpRuOXJjGJpptX2QN4Jd9iL+q4Sb4TwW55G
         yHaqCF7d1coGBDvKL2hLUbIFajWnWFr9q+cj0bJhmU2pUWLueLvO72KgJDwFvxSmTR2o
         yRG48AB3MYpE7kA+PsKnock4YC7STzRQ6s8rBRefzA6b7vdMhl1mHQxD2BaMMP7yJVmt
         9RMaylpuGYmLKUq8UR/BTauBnV7NqVsxA2fNe+bWBhNDN5gtds5eCsn+38lKrsE9wn0V
         vzo97KUJlug1hdXXg/iy0y7u88J7uh3SKI6Y4HgfU6wBnOeJ6kqhvlQSkiv9F/L17zQu
         JHGg==
X-Gm-Message-State: AOJu0YybSspkjcz0nqdE//LYC13REgE4J/mAtzCysKz/cu8iq06C9c11
        GNqw4vS7R1My6WfiXPCvHX1fnhkzVi4=
X-Google-Smtp-Source: AGHT+IGDUdJgo+MJ6+2aZRfH3/YowIGxQsEvFIcUSx2iogNdLSlS53ij+RVDbB0oTfE5uPotkkKXADFTBn0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:105:b0:da0:3da9:ce08 with SMTP id
 o5-20020a056902010500b00da03da9ce08mr8158ybh.10.1698107220804; Mon, 23 Oct
 2023 17:27:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:33 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-14-seanjc@google.com>
Subject: [PATCH v5 13/13] KVM: selftests: Extend PMU counters test to permute
 on vPMU version
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extent the PMU counters test to verify that KVM emulates the vPMU (or
not) according to the vPMU version exposed to the guest.  KVM's ABI (which
does NOT reflect Intel's architectural behavior) is that GP counters are
available if the PMU version is >0, and that fixed counters and
PERF_GLOBAL_CTRL are available if the PMU version is >1.

Test up to vPMU version 5, i.e. the current architectural max.  KVM only
officially supports up to version 2, but the behavior of the counters is
backwards compatible, i.e. KVM shouldn't do something completely different
for a higher, architecturally-defined vPMU version.

Verify KVM behavior against the effective vPMU version, e.g. advertising
vPMU 5 when KVM only supports vPMU 2 shouldn't magically unlock vPMU 5
features.

Suggested-by: Like Xu <likexu@tencent.com>
Suggested-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 60 +++++++++++++++----
 1 file changed, 47 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 1c392ad156f4..85b01dd5b2cd 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -12,6 +12,8 @@
 /* Guest payload for any performance counter counting */
 #define NUM_BRANCHES		10
 
+static uint8_t kvm_pmu_version;
+
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code)
 {
@@ -21,6 +23,8 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(*vcpu);
 
+	sync_global_to_guest(vm, kvm_pmu_version);
+
 	return vm;
 }
 
@@ -97,6 +101,19 @@ static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
 	return !(*(u64 *)&event);
 }
 
+static uint8_t guest_get_pmu_version(void)
+{
+	/*
+	 * Return the effective PMU version, i.e. the minimum between what KVM
+	 * supports and what is enumerated to the guest.  The counters test
+	 * deliberately advertises a PMU version to the guest beyond what is
+	 * actually supported by KVM to verify KVM doesn't freak out and do
+	 * something bizarre with an architecturally valid, but unsupported,
+	 * version.
+	 */
+	return min_t(uint8_t, kvm_pmu_version, this_cpu_property(X86_PROPERTY_PMU_VERSION));
+}
+
 static void guest_measure_loop(uint8_t idx)
 {
 	const struct {
@@ -121,7 +138,7 @@ static void guest_measure_loop(uint8_t idx)
 	};
 
 	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
-	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
+	uint32_t pmu_version = guest_get_pmu_version();
 	struct kvm_x86_pmu_feature gp_event, fixed_event;
 	uint32_t counter_msr;
 	unsigned int i;
@@ -270,9 +287,12 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 
 static void guest_test_gp_counters(void)
 {
-	uint8_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint8_t nr_gp_counters = 0;
 	uint32_t base_msr;
 
+	if (guest_get_pmu_version())
+		nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+
 	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
 		base_msr = MSR_IA32_PMC0;
 	else
@@ -282,7 +302,8 @@ static void guest_test_gp_counters(void)
 	GUEST_DONE();
 }
 
-static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_cap)
+static void test_gp_counters(uint8_t pmu_version, uint8_t nr_gp_counters,
+			     uint64_t perf_cap)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -305,16 +326,17 @@ static void guest_test_fixed_counters(void)
 	uint8_t i;
 
 	/* KVM provides fixed counters iff the vPMU version is 2+. */
-	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 2)
+	if (guest_get_pmu_version() >= 2)
 		nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 
 	/*
 	 * The supported bitmask for fixed counters was introduced in PMU
 	 * version 5.
 	 */
-	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 5)
+	if (guest_get_pmu_version() >= 5)
 		supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
 
+
 	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
 			     nr_fixed_counters, supported_bitmask);
 
@@ -345,7 +367,7 @@ static void guest_test_fixed_counters(void)
 	GUEST_DONE();
 }
 
-static void test_fixed_counters(uint8_t nr_fixed_counters,
+static void test_fixed_counters(uint8_t pmu_version, uint8_t nr_fixed_counters,
 				uint32_t supported_bitmask, uint64_t perf_cap)
 {
 	struct kvm_vcpu *vcpu;
@@ -368,22 +390,32 @@ static void test_intel_counters(void)
 {
 	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint8_t max_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	unsigned int i;
+	uint8_t j, v;
 	uint32_t k;
-	uint8_t j;
 
 	const uint64_t perf_caps[] = {
 		0,
 		PMU_CAP_FW_WRITES,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
-		for (j = 0; j <= nr_gp_counters; j++)
-			test_gp_counters(j, perf_caps[i]);
+	/*
+	 * Test up to PMU v5, which is the current maximum version defined by
+	 * Intel, i.e. is the last version that is guaranteed to be backwards
+	 * compatible with KVM's existing behavior.
+	 */
+	max_pmu_version = max_t(typeof(max_pmu_version), max_pmu_version, 5);
 
-		for (j = 0; j <= nr_fixed_counters; j++) {
-			for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
-				test_fixed_counters(j, k, perf_caps[i]);
+	for (v = 0; v <= max_pmu_version; v++) {
+		for (i = 0; i < ARRAY_SIZE(perf_caps) + 1; i++) {
+			for (j = 0; j <= nr_gp_counters; j++)
+				test_gp_counters(v, j, perf_caps[i]);
+
+			for (j = 0; j <= nr_fixed_counters; j++) {
+				for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
+					test_fixed_counters(v, j, k, perf_caps[i]);
+			}
 		}
 	}
 }
@@ -397,6 +429,8 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
+	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
+
 	test_intel_arch_events();
 	test_intel_counters();
 
-- 
2.42.0.758.gaed0368e0e-goog

