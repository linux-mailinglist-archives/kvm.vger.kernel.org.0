Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2209827798D
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 21:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIXTnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 15:43:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:31793 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgIXTm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 15:42:56 -0400
IronPort-SDR: D4iXNd6lfzcIyjuQvCELRGUAJOpT1jj5jRHaN7rwrcbkj3sKb9MEgGZ9Nsi2CSnqgKFJWb0uFu
 10x3KBrC/Rtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="149076390"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="149076390"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:42:52 -0700
IronPort-SDR: ZEDh0cnvrQ/71qCLp/tHzQ92oH133MPFU2OpzJ2aHR1x6plt8DKxd03AC/J/GbDRlJ3boIJjgg
 cXHSJdcGmdqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="347953052"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Sep 2020 12:42:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK with helper function
Date:   Thu, 24 Sep 2020 12:42:48 -0700
Message-Id: <20200924194250.19137-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924194250.19137-1-sean.j.christopherson@intel.com>
References: <20200924194250.19137-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index be82da055fc4..0d41faf63b57 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -146,9 +146,6 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 	RTIT_STATUS_ERROR | RTIT_STATUS_STOPPED | \
 	RTIT_STATUS_BYTECNT))
 
-#define MSR_IA32_RTIT_OUTPUT_BASE_MASK \
-	(~((1UL << cpuid_maxphyaddr(vcpu)) - 1) | 0x7f)
-
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * ple_gap:    upper bound on the amount of time between two successive
@@ -1037,6 +1034,12 @@ static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
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
@@ -2167,7 +2170,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_single_range_output))
 			return 1;
-		if (data & MSR_IA32_RTIT_OUTPUT_BASE_MASK)
+		if (!pt_output_base_valid(vcpu, data))
 			return 1;
 		vmx->pt_desc.guest.output_base = data;
 		break;
-- 
2.28.0

