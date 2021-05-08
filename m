Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F9377035
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 08:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhEHG6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 May 2021 02:58:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:31055 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229701AbhEHG6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 May 2021 02:58:18 -0400
IronPort-SDR: e3374fKmBfJI6clEZh3NVKXf8tyVdEjRr85TPLza+mc8J7i9XTgbGekIygZndhiAaNWFOfVjGg
 vG2cem+tBaYA==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="284342962"
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="scan'208";a="284342962"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 23:57:17 -0700
IronPort-SDR: zS4QOPadBzcAxJpEIR004ULpAonv9OaBt4d9Hfs0piQ51u0zXRSpAbLsa0LmW5WvY0rMNl+A/g
 R8ub7TQ6FLPQ==
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="scan'208";a="470153866"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.3]) ([10.254.209.3])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 23:57:02 -0700
Subject: Re: Question on guest enable msi fail when using GICv4/4.1
To:     Jason Wang <jasowang@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
 <373c70d3-eda3-8e84-d138-2f90d4e55217@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <4695fd66-7832-5070-627a-74dd254f7456@intel.com>
Date:   Sat, 8 May 2021 14:56:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <373c70d3-eda3-8e84-d138-2f90d4e55217@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/8/2021 9:51 AM, Jason Wang wrote:
>
> 在 2021/5/8 上午1:36, Marc Zyngier 写道:
>> On Fri, 07 May 2021 12:02:57 +0100,
>> Marc Zyngier <maz@kernel.org> wrote:
>>> On Fri, 07 May 2021 10:58:23 +0100,
>>> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>>> Hi Marc,
>>>>
>>>> Thanks for your quick reply.
>>>>
>>>> On 2021/5/7 17:03, Marc Zyngier wrote:
>>>>> On Fri, 07 May 2021 06:57:04 +0100,
>>>>> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>>>>> [This letter comes from Nianyao Tang]
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> Using GICv4/4.1 and msi capability, guest vf driver requires 3
>>>>>> vectors and enable msi, will lead to guest stuck.
>>>>> Stuck how?
>>>> Guest serial does not response anymore and guest network shutdown.
>>>>
>>>>>> Qemu gets number of interrupts from Multiple Message Capable field
>>>>>> set by guest. This field is aligned to a power of 2(if a function
>>>>>> requires 3 vectors, it initializes it to 2).
>>>>> So I guess this is a MultiMSI device with 4 vectors, right?
>>>>>
>>>> Yes, it can support maximum of 32 msi interrupts, and vf driver 
>>>> only use 3 msi.
>>>>
>>>>>> However, guest driver just sends 3 mapi-cmd to vits and 3 ite
>>>>>> entries is recorded in host.  Vfio initializes msi interrupts using
>>>>>> the number of interrupts 4 provide by qemu.  When it comes to the
>>>>>> 4th msi without ite in vits, in irq_bypass_register_producer,
>>>>>> producer and consumer will __connect fail, due to find_ite fail, and
>>>>>> do not resume guest.
>>>>> Let me rephrase this to check that I understand it:
>>>>> - The device has 4 vectors
>>>>> - The guest only create mappings for 3 of them
>>>>> - VFIO calls kvm_vgic_v4_set_forwarding() for each vector
>>>>> - KVM doesn't have a mapping for the 4th vector and returns an error
>>>>> - VFIO disable this 4th vector
>>>>>
>>>>> Is that correct? If yes, I don't understand why that impacts the 
>>>>> guest
>>>>> at all. From what I can see, vfio_msi_set_vector_signal() just prints
>>>>> a message on the console and carries on.
>>>>>
>>>> function calls:
>>>> --> vfio_msi_set_vector_signal
>>>>     --> irq_bypass_register_producer
>>>>        -->__connect
>>>>
>>>> in __connect, add_producer finally calls kvm_vgic_v4_set_forwarding
>>>> and fails to get the 4th mapping. When add_producer fail, it does
>>>> not call cons->start, calls kvm_arch_irq_bypass_start and then
>>>> kvm_arm_resume_guest.
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
>>>
>>> Can you please try this? It is completely untested (and I think the
>>> del_consumer call is odd, which is why I've also dropped it).
>>>
>>> Eric, what do you think?
>> Adding Zhu, Jason, MST to the party. It all seems to be caused by this
>> commit:
>>
>> commit a979a6aa009f3c99689432e0cdb5402a4463fb88
>> Author: Zhu Lingshan <lingshan.zhu@intel.com>
>> Date:   Fri Jul 31 14:55:33 2020 +0800
>>
>>      irqbypass: do not start cons/prod when failed connect
>>           If failed to connect, there is no need to start consumer nor
>>      producer.
>>           Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>      Suggested-by: Jason Wang <jasowang@redhat.com>
>>      Link: 
>> https://lore.kernel.org/r/20200731065533.4144-7-lingshan.zhu@intel.com
>>      Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>
>>
>> Zhu, I'd really like to understand why you think it is OK not to
>> restart consumer and producers when a connection has failed to be
>> established between the two?
>
>
> My bad, I didn't check ARM code but it's not easy to infer that the 
> cons->start/stop is not a per consumer specific operation but a global 
> one like VM halting/resuming.
Hi Marc,

I will send out a patch to revert this commit as Jason suggested.

Thanks
>
>
>>
>> In the case of KVM/arm64, this results in the guest being forever
>> suspended and never resumed. That's obviously not an acceptable
>> regression, as there is a number of benign reasons for a connect to
>> fail.
>
>
> Let's revert this commit.
>
> Thanks
>
>
>>
>> Thanks,
>>
>>     M.
>>
>

