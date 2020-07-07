Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72721793A
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 22:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgGGUV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 16:21:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:12443 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbgGGUV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 16:21:56 -0400
IronPort-SDR: uoxJQAuQkzdkRWD4beIOXNEvSJEe27ZjNoTNxNdSl3x8LpJU1CNryAbyr8pdVhdXQYp5SbtQ4V
 5XidVzsF4T1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="165762916"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="165762916"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 13:21:55 -0700
IronPort-SDR: 5S8dbwAmxyaDzUOfHT+EAChbAGQuisZKVQi7WCkNmyrcQ2D1hLFUXEy4gNWnKQgQf4ZDRpEEnR
 cGrxXojTt5QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="388616648"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jul 2020 13:21:55 -0700
Date:   Tue, 7 Jul 2020 13:21:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v12 07/11] KVM: vmx/pmu: Unmask LBR fields in the
 MSR_IA32_DEBUGCTLMSR emualtion
Message-ID: <20200707202155.GL20096@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200613080958.132489-8-like.xu@linux.intel.com>
 <654d931c-a724-ed69-6501-52ce195a6f44@intel.com>
 <ea424570-c93f-2624-3e85-d7255b609da4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea424570-c93f-2624-3e85-d7255b609da4@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 13, 2020 at 05:42:50PM +0800, Xu, Like wrote:
> On 2020/6/13 17:14, Xiaoyao Li wrote:
> >On 6/13/2020 4:09 PM, Like Xu wrote:
> >>When the LBR feature is reported by the vmx_get_perf_capabilities(),
> >>the LBR fields in the [vmx|vcpu]_supported debugctl should be unmasked.
> >>
> >>The debugctl msr is handled separately in vmx/svm and they're not
> >>completely identical, hence remove the common msr handling code.

I would prefer to put the "remove DEBUGCTRL handling from common x86" in a
separate patch.  Without digging into SVM, it's not obvious that dropping
MSR_IA32_DEBUGCTLMSR from kvm_set_msr_common() is a nop for SVM.

> >>Signed-off-by: Like Xu <like.xu@linux.intel.com>
> >>---
> >>  arch/x86/kvm/vmx/capabilities.h | 12 ++++++++++++
> >>  arch/x86/kvm/vmx/pmu_intel.c    | 19 +++++++++++++++++++
> >>  arch/x86/kvm/x86.c              | 13 -------------
> >>  3 files changed, 31 insertions(+), 13 deletions(-)
> >>
> >>diff --git a/arch/x86/kvm/vmx/capabilities.h
> >>b/arch/x86/kvm/vmx/capabilities.h
> >>index b633a90320ee..f6fcfabb1026 100644
> >>--- a/arch/x86/kvm/vmx/capabilities.h
> >>+++ b/arch/x86/kvm/vmx/capabilities.h
> >>@@ -21,6 +21,8 @@ extern int __read_mostly pt_mode;
> >>  #define PMU_CAP_FW_WRITES    (1ULL << 13)
> >>  #define PMU_CAP_LBR_FMT        0x3f
> >>  +#define DEBUGCTLMSR_LBR_MASK        (DEBUGCTLMSR_LBR |
> >>DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)
> >>+
> >>  struct nested_vmx_msrs {
> >>      /*
> >>       * We only store the "true" versions of the VMX capability MSRs. We
> >>@@ -387,4 +389,14 @@ static inline u64 vmx_get_perf_capabilities(void)
> >>      return perf_cap;
> >>  }
> >>  +static inline u64 vmx_get_supported_debugctl(void)
> >>+{
> >>+    u64 val = 0;
> >>+
> >>+    if (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT)
> >>+        val |= DEBUGCTLMSR_LBR_MASK;
> >>+
> >>+    return val;
> >>+}
> >>+
> >>  #endif /* __KVM_X86_VMX_CAPS_H */
> >>diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> >>index a953c7d633f6..d92e95b64c74 100644
> >>--- a/arch/x86/kvm/vmx/pmu_intel.c
> >>+++ b/arch/x86/kvm/vmx/pmu_intel.c
> >>@@ -187,6 +187,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu
> >>*vcpu, u32 msr)
> >>      case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> >>          ret = pmu->version > 1;
> >>          break;
> >>+    case MSR_IA32_DEBUGCTLMSR:
> >>      case MSR_IA32_PERF_CAPABILITIES:
> >>          ret = 1;
> >>          break;
> >>@@ -237,6 +238,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu,
> >>struct msr_data *msr_info)
> >>              return 1;
> >>          msr_info->data = vcpu->arch.perf_capabilities;
> >>          return 0;
> >>+    case MSR_IA32_DEBUGCTLMSR:
> >>+        msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> >
> >Can we put the emulation of MSR_IA32_DEBUGCTLMSR in vmx_{get/set})_msr().
> >AFAIK, MSR_IA32_DEBUGCTLMSR is not a pure PMU related MSR that there is
> >bit 2 to enable #DB for bus lock.
> We already have "case MSR_IA32_DEBUGCTLMSR" handler in the vmx_set_msr()
> and you may apply you bus lock changes in that handler.

