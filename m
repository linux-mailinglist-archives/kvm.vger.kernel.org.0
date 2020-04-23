Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFF11B571A
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgDWISP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:18:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:57619 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgDWISK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:18:10 -0400
IronPort-SDR: 6nScYEbL5sC1832kois4tnBVeWgnr1VEqXB8AMu7OKKAMH5aZky/2U9IZj9wSYKXPIfMeikjOv
 Urf+vXAIFB3Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:18:09 -0700
IronPort-SDR: H2js4KyfqgKPTrSIYNjsglnFfWiHpURD680umEPk7b1S7xoshEnoq1ns8VOdG92uFnD2SZTbI6
 o0EUARnm/8+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910162"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:18:07 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com
Subject: [PATCH v10 11/11] KVM: x86: Remove the common trap handler of the MSR_IA32_DEBUGCTLMSR
Date:   Thu, 23 Apr 2020 16:14:12 +0800
Message-Id: <20200423081412.164863-12-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

The debugctl msr is not completely identical on AMD and Intel CPUs, for
example, FREEZE_LBRS_ON_PMI is supported by Intel CPUs only. Now, this
msr is handled separately in svm.c and intel_pmu.c. So remove the
common debugctl msr handling code in kvm_get/set_msr_common.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/x86.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99f819dfcc90..e6dd8525cc60 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2791,18 +2791,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case MSR_IA32_DEBUGCTLMSR:
-		if (!data) {
-			/* We support the non-activated case already */
-			break;
-		} else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
-			/* Values other than LBR and BTF are vendor-specific,
-			   thus reserved and should throw a #GP */
-			return 1;
-		}
-		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-			    __func__, data);
-		break;
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
@@ -3059,7 +3047,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr_info->index) {
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
-	case MSR_IA32_DEBUGCTLMSR:
 	case MSR_IA32_LASTBRANCHFROMIP:
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
-- 
2.21.1

