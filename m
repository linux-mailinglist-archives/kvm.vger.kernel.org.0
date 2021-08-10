Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02573E543B
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 09:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhHJH0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 03:26:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:57009 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhHJH0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 03:26:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="202022560"
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="202022560"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 00:25:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="483945738"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by fmsmga008.fm.intel.com with ESMTP; 10 Aug 2021 00:25:48 -0700
Date:   Tue, 10 Aug 2021 15:38:58 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 04/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Message-ID: <20210810073858.GA2970@intel.com>
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-5-git-send-email-weijiang.yang@intel.com>
 <e739722a-b875-6e5b-3e77-38586d799485@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e739722a-b875-6e5b-3e77-38586d799485@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021 at 09:16:47PM +0800, Like Xu wrote:
> On 6/8/2021 3:42 pm, Yang Weijiang wrote:
> >From: Like Xu <like.xu@linux.intel.com>
> 
> ...
> 
> >
> >The number of Arch LBR entries available is determined by the value
> >in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
> >enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
> >in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
> >supported.
> >
> >On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
> >KVM writes guest requested value to the native ARCH_LBR_DEPTH MSR
> >(this is safe because the two values will be the same) when the Arch LBR
> >records MSRs are pass-through to the guest.
> >
> >Signed-off-by: Like Xu <like.xu@linux.intel.com>
> >Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> >---
> >  arch/x86/kvm/vmx/pmu_intel.c | 35 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 34 insertions(+), 1 deletion(-)
> >
> >diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> >index 9efc1a6b8693..a4ef5bbce186 100644
> >--- a/arch/x86/kvm/vmx/pmu_intel.c
> >+++ b/arch/x86/kvm/vmx/pmu_intel.c
> >@@ -211,7 +211,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
> >  static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> >  {
> >  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >-	int ret;
> >+	int ret = 0;
> >  	switch (msr) {
> >  	case MSR_CORE_PERF_FIXED_CTR_CTRL:
> >@@ -220,6 +220,10 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> >  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> >  		ret = pmu->version > 1;
> >  		break;
> >+	case MSR_ARCH_LBR_DEPTH:
> >+		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> >+			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
> >+		break;
> >  	default:
> >  		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
> >  			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
> >@@ -348,10 +352,28 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
> >  	return true;
> >  }
> >+/*
> >+ * Check if the requested depth value the same as that of host.
> >+ * When guest/host depth are different, the handling would be tricky,
> >+ * so now only max depth is supported for both host and guest.
> >+ */
> >+static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
> >+{
> >+	unsigned int eax, ebx, ecx, edx;
> >+
> >+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> >+		return false;
> >+
> >+	cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
> 
> I really don't understand why the sanity check of the
> guest lbr depth needs to read the host's cpuid entry and it's pretty slow.
>
This is to address a concern from Jim:
"Does this imply that, when restoring a vCPU, KVM_SET_CPUID2 must be called before
KVM_SET_MSRS, so that arch_lbr_depth_is_valid() knows what to do? Is this documented
anywhere?" 
anyway, setting depth MSR shouldn't be hot path.
 
> KVM has reported the maximum host LBR depth as the only supported value.
> 
> >+
> >+	return (depth == fls(eax & 0xff) * 8);
> >+}
> >+
> >  static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  {
> >  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >  	struct kvm_pmc *pmc;
> >+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> >  	u32 msr = msr_info->index;
> >  	switch (msr) {
> >@@ -367,6 +389,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> >  		msr_info->data = pmu->global_ovf_ctrl;
> >  		return 0;
> >+	case MSR_ARCH_LBR_DEPTH:
> >+		msr_info->data = lbr_desc->records.nr;
> >+		return 0;
> >  	default:
> >  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> >  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> >@@ -393,6 +418,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  {
> >  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >  	struct kvm_pmc *pmc;
> >+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> >  	u32 msr = msr_info->index;
> >  	u64 data = msr_info->data;
> >@@ -427,6 +453,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  			return 0;
> >  		}
> >  		break;
> >+	case MSR_ARCH_LBR_DEPTH:
> >+		if (!arch_lbr_depth_is_valid(vcpu, data))
> >+			return 1;
> >+		lbr_desc->records.nr = data;
> >+		if (!msr_info->host_initiated)
> >+			wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
> 
> Resetting the host msr here is dangerous,
> what if the guest LBR event doesn't exist or isn't scheduled on?
Hmm, should be vmcs_write to the DEPTH field, thanks for pointing this
out!
> 
> >+		return 0;
> >  	default:
> >  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> >  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> >