Hrm, but that'd be weird dependency as vmx_set_msr() would need to check for
#DB bus lock support but not actually write GUEST_IA32_DEBUGCTL, or we'd end
up writing it twice when both bus lock and LBR are supported.

I don't see anything in the series that takes action on writes to
MSR_IA32_DEBUGCTLMSR beyond updating the VMCS, i.e. AFAICT there isn't any
reason to call into the PMU, VMX can simply query vmx_get_perf_capabilities()
to check if it's legal to enable DEBUGCTLMSR_LBR_MASK.

A question for both LBR and bus lock: would it make sense to cache the
guest's value in vcpu_vmx so that querying the guest value doesn't require
a VMREAD?  I don't have a good feel for how frequently it would be accessed.

> >>+        return 0;
> >>      default:
> >>          if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> >>              (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> >>@@ -282,6 +286,16 @@ static inline bool lbr_is_compatible(struct
> >>kvm_vcpu *vcpu)
> >>      return true;
> >>  }
> >>  +static inline u64 vcpu_get_supported_debugctl(struct kvm_vcpu *vcpu)
> >>+{
> >>+    u64 debugctlmsr = vmx_get_supported_debugctl();
> >>+
> >>+    if (!lbr_is_enabled(vcpu))
> >>+        debugctlmsr &= ~DEBUGCTLMSR_LBR_MASK;
> >>+
> >>+    return debugctlmsr;
> >>+}
> >>+
> >>  static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data
> >>*msr_info)
> >>  {
> >>      struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >>@@ -336,6 +350,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu,
> >>struct msr_data *msr_info)
> >>          }
> >>          vcpu->arch.perf_capabilities = data;
> >>          return 0;
> >>+    case MSR_IA32_DEBUGCTLMSR:
> >>+        if (data & ~vcpu_get_supported_debugctl(vcpu))
> >>+            return 1;
> >>+        vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> >>+        return 0;
> >>      default:
> >>          if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> >>              (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> >>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>index 00c88c2f34e4..56f275eb4554 100644
> >>--- a/arch/x86/kvm/x86.c
> >>+++ b/arch/x86/kvm/x86.c
> >>@@ -2840,18 +2840,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu,
> >>struct msr_data *msr_info)
> >>              return 1;
> >>          }
> >>          break;
> >>-    case MSR_IA32_DEBUGCTLMSR:
> >>-        if (!data) {
> >>-            /* We support the non-activated case already */
> >>-            break;
> >>-        } else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
> >
> >So after this patch, guest trying to set bit DEBUGCTLMSR_BTF will get a
> >#GP instead of being ignored and printing a log in kernel.
> >
> 
> Since the BTF is not implemented on the KVM at all,
> I do propose not left this kind of dummy thing in the future KVM code.
> 
> Let's see if Netware or any BTF user will complain about this change.

If you want to drop that behavior it needs be done in a separate patch.
Personally I don't see the point in doing so, it's a trivial amount of code
in KVM and there's no harm in dropping the bits on write.
