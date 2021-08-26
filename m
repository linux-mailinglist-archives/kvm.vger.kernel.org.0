Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390D73F8EB6
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 21:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243419AbhHZT2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 15:28:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230008AbhHZT2R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 15:28:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G18kBJm+1QrGSDMZhX+3k2NdPp8yMmEI4I4QJxr0VkI=;
        b=eUI68voLx7PEcQ3+0VNHRDBKUzCLHKSqtxL1GFfQ/O17KyuN83kYGRaEeED/n+Vv7jh/jZ
        v8t+QbA25MLUlUBrKWzl5So2Ng3Z5VdyaukofHshebr+PBGQmPjeviYE8V2Mmfhx9CujVw
        +T8zP0m24H077/c9CbQ5J9YRzs/cmm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-qsklTeaQMUCDQh-prBESzw-1; Thu, 26 Aug 2021 15:27:27 -0400
X-MC-Unique: qsklTeaQMUCDQh-prBESzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E6081082923;
        Thu, 26 Aug 2021 19:27:26 +0000 (UTC)
Received: from localhost (unknown [10.22.10.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0128D60C4A;
        Thu, 26 Aug 2021 19:27:18 +0000 (UTC)
Date:   Thu, 26 Aug 2021 15:27:18 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
Message-ID: <20210826192718.h6ct6pe2njaazhyh@habkost.net>
References: <20210823143028.649818-1-vkuznets@redhat.com>
 <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net>
 <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm re-reading this, and:

On Tue, Aug 24, 2021 at 07:07:58PM +0300, Maxim Levitsky wrote:
[...]
> Hi,
> 
> Not a classical review but,
> I did some digital archaeology with this one, trying to understand what is going on:
> 
> 
> I think that 16 bit vcpu bitmap is due to the fact that IOAPIC spec states that
> it can address up to 16 cpus in physical destination mode.
>  
> In logical destination mode, assuming flat addressing and that logical id = 1 << physical id
> which KVM hardcodes, it is also only possible to address 8 CPUs.
>  
> However(!) in flat cluster mode, the logical apic id is split in two.
> We have 16 clusters and each have 4 CPUs, so it is possible to address 64 CPUs,
> and unlike the logical ID, the KVM does honour cluster ID, 
> thus one can stick say cluster ID 0 to any vCPU.
>  
>  
> Let's look at ioapic_write_indirect.
> It does:
>  
>     -> bitmap_zero(&vcpu_bitmap, 16);
>     -> kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq, &vcpu_bitmap);
>     -> kvm_make_scan_ioapic_request_mask(ioapic->kvm, &vcpu_bitmap); // use of the above bitmap
>  
>  
> When we call kvm_bitmap_or_dest_vcpus, we can already overflow the bitmap,
> since we pass all 8 bit of the destination even when it is physical.
>  
>  
> Lets examine the kvm_bitmap_or_dest_vcpus:
>  
>   -> It calls the kvm_apic_map_get_dest_lapic which 
>  
>        -> for physical destinations, it just sets the bitmap, which can overflow
>           if we pass it 8 bit destination (which basically includes reserved bits + 4 bit destination).

How exactly do you think kvm_apic_map_get_dest_lapic() can
overflow?  It never writes beyond `bitmap[0]`, as far as I can
see.

>  
>  
>        -> For logical apic ID, it seems to truncate the result to 16 bit, which isn't correct as I explained
>           above, but should not overflow the result.
>  
>   
>    -> If call to kvm_apic_map_get_dest_lapic fails, it goes over all vcpus and tries to match the destination
>        This can overflow as well.
>  
>  [...]

-- 
Eduardo

