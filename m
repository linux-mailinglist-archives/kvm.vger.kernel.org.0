Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87513377E39
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhEJIbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:31:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230326AbhEJIbE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FKDGvNTOu+l98CEFBGE2CwvsTNx4tKn3+gggtayZ+GA=;
        b=L4C/+k5JhxmWP5ymwugeF2UORnwfhPXZVkNl4+TfmZXd/bBH2JnFfdFXUjDaJRCcWzkT2a
        dDnRa7MTjNz+gOuLrwy0KbEWShNnNaM8rkUgo7K79Ft7nQE/GWyUfb05QF2aj14xzCemAB
        t5gylCEdQleB1NT6t2w000zw3GyYrSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-B4pWwqHOMA6Zr9UN-8mAgQ-1; Mon, 10 May 2021 04:29:56 -0400
X-MC-Unique: B4pWwqHOMA6Zr9UN-8mAgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0968E1008063;
        Mon, 10 May 2021 08:29:55 +0000 (UTC)
Received: from [10.36.113.168] (ovpn-113-168.ams2.redhat.com [10.36.113.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C7BB519C44;
        Mon, 10 May 2021 08:29:48 +0000 (UTC)
Subject: Re: Question on guest enable msi fail when using GICv4/4.1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
 <87k0oaq5jf.wl-maz@kernel.org>
 <cf870bcf-1173-a70b-2b55-4209abcbcbc3@hisilicon.com>
 <878s4qq00u.wl-maz@kernel.org>
 <d6481eee-4318-1a56-a5a4-daf467070d22@redhat.com>
 <871rafowp2.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <69cd5989-f4cb-469c-f6a0-3362540e0271@redhat.com>
Date:   Mon, 10 May 2021 10:29:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <871rafowp2.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/10/21 9:49 AM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Sun, 09 May 2021 18:00:04 +0100,
> Auger Eric <eric.auger@redhat.com> wrote:
>>
>> Hi,
>> On 5/7/21 1:02 PM, Marc Zyngier wrote:
>>> On Fri, 07 May 2021 10:58:23 +0100,
>>> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> Thanks for your quick reply.
>>>>
>>>> On 2021/5/7 17:03, Marc Zyngier wrote:
>>>>> On Fri, 07 May 2021 06:57:04 +0100,
>>>>> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>>>>>
>>>>>> [This letter comes from Nianyao Tang]
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> Using GICv4/4.1 and msi capability, guest vf driver requires 3
>>>>>> vectors and enable msi, will lead to guest stuck.
>>>>>
>>>>> Stuck how?
>>>>
>>>> Guest serial does not response anymore and guest network shutdown.
>>>>
>>>>>
>>>>>> Qemu gets number of interrupts from Multiple Message Capable field
>>>>>> set by guest. This field is aligned to a power of 2(if a function
>>>>>> requires 3 vectors, it initializes it to 2).
>>>>>
>>>>> So I guess this is a MultiMSI device with 4 vectors, right?
>>>>>
>>>>
>>>> Yes, it can support maximum of 32 msi interrupts, and vf driver only use 3 msi.
>>>>
>>>>>> However, guest driver just sends 3 mapi-cmd to vits and 3 ite
>>>>>> entries is recorded in host.  Vfio initializes msi interrupts using
>>>>>> the number of interrupts 4 provide by qemu.  When it comes to the
>>>>>> 4th msi without ite in vits, in irq_bypass_register_producer,
>>>>>> producer and consumer will __connect fail, due to find_ite fail, and
>>>>>> do not resume guest.
>>>>>
>>>>> Let me rephrase this to check that I understand it:
>>>>> - The device has 4 vectors
>>>>> - The guest only create mappings for 3 of them
>>>>> - VFIO calls kvm_vgic_v4_set_forwarding() for each vector
>>>>> - KVM doesn't have a mapping for the 4th vector and returns an error
>>>>> - VFIO disable this 4th vector
>>>>>
>>>>> Is that correct? If yes, I don't understand why that impacts the guest
>>>>> at all. From what I can see, vfio_msi_set_vector_signal() just prints
>>>>> a message on the console and carries on.
>>>>>
>>>>
>>>> function calls:
>>>> --> vfio_msi_set_vector_signal
>>>>    --> irq_bypass_register_producer
>>>>       -->__connect
>>>>
>>>> in __connect, add_producer finally calls kvm_vgic_v4_set_forwarding
>>>> and fails to get the 4th mapping. When add_producer fail, it does
>>>> not call cons->start, calls kvm_arch_irq_bypass_start and then
>>>> kvm_arm_resume_guest.
>>>
>>> [+Eric, who wrote the irq_bypass infrastructure.]
>>>
>>> Ah, so the guest is actually paused, not in a livelock situation
>>> (which is how I interpreted "stuck").
>>>
>>> I think we should handle this case gracefully, as there should be no
>>> expectation that the guest will be using this interrupt. Given that
>>> VFIO seems to be pretty unfazed when a producer fails, I'm temped to
>>> do the same thing and restart the guest.
>>>
>>> Also, __disconnect doesn't care about errors, so why should __connect
>>> have this odd behaviour?
>>
>> _disconnect() does not care as we should always succeed tearing off
>> things. del_* ops are void functions. On the opposite we can fail
>> setting up the bypass.
>>
>> Effectively
>> a979a6aa009f ("irqbypass: do not start cons/prod when failed connect")
>> needs to be reverted.
>>
>> I agree the kerneldoc comments in linux/irqbypass.h may be improved to
>> better explain the role of stop/start cbs and warn about their potential
>> global impact.
> 
> Yup. It also begs the question of why we have producer callbacks, as
> nobody seems to use them.

At the time this was designed, I was working on VFIO platform IRQ
forwarding using direct EOI and they were used (and useful)

+	irq->producer.stop = vfio_platform_irq_bypass_stop;
+	irq->producer.start = vfio_platform_irq_bypass_start;

[PATCH v4 02/13] VFIO: platform: registration of a dummy IRQ bypass producer
[PATCH v4 07/13] VFIO: platform: add irq bypass producer management
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-November/017323.html

basically the IRQ was disabled and re-enabled. This series has never
been upstreamed but that's where it originates from.



> 
>> wrt the case above, "in __connect, add_producer finally calls
>> kvm_vgic_v4_set_forwarding and fails to get the 4th mapping", shouldn't
>> we succeed in that case?
> 
> From a KVM perspective, we can't return a success because there is no
> guest LPI that matches the input signal.
right, sorry I had in mind the set_forwarding was partially successful
for 3 of 4 LPIs but it is a unitary operation.
> 
> And such failure seems to be expected by the VFIO code, which just
> prints a message on the console and set the producer token to NULL. So
> returning an error from the KVM code is useful, at least to an extent.

OK. So with the revert, the use case resume working, right?

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

