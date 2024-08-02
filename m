Return-Path: <kvm+bounces-23101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74FBF946326
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00275282BD0
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353491547FB;
	Fri,  2 Aug 2024 18:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="35sAJVgS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7948F3DABF2
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722623010; cv=none; b=AD/ByGeZj2lUoPlI5zW9oCKTdQHHQ15XNOjhiYJKIr7bBAKa8mDeoXkAjubILsWpmZzz8g8ze6SPw8/4bhESMe4DiKpjtcDhLuxPaB0zjCM3cxs1o4d90MnVGv1j3xaRQnrdSBCdqrs/Vwd4Q3jtv7xESKxWL5GuagksXW1vpT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722623010; c=relaxed/simple;
	bh=M2AcP+s2OA4HvFU5924UK0HVvNHdjEpuqdHORW0nDuk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UT6oL17owvT9P+cYowFuYtmOSXZpPHIh2epzdOVZTYYN9hcv+N1CpCQTqo43HpzI8rDxYuW6+dcLZedWtdVhPTNJ8QXiCqlMtpuly2eKmEsydcAw1Uc8oJK2ZZwGP551u+hgeFJvCGOsECnADJ2/on7cDpZSTyMePXBO+tgfJ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=35sAJVgS; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-81f901cd3b5so1123574639f.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722623007; x=1723227807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VEpPHLX4AnIsaqPK3Ab7LVgS8QWm0D2UDwzN0KZ7X14=;
        b=35sAJVgS3t65+lalVkqQ9hn8PbCehIlRC5Pu3O2cqolDd5sjyO6Ft0JhToplq13QJQ
         PgP/mMu0qYF8IaNI5xodbjHG3kVPJQlirwp0CKstSlE6HGifZuCRrm/lETWsOS9hVpwn
         wYuGUiMnETG98PQXsV8QX+ygiuDlEMYUFkoH3quWOyd1QbCKD/ZM1EN722dJtfiUC/h7
         DqA4fI/6J+Lxqgr9Ecj6Omb7rGH3yOo4/EHgohy8/VO48dlBKAnmbVP+bOUtKaedNtZP
         tnCOmfwXkiWbK2ONh6DOL1oVYqpYtfWqEMc5uczvjO5urFQB1z5Oz7yECqpLxsuMS5+N
         Tw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722623007; x=1723227807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VEpPHLX4AnIsaqPK3Ab7LVgS8QWm0D2UDwzN0KZ7X14=;
        b=n5ybYQ7vqyoRRNvZBEaM+qmWzJRpdj/fb6NhifmP56938jI37ejkeG8Wmj0RLpUaBG
         eJj6VgfEgTRtUvSFsRpq16wjGe+jAtA6VpNFI9xSsNilpLapqneoczBm8qBfacrAdhio
         dHPuATe+97wv/Ct7ykxgHqb2pOZR4GmLQx/OAetk3/jGH548H272FxCt2r8ua+hIrA0a
         C9UOhnncTZ/+qCHprQmQJ+gqLTV1mtZwwp0f0pC2rSzEy81+fIMUj2SgD7HBAdmQG/Wh
         /fK49RSrEIGqa16Ja77k7TNpNPFp+RSfeLgpUozNR5I4AP/sdNYv9p0hnXgPyPxoMf7W
         +HVg==
X-Gm-Message-State: AOJu0Yyr2imSFmJk3ezlGzoP1bYzxHZJOH3Xhufws7Qdy3oIifubGOz2
	NfaeuDecCqj7ovM7Yx2ky+QehpnFQP/iMdrRl7UhpnXCPzbH6SIqRLm72ZFlzbQXZtdLqI2hMYL
	Te5TOREL/IFBOZF3+C+LocbCbcRlBG3o7f9a3UNlKyp0iRY+vS/mPXJO7hxs3FUAsEqMvnir6Aw
	RrzHu3iURiLJjlQRXPaXbG4vEGmQ0pbrNdXaz3lguXAsMnOrvrzmQs+kQ=
X-Google-Smtp-Source: AGHT+IHwx/s+GmkXDBo53QrNd0xcKe7xX8Jjc0U5RecbZE1aneXbPVG84LQC7y2SiWk6tksAmkVGNBb8VWM9/6ZQGg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:2181:b0:396:dc3a:72f2 with
 SMTP id e9e14a558f8ab-39b1fc3aedcmr2758625ab.3.1722623007707; Fri, 02 Aug
 2024 11:23:27 -0700 (PDT)
