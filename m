Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296BBD42D0
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 16:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfJKO0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 10:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbfJKO0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 10:26:41 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E27AC08E285
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 14:26:41 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id y189so9077744qkb.14
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 07:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u9P7ZH+Y5VJTavkHr+ZiIN7ARusJlNnypFrPGuqGbsc=;
        b=jSmfZo2u9catf0ifOR1KgiEJ3pxdN62DJJNDKnX+DmuNeS/cMNXm1gvNsUtXf/ALmP
         HZLlO613WQ3y/ZrWWeJ8gvDvC4/1vXjx6bSB5eddlqpepdyT2JpqJmBEa3N0n+wREIDa
         Z6TAEQGiVJnnrC9poebFsD5p6uFRgbiB71s3YsCHqnqO+obIBFri2xrb8VbOj13pN5EL
         ORuIHUopY5ytkZ/OsUpurbEgXtYxd1siALmlX2bN33IJrTmsu+/G6KF8+ak1H9LU5tP8
         zjEIFLRGppguI78UZQvz3w8dOD8n9eUI25/1Z9Dn/nRTEYvjNgce9QSofYlwl31lQtW3
         BCww==
X-Gm-Message-State: APjAAAWB02rvmT1W5O2QVhdywHmfS1F+pMW1g5CFwyy2RZc6WsBqpCkL
        kqBat5ji5jMs17jlJDpstxF2TC1itJLQ0EceEX05fsRZ5IobWpVN5wFBVgPuTkkpSCp6Hg3efK3
        hADyt7fxzcrmC
X-Received: by 2002:a37:6114:: with SMTP id v20mr16560718qkb.329.1570804000581;
        Fri, 11 Oct 2019 07:26:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxRQu0tWlUWQUkl0Snv5crytJ8wM4hPrKuPA7AXRTavuKo53VLfKGDp3FcKv1ZsSQwyKNvQTQ==
X-Received: by 2002:a37:6114:: with SMTP id v20mr16560681qkb.329.1570804000320;
        Fri, 11 Oct 2019 07:26:40 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id i30sm4661684qte.27.2019.10.11.07.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 07:26:39 -0700 (PDT)
Date:   Fri, 11 Oct 2019 10:26:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] vhost/vsock: don't allow half-closed socket in
 the host
Message-ID: <20191011102246-mutt-send-email-mst@kernel.org>
References: <20191011130758.22134-1-sgarzare@redhat.com>
 <20191011130758.22134-3-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011130758.22134-3-sgarzare@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 03:07:58PM +0200, Stefano Garzarella wrote:
> vmci_transport never allowed half-closed socket on the host side.
> In order to provide the same behaviour, we changed the
> vhost_transport_stream_has_data() to return 0 (no data available)
> if the peer (guest) closed the connection.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

I don't think we should copy bugs like this.
Applications don't actually depend on this VMCI limitation, in fact
it looks like a working application can get broken by this.

So this looks like a userspace visible ABI change
which we can't really do.

If it turns out some application cares, it can always
fully close the connection. Or add an ioctl so the application
can find out whether half close works.

> ---
>  drivers/vhost/vsock.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 9f57736fe15e..754120aa4478 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -58,6 +58,21 @@ static u32 vhost_transport_get_local_cid(void)
>  	return VHOST_VSOCK_DEFAULT_HOST_CID;
>  }
>  
> +static s64 vhost_transport_stream_has_data(struct vsock_sock *vsk)
> +{
> +	/* vmci_transport doesn't allow half-closed socket on the host side.
> +	 * recv() on the host side returns EOF when the guest closes a
> +	 * connection, also if some data is still in the receive queue.
> +	 *
> +	 * In order to provide the same behaviour, we always return 0
> +	 * (no data available) if the peer (guest) closed the connection.
> +	 */
> +	if (vsk->peer_shutdown == SHUTDOWN_MASK)
> +		return 0;
> +
> +	return virtio_transport_stream_has_data(vsk);
> +}
> +
>  /* Callers that dereference the return value must hold vhost_vsock_mutex or the
>   * RCU read lock.
>   */
> @@ -804,7 +819,7 @@ static struct virtio_transport vhost_transport = {
>  
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
> -		.stream_has_data          = virtio_transport_stream_has_data,
> +		.stream_has_data          = vhost_transport_stream_has_data,
>  		.stream_has_space         = virtio_transport_stream_has_space,
>  		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
>  		.stream_is_active         = virtio_transport_stream_is_active,
> -- 
> 2.21.0
