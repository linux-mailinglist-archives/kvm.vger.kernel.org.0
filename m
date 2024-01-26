Return-Path: <kvm+bounces-7103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B3483D67A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:36:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 444BD1C291C7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCDA13F01E;
	Fri, 26 Jan 2024 08:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="edt/f7sF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D3D13EFEA;
	Fri, 26 Jan 2024 08:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259419; cv=none; b=E0XL+gUkt5z2gR7gRMFiDsUou2+zB7JCgMUS6yKSEA7FPpl1L9TRuxMoo3YeGZk0b9rbamCI1h19ipteOVxLU9V712XlpWXiwb/azrfzy212w3s4AHRLhZYVlGZnyH/jeuONNWzkEsJ/ex8E9iw4jxmNyPmSRoyFWw1tYZ7ISuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259419; c=relaxed/simple;
	bh=RjuN6r5nGa+8QVlv978u5XMosX7zu6au/aoXHUlMgkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u2OPicK3YrsvQfQbg8CbJZSNtsGA2shkJqUyu5MWalaAzDuntWwXex6szZQjK+VqbqICjZUcnx3J0GJPiQDEMgbk9FqWMTAzVjUeSHGLTlgs7zIOjzfvMvdEk883a+7LtIkU6VKphAcnIe1UhvbngOxgwIXCSmXU3+Gh7NRYdsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=edt/f7sF; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259418; x=1737795418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RjuN6r5nGa+8QVlv978u5XMosX7zu6au/aoXHUlMgkg=;
  b=edt/f7sFyoSeFBoIiZ4Tr8Ak6UE8xgOfoxvNT8Rux0I0qt6J8DWUyR+J
   vpHLNqHLx530/Qz6wg6FMxSuDmDIy/+uuj8xN7OvKGK8IsjBVcAxyg2tK
   +qTEZQKXaVXt+cD/1DGPMIfVbXpQfwndx/D/RpwQ+3jkcw1izCtawSjiY
   l9sBHDwaSd6xtCaImV7hnw82PxgRqldWy5VvJdvrfn8O9dxMdQ8waq2uP
   sTifi7nTRyvhgmK8UTC7J1p3k20/p5qwrKPJ7E6HXsJJ5/WsAxXp+cpwG
   5JsIyes/MgdwVWhKu9CHf3dwuTHPSAN32q9WKcDH42keGr1/AkRtrUgDE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792463"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792463"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310069"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310069"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:52 -0800
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
Subject: [RFC PATCH 16/41] KVM: x86/pmu: Create a function prototype to disable MSR interception
Date: Fri, 26 Jan 2024 16:54:19 +0800
Message-Id: <20240126085444.324918-17-xiong.y.zhang@linux.intel.com>
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

Add one extra pmu function prototype in kvm_pmu_ops to disable PMU MSR
interception.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
 arch/x86/kvm/cpuid.c                   | 4 ++++
 arch/x86/kvm/pmu.c                     | 5 +++++
 arch/x86/kvm/pmu.h                     | 2 ++
 4 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 6c98f4bb4228..a2acf0afee5d 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -25,6 +25,7 @@ KVM_X86_PMU_OP(init)
 KVM_X86_PMU_OP(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
+KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dda6fc4cfae8..ab9e47ba8b6a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -366,6 +366,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	kvm_pmu_refresh(vcpu);
+
+	if (is_passthrough_pmu_enabled(vcpu))
+		kvm_pmu_passthrough_pmu_msrs(vcpu);
+
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 1853739a59bf..d83746f93392 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -893,3 +893,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	kfree(filter);
 	return r;
 }
+
+void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
+{
+	static_call_cond(kvm_x86_pmu_passthrough_pmu_msrs)(vcpu);
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 28beae0f9209..d575808c7258 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -33,6 +33,7 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+	void (*passthrough_pmu_msrs)(struct kvm_vcpu *vcpu);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
@@ -286,6 +287,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
+void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
-- 
2.34.1


