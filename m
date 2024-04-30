Return-Path: <kvm+bounces-16205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A398B6700
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 02:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A744A1C228E6
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 00:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604208BF1;
	Tue, 30 Apr 2024 00:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j8uwwhA/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDB13232;
	Tue, 30 Apr 2024 00:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714437953; cv=none; b=khCzx3Zwkkh34YZmR30sDAT0VBqUEMTM5rtHwXq7yICea+urc5Vg/yZSLHek29VkZ+piLC8FH9n1RCxWDXKmGcpKDhutmIKMEUV/ZR14j6m6nR9aldh50okFNC2ybi4mUorWdYxqI+OwYdhs8UfStGUjl5xQpJEnHtSDQ7ib8Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714437953; c=relaxed/simple;
	bh=TdjZzcSnWK31FFEeVLmFtgAwaYimer6fJ7p8JCxcxWc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C5fryNrfrlA+ZpztxOFOQzVHGE2a0NCRYcgG4GVIL+04tJi4ea27cvDDEbKt3gtxgktWx7dGx5sokJGzRjTmu40FrWFnn75aoNkxKymFsRo/q5Gz+muLNfmcBXaeS/4kmF/vUUyoUshUa2hZfOw5pQEF8aPa2kDFR6+54PPQRrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j8uwwhA/; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714437952; x=1745973952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TdjZzcSnWK31FFEeVLmFtgAwaYimer6fJ7p8JCxcxWc=;
  b=j8uwwhA/9R6X2YevenAKO6A8kEvh2nHPHHSIowZzLI0DTuC8yz8PCuTc
   AZj/yjjP1vdUMXovLa+TWZ+8DU0PTUAyLXYpcFYgBjrXa/LT/CcFvrheo
   6XMUAtXGNdlXTwme30215wowktJpbFczwqR17NqZUjo6LS8u8oMHwmmnB
   QUWPW9BJPCmCLGZ0COpE1zjLafIBfZGofreku4jmfjyRNz7+/H8gil8P8
   FqbSOHbtr+Wze6LB7gaguc5wxXWkbkV2Y90XXNcSJteCYtoUMPjnkZM8a
   m90RSUAVXRvw/Hs3d5d0Tr7NqHojNCx4Jb9/kwndvihi0FknGyNcvTsee
   A==;
X-CSE-ConnectionGUID: wHC4bNU/Rlu5ZE7iyvk6dA==
X-CSE-MsgGUID: O1BjH6VqSLum0HTzfr7RXA==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="10658592"
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="10658592"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 17:45:52 -0700
X-CSE-ConnectionGUID: zTp0AtE8TF+GGf4Kp6DCyA==
X-CSE-MsgGUID: 9MFXC5vlR/usE5PvRTX8KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="31079800"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by orviesa005.jf.intel.com with ESMTP; 29 Apr 2024 17:45:49 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 1/2] KVM: x86/pmu: Change ambiguous _mask suffix to _rsvd in kvm_pmu
Date: Tue, 30 Apr 2024 08:52:38 +0800
Message-Id: <20240430005239.13527-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240430005239.13527-1-dapeng1.mi@linux.intel.com>
References: <20240430005239.13527-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several '_mask' suffixed variables such as, global_ctrl_mask, are
defined in kvm_pmu structure. However the _mask suffix is ambiguous and
misleading since it's not a real mask with positive logic. On the contrary
it represents the reserved bits of corresponding MSRs and these bits
should not be accessed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 10 +++++-----
 arch/x86/kvm/pmu.c              | 16 ++++++++--------
 arch/x86/kvm/pmu.h              |  2 +-
 arch/x86/kvm/svm/pmu.c          |  4 ++--
 arch/x86/kvm/vmx/pmu_intel.c    | 26 +++++++++++++-------------
 5 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d13e3cd1dc5..90edb7d30fce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -543,12 +543,12 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
-	u64 fixed_ctr_ctrl_mask;
+	u64 fixed_ctr_ctrl_rsvd;
 	u64 global_ctrl;
 	u64 global_status;
 	u64 counter_bitmask[2];
-	u64 global_ctrl_mask;
-	u64 global_status_mask;
+	u64 global_ctrl_rsvd;
+	u64 global_status_rsvd;
 	u64 reserved_bits;
 	u64 raw_event_mask;
 	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
