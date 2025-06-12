Return-Path: <kvm+bounces-49237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 877B1AD6A55
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0580D1659CC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66E0223DFD;
	Thu, 12 Jun 2025 08:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dN1JAUar"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3D422154A;
	Thu, 12 Jun 2025 08:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716395; cv=none; b=arE5dSgujc79niAiUa2Ip/0cs8ElgVkJSfRXm/cHWObpXS9I7tC67RQB5lWVuuXB3ubNa3lnlX4lHz47laIsG1j4kTitgME3uFToBEVTpsVDRU3cmmQxfI7ApZyUjlZ3maoIVC8kz7HyrTjzjLmXx8Xc4Xn7HfAo6oxfYostDYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716395; c=relaxed/simple;
	bh=qZgUW7Zl1CLJ2uVKQxnl6lpmdfsy2MojuW22eubTURo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/GDiUCrwBC2jOxf4bj4xQNv2k9R9WbVwlxGSMtDjhbFNL3knHw9xvKVXr3ta0ehriU79W+bsg0hDBr8DqZxC/J1vuFgk/yg4mgZseT2yaYSj6lQ5FtR10mAfQEtIw+4++dfDWK4He5oMCP0JGJuLtRhVwAOWNKFppjgpauWTYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dN1JAUar; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716394; x=1781252394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qZgUW7Zl1CLJ2uVKQxnl6lpmdfsy2MojuW22eubTURo=;
  b=dN1JAUarJWDxc9kFMM+mYH2TrKgMwcp+9cOwGqVJo7C+vqACIImeHGeu
   A43JKYI6DLwkIcccPpf64hsTI5tc86rkDGE9mW9xAEtBr6PFN8uKg/wUJ
   jnt9Wu1j1r5DeD02PPC+wjGQWakdrkepddphElWhjydpDhsE6AqEAnXi8
   JNqhItLBQFHB7y+Ugeb74geubr1pX5m6KqfafAJb0D03ZuwQLyGFAIdHd
   /TW29WqlaidMV792FS8Ug5RdVLnsW7caVfeiSaQeM+CqHobpDhlyT2JiF
   hFrUs0uXQC69aleEpJzGYVcK4H0Pgm/MS0SXaCyz9Al3hR/zO6eEPDkV9
   g==;
X-CSE-ConnectionGUID: E1HN7DKdQTyt2y7uott3Cw==
X-CSE-MsgGUID: CuUlwrhvRZ+lqSuZ0nWZ0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51759997"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51759997"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:19:50 -0700
X-CSE-ConnectionGUID: 4PKnm71VS6q1E3Af9mDBjg==
X-CSE-MsgGUID: s/E3W+LCQNWVnGbTWS/24g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147322375"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:19:50 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	dapeng1.mi@linux.intel.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH 2/2] KVM: SVM: Simplify MSR interception logic for IA32_XSS MSR
Date: Thu, 12 Jun 2025 01:19:47 -0700
Message-ID: <20250612081947.94081-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612081947.94081-1-chao.gao@intel.com>
References: <20250612081947.94081-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use svm_set_intercept_for_msr() directly to configure IA32_XSS MSR
interception, ensuring consistency with other cases where MSRs are
intercepted depending on guest caps and CPUIDs.

No functional change intended.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
With this patch applied, svm_enable_intercept_for_msr() has no user.
Should it be removed?
---
 arch/x86/kvm/svm/sev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6282c2930cda..504e8a87644a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4371,11 +4371,9 @@ void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	 * XSAVES being exposed to the guest so that KVM can at least honor
 	 * guest CPUID for RDMSR and WRMSR.
 	 */
-	if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
-	else
-		svm_enable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW,
+				  !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) ||
+				  !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES));
 }
 
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
-- 
2.47.1


