Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C30B3306B5
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 05:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhCHD76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Mar 2021 22:59:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232429AbhCHD7Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 7 Mar 2021 22:59:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615175964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TGiugw84K0yAazMlXfQCN5eRxZQb5KNF3VYCr/dWXMU=;
        b=f4XyS8Z0ekXl8iXdU+zMKP/a8yWwNo9QmN9NeXILQhxIvTsq6aPBZk5qiz4kZP4W+Yn8hn
        btnhJOx2RsoIyJGHcEki+Lnv3Ercr6JoyfcGQLmV2zymfnAAOTSc7VmkGPzgcswMivwU+t
        2ubcT7IqxaVOpE+PX9cYi/mX9RXzx2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-oxtmNiEiPm-Tepl0IYgO_w-1; Sun, 07 Mar 2021 22:59:20 -0500
X-MC-Unique: oxtmNiEiPm-Tepl0IYgO_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7556226860;
        Mon,  8 Mar 2021 03:59:19 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F7B55B4B3;
        Mon,  8 Mar 2021 03:59:13 +0000 (UTC)
Subject: Re: [RFC PATCH 10/10] vhost/vdpa: return configuration bytes read and
 written to user space
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-11-sgarzare@redhat.com>
 <4d682ff2-9663-d6ac-d5bf-616b2bf96e1a@redhat.com>
 <20210302140654.ybmjqui5snp5wxym@steredhat>
 <5cf852b1-1279-20e9-516d-30f876e0162d@redhat.com>
 <20210305083712.atfrlpq6bkjrf6pd@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ec8dba28-820b-4948-999e-439e268b536c@redhat.com>
Date:   Mon, 8 Mar 2021 11:59:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305083712.atfrlpq6bkjrf6pd@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/3/5 4:37 下午, Stefano Garzarella wrote:
> On Thu, Mar 04, 2021 at 04:31:22PM +0800, Jason Wang wrote:
>>
>> On 2021/3/2 10:06 下午, Stefano Garzarella wrote:
>>> On Tue, Mar 02, 2021 at 12:05:35PM +0800, Jason Wang wrote:
>>>>
>>>> On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
>>>>> vdpa_get_config() and vdpa_set_config() now return the amount
>>>>> of bytes read and written, so let's return them to the user space.
>>>>>
>>>>> We also modify vhost_vdpa_config_validate() to return 0 (bytes read
>>>>> or written) instead of an error, when the buffer length is 0.
>>>>>
>>>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>>> ---
>>>>>  drivers/vhost/vdpa.c | 26 +++++++++++++++-----------
>>>>>  1 file changed, 15 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>> index 21eea2be5afa..b754c53171a7 100644
>>>>> --- a/drivers/vhost/vdpa.c
>>>>> +++ b/drivers/vhost/vdpa.c
>>>>> @@ -191,9 +191,6 @@ static ssize_t 
>>>>> vhost_vdpa_config_validate(struct vhost_vdpa *v,
>>>>>      struct vdpa_device *vdpa = v->vdpa;
>>>>>      u32 size = vdpa->config->get_config_size(vdpa);
>>>>> -    if (c->len == 0)
>>>>> -        return -EINVAL;
>>>>> -
>>>>>      return min(c->len, size);
>>>>>  }
>>>>> @@ -204,6 +201,7 @@ static long vhost_vdpa_get_config(struct 
>>>>> vhost_vdpa *v,
>>>>>      struct vhost_vdpa_config config;
>>>>>      unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>>>>      ssize_t config_size;
>>>>> +    long ret;
>>>>>      u8 *buf;
>>>>>      if (copy_from_user(&config, c, size))
>>>>> @@ -217,15 +215,18 @@ static long vhost_vdpa_get_config(struct 
>>>>> vhost_vdpa *v,
>>>>>      if (!buf)
>>>>>          return -ENOMEM;
>>>>> -    vdpa_get_config(vdpa, config.off, buf, config_size);
>>>>> -
>>>>> -    if (copy_to_user(c->buf, buf, config_size)) {
>>>>> -        kvfree(buf);
>>>>> -        return -EFAULT;
>>>>> +    ret = vdpa_get_config(vdpa, config.off, buf, config_size);
>>>>> +    if (ret < 0) {
>>>>> +        ret = -EFAULT;
>>>>> +        goto out;
>>>>>      }
>>>>> +    if (copy_to_user(c->buf, buf, config_size))
>>>>> +        ret = -EFAULT;
>>>>> +
>>>>> +out:
>>>>>      kvfree(buf);
>>>>> -    return 0;
>>>>> +    return ret;
>>>>>  }
>>>>>  static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>>>>> @@ -235,6 +236,7 @@ static long vhost_vdpa_set_config(struct 
>>>>> vhost_vdpa *v,
>>>>>      struct vhost_vdpa_config config;
>>>>>      unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>>>>      ssize_t config_size;
>>>>> +    long ret;
>>>>>      u8 *buf;
>>>>>      if (copy_from_user(&config, c, size))
>>>>> @@ -248,10 +250,12 @@ static long vhost_vdpa_set_config(struct 
>>>>> vhost_vdpa *v,
>>>>>      if (IS_ERR(buf))
>>>>>          return PTR_ERR(buf);
>>>>> -    vdpa_set_config(vdpa, config.off, buf, config_size);
>>>>> +    ret = vdpa_set_config(vdpa, config.off, buf, config_size);
>>>>> +    if (ret < 0)
>>>>> +        ret = -EFAULT;
>>>>>      kvfree(buf);
>>>>> -    return 0;
>>>>> +    return ret;
>>>>>  }
>>>>
>>>>
>>>> So I wonder whether it's worth to return the number of bytes since 
>>>> we can't propogate the result to driver or driver doesn't care 
>>>> about that.
>>>
>>> Okay, but IIUC user space application that issue 
>>> VHOST_VDPA_GET_CONFIG ioctl can use the return value.
>>
>>
>> Yes, but it looks to it's too late to change since it's a userspace 
>> noticble behaviour.
>
> Yeah, this is a good point.
> I looked at QEMU and we only check if the value is not negative, so it 
> should work, but for other applications it could be a real change.
>
> Do we leave it as is?


Yes, I think we'd better be conservative here.

Thanks


>
>>
>>
>>>
>>> Should we change also 'struct virtio_config_ops' to propagate this 
>>> value also to virtio drivers?
>>
>>
>> I think not, the reason is the driver doesn't expect the get()/set() 
>> can fail...
>
> Got it.
>
> Thanks,
> Stefano
>

