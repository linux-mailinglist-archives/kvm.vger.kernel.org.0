Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96ABF3F710C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 10:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbhHYIWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 04:22:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28890 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239338AbhHYIWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 04:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629879675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QW7PXYP8IfyOJUWBjxnrPNW0xt14Kogt0NQDd6gwJ6Y=;
        b=GMP6eY7Q7fFz8eqlaHeB0FoCTqZw392l0vmKjWa0i7EfClsDsaVthFBMp1OguEu4M0SJXv
        kQbVrdR8jn5PkCnf8U3w3lr6vZ6vhPNTpNuu0rSb1g0flvM7sJHXD0CdzYg8WEwcfrtAs0
        rraQkzO2Jb0wQc8lfLNSM04RwT8neYw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-tQ0wEnuZPQCxqEyWbPeXYg-1; Wed, 25 Aug 2021 04:21:07 -0400
X-MC-Unique: tQ0wEnuZPQCxqEyWbPeXYg-1
Received: by mail-wr1-f69.google.com with SMTP id b7-20020a5d4d87000000b001575d1053d2so1543873wru.23
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 01:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QW7PXYP8IfyOJUWBjxnrPNW0xt14Kogt0NQDd6gwJ6Y=;
        b=hEEhycMvjcQznN6lEn8r5Znr2B/gNKraOWn4+UManR6lRwFqQ6/Xd4j+HBPdsPamwF
         GMfYlGaOE2XR0g5QWxydg0ucdCsM0oi32iPhOK3MEfZGqpkrfxOJP/ZlRlxaMHPk8kyK
         v31wW/lS2e3kGG+xdC92Q4Tgwrqh0grGryixOrnFpZse9eUyBQNSLkAQjMghvh/Hlkcn
         pgtXhQPAPbncu1eqMTfQstDgYRTJS3ebaukm93ilwvU5knODNED6/la6kQ5kFqW2h2yF
         qmXdubeRPbbCddgnpiIQ13RIGUeQT1c8Uvmf4HpG8Of/gIkE4Zdl5ShmpeXHMyuaAa+H
         tykA==
X-Gm-Message-State: AOAM533Df8WXTaXwVy6qS/4H2HjL8aBa1wnbLPsaauxUfgEA7cwjlqZ0
        Jy8XOisUYePWCGNS3yVwnXyajTQk4fp+SvzyZXI0Wcg1TeV9a6tUKi+4fis9/pgEmvYSl28cjLW
        d0M2tyxZ8vVbA
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr8046410wmg.36.1629879666474;
        Wed, 25 Aug 2021 01:21:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTA19up2LH13aznsuiyStC+W/wWm3m+AvccbfYlcYYMsVuq7TaIZTrQj6ozbcDLZF+FTmrug==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr8046395wmg.36.1629879666254;
        Wed, 25 Aug 2021 01:21:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d24sm4510653wmb.35.2021.08.25.01.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 01:21:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
In-Reply-To: <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
 <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net>
 <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
Date:   Wed, 25 Aug 2021 10:21:04 +0200
Message-ID: <87h7fej5ov.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
...
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
>  
>  
>        -> For logical apic ID, it seems to truncate the result to 16 bit, which isn't correct as I explained
>           above, but should not overflow the result.
>  
>   
>    -> If call to kvm_apic_map_get_dest_lapic fails, it goes over all vcpus and tries to match the destination
>        This can overflow as well.
>  
>  
> I also don't like that ioapic_write_indirect calls the kvm_bitmap_or_dest_vcpus twice,
> and second time with 'old_dest_id'
>  
> I am not 100%  sure why old_dest_id/old_dest_mode are needed as I don't see anything in the
> function changing them.
> I think only the guest can change them, so maybe the code deals with the guest changing them
> while the code is running from a different vcpu?
>  
> The commit that introduced this code is 7ee30bc132c683d06a6d9e360e39e483e3990708
> Nitesh Narayan Lal, maybe you remember something about it?
>  

Before posting this patch I've contacted Nitesh privately, he's
currently on vacation but will take a look when he gets back.

>
> Also I worry a lot about other callers of kvm_apic_map_get_dest_lapic
>  
> It is also called from kvm_irq_delivery_to_apic_fast, and from kvm_intr_is_single_vcpu_fast
> and both seem to also use 'unsigned long' for bitmap, and then only use 16 bits of it.
>  
> I haven't dug into them, but these don't seem to be IOAPIC related and I think
> can overwrite the stack as well.

I'm no expert in this code but when writing the patch I somehow
convinced myself that a single unsigned long is always enough. I think
that for cluster mode 'bitmap' needs 64-bits (and it is *not* a
vcpu_bitmap, we need to convert). I may be completely wrong of course
but in any case this is a different issue. In ioapic_write_indirect() we
have 'vcpu_bitmap' which should certainly be longer than 64 bits.

-- 
Vitaly

