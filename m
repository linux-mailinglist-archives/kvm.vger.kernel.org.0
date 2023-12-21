Return-Path: <kvm+bounces-4995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1163681B1D6
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 444CC1C238C2
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8552E54FA8;
	Thu, 21 Dec 2023 09:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dRAUm9s9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476234E1AF;
	Thu, 21 Dec 2023 09:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149430; x=1734685430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cxpPX3Wn0VREKtBeuHc/MZkj33xyM0sqH6UvdE/wBRo=;
  b=dRAUm9s9l+HdfkPkw6Ny/09VX8iYFOFRjA6Jm6Mhz/xAiryCSGgVvN4F
   2hPWVA2xre0Qplv9A/PVpemPM8HDJXqrYeKVN0x5Vzs1t7vBisyP4h3u/
   eGxl6NRJFXdVZmYEAEmY7flK8XlkaqbMnOFZdvdpOJt3MTjyZaMhSDxZL
   QEeUDCMgMK03gjmSIIDmELiIWb/mf6BcdFpFLa4RBDOSXtX7KGD1teRuX
   wPibCDDVgIEJwjXH/KZm6QexLFhpPxhZZWAQ7+y8n8vEPDhv6VLCWf/ET
   Dvcvbmf2CgNmgy0FjWVC6e3PO1E/AEgZB+2jfzBXEFpkp05v/J1/0qk6h
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729646"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729646"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028589"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028589"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:10 -0800
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
Subject: [PATCH v8 10/26] KVM: x86: Refine xsave-managed guest register/MSR reset handling
Date: Thu, 21 Dec 2023 09:02:23 -0500
Message-Id: <20231221140239.4349-11-weijiang.yang@intel.com>
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

Tweak the code a bit to facilitate resetting more xstate components in
the future, e.g., adding CET's xstate-managed MSRs.

No functional change intended.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0e7dc3398293..3671f4868d1b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12205,6 +12205,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
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
@@ -12262,7 +12267,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
+	if (vcpu->arch.guest_fpu.fpstate && is_xstate_reset_needed()) {
 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 
 		/*
@@ -12272,8 +12277,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
2.39.3


