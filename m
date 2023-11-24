Return-Path: <kvm+bounces-2404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EA57F6D6C
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:59:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 437781C20E30
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 07:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD0A15AFB;
	Fri, 24 Nov 2023 07:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="idHEpzN5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1BE1710;
	Thu, 23 Nov 2023 23:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812724; x=1732348724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hoo4Iwqu83bRaL99m4ilvZ+WdOV6DreLDSnH/3fxOIs=;
  b=idHEpzN51+O7s0Wil+apR1RyXame7o6nVIkOi8n3PvFSY8bnZVHmFZe2
   bMjPK8RQlLYpGBi8aB+WIj7kygbay63JKGL3zD/fpZMzQV+KwRi0UVN4m
   CWTwxLRxgVuitfj0TAbVOzlSmMehReDz0A41mkjQ26sxFsOWWqpAVqnmt
   8EbBkBrXs86lhSJcIPXYF+emNcrA+wnVUUR1eU1X9aQy5KdkQpgiq5Ws+
   FuspsKgO6gob6k2a0tLkC1zxxkcGBSLJz5p7Areytzr5nDJ7lFPmWZrpR
   zGEEuZ0Ml80RvBsyjUt8j1o4KpgHpT42k9A4wkPQpW4PCiqj8e9jZFcyJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872319"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872319"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629820"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629820"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:38 -0800
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
Subject: [PATCH v7 10/26] KVM: x86: Refine xsave-managed guest register/MSR reset handling
Date: Fri, 24 Nov 2023 00:53:14 -0500
Message-Id: <20231124055330.138870-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tweak the code a bit to facilitate resetting more xstate components in
the future, e.g., adding CET's xstate-managed MSRs.

No functional change intended.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9c2c0cd4cf5..16b4f2dd138a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12132,6 +12132,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 		static_branch_dec(&kvm_has_noapic_vcpu);
 }
 
+static inline bool is_xstate_reset_needed(void)
+{
+	return kvm_cpu_cap_has(X86_FEATURE_MPX);
+}
+
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_cpuid_entry2 *cpuid_0x1;
@@ -12189,7 +12194,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
+	if (vcpu->arch.guest_fpu.fpstate && is_xstate_reset_needed()) {
 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 
 		/*
@@ -12199,8 +12204,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
 
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+		if (kvm_cpu_cap_has(X86_FEATURE_MPX)) {
+			fpstate_clear_xstate_component(fpstate,
+						       XFEATURE_BNDREGS);
+			fpstate_clear_xstate_component(fpstate,
+						       XFEATURE_BNDCSR);
+		}
 
 		if (init_event)
 			kvm_load_guest_fpu(vcpu);
-- 
2.27.0


