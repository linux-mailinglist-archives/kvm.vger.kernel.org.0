Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370713F624D
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhHXQIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 12:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232422AbhHXQIw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 12:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629821288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bgk9XzjEnymSLljkfRe6ekVZlsiJF5vccXtnA6/Cgj4=;
        b=Ij59qkGduSAn+N95uoGsSYScG4AkrpwjT5OhW+lnh6IMOKSLlzm9CwVlli3ed3MlNzMqVK
        zFP6FooPOnpfTrPNFs4L4R1LGQIo3065KKT6/hYOP1sSq8efFdu0Y1k3a+XZvMpopeaq2x
        4YjPAZ2Scq2Dcw6ptgzeAgD62K+cvJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-ndveXrATM8u-_a8E1jtmnQ-1; Tue, 24 Aug 2021 12:08:06 -0400
X-MC-Unique: ndveXrATM8u-_a8E1jtmnQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F3FBC7403;
        Tue, 24 Aug 2021 16:08:05 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54B5C60C05;
        Tue, 24 Aug 2021 16:07:59 +0000 (UTC)
Message-ID: <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Date:   Tue, 24 Aug 2021 19:07:58 +0300
In-Reply-To: <87k0kakip9.fsf@vitty.brq.redhat.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
         <20210823143028.649818-5-vkuznets@redhat.com>
         <20210823185841.ov7ejn2thwebcwqk@habkost.net>
         <87mtp7jowv.fsf@vitty.brq.redhat.com>
         <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
         <87k0kakip9.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
> Eduardo Habkost <ehabkost@redhat.com> writes:
> 
> > On Tue, Aug 24, 2021 at 3:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > > Eduardo Habkost <ehabkost@redhat.com> writes:
> > > 
> > > > On Mon, Aug 23, 2021 at 04:30:28PM +0200, Vitaly Kuznetsov wrote:
> > > > > KASAN reports the following issue:
> > > > > 
> > > > >  BUG: KASAN: stack-out-of-bounds in kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> > > > >  Read of size 8 at addr ffffc9001364f638 by task qemu-kvm/4798
> > > > > 
> > > > >  CPU: 0 PID: 4798 Comm: qemu-kvm Tainted: G               X --------- ---
> > > > >  Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RYM0081C 07/13/2020
> > > > >  Call Trace:
> > > > >   dump_stack+0xa5/0xe6
> > > > >   print_address_description.constprop.0+0x18/0x130
> > > > >   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> > > > >   __kasan_report.cold+0x7f/0x114
> > > > >   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> > > > >   kasan_report+0x38/0x50
> > > > >   kasan_check_range+0xf5/0x1d0
> > > > >   kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> > > > >   kvm_make_scan_ioapic_request_mask+0x84/0xc0 [kvm]
> > > > >   ? kvm_arch_exit+0x110/0x110 [kvm]
> > > > >   ? sched_clock+0x5/0x10
> > > > >   ioapic_write_indirect+0x59f/0x9e0 [kvm]
> > > > >   ? static_obj+0xc0/0xc0
> > > > >   ? __lock_acquired+0x1d2/0x8c0
> > > > >   ? kvm_ioapic_eoi_inject_work+0x120/0x120 [kvm]
> > > > > 
> > > > > The problem appears to be that 'vcpu_bitmap' is allocated as a single long
> > > > > on stack and it should really be KVM_MAX_VCPUS long. We also seem to clear
> > > > > the lower 16 bits of it with bitmap_zero() for no particular reason (my
> > > > > guess would be that 'bitmap' and 'vcpu_bitmap' variables in
> > > > > kvm_bitmap_or_dest_vcpus() caused the confusion: while the later is indeed
> > > > > 16-bit long, the later should accommodate all possible vCPUs).
> > > > > 
> > > > > Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
> > > > > Fixes: 9a2ae9f6b6bb ("KVM: x86: Zero the IOAPIC scan request dest vCPUs bitmap")
> > > > > Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > > > ---
> > > > >  arch/x86/kvm/ioapic.c | 10 +++++-----
> > > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> > > > > index ff005fe738a4..92cd4b02e9ba 100644
> > > > > --- a/arch/x86/kvm/ioapic.c
> > > > > +++ b/arch/x86/kvm/ioapic.c
> > > > > @@ -319,7 +319,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
> > > > >      unsigned index;
> > > > >      bool mask_before, mask_after;
> > > > >      union kvm_ioapic_redirect_entry *e;
> > > > > -    unsigned long vcpu_bitmap;
> > > > > +    unsigned long vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
> > > > 
> > > > Is there a way to avoid this KVM_MAX_VCPUS-sized variable on the
> > > > stack?  This might hit us back when we increase KVM_MAX_VCPUS to
> > > > a few thousand VCPUs (I was planning to submit a patch for that
> > > > soon).
> > > 
> > > What's the short- or mid-term target?
> > 
> > Short term target is 2048 (which was already tested). Mid-term target
> > (not tested yet) is 4096, maybe 8192.
> > 
> > > Note, we're allocating KVM_MAX_VCPUS bits (not bytes!) here, this means
> > > that for e.g. 2048 vCPUs we need 256 bytes of the stack only. In case
> > > the target much higher than that, we will need to either switch to
> > > dynamic allocation or e.g. use pre-allocated per-CPU variables and make
> > > this a preempt-disabled region. I, however, would like to understand if
> > > the problem with allocating this from stack is real or not first.
> > 
> > Is 256 bytes too much here, or would that be OK?
> > 
> 
> AFAIR, on x86_64 stack size (both reqular and irq) is 16k, eating 256
> bytes of it is probably OK. I'd start worrying when we go to 1024 (8k
> vCPUs) and above (but this is subjective of course).
> 
Hi,

