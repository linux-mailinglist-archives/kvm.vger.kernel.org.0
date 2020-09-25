Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDB5278F93
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgIYRZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 13:25:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:56940 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgIYRZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 13:25:41 -0400
IronPort-SDR: l1s3r0WbxLYtXok1tXsAkk5l77ri6PGiu6v87JN3ELxhOm0gEePkb7rVTvwWnBIaOEREeM4NVS
 SeF+sGjrFlkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="141004363"
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="141004363"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 10:12:35 -0700
IronPort-SDR: cpapzdKeorbGJAJcicHTqvjLBQC0HcUDOXmfyns5mrzobWjC3ddmjR9HRB2DUcOw18nqoDh4KK
 uLzfmR0kQukQ==
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="336814163"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 10:12:35 -0700
Date:   Fri, 25 Sep 2020 10:12:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs
 that are fatal to the VM
Message-ID: <20200925171233.GC31528@linux.intel.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
 <20200923224530.17735-4-sean.j.christopherson@intel.com>
 <878scze4l5.fsf@vitty.brq.redhat.com>
 <20200924181134.GB9649@linux.intel.com>
 <87k0wichht.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0wichht.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 11:50:38AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Thu, Sep 24, 2020 at 02:34:14PM +0200, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> > index 6f9a0c6d5dc5..810d46ab0a47 100644
> >> > --- a/arch/x86/kvm/vmx/vmx.c
> >> > +++ b/arch/x86/kvm/vmx/vmx.c
> >> > @@ -4985,14 +4986,13 @@ static int handle_cr(struct kvm_vcpu *vcpu)
> >> >  		}
> >> >  		break;
> >> >  	case 2: /* clts */
> >> > -		WARN_ONCE(1, "Guest should always own CR0.TS");
> >> > -		vmx_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
> >> > -		trace_kvm_cr_write(0, kvm_read_cr0(vcpu));
> >> > -		return kvm_skip_emulated_instruction(vcpu);
> >> > +		KVM_BUG(1, vcpu->kvm, "Guest always owns CR0.TS");
> >> > +		return -EIO;
> >> >  	case 1: /*mov from cr*/
> >> >  		switch (cr) {
> >> >  		case 3:
> >> >  			WARN_ON_ONCE(enable_unrestricted_guest);
> >> > +
> >> 
> >> Here, were you intended to replace WARN_ON_ONCE() with KVM_BUG_ON() or
> >> this is just a stray newline added?
> >
> > I think it's just a stray newline.  At one point I had converted this to a
> > KVM_BUG_ON(), but then reversed direction because it's not fatal to the guest,
> > i.e. KVM should continue to function even though it's spuriously intercepting
> > CR3 loads.
> >
> > Which, rereading this patch, completely contradicts the KVM_BUG() for CLTS.
> >
> > That's probably something we should sort out in this RFC: is KVM_BUG() only
> > to be used if the bug is fatal/dangerous, or should it be used any time the
> > error is definitely a KVM (or hardware) bug.
> 
> Personally, I'm feeling adventurous so my vote goes to the later :-)
> Whenever a KVM bug was discovered by a VM it's much safer to stop
> executing it as who knows what the implications might be?

Not necessarily, e.g. terminating the VM may corrupt the VM's file system,
which is less safe, for lack of a better word, from the VM's perspective.

> In this particular case I can think of a nested scenario when L1 didn't
> ask for CR3 intercept but L0 is still injecting it. It is not fatal by
> itself but probably there is bug in calculating intercepts in L0 so
> if we're getting something extra maybe we're also missing some? And this
> doesn't sound good at all.

Hmm, but by that argument this scenario would fall into the "dangerous" part
of "bug is fatal/dangerous".  I guess my opinion is that we should set a
fairly high bar for using KVM_BUG() so that KVM can be aggressive in shutting
down.

> > In theory, it should be impossible to reach this again as "r = -EIO" will
> > bounce this out to userspace, the common checks to deny all ioctls() will
> > prevent reinvoking KVM_RUN.
> 
> Do we actually want to prevent *all* ioctls? E.g. when 'vm bugged'
> condition is triggered userspace may want to extract some information to
> assist debugging but even things like KVM_GET_[S]REGS will just return
> -EIO. I'm not sure it is generally safe to enable *everything* (except
> for KVM_RUN which should definitely be forbidden) so maybe your approach
> is preferable.

The answer to this probably depends on the answer to the first question of
when it's appropriate to use KVM_BUG().  E.g. if we limit usage to fatal or
dangrous cases, then blocking all ioctls() is probably the right thing do do.
