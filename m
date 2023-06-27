Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D71740254
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjF0RhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 13:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjF0RhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 13:37:12 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556DD272D;
        Tue, 27 Jun 2023 10:37:11 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b7db2e162cso19065735ad.1;
        Tue, 27 Jun 2023 10:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687887431; x=1690479431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9jrnt+MmJKUYvCt2TBQZCoAXPj+BR7ObJDIcBWoLltM=;
        b=fMVqxpqFDIZeWw2s+njNjftXa7SeHIKEqOXAF1O1i/CkGCjB5kgjVRxXKk7hUHbFwa
         HjcGS/m0mm9WAANhdhb+nz4SMAQ3mN+rChiIsxP8mr/8z0KsP8QgMYTVgdjZ7PvOSXBz
         GzRHMlXleSZ6y80j63vAdmqx9eJAm5jQoBOxypiIq5A9dzj10nB9hrF5xSdsHxIxNJ9F
         VOuQBbTb1qAL/09MH+WPgynqhZbmr6k7aoc9gHyuQmGiF3EEu5hbFyuBqMG0f78+hTDF
         61zB+FW6VQ4Sxz4hk8SiDNuimg879WL1xiI8dyuRurzC/jozDWXVF3c/9Krav/WJz9w0
         Pxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687887431; x=1690479431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9jrnt+MmJKUYvCt2TBQZCoAXPj+BR7ObJDIcBWoLltM=;
        b=O1JeZ1N5C+DGkskpVfdFTFPuT4g+ASykIY9LUB4wsaQykg//tZXzJVWi3CuPeRwlM1
         8VBEsL+LQx0+uvK+r6mdWQ9LNPK0s0nElXrp1l9x3uqntYp+XPQCvCUxLJ0zzrxoXyLm
         cOUIXeaGsiMAEqpSRBX5Z1iSWLbssj59xBHN6hbQdNal7vSeFFLAgtN90DWj0Ia4YeQl
         qRsv6LWFqbXrUr4v8Bf1MDvBljyGlcKy0c41CIlxI2Zj75wIyMH7VyDkMdrbJbZYALFg
         oYHkxlTOb25paKKGqFKDIKWOaG4EYj6fd/9ou7ek44zYc1MWsomeKLUx2MFdVh4CE25i
         oSXw==
X-Gm-Message-State: AC+VfDzvyemX33+9eRypmWoCHIKi+pZO/C+H/C2xVDzvYOKCGc9oCQRj
        xn0g1T/LBGw2Lr1XWgocu1g=
X-Google-Smtp-Source: ACHHUZ48/5F1QCAuM+vaEF4+GHglqT6kuidrmI4yq5vdDQO5Ro6c54tZsyFLHKVSpmKxrEK3FSkLgA==
X-Received: by 2002:a17:902:9341:b0:1b8:b51:694e with SMTP id g1-20020a170902934100b001b80b51694emr4195898plp.62.1687887430751;
        Tue, 27 Jun 2023 10:37:10 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902a9c800b001b5247cac3dsm6245649plr.110.2023.06.27.10.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 10:37:10 -0700 (PDT)
Date:   Tue, 27 Jun 2023 01:32:37 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 1/4] virtio/vsock: rework MSG_PEEK for SOCK_STREAM
Message-ID: <ZJo8NTRCjBTdZyOT@bullseye>
References: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
 <20230618062451.79980-2-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618062451.79980-2-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 18, 2023 at 09:24:48AM +0300, Arseniy Krasnov wrote:
> This reworks current implementation of MSG_PEEK logic:
> 1) Replaces 'skb_queue_walk_safe()' with 'skb_queue_walk()'. There is
>    no need in the first one, as there are no removes of skb in loop.
> 2) Removes nested while loop - MSG_PEEK logic could be implemented
>    without it: just iterate over skbs without removing it and copy
>    data from each until destination buffer is not full.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 41 ++++++++++++-------------
>  1 file changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index b769fc258931..2ee40574c339 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -348,37 +348,34 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
>  				size_t len)
>  {
>  	struct virtio_vsock_sock *vvs = vsk->trans;
> -	size_t bytes, total = 0, off;
> -	struct sk_buff *skb, *tmp;
> -	int err = -EFAULT;
> +	struct sk_buff *skb;
> +	size_t total = 0;
> +	int err;
>  
>  	spin_lock_bh(&vvs->rx_lock);
>  
> -	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
> -		off = 0;
> +	skb_queue_walk(&vvs->rx_queue, skb) {
> +		size_t bytes;
>  
> -		if (total == len)
> -			break;
> +		bytes = len - total;
> +		if (bytes > skb->len)
> +			bytes = skb->len;
>  
> -		while (total < len && off < skb->len) {
> -			bytes = len - total;
> -			if (bytes > skb->len - off)
> -				bytes = skb->len - off;
> +		spin_unlock_bh(&vvs->rx_lock);
>  
> -			/* sk_lock is held by caller so no one else can dequeue.
> -			 * Unlock rx_lock since memcpy_to_msg() may sleep.
> -			 */
> -			spin_unlock_bh(&vvs->rx_lock);
> +		/* sk_lock is held by caller so no one else can dequeue.
> +		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> +		 */
> +		err = memcpy_to_msg(msg, skb->data, bytes);
> +		if (err)
> +			goto out;
>  
> -			err = memcpy_to_msg(msg, skb->data + off, bytes);
> -			if (err)
> -				goto out;
> +		total += bytes;
>  
> -			spin_lock_bh(&vvs->rx_lock);
> +		spin_lock_bh(&vvs->rx_lock);
>  
> -			total += bytes;
> -			off += bytes;
> -		}
> +		if (total == len)
> +			break;
>  	}
>  
>  	spin_unlock_bh(&vvs->rx_lock);
> -- 
> 2.25.1
> 

That cleans up nicely!

LGTM.

Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
