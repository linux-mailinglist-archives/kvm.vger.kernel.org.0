Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E1318ACD9
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgCSGgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:36:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:25753 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgCSGgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:36:07 -0400
IronPort-SDR: ZAQ6D+KT8gR5YRxuhiw0noZBPrjy0r5uNa4S2WQ6jgYEY84oMjs0g55cXW7EHO6FjMjk/zaaB+
 peP1mrucmlrg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:36:06 -0700
IronPort-SDR: F6KwX0Atn4KHwoE0e6DWfKBmMZKeFiBSHNbcsydGQRTVJZ1TI4l4JFOF7eOdCDmqeXo1b9LSlc
 BEhoesRzxsFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="248439246"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 23:36:00 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v2 5/5] KVM: VMX: Switch PEBS records output to Intel PT buffer
Date:   Thu, 19 Mar 2020 22:33:50 +0800
Message-Id: <1584628430-23220-6-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
References: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Switch PEBS records output to Intel PT buffer when PEBS is enabled
in KVM guest by Intel PT.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c6d9a87..ec74656 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -921,6 +921,7 @@ void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 {
 	int i, j = 0;
 	struct msr_autoload *m = &vmx->msr_autoload;
+	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
 	switch (msr) {
 	case MSR_EFER:
@@ -952,6 +953,8 @@ void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 		 * guest's memory.
 		 */
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
+		if ((pmu->pebs_enable & PEBS_OUTPUT_MASK) == PEBS_OUTPUT_PT)
+			guest_val |= PEBS_OUTPUT_PT;
 	}
 
 	i = vmx_find_msr_index(&m->guest, msr);
-- 
1.8.3.1

