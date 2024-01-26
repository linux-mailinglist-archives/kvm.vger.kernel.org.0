Return-Path: <kvm+bounces-7123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E13A283D6C2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CAA5283A4C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BC745967;
	Fri, 26 Jan 2024 08:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MB4t7FLL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E7F4595F;
	Fri, 26 Jan 2024 08:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259521; cv=none; b=eTn39erM06Kpqb1L6emEydsrXayYypbmUuBLZyWqOOOYj2UpmSLPT+k0o/6VFl2uc9orC2nhHa2SDzZD/9ArYVMiKWq780atB6YB5uOK7k3+Tl5LrCtxhj+9MhNwMEtj9GDtMXDPEZgVqpnEHY1IfzX2WJfBHuKSl7LREMKO3tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259521; c=relaxed/simple;
	bh=7KYMJKQiAOpNay9R+R0ZbMZPZmltntgZuyawstQhKcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JZ1WBP7gL5OO8otrc38G+/Lt0HpEpfGqxYnuKOqQgz9cMvn4U69BPqoPTClfnm+MalKEeioEmILZW+nD+DLGHJP+L/uBgfjW3LCGErzVZ4q0shCzI8L1EZXRu/tPpuDzyb3BZBUTuAuTdrquDYCNuqy+4kTyVSoBjhWGkNqBVuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MB4t7FLL; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259520; x=1737795520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7KYMJKQiAOpNay9R+R0ZbMZPZmltntgZuyawstQhKcA=;
  b=MB4t7FLLqSyy4UmhXj/H4mjO23Jebos8bz65RlQnmUAL4fgfmdHjVMhR
   tgXRQ6P2ye2IAwuHapo0Rf4Kf4F9kZuB2onDGZxpHW5PD5kAhURuE+9Wm
   GA06W+opKYzZ+WHdESi/z5HIZr2PY+W/lKbB5EGMz6+Mkj/xwje0JyI1p
   XLCDqn5wGUo6ROTkkl2zb8AVhjjuptzAD03VmXc/aMgaQypqfIg78P5TD
   iGuaB6drbI7KZgE892OPmBAZwGBm/Cteo816znK5rWuMN2Gn6nq8iCvZs
   aCHLWJRj6RBODWxytPknUKKpRhc9DSGwR4AVbUVu2S1BsYvinkWS0SGq4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9793019"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9793019"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310463"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310463"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:34 -0800
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
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 36/41] KVM: x86/pmu: Intercept FIXED_CTR_CTRL MSR
Date: Fri, 26 Jan 2024 16:54:39 +0800
Message-Id: <20240126085444.324918-37-xiong.y.zhang@linux.intel.com>
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

From: Xiong Zhang <xiong.y.zhang@intel.com>

Fixed counters control MSR are still intercepted for the purpose of
security, i.e., preventing guest from using unallowed Fixed Counter
to steal information or take advantages of any CPU errata.

Signed-off-by: Xiong Zhang  <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang  <mizhang@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 1 -
 arch/x86/kvm/vmx/vmx.c       | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 92c5baed8d36..713c2a7c7f07 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -825,7 +825,6 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, false);
 	}
 
-	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_TYPE_RW, false);
 	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_fixed_counters; i++)
 		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, false);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a518800d154..7c4e1feb589b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -700,7 +700,6 @@ static bool is_valid_passthrough_msr(u32 msr)
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 	case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + 7:
 	case MSR_IA32_PERFCTR0 ... MSR_IA32_PERFCTR0 + 7:
-	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 	case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + 2:
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
-- 
2.34.1


