Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34653114A9
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 23:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhBEWLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 17:11:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232798AbhBEOk6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 09:40:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612541897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NnP5XCU4u3GLA5tU6K2RnQ5rd1UvAC9ZZ89SyiHV8bU=;
        b=jHWLp9fXeO5yPVNAl5Qq4lKE1QLdW9VH2ka22e3qy0V5gQLW8KBACGp0rXKIZnX4uXUJZB
        i77/O5NXtDuz+K3rDXVYd4x0R+76WGdCWSJ3ialrhOD4+u97xFBJFLOAy9MxLVkJtNvTLX
        tUSQ6q5VGdlCmSmMeTD2vpOpY7noVQc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-SJzwipg3OWqg1c6qqbbG9w-1; Fri, 05 Feb 2021 09:17:11 -0500
X-MC-Unique: SJzwipg3OWqg1c6qqbbG9w-1
Received: by mail-wr1-f72.google.com with SMTP id l7so5406710wrp.1
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 06:17:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NnP5XCU4u3GLA5tU6K2RnQ5rd1UvAC9ZZ89SyiHV8bU=;
        b=nOUtFAoUSzsmeebpwpNHSP1boTStmxRDtYyPx+/drBstmcIZx3KYUKA1aFx6umuZqq
         +CzKGv3keCJcDVCVuQVdarWiKXLX614YdNQqaQoH8tsksM/yOkGU395kMfI2sZcT2m+c
         Dq1uDUxbOdRliEG9rkx5D91TMG9cQllV51H0pSdon9ftd/lFpl9XwJvtLQBi6KPQApKx
         iLnDhlStlImsgBYWyNIKZc/MqKYUVle9aI3z0ewadHJzEYl/KyiTb2SuZh3C94b5hJ80
         fFbYTUliUO/TVWjkqwSXBok3lp1DeIs6+42b2a7D4y/1Im+eHNaS21Hf3ZF3PCs9x23z
         Eb/w==
X-Gm-Message-State: AOAM530jbKuvz2y5e0fpByaY3NXTCMSYzWjReZ4dwZWnzhTArP1WqsSx
        XVn0b7KkAkc7Es8hHKOy5x6Iapv9m3KhXPpchExgXRWn3H+r04yOt4meBo6QhySW86jrsaIasZo
        byxnrsyoMm8fh
X-Received: by 2002:a5d:453b:: with SMTP id j27mr5351075wra.92.1612534630613;
        Fri, 05 Feb 2021 06:17:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxoN6BUEbnc4t31XEyr636+ZdDqrgfqdIVz7cbLxF0zafdGnFimMKQJ7JMi3xLjdYuOKx6feA==
X-Received: by 2002:a5d:453b:: with SMTP id j27mr5351061wra.92.1612534630414;
        Fri, 05 Feb 2021 06:17:10 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v6sm12579287wrx.32.2021.02.05.06.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:17:09 -0800 (PST)
Date:   Fri, 5 Feb 2021 15:17:07 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/13] vhost/vdpa: remove vhost_vdpa_config_validate()
Message-ID: <20210205141707.clbckauxnrzd7nmv@steredhat>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-10-sgarzare@redhat.com>
 <6919d2d4-cc8e-2b67-2385-35803de5e38b@redhat.com>
 <20210205091651.xfcdyuvwwzew2ufo@steredhat>
 <20210205083108-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210205083108-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 08:32:37AM -0500, Michael S. Tsirkin wrote:
>On Fri, Feb 05, 2021 at 10:16:51AM +0100, Stefano Garzarella wrote:
>> On Fri, Feb 05, 2021 at 11:27:32AM +0800, Jason Wang wrote:
>> >
>> > On 2021/2/5 上午1:22, Stefano Garzarella wrote:
>> > > get_config() and set_config() callbacks in the 'struct vdpa_config_ops'
>> > > usually already validated the inputs. Also now they can return an error,
>> > > so we don't need to validate them here anymore.
>> > >
>> > > Let's use the return value of these callbacks and return it in case of
>> > > error in vhost_vdpa_get_config() and vhost_vdpa_set_config().
>> > >
>> > > Originally-by: Xie Yongji <xieyongji@bytedance.com>
>> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > ---
>> > >  drivers/vhost/vdpa.c | 41 +++++++++++++----------------------------
>> > >  1 file changed, 13 insertions(+), 28 deletions(-)
>> > >
>> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> > > index ef688c8c0e0e..d61e779000a8 100644
>> > > --- a/drivers/vhost/vdpa.c
>> > > +++ b/drivers/vhost/vdpa.c
>> > > @@ -185,51 +185,35 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>> > >  	return 0;
>> > >  }
>> > > -static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
>> > > -				      struct vhost_vdpa_config *c)
>> > > -{
>> > > -	long size = 0;
>> > > -
>> > > -	switch (v->virtio_id) {
>> > > -	case VIRTIO_ID_NET:
>> > > -		size = sizeof(struct virtio_net_config);
>> > > -		break;
>> > > -	}
>> > > -
>> > > -	if (c->len == 0)
>> > > -		return -EINVAL;
>> > > -
>> > > -	if (c->len > size - c->off)
>> > > -		return -E2BIG;
>> > > -
>> > > -	return 0;
>> > > -}
>> > > -
>> > >  static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>> > >  				  struct vhost_vdpa_config __user *c)
>> > >  {
>> > >  	struct vdpa_device *vdpa = v->vdpa;
>> > >  	struct vhost_vdpa_config config;
>> > >  	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>> > > +	long ret;
>> > >  	u8 *buf;
>> > >  	if (copy_from_user(&config, c, size))
>> > >  		return -EFAULT;
>> > > -	if (vhost_vdpa_config_validate(v, &config))
>> > > +	if (config.len == 0)
>> > >  		return -EINVAL;
>> > >  	buf = kvzalloc(config.len, GFP_KERNEL);
>> >
>> >
>> > Then it means usersapce can allocate a very large memory.
>>
>> Good point.
>>
>> >
>> > Rethink about this, we should limit the size here (e.g PAGE_SIZE) or
>> > fetch the config size first (either through a config ops as you
>> > suggested or a variable in the vdpa device that is initialized during
>> > device creation).
>>
>> Maybe PAGE_SIZE is okay as a limit.
>>
>> If instead we want to fetch the config size, then better a config ops in my
>> opinion, to avoid adding a new parameter to __vdpa_alloc_device().
>>
>> I vote for PAGE_SIZE, but it isn't a strong opinion.
>>
>> What do you and @Michael suggest?
>>
>> Thanks,
>> Stefano
>
>Devices know what the config size is. Just have them provide it.
>

Okay, I'll add get_config_size() callback in vdpa_config_ops and I'll 
leave vhost_vdpa_config_validate() that will use that callback instead 
of 'virtio_id' to get the config size from the device.

At this point I think I can remove the "vdpa: add return value to 
get_config/set_config callbacks" patch and leave void return to 
get_config/set_config callbacks.

Does this make sense?

Thanks,
Stefano

