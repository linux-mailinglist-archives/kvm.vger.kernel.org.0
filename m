Return-Path: <kvm+bounces-51571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 913FEAF8CC8
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D4AE176D08
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F42C29E0F5;
	Fri,  4 Jul 2025 08:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UwQfjbz6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1342868A9;
	Fri,  4 Jul 2025 08:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619040; cv=none; b=Gc6e8nKGfe3CqUp+0syy8yU2PdniidC0Jp1kzII/tybsPu9fuDd70b/XwLcOYYiyR+CW9TA2ynzDKda6lyKh08ebyzum+9XUQkLymzrTKn2a10B/N/8HXRhKeKumET3rBU7TWkh4Y740ne4gbENg5WxlMJUrwVUCVlhzeRjFCLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619040; c=relaxed/simple;
	bh=EmKOsrNzZJJcXfGM/ESPYCS66R+7WBgMhtsNsYmE5/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUMutHcu0nzwk90f0H7iUnCh098r3lQPW+9xWXRxUPi8UM0OhGn1SGFR5WXCpUyR4m09vL59vYEf1++eGqpQYV7WS5yoh+AjadMQNlD+WUop7glmpJYnvAeyYGCVOPAo8O9Mxm+Wc2P3J6t3l85ezJ7R8v4Ctfe96Sbe0/65D6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UwQfjbz6; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619039; x=1783155039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EmKOsrNzZJJcXfGM/ESPYCS66R+7WBgMhtsNsYmE5/g=;
  b=UwQfjbz6h6lbBn5JF56nUoTA1kY/Z5O5yuh5CUKwZu7uvNgAt6SRKttr
   b31ZlTcEGf22NkonjhqtWpd0IGIA8xh1H7pwWrU549u61BszyXwUwQLat
   e3KGTYiEx+1irE7hLWCZZLzbuXVJY0Xsrhc8zm/GQhsNw1OCDenmPQ4qA
   K2rwaRrIwR04m9zdpdnp4U9qdA25seqIWrcRU7VzfbV9vyTssJvX2l9s8
   bdL0MSAEDAns2IsDA2GVCELphITjlc81Z/SkxC+h3cWxgRIEclTp2LMRA
   GkNd8IhQYuxjBf5jGexdEr58QSTJgI2xNVdfn/zZzEJwjTWd9xggWcIv6
   w==;
X-CSE-ConnectionGUID: m7WhYJ/IRCSqGJHDYlyhHA==
X-CSE-MsgGUID: MzIq46PeTaWpu7fCHQ3NLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391596"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391596"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:36 -0700
X-CSE-ConnectionGUID: d2pwx/CoRyuKh3aTpQqRaw==
X-CSE-MsgGUID: jFGbck20RN+mvw7wFDUNEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721955"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:36 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 04/23] KVM: x86: Zero XSTATE components on INIT by iterating over supported features
Date: Fri,  4 Jul 2025 01:49:35 -0700
Message-ID: <20250704085027.182163-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tweak the code a bit to facilitate resetting more xstate components in
the future, e.g., CET's xstate-managed MSRs.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c956b36314fb..b9d1c84f0794 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12520,6 +12520,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
+	u64 xfeatures_mask;
+	int i;
 
 	/*
 	 * Guest FPU state is zero allocated and so doesn't need to be manually
@@ -12533,16 +12535,20 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 * are unchanged.  Currently, the only components that are zeroed and
 	 * supported by KVM are MPX related.
 	 */
-	if (!kvm_mpx_supported())
+	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
+			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+	if (!xfeatures_mask)
 		return;
 
+	BUILD_BUG_ON(sizeof(xfeatures_mask) * BITS_PER_BYTE <= XFEATURE_MAX);
+
 	/*
 	 * All paths that lead to INIT are required to load the guest's FPU
 	 * state (because most paths are buried in KVM_RUN).
 	 */
 	kvm_put_guest_fpu(vcpu);
-	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
-	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+	for_each_set_bit(i, (unsigned long *)&xfeatures_mask, XFEATURE_MAX)
+		fpstate_clear_xstate_component(fpstate, i);
 	kvm_load_guest_fpu(vcpu);
 }
 
-- 
2.47.1