@@ -568,9 +568,9 @@ struct kvm_pmu {
 
 	u64 ds_area;
 	u64 pebs_enable;
-	u64 pebs_enable_mask;
+	u64 pebs_enable_rsvd;
 	u64 pebs_data_cfg;
-	u64 pebs_data_cfg_mask;
+	u64 pebs_data_cfg_rsvd;
 
 	/*
 	 * If a guest counter is cross-mapped to host counter with different
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a593b03c9aed..afbd67ca782c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -681,13 +681,13 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated)
 			break;
 
-		if (data & pmu->global_status_mask)
+		if (data & pmu->global_status_rsvd)
 			return 1;
 
 		pmu->global_status = data;
 		break;
 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
-		data &= ~pmu->global_ctrl_mask;
+		data &= ~pmu->global_ctrl_rsvd;
 		fallthrough;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		if (!kvm_valid_perf_global_ctrl(pmu, data))
@@ -704,7 +704,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
 		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
 		 */
-		if (data & pmu->global_status_mask)
+		if (data & pmu->global_status_rsvd)
 			return 1;
 		fallthrough;
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
@@ -768,11 +768,11 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
-	pmu->global_ctrl_mask = ~0ull;
-	pmu->global_status_mask = ~0ull;
-	pmu->fixed_ctr_ctrl_mask = ~0ull;
-	pmu->pebs_enable_mask = ~0ull;
-	pmu->pebs_data_cfg_mask = ~0ull;
+	pmu->global_ctrl_rsvd = ~0ull;
+	pmu->global_status_rsvd = ~0ull;
+	pmu->fixed_ctr_ctrl_rsvd = ~0ull;
+	pmu->pebs_enable_rsvd = ~0ull;
+	pmu->pebs_data_cfg_rsvd = ~0ull;
 	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
 
 	if (!vcpu->kvm->arch.enable_pmu)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 4d52b0b539ba..2eab8ea610db 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -129,7 +129,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
 						 u64 data)
 {
-	return !(pmu->global_ctrl_mask & data);
+	return !(pmu->global_ctrl_rsvd & data);
 }
 
 /* returns general purpose PMC with the specified MSR. Note that it can be
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index dfcc38bd97d3..6e908bdc3310 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -199,8 +199,8 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 					 kvm_pmu_cap.num_counters_gp);
 
 	if (pmu->version > 1) {
-		pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
-		pmu->global_status_mask = pmu->global_ctrl_mask;
+		pmu->global_ctrl_rsvd = ~((1ull << pmu->nr_arch_gp_counters) - 1);
+		pmu->global_status_rsvd = pmu->global_ctrl_rsvd;
 	}
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index be40474de6e4..eaee9a08952e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -348,14 +348,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
-		if (data & pmu->fixed_ctr_ctrl_mask)
+		if (data & pmu->fixed_ctr_ctrl_rsvd)
 			return 1;
 
 		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
 	case MSR_IA32_PEBS_ENABLE:
-		if (data & pmu->pebs_enable_mask)
+		if (data & pmu->pebs_enable_rsvd)
 			return 1;
 
 		if (pmu->pebs_enable != data) {
@@ -371,7 +371,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		pmu->ds_area = data;
 		break;
 	case MSR_PEBS_DATA_CFG:
-		if (data & pmu->pebs_data_cfg_mask)
+		if (data & pmu->pebs_data_cfg_rsvd)
 			return 1;
 
 		pmu->pebs_data_cfg = data;
@@ -456,7 +456,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
 	u64 perf_capabilities;
-	u64 counter_mask;
+	u64 counter_rsvd;
 	int i;
 
 	memset(&lbr_desc->records, 0, sizeof(lbr_desc->records));
@@ -502,21 +502,21 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
-		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
-	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
+		pmu->fixed_ctr_ctrl_rsvd &= ~(0xbull << (i * 4));
+	counter_rsvd = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << KVM_FIXED_PMC_BASE_IDX));
-	pmu->global_ctrl_mask = counter_mask;
+	pmu->global_ctrl_rsvd = counter_rsvd;
 
 	/*
 	 * GLOBAL_STATUS and GLOBAL_OVF_CONTROL (a.k.a. GLOBAL_STATUS_RESET)
 	 * share reserved bit definitions.  The kernel just happens to use
 	 * OVF_CTRL for the names.
 	 */
-	pmu->global_status_mask = pmu->global_ctrl_mask
+	pmu->global_status_rsvd = pmu->global_ctrl_rsvd
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
 	if (vmx_pt_mode_is_host_guest())
-		pmu->global_status_mask &=
+		pmu->global_status_rsvd &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);
@@ -544,15 +544,15 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	if (perf_capabilities & PERF_CAP_PEBS_FORMAT) {
 		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
-			pmu->pebs_enable_mask = counter_mask;
+			pmu->pebs_enable_rsvd = counter_rsvd;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
 			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
-				pmu->fixed_ctr_ctrl_mask &=
+				pmu->fixed_ctr_ctrl_rsvd &=
 					~(1ULL << (KVM_FIXED_PMC_BASE_IDX + i * 4));
 			}
-			pmu->pebs_data_cfg_mask = ~0xff00000full;
+			pmu->pebs_data_cfg_rsvd = ~0xff00000full;
 		} else {
-			pmu->pebs_enable_mask =
+			pmu->pebs_enable_rsvd =
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
 	}
-- 
2.40.1


