Return-Path: <kvm+bounces-54489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C322B21B1E
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 05:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38EF4466E24
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496812E92B1;
	Tue, 12 Aug 2025 02:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BdI2NoqB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DD92E7BD2;
	Tue, 12 Aug 2025 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967399; cv=none; b=rjiKjS/QEH2JJc+T8ufW5tdzW13nBTg2tV4rWLwfM7QCMyaypMVVwOkW1X+/xrpuYm+2ofKbLqRpPuZd747u4UIX+6tLJ5eMoTHY81ImH+0FB2/SIJAdHTS6lnqa9Urg0fdxLWIHZgfD+7/5t57zgZxFth1LrKWyyEaqzgU+gTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967399; c=relaxed/simple;
	bh=HufWc81H77CIL8AVtjRq6/E/Pufpr+TtO1E3be/dcII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7mxnFwCPoKh4oO1M8IMv5VmD+N/FfT7+DHajEthfa0psRCvUAIky5zDj8nFqmmpTpEDZq/hzGnktFaurT4Dqo4dUUBE65ZwGw243uB0VWK6ptEOzoOXWAKPr/PQc9Eff8JkHqkbrd7irOnyCBf0cLyOi7QPw+RNxL9q9+6nxlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BdI2NoqB; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967397; x=1786503397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HufWc81H77CIL8AVtjRq6/E/Pufpr+TtO1E3be/dcII=;
  b=BdI2NoqB5VSudflI+mNtxQKp39EGWSpbtmnfP6IZfcSCGIirmLtwZfwK
   U1oJLNIQmkpdMYdYa42161+iV8SrunkGzdPNv5IfvUqKbWk+BBnx1xopt
   c4dz0lr8iHP+/g33JvCPtmp2BIZ60FU6xajsoUPLq1KMI2VFJDVaE6k/P
   7qra6r97gJ718umtegdtAkJ/Ru3aLXalHwFldssnTDc/hUyR+ecJCvK/4
   3BT1LIsXnK9WoP1+bUHU+mgLZa4RwIwg1+PiynJ3X2KUheJox7X6gViex
   lq6KvPI5q8SZD4MfLBCGUWt6+jKq/P/3jYzI1qgxDA8qU1LNJBpdXmGa7
   Q==;
X-CSE-ConnectionGUID: i7KvvX1WSFmKH2iQu6WYWg==
X-CSE-MsgGUID: OehvMwGyRLONXsfr0Wg0zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100596"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100596"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:36 -0700
X-CSE-ConnectionGUID: oLT/2wJYSlyYYHvFYBZ2zA==
X-CSE-MsgGUID: 5aP0q0ybQBWwDpa4RSI9gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321337"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:36 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Sean Christopherson <seanjc@google.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 17/24] KVM: VMX: Set up interception for CET MSRs
Date: Mon, 11 Aug 2025 19:55:25 -0700
Message-ID: <20250812025606.74625-18-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Enable/disable CET MSRs interception per associated feature configuration.

Shadow Stack feature requires all CET MSRs passed through to guest to make
it supported in user and supervisor mode while IBT feature only depends on
MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.

Note, this MSR design introduced an architectural limitation of SHSTK and
IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
to guest from architectural perspective since IBT relies on subset of SHSTK
relevant MSRs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bd572c8c7bc3..130ffbe7dc1a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4088,6 +4088,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 
 void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
+	bool set;
+
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
@@ -4133,6 +4135,24 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, set);
+	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
+		      !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, set);
+	}
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.47.1


