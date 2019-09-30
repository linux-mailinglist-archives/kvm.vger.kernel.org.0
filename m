Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6991C22E3
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 16:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbfI3OMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 10:12:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1989 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731452AbfI3OMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 10:12:42 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38FDA85362
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 14:12:41 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id z17so4584736wru.13
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 07:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U7Vi6scFOY6hhqVA0cemS3cQSEC3brtnkAsLJZs+8us=;
        b=VPzXQoAZfAmYhpZ2JVc//SEN3NZVOkyiel5JNr+viHH1Nr0IoZnIZrN6QN3lSHjqbu
         tRq5UbutiyMKd9VXM7AzWCeeUnJpc9hc5jz99vxjN6V3C+UOIRBW8PLMRrcgGihNE6EB
         82KdMvRybTVr3FHSnzGDmwWsSJ657Jbz2i2BrazfqOZEmKf96mcwOPN3uiKtJKjHt5Iw
         pGyoZH7+k9X/iJqqhM7XQ0so2l0mmrqbzJW/4LH2g2jHsSaOUnst3tiMxlGbTUSC8B5o
         JIhBA9OkslkbrCyssriFdwWRTZJRpOZ2eC+vV4/wI/rpaEMVR5xS0dM8+qsQEVxpSPdH
         UJyg==
X-Gm-Message-State: APjAAAUnnkxycPPOAgdgQEMxolAneOnsPdfq2DR9iEO3+jLxl8iphAg1
        RmojEageALs1wuYowv+Mj2LyBlAzM74+XjU29eo2HCm2PlwORF+w+heHVVKkO4byBA/zkee6Ts6
        8Qd1oGi7dUl6v
X-Received: by 2002:a5d:4a52:: with SMTP id v18mr12746635wrs.368.1569852759890;
        Mon, 30 Sep 2019 07:12:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyuBZfGK6lRi6GwfXTgTA8HHpv68vhrm6ZMForGt3w+ZiwRNEldTnLZexHFnR0clNvNiDrJgw==
X-Received: by 2002:a5d:4a52:: with SMTP id v18mr12746617wrs.368.1569852759679;
        Mon, 30 Sep 2019 07:12:39 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id u11sm14385252wmd.32.2019.09.30.07.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 07:12:38 -0700 (PDT)
Date:   Mon, 30 Sep 2019 16:12:36 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH v2] vsock/virtio: add support for MSG_PEEK
Message-ID: <20190930141236.lp3nroal33k63vlg@steredhat>
References: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
 <1569602663-16815-1-git-send-email-matiasevara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569602663-16815-1-git-send-email-matiasevara@gmail.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matias,

On Fri, Sep 27, 2019 at 04:44:23PM +0000, Matias Ezequiel Vara Larsen wrote:
> This patch adds support for MSG_PEEK. In such a case, packets are not
> removed from the rx_queue and credit updates are not sent.
> 
> Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 55 +++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 3 deletions(-)

The patch LGTM. As David pointed out, this patch should go into net-next.
Since now net-next is open, you can resend with net-next tag [1] and
with:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Tested-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

[1] https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 94cc0fa..cf15751 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -264,6 +264,55 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
>  }
>  
>  static ssize_t
> +virtio_transport_stream_do_peek(struct vsock_sock *vsk,
> +				struct msghdr *msg,
> +				size_t len)
> +{
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	struct virtio_vsock_pkt *pkt;
> +	size_t bytes, total = 0, off;
> +	int err = -EFAULT;
> +
> +	spin_lock_bh(&vvs->rx_lock);
> +
> +	list_for_each_entry(pkt, &vvs->rx_queue, list) {
> +		off = pkt->off;
> +
> +		if (total == len)
> +			break;
> +
> +		while (total < len && off < pkt->len) {
> +			bytes = len - total;
> +			if (bytes > pkt->len - off)
> +				bytes = pkt->len - off;
> +
> +			/* sk_lock is held by caller so no one else can dequeue.
> +			 * Unlock rx_lock since memcpy_to_msg() may sleep.
> +			 */
> +			spin_unlock_bh(&vvs->rx_lock);
> +
> +			err = memcpy_to_msg(msg, pkt->buf + off, bytes);
> +			if (err)
> +				goto out;
> +
> +			spin_lock_bh(&vvs->rx_lock);
> +
> +			total += bytes;
> +			off += bytes;
> +		}
> +	}
> +
> +	spin_unlock_bh(&vvs->rx_lock);
> +
> +	return total;
> +
> +out:
> +	if (total)
> +		err = total;
> +	return err;
> +}
> +
> +static ssize_t
>  virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  				   struct msghdr *msg,
>  				   size_t len)
> @@ -330,9 +379,9 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>  				size_t len, int flags)
>  {
>  	if (flags & MSG_PEEK)
> -		return -EOPNOTSUPP;
> -
> -	return virtio_transport_stream_do_dequeue(vsk, msg, len);
> +		return virtio_transport_stream_do_peek(vsk, msg, len);
> +	else
> +		return virtio_transport_stream_do_dequeue(vsk, msg, len);
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>  
> -- 
> 2.7.4
> 

-- 
