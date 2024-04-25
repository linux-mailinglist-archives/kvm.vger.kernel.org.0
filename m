Return-Path: <kvm+bounces-15912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F7C8B2203
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F326B1F21E49
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 12:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C1A14A081;
	Thu, 25 Apr 2024 12:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HmPVATzK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F83149E00;
	Thu, 25 Apr 2024 12:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714049588; cv=none; b=DIz3mXQTO5vP/My78hAaw5n8zVKHexLyjkRp+dilWwLkvddkPAVFP0N5KBOK+ZfgdxypSt6t1fsfaqcXMPMV/GkQWA8GjhoITVmLXQp7ui3sAeHeXn/5AeKkiBTTjfOUw4VM7EFr2s3smuMxWsFJKUANp0YLMrkZKzhjcbBqqV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714049588; c=relaxed/simple;
	bh=XfQQ/z9BtUlkZgytQuO3SdEdKCJLzgISzH2+HARnjeE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JYXCzoF4U/PeCCHLBjRzAu49zYHgmwT58cfgLtMbue7eQENADgcJ48RE9McB3DaTJVkcItdbR64b/+AgetlrvqLeLNVN3Nk5ExzGM0cR9olhFfOZTiWxlSKsMpHLXJTboOLS3NC2NefXafkcjrJ5qVd4nwn7qwAc5MkTISwdpy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HmPVATzK; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714049587; x=1745585587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XfQQ/z9BtUlkZgytQuO3SdEdKCJLzgISzH2+HARnjeE=;
  b=HmPVATzKXMv6gKa0jtoWQm9OM3wiXAMHoo6g7kWPJ7QNhMbJOALdRbnA
   b3tFeJmFOnJqKL0azf2IYlyiiaGKLKqwm8s8cffCCa/X7/2QVID99mZOR
   4Iz+HYXOBeZEBLwtrmwS0upM8zWM1MNOsndB3tqsOa9idgmn3URmIrwwF
   UNo/9paxS3lDz+bJyr9jYvVPh4o2dlQQVzFrsWz8VBX+BijNIHy8MHY6/
   FubRipl9rol1syFOmQZoXdxqWDTd0nsUz0om0izPIOdjEPJpO/n3i8s0Z
   hb7lFWH6rZc2OcRCJt/PlvHGRwJDyvpA8fCMwWmf9rWnlOy5Ro1zME4LE
   g==;
X-CSE-ConnectionGUID: LZX3ITRvTgyTjOS1mjkapg==
X-CSE-MsgGUID: lg1NI6+ETb2b1+KTwpFu0g==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="10267430"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="10267430"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 05:53:06 -0700
X-CSE-ConnectionGUID: mF1UQcu1QwmzL4T9hwsi8w==
X-CSE-MsgGUID: dsuxEbtlSv+UCs0CdtCYYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="29691994"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orviesa003.jf.intel.com with ESMTP; 25 Apr 2024 05:53:04 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 3/3] KVM: x86/pmu: Add KVM_PMU_CALL() to simplify static calls of kvm_pmu_ops
Date: Thu, 25 Apr 2024 20:52:52 +0800
Message-Id: <20240425125252.48963-4-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20240425125252.48963-1-wei.w.wang@intel.com>
References: <20240425125252.48963-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to KVM_X86_CALL(), KVM_PMU_CALL() is added to streamline the usage
of static calls of kvm_pmu_ops, which improves code readability.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 24 ++++++++++++------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 90cdb7256a69..eafffc2e5732 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1853,6 +1853,7 @@ extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_CALL(func) static_call(kvm_x86_##func)
+#define KVM_PMU_CALL(func) static_call(kvm_x86_pmu_##func)
 
 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 6c92bc7647b3..2ec943e3d5ba 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -542,7 +542,7 @@ int kvm_pmu_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx)
 	if (!kvm_pmu_ops.check_rdpmc_early)
 		return 0;
 
-	return static_call(kvm_x86_pmu_check_rdpmc_early)(vcpu, idx);
+	return KVM_PMU_CALL(check_rdpmc_early)(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -591,7 +591,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
+	pmc = KVM_PMU_CALL(rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -607,7 +607,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
-		static_call(kvm_x86_pmu_deliver_pmi)(vcpu);
+		KVM_PMU_CALL(deliver_pmi)(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
 	}
 }
@@ -622,14 +622,14 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		break;
 	}
-	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
-		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
+	return KVM_PMU_CALL(msr_idx_to_pmc)(vcpu, msr) ||
+	       KVM_PMU_CALL(is_valid_msr)(vcpu, msr);
 }
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr);
+	struct kvm_pmc *pmc = KVM_PMU_CALL(msr_idx_to_pmc)(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -654,7 +654,7 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0;
 		break;
 	default:
-		return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
+		return KVM_PMU_CALL(get_msr)(vcpu, msr_info);
 	}
 
 	return 0;
@@ -713,7 +713,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	default:
 		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
+		return KVM_PMU_CALL(set_msr)(vcpu, msr_info);
 	}
 
 	return 0;
@@ -740,7 +740,7 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
 
-	static_call(kvm_x86_pmu_reset)(vcpu);
+	KVM_PMU_CALL(reset)(vcpu);
 }
 
 
@@ -778,7 +778,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!vcpu->kvm->arch.enable_pmu)
 		return;
 
-	static_call(kvm_x86_pmu_refresh)(vcpu);
+	KVM_PMU_CALL(refresh)(vcpu);
 
 	/*
 	 * At RESET, both Intel and AMD CPUs set all enable bits for general
@@ -796,7 +796,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	static_call(kvm_x86_pmu_init)(vcpu);
+	KVM_PMU_CALL(init)(vcpu);
 	kvm_pmu_refresh(vcpu);
 }
 
@@ -818,7 +818,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 			pmc_stop_counter(pmc);
 	}
 
-	static_call(kvm_x86_pmu_cleanup)(vcpu);
+	KVM_PMU_CALL(cleanup)(vcpu);
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
-- 
2.27.0


