Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0BA82D7B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732445AbfHFIGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:06:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:5872 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732429AbfHFIGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:06:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:01:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337527"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:01:07 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 14/14] KVM/x86: remove the common handling of the debugctl msr
Date:   Tue,  6 Aug 2019 15:16:14 +0800
Message-Id: <1565075774-26671-15-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The debugctl msr is not completely identical on AMD and Intel CPUs, for
example, FREEZE_LBRS_ON_PMI is supported by Intel CPUs only. Now, this
msr is handled separatedly in svm.c and intel_pmu.c. So remove the
common debugctl msr handling code in kvm_get/set_msr_common.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/x86.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index efaf0e8..3839ebd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2528,18 +2528,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2800,7 +2788,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr_info->index) {
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
-	case MSR_IA32_DEBUGCTLMSR:
 	case MSR_IA32_LASTBRANCHFROMIP:
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
-- 
2.7.4

