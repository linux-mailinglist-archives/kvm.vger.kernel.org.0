Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73221E3CAA
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388234AbgE0IwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:52:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:8402 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388070AbgE0IwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:52:14 -0400
IronPort-SDR: nSAUr2I8YR2pNQ161YXOcfaZO9jMc7IXHbF1FJ27YGZuJIqAXheMPDba4dc5yahZzAKnOlYqyL
 bnH3DJjxLm5Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 01:52:14 -0700
IronPort-SDR: iEFBK9hw43SNyYE55/qG1GyBCco/ur0BvGwY2RTz4cHM3tJcOd6sfeM9yd3g9AojAeW0S1+lph
 ri5MUuys8bRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="414132602"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 27 May 2020 01:52:14 -0700
Date:   Wed, 27 May 2020 01:52:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 02/16] x86/kvm: Introduce KVM memory protection feature
Message-ID: <20200527085214.GP31696@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-3-kirill.shutemov@linux.intel.com>
 <87d06s83is.fsf@vitty.brq.redhat.com>
 <20200525151525.qmfvzxbl7sq46cdq@box>
 <20200527050350.GK31696@linux.intel.com>
 <87eer56abe.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eer56abe.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 27, 2020 at 10:39:33AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Mon, May 25, 2020 at 06:15:25PM +0300, Kirill A. Shutemov wrote:
> >> On Mon, May 25, 2020 at 04:58:51PM +0200, Vitaly Kuznetsov wrote:
> >> > > @@ -727,6 +734,15 @@ static void __init kvm_init_platform(void)
> >> > >  {
> >> > >  	kvmclock_init();
> >> > >  	x86_platform.apic_post_init = kvm_apic_init;
> >> > > +
> >> > > +	if (kvm_para_has_feature(KVM_FEATURE_MEM_PROTECTED)) {
> >> > > +		if (kvm_hypercall0(KVM_HC_ENABLE_MEM_PROTECTED)) {
> >> > > +			pr_err("Failed to enable KVM memory protection\n");
> >> > > +			return;
> >> > > +		}
> >> > > +
> >> > > +		mem_protected = true;
> >> > > +	}
> >> > >  }
> >> > 
> >> > Personally, I'd prefer to do this via setting a bit in a KVM-specific
> >> > MSR instead. The benefit is that the guest doesn't need to remember if
> >> > it enabled the feature or not, it can always read the config msr. May
> >> > come handy for e.g. kexec/kdump.
> >> 
> >> I think we would need to remember it anyway. Accessing MSR is somewhat
> >> expensive. But, okay, I can rework it MSR if needed.
> >
> > I think Vitaly is talking about the case where the kernel can't easily get
> > at its cached state, e.g. after booting into a new kernel.  The kernel would
> > still have an X86_FEATURE bit or whatever, providing a virtual MSR would be
> > purely for rare slow paths.
> >
> > That being said, a hypercall plus CPUID bit might be better, e.g. that'd
> > allow the guest to query the state without risking a #GP.
> 
> We have rdmsr_safe() for that! :-) MSR (and hypercall to that matter)
> should have an associated CPUID feature bit of course.

rdmsr_safe() won't fly in early boot, e.g. verify_cpu.  It probably doesn't
matter for late enabling, but it might save some headache if there's ever a
handoff from vBIOS.

> Yes, hypercall + CPUID would do but normally we treat CPUID data as
> static and in this case we'll make it a dynamically flipping

There are multiple examples of dynamic CPUID, e.g. MWAIT and OSPKE.

> bit. Especially if we introduce 'KVM_HC_DISABLE_MEM_PROTECTED' later.
> 
> >
> >> Note, that we can avoid the enabling algother, if we modify BIOS to deal
> >> with private/shared memory. Currently BIOS get system crash if we enable
> >> the feature from time zero.
> >
> > Which would mesh better with a CPUID feature bit.
> >
> 
> And maybe even help us to resolve 'reboot' problem.
> 
> -- 
> Vitaly
> 
