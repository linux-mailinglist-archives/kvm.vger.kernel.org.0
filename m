Return-Path: <kvm+bounces-52446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F872B05420
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C29EB3B8792
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6EC4274B43;
	Tue, 15 Jul 2025 08:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VaqgQbHl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A2F274670;
	Tue, 15 Jul 2025 08:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752566875; cv=none; b=Xh1KhEijwTtzVz9oEpEceOb+I+aut5qxzJbzulS0Fy4b801sUFvWCzq/vHQoFqnj01cehHGY/Mj+FWbmFffKFEHjwyq28O51ukvQZ7iGLD5FG+7CXmquY0CgI6SyAo+a7PuqqqIxeewjkfJerK9HBLYU9pTjfFaceGvra6Vg81Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752566875; c=relaxed/simple;
	bh=Etrx1ii+t2DRRR7Ohnr/tADETapQZWGGpqFK1PhyTVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHeLsnn35DcVqf10Sr6JDCfYkTgm7Ul7hTHQcPTMq3dnVlg0I9c0YyrGSQ0PvbheTFPpGqC7Hurg40U2qKGPUHn48KO2F+rF38FMe9VBXi1wY3WDLHTrLDDREtB6cgqdvPrsallPUPIE7HUtwiNDToQMn5SLLyAZrKzTg97Vcnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VaqgQbHl; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752566873; x=1784102873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Etrx1ii+t2DRRR7Ohnr/tADETapQZWGGpqFK1PhyTVA=;
  b=VaqgQbHlndi/NbpG5uysF/o/Nbwmiy8Em6MBBgIN7uy43fZmfKX70Vsg
   cvqTQ4vd0/vHrF/8pNMwYP1k1iBMB3XtmJ2RCX50V/NoTi3MnO9sotxRj
   +21AI0RP/TcvkeL75pt22ydkHZ3Q8AOGr6JledM992Lk5WZh0YzX2cn+j
   U8iR3gkLD0cbKTHGdrc1scYJQdfBhPyJWaezRv5xDB2NoGv7/ujUUZqKP
   NCrrzXWuU8MOzC8S4nLWRteDYKHKmnoLwJCykTzkus4ul0CBdVsanpiow
   3a1YHu1V9UqlkyNj0hwQVkFJsZQ7EPToJtoa0alNr07QIr/5V+KYL8lWq
   w==;
X-CSE-ConnectionGUID: c3UEDmsrR3Om7x4KKwJjFQ==
X-CSE-MsgGUID: 0u4Jdi55T/G/xYFODj3dRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66135083"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="66135083"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:07:53 -0700
X-CSE-ConnectionGUID: pWiGO6NkRvq2Tkbj5oK5wg==
X-CSE-MsgGUID: HYYWY+KwSkOeTQIoiITzaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="161471321"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa003.jf.intel.com with ESMTP; 15 Jul 2025 01:07:50 -0700
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
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 1/3] KVM: Selftests: Validate more arch-events in pmu_counters_test
Date: Sat, 12 Jul 2025 17:25:19 +0000
Message-ID: <20250712172522.187414-2-dapeng1.mi@linux.intel.com>
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

Clearwater Forest introduces 5 new architectural events (4 topdown
level 1 metrics events and LBR inserts event). This patch supports
to validate these 5 newly added events. The detailed info about these
5 events can be found in SDM section 21.2.7 "Pre-defined Architectural
 Performance Events".

It becomes unrealistic to traverse all possible combinations of
unavailable events mask (may need dozens of minutes to finish all
possible combination validation). So only limit unavailable events mask
traverse to the first 8 arch-events.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 tools/testing/selftests/kvm/include/x86/pmu.h | 10 +++++++++
 .../selftests/kvm/include/x86/processor.h     |  7 +++++-
 tools/testing/selftests/kvm/lib/x86/pmu.c     |  5 +++++
 .../selftests/kvm/x86/pmu_counters_test.c     | 22 ++++++++++++++-----
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h b/tools/testing/selftests/kvm/include/x86/pmu.h
index 3c10c4dc0ae8..2aabda2da002 100644
--- a/tools/testing/selftests/kvm/include/x86/pmu.h
+++ b/tools/testing/selftests/kvm/include/x86/pmu.h
@@ -61,6 +61,11 @@
 #define	INTEL_ARCH_BRANCHES_RETIRED		RAW_EVENT(0xc4, 0x00)
 #define	INTEL_ARCH_BRANCHES_MISPREDICTED	RAW_EVENT(0xc5, 0x00)
 #define	INTEL_ARCH_TOPDOWN_SLOTS		RAW_EVENT(0xa4, 0x01)
