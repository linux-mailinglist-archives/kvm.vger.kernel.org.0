Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0591F32CC44
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 07:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhCDF7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 00:59:22 -0500
Received: from mga17.intel.com ([192.55.52.151]:21297 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234473AbhCDF64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 00:58:56 -0500
IronPort-SDR: Z1p5Tn5nraeebuC75Eb9NDZmY6fsoLIEY6ZBgEVN8iZOjL0EmrnWRswv+m6zZPWBkb+sAVDdT2
 XcGbxNH7WY2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="167246444"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="167246444"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 21:58:12 -0800
IronPort-SDR: Nwe/rRRaOBisODDOsXPKZlisjpbHoEK99+qpPu6jkfqQ7F8SCn8eEIlorjhPBz1Bv3x832B8RE
 J67n0ZdmJOAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="400431233"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 21:58:10 -0800
Date:   Thu, 4 Mar 2021 14:10:55 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Add CET entry/exit load bits to evmcs
 unsupported list
Message-ID: <20210304061055.GA11421@local-michael-cet-test.sh.intel.com>
References: <20210303060435.8158-1-weijiang.yang@intel.com>
 <87h7lsefyv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7lsefyv.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021 at 10:36:40AM +0100, Vitaly Kuznetsov wrote:
> Yang Weijiang <weijiang.yang@intel.com> writes:
> 
> > CET in nested guest over Hyper-V is not supported for now. Relevant
> > enabling patches will be posted as a separate patch series.
> >
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/evmcs.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> > index bd41d9462355..25588694eb04 100644
> > --- a/arch/x86/kvm/vmx/evmcs.h
> > +++ b/arch/x86/kvm/vmx/evmcs.h
> > @@ -59,8 +59,10 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
> >  	 SECONDARY_EXEC_SHADOW_VMCS |					\
> >  	 SECONDARY_EXEC_TSC_SCALING |					\
> >  	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
> > -#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> > -#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
> > +#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | \
> > +					VM_EXIT_LOAD_CET_STATE)
> > +#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | \
> > +					 VM_ENTRY_LOAD_CET_STATE)
> >  #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
> >  
> >  #if IS_ENABLED(CONFIG_HYPERV)
> 
> This should be enough when we run KVM on Hyper-V using eVMCS, however,
> it may not suffice when we run Hyper-V on KVM using eVMCS: there's still
> no corresponding eVMCS fields so CET can't be used. In case Hyper-V is
> smart enough it won't use the feature, however, it was proven to be 'not
> very smart' in the past, see nested_evmcs_filter_control_msr(). I'm
> wondering if we should also do
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 41f24661af04..9f81db51fd8b 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -351,11 +351,11 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>         switch (msr_index) {
>         case MSR_IA32_VMX_EXIT_CTLS:
>         case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> -               ctl_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +               ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>                 break;
>         case MSR_IA32_VMX_ENTRY_CTLS:
>         case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> -               ctl_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +               ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
>                 break;
>         case MSR_IA32_VMX_PROCBASED_CTLS2:
>                 ctl_high &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> 
> to be on the safe side.

Yes, it looks good to me, will add it to new patch, thanks!

> 
> -- 
> Vitaly
