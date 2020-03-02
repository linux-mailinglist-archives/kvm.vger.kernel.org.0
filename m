Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087431751DB
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 03:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgCBCkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 21:40:42 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60226 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726695AbgCBCkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 21:40:42 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 66F8A3F26BA126D15212;
        Mon,  2 Mar 2020 10:40:39 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 2 Mar 2020
 10:40:32 +0800
Subject: Re: [PATCH v4 16/20] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "Robert Richter" <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Eric Auger" <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-17-maz@kernel.org>
 <6798eb13-a7e9-2a92-91b2-9b657962ea79@huawei.com>
 <7aa668a5920b8deb8c2ee2fec3ef69b3@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <865e3cc6-19e3-a1ec-84a6-8c15ad738345@huawei.com>
Date:   Mon, 2 Mar 2020 10:40:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <7aa668a5920b8deb8c2ee2fec3ef69b3@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/2/29 3:16, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On 2020-02-20 03:55, Zenghui Yu wrote:
>> Hi Marc,
>>
>> On 2020/2/14 22:57, Marc Zyngier wrote:
>>> In order to let a guest buy in the new, active-less SGIs, we
>>> need to be able to switch between the two modes.
>>>
>>> Handle this by stopping all guest activity, transfer the state
>>> from one mode to the other, and resume the guest.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>
>> [...]
>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>> index 1bc09b523486..2c9fc13e2c59 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>> @@ -540,6 +540,8 @@ int vgic_v3_map_resources(struct kvm *kvm)
>>>           goto out;
>>>       }
>>>   +    if (kvm_vgic_global_state.has_gicv4_1)
>>> +        vgic_v4_configure_vsgis(kvm);
>>>       dist->ready = true;
>>>     out:
>>
>> Is there any reason to invoke vgic_v4_configure_vsgis() here?
>> This is called on the first VCPU run, through kvm_vgic_map_resources().
>> Shouldn't the vSGI configuration only driven by a GICD_CTLR.nASSGIreq
>> writing (from guest, or from userspace maybe)?
> 
> What I'm trying to catch here is the guest that has been restored with
> nASSGIreq set. At the moment, we don't do anything on the userspace
> side, because the vmm could decide to write that particular bit
> multiple times, and switching between the two modes is expensive (not
> to mention that all the vcpus may not have been created yet).
> 
> Moving it to the first run makes all these pitfalls go away (we have the
> final nASSSGIreq value, and all the vcpus are accounted for).

So what will happen on restoration is (roughly):

  - for GICR_ISPENR0: We will restore the pending status of vSGIs into
    software pending_latch, just like what we've done for normal SGIs.
  - for GICD_CTLR.nASSGIreq: We will only record the written value.
    (Note to myself: No invocation of configure_vsgis() in uaccess_write
     callback, I previously mixed it up with the guest write callback.)
  - Finally, you choose the first vcpu run as the appropriate point to
    potentially flush the pending status to HW according to the final
    nASSGIreq value.

> 
> Does this make sense to you?

Yeah, it sounds like a good idea! And please ignore what I've replied to
patch #15, I obviously missed your intention at that time, sorry...

But can we move this hunk to some places more appropriate, for example,
put it together with the GICD_CTLR's uaccess_write change? It might make
things a bit clearer for other reviewers. :-)


Thanks,
Zenghui

