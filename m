Return-Path: <kvm+bounces-55289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2024B2FAC3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCAF3189DC1F
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E30FC350826;
	Thu, 21 Aug 2025 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z36y460i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433FB34AB02;
	Thu, 21 Aug 2025 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783130; cv=none; b=W4Y/8/QNPNPU36NvBKris7rz6VDy/cnMjGgBb7tlU8DrM9Anyyk6cPs16g25oQ3J9MGkLPuKpUIxcIXHwRnM2Js2orfDoB47QbAlUgesqwZLE75lO19uCbZN8ASPVwsQ8nE9/T2q9ZNPAZb2wAlftUlxwHoGngAi3c3qhkNWcGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783130; c=relaxed/simple;
	bh=Iee4CLaQXxLG8uUP5bqwP61MDqXRMZclM7eNQhokwNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAkJFKREWZ6A9pZepYbPRGFOjzf62r2aRgG+BNGMJmIkpOJ/rWSK9epoY+bRrUkPlOcZSDqERc9hD0g5P4zagSxWU+TSZeqrlTcgXPBX3nud469pqqeQqN3bwelL9xrTRkiSeGVfUjaNPCkWFXW4SYbfZOOqCTV8Tjme/e+jseE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z36y460i; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783128; x=1787319128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iee4CLaQXxLG8uUP5bqwP61MDqXRMZclM7eNQhokwNI=;
  b=Z36y460iE6rhlevulWHLQrgur05MzAyokTKPn234+/pr+WyO1oSGwOIX
   3ACulchszlZ+8oYEddqfnKZ7hIuBT1lhAcFAfZSdobDXLFxeXIN39IY4o
   sx+RsYD6fYmePK0LuqcONxr0dkGZUtl65BH9etnEeWsJnliOYW/iOqk6o
   itN8Yne9z8yTs3DcmVB87JCDarXew5cBKycDe5aQT/OkTuosMxfIArS9H
   ZMJBzajdUTu0SBtuXef5jXM7WmhO2ZDvjKI2pxxZWHX6JQz9EGYKvr8LY
   6lXh/ku2E9SuZna5AjBENMUgOah6rlmUQBbKtm++LvFOibmnEoqjd8wfO
   Q==;
X-CSE-ConnectionGUID: iv/qWqeUSpye/JsVF8crew==
X-CSE-MsgGUID: z7STBDwzToG8PQyYccMm9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446179"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446179"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: fV+mnNveSuukTPmN+ev+1w==
X-CSE-MsgGUID: wg7aOt49SeOSJiIt/w9j1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285418"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:48 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 11/21] KVM: x86: Save and reload SSP to/from SMRAM
Date: Thu, 21 Aug 2025 06:30:45 -0700
Message-ID: <20250821133132.72322-12-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
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
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
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
2.47.3


