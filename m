Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C308137CDF
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 20:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfFFS53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 14:57:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:34039 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFFS52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 14:57:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 11:57:28 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2019 11:57:27 -0700
Date:   Thu, 6 Jun 2019 11:57:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 06/15] KVM: nVMX: Don't "put" vCPU or host state when
 switching VMCS
Message-ID: <20190606185727.GK23169@linux.intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-7-sean.j.christopherson@intel.com>
 <79ac3a1c-8386-3f5a-2abd-eb284407abb7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79ac3a1c-8386-3f5a-2abd-eb284407abb7@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 06:24:43PM +0200, Paolo Bonzini wrote:
> On 07/05/19 18:06, Sean Christopherson wrote:
> > When switching between vmcs01 and vmcs02, KVM isn't actually switching
> > between guest and host.  If guest state is already loaded (the likely,
> > if not guaranteed, case), keep the guest state loaded and manually swap
> > the loaded_cpu_state pointer after propagating saved host state to the
> > new vmcs0{1,2}.
> > 
> > Avoiding the switch between guest and host reduces the latency of
> > switching between vmcs01 and vmcs02 by several hundred cycles, and
> > reduces the roundtrip time of a nested VM by upwards of 1000 cycles.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 18 +++++++++++++-
> >  arch/x86/kvm/vmx/vmx.c    | 52 ++++++++++++++++++++++-----------------
> >  arch/x86/kvm/vmx/vmx.h    |  3 ++-
> >  3 files changed, 48 insertions(+), 25 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index a30d53823b2e..4651d3462df4 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -241,15 +241,31 @@ static void free_nested(struct kvm_vcpu *vcpu)
> >  static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +	struct vmcs_host_state *src;
> > +	struct loaded_vmcs *prev;
> >  	int cpu;
> >  
> >  	if (vmx->loaded_vmcs == vmcs)
> >  		return;
> >  
> >  	cpu = get_cpu();
> > -	vmx_vcpu_put(vcpu);
> > +	prev = vmx->loaded_cpu_state;
> >  	vmx->loaded_vmcs = vmcs;
> >  	vmx_vcpu_load(vcpu, cpu);
> > +
> > +	if (likely(prev)) {
> > +		src = &prev->host_state;
> > +
> > +		vmx_set_host_fs_gs(&vmcs->host_state, src->fs_sel, src->gs_sel,
> > +				   src->fs_base, src->gs_base);
> > +
> > +		vmcs->host_state.ldt_sel = src->ldt_sel;
> > +#ifdef CONFIG_X86_64
> > +		vmcs->host_state.ds_sel = src->ds_sel;
> > +		vmcs->host_state.es_sel = src->es_sel;
> > +#endif
> > +		vmx->loaded_cpu_state = vmcs;
> > +	}
> >  	put_cpu();
> 
> I'd like to extract this into a separate function:
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 438fae1fef2a..83e436f201bf 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -248,34 +248,40 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  	free_loaded_vmcs(&vmx->nested.vmcs02);
>  }
>  
> +static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx)

What about taking the vmcs pointers, and using old/new instead of
prev/cur?  Calling it prev is wonky since it's pulled from the current
value of loaded_cpu_state, especially since cur is the same type.
That oddity is also why I grabbed prev before setting loaded_vmcs,
it just felt wrong even though they really are two separate things.

static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
				     struct loaded_vmcs *old,
				     struct loaded_vmcs *new)
{
	...
}


{
	vmx_sync_vmcs_host_state(vmx, vmx->loaded_cpu_state, vmcs);
}

> +{
> +	struct loaded_vmcs *prev = vmx->loaded_cpu_state;
> +	struct loaded_vmcs *cur;
> +	struct vmcs_host_state *dest, *src;
> +
> +	if (unlikely(!prev))
> +		return;
> +
> +	cur = &vmx->loaded_vmcs;
> +	src = &prev->host_state;
> +	dest = &cur->host_state;
> +
> +	vmx_set_host_fs_gs(dest, src->fs_sel, src->gs_sel, src->fs_base, src->gs_base);
> +	dest->ldt_sel = src->ldt_sel;
> +#ifdef CONFIG_X86_64
> +	dest->ds_sel = src->ds_sel;
> +	dest->es_sel = src->es_sel;
> +#endif
> +	vmx->loaded_cpu_state = cur;
> +}
> +
>  static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	struct vmcs_host_state *src;
> -	struct loaded_vmcs *prev;
>  	int cpu;
>  
>  	if (vmx->loaded_vmcs == vmcs)
>  		return;
>  
>  	cpu = get_cpu();
> -	prev = vmx->loaded_cpu_state;
>  	vmx->loaded_vmcs = vmcs;
>  	vmx_vcpu_load(vcpu, cpu);
> -
> -	if (likely(prev)) {
> -		src = &prev->host_state;
> -
> -		vmx_set_host_fs_gs(&vmcs->host_state, src->fs_sel, src->gs_sel,
> -				   src->fs_base, src->gs_base);
> -
> -		vmcs->host_state.ldt_sel = src->ldt_sel;
> -#ifdef CONFIG_X86_64
> -		vmcs->host_state.ds_sel = src->ds_sel;
> -		vmcs->host_state.es_sel = src->es_sel;
> -#endif
> -		vmx->loaded_cpu_state = vmcs;
> -	}
> +	vmx_sync_vmcs_host_state(vmx);
>  	put_cpu();
>  
>  	vm_entry_controls_reset_shadow(vmx);
> 
> Paolo
