Return-Path: <kvm+bounces-42463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B879A78B0D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 11:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF5C1170112
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 09:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB92235C01;
	Wed,  2 Apr 2025 09:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnk6uNTC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCBA205AD7;
	Wed,  2 Apr 2025 09:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743585971; cv=none; b=FBeOgCgwAihxHZ5CKosuPH+fRmpHnOR4Hd/iZmHru2IaY0MdGHpKSgYyg0upN1LH3o5iMqUo880nV0xIiOSCqLLN2foIBDLrCHHvj8/QNMl0YFLU9PDaXmaHcUY8/zEqNrt/xPzXukFZRtiqo2BaxoYTQEa8MqWGX0OGKPoJySQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743585971; c=relaxed/simple;
	bh=UrEYev3gTVK2sp5pdFb3fCyxVMvmTB7pMIYsSE6G+/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0UJPZmZdpGqqMMc1Cv/IPJMxZUST5FwZ2wnEFn36MEmsfj8Jcf+pd1g6r+VSC2SKmr1sDpPIaNbtLSRlgGEAIVGwNAacm5MSPxoSax+3kRmnxXh2NKoUe34Z+5jyoGmWgqjO2/ouFr6LPGhbWrk+4+uqdjcPsX1F6kgrKMPCck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnk6uNTC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBDBC4CEDD;
	Wed,  2 Apr 2025 09:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743585969;
	bh=UrEYev3gTVK2sp5pdFb3fCyxVMvmTB7pMIYsSE6G+/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qnk6uNTCD4FAegNtPTzvmqtYr8HhwgZC63m8UvDrbJ+jtWCcaEv0R9JlTcD1FgAuO
	 15OjR90Rrm50QfiGh+F+8Weypj12hn1RAbekQxq8A34AY4gkvsQ1A19W1iDWD+IPSo
	 igm2tdTZTXOrT589fpUgLmjzDYEfYioExTX/nj/pZ0gVE42HVNatQGKcgZxEDcf/O8
	 t9RQpiWwgmv0A2YPWIyA7Lm5MeiWcYQp5HA+Mek3whA8g/RsPw2KI7erEpZeb5IgCa
	 PijpXofM323Mn/XRPeSv4RO897GzqMg2fUN0c6jJNQaKd191A4F4rDOxLmpwVJ6+Uo
	 d9dRnCZGXTYRQ==
Date: Wed, 2 Apr 2025 10:26:05 +0100
From: Simon Horman <horms@kernel.org>
To: Alexander Graf <graf@amazon.com>
Cc: netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Asias He <asias@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>, nh-open-source@amazon.com
Subject: Re: [PATCH v2] vsock/virtio: Remove queued_replies pushback logic
Message-ID: <20250402092605.GJ214849@horms.kernel.org>
References: <20250401201349.23867-1-graf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401201349.23867-1-graf@amazon.com>

On Tue, Apr 01, 2025 at 08:13:49PM +0000, Alexander Graf wrote:
> Ever since the introduction of the virtio vsock driver, it included
> pushback logic that blocks it from taking any new RX packets until the
> TX queue backlog becomes shallower than the virtqueue size.
> 
> This logic works fine when you connect a user space application on the
> hypervisor with a virtio-vsock target, because the guest will stop
> receiving data until the host pulled all outstanding data from the VM.
> 
> With Nitro Enclaves however, we connect 2 VMs directly via vsock:
> 
>   Parent      Enclave
> 
>     RX -------- TX
>     TX -------- RX
> 
> This means we now have 2 virtio-vsock backends that both have the pushback
> logic. If the parent's TX queue runs full at the same time as the
> Enclave's, both virtio-vsock drivers fall into the pushback path and
> no longer accept RX traffic. However, that RX traffic is TX traffic on
> the other side which blocks that driver from making any forward
> progress. We're now in a deadlock.
> 
> To resolve this, let's remove that pushback logic altogether and rely on
> higher levels (like credits) to ensure we do not consume unbounded
> memory.
> 
> RX and TX queues share the same work queue. To prevent starvation of TX
> by an RX flood and vice versa now that the pushback logic is gone, let's
> deliberately reschedule RX and TX work after a fixed threshold (256) of
> packets to process.
> 
> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 70 +++++++++-----------------------
>  1 file changed, 19 insertions(+), 51 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c

...

> @@ -158,7 +162,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  		container_of(work, struct virtio_vsock, send_pkt_work);
>  	struct virtqueue *vq;
>  	bool added = false;
> -	bool restart_rx = false;
> +	int pkts = 0;
>  
>  	mutex_lock(&vsock->tx_lock);
>  
> @@ -172,6 +176,12 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  		bool reply;
>  		int ret;
>  
> +		if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
> +			/* Allow other works on the same queue to run */
> +			queue_work(virtio_vsock_workqueue, work);
> +			break;
> +		}
> +
>  		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
>  		if (!skb)
>  			break;

Hi Alexander,

The next non-blank line of code looks like this:

		reply = virtio_vsock_skb_reply(skb);

But with this patch reply is assigned but otherwise unused.
So perhaps the line above, and the declaration of reply, can be removed?

Flagged by W=1 builds.

> @@ -184,17 +194,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  			break;
>  		}
>  
> -		if (reply) {
> -			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
> -			int val;
> -
> -			val = atomic_dec_return(&vsock->queued_replies);
> -
> -			/* Do we now have resources to resume rx processing? */
> -			if (val + 1 == virtqueue_get_vring_size(rx_vq))
> -				restart_rx = true;
> -		}
> -
>  		added = true;
>  	}
>  
> @@ -203,9 +202,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  
>  out:
>  	mutex_unlock(&vsock->tx_lock);
> -
> -	if (restart_rx)
> -		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>  }
>  
>  /* Caller need to hold RCU for vsock.

...

