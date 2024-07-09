Return-Path: <kvm+bounces-21159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E010C92B1AB
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 09:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CCF42823A3
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 07:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D6714E2D9;
	Tue,  9 Jul 2024 07:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cLJ2IeGA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A82145324;
	Tue,  9 Jul 2024 07:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720511937; cv=none; b=dazPh5o+QwE0gLtBsPUKmohqNObfZA7qBmjWyNo6vZkmguu5SoAfWzYouytt8DbROCQyIq5UqGvMjky8eFcJqH/4aBeIc/MIQDq99bnAMativ5QWo7fKeKm1dg6CQkpuq2a05Z/Ybht9iUs2a4qSLZ/oxH9xSnmB6QssqWz7iwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720511937; c=relaxed/simple;
	bh=bKwtyn9GyQl3QIVX3DiIrXVZ728SUiDGt68+3zP0kk4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gSvzquGhz7d/LrNLKN5EFx0qrMycFm0C97CbYRw4B+g0Xzn4rVNhDxitoGAT1QCGzuo5oXDuIlVe1uCHAtXbou+bq/2hm5kj7bw9g5BzmD/kfneqdj0dfstoej/b2vTlWKHkog4tZl8yne5wTL4QKUOyoigyCMpPejuRfpR7iuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cLJ2IeGA; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720511936; x=1752047936;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bKwtyn9GyQl3QIVX3DiIrXVZ728SUiDGt68+3zP0kk4=;
  b=cLJ2IeGAm4+zIWSumNUFWhCtJgoIUFxjitXvjx3FnYd9J0j76KF9MwXv
   HVXNx2yTtv4iuT/+U0fE0eK83SCncmMifqYft51ofFwLIUeMOMgYwxQFw
   NsO6G8oFttjNGjocCIKk1R+VxMGsGzZRfzOekxJiqXdVhCejVS4WSVz98
   L+rBXl6WrTgFV8mnbv4MfkLTjZlwMkMnAvCBnzXAjx/0f+NCIhVUhqURP
   flqJitYnWlNquEO9ySp3k0xyXPlKEhKdEMpUsASlu13Oviq/Do1aeUrTY
   9vhrjt071iOS5M3ChDIFNNHe7+BP+nLoa0Nu0PcgheqQeU5JdlNYFGI69
   A==;
X-CSE-ConnectionGUID: 9Rqpt7bZTimhwy3luhtzsQ==
X-CSE-MsgGUID: NjsMtjfzQp+S/YlfEAYZSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="21559780"
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="21559780"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 00:58:56 -0700
X-CSE-ConnectionGUID: bUa1RoZVTP+jl/NkiZb1ug==
X-CSE-MsgGUID: cZU6D+hfTLKr08NPd7M2nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="48496861"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa008.jf.intel.com with ESMTP; 09 Jul 2024 00:58:52 -0700
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
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Gleb Natapov <gleb@redhat.com>
Subject: [PATCH] KVM: x86/pmu: Return KVM_MSR_RET_INVALID for invalid PMU MSR access
Date: Tue,  9 Jul 2024 14:55:00 +0000
Message-Id: <20240709145500.45547-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return KVM_MSR_RET_INVALID instead of 0 to inject #GP to guest for all
invalid PMU MSRs access

Currently KVM silently drops the access and doesn't inject #GP for some
invalid PMU MSRs like MSR_P6_PERFCTR0/MSR_P6_PERFCTR1,
MSR_P6_EVNTSEL0/MSR_P6_EVNTSEL1, but KVM still injects #GP for all other
invalid PMU MSRs. This leads to guest see different behavior on invalid
PMU access and may confuse guest.

This behavior is introduced by the
'commit 5753785fa977 ("KVM: do not #GP on perf MSR writes when vPMU is disabled")'
in 2012. This commit seems to want to keep back compatible with weird
behavior of some guests in vPMU disabled case, but strongly suspect if
it's still available nowadays.

Since Perfmon v6 starts, the GP counters could become discontinuous on
HW, It's possible that HW doesn't support GP counters 0 and 1.
Considering this situation KVM should inject #GP for all invalid PMU MSRs
access.

Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/x86.c                             | 18 ------------------
 .../selftests/kvm/x86_64/pmu_counters_test.c   |  7 +------
 2 files changed, 1 insertion(+), 24 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 994743266480..d92321d37892 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4051,16 +4051,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return set_msr_mce(vcpu, msr_info);
 
-	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
-	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
-	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
-	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr))
-			return kvm_pmu_set_msr(vcpu, msr_info);
-
-		if (data)
-			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
-		break;
 	case MSR_K7_CLK_CTL:
 		/*
 		 * Ignore all writes to this no longer documented MSR.
@@ -4239,14 +4229,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_DRAM_ENERGY_STATUS:	/* DRAM controller */
 		msr_info->data = 0;
 		break;
-	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
-	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
-	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
-	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info);
-		msr_info->data = 0;
-		break;
 	case MSR_IA32_UCODE_REV:
 		msr_info->data = vcpu->arch.microcode_version;
 		break;
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 698cb36989db..62ed765d2aa7 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -376,13 +376,8 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		 */
 		const bool expect_success = i < nr_counters || (or_mask & BIT(i));
 
-		/*
-		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
-		 * unsupported, i.e. doesn't #GP and reads back '0'.
-		 */
 		const uint64_t expected_val = expect_success ? test_val : 0;
-		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
-				       msr != MSR_P6_PERFCTR1;
+		const bool expect_gp = !expect_success;
 		uint32_t rdpmc_idx;
 		uint8_t vector;
 		uint64_t val;

base-commit: 771df9ffadb8204e61d3e98f36c5067102aab78f
-- 
2.40.1


