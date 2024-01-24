Return-Path: <kvm+bounces-6770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E7A839F7D
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03C0A1F23533
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9027017BA3;
	Wed, 24 Jan 2024 02:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RD+YoJYk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52B718E1E;
	Wed, 24 Jan 2024 02:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064168; cv=none; b=EgUyayNWxWgdk1JOfRUn0J79pc+00N9V9gOYnCjvPLInly/cLWCv9X3OqiOQrOLgtwveD/PHhq5b3JeBfShuiVwldOTMEnLqgON9e46KLfFX9+QePjQSd7WP9Z82Ux+r5EapKXu5QtaF4m868ofnzbDGlgUAdkeuDlrAOpqsByc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064168; c=relaxed/simple;
	bh=h8um0cUpGOSDzpshStMJ7pABEvMbvAz9TJHO3NVRyXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N7wwVHQbkDRfOobNLs2MEL6Kxvs5hg03q/4Z1attXQ+Fja/maePuui0wuKd6s/lAOV8ySLKN8DFX0lQzIYz/ClgL8UCnkCj4qUNVseRzZ22vB+BHdKi09+hJC2fMS/sK80LHA20UZTw2JHyjwOXU4srxxkNBtSROOeqNqWwRhbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RD+YoJYk; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064166; x=1737600166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h8um0cUpGOSDzpshStMJ7pABEvMbvAz9TJHO3NVRyXM=;
  b=RD+YoJYksDxfDmMEAVbos7KH/+l5xlDjF0Z+Rd323aJSSO4ok4bzjcev
   QXU3mpVb9vqRxnu+0YZNcAv2lahXIL4QzIb+UlvzGCt8ef4ATyUOxk3c+
   emEst1PpeTr++i7cSwloMa3ye6jb74XQPrn5WEL8kn+O6sDSokwPB26Pe
   loA2hxRdYrLZsN3ghT+9mScAPPmXZN6xM4OSjvlxDrRX5ug5ZTkb+q25c
   0Mluy8WpTxuwOtdM9FWfP+D2VRnmBnADJb+P+aFa6mjbpW8udwCxjxNa1
   YkjHbTesc3R1ubnWH1fug1MeymsCN1hX8JuSkekQBmmmTlGf9fqOJN0qI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586556"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586556"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825909"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:42 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 21/27] KVM: x86: Save and reload SSP to/from SMRAM
Date: Tue, 23 Jan 2024 18:41:54 -0800
Message-Id: <20240124024200.102792-22-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/cpuid.c | 11 +++++++++++
 arch/x86/kvm/smm.c   |  8 ++++++++
 arch/x86/kvm/smm.h   |  2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3ab133530573..95233b0879a3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -149,6 +149,17 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
 			return -EINVAL;
 	}
+	/*
+	 * Prevent 32-bit guest launch if shadow stack is exposed as SSP
+	 * state is not defined for 32-bit SMRAM.
+	 */
+	best = cpuid_entry2_find(entries, nent, 0x80000001,
+				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	if (best && !(best->edx & F(LM))) {
+		best = cpuid_entry2_find(entries, nent, 0x7, 0);
+		if (best && (best->ecx & F(SHSTK)))
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


