Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD382234067
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbgGaHqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:46:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:55474 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731821AbgGaHqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:46:18 -0400
IronPort-SDR: nvoGIYaPkWX8pvYsTqbpYanNaVvTLqw3IIEcJGCHXxOJkeukAHG7FeeCjO0Rhye5xGFUuvRatH
 FnlJEkow6DKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149570538"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="149570538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 00:46:18 -0700
IronPort-SDR: zfbK1Cz6gFXSxE0PUhamrX+tM7QB8XadwU5JH1kcfZ4iubYKL4SXyHDF87TWUSRiEt/tvw3sFs
 PeGpUIVHubqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="323160606"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2020 00:46:16 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH 4/6] KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
Date:   Fri, 31 Jul 2020 15:44:00 +0800
Message-Id: <20200731074402.8879-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200731074402.8879-1-like.xu@linux.intel.com>
References: <20200731074402.8879-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. On
processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has
no meaning. It can be written to 0 or 1, but reads will always return 0.

A new guest state field named "Guest IA32_LBR_CTL" has been added to
enhance guest LBR usage and the guest value of MSR_ARCH_LBR_CTL is
written to this field on all VM exits.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/vmx.h   |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c | 13 +++++++++++++
 arch/x86/kvm/vmx/vmx.c       |  8 ++++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cd7de4b401fe..27f53c81a17f 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -243,6 +243,8 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_LBR_CTL		= 0x00002816,
+	GUEST_IA32_LBR_CTL_HIGH		= 0x00002817,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8021fbdbd618..289c267732bd 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "pmu.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
+#define MSR_ARCH_LBR_CTL_MASK      0x7f000f
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
@@ -232,6 +233,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = pmu->version > 1;
 		break;
 	case MSR_ARCH_LBR_DEPTH:
+	case MSR_ARCH_LBR_CTL:
 		ret =  guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
 		break;
 	default:
@@ -398,6 +400,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_DEPTH:
 		msr_info->data = lbr_desc->records.nr;
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -466,6 +471,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		lbr_desc->arch_lbr_reset = true;
 		__set_bit(INTEL_GUEST_LBR_INUSE, pmu->pmc_in_use);
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		if (data & ~MSR_ARCH_LBR_CTL_MASK)
+			return 1;
+		vmcs_write64(GUEST_IA32_LBR_CTL, data);
+		if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
+		    (data & DEBUGCTLMSR_LBR))
+			intel_pmu_create_guest_lbr_event(vcpu);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d8b1d98ae1d..9f42553b1e11 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2054,6 +2054,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				__func__, data);
 			data &= ~DEBUGCTLMSR_BTF;
 		}
+
+		/*
+		 * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
+		 * It can be written to 0 or 1, but reads will always return 0.
+		 */
+		if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+			data &= ~DEBUGCTLMSR_LBR;
+
 		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
 		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
 		    (data & DEBUGCTLMSR_LBR))
-- 
2.21.3

