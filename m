Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA9B32A6E0
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578979AbhCBPyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:54:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238040AbhCBEIr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 23:08:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614657946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AiqlnBbL124RbFr+ZWPEGMV28LDKcaWTVjjFw6NK3tk=;
        b=IcpbLi6pbx7tXg8V1zCZNZHg/VqgW0379ZAxGz1km3KG/Af3u5L7sE4vgY5jL3/vKXd7nR
        WJnG0gQfqhCI0e7zHGQ7cKO4iI8pmbZJsUFGZFCntMTzY+hLWmuBkgme1qWG0GnOfKlXqw
        LzmTyvgeDRuCkQVH3FqHH+vcem8QXWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-Z7l6R31lOImEgMGWxzuctg-1; Mon, 01 Mar 2021 23:05:43 -0500
X-MC-Unique: Z7l6R31lOImEgMGWxzuctg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BCDC107ACE3;
        Tue,  2 Mar 2021 04:05:42 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-215.pek2.redhat.com [10.72.13.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4F5E1A7D9;
        Tue,  2 Mar 2021 04:05:37 +0000 (UTC)
Subject: Re: [RFC PATCH 10/10] vhost/vdpa: return configuration bytes read and
 written to user space
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-11-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4d682ff2-9663-d6ac-d5bf-616b2bf96e1a@redhat.com>
Date:   Tue, 2 Mar 2021 12:05:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210216094454.82106-11-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
> vdpa_get_config() and vdpa_set_config() now return the amount
> of bytes read and written, so let's return them to the user space.
>
> We also modify vhost_vdpa_config_validate() to return 0 (bytes read
> or written) instead of an error, when the buffer length is 0.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   drivers/vhost/vdpa.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 21eea2be5afa..b754c53171a7 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -191,9 +191,6 @@ static ssize_t vhost_vdpa_config_validate(struct vhost_vdpa *v,
>   	struct vdpa_device *vdpa = v->vdpa;
>   	u32 size = vdpa->config->get_config_size(vdpa);
>   
> -	if (c->len == 0)
> -		return -EINVAL;
> -
>   	return min(c->len, size);
>   }
>   
> @@ -204,6 +201,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>   	struct vhost_vdpa_config config;
>   	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>   	ssize_t config_size;
> +	long ret;
>   	u8 *buf;
>   
>   	if (copy_from_user(&config, c, size))
> @@ -217,15 +215,18 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>   	if (!buf)
>   		return -ENOMEM;
>   
> -	vdpa_get_config(vdpa, config.off, buf, config_size);
> -
> -	if (copy_to_user(c->buf, buf, config_size)) {
> -		kvfree(buf);
> -		return -EFAULT;
> +	ret = vdpa_get_config(vdpa, config.off, buf, config_size);
> +	if (ret < 0) {
> +		ret = -EFAULT;
> +		goto out;
>   	}
>   
> +	if (copy_to_user(c->buf, buf, config_size))
> +		ret = -EFAULT;
> +
> +out:
>   	kvfree(buf);
> -	return 0;
> +	return ret;
>   }
>   
>   static long vhost_vdpa_set_config(struct vhost_vdpa *v,
> @@ -235,6 +236,7 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>   	struct vhost_vdpa_config config;
>   	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>   	ssize_t config_size;
> +	long ret;
>   	u8 *buf;
>   
>   	if (copy_from_user(&config, c, size))
> @@ -248,10 +250,12 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>   	if (IS_ERR(buf))
>   		return PTR_ERR(buf);
>   
> -	vdpa_set_config(vdpa, config.off, buf, config_size);
> +	ret = vdpa_set_config(vdpa, config.off, buf, config_size);
> +	if (ret < 0)
> +		ret = -EFAULT;
>   
>   	kvfree(buf);
> -	return 0;
> +	return ret;
>   }


So I wonder whether it's worth to return the number of bytes since we 
can't propogate the result to driver or driver doesn't care about that.

Thanks


>   
>   static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)

