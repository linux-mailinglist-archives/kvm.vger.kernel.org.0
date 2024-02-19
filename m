Return-Path: <kvm+bounces-9022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F044B859D83
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:52:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90748B22649
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1CE32C8C;
	Mon, 19 Feb 2024 07:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="erLHhcPE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1BC2C6A5;
	Mon, 19 Feb 2024 07:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328872; cv=none; b=Rjepv+AHHVSXUJ1jN4a5Z4WI2jiVfugb/IoaSeUHswUecBahEG/Qu7o0cLsTRnC2bGFaAY6dAo1cSupRXa3r/UNIu+Qy2kVWxAx145qPo7AGdUh5U6DCF/tWnWkyPLftdpFYn1rS4RY65aKxpPQM9UKlYfj0aI8VzYAE81fLXvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328872; c=relaxed/simple;
	bh=LLhrBOymq6NYTEUsoYOVmixfi9tT5OVBKgVwc5iax14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB/NL/NSV1CuM3GfzeCBfIL9wvtWUHtSfGBerFgXPCeYqiGM5uZ/N9p/77Mvqf7nmnRhwh9u8zmIwQdD+4vF61pwduFe1vTclHz6rg+SV32+zxo//zyLHvuq6jtuPlWFM28vtOlrQre9p8tAdoq4ti+dvUvC93tGXMaftYcxwzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=erLHhcPE; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328870; x=1739864870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LLhrBOymq6NYTEUsoYOVmixfi9tT5OVBKgVwc5iax14=;
  b=erLHhcPE0ozar76TYW+++JNk/DEeIdbmnd1R/Dh0IOuSYm74NeT6VqK2
   An3VBmbx/mk5S1S0zX8BDvqrDB9e5nx7oom8F8nBui+SZx7psI7IjLREE
   LjXRjT0M6A3/dsH0QFHAn69x1wu1S1xBX58YcjGR99lKsMwtkKiUxhDAW
   jFhOgvYSVs0PPNj8eGKByCXoZzoLh8/EzzSjYMT6DMicBrz8p2HUCHuAC
   Hyb6abbAA4cXLMYxaz/JeBgUHXrETAMcA65dSRqk6M7HMScbr9EPRX1+i
   5gIGl8UKhY609SeymFVL+ENcYgkVymseNLSdlhxxYrW7hpe58pO0jjQ9a
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535077"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535077"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966087"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966087"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
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
Subject: [PATCH v10 10/27] KVM: x86: Refine xsave-managed guest register/MSR reset handling
Date: Sun, 18 Feb 2024 23:47:16 -0800
Message-ID: <20240219074733.122080-11-weijiang.yang@intel.com>
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

Tweak the code a bit to facilitate resetting more xstate components in
the future, e.g., CET's xstate-managed MSRs.

No functional change intended.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 10847e1cc413..5a9c07751c0e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12217,11 +12217,27 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 		static_branch_dec(&kvm_has_noapic_vcpu);
 }
 
+#define XSTATE_NEED_RESET_MASK	(XFEATURE_MASK_BNDREGS | \
+				 XFEATURE_MASK_BNDCSR)
+
+static bool kvm_vcpu_has_xstate(unsigned long xfeature)
+{
+	switch (xfeature) {
+	case XFEATURE_MASK_BNDREGS:
+	case XFEATURE_MASK_BNDCSR:
+		return kvm_cpu_cap_has(X86_FEATURE_MPX);
+	default:
+		return false;
+	}
+}
+
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_cpuid_entry2 *cpuid_0x1;
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
+	DECLARE_BITMAP(reset_mask, 64);
 	unsigned long new_cr0;
+	unsigned int i;
 
 	/*
 	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
@@ -12274,7 +12290,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
+	bitmap_from_u64(reset_mask, (kvm_caps.supported_xcr0 |
+				     kvm_caps.supported_xss) &
+				    XSTATE_NEED_RESET_MASK);
+
+	if (vcpu->arch.guest_fpu.fpstate &&
+	    !bitmap_empty(reset_mask, XFEATURE_MAX)) {
 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 
 		/*
@@ -12284,8 +12305,11 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
 
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+		for_each_set_bit(i, reset_mask, XFEATURE_MAX) {
+			if (!kvm_vcpu_has_xstate(i))
+				continue;
+			fpstate_clear_xstate_component(fpstate, i);
+		}
 
 		if (init_event)
 			kvm_load_guest_fpu(vcpu);
-- 
2.43.0


