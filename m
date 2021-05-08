Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEBD376E39
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 03:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhEHBxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 21:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230257AbhEHBxB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 21:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620438720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qaU4UN52bL9DeZ0ND4jhfpiSI9Et+mZ9RMw7As/kczA=;
        b=PW2JLNDgJJa2ljaDClKSNKl/s2ETwxxGgpQYy0F0aBT3hGQCmCYfrqRc1i3JTbTxhwr6BJ
        /EpieYQLHVJL6UYbb7T7Ft1/Yf1ZH/S5LlZdvhNMDqnpNgkqZeOlIwN9JSkhn8MnSqQ9fl
        dJfVM+VlNelCiARaVpCRjhun3IsfHEQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-EHqKB97XOb2zg-q63RXjLQ-1; Fri, 07 May 2021 21:51:58 -0400
X-MC-Unique: EHqKB97XOb2zg-q63RXjLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20C30107ACC7;
        Sat,  8 May 2021 01:51:57 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-251.pek2.redhat.com [10.72.12.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 913785D740;
        Sat,  8 May 2021 01:51:41 +0000 (UTC)
Subject: Re: Question on guest enable msi fail when using GICv4/4.1
To:     Marc Zyngier <maz@kernel.org>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
 <87k0oaq5jf.wl-maz@kernel.org>
 <cf870bcf-1173-a70b-2b55-4209abcbcbc3@hisilicon.com>
 <878s4qq00u.wl-maz@kernel.org> <874kfepht4.wl-maz@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <373c70d3-eda3-8e84-d138-2f90d4e55217@redhat.com>
Date:   Sat, 8 May 2021 09:51:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <874kfepht4.wl-maz@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/8 ÉÏÎç1:36, Marc Zyngier Ð´µÀ:
> On Fri, 07 May 2021 12:02:57 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
>> On Fri, 07 May 2021 10:58:23 +0100,
>> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>> Hi Marc,
>>>
>>> Thanks for your quick reply.
>>>
>>> On 2021/5/7 17:03, Marc Zyngier wrote:
>>>> On Fri, 07 May 2021 06:57:04 +0100,
>>>> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>>>> [This letter comes from Nianyao Tang]
>>>>>
>>>>> Hi,
>>>>>
>>>>> Using GICv4/4.1 and msi capability, guest vf driver requires 3
>>>>> vectors and enable msi, will lead to guest stuck.
>>>> Stuck how?
>>> Guest serial does not response anymore and guest network shutdown.
>>>
>>>>> Qemu gets number of interrupts from Multiple Message Capable field
>>>>> set by guest. This field is aligned to a power of 2(if a function
>>>>> requires 3 vectors, it initializes it to 2).
>>>> So I guess this is a MultiMSI device with 4 vectors, right?
>>>>
>>> Yes, it can support maximum of 32 msi interrupts, and vf driver only use 3 msi.
>>>
>>>>> However, guest driver just sends 3 mapi-cmd to vits and 3 ite
>>>>> entries is recorded in host.  Vfio initializes msi interrupts using
>>>>> the number of interrupts 4 provide by qemu.  When it comes to the
>>>>> 4th msi without ite in vits, in irq_bypass_register_producer,
>>>>> producer and consumer will __connect fail, due to find_ite fail, and
>>>>> do not resume guest.
>>>> Let me rephrase this to check that I understand it:
>>>> - The device has 4 vectors
>>>> - The guest only create mappings for 3 of them
>>>> - VFIO calls kvm_vgic_v4_set_forwarding() for each vector
>>>> - KVM doesn't have a mapping for the 4th vector and returns an error
>>>> - VFIO disable this 4th vector
>>>>
>>>> Is that correct? If yes, I don't understand why that impacts the guest
>>>> at all. From what I can see, vfio_msi_set_vector_signal() just prints
>>>> a message on the console and carries on.
>>>>
>>> function calls:
>>> --> vfio_msi_set_vector_signal
>>>     --> irq_bypass_register_producer
>>>        -->__connect
>>>
>>> in __connect, add_producer finally calls kvm_vgic_v4_set_forwarding
>>> and fails to get the 4th mapping. When add_producer fail, it does
>>> not call cons->start, calls kvm_arch_irq_bypass_start and then
>>> kvm_arm_resume_guest.
>> [+Eric, who wrote the irq_bypass infrastructure.]
>>
>> Ah, so the guest is actually paused, not in a livelock situation
>> (which is how I interpreted "stuck").
>>
>> I think we should handle this case gracefully, as there should be no
>> expectation that the guest will be using this interrupt. Given that
>> VFIO seems to be pretty unfazed when a producer fails, I'm temped to
>> do the same thing and restart the guest.
>>
>> Also, __disconnect doesn't care about errors, so why should __connect
>> have this odd behaviour?
>>
>> Can you please try this? It is completely untested (and I think the
>> del_consumer call is odd, which is why I've also dropped it).
>>
>> Eric, what do you think?
> Adding Zhu, Jason, MST to the party. It all seems to be caused by this
> commit:
>
> commit a979a6aa009f3c99689432e0cdb5402a4463fb88
> Author: Zhu Lingshan <lingshan.zhu@intel.com>
> Date:   Fri Jul 31 14:55:33 2020 +0800
>
>      irqbypass: do not start cons/prod when failed connect
>      
>      If failed to connect, there is no need to start consumer nor
>      producer.
>      
>      Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>      Suggested-by: Jason Wang <jasowang@redhat.com>
>      Link: https://lore.kernel.org/r/20200731065533.4144-7-lingshan.zhu@intel.com
>      Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
>
> Zhu, I'd really like to understand why you think it is OK not to
> restart consumer and producers when a connection has failed to be
> established between the two?


My bad, I didn't check ARM code but it's not easy to infer that the 
cons->start/stop is not a per consumer specific operation but a global 
one like VM halting/resuming.


>
> In the case of KVM/arm64, this results in the guest being forever
> suspended and never resumed. That's obviously not an acceptable
> regression, as there is a number of benign reasons for a connect to
> fail.


Let's revert this commit.

Thanks


>
> Thanks,
>
> 	M.
>

