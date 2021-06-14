Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2852E3A5F6A
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 11:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhFNJxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 05:53:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232776AbhFNJxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 05:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623664270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pkbuA5hf8p6fEJiSHAXuHkzswzV57iOl5tZWDJ1RMuQ=;
        b=BvGa2m+9TkD8iE9BJagPLEsncCFsYpOHjBvaqhfj3bXUVRycdIfASUmmpdtUT2AQkIgK5F
        es8Hqzc/UZk9Ioa3AO6eBvjDjKjdKJ/w8GrBhjLG+QlB6itqdcMtyrwQD9fFPSF8Y9krOJ
        1Z9x/kW6ceyTPBAk+bB0VS2xglKYR5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-LuLRukLhPFesTH-wtx8tTw-1; Mon, 14 Jun 2021 05:51:07 -0400
X-MC-Unique: LuLRukLhPFesTH-wtx8tTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 397BB192296B;
        Mon, 14 Jun 2021 09:51:06 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D381560938;
        Mon, 14 Jun 2021 09:51:03 +0000 (UTC)
Message-ID: <d175c6ee68f357280166464bbacf6a468c3d9a74.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM: x86: hyper-v: Conditionally allow SynIC
 with APICv/AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 14 Jun 2021 12:51:02 +0300
In-Reply-To: <87zgvsx5b1.fsf@vitty.brq.redhat.com>
References: <20210609150911.1471882-1-vkuznets@redhat.com>
         <f294faba4e5d25aba8773f36170d1309236edd3b.camel@redhat.com>
         <87zgvsx5b1.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-14 at 09:40 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Wed, 2021-06-09 at 17:09 +0200, Vitaly Kuznetsov wrote:
> > > Changes since v2:
> > > - First two patches got merged, rebase.
> > > - Use 'enable_apicv = avic = ...' in PATCH1 [Paolo]
> > > - Collect R-b tags for PATCH2 [Sean, Max]
> > > - Use hv_apicv_update_work() to get out of SRCU lock [Max]
> > > - "KVM: x86: Check for pending interrupts when APICv is getting disabled"
> > >   added.
> > > 
> > > Original description:
> > > 
> > > APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> > > SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> > > however, possible to track whether the feature was actually used by the
> > > guest and only inhibit APICv/AVIC when needed.
> > > 
> > > The series can be tested with the followin hack:
> > > 
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 9a48f138832d..65a9974f80d9 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -147,6 +147,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> > >                                            vcpu->arch.ia32_misc_enable_msr &
> > >                                            MSR_IA32_MISC_ENABLE_MWAIT);
> > >         }
> > > +
> > > +       /* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be merged! */
> > > +       best = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
> > > +       if (best) {
> > > +               best->eax &= ~HV_X64_APIC_ACCESS_RECOMMENDED;
> > > +               best->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
> > > +       }
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
> > >  
> > > Vitaly Kuznetsov (4):
> > >   KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
> > >   KVM: x86: Drop vendor specific functions for APICv/AVIC enablement
> > >   KVM: x86: Check for pending interrupts when APICv is getting disabled
> > >   KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
> > >     use
> > > 
> > >  arch/x86/include/asm/kvm_host.h |  9 +++++-
> > >  arch/x86/kvm/hyperv.c           | 51 +++++++++++++++++++++++++++++----
> > >  arch/x86/kvm/svm/avic.c         | 14 ++++-----
> > >  arch/x86/kvm/svm/svm.c          | 22 ++++++++------
> > >  arch/x86/kvm/svm/svm.h          |  2 --
> > >  arch/x86/kvm/vmx/capabilities.h |  1 -
> > >  arch/x86/kvm/vmx/vmx.c          |  2 --
> > >  arch/x86/kvm/x86.c              | 18 ++++++++++--
> > >  8 files changed, 86 insertions(+), 33 deletions(-)
> > > 
> > 
> > Hi!
> > 
> > I hate to say it, but at least one of my VMs doesn't boot amymore
> > with avic=1, after the recent updates. I'll bisect this soon,
> > but this is likely related to this series.
> > 
> > I will also review this series very soon.
> > 
> > When the VM fails, it hangs on the OVMF screen and I see this
> > in qemu logs:
> > 
> > KVM: injection failed, MSI lost (Operation not permitted)
> > KVM: injection failed, MSI lost (Operation not permitted)
> > KVM: injection failed, MSI lost (Operation not permitted)
> > KVM: injection failed, MSI lost (Operation not permitted)
> > KVM: injection failed, MSI lost (Operation not permitted)
> > KVM: injection failed, MSI lost (Operation not permitted)
> > 
> 
> -EPERM?? Interesting... strace(1) may come handy...


Hi Vitaly!
 
I spent all yesterday debugging this and I found out what is going on:
(spoiler alert: hacks are bad)

The call to kvm_request_apicv_update was moved to a delayed work which is fine at first glance 
but turns out that we both don't notice that kvm doesn't allow to update the guest
memory map from non vcpu thread which is what kvm_request_apicv_update does
on AVIC.
 
The memslot update is to switch between regular r/w mapped dummy page
which is not really used but doesn't hurt to be there, and between paging entry with
reserved bits, used for MMIO, which AVIC sadly needs because it is written in the
spec that AVIC's MMIO despite being redirected to the avic_vapic_bar, still needs a valid
R/W mapping in the NPT, whose physical address is ignored.

So, in avic_update_access_page we have this nice hack:
 
if ((kvm->arch.apic_access_page_done == activate) ||
	    (kvm->mm != current->mm))
		goto out;
 
So instead of crashing this function just does nothing.
So AVIC MMIO is still mapped R/W to a dummy page, but the AVIC itself
is disabled on all vCPUs by kvm_request_apicv_update (with 
KVM_REQ_APICV_UPDATE request)

So now all guest APIC writes just disappear to that dummy
page, and we have a guest that seems to run but can't really
continue. 

The -EPERM in the error message I reported, is just -1, returned by 
KVM_SIGNAL_MSI which is likely result of gross missmatch between
state of the KVM's APIC registers and that dummy page which contains
whatever the guest wrote there and what the guest thinks
the APIC registers are.

I am curently thinking on how to do the whole thing with
KVM's requests, I'll try to prepare a patch today.
 
Best regards,
	Maxim Levitsky

> 
> $ git grep EPERM kvm/queue arch/x86/kvm/ 
> kvm/queue:arch/x86/kvm/x86.c:           ret = -KVM_EPERM;
> (just this one)
> 
> kvm_emulate_hypercall():
> ...
> b3646477d458f arch/x86/kvm/x86.c (Jason Baron                2021-01-14 22:27:56 -0500  8433)   if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
> 07708c4af1346 arch/x86/kvm/x86.c (Jan Kiszka                 2009-08-03 18:43:28 +0200  8434)           ret = -KVM_EPERM;
> 696ca779a928d arch/x86/kvm/x86.c (Radim Krčmář               2018-05-24 17:50:56 +0200  8435)           goto out;
> 07708c4af1346 arch/x86/kvm/x86.c (Jan Kiszka                 2009-08-03 18:43:28 +0200  8436)   }
> ...
> 
> Doesn't seem we have any updates here, curious what your bisection will
> point us to.
> 


