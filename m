Return-Path: <kvm+bounces-16832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9218BE451
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5080B289B37
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 13:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C17D16ABD8;
	Tue,  7 May 2024 13:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPGyjPaY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEEE168B0B;
	Tue,  7 May 2024 13:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715088677; cv=none; b=vA0KUnqc9OZ3lhr5U2lTjUUDLC5ZNLGH3e8mo1FwndXOVrsbaYAnjn8xt9v5Dhw6+gcsTSGmb+MznxaDJJZcEjanAnkjEKqXMLeVpd4P6y7YLmsbOlCmB14pWI204bkWJwRJQ8R/42NnB++XNA6wY6DogPuAsxrM3Cru4RR/72Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715088677; c=relaxed/simple;
	bh=xG/CVNYAc6xO6S2uwsWYr2AwXm5itgYm4sDIAGI1kII=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JqdzYAsMvj8Egl6bHwY2LEjMPaLi4It3Hf9+Zi19SGG6KkrX2Brw/t1bCNSuWTmUw1Dl+1R+CJA09fjHOuUuexlDdGleM+S+ECZ65/DALOtE58NC8ZH1nd0rNYthdZyIM6VbJn/GipJEoHHi+Dd2vht8WkCwkYl06xlbdHQ4+PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPGyjPaY; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715088676; x=1746624676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xG/CVNYAc6xO6S2uwsWYr2AwXm5itgYm4sDIAGI1kII=;
  b=HPGyjPaYPvGXd8o+kGTXcDLD6gLLPCWb8ROpUs2TuoMYWIK59GWmAEiX
   xT3SC3phpwoyf4Me5xVdghfQmhdNZnPoWguEofXcmELplVo4HlMTdEuiI
   1FgwQJY7LzqpEHONs1ZWtJ3E6RtwcBuxdyGXis2UZjh3kggeCl+pMNMn4
   JMX/PfP99lK1s2wmUw+NDvFoVzNv8uLJRNsWVfBOLFuyZXhltN0qr0/Fx
   u5EjVbM6gMv2a8yb/sNy7LLKuHh8z1CtusXmyew16Z1Wrpyio4BP7sj1Y
   ml6Z+QgWAZsw1M+BIbn6rWa8zyMHCVOfOsCrZoJokyfxev758sXNvKJbt
   w==;
X-CSE-ConnectionGUID: MtgAVVyhSs2clMcB3Ejbcg==
X-CSE-MsgGUID: 9QjH4d6USvOiOLguHfbtKQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="28361584"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="28361584"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 06:31:15 -0700
X-CSE-ConnectionGUID: eqwSv8WXT3OG8FZgXw0ToA==
X-CSE-MsgGUID: 3T/ltbUpTN29r7nDjqYnFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="33330804"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orviesa005.jf.intel.com with ESMTP; 07 May 2024 06:31:14 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v4 3/3] KVM: x86/pmu: Add kvm_pmu_call() to simplify static calls of kvm_pmu_ops
Date: Tue,  7 May 2024 21:31:03 +0800
Message-Id: <20240507133103.15052-4-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20240507133103.15052-1-wei.w.wang@intel.com>
References: <20240507133103.15052-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to kvm_x86_call(), kvm_pmu_call() is added to streamline the usage
of static calls of kvm_pmu_ops, which improves code readability.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 24 ++++++++++++------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44d19eb5a27a..7088a5d189a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1853,6 +1853,7 @@ extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define kvm_x86_call(func) static_call(kvm_x86_##func)
+#define kvm_pmu_call(func) static_call(kvm_x86_pmu_##func)
 
 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 68b5826328b1..ed42d4eedb7f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -542,7 +542,7 @@ int kvm_pmu_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx)
 	if (!kvm_pmu_ops.check_rdpmc_early)
 		return 0;
 
-	return static_call(kvm_x86_pmu_check_rdpmc_early)(vcpu, idx);
+	return kvm_pmu_call(check_rdpmc_early)(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -591,7 +591,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
+	pmc = kvm_pmu_call(rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -607,7 +607,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
-		static_call(kvm_x86_pmu_deliver_pmi)(vcpu);
+		kvm_pmu_call(deliver_pmi)(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
 	}
 }
@@ -622,14 +622,14 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		break;
 	}
-	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
-		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
+	return kvm_pmu_call(msr_idx_to_pmc)(vcpu, msr) ||
+	       kvm_pmu_call(is_valid_msr)(vcpu, msr);
 }
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr);
+	struct kvm_pmc *pmc = kvm_pmu_call(msr_idx_to_pmc)(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -654,7 +654,7 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0;
 		break;
 	default:
-		return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
+		return kvm_pmu_call(get_msr)(vcpu, msr_info);
 	}
 
 	return 0;
@@ -713,7 +713,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	default:
 		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
+		return kvm_pmu_call(set_msr)(vcpu, msr_info);
 	}
 
 	return 0;
@@ -740,7 +740,7 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
 
-	static_call(kvm_x86_pmu_reset)(vcpu);
+	kvm_pmu_call(reset)(vcpu);
 }
 
 
@@ -778,7 +778,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!vcpu->kvm->arch.enable_pmu)
 		return;
 
-	static_call(kvm_x86_pmu_refresh)(vcpu);
+	kvm_pmu_call(refresh)(vcpu);
 
 	/*
 	 * At RESET, both Intel and AMD CPUs set all enable bits for general
@@ -796,7 +796,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	static_call(kvm_x86_pmu_init)(vcpu);
+	kvm_pmu_call(init)(vcpu);
 	kvm_pmu_refresh(vcpu);
 }
 
@@ -818,7 +818,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 			pmc_stop_counter(pmc);
 	}
 
-	static_call(kvm_x86_pmu_cleanup)(vcpu);
+	kvm_pmu_call(cleanup)(vcpu);
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
-- 
2.27.0


