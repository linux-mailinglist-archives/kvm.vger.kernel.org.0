Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E36E36E429
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 06:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhD2ERj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 00:17:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231874AbhD2ERi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 00:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619669803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/QUY4qCTlUpRklnkagB+tJ3wFuKq8JIyfGnRJ0ldCk=;
        b=b9+KISNKLwYCiGKDw2954hB35/fGFQt9Bpb2TFzs4He3xjCIM3qjTHk58xfH7txjP8gEi6
        rggaEwoIJWpKK6sfY9DuvFuq2rJ+c5Uj5vRdagW4TxDbGYh1qoC1kLuciREsRw78jk7D7Q
        Hns+kazdIlHUHsssJuczbYQw9D4Rpp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-OyWakbAFOPmsSM8Iu953tQ-1; Thu, 29 Apr 2021 00:16:39 -0400
X-MC-Unique: OyWakbAFOPmsSM8Iu953tQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D06BD802938;
        Thu, 29 Apr 2021 04:16:37 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-162.pek2.redhat.com [10.72.13.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEC8D6A967;
        Thu, 29 Apr 2021 04:16:26 +0000 (UTC)
Subject: Re: [RFC PATCH 0/7] Untrusted device support for virtio
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, kvm@vger.kernel.org
References: <20210421032117.5177-1-jasowang@redhat.com>
 <YInOQt1l/59zzPJK@Konrads-MacBook-Pro.local>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9b089e3b-7d7a-b9d6-a4a1-81a6eff2e425@redhat.com>
Date:   Thu, 29 Apr 2021 12:16:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YInOQt1l/59zzPJK@Konrads-MacBook-Pro.local>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/4/29 ÉÏÎç5:06, Konrad Rzeszutek Wilk Ð´µÀ:
> On Wed, Apr 21, 2021 at 11:21:10AM +0800, Jason Wang wrote:
>> Hi All:
>>
>> Sometimes, the driver doesn't trust the device. This is usually
>> happens for the encrtpyed VM or VDUSE[1]. In both cases, technology
>> like swiotlb is used to prevent the poking/mangling of memory from the
>> device. But this is not sufficient since current virtio driver may
>> trust what is stored in the descriptor table (coherent mapping) for
>> performing the DMA operations like unmap and bounce so the device may
>> choose to utilize the behaviour of swiotlb to perform attacks[2].
> We fixed it in the SWIOTLB. That is it saves the expected length
> of the DMA operation. See
>
> commit daf9514fd5eb098d7d6f3a1247cb8cc48fc94155
> Author: Martin Radev <martin.b.radev@gmail.com>
> Date:   Tue Jan 12 16:07:29 2021 +0100
>
>      swiotlb: Validate bounce size in the sync/unmap path
>      
>      The size of the buffer being bounced is not checked if it happens
>      to be larger than the size of the mapped buffer. Because the size
>      can be controlled by a device, as it's the case with virtio devices,
>      this can lead to memory corruption.
>      


Good to know this, but this series tries to protect at different level. 
And I believe such protection needs to be done at both levels.


>> For double insurance, to protect from a malicous device, when DMA API
>> is used for the device, this series store and use the descriptor
>> metadata in an auxiliay structure which can not be accessed via
>> swiotlb instead of the ones in the descriptor table. Actually, we've
> Sorry for being dense here, but how wold SWIOTLB be utilized for
> this attack?


So we still behaviors that is triggered by device that is not trusted. 
Such behavior is what the series tries to avoid. We've learnt a lot of 
lessons to eliminate the potential attacks via this. And it would be too 
late to fix if we found another issue of SWIOTLB.

Proving "the unexpected device triggered behavior is safe" is very hard 
(or even impossible) than "eliminating the unexpected device triggered 
behavior totally".

E.g I wonder whether something like this can happen: Consider the DMA 
direction of unmap is under the control of device. The device can cheat 
the SWIOTLB by changing the flag to modify the device read only buffer. 
If yes, it is really safe?

The above patch only log the bounce size but it doesn't log the flag. 
Even if it logs the flag, SWIOTLB still doesn't know how each buffer is 
used and when it's the appropriate(safe) time to unmap the buffer, only 
the driver that is using the SWIOTLB know them.

So I think we need to consolidate on both layers instead of solely 
depending on the SWIOTLB.

Thanks


>
>> almost achieved that through packed virtqueue and we just need to fix
>> a corner case of handling mapping errors. For split virtqueue we just
>> follow what's done in the packed.
>>
>> Note that we don't duplicate descriptor medata for indirect
>> descriptors since it uses stream mapping which is read only so it's
>> safe if the metadata of non-indirect descriptors are correct.
>>
>> The behaivor for non DMA API is kept for minimizing the performance
>> impact.
>>
>> Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
>> the guest.
>>
>> Please review.
>>
>> [1] https://lore.kernel.org/netdev/fab615ce-5e13-a3b3-3715-a4203b4ab010@redhat.com/T/
>> [2] https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
>>
>> Jason Wang (7):
>>    virtio-ring: maintain next in extra state for packed virtqueue
>>    virtio_ring: rename vring_desc_extra_packed
>>    virtio-ring: factor out desc_extra allocation
>>    virtio_ring: secure handling of mapping errors
>>    virtio_ring: introduce virtqueue_desc_add_split()
>>    virtio: use err label in __vring_new_virtqueue()
>>    virtio-ring: store DMA metadata in desc_extra for split virtqueue
>>
>>   drivers/virtio/virtio_ring.c | 189 ++++++++++++++++++++++++++---------
>>   1 file changed, 141 insertions(+), 48 deletions(-)
>>
>> -- 
>> 2.25.1
>>

