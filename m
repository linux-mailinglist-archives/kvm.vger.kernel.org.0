Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE7418E239
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCUOzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 10:55:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:39819 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgCUOzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 10:55:53 -0400
IronPort-SDR: M3x1jC4RDmGQX9zT4cDwovUr31yxNFwg4lqVpumyQTHUCTKrvL7ZCT9Q+i7WG02p4SV23EVfSm
 VLoy3Vx+n3iA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 07:55:52 -0700
IronPort-SDR: H7Fx5e3vGBOWvo9sSEFuouY7EMYSDdq5LAAbqIYuuwRubmj2u3R4jrnGqeobrgu3RyPQdPGO14
 9ryOAT075zzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,288,1580803200"; 
   d="scan'208";a="446950933"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 21 Mar 2020 07:55:51 -0700
Date:   Sat, 21 Mar 2020 07:55:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: VMX: Always VMCLEAR in-use VMCSes during crash
 with kexec support
Message-ID: <20200321145551.GA12329@linux.intel.com>
References: <20200227223047.13125-1-sean.j.christopherson@intel.com>
 <20200227223047.13125-2-sean.j.christopherson@intel.com>
 <9edc8cef-9aa4-11ca-f8f2-a1fea990b87e@redhat.com>
 <20200228145942.GA2329@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228145942.GA2329@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 06:59:43AM -0800, Sean Christopherson wrote:
> On Fri, Feb 28, 2020 at 11:16:10AM +0100, Paolo Bonzini wrote:
> > On 27/02/20 23:30, Sean Christopherson wrote:
> > > -void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
> > > +void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
> > >  {
> > >  	vmcs_clear(loaded_vmcs->vmcs);
> > >  	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
> > >  		vmcs_clear(loaded_vmcs->shadow_vmcs);
> > > +
> > > +	if (in_use) {
> > > +		list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
> > > +
> > > +		/*
> > > +		 * Ensure deleting loaded_vmcs from its current percpu list
> > > +		 * completes before setting loaded_vmcs->vcpu to -1, otherwise
> > > +		 * a different cpu can see vcpu == -1 first and add loaded_vmcs
> > > +		 * to its percpu list before it's deleted from this cpu's list.
> > > +		 * Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> > > +		 */
> > > +		smp_wmb();
> > > +	}
> > > +
> > 
> > I'd like to avoid the new in_use argument and, also, I think it's a
> > little bit nicer to always invoke the memory barrier.  Even though we 
> > use "asm volatile" for vmclear and therefore the compiler is already 
> > taken care of, in principle it's more correct to order the ->cpu write 
> > against vmclear's.
> 
> Completely agree on all points.  I wanted to avoid in_use as well, but it
> didn't occur to me to use list_empty()...
> 
> > This gives the following patch on top:
> 
> Looks good.
> 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index c9d6152e7a4d..77a64110577b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -656,25 +656,24 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr,
> >  	return ret;
> >  }
> >  
> > -void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
> > +void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
> >  {
> >  	vmcs_clear(loaded_vmcs->vmcs);
> >  	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
> >  		vmcs_clear(loaded_vmcs->shadow_vmcs);
> >  
> > -	if (in_use) {
> > +	if (!list_empty(&loaded_vmcs->loaded_vmcss_on_cpu_link))

Circling back to this, an even better option is to drop loaded_vmcs_init()
and open code the required pieces in __loaded_vmcs_clear() and
alloc_loaded_vmcs().  Those are the only two callers, and the latter
doesn't need to VMCLEAR the shadow VMCS (guaranteed to be NULL) and
obviously doesn't need the list manipulation of smp_wmb().
