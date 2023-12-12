Return-Path: <kvm+bounces-4159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B67E80E6F8
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 09:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56A27282BAD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 08:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC775812D;
	Tue, 12 Dec 2023 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2wjb/y5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17ADDC
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 00:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702371422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+DYsFoZHtER6WKTlmJtvh956H3bsUBDuNP4h+dQhswI=;
	b=P2wjb/y5ymsI+/pOG/8sBHAS2dN3s4wq+0OEOZ7jAtNV/ydX75CUQw3HvC70AkpqxdlIOU
	hC+TL6KXSwFxp0Ab+Pswkkph+H5BA9zqyoILqzZwWVoKuDtEqVVVv7/ojhxIZ1R9nDh7xm
	iSWcTkrVwTaD+pOyzz4LB/Gh9Jdh4nE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-nGPRoDHJO5yuOxsLvzH7mA-1; Tue, 12 Dec 2023 03:57:01 -0500
X-MC-Unique: nGPRoDHJO5yuOxsLvzH7mA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40c1e063438so41605865e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 00:57:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702371420; x=1702976220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DYsFoZHtER6WKTlmJtvh956H3bsUBDuNP4h+dQhswI=;
        b=vUveBIz1IEycj0R7YXzJzd+Gy1OQAAvRm26KALRT78CYnQRx7O3bkZkPl9tgzJpRk2
         5WX+hMZkLg0LVIifWYmvp11IILzRr1rUKB6qYWmLPzHg7nNelIk9ye43sWsjg8bNmHD6
         D5bpOZcvQzEPQ3C8z3Z1+BpLf8ASQJ4uP/BDuTSCWk2CUi01NU69wDiLt5Y21e7HGLXv
         dgmRXkBZD09TfjDHTRiQfuHB1zuaHeLppCglj03SQg2syryCmXXzOEa/DYPp+Ja6xPlS
         LtNN2O4vYfuJ1Uhco3wAEOvJYVF9t/v1qPU08nq4XcFQsM2akiGneZZGC7CQ1jIFwoNi
         /DZg==
X-Gm-Message-State: AOJu0YwPK8xjQOPOZxzl3PLss42s6iULOkVo6dC2RYgqH1fZ5+6gNRHL
	9ygTycwcybJAqhplNgdEXVjfIupHLCX6l8LiJHnM3pRqyMUqunDACC2F6DuN52fgus02XEq/TC+
	fd4NP7Yiyhi2f
X-Received: by 2002:a05:600c:3b26:b0:40c:224a:4450 with SMTP id m38-20020a05600c3b2600b0040c224a4450mr3229524wms.37.1702371420268;
        Tue, 12 Dec 2023 00:57:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIvN7jWx6yzro4Qv1kFQ+dgRjl2IrdvJ4STo7PXBwwt5ZmQf8etAfWpYSWHF1NH+upAURrYw==
X-Received: by 2002:a05:600c:3b26:b0:40c:224a:4450 with SMTP id m38-20020a05600c3b2600b0040c224a4450mr3229507wms.37.1702371419828;
        Tue, 12 Dec 2023 00:56:59 -0800 (PST)
Received: from sgarzare-redhat ([193.207.128.35])
        by smtp.gmail.com with ESMTPSA id d13-20020a05600c34cd00b0040c496c64cfsm5430442wmq.12.2023.12.12.00.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 00:56:59 -0800 (PST)
Date: Tue, 12 Dec 2023 09:56:45 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v8 3/4] virtio/vsock: fix logic which reduces
 credit update messages
Message-ID: <5wewycputeafvvgehioon3j75hlwxeliyni6nt4qtw3ch5rlt4@o7yncdbcyoc4>
References: <20231211211658.2904268-1-avkrasnov@salutedevices.com>
 <20231211211658.2904268-4-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231211211658.2904268-4-avkrasnov@salutedevices.com>

On Tue, Dec 12, 2023 at 12:16:57AM +0300, Arseniy Krasnov wrote:
>Add one more condition for sending credit update during dequeue from
>stream socket: when number of bytes in the rx queue is smaller than
>SO_RCVLOWAT value of the socket. This is actual for non-default value
>of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
>transmission, because we need at least SO_RCVLOWAT bytes in our rx
>queue to wake up user for reading data (in corner case it is also
>possible to stuck both tx and rx sides, this is why 'Fixes' is used).
>
>Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v6 -> v7:
>  * Handle wrap of 'fwd_cnt'.
>  * Do to send credit update when 'fwd_cnt' == 'last_fwd_cnt'.
> v7 -> v8:
>  * Remove unneeded/wrong handling of wrap for 'fwd_cnt'.
>
> net/vmw_vsock/virtio_transport_common.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks!
Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index e137d740804e..8572f94bba88 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -558,6 +558,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	struct virtio_vsock_sock *vvs = vsk->trans;
> 	size_t bytes, total = 0;
> 	struct sk_buff *skb;
>+	u32 fwd_cnt_delta;
>+	bool low_rx_bytes;
> 	int err = -EFAULT;
> 	u32 free_space;
>
>@@ -601,7 +603,10 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 		}
> 	}
>
>-	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
>+	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
>+	free_space = vvs->buf_alloc - fwd_cnt_delta;
>+	low_rx_bytes = (vvs->rx_bytes <
>+			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
>
> 	spin_unlock_bh(&vvs->rx_lock);
>
>@@ -611,9 +616,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	 * too high causes extra messages. Too low causes transmitter
> 	 * stalls. As stalls are in theory more expensive than extra
> 	 * messages, we set the limit to a high value. TODO: experiment
>-	 * with different values.
>+	 * with different values. Also send credit update message when
>+	 * number of bytes in rx queue is not enough to wake up reader.
> 	 */
>-	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>+	if (fwd_cnt_delta &&
>+	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
> 		virtio_transport_send_credit_update(vsk);
>
> 	return total;
>-- 
>2.25.1
>


