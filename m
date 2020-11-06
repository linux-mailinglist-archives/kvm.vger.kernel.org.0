Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2926A2A8BDB
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 02:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733271AbgKFBGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 20:06:42 -0500
Received: from mga18.intel.com ([134.134.136.126]:38191 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733237AbgKFBGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 20:06:39 -0500
IronPort-SDR: 6AkZnlBe7JYycstSJ/IKTDDfQvZxd+QaWQKAHRmmAIWf2mMrBf6hSAPmw5oq/KCs07fHdpy8jW
 XNPFBceJ43vA==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="157264716"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="157264716"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 17:06:38 -0800
IronPort-SDR: Cq9sbFqjcWPBe5rvAf6GTguXqh1M0OAtxTYrlkp6IlUlR61kH1ncpyMnJkfrjhQE/5HNWqAxqM
 ZdsqOB+goWRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="471874567"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2020 17:06:36 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v14 12/13] KVM: nVMX: Add helper to check the vmcs01 MSR bitmap for MSR pass-through
Date:   Fri,  6 Nov 2020 09:16:36 +0800
Message-Id: <20201106011637.14289-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201106011637.14289-1-weijiang.yang@intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
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
index 89af692deb7e..8abc7bdd94f7 100644
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
2.17.2

