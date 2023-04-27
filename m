Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040E46F03C8
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbjD0J4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 05:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242993AbjD0J4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 05:56:22 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABEA2684;
        Thu, 27 Apr 2023 02:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682589382; x=1714125382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qcFa5WhDhth2RthO+KE8joUY3Ff88MyzXmCj6BoFCww=;
  b=ayhk5npi+GU41W0eaGLJ0dJLHhhU1NG3wq5VdnBDddOLQoP7k69ubv8B
   QIoOYikR5jUb5Dj/YzwFW/Qe9jROlHRdR+E3qgSD9wdP/raVNi0OI7pGA
   KCdEjB1vgRT6EXQtdNA3u5m3iFtAB9+SGGaxz3+mrr67OkuKOb12bo/DA
   w=;
X-IronPort-AV: E=Sophos;i="5.99,230,1677542400"; 
   d="scan'208";a="280561672"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 09:56:14 +0000
Received: from EX19MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id 518F641418;
        Thu, 27 Apr 2023 09:56:10 +0000 (UTC)
Received: from EX19D008UEC003.ant.amazon.com (10.252.135.194) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Apr 2023 09:56:07 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEC003.ant.amazon.com (10.252.135.194) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Apr 2023 09:56:07 +0000
Received: from dev-dsk-abusse-1c-9fba1bbe.eu-west-1.amazon.com (10.13.253.110)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26 via Frontend Transport; Thu, 27 Apr 2023 09:56:06 +0000
From:   Anselm Busse <abusse@amazon.com>
CC:     <dwmw@amazon.co.uk>, <hborghor@amazon.de>, <sironi@amazon.de>,
        "Anselm Busse" <abusse@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] KVM: vmx/pmu: Indicate available fixed function PMCs through a bitmap
Date:   Thu, 27 Apr 2023 09:53:32 +0000
Message-ID: <20230427095333.35038-2-abusse@amazon.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230427095333.35038-1-abusse@amazon.com>
References: <20230427095333.35038-1-abusse@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit changes the tracking of available fixed function counters
from a number to a bitmap.

Starting with Intel PMU v5, the available fixed function counters cannot
only be advertised through a number, but also through a bitmap in
CPUID.0AH.ECX. However, the current KVM implementation determines if a
fixed function PMC is available to a guest purely based on the number
of exposed fixed function PMCs. This makes it impossible to use this
new feature of the Intel PMU v5. Therefore, this change serves as a
preparation to seamlessly enable the virtualization of Intel PMU v5 in
the future.

No functional change intended.

Signed-off-by: Anselm Busse <abusse@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/pmu.h              |  6 +++---
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 33 ++++++++++++++++++---------------
 4 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 808c292ad3f4..ea4859554678 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -516,7 +516,7 @@ struct kvm_pmc {
 #define KVM_AMD_PMC_MAX_GENERIC	6
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
-	unsigned nr_arch_fixed_counters;
+	DECLARE_BITMAP(mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED);
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
 	u64 fixed_ctr_ctrl_mask;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index be62c16f2265..11940c97f7a4 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -116,9 +116,9 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
 {
 	int base = MSR_CORE_PERF_FIXED_CTR0;
 
-	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
-		u32 index = array_index_nospec(msr - base,
-					       pmu->nr_arch_fixed_counters);
+	if (msr >= base && msr < base + INTEL_PMC_MAX_FIXED &&
+	    test_bit(msr - base, pmu->mask_arch_fixed_counters)) {
+		u32 index = array_index_nospec(msr - base, INTEL_PMC_MAX_FIXED);
 
 		return &pmu->fixed_counters[index];
 	}
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index cc77a0681800..ce8bd53aa6cc 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -184,7 +184,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
-	pmu->nr_arch_fixed_counters = 0;
+	bitmap_zero(pmu->mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED);
 	pmu->global_status = 0;
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..55ff06a9df47 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -47,7 +47,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 	int i;
 
 	pmu->fixed_ctr_ctrl = data;
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+	for_each_set_bit(i, pmu->mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED) {
 		u8 new_ctrl = fixed_ctrl_field(data, i);
 		u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
 
@@ -125,7 +125,7 @@ static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 
 	idx &= ~(3u << 30);
 
-	return fixed ? idx < pmu->nr_arch_fixed_counters
+	return fixed ? test_bit(idx, pmu->mask_arch_fixed_counters)
 		     : idx < pmu->nr_arch_gp_counters;
 }
 
@@ -140,12 +140,12 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	idx &= ~(3u << 30);
 	if (fixed) {
 		counters = pmu->fixed_counters;
-		num_counters = pmu->nr_arch_fixed_counters;
+		num_counters = INTEL_PMC_MAX_FIXED;
 	} else {
 		counters = pmu->gp_counters;
 		num_counters = pmu->nr_arch_gp_counters;
 	}
-	if (idx >= num_counters)
+	if (idx >= num_counters || (fixed && !test_bit(idx, pmu->mask_arch_fixed_counters)))
 		return NULL;
 	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
 	return &counters[array_index_nospec(idx, num_counters)];
@@ -499,7 +499,7 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 	u32 event;
 	int i;
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+	for_each_set_bit(i, pmu->mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED) {
 		pmc = &pmu->fixed_counters[i];
 		event = fixed_pmc_events[array_index_nospec(i, size)];
 		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
@@ -519,7 +519,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	int i;
 
 	pmu->nr_arch_gp_counters = 0;
-	pmu->nr_arch_fixed_counters = 0;
+	bitmap_zero(pmu->mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED);
 	pmu->counter_bitmask[KVM_PMC_GP] = 0;
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
@@ -552,12 +552,12 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 					((1ull << eax.split.mask_length) - 1);
 
 	if (pmu->version == 1) {
-		pmu->nr_arch_fixed_counters = 0;
+		bitmap_zero(pmu->mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED);
 	} else {
-		pmu->nr_arch_fixed_counters =
+		bitmap_set(pmu->mask_arch_fixed_counters, 0,
 			min3(ARRAY_SIZE(fixed_pmc_events),
 			     (size_t) edx.split.num_counters_fixed,
-			     (size_t)kvm_pmu_cap.num_counters_fixed);
+			     (size_t)kvm_pmu_cap.num_counters_fixed));
 		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
@@ -565,10 +565,13 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+	counter_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
+
+	for_each_set_bit(i, pmu->mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED) {
 		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
-	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
-		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
+		counter_mask &= ~(1ull << (INTEL_PMC_MAX_GENERIC + i));
+	}
+
 	pmu->global_ctrl_mask = counter_mask;
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
@@ -587,8 +590,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	bitmap_set(pmu->all_valid_pmc_idx,
 		0, pmu->nr_arch_gp_counters);
-	bitmap_set(pmu->all_valid_pmc_idx,
-		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
+	for_each_set_bit(i, pmu->mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED)
+		set_bit(INTEL_PMC_MAX_GENERIC + i, pmu->all_valid_pmc_idx);
 
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 	if (cpuid_model_is_consistent(vcpu) &&
@@ -604,7 +607,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = counter_mask;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
-			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+			for_each_set_bit(i, pmu->mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED) {
 				pmu->fixed_ctr_ctrl_mask &=
 					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
 			}
-- 
2.39.2




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



