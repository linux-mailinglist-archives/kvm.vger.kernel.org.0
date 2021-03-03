Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3D932B5CB
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1452182AbhCCHUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:20:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:46711 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238280AbhCCF5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 00:57:44 -0500
IronPort-SDR: 4df1HfbWa1TGM3weHNFlY3K3u8vCKkjzmAgydyuyLoahB11GdDRky52wQN7nuORokoOcwPCdOb
 +3A1es2vbJsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="187225218"
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="187225218"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 21:56:54 -0800
IronPort-SDR: PbsOBCdr6YFQPm3VhY1tyo14Q++dIXx3Q8TGVQxLMuzUpfhkLyskwcdSWgz3bwhfjYNyezIG0O
 KcTqKTKkYyYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="399516650"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2021 21:56:52 -0800
Date:   Wed, 3 Mar 2021 14:09:39 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <20210303060939.GA8243@local-michael-cet-test.sh.intel.com>
References: <20210225030951.17099-1-weijiang.yang@intel.com>
 <20210225030951.17099-2-weijiang.yang@intel.com>
 <YD0oa99pgXqlS07h@google.com>
 <87y2f5etc2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2f5etc2.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 11:35:41AM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > +Vitaly
> >
> > On Thu, Feb 25, 2021, Yang Weijiang wrote:
> >> These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
> >> read/write them and after they're changed. If CET guest entry-load bit is not
> >> set by L1 guest, migrate them to L2 manaully.
> >> 
> >> Suggested-by: Sean Christopherson <seanjc@google.com>
> >> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> >> 
> >> change in v2:
> >>  - Per Sean's review feedback, change CET guest states as rarely-updated fields.
> >>    And also migrate L1's CET states to L2 if the entry-load bit is not set.
> >>  - Opportunistically removed one blank line.
> >> ---
> >>  arch/x86/kvm/cpuid.c      |  1 -
> >>  arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++++++++++++++
> >>  arch/x86/kvm/vmx/vmx.h    |  3 +++
> >>  3 files changed, 32 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >> index 46087bca9418..afc97122c05c 100644
> >> --- a/arch/x86/kvm/cpuid.c
> >> +++ b/arch/x86/kvm/cpuid.c
> >> @@ -143,7 +143,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> >>  		}
> >>  		vcpu->arch.guest_supported_xss =
> >>  			(((u64)best->edx << 32) | best->ecx) & supported_xss;
> >> -
> >>  	} else {
> >>  		vcpu->arch.guest_supported_xss = 0;
> >>  	}
> >> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> index 9728efd529a1..1703b8874fad 100644
> >> --- a/arch/x86/kvm/vmx/nested.c
> >> +++ b/arch/x86/kvm/vmx/nested.c
> >> @@ -2516,6 +2516,12 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> >>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
> >>  
> >>  	set_cr4_guest_host_mask(vmx);
> >> +
> >> +	if (kvm_cet_supported()) {
> >
> > This needs to be conditioned on CET coming from vmcs12, it's on the loading of
> > host state on VM-Exit that is unconditional (if CET is supported).
> >
> > 	if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
> > 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> >
> > I also assume these should be guarded by one of the eVMCS fields, though a quick
> > search of the public docs didn't provide a hit on the CET fields.
> >
> > Vitaly, any idea if these will be GUEST_GRP2 or something else?
> >
> 
> The latest published TLFS I see is 6.0b and it doesn't list anything CET
> related in eVMCS v1.0 :-( So I agree with Paolo: we just need to adjust
> EVMCS1_UNSUPPORTED_VMENTRY_CTRL/ EVMCS1_UNSUPPORTED_VMEXIT_CTRL for now
> and enable it separately later.
>

Thanks Vitaly and Paolo.
New patches have been sent to community.

> >> +		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> >> +		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> >> +		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
> >> +	}
> >>  }
> >
> 
> -- 
> Vitaly
