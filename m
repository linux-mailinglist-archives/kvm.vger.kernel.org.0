Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B7342A16B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 11:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhJLJzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 05:55:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232891AbhJLJzP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 05:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634032393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b6zpFaoEk3AK/+KJak32kXjy2MJ6L7r5CQXtJQyHUkY=;
        b=Lo4RYWAuMv4rzX4M8V/Cud1nrOTsKVlA4Esc+sJACzLbht42noga/mbD8EEBiSfSvwTPjW
        6J794qtaMCl2lr6hANujU6D/HPFgzmpIqdZXiu+4/lReHXoq1yNjmwPobm5+SdHinmDdD1
        PLcBQLzxLLGmcp45Xd3z0sA+cda5Gq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-hsjvK7tAPIKhII0yFQdp_w-1; Tue, 12 Oct 2021 05:53:10 -0400
X-MC-Unique: hsjvK7tAPIKhII0yFQdp_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 067E979EDC;
        Tue, 12 Oct 2021 09:53:09 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB7E9717C0;
        Tue, 12 Oct 2021 09:53:06 +0000 (UTC)
Message-ID: <ebf038b7b242dd19aba1e4adb6f4ef2701c53748.camel@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix and cleanup for recent AVIC changes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 12 Oct 2021 12:53:05 +0300
In-Reply-To: <YWRtHmAUaKcbWEzH@google.com>
References: <20211009010135.4031460-1-seanjc@google.com>
         <9e9e91149ab4fa114543b69eaf493f84d2f33ce2.camel@redhat.com>
         <YWRJwZF1toUuyBdC@google.com> <YWRtHmAUaKcbWEzH@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-11 at 16:58 +0000, Sean Christopherson wrote:
> On Mon, Oct 11, 2021, Sean Christopherson wrote:
> > On Sun, Oct 10, 2021, Maxim Levitsky wrote:
> > > On Fri, 2021-10-08 at 18:01 -0700, Sean Christopherson wrote:
> > > > Belated "code review" for Maxim's recent series to rework the AVIC inhibit
> > > > code.  Using the global APICv status in the page fault path is wrong as
> > > > the correct status is always the vCPU's, since that status is accurate
> > > > with respect to the time of the page fault.  In a similar vein, the code
> > > > to change the inhibit can be cleaned up since KVM can't rely on ordering
> > > > between the update and the request for anything except consumers of the
> > > > request.
> > > > 
> > > > Sean Christopherson (2):
> > > >   KVM: x86/mmu: Use vCPU's APICv status when handling APIC_ACCESS
> > > >     memslot
> > > >   KVM: x86: Simplify APICv update request logic
> > > > 
> > > >  arch/x86/kvm/mmu/mmu.c |  2 +-
> > > >  arch/x86/kvm/x86.c     | 16 +++++++---------
> > > >  2 files changed, 8 insertions(+), 10 deletions(-)
> > > > 
> > > 
> > > Are you sure about it? Let me explain how the algorithm works:
> > > 
> > > - kvm_request_apicv_update:
> > > 
> > > 	- take kvm->arch.apicv_update_lock
> > > 
> > > 	- if inhibition state doesn't really change (kvm->arch.apicv_inhibit_reasons still zero or non zero)
> > > 		- update kvm->arch.apicv_inhibit_reasons
> > > 		- release the lock
> > > 
> > > 	- raise KVM_REQ_APICV_UPDATE
> > > 		* since kvm->arch.apicv_update_lock is taken, all vCPUs will be
> > > 		kicked out of guest mode and will be either doing someing in
> > > 		the KVM (like page fault) or stuck on trying to process that
> > > 		request the important thing is that no vCPU will be able to get
> > > 		back to the guest mode.
> > > 
> > > 	- update the kvm->arch.apicv_inhibit_reasons
> > > 		* since we hold vm->arch.apicv_update_lock vcpus can't see the new value
> > 
> > This assertion is incorrect, kvm_apicv_activated() is not guarded by the lock.
> > 
> > > 	- update the SPTE that covers the APIC's mmio window:
> > 
> > This won't affect in-flight page faults.
> > 
> > 
> >    vCPU0                               vCPU1
> >    =====                               =====
> >    Disabled APICv
> >    #NPT                                Acquire apicv_update_lock
> >                                        Re-enable APICv
> >    kvm_apicv_activated() == false
> 
> Doh, that's supposed to be "true".
> 
> >    incorrectly handle as regular MMIO
> >                                        zap APIC pages
> >    MMIO cache has bad entry
> 
> Argh, I forgot the memslot is still there, so the access won't be treated as MMIO
> and thus won't end up in the MMIO cache.
> 
> So I agree that the code is functionally ok, but I'd still prefer to switch to
> kvm_vcpu_apicv_active() so that this code is coherent with respect to the APICv
> status at the time the fault occurred.
> 
> My objection to using kvm_apicv_activated() is that the result is completely
> non-deterministic with respect to the vCPU's APICv status at the time of the
> fault.  It works because all of the other mechanisms that are in place, e.g.
> elevating the MMU notifier count, but the fact that the result is non-deterministic
> means that using the per-vCPU status is also functionally ok.

The problem is that it is just not correct to use local AVIC enable state 
to determine if we want to populate the SPTE or or just jump to the emulation.


For example, assuming that the AVIC is now enabled on all vCPUs,
we can have this scenario:

    vCPU0                                   vCPU1
    =====                                   =====

- disable AVIC
- VMRUN
                                        - #NPT on AVIC MMIO access
                                        - *stuck on something prior to the page fault code*
- enable AVIC
- VMRUN
                                        - *still stuck on something prior to the page fault code*

- disable AVIC:

  - raise KVM_REQ_APICV_UPDATE request
					
  - set global avic state to disable

  - zap the SPTE (does nothing, doesn't race
	with anything either)

  - handle KVM_REQ_APICV_UPDATE -
    - disable vCPU0 AVIC

- VMRUN
					- *still stuck on something prior to the page fault code*

                                                            ...
                                                            ...
                                                            ...

                                        - now vCPU1 finally starts running the page fault code.

                                        - vCPU1 AVIC is still enabled 
                                          (because vCPU1 never handled KVM_REQ_APICV_UPDATE),
                                          so the page fault code will populate the SPTE.
                                          

                                        - handle KVM_REQ_APICV_UPDATE
                                           - finally disable vCPU1 AVIC

                                        - VMRUN (vCPU1 AVIC disabled, SPTE populated)

					                 ***boom***



> 
> At a minimum, I'd like to add a blurb in the kvm_faultin_pfn() comment to call out
> the reliance on mmu_notifier_seq.

This is a very good idea!


> 
> E.g. if kvm_zap_gfn_range() wins the race to acquire mmu_lock() after APICv is
> inhibited/disabled by __kvm_request_apicv_update(), then direct_page_fault() will
> retry the fault due to the change in mmu_notifier_seq.  If direct_page_fault()
> wins the race, then kvm_zap_gfn_range() will zap the freshly-installed SPTEs.
> For the uninhibit/enable case, at worst KVM will emulate an access that could have
> been accelerated by retrying the instruction.

Yes, 100% agree. 

The thing was super tricky to implement to avoid races that happen otherwise
this way or another.



Best regards,
	Maxim Levitsky

> 




