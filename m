Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D899F3129B0
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 05:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBHEPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 23:15:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229646AbhBHEPD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 7 Feb 2021 23:15:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612757616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OwbGbSWL1LBJv8uhMlfeoPlfAVlcGee31SXrkqRKFhU=;
        b=MtT7LtyUeqqFl2NKCQi1OX8pGmOci+Y7SDP9/ZgnNZ/dNfIB51glaxuK4+MX4w+hrdBCYu
        ZHNI1Yfwu1AzrVYnopFPbhlA0Vq2OGZzgUDBFsQeSIMhAf4S3bS2QG47FnwQtAtl+541F8
        Om+src0ceGIGg+doUeC1/q/k/kueoRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-Ncn5d9ULMziacd2DWrxyRg-1; Sun, 07 Feb 2021 23:13:35 -0500
X-MC-Unique: Ncn5d9ULMziacd2DWrxyRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC93A427C1;
        Mon,  8 Feb 2021 04:13:33 +0000 (UTC)
Received: from [10.72.13.185] (ovpn-13-185.pek2.redhat.com [10.72.13.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97DF262A22;
        Mon,  8 Feb 2021 04:13:24 +0000 (UTC)
Subject: Re: [PATCH v3 09/13] vhost/vdpa: remove vhost_vdpa_config_validate()
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-10-sgarzare@redhat.com>
 <6919d2d4-cc8e-2b67-2385-35803de5e38b@redhat.com>
 <20210205091651.xfcdyuvwwzew2ufo@steredhat>
 <20210205083108-mutt-send-email-mst@kernel.org>
 <20210205141707.clbckauxnrzd7nmv@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d86393d3-67b6-6524-5f9f-8634ec4f9b8f@redhat.com>
Date:   Mon, 8 Feb 2021 12:13:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210205141707.clbckauxnrzd7nmv@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/5 下午10:17, Stefano Garzarella wrote:
> On Fri, Feb 05, 2021 at 08:32:37AM -0500, Michael S. Tsirkin wrote:
>> On Fri, Feb 05, 2021 at 10:16:51AM +0100, Stefano Garzarella wrote:
>>> On Fri, Feb 05, 2021 at 11:27:32AM +0800, Jason Wang wrote:
>>> >
>>> > On 2021/2/5 上午1:22, Stefano Garzarella wrote:
>>> > > get_config() and set_config() callbacks in the 'struct 
>>> vdpa_config_ops'
>>> > > usually already validated the inputs. Also now they can return 
>>> an error,
>>> > > so we don't need to validate them here anymore.
>>> > >
>>> > > Let's use the return value of these callbacks and return it in 
>>> case of
>>> > > error in vhost_vdpa_get_config() and vhost_vdpa_set_config().
>>> > >
>>> > > Originally-by: Xie Yongji <xieyongji@bytedance.com>
>>> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> > > ---
>>> > >  drivers/vhost/vdpa.c | 41 
>>> +++++++++++++----------------------------
>>> > >  1 file changed, 13 insertions(+), 28 deletions(-)
>>> > >
>>> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> > > index ef688c8c0e0e..d61e779000a8 100644
>>> > > --- a/drivers/vhost/vdpa.c
>>> > > +++ b/drivers/vhost/vdpa.c
>>> > > @@ -185,51 +185,35 @@ static long vhost_vdpa_set_status(struct 
>>> vhost_vdpa *v, u8 __user *statusp)
>>> > >      return 0;
>>> > >  }
>>> > > -static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
>>> > > -                      struct vhost_vdpa_config *c)
>>> > > -{
>>> > > -    long size = 0;
>>> > > -
>>> > > -    switch (v->virtio_id) {
>>> > > -    case VIRTIO_ID_NET:
>>> > > -        size = sizeof(struct virtio_net_config);
>>> > > -        break;
>>> > > -    }
>>> > > -
>>> > > -    if (c->len == 0)
>>> > > -        return -EINVAL;
>>> > > -
>>> > > -    if (c->len > size - c->off)
>>> > > -        return -E2BIG;
>>> > > -
>>> > > -    return 0;
>>> > > -}
>>> > > -
>>> > >  static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>>> > >                    struct vhost_vdpa_config __user *c)
>>> > >  {
>>> > >      struct vdpa_device *vdpa = v->vdpa;
>>> > >      struct vhost_vdpa_config config;
>>> > >      unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>> > > +    long ret;
>>> > >      u8 *buf;
>>> > >      if (copy_from_user(&config, c, size))
>>> > >          return -EFAULT;
>>> > > -    if (vhost_vdpa_config_validate(v, &config))
>>> > > +    if (config.len == 0)
>>> > >          return -EINVAL;
>>> > >      buf = kvzalloc(config.len, GFP_KERNEL);
>>> >
>>> >
>>> > Then it means usersapce can allocate a very large memory.
>>>
>>> Good point.
>>>
>>> >
>>> > Rethink about this, we should limit the size here (e.g PAGE_SIZE) or
>>> > fetch the config size first (either through a config ops as you
>>> > suggested or a variable in the vdpa device that is initialized during
>>> > device creation).
>>>
>>> Maybe PAGE_SIZE is okay as a limit.
>>>
>>> If instead we want to fetch the config size, then better a config 
>>> ops in my
>>> opinion, to avoid adding a new parameter to __vdpa_alloc_device().
>>>
>>> I vote for PAGE_SIZE, but it isn't a strong opinion.
>>>
>>> What do you and @Michael suggest?
>>>
>>> Thanks,
>>> Stefano
>>
>> Devices know what the config size is. Just have them provide it.
>>
>
> Okay, I'll add get_config_size() callback in vdpa_config_ops and I'll 
> leave vhost_vdpa_config_validate() that will use that callback instead 
> of 'virtio_id' to get the config size from the device.
>
> At this point I think I can remove the "vdpa: add return value to 
> get_config/set_config callbacks" patch and leave void return to 
> get_config/set_config callbacks.
>
> Does this make sense?
>
> Thanks,
> Stefano


Yes I think so.

Thanks


