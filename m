Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367B61B7974
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 17:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgDXPWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 11:22:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:12913 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgDXPWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 11:22:20 -0400
IronPort-SDR: gkmLLEDGFVXVA+Pyahqqvl++4ENjVxKYf7KYBaT+rc4us59sjbWqGQhul84TbuQkDYWuBfjuk0
 eH3FUQl7UpDw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 08:22:19 -0700
IronPort-SDR: lNZQXQ63t+XjMky3bU1cg+5d3JFTtZ1ZILO0XjPgq3c7HU32TVp1zDyK/1Hq4BIMeVbmnv0C20
 40vaoszU990w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="457375407"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2020 08:22:17 -0700
Date:   Fri, 24 Apr 2020 23:24:19 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 8/9] KVM: VMX: Enable CET support for nested VM
Message-ID: <20200424152419.GL24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-9-weijiang.yang@intel.com>
 <20200423182906.GL17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423182906.GL17824@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 11:29:06AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:45PM +0800, Yang Weijiang wrote:
> > CET MSRs pass through guests for performance consideration.
> > Configure the MSRs to match L0/L1 settings so that nested VM
> > is able to run with CET.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 41 +++++++++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/vmx/vmcs12.c |  6 ++++++
> >  arch/x86/kvm/vmx/vmcs12.h | 14 ++++++++++++-
> >  arch/x86/kvm/vmx/vmx.c    |  1 +
> >  4 files changed, 59 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index e47eb7c0fbae..a71ef33de55f 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -627,6 +627,41 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> >  	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
> >  					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> >  
> > +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
> > +	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_U_CET))
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_IA32_U_CET, MSR_TYPE_RW);
> > +
> > +	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PL3_SSP))
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> > +
> > +	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_S_CET))
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_IA32_S_CET, MSR_TYPE_RW);
> > +
> > +	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PL0_SSP))
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> > +
> > +	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PL1_SSP))
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> > +
> > +	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PL2_SSP))
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> > +
> > +	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_INT_SSP_TAB))
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
> 
> That's a lot of copy-paste.  Maybe add a helper to do the conditional l01
> check and subsequent call to nested_vmx_disable_intercept_for_msr()?  It's
> still a lot of boilerplate, but it's at least a little better.  Not sure
> what a good name would be.
> 
> 	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> 					    msr_bitmap_l1, msr_bitmap_l0,
> 					    MSR_TYPE_RW);
>
OK, I'll figure out how to make it nicer :-)

> 
> >  	/*
> >  	 * Checking the L0->L1 bitmap is trying to verify two things:
> >  	 *
> > @@ -6040,7 +6075,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
> >  	msrs->exit_ctls_high |=
> >  		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
> >  		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
> > -		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT;
> > +		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT |
> > +		VM_EXIT_LOAD_HOST_CET_STATE;
> >  
> >  	/* We support free control of debug control saving. */
> >  	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
> > @@ -6057,7 +6093,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
> >  #endif
> >  		VM_ENTRY_LOAD_IA32_PAT;
> >  	msrs->entry_ctls_high |=
> > -		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
> > +		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
> > +		 VM_ENTRY_LOAD_GUEST_CET_STATE);
> 
> This is wrong, the OR path is only for emulated stuff, I'm guessing you're
> not planning on emulating CET :-)
When I tested nested VM, if it's not "ORed" here, nested VM entry will
fail, so what's your suggestion on this?
> 
> And I think this needs to be conditional based on supported_xss?
Yes, a check is necessary.

>  
> >  	/* We support free control of debug control loading. */
> >  	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
> > diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> > index 53dfb401316d..82b82bebeee0 100644
> > --- a/arch/x86/kvm/vmx/vmcs12.c
> > +++ b/arch/x86/kvm/vmx/vmcs12.c
> > @@ -141,6 +141,9 @@ const unsigned short vmcs_field_to_offset_table[] = {
> >  	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
> >  	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
> >  	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
> > +	FIELD(GUEST_S_CET, guest_s_cet),
> > +	FIELD(GUEST_SSP, guest_ssp),
> > +	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
> >  	FIELD(HOST_CR0, host_cr0),
> >  	FIELD(HOST_CR3, host_cr3),
> >  	FIELD(HOST_CR4, host_cr4),
> > @@ -153,5 +156,8 @@ const unsigned short vmcs_field_to_offset_table[] = {
> >  	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
> >  	FIELD(HOST_RSP, host_rsp),
> >  	FIELD(HOST_RIP, host_rip),
> > +	FIELD(HOST_S_CET, host_s_cet),
> > +	FIELD(HOST_SSP, host_ssp),
> > +	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
> >  };
> >  const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs_field_to_offset_table);
> > diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> > index d0c6df373f67..62b7be68f05c 100644
> > --- a/arch/x86/kvm/vmx/vmcs12.h
> > +++ b/arch/x86/kvm/vmx/vmcs12.h
> > @@ -118,7 +118,13 @@ struct __packed vmcs12 {
> >  	natural_width host_ia32_sysenter_eip;
> >  	natural_width host_rsp;
> >  	natural_width host_rip;
> > -	natural_width paddingl[8]; /* room for future expansion */
> > +	natural_width host_s_cet;
> > +	natural_width host_ssp;
> > +	natural_width host_ssp_tbl;
> > +	natural_width guest_s_cet;
> > +	natural_width guest_ssp;
> > +	natural_width guest_ssp_tbl;
> > +	natural_width paddingl[2]; /* room for future expansion */
> 
> Tangetial topic, it'd be helpful if FIELD and FIELD64 had compile-time
> assertions similar to vmcs_read*() to verify the size of the vmcs12 field
> is correct.  In other words, I don't feel like reviewing all of these :-).
>
OK, let me figure out how to polish them...

> >  	u32 pin_based_vm_exec_control;
> >  	u32 cpu_based_vm_exec_control;
> >  	u32 exception_bitmap;
> > @@ -301,6 +307,12 @@ static inline void vmx_check_vmcs12_offsets(void)
> >  	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
> >  	CHECK_OFFSET(host_rsp, 664);
> >  	CHECK_OFFSET(host_rip, 672);
> > +	CHECK_OFFSET(host_s_cet, 680);
> > +	CHECK_OFFSET(host_ssp, 688);
> > +	CHECK_OFFSET(host_ssp_tbl, 696);
> > +	CHECK_OFFSET(guest_s_cet, 704);
> > +	CHECK_OFFSET(guest_ssp, 712);
> > +	CHECK_OFFSET(guest_ssp_tbl, 720);
> >  	CHECK_OFFSET(pin_based_vm_exec_control, 744);
> >  	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
> >  	CHECK_OFFSET(exception_bitmap, 752);
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index a3d01014b9e7..c2e950d378bd 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7153,6 +7153,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
> >  	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
> >  	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
> >  	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
> > +	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
> >  
> >  #undef cr4_fixed1_update
> >  }
> > -- 
> > 2.17.2
> > 
