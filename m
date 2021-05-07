Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A71376331
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 11:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhEGJ7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 05:59:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17474 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbhEGJ7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 05:59:34 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fc5Rw5QgTzkX9h;
        Fri,  7 May 2021 17:55:56 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Fri, 7 May 2021
 17:58:23 +0800
Subject: Re: Question on guest enable msi fail when using GICv4/4.1
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-pci@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
 <87k0oaq5jf.wl-maz@kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <cf870bcf-1173-a70b-2b55-4209abcbcbc3@hisilicon.com>
Date:   Fri, 7 May 2021 17:58:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87k0oaq5jf.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Thanks for your quick reply.

On 2021/5/7 17:03, Marc Zyngier wrote:
> On Fri, 07 May 2021 06:57:04 +0100,
> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>
>> [This letter comes from Nianyao Tang]
>>
>> Hi,
>>
>> Using GICv4/4.1 and msi capability, guest vf driver requires 3
>> vectors and enable msi, will lead to guest stuck.
> 
> Stuck how?

Guest serial does not response anymore and guest network shutdown.

> 
>> Qemu gets number of interrupts from Multiple Message Capable field
>> set by guest. This field is aligned to a power of 2(if a function
>> requires 3 vectors, it initializes it to 2).
> 
> So I guess this is a MultiMSI device with 4 vectors, right?
> 

Yes, it can support maximum of 32 msi interrupts, and vf driver only use 3 msi.

>> However, guest driver just sends 3 mapi-cmd to vits and 3 ite
>> entries is recorded in host.  Vfio initializes msi interrupts using
>> the number of interrupts 4 provide by qemu.  When it comes to the
>> 4th msi without ite in vits, in irq_bypass_register_producer,
>> producer and consumer will __connect fail, due to find_ite fail, and
>> do not resume guest.
> 
> Let me rephrase this to check that I understand it:
> - The device has 4 vectors
> - The guest only create mappings for 3 of them
> - VFIO calls kvm_vgic_v4_set_forwarding() for each vector
> - KVM doesn't have a mapping for the 4th vector and returns an error
> - VFIO disable this 4th vector
> 
> Is that correct? If yes, I don't understand why that impacts the guest
> at all. From what I can see, vfio_msi_set_vector_signal() just prints
> a message on the console and carries on.
> 

function calls:
--> vfio_msi_set_vector_signal
   --> irq_bypass_register_producer
      -->__connect

in __connect, add_producer finally calls kvm_vgic_v4_set_forwarding and fails to
get the 4th mapping. When add_producer fail, it does not call cons->start, calls
kvm_arch_irq_bypass_start and then kvm_arm_resume_guest.

Thanks,
Shaokun

>> Do we support this case, Guest function using msi interrupts number
>> not aligned to a power of 2?  Or qemu should provide correct msi
>> interrupts number?
> 
> QEMU cannot know how many vectors are in use, and the guest is free to
> issue mappings for the exact number of vectors it wants to service.
> 
> Please describe what breaks the guest here.
> 
> Thanks,
> 
> 	M.
> 
