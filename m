Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2C631A98B
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 02:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhBMBvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 20:51:47 -0500
Received: from mga12.intel.com ([192.55.52.136]:53434 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhBMBvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 20:51:46 -0500
IronPort-SDR: CARAYbTy6xH6oxSFN6j8i0i7us+gHdxOqseARdi+uISJw8m7Hfb/wuSLoc3RDX6cXCwK+QFliH
 y8BVI2lrsQjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="161644256"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="161644256"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 17:51:05 -0800
IronPort-SDR: 0sEY4dpGGxoLtS+OklzWHPiVcoYVfXZ2TTGDAzOCHz0MnQ0AN9TLE7LgUA3c+ok1SfmLJcOMSL
 t2HOvecGNUtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="381938586"
Received: from unknown (HELO localhost) ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 17:51:04 -0800
Date:   Sat, 13 Feb 2021 10:03:02 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <20210213020302.GA19477@local-michael-cet-test>
References: <20210209083708.2680-1-weijiang.yang@intel.com>
 <YCVmyx8N6BYB7NGy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YCVmyx8N6BYB7NGy@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 11, 2021 at 09:18:03AM -0800, Sean Christopherson wrote:
> On Tue, Feb 09, 2021, Yang Weijiang wrote:
> > When L2 guest status has been changed by L1 QEMU/KVM, sync the change back
> > to L2 guest before the later's next vm-entry. On the other hand, if it's
> > changed due to L2 guest, sync it back so as to let L1 guest see the change.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 9728efd529a1..b9d8db8facea 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2602,6 +2602,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> >  	/* Note: may modify VM_ENTRY/EXIT_CONTROLS and GUEST/HOST_IA32_EFER */
> >  	vmx_set_efer(vcpu, vcpu->arch.efer);
> >  
> > +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
> > +		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> > +		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
> > +		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> > +	}
> > +
> 
> This is incomplete.  If VM_ENTRY_LOAD_CET_STATE is not set, then CET state needs
> to be propagated from vmcs01 to vmcs02.  See nested.vmcs01_debugctl and
> nested.vmcs01_guest_bndcfgs.
> 
> It's tempting to say that we should add machinery to simplify implementing new
> fields that are conditionally loading, e.g. define an array that specifies the
> field, its control, and its offset in vmcs12, then process the array at the
> appropriate time.  That might be overkill though...
>
Thanks Sean! I'll check the implementation of the two features.

> >  	/*
> >  	 * Guest state is invalid and unrestricted guest is disabled,
> >  	 * which means L1 attempted VMEntry to L2 with invalid state.
> > @@ -4152,6 +4158,12 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
> >  
> >  	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
> >  		vmcs12->guest_ia32_efer = vcpu->arch.efer;
> > +
> > +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
> 
> This is wrong, guest state is saved on VM-Exit if the control is _supported_,
> it doesn't have to be enabled.
> 
>   If the processor supports the 1-setting of the “load CET” VM-entry control,
>   the contents of the IA32_S_CET and IA32_INTERRUPT_SSP_TABLE_ADDR MSRs are
>   saved into the corresponding fields. On processors that do not support Intel
>   64 architecture, bits 63:32 of these MSRs are not saved.
> 
> And I'm pretty sure we should define these fields as a so called "rare" fields,
> i.e. add 'em to the case statement in is_vmcs12_ext_field() and process them in
> sync_vmcs02_to_vmcs12_rare().  CET isn't easily emulated, so they should almost
> never be read/written by a VMM, and thus aren't with synchronizing to vmcs12 on
> every exit.
Sure, will modifiy the patch accordingly.
> 
> > +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
> > +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
> > +	}
> >  }
> >  
> >  /*
> > -- 
> > 2.26.2
> > 
