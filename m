Return-Path: <kvm+bounces-7113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C9F83D6AF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:43:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9091FB258C4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA3E14A4CB;
	Fri, 26 Jan 2024 08:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E8o/GLhe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C5014A096;
	Fri, 26 Jan 2024 08:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259469; cv=none; b=UJgX1HBnKczReskb7JgrzDNGS0mRr/pmt04sc/jtvj2lVruHgaiX7S2QhqzZxFlBfRpxGnv9jg5x7lRqAvkjpdX/dYtW3rJEDlPiexzNmfx5Lbgd/7HoM0hN+QfAOKjyyelFhFSR6LpqwXNYUwcXABQWDhTRg26oAAq2UggKxSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259469; c=relaxed/simple;
	bh=IbYfCxqPksLaeoFkdiGUr44Kkbsmws1IykdSnPTgst4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q16m865Fm+NTVv6nsbPFk5x/Qn6J7BgT4AmFEBXWtwk4Qu29wI/HLsf6b6LJvEmsgqeieDeasYpQrLp+2o1GvL1chAWUlegBMPGjenqSBtRe6qn1ugfwTz5fAKslb6drUzKQaMDH++4DQZWlwtRiAo0RbBArYz3S0+0LekpYXAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E8o/GLhe; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259468; x=1737795468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IbYfCxqPksLaeoFkdiGUr44Kkbsmws1IykdSnPTgst4=;
  b=E8o/GLheeUlyXIaZ4eDYq0uBGnHuCsMCUgwgw64auF1sYjpxZLyGlUZL
   pdWT5TYpS5p9A+PqoF1duUDXxnuTgXmjThsH8TMpdV2b441S06RyGOYp0
   3G/8NxDS+t/N7zO8VvODRBOTiudQV2M0Y/RvLbLieU8LR/rGSlIkrGJZ9
   7IQvE6dJ+82FPvz2b2bk36mvZA8LhEd1w/6/Q+Y0TWjycEpIpbOS7qaH2
   R8uFIxbrCOtQNaRQDfQdDQfrMh1f8v/0G3Ah41CRW1IAYADT++VDTE9/Z
   aGDsUUqF+8SZ890bszhxVZ0Oxf0HAeZYAn2ltJdr8Bd9tDbSbSsxO3LKc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792724"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792724"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310246"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310246"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:42 -0800
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
Subject: [RFC PATCH 26/41] KVM: x86/pmu: Add host_perf_cap field in kvm_caps to record host PMU capability
Date: Fri, 26 Jan 2024 16:54:29 +0800
Message-Id: <20240126085444.324918-27-xiong.y.zhang@linux.intel.com>
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

Add host_perf_cap field in kvm_caps to record host PMU capability. This
helps KVM recognize the PMU capability difference between host and guest.
This awareness improves performance in PMU context switch. In particular,
KVM will need to zero out all MSRs that guest PMU does not use but host PMU
does use. Having the host PMU feature set cached in host_perf_cap in
kvm_caps structure saves a rdmsrl() to IA32_PERF_CAPABILITY MSR on each PMU
context switch. In addition, this is more convenient approach than open
another API on the host perf subsystem side.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++--------
 arch/x86/kvm/x86.h     |  1 +
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 349954f90fe9..50100954cd92 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7896,32 +7896,33 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vmx_update_exception_bitmap(vcpu);
 }
 
-static u64 vmx_get_perf_capabilities(void)
+static void vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = PMU_CAP_FW_WRITES;
 	struct x86_pmu_lbr lbr;
-	u64 host_perf_cap = 0;
+
+	kvm_caps.host_perf_cap = 0;
 
 	if (!enable_pmu)
-		return 0;
+		return;
 
 	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, kvm_caps.host_perf_cap);
 
 	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
 	    !enable_passthrough_pmu) {
 		x86_perf_get_lbr(&lbr);
 		if (lbr.nr)
-			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+			perf_cap |= kvm_caps.host_perf_cap & PMU_CAP_LBR_FMT;
 	}
 
 	if (vmx_pebs_supported() && !enable_passthrough_pmu) {
-		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
+		perf_cap |= kvm_caps.host_perf_cap & PERF_CAP_PEBS_MASK;
 		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
 	}
 
-	return perf_cap;
+	kvm_caps.supported_perf_cap = perf_cap;
 }
 
 static __init void vmx_set_cpu_caps(void)
@@ -7946,7 +7947,7 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (!enable_pmu)
 		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
-	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
+	vmx_get_perf_capabilities();
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 38b73e98eae9..a29eb0469d7e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -28,6 +28,7 @@ struct kvm_caps {
 	u64 supported_mce_cap;
 	u64 supported_xcr0;
 	u64 supported_xss;
+	u64 host_perf_cap;
 	u64 supported_perf_cap;
 };
 
-- 
2.34.1


