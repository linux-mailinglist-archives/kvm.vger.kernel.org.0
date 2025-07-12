Return-Path: <kvm+bounces-52447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F1BAB05422
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:08:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 296BF3BAEFB
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED2E2741CB;
	Tue, 15 Jul 2025 08:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uqpe9BXw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7432274FD7;
	Tue, 15 Jul 2025 08:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752566878; cv=none; b=pxZoKOCCfRNY8u4QqXdoYz3yE0944owFVZAiy0+xaiYmo9ob/xV2fRxEjk4hxisnvyjVf410V18z3M7t0ruo168zz+oREnVx1gU6BlzNESLG6+QUcJW3oPwuyPhoPTcOMwidmFgwdHImaC/2Bx9JC7lEYDXIThf3Kqy52QU4s+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752566878; c=relaxed/simple;
	bh=phqBjWmDEKCEhMDLC3/Pvh9nRe1YSXGvmgMiyJUNVZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XttdM6TtSq0zxhrRfCd5ntmldQzRh0eaSCkG9ODoQ8odJ8MS1IW6VZkPwfBKZVS96oMdTTYaCxwxi89DC/hDLxEuJJUbGBnhMRkxb53hlc4J9IcHjUtitkdgev8QeP6dHmX/AvW2lpHeI8hb7m0TP1Ogy2W4BYe5Tw3Oy43u7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uqpe9BXw; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752566876; x=1784102876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=phqBjWmDEKCEhMDLC3/Pvh9nRe1YSXGvmgMiyJUNVZ8=;
  b=Uqpe9BXwKLchTfGMSNeFWapSfR562K05dOXmpUDKgx2sXU4ImbMZ5X9/
   7+bwYobFP2gig0VS7H3r4I9gdmf+zHjL0HxClOQq14RGqcc28Bni7FU51
   Lu5JFF4KXfl9iOmpSr1HZkmcT54mzobPxKQep1ckX9m6kw0uSZbuzhh/Y
   QM7H2gLxdZdpvM2wMH4458MkXTM/ZsI+s5EpadFgYveGbGYQEgkTWDG7R
   VyKyAX6VojFkhdyZQYqhyxvw3Z9DKgayuL7W3gMKvh3VYRty1HyweN2M7
   DkQ+Y+UDPyMuCdrRhGF5qp+FI5kFOjwo9VT1dTO12oDN1Kog4OFhuiCav
   g==;
X-CSE-ConnectionGUID: DCLd7HtlRmSvh+XU0rVelA==
X-CSE-MsgGUID: HEtA3eaPSU6ZrMJx/P1daQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66135088"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="66135088"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:07:56 -0700
X-CSE-ConnectionGUID: bBqpY+WGSmupp4p8WH5vrQ==
X-CSE-MsgGUID: r35b1iUFTQSe6Ea8j0rEQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="161471339"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa003.jf.intel.com with ESMTP; 15 Jul 2025 01:07:53 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 2/3] KVM: selftests: Relax precise event count validation as overcount issue
Date: Sat, 12 Jul 2025 17:25:20 +0000
Message-ID: <20250712172522.187414-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250712172522.187414-1-dapeng1.mi@linux.intel.com>
References: <20250712172522.187414-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

For Intel Atom CPUs, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows.

The detailed information can be found in the errata (section SRF7):
https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/

For the Atom platforms before Sierra Forest (including Sierra Forest),
Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
be overcounted on these certain instructions, but for Clearwater Forest
only "Instruction Retired" event is overcounted on these instructions.

