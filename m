Return-Path: <kvm+bounces-54476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A16B21B08
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0E613BEB48
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D362E541E;
	Tue, 12 Aug 2025 02:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZIiKLTvB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF992D8365;
	Tue, 12 Aug 2025 02:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967391; cv=none; b=Gnk1fJUDK5hAczU7LMIODq7GexscdFo6y8DgmNM8j4YxBJVmwX3LLE9MyLq6CerG1smcIZYIiSzxCrLglIlnq5fWF8Mn+Nq7tgP4o5ADMEv90g33tpX1a26uY2o5t+GYTsSVJY/6RwCkHCWbW6Tw3/VbtHLiR4vnWwNGWS1gC8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967391; c=relaxed/simple;
	bh=FVanvm/VpXucreMGhf99RZyR3UD92uB5Vfal1SBRqZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HY2tqkpV5pixS7Fug7B/zWWhaiQQeqi8UNktzy3Wux+81Niclap/0CPf7tVRkKfbmo2qsph2QPrzLJEvqmmqYSX+jYU6b1eDGJpILvqCkeC7ARnm7n/ZcOF/2P0bvD1GjJ4Il4vjzBifU8zwmaGRUjbjW/uJJsro9g02xbt3/bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZIiKLTvB; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967390; x=1786503390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FVanvm/VpXucreMGhf99RZyR3UD92uB5Vfal1SBRqZ8=;
  b=ZIiKLTvB+calwWSZQWsqtbUud5/v8EgJDdxVSxWUlXlvzbaLQi/BYRDP
   q9HCW1dfRIw1rSKO8nFnvsWJSo9MWqvH1bM8ZCV4RKu/xA7/eCNbEp6UQ
   D40IEf0ZanH6k43Z4rgo0Uc6p57FewGY55jZ3oOvOWHN8JBvAQ9jehZEy
   aDm6ODScQPrhL00FZNRi89l42xdCwfhQu5188vxaDP5tPji/TkJkT/IWZ
   bXKuUbvTvZza8P4yjaU7tS55LAORcNjKSP+4ev2c+KDRO7Wpm46eypne4
   +CmnyFzAAjjD5sgwJngGf0mBf0wKQdcKqMm5sLc4CQbniVmlk7SJcoqnG
   g==;
X-CSE-ConnectionGUID: RvO1Unu9Ry6E+ZdmvoGTvQ==
X-CSE-MsgGUID: J+KUbK0URuCQLt8o0k2gBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100460"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100460"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:25 -0700
X-CSE-ConnectionGUID: 0350Ci/XTv6+YnVdLh8+Ww==
X-CSE-MsgGUID: grSDObJtRymncPkTWyMBPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321240"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:25 -0700
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
Subject: [PATCH v12 04/24] KVM: x86: Manually clear MPX state only on INIT
Date: Mon, 11 Aug 2025 19:55:12 -0700
Message-ID: <20250812025606.74625-5-chao.gao@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

Don't manually clear/zero MPX state on RESET, as the guest FPU state is
zero allocated and KVM only does RESET during vCPU creation, i.e. the
relevant state is guaranteed to be all zeroes.

Opportunistically move the relevant code into a helper in anticipation of
adding support for CET shadow stacks, which also has state that is zeroed
on INIT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 726028eb647b..6cf0d15a7a64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12389,6 +12389,35 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvfree(vcpu->arch.cpuid_entries);
 }
 
+static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
+
+	/*
+	 * Guest FPU state is zero allocated and so doesn't need to be manually
+	 * cleared on RESET, i.e. during vCPU creation.
+	 */
+	if (!init_event || !fpstate)
+		return;
+
+	/*
+	 * On INIT, only select XSTATE components are zeroed, most components
+	 * are unchanged.  Currently, the only components that are zeroed and
+	 * supported by KVM are MPX related.
+	 */
+	if (!kvm_mpx_supported())
+		return;
+
+	/*
+	 * All paths that lead to INIT are required to load the guest's FPU
+	 * state (because most paths are buried in KVM_RUN).
+	 */
+	kvm_put_guest_fpu(vcpu);
+	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
+	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+	kvm_load_guest_fpu(vcpu);
+}
+
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_cpuid_entry2 *cpuid_0x1;
@@ -12446,22 +12475,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
-		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
-
-		/*
-		 * All paths that lead to INIT are required to load the guest's
-		 * FPU state (because most paths are buried in KVM_RUN).
-		 */
-		if (init_event)
-			kvm_put_guest_fpu(vcpu);
-
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
-
-		if (init_event)
-			kvm_load_guest_fpu(vcpu);
-	}
+	kvm_xstate_reset(vcpu, init_event);
 
 	if (!init_event) {
 		vcpu->arch.smbase = 0x30000;
-- 
2.47.1