Not a classical review but,
I did some digital archaeology with this one, trying to understand what is going on:


I think that 16 bit vcpu bitmap is due to the fact that IOAPIC spec states that
it can address up to 16 cpus in physical destination mode.
 
In logical destination mode, assuming flat addressing and that logical id = 1 << physical id
which KVM hardcodes, it is also only possible to address 8 CPUs.
 
However(!) in flat cluster mode, the logical apic id is split in two.
We have 16 clusters and each have 4 CPUs, so it is possible to address 64 CPUs,
and unlike the logical ID, the KVM does honour cluster ID, 
thus one can stick say cluster ID 0 to any vCPU.
 
 
Let's look at ioapic_write_indirect.
It does:
 
    -> bitmap_zero(&vcpu_bitmap, 16);
    -> kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq, &vcpu_bitmap);
    -> kvm_make_scan_ioapic_request_mask(ioapic->kvm, &vcpu_bitmap); // use of the above bitmap
 
 
When we call kvm_bitmap_or_dest_vcpus, we can already overflow the bitmap,
since we pass all 8 bit of the destination even when it is physical.
 
 
Lets examine the kvm_bitmap_or_dest_vcpus:
 
  -> It calls the kvm_apic_map_get_dest_lapic which 
 
       -> for physical destinations, it just sets the bitmap, which can overflow
          if we pass it 8 bit destination (which basically includes reserved bits + 4 bit destination).
 
 
       -> For logical apic ID, it seems to truncate the result to 16 bit, which isn't correct as I explained
          above, but should not overflow the result.
 
  
   -> If call to kvm_apic_map_get_dest_lapic fails, it goes over all vcpus and tries to match the destination
       This can overflow as well.
 
 
I also don't like that ioapic_write_indirect calls the kvm_bitmap_or_dest_vcpus twice,
and second time with 'old_dest_id'
 
I am not 100%  sure why old_dest_id/old_dest_mode are needed as I don't see anything in the
function changing them.
I think only the guest can change them, so maybe the code deals with the guest changing them
while the code is running from a different vcpu?
 
The commit that introduced this code is 7ee30bc132c683d06a6d9e360e39e483e3990708
Nitesh Narayan Lal, maybe you remember something about it?
 

Also I worry a lot about other callers of kvm_apic_map_get_dest_lapic
 
It is also called from kvm_irq_delivery_to_apic_fast, and from kvm_intr_is_single_vcpu_fast
and both seem to also use 'unsigned long' for bitmap, and then only use 16 bits of it.
 
I haven't dug into them, but these don't seem to be IOAPIC related and I think
can overwrite the stack as well.
 

The whole thing seems a bit busted IMHO.

On the topic of enlarging these bitmaps to cover all vCPUs.

I also share the worry of having the whole bitmap on kernel stack for very large number of vcpus.
Maybe we need to abstract and use a bitmap for a sane number of vcpus, 
and use otherwise a 'kmalloc'ed buffer?

Also in theory large bitmaps might affect performance a bit.

My 0.2 cents.

Best regards,
	Maxim Levitsky

