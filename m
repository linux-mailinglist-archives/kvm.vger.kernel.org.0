Return-Path: <kvm+bounces-58093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DC3B8787E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0F19564568
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 526E025A62E;
	Fri, 19 Sep 2025 00:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y46bmjHf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6699257852
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758242725; cv=none; b=q/x3fuDxtXLnJywo80RUJzB2xaaOvhkCzstHFuhVc7Dq9aBg0dlaShsjERSbxaQ4nGBiax+nEee3xmSVDLQt3ROZj7tviBdfBsd5/odKFrbfGIdzpNOgLGLRKqCRDBCZmVhY8sbCb7zIZUI74Jpeex9JJuSLA/bkEiGR7WOHhdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758242725; c=relaxed/simple;
	bh=pu5kp6pYW+tq5sBpPFCMOucqNiW0W1L/AzTSZAL567I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T05WzK82RTjks4BzP3MBTGO21hL8zjJ3weqvmxg4NFuqHmGr1WWsRvjLAn3DBBV+jHBOHwpf9IKQgVDfu/usesUp/HDB2npW9ePke8KbLHPEDrV2ztJYfl5/rP4EK3xZkFj9LOgJRYhJI7gCMDMR9j/DxmXxC08scXRZbQgx+5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y46bmjHf; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-267fa90a2fbso28384895ad.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758242723; x=1758847523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=K3g1+aaL01ByoZzXTzpQww+Yiuz3bE8C4orevXKBlGM=;
        b=y46bmjHfNM//N+tnuverzhAUKh6zhEwq0lyGxA+JraXRyV67jZIKPW8RToW6/UtZ9+
         IPkAxHDOvAgNoeDosvObbOI6L8fZ5evd4JoBaGH+nUKZqPhGv+8lPyEhXaq8N+oDld1v
         sRt4S26YqC1iESf9ySvyAcOdyOiecfm+qyjLselma9jrttbIYUQsemTI62f8RUEambHF
         G4sDSrIwb6TB0L0I3Cfc1V9SwQuyYC2vF+Jb4Trxk3w07XKi6cmivhB7fJ2UGYtkiHeh
         dWEoDJicnIroXMj/K1D6vkQ9kEYe54efJkaTWZzz5AAu0XrbZW+pw4apR7tgVZW46wv8
         ciWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758242723; x=1758847523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K3g1+aaL01ByoZzXTzpQww+Yiuz3bE8C4orevXKBlGM=;
        b=CBDRYKeX0GiCfRYf3R7d1bVPEs1XwZpvu+q6UC36of5KSS1XtThYCKBxwgCyEDEHiL
         nSk9gd27NjnB5sVWYqgT2Lul+H8i7376wzJ5SeFt7OO9F3ZNjAOI4iavTyPwdwH3wMSW
         oLb3bMd+x+SekqoX92NCjXzsIJAKxH14xGM2SkxzH0+X/WzERj0Cfxgzwc6sYNpZJyf0
         Z13TniVhHgx+qsQbToA2WwHwl++5ZX625+OMOWw8cB0izFicExAoapBky/In5Bq/m+ws
         mwLvTdCJ+SWWpGS990KhOS16o42uWgiD5G0LpHfrrstZrYhmx0DQD8ljNNAre9A0VzIZ
         Nw0Q==
X-Gm-Message-State: AOJu0YzGRc4r4UhuR5+F36n85z+PNn2cihxsm19QaYgTInQ4DwlFWhnx
	F+VCtBO1SITit+xVFrO0J2rV3JGoaCYg+S7a01VyYPSnS77zj18dTS0uuK13oYSzZHMLMdT9Sus
	dmABCyA==
