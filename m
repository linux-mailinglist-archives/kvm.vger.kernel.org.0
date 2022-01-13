Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005FA48D26D
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 07:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiAMGqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 01:46:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:8337 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230033AbiAMGqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 01:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642056393; x=1673592393;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vSzexYw+aYDCl2P+VpHegt5l23c/Ezkw/q3HtZOpj7A=;
  b=hqUws/eTbF8wbhInmcJ2F1et/d1wXPSo+6HZdzzygFwk+AEjjpe7UCvT
   +g4hK9ullxV3Bn2o9I9I+BTnfQspeXxfchWruDGwQuUvUBDHwg0JyF8TG
   Q/UH/tGZBRrRLYVfxFBUWDTREiVXbrWnfiNqAUnOd/wGDIUuRahBmo5wB
   vWarXHrH6ztKFoT91RPcwu/OqFdddyKchT9rV27rLd8IQZd4e8yGtkmMG
   Avdrb3idshVweqDn10seEb/dvXsnPS1/G0LC/VVREkpN93JJzk8b1a8B5
   ihGoITnh0St7OfJ8DF79c2cBBti0BM34L6uf/kB8kUcqVtLytpHHd8P2p
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243738485"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="243738485"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 22:46:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="623755636"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.145.56])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 12 Jan 2022 22:46:30 -0800
Date:   Thu, 13 Jan 2022 14:31:17 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jun.nakajima@intel.com,
        kevin.tian@intel.com, jing2.liu@linux.intel.com,
        yang.zhong@intel.com
Subject: Re: [WARNING: UNSCANNABLE EXTRACTION FAILED][PATCH v2 1/3] selftest:
 kvm: Reorder vcpu_load_state steps for AMX
Message-ID: <20220113063117.GA14771@yangzhon-Virtual>
References: <20211222214731.2912361-1-yang.zhong@intel.com>
 <20211222214731.2912361-2-yang.zhong@intel.com>
 <Yd9CfnNhcQNGsUqA@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd9CfnNhcQNGsUqA@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Wed, Jan 12, 2022 at 09:05:02PM +0000, Sean Christopherson wrote:
> On Wed, Dec 22, 2021, Yang Zhong wrote:
> > From: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > For AMX support it is recommended to load XCR0 after XFD, so
> > that KVM does not see XFD=0, XCR=1 for a save state that will
> > eventually be disabled (which would lead to premature allocation
> > of the space required for that save state).
> 
> It would be very helpful to clarify that XFD is loaded via KVM_SET_MSRS.  It took
> me longer than it should have to understand what was going on.  The large amount of
> whitespace noise in this patch certainly didn't help.  E.g. just a simple tweak:
> 
>   For AMX support it is recommended to load XCR0 after XFD, i.e. after MSRs, so
> 

    Thanks, this is clearer.


> > It is also required to load XSAVE data after XCR0 and XFD, so
> > that KVM can trigger allocation of the extra space required to
> > store AMX state.
> > 
> > Adjust vcpu_load_state to obey these new requirements.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> > ---
> >  .../selftests/kvm/lib/x86_64/processor.c      | 29 ++++++++++---------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 00324d73c687..9b5abf488211 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -1192,9 +1192,14 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
> >  	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >  	int r;
> >  
> > -	r = ioctl(vcpu->fd, KVM_SET_XSAVE, &state->xsave);
> > -        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
> > -                r);
> > +	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
> > +	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
> > +		r);
> 
> If we're going to bother replacing spaces with tabs, might as well get rid of all
> the gratuituous newlines as well.
> 
> > +
> > +	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
> > +	TEST_ASSERT(r == state->msrs.nmsrs,
> > +		"Unexpected result from KVM_SET_MSRS,r: %i (failed at %x)",
> > +		r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
> 
> Most people not named "Paolo" prefer to align this with the opening "(" :-)
> 
> E.g.
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 97f8c2f2df36..971f41afa689 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1158,44 +1158,36 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
>         int r;
> 
>         r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
> -       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
> -               r);
> +       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i", r);
> 
>         r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
>         TEST_ASSERT(r == state->msrs.nmsrs,
> -               "Unexpected result from KVM_SET_MSRS,r: %i (failed at %x)",
> -               r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
> +                   "Unexpected result from KVM_SET_MSRS,r: %i (failed at %x)",
> +                   r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
> 
>         if (kvm_check_cap(KVM_CAP_XCRS)) {
>                 r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
> -               TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
> -                           r);
> +               TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i", r);
>         }
> 
>         r = ioctl(vcpu->fd, KVM_SET_XSAVE, &state->xsave);
> -       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
> -               r);
> +       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i", r);
> 
>         r = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, &state->events);
> -       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
> -               r);
> +       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i", r);
> 
>         r = ioctl(vcpu->fd, KVM_SET_MP_STATE, &state->mp_state);
> -        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i",
> -                r);
> +        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i", r);
> 
>         r = ioctl(vcpu->fd, KVM_SET_DEBUGREGS, &state->debugregs);
> -        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_DEBUGREGS, r: %i",
> -                r);
> +        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_DEBUGREGS, r: %i", r);
> 
>         r = ioctl(vcpu->fd, KVM_SET_REGS, &state->regs);
> -       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i",
> -               r);
> +       TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i", r);
> 
>         if (state->nested.size) {
>                 r = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, &state->nested);
> -               TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_NESTED_STATE, r: %i",
> -                       r);
> +               TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_NESTED_STATE, r: %i", r);
>         }
>  }

   Thanks for pointing out those issues.
   In fact, space issues are not only in this function, if we need handle those, we had better
   cleanup all those space issues. 
   Since this series has been merged into KVM-Next, we can submit one patch to handle those space 
   issue in the new 5.17-rcx release. thanks!

   Yang
