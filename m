Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB742CB2F7
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 03:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgLBCzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 21:55:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727590AbgLBCzh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 21:55:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606877650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9vqxpVgMGEKJ5/jWqjIrVL+uKldVNUjKodTeexFZtk0=;
        b=Bps/bCi6dqlQdYTKkqIXfSefIeqDT06uTaYE64Rc2lvUghpmWXEZQrIu+J0mdgR+0lWVJ1
        kbRWvSEVyDdGGSYOPaoCt8fw0uLgqrYjQL/vcaSc3TD//auxVK4jwZ8a8WFDvXWVTNaycy
        6zrDH/QTBT00qoEfZZEOVpu8aYWYlrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-Xdg-i7kgMneqoF3lACxVCQ-1; Tue, 01 Dec 2020 21:54:09 -0500
X-MC-Unique: Xdg-i7kgMneqoF3lACxVCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81255817B8C;
        Wed,  2 Dec 2020 02:54:07 +0000 (UTC)
Received: from [10.72.13.145] (ovpn-13-145.pek2.redhat.com [10.72.13.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB97660854;
        Wed,  2 Dec 2020 02:53:53 +0000 (UTC)
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, felipe@nutanix.com,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
 <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
 <20201126123659.GC1180457@stefanha-x1.localdomain>
 <c9f926fb-438c-9588-f018-dd040935e5e5@redhat.com>
 <20201127134403.GB46707@stefanha-x1.localdomain>
 <6001ed07-5823-365e-5235-8bfea0e72c7f@redhat.com>
 <20201130124702.GB422962@stefanha-x1.localdomain>
 <4c1af937-a176-be67-fbcc-2bcf965e0bbc@redhat.com>
 <20201201103516.GD567514@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d5ab77b8-63c0-8140-418e-59888e6c9ca8@redhat.com>
Date:   Wed, 2 Dec 2020 10:53:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201201103516.GD567514@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/12/1 下午6:35, Stefan Hajnoczi wrote:
> On Tue, Dec 01, 2020 at 12:05:04PM +0800, Jason Wang wrote:
>> On 2020/11/30 下午8:47, Stefan Hajnoczi wrote:
>>> On Mon, Nov 30, 2020 at 10:14:15AM +0800, Jason Wang wrote:
>>>> On 2020/11/27 下午9:44, Stefan Hajnoczi wrote:
>>>>> On Fri, Nov 27, 2020 at 11:39:23AM +0800, Jason Wang wrote:
>>>>>> On 2020/11/26 下午8:36, Stefan Hajnoczi wrote:
>>>>>>> On Thu, Nov 26, 2020 at 11:37:30AM +0800, Jason Wang wrote:
>>>>>>>> On 2020/11/26 上午3:21, Elena Afanasova wrote:
>>>>>> Or I wonder whether we can attach an eBPF program when trapping MMIO/PIO and
>>>>>> allow it to decide how to proceed?
>>>>> The eBPF program approach is interesting, but it would probably require
>>>>> access to guest RAM and additional userspace state (e.g. device-specific
>>>>> register values). I don't know the current status of Linux eBPF - is it
>>>>> possible to access user memory (it could be swapped out)?
>>>> AFAIK it doesn't, but just to make sure I understand, any reason that eBPF
>>>> need to access userspace memory here?
>>> Maybe we're thinking of different things. In the past I've thought about
>>> using eBPF to avoid a trip to userspace for request submission and
>>> completion, but that requires virtqueue parsing from eBPF and guest RAM
>>> access.
>>
>> I see. I've  considered something similar. e.g using eBPF dataplane in
>> vhost, but it requires a lot of work. For guest RAM access, we probably can
>> provide some eBPF helpers to do that but we need strong point to convince
>> eBPF guys.
>>
>>
>>> Are you thinking about replacing ioctl(KVM_SET_IOREGION) and all the
>>> necessary kvm.ko code with an ioctl(KVM_SET_IO_PROGRAM), where userspace
>>> can load an eBPF program into kvm.ko that gets executed when an MMIO/PIO
>>> accesses occur?
>>
>> Yes.
>>
>>
>>>    Wouldn't it need to write to userspace memory to store
>>> the ring index that was written to the doorbell register, for example?
>>
>> The proram itself can choose want to do:
>>
>> 1) do datamatch and write/wakeup eventfd
>>
>> or
>>
>> 2) transport the write via an arbitrary fd as what has been done in this
>> proposal, but the protocol is userspace defined
>>
>>> How would the program communicate with userspace (eventfd isn't enough)
>>> and how can it handle synchronous I/O accesses like reads?
>>
>> I may miss something, but it can behave exactly as what has been proposed in
>> this patch?
> I see. This seems to have two possible advantages:
> 1. Pushing the kvm.ko code into userspace thanks to eBPF. Less kernel
>     code.
> 2. Allowing more flexibile I/O dispatch logic (e.g. ioeventfd-style
>     datamatch) and communication protocols.
>
> I think #1 is minor because the communication protocol is trivial,
> struct kvm_io_device can be reused for dispatch, and eBPF will introduce
> some complexity itself.
>
> #2 is more interesting but I'm not sure how to use this extra
> flexibility to get a big advantage. Maybe vfio-user applications could
> install an eBPF program that speaks the vfio-user protocol instead of
> the ioregionfd protocol, making it easier to integrate ioregionfd into
> vfio-user programs?


Yes, that's could be one. Basically it shift the policy from kernel to 
userspace.


>
> My opinion is that eBPF complicates things and since we lack a strong
> use case for that extra flexibility, I would stick to the ioregionfd
> proposal.
>
> Elena, Jason: Do you have any opinions on this?


I agree. And we need a way to make it work without eBPF. Let's leave it 
for future investigation.

Thanks


>
> Stefan

