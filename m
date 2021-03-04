Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E8832CE8E
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 09:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbhCDIdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 03:33:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235797AbhCDIdH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 03:33:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614846701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cIgimn0UIHHj/HcSM5k1NV19AV4eDUyhIzCAKNQZCBo=;
        b=RYcq6oPe08TTC5sNKOIkI5Ay21FDF4AQOmgjBWn7gGhY/4kz6ZeH/893cAp3bswmXGe95L
        RKsjdopls6GopzuItnqLfhrIGICcGk9bfcEkS5wYOwULmo5Q4EHv7M01NRvEXwpeYXQ23f
        WbrCuupwrf3+XIv9Ac1N9ieW7O+jRxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-s5snE4gtMi-DtQ6TIJq10Q-1; Thu, 04 Mar 2021 03:31:37 -0500
X-MC-Unique: s5snE4gtMi-DtQ6TIJq10Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FFC01009E25;
        Thu,  4 Mar 2021 08:31:36 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1AB55C304;
        Thu,  4 Mar 2021 08:31:23 +0000 (UTC)
Subject: Re: [RFC PATCH 10/10] vhost/vdpa: return configuration bytes read and
 written to user space
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-11-sgarzare@redhat.com>
 <4d682ff2-9663-d6ac-d5bf-616b2bf96e1a@redhat.com>
 <20210302140654.ybmjqui5snp5wxym@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5cf852b1-1279-20e9-516d-30f876e0162d@redhat.com>
Date:   Thu, 4 Mar 2021 16:31:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302140654.ybmjqui5snp5wxym@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/3/2 10:06 下午, Stefano Garzarella wrote:
> On Tue, Mar 02, 2021 at 12:05:35PM +0800, Jason Wang wrote:
>>
>> On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
>>> vdpa_get_config() and vdpa_set_config() now return the amount
>>> of bytes read and written, so let's return them to the user space.
>>>
>>> We also modify vhost_vdpa_config_validate() to return 0 (bytes read
>>> or written) instead of an error, when the buffer length is 0.
>>>
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> ---
>>>  drivers/vhost/vdpa.c | 26 +++++++++++++++-----------
>>>  1 file changed, 15 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> index 21eea2be5afa..b754c53171a7 100644
>>> --- a/drivers/vhost/vdpa.c
>>> +++ b/drivers/vhost/vdpa.c
>>> @@ -191,9 +191,6 @@ static ssize_t vhost_vdpa_config_validate(struct 
>>> vhost_vdpa *v,
>>>      struct vdpa_device *vdpa = v->vdpa;
>>>      u32 size = vdpa->config->get_config_size(vdpa);
>>> -    if (c->len == 0)
>>> -        return -EINVAL;
>>> -
>>>      return min(c->len, size);
>>>  }
>>> @@ -204,6 +201,7 @@ static long vhost_vdpa_get_config(struct 
>>> vhost_vdpa *v,
>>>      struct vhost_vdpa_config config;
>>>      unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>>      ssize_t config_size;
>>> +    long ret;
>>>      u8 *buf;
>>>      if (copy_from_user(&config, c, size))
>>> @@ -217,15 +215,18 @@ static long vhost_vdpa_get_config(struct 
>>> vhost_vdpa *v,
>>>      if (!buf)
>>>          return -ENOMEM;
>>> -    vdpa_get_config(vdpa, config.off, buf, config_size);
>>> -
>>> -    if (copy_to_user(c->buf, buf, config_size)) {
>>> -        kvfree(buf);
>>> -        return -EFAULT;
>>> +    ret = vdpa_get_config(vdpa, config.off, buf, config_size);
>>> +    if (ret < 0) {
>>> +        ret = -EFAULT;
>>> +        goto out;
>>>      }
>>> +    if (copy_to_user(c->buf, buf, config_size))
>>> +        ret = -EFAULT;
>>> +
>>> +out:
>>>      kvfree(buf);
>>> -    return 0;
>>> +    return ret;
>>>  }
>>>  static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>>> @@ -235,6 +236,7 @@ static long vhost_vdpa_set_config(struct 
>>> vhost_vdpa *v,
>>>      struct vhost_vdpa_config config;
>>>      unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>>      ssize_t config_size;
>>> +    long ret;
>>>      u8 *buf;
>>>      if (copy_from_user(&config, c, size))
>>> @@ -248,10 +250,12 @@ static long vhost_vdpa_set_config(struct 
>>> vhost_vdpa *v,
>>>      if (IS_ERR(buf))
>>>          return PTR_ERR(buf);
>>> -    vdpa_set_config(vdpa, config.off, buf, config_size);
>>> +    ret = vdpa_set_config(vdpa, config.off, buf, config_size);
>>> +    if (ret < 0)
>>> +        ret = -EFAULT;
>>>      kvfree(buf);
>>> -    return 0;
>>> +    return ret;
>>>  }
>>
>>
>> So I wonder whether it's worth to return the number of bytes since we 
>> can't propogate the result to driver or driver doesn't care about that.
>
> Okay, but IIUC user space application that issue VHOST_VDPA_GET_CONFIG 
> ioctl can use the return value.


Yes, but it looks to it's too late to change since it's a userspace 
noticble behaviour.


>
> Should we change also 'struct virtio_config_ops' to propagate this 
> value also to virtio drivers?


I think not, the reason is the driver doesn't expect the get()/set() can 
fail...

Thanks


>
> Thanks,
> Stefano
>

