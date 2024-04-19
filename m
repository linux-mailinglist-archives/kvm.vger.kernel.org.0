Return-Path: <kvm+bounces-15254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B3A8AADBB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CCE63B21D74
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4497C8564D;
	Fri, 19 Apr 2024 11:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AMFulOSu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C7485276;
	Fri, 19 Apr 2024 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713526208; cv=none; b=QOqnVxkNEjNU0/5ygH1vlV1iXjhcx7RtWT/cCWP8P3aY94t7OQq46WaECmEya9nF+k6OIAeVyEx3Tp44S6CJ3V31fpCso8CzE38qMzDUuKIgF/V3VB6wwg3/j/ekLZFF5MOxVMJX/Z9kGO73Nxu4ANY9DPfjrfwTrqUHYPfdAzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713526208; c=relaxed/simple;
	bh=Ldf7k3wrY1tsDmSzNh7Qf10ghbIG0Xh8ZOKx/c6nmQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PQmcTDOcqSnRxJOeL80JsygzuME7w0o0REaQIRCISqvYUTkR/KvoIZ1GkF+fN6HrQibvdGey8Xv2R0DpSk7M+1a2qPLpaiWUHUXyS8ArmFKrXHRMD8kWQdQFALOIwkh1nTLfEAmpTdZBGHOQnYCUNDuAFVeeia9wPb01QPW0jyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AMFulOSu; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713526207; x=1745062207;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ldf7k3wrY1tsDmSzNh7Qf10ghbIG0Xh8ZOKx/c6nmQs=;
  b=AMFulOSuARLb4VK7lmEeHns+/ze682HttkCac2FlgNiSI52qHvtTvLxi
   xIXMTsBz9wIa0WysuWN1i5FVnh9T7MYVL820NBjwkUDgeyXVwFAngUXEz
   ligE97EkBf0UMdP173O8PEUqE+/aTjRCaBHi1zEdDAGnAf/QYJzRp7s4v
   h/RQTdT4vIywofsHiMuWBlxwvBC146Qupr5mM1+wTBM6tK2egJ4QYG1Q6
   zZtteXPvjEt3d+xh8dk+rYJeUH8MiCYveYYEf3IdKU8qTg3R4BZFmRHw5
   bqQ4hTZcy1Hlz+PYCvFsPEjuBjc1RWu5SuHjOuAQh5hNgxHbEOSTqRmIT
   A==;
X-CSE-ConnectionGUID: D3vOdUgRSxepVZhP8vx1dA==
X-CSE-MsgGUID: 332ZqfM6QeajHpMld3+M1Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20513174"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="20513174"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 04:30:06 -0700
X-CSE-ConnectionGUID: 21w69g2lSCST917sHZx2iA==
X-CSE-MsgGUID: RAdGnLVJT8OnuC72oqoaqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23389394"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmviesa008.fm.intel.com with ESMTP; 19 Apr 2024 04:30:05 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 3/5] KVM: x86/pmu: Add KVM_PMU_CALL() to simplify static calls of kvm_pmu_ops
Date: Fri, 19 Apr 2024 19:29:50 +0800
Message-Id: <20240419112952.15598-4-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20240419112952.15598-1-wei.w.wang@intel.com>
References: <20240419112952.15598-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to KVM_X86_CALL(), KVM_PMU_CALL() is added to streamline the usage
of static calls of kvm_pmu_ops. This improves code readability and
maintainability, while adhering to the coding style guidelines.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 24 ++++++++++++------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7249a3a2bbb1..3a2e42bb6969 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1853,6 +1853,7 @@ extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_CALL(func, ...) static_call(kvm_x86_##func)(__VA_ARGS__)
+#define KVM_PMU_CALL(func, ...) static_call(kvm_x86_pmu_##func)(__VA_ARGS__)
 
 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 1d456b69ddc6..c6f8e9ab2866 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -542,7 +542,7 @@ int kvm_pmu_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx)
 	if (!kvm_pmu_ops.check_rdpmc_early)
 		return 0;
 
-	return static_call(kvm_x86_pmu_check_rdpmc_early)(vcpu, idx);
+	return KVM_PMU_CALL(check_rdpmc_early, vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -591,7 +591,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
+	pmc = KVM_PMU_CALL(rdpmc_ecx_to_pmc, vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -607,7 +607,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
-		static_call(kvm_x86_pmu_deliver_pmi)(vcpu);
+		KVM_PMU_CALL(deliver_pmi, vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
 	}
 }
@@ -622,14 +622,14 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		break;
 	}
-	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
-		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
+	return KVM_PMU_CALL(msr_idx_to_pmc, vcpu, msr) ||
+	       KVM_PMU_CALL(is_valid_msr, vcpu, msr);
 }
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr);
+	struct kvm_pmc *pmc = KVM_PMU_CALL(msr_idx_to_pmc, vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -654,7 +654,7 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0;
 		break;
 	default:
-		return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
+		return KVM_PMU_CALL(get_msr, vcpu, msr_info);
 	}
 
 	return 0;
@@ -713,7 +713,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	default:
 		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
+		return KVM_PMU_CALL(set_msr, vcpu, msr_info);
 	}
 
 	return 0;
@@ -740,7 +740,7 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
 
-	static_call(kvm_x86_pmu_reset)(vcpu);
+	KVM_PMU_CALL(reset, vcpu);
 }
 
 
@@ -778,7 +778,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!vcpu->kvm->arch.enable_pmu)
 		return;
 
-	static_call(kvm_x86_pmu_refresh)(vcpu);
+	KVM_PMU_CALL(refresh, vcpu);
 
 	/*
 	 * At RESET, both Intel and AMD CPUs set all enable bits for general
@@ -796,7 +796,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	static_call(kvm_x86_pmu_init)(vcpu);
+	KVM_PMU_CALL(init, vcpu);
 	kvm_pmu_refresh(vcpu);
 }
 
@@ -818,7 +818,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 			pmc_stop_counter(pmc);
 	}
 
-	static_call(kvm_x86_pmu_cleanup)(vcpu);
+	KVM_PMU_CALL(cleanup, vcpu);
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
-- 
2.27.0


