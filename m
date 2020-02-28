Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6D173A81
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 15:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgB1O7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 09:59:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:36391 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgB1O7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 09:59:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 06:59:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,496,1574150400"; 
   d="scan'208";a="437437616"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 28 Feb 2020 06:59:43 -0800
Date:   Fri, 28 Feb 2020 06:59:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: VMX: Always VMCLEAR in-use VMCSes during crash
 with kexec support
Message-ID: <20200228145942.GA2329@linux.intel.com>
References: <20200227223047.13125-1-sean.j.christopherson@intel.com>
 <20200227223047.13125-2-sean.j.christopherson@intel.com>
 <9edc8cef-9aa4-11ca-f8f2-a1fea990b87e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9edc8cef-9aa4-11ca-f8f2-a1fea990b87e@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 11:16:10AM +0100, Paolo Bonzini wrote:
> On 27/02/20 23:30, Sean Christopherson wrote:
> > -void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
> > +void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
> >  {
> >  	vmcs_clear(loaded_vmcs->vmcs);
> >  	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
> >  		vmcs_clear(loaded_vmcs->shadow_vmcs);
> > +
> > +	if (in_use) {
> > +		list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
> > +
> > +		/*
> > +		 * Ensure deleting loaded_vmcs from its current percpu list
> > +		 * completes before setting loaded_vmcs->vcpu to -1, otherwise
> > +		 * a different cpu can see vcpu == -1 first and add loaded_vmcs
> > +		 * to its percpu list before it's deleted from this cpu's list.
> > +		 * Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> > +		 */
> > +		smp_wmb();
> > +	}
> > +
> 
> I'd like to avoid the new in_use argument and, also, I think it's a
> little bit nicer to always invoke the memory barrier.  Even though we 
> use "asm volatile" for vmclear and therefore the compiler is already 
> taken care of, in principle it's more correct to order the ->cpu write 
> against vmclear's.

Completely agree on all points.  I wanted to avoid in_use as well, but it
didn't occur to me to use list_empty()...

> This gives the following patch on top:

Looks good.

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c9d6152e7a4d..77a64110577b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -656,25 +656,24 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr,
>  	return ret;
>  }
>  
> -void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
> +void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
>  {
>  	vmcs_clear(loaded_vmcs->vmcs);
>  	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
>  		vmcs_clear(loaded_vmcs->shadow_vmcs);
>  
> -	if (in_use) {
> +	if (!list_empty(&loaded_vmcs->loaded_vmcss_on_cpu_link))
>  		list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
>  
> -		/*
> -		 * Ensure deleting loaded_vmcs from its current percpu list
> -		 * completes before setting loaded_vmcs->vcpu to -1, otherwise
> -		 * a different cpu can see vcpu == -1 first and add loaded_vmcs
> -		 * to its percpu list before it's deleted from this cpu's list.
> -		 * Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> -		 */
> -		smp_wmb();
> -	}
> -
> +	/*
> +	 * Ensure all writes to loaded_vmcs, including deleting it
> +	 * from its current percpu list, complete before setting
> +	 * loaded_vmcs->vcpu to -1; otherwise,, a different cpu can
> +	 * see vcpu == -1 first and add loaded_vmcs to its percpu
> +	 * list before it's deleted from this cpu's list.  Pairs
> +	 * with the smp_rmb() in vmx_vcpu_load_vmcs().
> +	 */
> +	smp_wmb();
>  	loaded_vmcs->cpu = -1;
>  	loaded_vmcs->launched = 0;
>  }
> @@ -701,7 +700,7 @@ static void __loaded_vmcs_clear(void *arg)
>  	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
>  		per_cpu(current_vmcs, cpu) = NULL;
>  
> -	loaded_vmcs_init(loaded_vmcs, true);
> +	loaded_vmcs_init(loaded_vmcs);
>  }
>  
>  void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
> @@ -2568,7 +2567,8 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>  
>  	loaded_vmcs->shadow_vmcs = NULL;
>  	loaded_vmcs->hv_timer_soft_disabled = false;
> -	loaded_vmcs_init(loaded_vmcs, false);
> +	INIT_LIST_HEAD(&loaded_vmcs->loaded_vmcss_on_cpu_link);
> +	loaded_vmcs_init(loaded_vmcs);
>  
>  	if (cpu_has_vmx_msr_bitmap()) {
>  		loaded_vmcs->msr_bitmap = (unsigned long *)
> 
> Paolo
> 
