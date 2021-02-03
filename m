Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE33030D88F
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhBCLYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:24:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:28346 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234045AbhBCLXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:23:45 -0500
IronPort-SDR: d+rpyEnlcHbpvMtdcU9EGpp2X0LpIq6r4SjQjhPuhGFc9XiNHmqqiHopXMmACgTM75A8D4+qAI
 pBDKyzgXv3IQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981291"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981291"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:21 -0800
IronPort-SDR: XeYaaLTK1Yej0eTHCLR59Ecd/X0t6d9fPKc/8cK4k13a2zGj8sOKIkOAvhuvVZkH+24sq2Y1sa
 QOyX/yjOAgsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311168"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:19 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 08/14] KVM: VMX: Add a synthetic MSR to allow userspace VMM to access GUEST_SSP
Date:   Wed,  3 Feb 2021 19:34:15 +0800
Message-Id: <20210203113421.5759-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP so that the VMM
can read/write the guest's SSP, e.g. to migrate CET state.  Use a
synthetic MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject
to the same consistency checks as the PL*_SSP MSRs, i.e. can share code.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/vmx/vmx.c               | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..8dd562a94724 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -54,6 +54,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_GUEST_SSP	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 694879c2b0b7..4cd6a9710a51 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1816,7 +1816,8 @@ static bool cet_is_ssp_msr_accessible(struct kvm_vcpu *vcpu,
 	if (msr->host_initiated)
 		return true;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+	    msr->index == MSR_KVM_GUEST_SSP)
 		return false;
 
 	if (msr->index == MSR_IA32_INT_SSP_TAB)
@@ -1994,6 +1995,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
 		break;
+	case MSR_KVM_GUEST_SSP:
+		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_SSP);
+		break;
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
 		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
 			return 1;
@@ -2286,12 +2292,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
 		break;
+	case MSR_KVM_GUEST_SSP:
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
 		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
 			return 1;
 		if ((data & GENMASK(2, 0)) || is_noncanonical_address(data, vcpu))
 			return 1;
-		vmx_set_xsave_msr(msr_info);
+		if (msr_index == MSR_KVM_GUEST_SSP)
+			vmcs_writel(GUEST_SSP, data);
+		else
+			vmx_set_xsave_msr(msr_info);
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
-- 
2.26.2

