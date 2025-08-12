Return-Path: <kvm+bounces-54488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA6FB21B24
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 05:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7953F6843FE
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8EC2E8E0D;
	Tue, 12 Aug 2025 02:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PAOHQC2L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E21A2E7BB1;
	Tue, 12 Aug 2025 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967398; cv=none; b=lR8MrZlRFyfkyIc+muJIllS9+RYbj92AfdaVhyQCDRBOcR62XGCytQqJVOLcYsgeJhDKzD6gfP608DkAXGBoe60b1Muo1zc/sHfQa8wmrA5Iz9LskLnuuMag0FfFR0RsnI/hrjHw+ITrG3u4toDBvS0uesFUNjLmQl+GRoJNEM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967398; c=relaxed/simple;
	bh=5WHPn4yw0uta1t4HIbKm9txODdqNNrH1SC+NG8IkwRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhUhKko3BV0Ra3k4kv/vkqF1HsR1Kg747ZTIHOsRjieD1v7odfhAU/0/MbahAVmu6YhHFLKZPmH1qsR6hxYH9HJVSUBNTqHTXUFZUI+NPhgYPglkI70i1RO7B+1zxIDxY1qwdx9ijNToiH1gWkftpCWV2PF2Vff4SW2PJK7gfW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PAOHQC2L; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967397; x=1786503397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5WHPn4yw0uta1t4HIbKm9txODdqNNrH1SC+NG8IkwRk=;
  b=PAOHQC2LG+haFcgWvZQ25XYiSRzUajqfPV87S6jIfGItf5OMGmk6lh5b
   w6mB92s7FQZXyXWyKs5d1/S2gfGafIJu5JQcEwdBeaQKLaJA9tNN8TMe2
   /rwb/BiM0vNUgU3MzphSblQuceEPw9w81HpX7SNYvGfg2fyrgWh1exj3W
   C5Byf7CrBv+2tU3tpgGeqN4MgKrsrW1BM7P3BkJqHzsKv9kV5L6yXA9/e
   3FLakrPDer7SSJIizDfwINbzOobyBh2E+tiIXwJR9GsQEhh6nWPNfEHaZ
   gwbhcexRImHBnkf+OqtwYXUACmcWfNiK6pGGpMDa3FBND3rQ+e46NA/Su
   A==;
X-CSE-ConnectionGUID: M2iImkelRKyAZqnpYO2TlQ==
X-CSE-MsgGUID: cr7xWPdIQLSUTtQwwgSZgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100586"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100586"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:35 -0700
X-CSE-ConnectionGUID: qDJbjBKRSHmKRijU9TyeDw==
X-CSE-MsgGUID: gxFrywQ8Qda7fLs2AaAFFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321332"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:35 -0700
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
Subject: [PATCH v12 16/24] KVM: x86: Save and reload SSP to/from SMRAM
Date: Mon, 11 Aug 2025 19:55:24 -0700
Message-ID: <20250812025606.74625-17-chao.gao@intel.com>
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

Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
one of such registers on 64-bit Arch, and add the support for SSP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/smm.c | 8 ++++++++
 arch/x86/kvm/smm.h | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 5dd8a1646800..b0b14ba37f9a 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -269,6 +269,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
 
 	smram->int_shadow = kvm_x86_call(get_interrupt_shadow)(vcpu);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_msr_read(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, &smram->ssp))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 }
 #endif
 
@@ -558,6 +562,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	kvm_x86_call(set_interrupt_shadow)(vcpu, 0);
 	ctxt->interruptibility = (u8)smstate->int_shadow;
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_msr_write(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, smstate->ssp))
+		return X86EMUL_UNHANDLEABLE;
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index 551703fbe200..db3c88f16138 100644
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
2.47.1


