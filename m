Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9EB310390
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 04:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBED3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 22:29:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhBED3O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 22:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612495667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j6n+ZLbkq+mLCc6aBqP6EMe2QS0ih77l0I/R5zi2Q/k=;
        b=LfdOAVLyXLfWPbqHY6Ghg+KmAczp7R47J/NHlGH34JhiUCT9SCVcdU8eZUmGZdx6rl0FAz
        Nzoy1nH8HlvDOCMzwD7jr1d3BMKEdIfX9miw1n+NJqgrM8uy8MBxGNZB1J+knEATTZ/UqC
        PU1pIiqBannsa1VLX/X1CGU5g6z3WIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-GXHq2iLTMEGLcKpW42pIgQ-1; Thu, 04 Feb 2021 22:27:45 -0500
X-MC-Unique: GXHq2iLTMEGLcKpW42pIgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 171DE195D560;
        Fri,  5 Feb 2021 03:27:44 +0000 (UTC)
Received: from [10.72.12.112] (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90BAA60937;
        Fri,  5 Feb 2021 03:27:33 +0000 (UTC)
Subject: Re: [PATCH v3 09/13] vhost/vdpa: remove vhost_vdpa_config_validate()
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-10-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6919d2d4-cc8e-2b67-2385-35803de5e38b@redhat.com>
Date:   Fri, 5 Feb 2021 11:27:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210204172230.85853-10-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/5 上午1:22, Stefano Garzarella wrote:
> get_config() and set_config() callbacks in the 'struct vdpa_config_ops'
> usually already validated the inputs. Also now they can return an error,
> so we don't need to validate them here anymore.
>
> Let's use the return value of these callbacks and return it in case of
> error in vhost_vdpa_get_config() and vhost_vdpa_set_config().
>
> Originally-by: Xie Yongji <xieyongji@bytedance.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   drivers/vhost/vdpa.c | 41 +++++++++++++----------------------------
>   1 file changed, 13 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ef688c8c0e0e..d61e779000a8 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -185,51 +185,35 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>   	return 0;
>   }
>   
> -static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
> -				      struct vhost_vdpa_config *c)
> -{
> -	long size = 0;
> -
> -	switch (v->virtio_id) {
> -	case VIRTIO_ID_NET:
> -		size = sizeof(struct virtio_net_config);
> -		break;
> -	}
> -
> -	if (c->len == 0)
> -		return -EINVAL;
> -
> -	if (c->len > size - c->off)
> -		return -E2BIG;
> -
> -	return 0;
> -}
> -
>   static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>   				  struct vhost_vdpa_config __user *c)
>   {
>   	struct vdpa_device *vdpa = v->vdpa;
>   	struct vhost_vdpa_config config;
>   	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
> +	long ret;
>   	u8 *buf;
>   
>   	if (copy_from_user(&config, c, size))
>   		return -EFAULT;
> -	if (vhost_vdpa_config_validate(v, &config))
> +	if (config.len == 0)
>   		return -EINVAL;
>   	buf = kvzalloc(config.len, GFP_KERNEL);


Then it means usersapce can allocate a very large memory.

Rethink about this, we should limit the size here (e.g PAGE_SIZE) or 
fetch the config size first (either through a config ops as you 
suggested or a variable in the vdpa device that is initialized during 
device creation).

Thanks

>   	if (!buf)
>   		return -ENOMEM;
>   
> -	vdpa_get_config(vdpa, config.off, buf, config.len);
> +	ret = vdpa_get_config(vdpa, config.off, buf, config.len);
> +	if (ret)
> +		goto out;
>   
>   	if (copy_to_user(c->buf, buf, config.len)) {
> -		kvfree(buf);
> -		return -EFAULT;
> +		ret = -EFAULT;
> +		goto out;
>   	}
>   
> +out:
>   	kvfree(buf);
> -	return 0;
> +	return ret;
>   }
>   
>   static long vhost_vdpa_set_config(struct vhost_vdpa *v,
> @@ -239,21 +223,22 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>   	const struct vdpa_config_ops *ops = vdpa->config;
>   	struct vhost_vdpa_config config;
>   	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
> +	long ret;
>   	u8 *buf;
>   
>   	if (copy_from_user(&config, c, size))
>   		return -EFAULT;
> -	if (vhost_vdpa_config_validate(v, &config))
> +	if (config.len == 0)
>   		return -EINVAL;
>   
>   	buf = vmemdup_user(c->buf, config.len);
>   	if (IS_ERR(buf))
>   		return PTR_ERR(buf);
>   
> -	ops->set_config(vdpa, config.off, buf, config.len);
> +	ret = ops->set_config(vdpa, config.off, buf, config.len);
>   
>   	kvfree(buf);
> -	return 0;
> +	return ret;
>   }
>   
>   static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)

