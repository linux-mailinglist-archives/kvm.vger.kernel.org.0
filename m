Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18C6221B04
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgGPDoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:44:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:54949 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgGPDoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:44:11 -0400
IronPort-SDR: /fZd8rCwJpiKyri9jPiGJHHrTOyNp2KlCTLkZ6pyyqR9GvyTEwQu0xidqCjeIqPlf/ukvlZIyy
 a+YNJVe6pC2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="150699763"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="150699763"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:44:10 -0700
IronPort-SDR: FoScwJ/y6PpfgYO0eWBfL/C9+7AOnuYVy1wgjYxDO0siAXT4tI19VBEMmMiM7KppUZz4Upfub6
 0M6RzHi4UQFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="282314263"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 15 Jul 2020 20:44:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK with helper function
Date:   Wed, 15 Jul 2020 20:44:07 -0700
Message-Id: <20200716034408.6342-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200716034408.6342-1-sean.j.christopherson@intel.com>
References: <20200716034408.6342-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the subtly not-a-constant MSR_IA32_RTIT_OUTPUT_BASE_MASK with a
proper helper function to check whether or not the specified base is
valid.  Blindly referencing the local 'vcpu' is especially nasty.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 50b7e85d37352..cf3c3562e843c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -145,9 +145,6 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 	RTIT_STATUS_ERROR | RTIT_STATUS_STOPPED | \
 	RTIT_STATUS_BYTECNT))
 
-#define MSR_IA32_RTIT_OUTPUT_BASE_MASK \
-	(~((1UL << cpuid_maxphyaddr(vcpu)) - 1) | 0x7f)
-
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * ple_gap:    upper bound on the amount of time between two successive
@@ -1036,6 +1033,12 @@ static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
 	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
 }
 
+static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
+{
+	/* The base must be 128-byte aligned and a legal physical address. */
+	return !(base & (~((1UL << cpuid_maxphyaddr(vcpu)) - 1) | 0x7f));
+}
+
 static inline void pt_load_msr(struct pt_ctx *ctx, u32 addr_range)
 {
 	u32 i;
@@ -2193,7 +2196,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_single_range_output))
 			return 1;
-		if (data & MSR_IA32_RTIT_OUTPUT_BASE_MASK)
+		if (!pt_output_base_valid(vcpu, data))
 			return 1;
 		vmx->pt_desc.guest.output_base = data;
 		break;
-- 
2.26.0