+#define	INTEL_ARCH_TOPDOWN_BE_BOUND		RAW_EVENT(0xa4, 0x02)
+#define	INTEL_ARCH_TOPDOWN_BAD_SPEC		RAW_EVENT(0x73, 0x00)
+#define	INTEL_ARCH_TOPDOWN_FE_BOUND		RAW_EVENT(0x9c, 0x01)
+#define	INTEL_ARCH_TOPDOWN_RETIRING		RAW_EVENT(0xc2, 0x02)
+#define	INTEL_ARCH_LBR_INSERTS			RAW_EVENT(0xe4, 0x01)
 
 #define	AMD_ZEN_CORE_CYCLES			RAW_EVENT(0x76, 0x00)
 #define	AMD_ZEN_INSTRUCTIONS_RETIRED		RAW_EVENT(0xc0, 0x00)
@@ -80,6 +85,11 @@ enum intel_pmu_architectural_events {
 	INTEL_ARCH_BRANCHES_RETIRED_INDEX,
 	INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX,
 	INTEL_ARCH_TOPDOWN_SLOTS_INDEX,
+	INTEL_ARCH_TOPDOWN_BE_BOUND_INDEX,
+	INTEL_ARCH_TOPDOWN_BAD_SPEC_INDEX,
+	INTEL_ARCH_TOPDOWN_FE_BOUND_INDEX,
+	INTEL_ARCH_TOPDOWN_RETIRING_INDEX,
+	INTEL_ARCH_LBR_INSERTS_INDEX,
 	NR_INTEL_ARCH_EVENTS,
 };
 
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 2efb05c2f2fb..232964f2a687 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -265,7 +265,7 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_PMU_NR_GP_COUNTERS		KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 8, 15)
 #define X86_PROPERTY_PMU_GP_COUNTERS_BIT_WIDTH	KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 16, 23)
 #define X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH	KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 24, 31)
-#define X86_PROPERTY_PMU_EVENTS_MASK		KVM_X86_CPU_PROPERTY(0xa, 0, EBX, 0, 7)
+#define X86_PROPERTY_PMU_EVENTS_MASK		KVM_X86_CPU_PROPERTY(0xa, 0, EBX, 0, 12)
 #define X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK	KVM_X86_CPU_PROPERTY(0xa, 0, ECX, 0, 31)
 #define X86_PROPERTY_PMU_NR_FIXED_COUNTERS	KVM_X86_CPU_PROPERTY(0xa, 0, EDX, 0, 4)
 #define X86_PROPERTY_PMU_FIXED_COUNTERS_BIT_WIDTH	KVM_X86_CPU_PROPERTY(0xa, 0, EDX, 5, 12)
