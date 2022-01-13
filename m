Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8723748DA96
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 16:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiAMPTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 10:19:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236053AbiAMPTy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 10:19:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642087193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NnVmdo4eA3jgB9H6nwQxP3p+2r7UOf/6AXY2LS6emsY=;
        b=Ad3xZTmx5jZGtH4TTfEF52EHvcKw5GTQOtatkHmn8EtifvQa6HscYajx8FMzKNV+aJf8fx
        dzBcacccSq/qxzl6lQI+KHS1nbmTnVRWso9xzGZmKBZuuL1rQ+1yXCMMh7nQ95VxFvh8Zp
        Sw4ugVnc67Z7v1JC8DbmeTAgRyn5+Fg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-wqjUgLKsOj-tiDFTNGSa2w-1; Thu, 13 Jan 2022 10:19:51 -0500
X-MC-Unique: wqjUgLKsOj-tiDFTNGSa2w-1
Received: by mail-ed1-f70.google.com with SMTP id m16-20020a056402431000b003fb60bbe0e2so5639041edc.3
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 07:19:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NnVmdo4eA3jgB9H6nwQxP3p+2r7UOf/6AXY2LS6emsY=;
        b=g+tVoKvQrwL2p+vi99BxKZfs9W8jwlyC+cc4VJH5XxA6+15+rtMjV1Sy5tBP9qWl/t
         ZJkyEc7mOnC7eVBKCjDpO7iagl8al7GiJATujGvADa2W6eGF/WiHOYOu6FnSo/kMZz2Z
         0T2U7/D52P8kTu/hzum26H75j4K3+BDtAtxaIbJ4GZZMTMQrk0EklLcMlqG6K3bcvzZH
         9xlYGQ1IE4MUNweY1mOYr4r4K78/YLBz0LI/VWTsi2LPu+qlWC/wlVjSdbBZPhmrS+F+
         QCj3VTyBnfZuyghV1iu8aoEOTZzTBW2HgoVG389Pb/2gpoac11LjtkCOCfDKmjG4vaDA
         4crA==
X-Gm-Message-State: AOAM530nurecJVVu5oqKVedyDrPujqqtZyLy8icVRAEA2lQx0/yHBYgw
        3U5eDFcv4XpMv0ihb1WqQWTaRCOPPgvdnw9kCjfCKCesesU22NonutF5t6iCstXBebNbb6Ex16P
        hfD7T1XMj/SG8
X-Received: by 2002:a17:906:7942:: with SMTP id l2mr4109128ejo.730.1642087190542;
        Thu, 13 Jan 2022 07:19:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzY9l0dMwz3EJs33yEWQDUQD/vM85TTnjGbfUdGlr/uzrnbvqMxaz/IW8imPgv8gALNSSrBgA==
X-Received: by 2002:a17:906:7942:: with SMTP id l2mr4109114ejo.730.1642087190356;
        Thu, 13 Jan 2022 07:19:50 -0800 (PST)
Received: from redhat.com ([2.55.154.210])
        by smtp.gmail.com with ESMTPSA id m12sm1309096edd.86.2022.01.13.07.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 07:19:49 -0800 (PST)
Date:   Thu, 13 Jan 2022 10:19:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stefanha@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220113101922-mutt-send-email-mst@kernel.org>
References: <20220113145642.205388-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113145642.205388-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 03:56:42PM +0100, Stefano Garzarella wrote:
> In vhost_enable_notify() we enable the notifications and we read
> the avail index to check if new buffers have become available in
> the meantime. In this case, the device would go to re-read avail
> index to access the descriptor.
> 
> As we already do in other place, we can cache the value in `avail_idx`
> and compare it with `last_avail_idx` to check if there are new
> buffers available.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

I guess we can ... but what's the point?

> ---
>  drivers/vhost/vhost.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..07363dff559e 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2543,8 +2543,9 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>  		       &vq->avail->idx, r);
>  		return false;
>  	}
> +	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
>  
> -	return vhost16_to_cpu(vq, avail_idx) != vq->avail_idx;
> +	return vq->avail_idx != vq->last_avail_idx;
>  }
>  EXPORT_SYMBOL_GPL(vhost_enable_notify);
>  
> -- 
> 2.31.1

