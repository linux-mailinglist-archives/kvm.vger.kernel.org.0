Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0425E30D89B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhBCL0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:26:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:28325 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234103AbhBCLYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:24:11 -0500
IronPort-SDR: bnH/wJZkB9qH5/Qmdw0ZsOw7AgOftPGCzTSsyBlR/oVwk0Kf+NU9X2qUQqfcMfBbCtjw6okil2
 FKox9qV6PaMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981321"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981321"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:29 -0800
IronPort-SDR: MDaR4lSE2oYPbm+4nf74lh8jOiLsoJWHDdWqyJ7qCCWsJWaO7Rq7Dq2SCMxTmiPN81OKlYvKx/
 q19vyVHIz7eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311213"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:27 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 12/14] KVM: nVMX: Add helper to check the vmcs01 MSR bitmap for MSR pass-through
Date:   Wed,  3 Feb 2021 19:34:19 +0800
Message-Id: <20210203113421.5759-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to perform the check on the vmcs01/l01 MSR bitmap when
disabling interception of an MSR for L2.  This reduces the boilerplate
for the existing cases, and will be used heavily in a future patch for
CET MSRs.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f2b9bfb58206..3b405ebabb6e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -544,6 +544,17 @@ static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
 	}
 }
 
+static void nested_vmx_cond_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
+						      unsigned long *bitmap_12,
+						      unsigned long *bitmap_02,
+						      int type)
+{
+	if (msr_write_intercepted_l01(vcpu, msr))
+		return;
+
+	nested_vmx_disable_intercept_for_msr(bitmap_12, bitmap_02, msr, type);
+}
+
 static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
 {
 	int msr;
@@ -640,17 +651,13 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	 *    updated to reflect this when L1 (or its L2s) actually write to
 	 *    the MSR.
 	 */
-	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL))
-		nested_vmx_disable_intercept_for_msr(
-					msr_bitmap_l1, msr_bitmap_l0,
-					MSR_IA32_SPEC_CTRL,
-					MSR_TYPE_R | MSR_TYPE_W);
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_R | MSR_TYPE_W);
 
-	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD))
-		nested_vmx_disable_intercept_for_msr(
-					msr_bitmap_l1, msr_bitmap_l0,
-					MSR_IA32_PRED_CMD,
-					MSR_TYPE_W);
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_W);
 
 	kvm_vcpu_unmap(vcpu, &to_vmx(vcpu)->nested.msr_bitmap_map, false);
 
-- 
2.26.2

