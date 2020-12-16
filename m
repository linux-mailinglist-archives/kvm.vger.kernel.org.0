Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39D22DBECB
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 11:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgLPKhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 05:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgLPKhg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 05:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608114970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9CKeWnWAx3u5eiNFnwtMWhwXN3PXTOPoJxw+acCycA=;
        b=F5tYhX6eUAjgVfhJxdkvU0bpAbPbzXrQjSZKW8yCkPFZtyrtU8HoP8RDU8/Y+U1U4LtPW9
        +aQkLYXgS5Tju34bAOfMV2Jk/Fddgy787/HdpAiCJy9T2n2uA37U3SohWWjigqOOe191t2
        gk/rMgWcKWq0UiWsajkVZiUUvTCMQDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-njN3WV6WMg-q2N8opfkSmQ-1; Wed, 16 Dec 2020 05:36:06 -0500
X-MC-Unique: njN3WV6WMg-q2N8opfkSmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83CB58030AC;
        Wed, 16 Dec 2020 10:36:03 +0000 (UTC)
Received: from [10.36.112.243] (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7449860C43;
        Wed, 16 Dec 2020 10:35:55 +0000 (UTC)
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
To:     Shenming Lu <lushenming@huawei.com>, Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
 <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
 <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
 <2ad38077300bdcaedd2e3b073cd36743@kernel.org>
 <9b80d460-e149-20c8-e9b3-e695310b4ed1@huawei.com>
 <274dafb2e21f49326a64bb575e668793@kernel.org>
 <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f8b398df-9945-9ce6-18e6-970637a1bb51@redhat.com>
Date:   Wed, 16 Dec 2020 11:35:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shenming,

On 12/1/20 1:15 PM, Shenming Lu wrote:
> On 2020/12/1 19:50, Marc Zyngier wrote:
>> On 2020-12-01 11:40, Shenming Lu wrote:
>>> On 2020/12/1 18:55, Marc Zyngier wrote:
>>>> On 2020-11-30 07:23, Shenming Lu wrote:
>>>>
>>>> Hi Shenming,
>>>>
>>>>> We are pondering over this problem these days, but still don't get a
>>>>> good solution...
>>>>> Could you give us some advice on this?
>>>>>
>>>>> Or could we move the restoring of the pending states (include the sync
>>>>> from guest RAM and the transfer to HW) to the GIC VM state change handler,
>>>>> which is completely corresponding to save_pending_tables (more symmetric?)
>>>>> and don't expose GICv4...
>>>>
>>>> What is "the GIC VM state change handler"? Is that a QEMU thing?
>>>
>>> Yeah, it is a a QEMU thing...
>>>
>>>> We don't really have that concept in KVM, so I'd appreciate if you could
>>>> be a bit more explicit on this.
>>>
>>> My thought is to add a new interface (to QEMU) for the restoring of
>>> the pending states, which is completely corresponding to
>>> KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES...
>>> And it is called from the GIC VM state change handler in QEMU, which
>>> is happening after the restoring (call kvm_vgic_v4_set_forwarding())
>>> but before the starting (running) of the VFIO device.
>>
>> Right, that makes sense. I still wonder how much the GIC save/restore
>> stuff differs from other architectures that implement similar features,
>> such as x86 with VT-D.
> 
> I am not familiar with it...
> 
>>
>> It is obviously too late to change the userspace interface, but I wonder
>> whether we missed something at the time.
> 
> The interface seems to be really asymmetrical?...

in qemu d5aa0c229a ("hw/intc/arm_gicv3_kvm: Implement pending table
save") commit message, it is traced:

"There is no explicit restore as the tables are implicitly sync'ed
on ITS table restore and on LPI enable at redistributor level."

At that time there was no real justification behind adding the RESTORE
fellow attr.

Maybe a stupid question but isn't it possible to unset the forwarding
when saving and rely on VFIO to automatically restore it when resuming
on destination?

Thanks

Eric


> 
> Or is there a possibility that we could know which irq is hw before the VFIO
> device calls kvm_vgic_v4_set_forwarding()?
> 
> Thanks,
> Shenming
> 
>>
>> Thanks,
>>
>>         M.
> 

