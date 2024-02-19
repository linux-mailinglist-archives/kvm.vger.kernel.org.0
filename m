Return-Path: <kvm+bounces-9035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A72859DA0
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B3CC1C21CB0
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8410B433A8;
	Mon, 19 Feb 2024 07:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mNmu02P1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DB53C09F;
	Mon, 19 Feb 2024 07:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328879; cv=none; b=pN/JzzxQ1wzMA8gGh4gPIxlwA/qXwoCvOoX6A3HRYHfjQ4R850bZJpioeYlsExuG8bXNKN0Gr8x+90GRseuZ9yuahL7d0lIZbAM+UexeciT6mszx1/ewZtQnAfCdGqtqj9nuXJtQNuYMirWupPe3TC652SdO966J+uBd6zG+9uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328879; c=relaxed/simple;
	bh=j6k0zNCcu78ZjgKB056TtP0O+fKYCAbaHVnQy48CcZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP+jLhn7EofgdSG2g7qYOaj7GsT7w5jDmB4gVENJcSrwEIPiR+dFd4/o/lKf8bh+Vieo9vlvwKvZ2ORQpQaJhQcUGX6up+HHiBE+DLcHXpxqo2RZTMnp8DjlTuE6K04jB5wuJ4e+ghGolstEGWZf38upGJd9KlgbBx8f0CPXxwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mNmu02P1; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328877; x=1739864877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j6k0zNCcu78ZjgKB056TtP0O+fKYCAbaHVnQy48CcZA=;
  b=mNmu02P1igqg5jSwFPmbDGHQkjxZyGnzWtkWhH3hQZBtHNSZkJZQIJ67
   7r0l686OnPvI4DndNS8TqdED/0ZpKddCDJXoyW6CZwSqZVbNPy3DT0H+p
   oxSNFDLb90WP8yxzdaDJtzs5Q1UeNCD9KJXKXN5lXo/QT5lp9Ub/6keWW
   GyfX9SwGbiq2Iz4ZOdcWMxcgivH/hFYqxqMLpvR2r1pVrtdZ3FYavciU2
   3OY0zldGciw7DmSq/33/GRC6uis8SYlCKJxXCM/X6OdMlNheXJvQpH4EY
   eSFQ1VTRuzz8BF2hTxGtsde1c36F9R2Uwu/pZiBfK1ybiR0jtbAdPsj9t
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535151"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535151"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966122"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966122"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 21/27] KVM: x86: Save and reload SSP to/from SMRAM
Date: Sun, 18 Feb 2024 23:47:27 -0800
Message-ID: <20240219074733.122080-22-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
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
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/cpuid.c | 11 +++++++++++
 arch/x86/kvm/smm.c   |  8 ++++++++
 arch/x86/kvm/smm.h   |  2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2bb1931103ad..c0e13040e35b 100644
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
2.43.0


