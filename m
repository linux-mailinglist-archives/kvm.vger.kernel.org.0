Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030583F7386
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 12:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhHYKmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 06:42:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238358AbhHYKmP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 06:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629888089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IoPAv+/75bucuIjnk9PlFh3DxV9j3NN/Txnq4G4fqfM=;
        b=TJKHx2DyA3H7wMqfZq0wBrAAOFylYukoqv25Uigi5+nL7kVOx2HTIKrkSdGIn5J22l32xe
        p3+H5fWAGfdGdSj+h/A7YfzzO1m2ejv1FzdyNQqYSoTFIvXAM8rgkcdn5hijuss3mqj+OU
        z65XkjqPC6/r4McnCJ6dXHn1d6oK0sg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-TgpkabijNyCpBzkTqyGvzw-1; Wed, 25 Aug 2021 06:41:28 -0400
X-MC-Unique: TgpkabijNyCpBzkTqyGvzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FBDC80124F;
        Wed, 25 Aug 2021 10:41:27 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF2A460BF4;
        Wed, 25 Aug 2021 10:41:21 +0000 (UTC)
Message-ID: <0d86ea59071c97ee3db16897d1fb7a13ead3a5ad.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Date:   Wed, 25 Aug 2021 13:41:20 +0300
In-Reply-To: <87bl5lkgfm.fsf@vitty.brq.redhat.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
         <20210823143028.649818-5-vkuznets@redhat.com>
         <20210823185841.ov7ejn2thwebcwqk@habkost.net>
         <87mtp7jowv.fsf@vitty.brq.redhat.com>
         <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
         <87k0kakip9.fsf@vitty.brq.redhat.com>
         <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
         <87h7fej5ov.fsf@vitty.brq.redhat.com>
         <36b6656637d1e6aaa2ab5098f7ebc27644466294.camel@redhat.com>
         <87bl5lkgfm.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-08-25 at 11:43 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Wed, 2021-08-25 at 10:21 +0200, Vitaly Kuznetsov wrote:
> > > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > > 
> > > > On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
> > > ...
> > > > Not a classical review but,
> > > > I did some digital archaeology with this one, trying to understand what is going on:
> > > > 
> > > > 
> > > > I think that 16 bit vcpu bitmap is due to the fact that IOAPIC spec states that
> > > > it can address up to 16 cpus in physical destination mode.
> > > >  
> > > > In logical destination mode, assuming flat addressing and that logical id = 1 << physical id
> > > > which KVM hardcodes, it is also only possible to address 8 CPUs.
> > > >  
> > > > However(!) in flat cluster mode, the logical apic id is split in two.
> > > > We have 16 clusters and each have 4 CPUs, so it is possible to address 64 CPUs,
> > > > and unlike the logical ID, the KVM does honour cluster ID, 
> > > > thus one can stick say cluster ID 0 to any vCPU.
> > > >  
> > > >  
> > > > Let's look at ioapic_write_indirect.
> > > > It does:
> > > >  
> > > >     -> bitmap_zero(&vcpu_bitmap, 16);
> > > >     -> kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq, &vcpu_bitmap);
> > > >     -> kvm_make_scan_ioapic_request_mask(ioapic->kvm, &vcpu_bitmap); // use of the above bitmap
> > > >  
> > > >  
> > > > When we call kvm_bitmap_or_dest_vcpus, we can already overflow the bitmap,
> > > > since we pass all 8 bit of the destination even when it is physical.
> > > >  
> > > >  
> > > > Lets examine the kvm_bitmap_or_dest_vcpus:
> > > >  
> > > >   -> It calls the kvm_apic_map_get_dest_lapic which 
> > > >  
> > > >        -> for physical destinations, it just sets the bitmap, which can overflow
> > > >           if we pass it 8 bit destination (which basically includes reserved bits + 4 bit destination).
> > > >  
> > > >  
> > > >        -> For logical apic ID, it seems to truncate the result to 16 bit, which isn't correct as I explained
> > > >           above, but should not overflow the result.
> > > >  
> > > >   
> > > >    -> If call to kvm_apic_map_get_dest_lapic fails, it goes over all vcpus and tries to match the destination
> > > >        This can overflow as well.
> > > >  
> > > >  
> > > > I also don't like that ioapic_write_indirect calls the kvm_bitmap_or_dest_vcpus twice,
> > > > and second time with 'old_dest_id'
> > > >  
> > > > I am not 100%  sure why old_dest_id/old_dest_mode are needed as I don't see anything in the
> > > > function changing them.
> > > > I think only the guest can change them, so maybe the code deals with the guest changing them
> > > > while the code is running from a different vcpu?
> > > >  
> > > > The commit that introduced this code is 7ee30bc132c683d06a6d9e360e39e483e3990708
> > > > Nitesh Narayan Lal, maybe you remember something about it?
> > > >  
> > > 
> > > Before posting this patch I've contacted Nitesh privately, he's
> > > currently on vacation but will take a look when he gets back.
> > > 
> > > > Also I worry a lot about other callers of kvm_apic_map_get_dest_lapic
> > > >  
> > > > It is also called from kvm_irq_delivery_to_apic_fast, and from kvm_intr_is_single_vcpu_fast
> > > > and both seem to also use 'unsigned long' for bitmap, and then only use 16 bits of it.
> > > >  
> > > > I haven't dug into them, but these don't seem to be IOAPIC related and I think
> > > > can overwrite the stack as well.
> > > 
> > > I'm no expert in this code but when writing the patch I somehow
> > > convinced myself that a single unsigned long is always enough. I think
> > > that for cluster mode 'bitmap' needs 64-bits (and it is *not* a
> > > vcpu_bitmap, we need to convert). I may be completely wrong of course
> > > but in any case this is a different issue. In ioapic_write_indirect() we
> > > have 'vcpu_bitmap' which should certainly be longer than 64 bits.
> > 
> > This code which I mentioned in 'other callers' as far as I see is not IOAPIC related.
> > For regular local APIC all bets are off, any vCPU and apic ID are possible 
> > (xapic I think limits apic id to 255 but x2apic doesn't).
> > 
> > I strongly suspect that this code can overflow as well.
> 
> I've probably missed something but I don't see how
> kvm_apic_map_get_dest_lapic() can set bits above 64 in 'bitmap'. If it
> can, then we have a problem indeed.

It me that missed that '*bitmap = 1' is harmless, since this function returns
the destanation local apic, and bitmap of vCPU to work on starting from
this local apic. So its OK.

So now your patch looks OK to me now.

You can also zero uppper 4 bits of destanation
apic ID though since IO apic spec says that they are reserved.
(But I won't be surprised if that restriction was later lifted, as I am reading
the original IO apic spec, about the good old actual chip).
But that isn't a serious issue.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky





> 