Date: Fri,  2 Aug 2024 18:22:37 +0000
In-Reply-To: <20240802182240.1916675-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802182240.1916675-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802182240.1916675-4-coltonlewis@google.com>
Subject: [PATCH 3/6] KVM: x86: selftests: Set up AMD VM in pmu_counters_test
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Mingwei Zhang <mizhang@google.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Branch in main() depending on if the CPU is Intel or AMD. They are
subject to vastly different requirements because the AMD PMU lacks
many properties defined by the Intel PMU including the entire CPUID
0xa function where Intel stores all the PMU properties. AMD lacks this
as well as any consistent notion of PMU versions as Intel does. Every
feature is a separate flag and they aren't the same features as Intel.

Set up a VM for testing core AMD counters and ensure proper CPUID
features are set.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 80 ++++++++++++++++---
 1 file changed, 68 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 0e305e43a93b..a11df073331a 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -33,7 +33,7 @@
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
 
-static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
+static struct kvm_vm *intel_pmu_vm_create(struct kvm_vcpu **vcpu,
 						  void *guest_code,
 						  uint8_t pmu_version,
 						  uint64_t perf_capabilities)
@@ -303,7 +303,7 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
 	if (!pmu_version)
 		return;
 
-	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_arch_events,
+	vm = intel_pmu_vm_create(&vcpu, guest_test_arch_events,
 					 pmu_version, perf_capabilities);
 
 	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
@@ -463,7 +463,7 @@ static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_gp_counters,
+	vm = intel_pmu_vm_create(&vcpu, guest_test_gp_counters,
 					 pmu_version, perf_capabilities);
 
 	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_GP_COUNTERS,
@@ -530,7 +530,7 @@ static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_fixed_counters,
+	vm = intel_pmu_vm_create(&vcpu, guest_test_fixed_counters,
 					 pmu_version, perf_capabilities);
 
 	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
@@ -627,18 +627,74 @@ static void test_intel_counters(void)
 	}
 }
 
-int main(int argc, char *argv[])
+static uint8_t nr_core_counters(void)
 {
-	TEST_REQUIRE(kvm_is_pmu_enabled());
+	const uint8_t nr_counters = kvm_cpu_property(X86_PROPERTY_NUM_PERF_CTR_CORE);
+	const bool core_ext = kvm_cpu_has(X86_FEATURE_PERF_CTR_EXT_CORE);
+	/* The default numbers promised if the property is 0 */
+	const uint8_t amd_nr_core_ext_counters = 6;
+	const uint8_t amd_nr_core_counters = 4;
+
+	if (nr_counters != 0)
+		return nr_counters;
+
+	if (core_ext)
+		return amd_nr_core_ext_counters;
+
+	return amd_nr_core_counters;
+}
+
+static void guest_test_core_counters(void)
+{
+	GUEST_DONE();
+}
 
-	TEST_REQUIRE(host_cpu_is_intel);
-	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
-	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+static void test_core_counters(void)
+{
+	uint8_t nr_counters = nr_core_counters();
+	bool core_ext = kvm_cpu_has(X86_FEATURE_PERF_CTR_EXT_CORE);
+	bool perf_mon_v2 = kvm_cpu_has(X86_FEATURE_PERF_MON_V2);
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
 
-	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
-	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_test_core_counters);
 
-	test_intel_counters();
+	/* This property may not be there in older underlying CPUs,
+	 * but it simplifies the test code for it to be set
+	 * unconditionally.
+	 */
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_NUM_PERF_CTR_CORE, nr_counters);
+	if (core_ext)
+		vcpu_set_cpuid_feature(vcpu, X86_FEATURE_PERF_CTR_EXT_CORE);
+	if (perf_mon_v2)
+		vcpu_set_cpuid_feature(vcpu, X86_FEATURE_PERF_MON_V2);
+
+	pr_info("Testing core counters: CoreExt = %u, PerfMonV2 = %u, NumCounters = %u\n",
+		core_ext, perf_mon_v2, nr_counters);
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+static void test_amd_counters(void)
+{
+	test_core_counters();
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_is_pmu_enabled());
+
+	if (host_cpu_is_intel) {
+		TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
+		TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+		kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
+		kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
+		test_intel_counters();
+	} else if (host_cpu_is_amd) {
+		/* AMD CPUs don't have the same properties to look at. */
+		test_amd_counters();
+	}
 
 	return 0;
 }
-- 
2.46.0.rc2.264.g509ed76dc8-goog


