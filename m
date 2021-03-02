Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27B032A6F9
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838939AbhCBPzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:55:31 -0500
Received: from mga18.intel.com ([134.134.136.126]:11224 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378010AbhCBIxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 03:53:54 -0500
IronPort-SDR: 52eoHLCxIQB1yD7JsOgfH1I1Rdwn10H/utiQjj+P0pK3dDC8qMFnEJU/h8Cl70hK2VSVm1VmeN
 tN7NQScd82Fw==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="174379005"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="174379005"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 00:52:45 -0800
IronPort-SDR: h4wmwP64YA75l1weRsePnlDmwwnsHRBLz5jMd2VSDVGSSFRVuF2S7JVCHcUE/tQdz3bqKumSeo
 r0zt1gW5PcqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="406623086"
Received: from unknown (HELO localhost) ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 02 Mar 2021 00:52:43 -0800
Date:   Tue, 2 Mar 2021 17:05:32 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <20210302090532.GA5372@local-michael-cet-test>
References: <20210225030951.17099-1-weijiang.yang@intel.com>
 <20210225030951.17099-2-weijiang.yang@intel.com>
 <YD0oa99pgXqlS07h@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD0oa99pgXqlS07h@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 09:46:19AM -0800, Sean Christopherson wrote:
> +Vitaly
> 
> On Thu, Feb 25, 2021, Yang Weijiang wrote:
> > These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
> > read/write them and after they're changed. If CET guest entry-load bit is not
> > set by L1 guest, migrate them to L2 manaully.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > 
> > change in v2:
> >  - Per Sean's review feedback, change CET guest states as rarely-updated fields.
> >    And also migrate L1's CET states to L2 if the entry-load bit is not set.
> >  - Opportunistically removed one blank line.
> > ---
> >  arch/x86/kvm/cpuid.c      |  1 -
> >  arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.h    |  3 +++
> >  3 files changed, 32 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 46087bca9418..afc97122c05c 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -143,7 +143,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> >  		}
> >  		vcpu->arch.guest_supported_xss =
> >  			(((u64)best->edx << 32) | best->ecx) & supported_xss;
> > -
> >  	} else {
> >  		vcpu->arch.guest_supported_xss = 0;
> >  	}
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 9728efd529a1..1703b8874fad 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2516,6 +2516,12 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> >  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
> >  
> >  	set_cr4_guest_host_mask(vmx);
> > +
> > +	if (kvm_cet_supported()) {
> 
> This needs to be conditioned on CET coming from vmcs12, it's on the loading of
> host state on VM-Exit that is unconditional (if CET is supported).
> 
> 	if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
> 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
>
Thanks Sean! Will change it.

> I also assume these should be guarded by one of the eVMCS fields, though a quick
> search of the public docs didn't provide a hit on the CET fields.
>

I got some description from MSFT as below, do you mean that:

GuestSsp uses clean field GUEST_BASIC (bit 10)
GuestSCet/GuestInterruptSspTableAddr uses GUEST_GRP1 (bit 11)
HostSCet/HostSsp/HostInterruptSspTableAddr uses HOST_GRP1 (bit 14)

If it is, should these go into separate patch series for Hyper-v nested
support? I have some pending patches for the enabling.

> Vitaly, any idea if these will be GUEST_GRP2 or something else?
> 
> > +		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> > +		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> > +		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
> > +	}
> >  }
