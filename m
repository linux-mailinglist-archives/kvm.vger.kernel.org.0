Return-Path: <kvm+bounces-19915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFF090E19B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 04:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDA5C1C230C8
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 02:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB6752F9E;
	Wed, 19 Jun 2024 02:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GG0WfNi+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F9D4D8A5;
	Wed, 19 Jun 2024 02:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718763625; cv=none; b=N0/UPSoopdkcv4DIAnUiyei9yoI7B49oEXrnCMv9V1BK+HHkqPykxYm9HEjSS/GHZ5GXE4IjcKEzE6KEXcPwG0WkCHn8JynPG70WJbKw/AFqLjfOpCYKAIA78QORoq0OCwylezgk9y0KIIDh05OzJSPOLsaIk2baO0NBFQTxU4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718763625; c=relaxed/simple;
	bh=t0bYkQuDqZkvErvSnvot1QzPCybyQU495u6bv1TO+Xg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t7RWwsSuRrjS8EoGoOrhECiXPrCAFffkvHfdOUBvJra+Ok82ZAkIOtqMjkB+AHLXEqBKGjCfLHQls9vX0oqPVlpAqv9OZsutWdwHSxhao4rhl0IEQjRN/jbkdN0ea+8ZDeOh1Ta8RZZk0JICPKEBaaMPSUMNTtBuO2PyYW/1e8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GG0WfNi+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718763624; x=1750299624;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t0bYkQuDqZkvErvSnvot1QzPCybyQU495u6bv1TO+Xg=;
  b=GG0WfNi+wY6VjTe5t7KSmc6KymJKc7f3Jc4katGr4FHcQnfRpZi6y8ZS
   OdGjr63ZJWRfaImXrXki5NfEz+M7Zfw9wanyKEsRPSy1hkkh9RziEKfKI
   1t8QFyCm20P+IN4lvc0xGGhTFohH18lEkxOK3d6WZ9eIjKFJdCXLpBj4b
   OXJ9CE/lwkwGr4Cbr5SPM0Xv9iLCQ48x4dN0FBRmXuCPS+p3sAIr67zke
   fcwY/8O/GAUPqBuil/qjEhmHH5EJAKnHlwcDev0biuRbZv4d2TdGsCmWC
   VQO4b+9rMWOj2xGgWKMv53ZwZUDyRnTRsWRhzvdPchy3eOEb9usR4mq8r
   g==;
X-CSE-ConnectionGUID: Vt9ZDuIwTkO8mkYx/RqIMQ==
X-CSE-MsgGUID: rvBOQfV8RByjSbNiE9b+4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15648150"
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="15648150"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 19:20:24 -0700
X-CSE-ConnectionGUID: RIqV2wB3TumlJBCQ/pjEuw==
X-CSE-MsgGUID: ROkjTKUHQZOB0tks32zrlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="42470834"
Received: from unknown (HELO dell-3650.sh.intel.com) ([10.239.159.147])
  by orviesa007.jf.intel.com with ESMTP; 18 Jun 2024 19:20:20 -0700
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
Subject: [PATCH 1/2] KVM: x86/pmu: Define KVM_PMC_MAX_GENERIC for platform independence
Date: Thu, 20 Jun 2024 02:21:27 +0800
Message-Id: <20240619182128.4131355-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing macro, KVM_INTEL_PMC_MAX_GENERIC, ambiguously represents the
maximum supported General Purpose (GP) counter number for both Intel and
AMD platforms. This could lead to issues if AMD begins to support more GP
counters than Intel.

To resolve this, a new platform-independent macro, KVM_PMC_MAX_GENERIC,
is introduced to represent the maximum GP counter number across all x86
platforms.

No logic changes are introduced in this patch.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 9 +++++----
 arch/x86/kvm/svm/pmu.c          | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 2 ++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 57440bda4dc4..18137be6504a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -534,11 +534,12 @@ struct kvm_pmc {
 
 /* More counters may conflict with other existing Architectural MSRs */
 #define KVM_INTEL_PMC_MAX_GENERIC	8
-#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
-#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
+#define KVM_AMD_PMC_MAX_GENERIC	6
+#define KVM_PMC_MAX_GENERIC		KVM_INTEL_PMC_MAX_GENERIC
+#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_PMC_MAX_GENERIC - 1)
+#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_PMC_MAX_GENERIC - 1)
 #define KVM_PMC_MAX_FIXED	3
 #define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
-#define KVM_AMD_PMC_MAX_GENERIC	6
 
 struct kvm_pmu {
 	u8 version;
@@ -554,7 +555,7 @@ struct kvm_pmu {
 	u64 global_status_rsvd;
 	u64 reserved_bits;
 	u64 raw_event_mask;
-	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
+	struct kvm_pmc gp_counters[KVM_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
 
 	/*
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 6e908bdc3310..2fca247798eb 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -218,7 +218,7 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	int i;
 
 	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > AMD64_NUM_COUNTERS_CORE);
-	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
+	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > KVM_PMC_MAX_GENERIC);
 
 	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fb5cbd6cbeff..a4b0bee04596 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -570,6 +570,8 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	BUILD_BUG_ON(KVM_INTEL_PMC_MAX_GENERIC > KVM_PMC_MAX_GENERIC);
+
 	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
-- 
2.34.1


