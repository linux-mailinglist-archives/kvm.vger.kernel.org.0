Return-Path: <kvm+bounces-5011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2889281B1FB
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8604282FA5
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75B35B5C3;
	Thu, 21 Dec 2023 09:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VfHUu1t2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BD559179;
	Thu, 21 Dec 2023 09:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149438; x=1734685438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RIlIrcwARg/R77yanApRrJd88iL97sRR08F2g5Gmp6A=;
  b=VfHUu1t2Dti0Sjccf0r4A3PF/eHRH55pW6/1sD0kl5e381bxhtjJJCln
   MsZt6u8uHsRkXBU8meGS5AX8aXYpkrWrG/+fcj36KKAt8sE4OQKY1K/uh
   1bbKIQrzChTu+xTHJ93RNrY7uzcEmPC3pw8FOth9MvA8prjQdGf47FOih
   kLD1mpnyLq3DXNk7Sf5G9KAkaeKhMGK+d/Ysp4HOMgh6lZJhru4sV/1IH
   rgfKgE6p0E6r3bMtHgFgAsq9fthPXsmDYsT47sjcEBXDbz4sFFL/lmaRA
   0+iJx9HhOF+dV1att0rgRbvHbqPidzaZYgwhxuKvz0JI4Wbeum6OTr1gB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729752"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729752"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028631"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028631"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:11 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 21/26] KVM: x86: Save and reload SSP to/from SMRAM
Date: Thu, 21 Dec 2023 09:02:34 -0500
Message-Id: <20231221140239.4349-22-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
one of such registers on 64-bit Arch, and add the support for SSP. Note,
on 32-bit Arch, SSP is not defined in SMRAM, so fail 32-bit CET guest
launch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c | 11 +++++++++++
 arch/x86/kvm/smm.c   |  8 ++++++++
 arch/x86/kvm/smm.h   |  2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3ab133530573..cfc0ac8ddb4a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -149,6 +149,17 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
 			return -EINVAL;
 	}
+	/*
+	 * Prevent 32-bit guest from being launched if CET is exposed as SSP
+	 * state is not defined for 32-bit SMRAM.
+	 */
+	best = cpuid_entry2_find(entries, nent, 0x80000001,
+				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	if (best && !(best->edx & F(LM))) {
+		best = cpuid_entry2_find(entries, nent, 0x7, 0);
+		if (best && ((best->ecx & F(SHSTK)) || (best->edx & F(IBT))))
+			return -EINVAL;
+	}
 
 	/*
 	 * Exposing dynamic xfeatures to the guest requires additional
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 45c855389ea7..7aac9c54c353 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
 
 	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
+
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
+		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
+			   vcpu->kvm);
 }
 #endif
 
@@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
 	ctxt->interruptibility = (u8)smstate->int_shadow;
 
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
+		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
+			   vcpu->kvm);
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index a1cf2ac5bd78..1e2a3e18207f 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
 	u32 smbase;
 	u32 reserved4[5];
 
-	/* ssp and svm_* fields below are not implemented by KVM */
 	u64 ssp;
+	/* svm_* fields below are not implemented by KVM */
 	u64 svm_guest_pat;
 	u64 svm_host_efer;
 	u64 svm_host_cr4;
-- 
2.39.3