X-Google-Smtp-Source: AGHT+IFR49E4UblXd44Lqj4iHyLUQu+gME1thr5lLZEYp1+FSVWGE5J7nHz78BmbEwgwpc2lagPA2VtxBbY=
X-Received: from pjbnw4.prod.google.com ([2002:a17:90b:2544:b0:32b:65c6:661a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e547:b0:251:a3b3:1572
 with SMTP id d9443c01a7336-2697c815446mr66755475ad.9.1758242723280; Thu, 18
 Sep 2025 17:45:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:45:12 -0700
In-Reply-To: <20250919004512.1359828-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919004512.1359828-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919004512.1359828-6-seanjc@google.com>
Subject: [PATCH v3 5/5] KVM: selftests: Handle Intel Atom errata that leads to
 PMU event overcount
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Yi Lai <yi1.lai@intel.com>, 
	dongsheng <dongsheng.x.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: dongsheng <dongsheng.x.zhang@intel.com>

Add a PMU errata framework and use it to relax precise event counts on
Atom platforms that overcount "Instruction Retired" and "Branch Instruction
Retired" events, as the overcount issues on VM-Exit/VM-Entry are impossible
to prevent from userspace, e.g. the test can't prevent host IRQs.

Setup errata during early initialization and automatically sync the mask
to VMs so that tests can check for errata without having to manually
manage host=>guest variables.

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

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/pmu.h | 14 ++++++
 tools/testing/selftests/kvm/lib/x86/pmu.c     | 44 +++++++++++++++++++
 .../testing/selftests/kvm/lib/x86/processor.c |  4 ++
 .../selftests/kvm/x86/pmu_counters_test.c     | 12 ++++-
 .../selftests/kvm/x86/pmu_event_filter_test.c |  4 +-
 5 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h b/tools/testing/selftests/kvm/include/x86/pmu.h
index 2aabda2da002..25d2b476daf4 100644
--- a/tools/testing/selftests/kvm/include/x86/pmu.h
+++ b/tools/testing/selftests/kvm/include/x86/pmu.h
@@ -5,6 +5,7 @@
 #ifndef SELFTEST_KVM_PMU_H
 #define SELFTEST_KVM_PMU_H
 
+#include <stdbool.h>
 #include <stdint.h>
 
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS			300
@@ -104,4 +105,17 @@ enum amd_pmu_zen_events {
 extern const uint64_t intel_pmu_arch_events[];
 extern const uint64_t amd_pmu_zen_events[];
 
+enum pmu_errata {
+	INSTRUCTIONS_RETIRED_OVERCOUNT,
+	BRANCHES_RETIRED_OVERCOUNT,
+};
+extern uint64_t pmu_errata_mask;
+
+void kvm_init_pmu_errata(void);
+
+static inline bool this_pmu_has_errata(enum pmu_errata errata)
+{
+	return pmu_errata_mask & errata;
+}
+
 #endif /* SELFTEST_KVM_PMU_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/pmu.c b/tools/testing/selftests/kvm/lib/x86/pmu.c
index 5ab44bf54773..34cb57d1d671 100644
--- a/tools/testing/selftests/kvm/lib/x86/pmu.c
+++ b/tools/testing/selftests/kvm/lib/x86/pmu.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 
 #include "kvm_util.h"
+#include "processor.h"
 #include "pmu.h"
 
 const uint64_t intel_pmu_arch_events[] = {
@@ -34,3 +35,46 @@ const uint64_t amd_pmu_zen_events[] = {
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
+static uint64_t get_pmu_errata(void)
+{
+	if (!this_cpu_is_intel())
+		return 0;
+
+	if (this_cpu_family() != 0x6)
+		return 0;
+
+	switch (this_cpu_model()) {
+	case 0xDD: /* Clearwater Forest */
+		return BIT_ULL(INSTRUCTIONS_RETIRED_OVERCOUNT);
+	case 0xAF: /* Sierra Forest */
+	case 0x4D: /* Avaton, Rangely */
+	case 0x5F: /* Denverton */
+	case 0x86: /* Jacobsville */
+		return BIT_ULL(INSTRUCTIONS_RETIRED_OVERCOUNT) |
+		       BIT_ULL(BRANCHES_RETIRED_OVERCOUNT);
+	default:
+		return 0;
+	}
+}
+
+uint64_t pmu_errata_mask;
+
+void kvm_init_pmu_errata(void)
+{
+	pmu_errata_mask = get_pmu_errata();
+}
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 3b63c99f7b96..4402d2e1ea69 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -6,6 +6,7 @@
 #include "linux/bitmap.h"
 #include "test_util.h"
 #include "kvm_util.h"
+#include "pmu.h"
 #include "processor.h"
 #include "sev.h"
 
@@ -638,6 +639,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 	sync_global_to_guest(vm, host_cpu_is_intel);
 	sync_global_to_guest(vm, host_cpu_is_amd);
 	sync_global_to_guest(vm, is_forced_emulation_enabled);
+	sync_global_to_guest(vm, pmu_errata_mask);
 
 	if (is_sev_vm(vm)) {
 		struct kvm_sev_init init = { 0 };
@@ -1269,6 +1271,8 @@ void kvm_selftest_arch_init(void)
 	host_cpu_is_intel = this_cpu_is_intel();
 	host_cpu_is_amd = this_cpu_is_amd();
 	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
+
+	kvm_init_pmu_errata();
 }
 
 bool sys_clocksource_is_based_on_tsc(void)
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index baa7b8a2d459..acb5a5c37296 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -163,10 +163,18 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
 
 	switch (idx) {
 	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
-		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
+		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
+		if (this_pmu_has_errata(INSTRUCTIONS_RETIRED_OVERCOUNT))
+			GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
+		else
+			GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
 		break;
 	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
-		GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
+		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue */
+		if (this_pmu_has_errata(BRANCHES_RETIRED_OVERCOUNT))
+			GUEST_ASSERT(count >= NUM_BRANCH_INSNS_RETIRED);
+		else
+			GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED);
 		break;
 	case INTEL_ARCH_LLC_REFERENCES_INDEX:
 	case INTEL_ARCH_LLC_MISSES_INDEX:
diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
index c15513cd74d1..1c5b7611db24 100644
--- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
@@ -214,8 +214,10 @@ static void remove_event(struct __kvm_pmu_event_filter *f, uint64_t event)
 do {											\
 	uint64_t br = pmc_results.branches_retired;					\
 	uint64_t ir = pmc_results.instructions_retired;					\
+	bool br_matched = this_pmu_has_errata(BRANCHES_RETIRED_OVERCOUNT) ?		\
+			  br >= NUM_BRANCHES : br == NUM_BRANCHES;			\
 											\
-	if (br && br != NUM_BRANCHES)							\
+	if (br && !br_matched)								\
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
 			__func__, br, NUM_BRANCHES);					\
 	TEST_ASSERT(br, "%s: Branch instructions retired = %lu (expected > 0)",		\
-- 
2.51.0.470.ga7dc726c21-goog