@@ -332,6 +332,11 @@ struct kvm_x86_pmu_feature {
 #define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED		KVM_X86_PMU_FEATURE(EBX, 5)
 #define X86_PMU_FEATURE_BRANCHES_MISPREDICTED		KVM_X86_PMU_FEATURE(EBX, 6)
 #define X86_PMU_FEATURE_TOPDOWN_SLOTS			KVM_X86_PMU_FEATURE(EBX, 7)
+#define X86_PMU_FEATURE_TOPDOWN_BE_BOUND		KVM_X86_PMU_FEATURE(EBX, 8)
+#define X86_PMU_FEATURE_TOPDOWN_BAD_SPEC		KVM_X86_PMU_FEATURE(EBX, 9)
+#define X86_PMU_FEATURE_TOPDOWN_FE_BOUND		KVM_X86_PMU_FEATURE(EBX, 10)
+#define X86_PMU_FEATURE_TOPDOWN_RETIRING		KVM_X86_PMU_FEATURE(EBX, 11)
+#define X86_PMU_FEATURE_LBR_INSERTS			KVM_X86_PMU_FEATURE(EBX, 12)
 
 #define X86_PMU_FEATURE_INSNS_RETIRED_FIXED		KVM_X86_PMU_FEATURE(ECX, 0)
 #define X86_PMU_FEATURE_CPU_CYCLES_FIXED		KVM_X86_PMU_FEATURE(ECX, 1)
diff --git a/tools/testing/selftests/kvm/lib/x86/pmu.c b/tools/testing/selftests/kvm/lib/x86/pmu.c
index f31f0427c17c..5ab44bf54773 100644
--- a/tools/testing/selftests/kvm/lib/x86/pmu.c
+++ b/tools/testing/selftests/kvm/lib/x86/pmu.c
@@ -19,6 +19,11 @@ const uint64_t intel_pmu_arch_events[] = {
 	INTEL_ARCH_BRANCHES_RETIRED,
 	INTEL_ARCH_BRANCHES_MISPREDICTED,
 	INTEL_ARCH_TOPDOWN_SLOTS,
+	INTEL_ARCH_TOPDOWN_BE_BOUND,
+	INTEL_ARCH_TOPDOWN_BAD_SPEC,
+	INTEL_ARCH_TOPDOWN_FE_BOUND,
+	INTEL_ARCH_TOPDOWN_RETIRING,
+	INTEL_ARCH_LBR_INSERTS,
 };
 kvm_static_assert(ARRAY_SIZE(intel_pmu_arch_events) == NR_INTEL_ARCH_EVENTS);
 
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 8aaaf25b6111..342a72420177 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -75,6 +75,11 @@ static struct kvm_intel_pmu_event intel_event_to_feature(uint8_t idx)
 		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
 		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
 		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
+		[INTEL_ARCH_TOPDOWN_BE_BOUND_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_BE_BOUND, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_BAD_SPEC_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_BAD_SPEC, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_FE_BOUND_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_FE_BOUND, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_RETIRING_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_RETIRING, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_LBR_INSERTS_INDEX]		 = { X86_PMU_FEATURE_LBR_INSERTS, X86_PMU_FEATURE_NULL },
 	};
 
 	kvm_static_assert(ARRAY_SIZE(__intel_event_to_feature) == NR_INTEL_ARCH_EVENTS);
@@ -171,9 +176,12 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
 		fallthrough;
 	case INTEL_ARCH_CPU_CYCLES_INDEX:
 	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
+	case INTEL_ARCH_TOPDOWN_BE_BOUND_INDEX:
+	case INTEL_ARCH_TOPDOWN_FE_BOUND_INDEX:
 		GUEST_ASSERT_NE(count, 0);
 		break;
 	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
+	case INTEL_ARCH_TOPDOWN_RETIRING_INDEX:
 		__GUEST_ASSERT(count >= NUM_INSNS_RETIRED,
 			       "Expected top-down slots >= %u, got count = %lu",
 			       NUM_INSNS_RETIRED, count);
@@ -612,15 +620,19 @@ static void test_intel_counters(void)
 			pr_info("Testing arch events, PMU version %u, perf_caps = %lx\n",
 				v, perf_caps[i]);
 			/*
-			 * To keep the total runtime reasonable, test every
-			 * possible non-zero, non-reserved bitmap combination
-			 * only with the native PMU version and the full bit
-			 * vector length.
+			 * To keep the total runtime reasonable, especially after
+			 * the total number of arch-events increasing to 13, It's
+			 * impossible to test every possible non-zero, non-reserved
+			 * bitmap combination. Only test the first 8-bits combination
+			 * with the native PMU version and the full bit vector length.
 			 */
 			if (v == pmu_version) {
-				for (k = 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
+				int max_events = min(NR_INTEL_ARCH_EVENTS, 8);
+
+				for (k = 1; k < (BIT(max_events) - 1); k++)
 					test_arch_events(v, perf_caps[i], NR_INTEL_ARCH_EVENTS, k);
 			}
+
 			/*
 			 * Test single bits for all PMU version and lengths up
 			 * the number of events +1 (to verify KVM doesn't do
-- 
2.43.0