As the overcount issue on VM-Exit/VM-Entry, it has no way to validate
the precise count for these 2 events on these affected Atom platforms,
so just relax the precise event count check for these 2 events on these
Atom platforms.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 tools/testing/selftests/kvm/include/x86/pmu.h |  9 +++++
 tools/testing/selftests/kvm/lib/x86/pmu.c     | 38 +++++++++++++++++++
 .../selftests/kvm/x86/pmu_counters_test.c     | 17 ++++++++-
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h b/tools/testing/selftests/kvm/include/x86/pmu.h
index 2aabda2da002..db14c08abc59 100644
--- a/tools/testing/selftests/kvm/include/x86/pmu.h
+++ b/tools/testing/selftests/kvm/include/x86/pmu.h
@@ -104,4 +104,13 @@ enum amd_pmu_zen_events {
 extern const uint64_t intel_pmu_arch_events[];
 extern const uint64_t amd_pmu_zen_events[];
 
+/*
+ * Flags for "Instruction Retired" and "Branch Instruction Retired"
+ * overcount flaws.
+ */
+#define INST_RETIRED_OVERCOUNT BIT(0)
+#define BR_RETIRED_OVERCOUNT   BIT(1)
+
+extern uint32_t detect_inst_overcount_flags(void);
+
 #endif /* SELFTEST_KVM_PMU_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/pmu.c b/tools/testing/selftests/kvm/lib/x86/pmu.c
index 5ab44bf54773..fd4ed577c88f 100644
--- a/tools/testing/selftests/kvm/lib/x86/pmu.c
+++ b/tools/testing/selftests/kvm/lib/x86/pmu.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 
 #include "kvm_util.h"
+#include "processor.h"
 #include "pmu.h"
 
 const uint64_t intel_pmu_arch_events[] = {
@@ -34,3 +35,40 @@ const uint64_t amd_pmu_zen_events[] = {
 	AMD_ZEN_BRANCHES_MISPREDICTED,
 };
 kvm_static_assert(ARRAY_SIZE(amd_pmu_zen_events) == NR_AMD_ZEN_EVENTS);
+
+/*
+ * For Intel Atom CPUs, the PMU events "Instruction Retired" or
+ * "Branch Instruction Retired" may be overcounted for some certain
+ * instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
+ * and complex SGX/SMX/CSTATE instructions/flows.
+ *
+ * The detailed information can be found in the errata (section SRF7):
+ * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
+ *
+ * For the Atom platforms before Sierra Forest (including Sierra Forest),
+ * Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
+ * be overcounted on these certain instructions, but for Clearwater Forest
+ * only "Instruction Retired" event is overcounted on these instructions.
+ */
+uint32_t detect_inst_overcount_flags(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	uint32_t flags = 0;
+
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+	if (x86_family(eax) == 0x6) {
+		switch (x86_model(eax)) {
+		case 0xDD: /* Clearwater Forest */
+			flags = INST_RETIRED_OVERCOUNT;
+			break;
+		case 0xAF: /* Sierra Forest */
+		case 0x4D: /* Avaton, Rangely */
+		case 0x5F: /* Denverton */
+		case 0x86: /* Jacobsville */
+			flags = INST_RETIRED_OVERCOUNT | BR_RETIRED_OVERCOUNT;
+			break;
+		}
+	}
+
+	return flags;
+}
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 342a72420177..074cdf323406 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -52,6 +52,9 @@ struct kvm_intel_pmu_event {
 	struct kvm_x86_pmu_feature fixed_event;
 };
 
+
+static uint8_t inst_overcount_flags;
+
 /*
  * Wrap the array to appease the compiler, as the macros used to construct each
  * kvm_x86_pmu_feature use syntax that's only valid in function scope, and the
@@ -163,10 +166,18 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
 
 	switch (idx) {
 	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
-		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
+		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
+		if (inst_overcount_flags & INST_RETIRED_OVERCOUNT)
+			GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
+		else
+			GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
 		break;
 	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
-		GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
+		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
+		if (inst_overcount_flags & BR_RETIRED_OVERCOUNT)
+			GUEST_ASSERT(count >= NUM_BRANCH_INSNS_RETIRED);
+		else
+			GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
 		break;
 	case INTEL_ARCH_LLC_REFERENCES_INDEX:
 	case INTEL_ARCH_LLC_MISSES_INDEX:
@@ -335,6 +346,7 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
 				length);
 	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
 				unavailable_mask);
+	sync_global_to_guest(vm, inst_overcount_flags);
 
 	run_vcpu(vcpu);
 
@@ -673,6 +685,7 @@ int main(int argc, char *argv[])
 
 	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
+	inst_overcount_flags = detect_inst_overcount_flags();
 
 	test_intel_counters();
 
-- 
2.43.0


