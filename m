Return-Path: <kvm+bounces-7126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D997E83D6E0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F062B2DC99
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4E5152DE4;
	Fri, 26 Jan 2024 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RooFUHJF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A68145C1F;
	Fri, 26 Jan 2024 08:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259536; cv=none; b=QyfyQ4jNTXNEgkH7RfSLw7UvtTU/NNspL0EY++IHO+VSGDJWFWIiRysp0VVsflyPreo86qwGg6F4kPoA416NtFqBffdWDbOIBXD9wv9dRttKfKMWc+1MkxzhC8LNDxSWAnu7dsUjca6V2NO/LLBfeKvyHzpIrp/WbixlRyiby0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259536; c=relaxed/simple;
	bh=bHmNwJkArTRO1rWzmQTGEV8UCY3qgs/M5gvIXwoJB5Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hSoTgFh3dvTJ7yMBEEuTOMzv3cJsSw3UBqJathDysPzj8m7J5AcbYbpMMNgRRg7em24d7HDkMAs5nqlJjK6CWKE3sxDJSFs4L0tnVsqu/nfA2siH+YUrwcAGlwq/zrYk18aucssBL3fNMNXUN4hPdp2YjCEr3f5fMQH/If392jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RooFUHJF; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259535; x=1737795535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bHmNwJkArTRO1rWzmQTGEV8UCY3qgs/M5gvIXwoJB5Y=;
  b=RooFUHJFtMAH9TaR9KED3j8TG/M+kE2mIu90EX1HXG14DX2b164BWu2K
   fTiy/j7ax0RrmQp3pMQz8gJfTQIaU6LiJTfY1ro4GPXpz4nQ5Iw4P4lZt
   3d/J4fLIzIPbi9FYbbCDI/aD2obNq8FJjjsxIQyX+avc2WsMM735BeoKE
   CMP2pDa3yY5v/ddjNsXT1yyAMkPiA3gsV/BfVmabOm6+8vHxZoKLQFoqr
   2ae0MOAtSzt1HOak4akoaXhyIMQ0fTgXWwKJwiQNb8AOrgQwZ4aKA1Gaq
   BF3Kk106o29xzy9UygmqQdoN0Urr+agFebxS2BgqdFD8JuJ4BHl7M+Cfv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9793100"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9793100"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310528"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310528"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:49 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 39/41] KVM: x86/pmu: Implement emulated counter increment for passthrough PMU
Date: Fri, 26 Jan 2024 16:54:42 +0800
Message-Id: <20240126085444.324918-40-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mingwei Zhang <mizhang@google.com>

Implement emulated counter increment for passthrough PMU under KVM_REQ_PMU.
Defer the counter increment to KVM_REQ_PMU handler because counter
increment requests come from kvm_pmu_trigger_event() which can be triggered
within the KVM_RUN inner loop or outside of the inner loop. This means the
counter increment could happen before or after PMU context switch.

So process counter increment in one place makes the implementation simple.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              | 52 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/pmu.h              |  1 +
 arch/x86/kvm/x86.c              |  8 +++--
 4 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 869de0d81055..9080319751de 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -532,6 +532,7 @@ struct kvm_pmu {
 	u64 fixed_ctr_ctrl_mask;
 	u64 global_ctrl;
 	u64 global_status;
+	u64 synthesized_overflow;
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
 	u64 global_status_mask;
@@ -550,6 +551,7 @@ struct kvm_pmu {
 		atomic64_t __reprogram_pmi;
 	};
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
+	DECLARE_BITMAP(incremented_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
 	u64 ds_area;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7b0bac1ac4bf..9e62e96fe48a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -449,6 +449,26 @@ static bool kvm_passthrough_pmu_incr_counter(struct kvm_pmc *pmc)
 	return false;
 }
 
+void kvm_passthrough_pmu_handle_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	int bit;
+
+	for_each_set_bit(bit, pmu->incremented_pmc_idx, X86_PMC_IDX_MAX) {
+		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
+
+		if (kvm_passthrough_pmu_incr_counter(pmc)) {
+			__set_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->synthesized_overflow);
+
+			if (pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT)
+				kvm_make_request(KVM_REQ_PMI, vcpu);
+		}
+	}
+	bitmap_zero(pmu->incremented_pmc_idx, X86_PMC_IDX_MAX);
+	pmu->global_status |= pmu->synthesized_overflow;
+	pmu->synthesized_overflow = 0;
+}
+
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -748,7 +768,29 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
 }
 
-void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
+static void __kvm_passthrough_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
+	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
+		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
+
+		if (!pmc || !pmc_speculative_in_use(pmc) ||
+		    !check_pmu_event_filter(pmc))
+			continue;
+
+		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
+		if (eventsel_match_perf_hw_id(pmc, perf_hw_id) && cpl_is_matched(pmc)) {
+			pmc->emulated_counter += 1;
+			__set_bit(pmc->idx, pmu->incremented_pmc_idx);
+			kvm_make_request(KVM_REQ_PMU, vcpu);
+		}
+	}
+}
+
+static void __kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
@@ -765,6 +807,14 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 			kvm_pmu_incr_counter(pmc);
 	}
 }
+
+void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
+{
+	if (is_passthrough_pmu_enabled(vcpu))
+		__kvm_passthrough_pmu_trigger_event(vcpu, perf_hw_id);
+	else
+		__kvm_pmu_trigger_event(vcpu, perf_hw_id);
+}
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
 static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 6f44fe056368..0fc37a06fe48 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -277,6 +277,7 @@ static inline bool is_passthrough_pmu_enabled(struct kvm_vcpu *vcpu)
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
+void kvm_passthrough_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe7da1a16c3b..1bbf312cbd73 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10726,8 +10726,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			record_steal_time(vcpu);
-		if (kvm_check_request(KVM_REQ_PMU, vcpu))
-			kvm_pmu_handle_event(vcpu);
+		if (kvm_check_request(KVM_REQ_PMU, vcpu)) {
+			if (is_passthrough_pmu_enabled(vcpu))
+				kvm_passthrough_pmu_handle_event(vcpu);
+			else
+				kvm_pmu_handle_event(vcpu);
+		}
 		if (kvm_check_request(KVM_REQ_PMI, vcpu))
 			kvm_pmu_deliver_pmi(vcpu);
 #ifdef CONFIG_KVM_SMM
-- 
2.34.1


