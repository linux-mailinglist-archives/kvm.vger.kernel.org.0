Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772D03777AC
	for <lists+kvm@lfdr.de>; Sun,  9 May 2021 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhEIRBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 May 2021 13:01:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229928AbhEIRBW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 9 May 2021 13:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620579619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvRrwIvL//wqR4eXLZSclNxQvYlBf9vfJ7b18pGt9jI=;
        b=Sgyi0MIBT2BFoJCrxHC47pxcwLmjaGC6d/s9SEDRmQdIx1GxJ48OHgBIlp4t9LvXNOCfeg
        RhGzv7IHD+MVwPaKMgmGdJWTrM+oJYI4wTfT4iXcKMTx+RpZg9oew4uTcqSmuO41A/KsZR
        YR78hzylNSiri/8rtOX8ecyZ5k2hulY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-mo1rzEFOPWmzXXIL-DVA0w-1; Sun, 09 May 2021 13:00:14 -0400
X-MC-Unique: mo1rzEFOPWmzXXIL-DVA0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 562DE8015A8;
        Sun,  9 May 2021 17:00:13 +0000 (UTC)
Received: from [10.36.113.168] (ovpn-113-168.ams2.redhat.com [10.36.113.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5E856249C;
        Sun,  9 May 2021 17:00:06 +0000 (UTC)
Subject: Re: Question on guest enable msi fail when using GICv4/4.1
To:     Marc Zyngier <maz@kernel.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
 <87k0oaq5jf.wl-maz@kernel.org>
 <cf870bcf-1173-a70b-2b55-4209abcbcbc3@hisilicon.com>
 <878s4qq00u.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d6481eee-4318-1a56-a5a4-daf467070d22@redhat.com>
Date:   Sun, 9 May 2021 19:00:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <878s4qq00u.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 5/7/21 1:02 PM, Marc Zyngier wrote:
> On Fri, 07 May 2021 10:58:23 +0100,
> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>
>> Hi Marc,
>>
>> Thanks for your quick reply.
>>
>> On 2021/5/7 17:03, Marc Zyngier wrote:
>>> On Fri, 07 May 2021 06:57:04 +0100,
>>> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>>>
>>>> [This letter comes from Nianyao Tang]
>>>>
>>>> Hi,
>>>>
>>>> Using GICv4/4.1 and msi capability, guest vf driver requires 3
>>>> vectors and enable msi, will lead to guest stuck.
>>>
>>> Stuck how?
>>
>> Guest serial does not response anymore and guest network shutdown.
>>
>>>
>>>> Qemu gets number of interrupts from Multiple Message Capable field
>>>> set by guest. This field is aligned to a power of 2(if a function
>>>> requires 3 vectors, it initializes it to 2).
>>>
>>> So I guess this is a MultiMSI device with 4 vectors, right?
>>>
>>
>> Yes, it can support maximum of 32 msi interrupts, and vf driver only use 3 msi.
>>
>>>> However, guest driver just sends 3 mapi-cmd to vits and 3 ite
>>>> entries is recorded in host.  Vfio initializes msi interrupts using
>>>> the number of interrupts 4 provide by qemu.  When it comes to the
>>>> 4th msi without ite in vits, in irq_bypass_register_producer,
>>>> producer and consumer will __connect fail, due to find_ite fail, and
>>>> do not resume guest.
>>>
>>> Let me rephrase this to check that I understand it:
>>> - The device has 4 vectors
>>> - The guest only create mappings for 3 of them
>>> - VFIO calls kvm_vgic_v4_set_forwarding() for each vector
>>> - KVM doesn't have a mapping for the 4th vector and returns an error
>>> - VFIO disable this 4th vector
>>>
>>> Is that correct? If yes, I don't understand why that impacts the guest
>>> at all. From what I can see, vfio_msi_set_vector_signal() just prints
>>> a message on the console and carries on.
>>>
>>
>> function calls:
>> --> vfio_msi_set_vector_signal
>>    --> irq_bypass_register_producer
>>       -->__connect
>>
>> in __connect, add_producer finally calls kvm_vgic_v4_set_forwarding
>> and fails to get the 4th mapping. When add_producer fail, it does
>> not call cons->start, calls kvm_arch_irq_bypass_start and then
>> kvm_arm_resume_guest.
> 
> [+Eric, who wrote the irq_bypass infrastructure.]
> 
> Ah, so the guest is actually paused, not in a livelock situation
> (which is how I interpreted "stuck").
> 
> I think we should handle this case gracefully, as there should be no
> expectation that the guest will be using this interrupt. Given that
> VFIO seems to be pretty unfazed when a producer fails, I'm temped to
> do the same thing and restart the guest.
> 
> Also, __disconnect doesn't care about errors, so why should __connect
> have this odd behaviour?

_disconnect() does not care as we should always succeed tearing off
things. del_* ops are void functions. On the opposite we can fail
setting up the bypass.

Effectively
a979a6aa009f ("irqbypass: do not start cons/prod when failed connect")
needs to be reverted.

I agree the kerneldoc comments in linux/irqbypass.h may be improved to
better explain the role of stop/start cbs and warn about their potential
global impact.

wrt the case above, "in __connect, add_producer finally calls
kvm_vgic_v4_set_forwarding and fails to get the 4th mapping", shouldn't
we succeed in that case?

Thanks

Eric

> 
> Can you please try this? It is completely untested (and I think the
> del_consumer call is odd, which is why I've also dropped it).
> 
> Eric, what do you think?
> 
> Thanks,
> 
> 	M.
> 
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index c9bb3957f58a..7e1865e15668 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -40,21 +40,14 @@ static int __connect(struct irq_bypass_producer *prod,
>  	if (prod->add_consumer)
>  		ret = prod->add_consumer(prod, cons);
>  
> -	if (ret)
> -		goto err_add_consumer;
> -
> -	ret = cons->add_producer(cons, prod);
> -	if (ret)
> -		goto err_add_producer;
> +	if (!ret)
> +		ret = cons->add_producer(cons, prod);
>  
>  	if (cons->start)
>  		cons->start(cons);
>  	if (prod->start)
>  		prod->start(prod);
> -err_add_producer:
> -	if (prod->del_consumer)
> -		prod->del_consumer(prod, cons);
> -err_add_consumer:
> +
>  	return ret;
>  }
>  
> 

