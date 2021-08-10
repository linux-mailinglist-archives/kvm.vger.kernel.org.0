Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781613E54FA
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 10:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbhHJIRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 04:17:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:60946 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235441AbhHJIRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 04:17:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="202029242"
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="202029242"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 01:17:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="515678692"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Aug 2021 01:17:29 -0700
Date:   Tue, 10 Aug 2021 16:30:40 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for
 guest Arch LBR
Message-ID: <20210810083040.GB2970@intel.com>
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-6-git-send-email-weijiang.yang@intel.com>
 <59ef2c3c-0997-d6a5-0d4a-4e777206a665@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ef2c3c-0997-d6a5-0d4a-4e777206a665@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021 at 09:36:49PM +0800, Like Xu wrote:
> On 6/8/2021 3:42 pm, Yang Weijiang wrote:
> >From: Like Xu <like.xu@linux.intel.com>
> >
> >Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
> >state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
> >When guest Arch LBR is enabled, a guest LBR event will be created like the
> >model-specific LBR does. Clear guest LBR enable bit on host PMI handling so
> >guest can see expected config.
> >
> >On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
> >meaning. It can be written to 0 or 1, but reads will always return 0.
> >Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also preserved on INIT.
> >
> >Regardless of the Arch LBR or legacy LBR, when the LBR_EN bit 0 of the
> >corresponding control MSR is set to 1, LBR recording will be enabled.
> >
> >Signed-off-by: Like Xu <like.xu@linux.intel.com>
> >Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> >---
> >  arch/x86/events/intel/lbr.c      |  2 --
> >  arch/x86/include/asm/msr-index.h |  1 +
> >  arch/x86/include/asm/vmx.h       |  2 ++
> >  arch/x86/kvm/vmx/pmu_intel.c     | 48 ++++++++++++++++++++++++++++----
> >  arch/x86/kvm/vmx/vmx.c           |  9 ++++++
> >  5 files changed, 55 insertions(+), 7 deletions(-)
> >

[...]

> >+static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
> >+{
> >+	unsigned int eax, ebx, ecx, edx;
> >+
> >+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> >+		return false;
> >+
> >+	cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
> >+	if (!(ebx & BIT(0)) && (ctl & ARCH_LBR_CTL_CPL))
> >+		return false;
> >+	if (!(ebx & BIT(2)) && (ctl & ARCH_LBR_CTL_STACK))
> >+		return false;
> >+	if (!(ebx & BIT(1)) && (ctl & ARCH_LBR_CTL_BRN_MASK))
> >+		return false;
> >+
> >+	return !(ctl & ~KVM_ARCH_LBR_CTL_MASK);
> >+}
> 
> Please check it with the *guest* cpuid entry.
If KVM "trusts" user-space, then check with guest cpuid is OK.
But if user-space enable excessive controls, then check against guest
cpuid could make things mess.

> 
> And it should remove the bits that are not supported by x86_pmu.lbr_ctl_mask before
> vmcs_write64(...) if the guest value is a superset of the host value with
> warning message.
Then I think it makes more sense to check against x86_pmu.lbr_xxx masks in above function
for compatibility. What do you think of it?
> 
> >+
> >  static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  {
> >  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >@@ -392,6 +414,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  	case MSR_ARCH_LBR_DEPTH:
> >  		msr_info->data = lbr_desc->records.nr;
> >  		return 0;
> >+	case MSR_ARCH_LBR_CTL:
> >+		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
> >+		return 0;
> >  	default:
> >  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> >  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> >  		vmcs_write64(GUEST_IA32_DEBUGCTL, data);

[...]

> >  		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
> >  		    (data & DEBUGCTLMSR_LBR))
> >@@ -4441,6 +4448,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  		vmcs_writel(GUEST_SYSENTER_ESP, 0);
> >  		vmcs_writel(GUEST_SYSENTER_EIP, 0);
> >  		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
> >+		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
> >+			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
> 
> Please update dump_vmcs() to dump GUEST_IA32_LBR_CTL as well.
OK, will add it.
> 
> How about update the load_vmcs12_host_state() for GUEST_IA32_LBR_CTL
> since you enabled the nested case in this patch set ?
No, I didn't enable nested Arch LBR but unblocked some issues for nested case.
> 
> >  	}
> >  	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
> >
