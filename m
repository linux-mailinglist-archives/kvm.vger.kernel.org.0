Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1930B5D0
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 04:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhBBD2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 22:28:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230470AbhBBD2M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 22:28:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612236405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+0xoBytfYFL452jZI7eq1Xid/1xoGVklSAHoMYfbNM=;
        b=aYdKwX0K5+LQhpaHi3Ea8dIyR0mSy+ekoTAr1PSehhKxCxmLBjigo5SeCGfSLIaQctMU2U
        3hFPs0lb9o0iZOW5wllFxuCoPHCz6Y+E6SxLMDV7gGywni2Wi7Ska/O1SuacJsxjXkJf2l
        LAedpvdMygasiCN9gj/zHNmwzuWoXGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-1axtorIiNDm0hWhRTR7PxA-1; Mon, 01 Feb 2021 22:26:44 -0500
X-MC-Unique: 1axtorIiNDm0hWhRTR7PxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17B6C803623;
        Tue,  2 Feb 2021 03:26:43 +0000 (UTC)
Received: from [10.72.13.250] (ovpn-13-250.pek2.redhat.com [10.72.13.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D8EA5D9CA;
        Tue,  2 Feb 2021 03:26:32 +0000 (UTC)
Subject: Re: [PATCH RFC v2 03/10] vringh: reset kiov 'consumed' field in
 __vringh_iov()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-4-sgarzare@redhat.com>
 <62bb2e93-4ac3-edf5-2baa-4c2be8257cf0@redhat.com>
 <20210201102120.kvbpbne3spaqv6yz@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <55287f2f-0288-ac07-8232-787612c00290@redhat.com>
Date:   Tue, 2 Feb 2021 11:26:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210201102120.kvbpbne3spaqv6yz@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/1 下午6:21, Stefano Garzarella wrote:
> On Mon, Feb 01, 2021 at 01:40:01PM +0800, Jason Wang wrote:
>>
>> On 2021/1/28 下午10:41, Stefano Garzarella wrote:
>>> __vringh_iov() overwrites the contents of riov and wiov, in fact it
>>> resets the 'i' and 'used' fields, but also the consumed field should
>>> be reset to avoid an inconsistent state.
>>>
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>>
>> I had a question(I remember we had some discussion like this but I 
>> forget the conclusion):
>
> Sorry, I forgot to update you.
>
>>
>> I see e.g in vringh_getdesc_kern() it has the following comment:
>>
>> /*
>>  * Note that you may need to clean up riov and wiov, even on error!
>>  */
>>
>> So it looks to me the correct way is to call vringh_kiov_cleanup() 
>> before?
>
> Looking at the code the right pattern should be:
>
>     vringh_getdesc_*(..., &out_iov, &in_iov, ...);
>
>     // use out_iov and in_iov
>
>     vringh_kiov_cleanup(&out_iov);
>     vringh_kiov_cleanup(&in_iov);
>
> This because vringh_getdesc_*() calls __vringh_iov() where 
> resize_iovec() is called to allocate the iov wrapped by 'struct 
> vringh_kiov' and vringh_kiov_cleanup() frees that memory.
>
> Looking better, __vringh_iov() is able to extend a 'vringh_kiov' 
> pre-allocated, so in order to avoid to allocate and free the iov for 
> each request we can avoid to call vringh_kiov_cleanup(), but this 
> patch is needed to avoid an inconsistent state.
>
> And also patch "vdpa_sim: cleanup kiovs in vdpasim_free()" is required 
> to free the iov when the device is going away.
>
> Does that make sense to you?


Make sense.


>
> Maybe I should add a comment in vringh.c to explain this better.


Yes, please.

Thanks


>
> Thanks,
> Stefano
>
>>
>> Thanks
>>
>>
>>> ---
>>>  drivers/vhost/vringh.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>>> index f68122705719..bee63d68201a 100644
>>> --- a/drivers/vhost/vringh.c
>>> +++ b/drivers/vhost/vringh.c
>>> @@ -290,9 +290,9 @@ __vringh_iov(struct vringh *vrh, u16 i,
>>>          return -EINVAL;
>>>      if (riov)
>>> -        riov->i = riov->used = 0;
>>> +        riov->i = riov->used = riov->consumed = 0;
>>>      if (wiov)
>>> -        wiov->i = wiov->used = 0;
>>> +        wiov->i = wiov->used = wiov->consumed = 0;
>>>      for (;;) {
>>>          void *addr;
>>
>

