Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B7125E68
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 09:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfEVHCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 03:02:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:31984 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbfEVHCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 03:02:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 00:02:08 -0700
X-ExtLoop1: 1
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2019 00:02:06 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yu-cheng.yu@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH v5 8/8] KVM: x86: Add user-space access interface for CET MSRs
Date:   Wed, 22 May 2019 15:01:01 +0800
Message-Id: <20190522070101.7636-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190522070101.7636-1-weijiang.yang@intel.com>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There're two different places storing Guest CET states, the states
managed with XSAVES/XRSTORS, as restored/saved
in previous patch, can be read/write directly from/to the MSRs.
For those stored in VMCS fields, they're access via vmcs_read/
vmcs_write.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/msr-index.h |  2 ++
 arch/x86/kvm/vmx/vmx.c           | 43 ++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index dc0a67c1ed80..53a4ef337846 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -827,6 +827,8 @@
 #define MSR_IA32_U_CET		0x6a0 /* user mode cet setting */
 #define MSR_IA32_S_CET		0x6a2 /* kernel mode cet setting */
 #define MSR_IA32_PL0_SSP	0x6a4 /* kernel shstk pointer */
+#define MSR_IA32_PL1_SSP	0x6a5 /* ring 1 shstk pointer */
+#define MSR_IA32_PL2_SSP	0x6a6 /* ring 2 shstk pointer */
 #define MSR_IA32_PL3_SSP	0x6a7 /* user shstk pointer */
 #define MSR_IA32_INT_SSP_TAB	0x6a8 /* exception shstk table */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dec6bda20235..233f58af3878 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1777,6 +1777,27 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
+	case MSR_IA32_U_CET:
+		rdmsrl(MSR_IA32_U_CET, msr_info->data);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
+	case MSR_IA32_PL0_SSP:
+		rdmsrl(MSR_IA32_PL0_SSP, msr_info->data);
+		break;
+	case MSR_IA32_PL1_SSP:
+		rdmsrl(MSR_IA32_PL1_SSP, msr_info->data);
+		break;
+	case MSR_IA32_PL2_SSP:
+		rdmsrl(MSR_IA32_PL2_SSP, msr_info->data);
+		break;
+	case MSR_IA32_PL3_SSP:
+		rdmsrl(MSR_IA32_PL3_SSP, msr_info->data);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2012,6 +2033,28 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+		vmcs_writel(GUEST_S_CET, data);
+		break;
+	case MSR_IA32_U_CET:
+		wrmsrl(MSR_IA32_U_CET, data);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
+	case MSR_IA32_PL0_SSP:
+		wrmsrl(MSR_IA32_PL0_SSP, data);
+		break;
+	case MSR_IA32_PL1_SSP:
+		wrmsrl(MSR_IA32_PL1_SSP, data);
+		break;
+	case MSR_IA32_PL2_SSP:
+		wrmsrl(MSR_IA32_PL2_SSP, data);
+		break;
+	case MSR_IA32_PL3_SSP:
+		wrmsrl(MSR_IA32_PL3_SSP, data);
+		break;
+
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
-- 
2.17.2

