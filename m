Return-Path: <kvm+bounces-16206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 938F88B6702
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 02:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F8EE284AC0
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 00:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C87BA47;
	Tue, 30 Apr 2024 00:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kL7t7aZo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B598F70;
	Tue, 30 Apr 2024 00:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714437956; cv=none; b=sJdzwaUDIe7tqHdc6srHcpaWJj6aHXE5WtqeTb826z/4jADoWDBc0t7AYyX3Cbw2SHF9nfmtHGlQy6bUhk76x95lpht1L6eZFqnePEbqxK03FhWetkIrTTxT5MCI8EHMSsUA8hyWZOPVSbzAAa4vouLvIjSbY5swhmv1WjUA3ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714437956; c=relaxed/simple;
	bh=n2JglvBaxDyC5t2TPzmaPHp6aarsIDz+KXhW0XBtZuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nZDBHTj3374y73cnC93hf+FlvZ1eSAtph9v5HO/ORRi4B8WrXwjh25bH71TGzFv2YP/j51fph8iF64cuHkNQY8Bst42CDFXAnefg/pZToQ8UbwnePD7JjKm6LvbOTImUy4sAIbpzeC5cQ+ahUTUyAzZhGMX4iwIltZN3CRJOvPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kL7t7aZo; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714437955; x=1745973955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n2JglvBaxDyC5t2TPzmaPHp6aarsIDz+KXhW0XBtZuE=;
  b=kL7t7aZo6tFeHyWexlzRZUkj/sOjnB5/C02aAeFMigKTXAd3SW+iiCIa
   AxOa+7dnevZuqD1sF+KERMRKh9fVoD6fLJUfrQoraof2s603iof2ZfyB4
   x+wluHhKRt3Kag9ohgFmFTsSeXyth8MPEPwPD9GBSuCsz3iSQmRWxG/U6
   LBdM0wwNcjUflZO+kmggFWxJr7nVYjuoEOFXSvGOaJIhIzZfDOoEqf2Z5
   HDR7PqK823IHh7V4d4WrrgjZ1MV4lfJrmQcMkv2JFKGyw8do9hZCWV6K3
   5LMW/9jmBHgXxmUj+uCBquZYzHJ/bb8AWEMaeMKTn85iAccmsk+Q3prd6
   Q==;
X-CSE-ConnectionGUID: KxL9vE8MRsmjdiR/Nca0Bw==
X-CSE-MsgGUID: 81OQq7hiQTqToaOzLLfN5Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="10658602"
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="10658602"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 17:45:55 -0700
X-CSE-ConnectionGUID: CnOKC37JQEuGplvgNu4MSg==
X-CSE-MsgGUID: jPppx7dLRkSggHSBWngtqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="31079849"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by orviesa005.jf.intel.com with ESMTP; 29 Apr 2024 17:45:52 -0700
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
Subject: [PATCH 2/2] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
Date: Tue, 30 Apr 2024 08:52:39 +0800
Message-Id: <20240430005239.13527-3-dapeng1.mi@linux.intel.com>
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

Magic numbers are used to manipulate the bit fields of
FIXED_CTR_CTRL MSR. This makes reading code become difficult, so use
pre-defined macros to replace these magic numbers.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c           | 10 +++++-----
 arch/x86/kvm/pmu.h           |  6 ++++--
 arch/x86/kvm/vmx/pmu_intel.c | 12 +++++++++---
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index afbd67ca782c..0314a4fe8b2d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -469,11 +469,11 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 	if (pmc_is_fixed(pmc)) {
 		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
 						  pmc->idx - KVM_FIXED_PMC_BASE_IDX);
-		if (fixed_ctr_ctrl & 0x1)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_KERNEL)
 			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
-		if (fixed_ctr_ctrl & 0x2)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_USER)
 			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
-		if (fixed_ctr_ctrl & 0x8)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI)
 			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
 		new_config = (u64)fixed_ctr_ctrl;
 	}
@@ -846,8 +846,8 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 	} else {
 		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
 					  pmc->idx - KVM_FIXED_PMC_BASE_IDX);
-		select_os = config & 0x1;
-		select_user = config & 0x2;
+		select_os = config & INTEL_FIXED_0_KERNEL;
+		select_user = config & INTEL_FIXED_0_USER;
 	}
 
 	/*
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 2eab8ea610db..d54741fe4bdd 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -14,7 +14,8 @@
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 
 /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
-#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
+#define fixed_ctrl_field(ctrl_reg, idx) \
+	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
 
 #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
@@ -170,7 +171,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 
 	if (pmc_is_fixed(pmc))
 		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-					pmc->idx - KVM_FIXED_PMC_BASE_IDX) & 0x3;
+					pmc->idx - KVM_FIXED_PMC_BASE_IDX) &
+					(INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER);
 
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index eaee9a08952e..846a4e7fd34a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -501,8 +501,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
-		pmu->fixed_ctr_ctrl_rsvd &= ~(0xbull << (i * 4));
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmu->fixed_ctr_ctrl_rsvd &=
+			 ~intel_fixed_bits_by_idx(i,
+						  INTEL_FIXED_0_KERNEL |
+						  INTEL_FIXED_0_USER |
+						  INTEL_FIXED_0_ENABLE_PMI);
+	}
+
 	counter_rsvd = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << KVM_FIXED_PMC_BASE_IDX));
 	pmu->global_ctrl_rsvd = counter_rsvd;
@@ -548,7 +554,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
 			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 				pmu->fixed_ctr_ctrl_rsvd &=
-					~(1ULL << (KVM_FIXED_PMC_BASE_IDX + i * 4));
+					~intel_fixed_bits_by_idx(i, ICL_FIXED_0_ADAPTIVE);
 			}
 			pmu->pebs_data_cfg_rsvd = ~0xff00000full;
 		} else {
-- 
2.40.1


