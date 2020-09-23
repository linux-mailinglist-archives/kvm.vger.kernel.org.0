Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB06275D8E
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgIWQgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:36:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:7062 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgIWQgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:36:32 -0400
IronPort-SDR: sZaBEw4TUO7YXQGgQS1cziRgqfOWaEPUKIc3Hz/S6sNAuvPF5d3G1D6idT7JxPRqC6cAIkYaww
 0CjyUfkH/DAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140962214"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140962214"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:36:31 -0700
IronPort-SDR: Yv13kHX3I8rLsS95qzixWRXkyTNfEnxIkgB1rHIYd4GZkW/U0589udwNYOIg+S9sHaAy03hbf8
 cw1GwkKNGxeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454981824"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 09:36:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK with helper function
Date:   Wed, 23 Sep 2020 09:36:28 -0700
Message-Id: <20200923163629.20168-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923163629.20168-1-sean.j.christopherson@intel.com>
References: <20200923163629.20168-1-sean.j.christopherson@intel.com>
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

