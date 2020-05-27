Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91DC1E3C50
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388154AbgE0ImY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:42:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47708 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387929AbgE0ImY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:42:24 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BB54F1344ACB74EED863;
        Wed, 27 May 2020 16:42:21 +0800 (CST)
Received: from [10.173.222.27] (10.173.222.27) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 16:42:14 +0800
Subject: Re: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>, <kernel-team@android.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200526161136.451312-1-maz@kernel.org>
 <47d6d521-f05e-86fe-4a94-ce21754100ae@huawei.com>
 <1d3658f4b92a690ba05367f2a22a7331@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <628e9f4b-0587-bde6-05f3-6877e37bd659@huawei.com>
Date:   Wed, 27 May 2020 16:42:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1d3658f4b92a690ba05367f2a22a7331@kernel.org>
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

On 2020/5/27 15:55, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On 2020-05-27 08:41, Zenghui Yu wrote:
>> On 2020/5/27 0:11, Marc Zyngier wrote:
>>> On a system that uses SPIs to implement MSIs (as it would be
>>> the case on a GICv2 system exposing a GICv2m to its guests),
>>> we deny the possibility of injecting SPIs on the in-atomic
>>> fast-path.
>>>
>>> This results in a very large amount of context-switches
>>> (roughly equivalent to twice the interrupt rate) on the host,
>>> and suboptimal performance for the guest (as measured with
>>> a test workload involving a virtio interface backed by vhost-net).
>>> Given that GICv2 systems are usually on the low-end of the spectrum
>>> performance wise, they could do without the aggravation.
>>>
>>> We solved this for GICv3+ITS by having a translation cache. But
>>> SPIs do not need any extra infrastructure, and can be immediately
>>> injected in the virtual distributor as the locking is already
>>> heavy enough that we don't need to worry about anything.
>>>
>>> This halves the number of context switches for the same workload.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>   arch/arm64/kvm/vgic/vgic-irqfd.c | 20 ++++++++++++++++----
>>>   arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
>>>   2 files changed, 17 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c 
>>> b/arch/arm64/kvm/vgic/vgic-irqfd.c
>>> index d8cdfea5cc96..11a9f81115ab 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
>>> @@ -107,15 +107,27 @@ int kvm_arch_set_irq_inatomic(struct 
>>> kvm_kernel_irq_routing_entry *e,
>>>                     struct kvm *kvm, int irq_source_id, int level,
>>>                     bool line_status)
>>
>> ... and you may also need to update the comment on top of it to
>> reflect this change.
>>
>> /**
>>  * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
>>  *
>>  * Currently only direct MSI injection is supported.
>>  */
> 
> As far as I can tell, it is still valid (at least from the guest's
> perspective). You could in practice use that to deal with level
> interrupts, but we only inject the rising edge on this path, never
> the falling edge. So effectively, this is limited to edge interrupts,
> which is mostly MSIs.

Oops... I had wrongly mixed MSI with the architecture-defined LPI, and
was think that we should add something like "direct SPI injection is
also supported now". Sorry.

> 
> Unless you are thinking of something else which I would have missed?

No, please ignore the noisy.


Thanks,
Zenghui
