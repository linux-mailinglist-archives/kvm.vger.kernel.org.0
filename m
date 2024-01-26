Return-Path: <kvm+bounces-7128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A47883D6D7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F19AEB2E415
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383061534E4;
	Fri, 26 Jan 2024 08:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khCX0w5K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F89C152E1B;
	Fri, 26 Jan 2024 08:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259550; cv=none; b=GxZZELuxBL39632COGLIGqXJ8NdSMytqyM7rEba09I1A8CqSYJBj7Z1QWynHcdOZOBaKzEldj5StQys8UzSUhD1eru9jPz15rLiEPZuisGo/mh9Lkg8rWnxPOXXlNB8QpByZqnSZTRq0JjCfItOnRe5eB8vbb28fE14PvLFrjCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259550; c=relaxed/simple;
	bh=mgcdLFdOZk7gOOt9XdDDqqjGJmhtjqnbjRyaGP4Ga8A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gfYLPvm13NNDb6qCRHUCp/TZf7e5AVFi3XRkGjLBjIfIfmeg1aSvCTWUMAqhmaITF91Lmvgj6+uSy2EylEvtkkdSiSHuIzo8pkdBdBdofDir6TG6yRwyBkJGO7KJV1u2VgF40SETyHchMHcRZsZrvx+2TWbZtfRnn/6gVxP3v/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khCX0w5K; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259549; x=1737795549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mgcdLFdOZk7gOOt9XdDDqqjGJmhtjqnbjRyaGP4Ga8A=;
  b=khCX0w5KRRPr71rdTVykMeVPkTlAyp55tmlcUtyr26Q+cT8LVSbtE5eW
   DTT3qFFQuUFQQ1bt3sYUPcSAbfNcqUmGtIOqt5CAVDHmcdmBd+4hg4J2W
   PjxlDkIpIoJ/ReZhSeGc8vvIrQ4Y4psCdPleooU7tmLkAer7NRJK4cI1B
   TGqCyWpCaIvGOqsPzrYavumVCiy1/sbSg4euBSkwMZV7UHyI1rp5js+o2
   7+Mt6Ls+QH+fkLOStAZHiZERj/Tca6PM6BrlkKIUO8Duqls2EcNWRzwsJ
   dkXhnHz54AtQO0izTQNIJlK05wA4+hHTMtPuadfm1Z5qGuViIERnFX7oo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9793186"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9793186"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:59:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310591"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310591"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:59:00 -0800
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
Subject: [RFC PATCH 41/41] KVM: nVMX: Add nested virtualization support for passthrough PMU
Date: Fri, 26 Jan 2024 16:54:44 +0800
Message-Id: <20240126085444.324918-42-xiong.y.zhang@linux.intel.com>
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

Add nested virtualization support for passthrough PMU by combining the MSR
interception bitmaps of vmcs01 and vmcs12. Readers may argue even without
this patch, nested virtualization works for passthrough PMU because L1 will
see Perfmon v2 and will have to use legacy vPMU implementation if it is
Linux. However, any assumption made on L1 may be invalid, e.g., L1 may not
even be Linux.

If both L0 and L1 pass through PMU MSRs, the correct behavior is to allow
MSR access from L2 directly touch HW MSRs, since both L0 and L1 passthrough
the access.

However, in current implementation, if without adding anything for nested,
KVM always set MSR interception bits in vmcs02. This leads to the fact that
L0 will emulate all MSR read/writes for L2, leading to errors, since the
current passthrough vPMU never implements set_msr() and get_msr() for any
counter access except counter accesses from the VMM side.

So fix the issue by setting up the correct MSR interception for PMU MSRs.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/nested.c | 52 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..95e1c78152da 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -561,6 +561,55 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
 						   msr_bitmap_l0, msr);
 }
 
+/* Pass PMU MSRs to nested VM if L0 and L1 are set to passthrough. */
+static void nested_vmx_set_passthru_pmu_intercept_for_msr(struct kvm_vcpu *vcpu,
+							  unsigned long *msr_bitmap_l1,
+							  unsigned long *msr_bitmap_l0)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+						 msr_bitmap_l0,
+						 MSR_ARCH_PERFMON_EVENTSEL0 + i,
+						 MSR_TYPE_RW);
+		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+						 msr_bitmap_l0,
+						 MSR_IA32_PERFCTR0 + i,
+						 MSR_TYPE_RW);
+		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+						 msr_bitmap_l0,
+						 MSR_IA32_PMC0 + i,
+						 MSR_TYPE_RW);
+	}
+
+	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_fixed_counters; i++) {
+		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+						 msr_bitmap_l0,
+						 MSR_CORE_PERF_FIXED_CTR0 + i,
+						 MSR_TYPE_RW);
+	}
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+					 msr_bitmap_l0,
+					 MSR_CORE_PERF_FIXED_CTR_CTRL,
+					 MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+					 msr_bitmap_l0,
+					 MSR_CORE_PERF_GLOBAL_STATUS,
+					 MSR_TYPE_RW);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+					 msr_bitmap_l0,
+					 MSR_CORE_PERF_GLOBAL_CTRL,
+					 MSR_TYPE_RW);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+					 msr_bitmap_l0,
+					 MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+					 MSR_TYPE_RW);
+}
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -660,6 +709,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		nested_vmx_set_passthru_pmu_intercept_for_msr(vcpu, msr_bitmap_l1, msr_bitmap_l0);
+
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
-- 
2.34.1


