Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4AE1F168E
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 12:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgFHKRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 06:17:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729259AbgFHKRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 06:17:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591611472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8qWrXG5uSNE9Dzp6V1sYS5ofw86anDpXXrPKXmMCdEo=;
        b=L3JTHtrb2uLBgEnqW7kuKLKOcZVUjAhQJPkGkeUahooxPA7L9RwDQ1kfN4Rgg6PYhGIhir
        SQ8wdVG5ojRhkUVGcAIFQAFH4252Xw9Kk27Q0cEkQu24mlc0bKYWG6f3RDizeMf7nCUNVK
        exYPur8mACV8FeruZVtGYDQuWMiQtrU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-M39UaSbzM3WOTcViv830gQ-1; Mon, 08 Jun 2020 06:17:50 -0400
X-MC-Unique: M39UaSbzM3WOTcViv830gQ-1
Received: by mail-wm1-f70.google.com with SMTP id t145so5083718wmt.2
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 03:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8qWrXG5uSNE9Dzp6V1sYS5ofw86anDpXXrPKXmMCdEo=;
        b=P1U0W9TeYerDPDsGClXTrG+iRB/L7LQrzduRBCNJMZfzXhZg7GO+iY9hqZhI+ZwhoW
         hZnNd5fjgmnfT8x1ifad7HqNfcgjK6H0D5JXynMR+OPPC5iij1Zcvd/YXOH7IoDBER3s
         pkMJ4/+fjiKl7n6LEBuBH4TSI8WU45J4qZPPUZgy4pI3K9bMqW+XpPiUrgQmT8S2iQdf
         AXpAvUP9dF0CdvJlnqBhUvMUOC6yfZaDEOD0gqUPg4zU+9JvgPu8JEsS/IX6kAeTJR/F
         4HNPCQzRd+J5/bmhaNwXyqNDNu66HNLa2D50M0ryiaDexD2Ib5FiV5zw3jzblxn/ZVMs
         TD6w==
X-Gm-Message-State: AOAM531zNI2sjPAQSLLNH28SPvNlOTPYyXmvC7/KXjDbKrp7JM75suM1
        vQ2XcaYM94pZgaRlBLZl3HUNDrbsyeEihoMEKIY59BddAeWblJroWO+raZu6ZrotubxJr41Vdqc
        eIPTQkk1KoUaE
X-Received: by 2002:a1c:4105:: with SMTP id o5mr15395858wma.168.1591611469373;
        Mon, 08 Jun 2020 03:17:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw01MpQfAn3zflPb7GVdN7FLLZh1HetB9oB+KWr4r5voKTa+SLtxH/AzT7wvjwZnQiGg0J+Pw==
X-Received: by 2002:a1c:4105:: with SMTP id o5mr15395824wma.168.1591611469097;
        Mon, 08 Jun 2020 03:17:49 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id a3sm22199003wrp.91.2020.06.08.03.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 03:17:48 -0700 (PDT)
Date:   Mon, 8 Jun 2020 12:17:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, eperezma@redhat.com,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH RFC v5 12/13] vhost/vsock: switch to the buf API
Message-ID: <20200608101746.xnxtwwygolsk7yol@steredhat>
References: <20200607141057.704085-1-mst@redhat.com>
 <20200607141057.704085-13-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607141057.704085-13-mst@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 07, 2020 at 10:11:49AM -0400, Michael S. Tsirkin wrote:
> A straight-forward conversion.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)

The changes for vsock part LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


I also did some tests with vhost-vsock (tools/testing/vsock/vsock_test
and iperf-vsock), so for vsock:

Tested-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index a483cec31d5c..61c6d3dd2ae3 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -103,7 +103,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  		unsigned out, in;
>  		size_t nbytes;
>  		size_t iov_len, payload_len;
> -		int head;
> +		struct vhost_buf buf;
> +		int ret;
>  
>  		spin_lock_bh(&vsock->send_pkt_list_lock);
>  		if (list_empty(&vsock->send_pkt_list)) {
> @@ -117,16 +118,17 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  		list_del_init(&pkt->list);
>  		spin_unlock_bh(&vsock->send_pkt_list_lock);
>  
> -		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> -					 &out, &in, NULL, NULL);
> -		if (head < 0) {
> +		ret = vhost_get_avail_buf(vq, &buf,
> +					  vq->iov, ARRAY_SIZE(vq->iov),
> +					  &out, &in, NULL, NULL);
> +		if (ret < 0) {
>  			spin_lock_bh(&vsock->send_pkt_list_lock);
>  			list_add(&pkt->list, &vsock->send_pkt_list);
>  			spin_unlock_bh(&vsock->send_pkt_list_lock);
>  			break;
>  		}
>  
> -		if (head == vq->num) {
> +		if (!ret) {
>  			spin_lock_bh(&vsock->send_pkt_list_lock);
>  			list_add(&pkt->list, &vsock->send_pkt_list);
>  			spin_unlock_bh(&vsock->send_pkt_list_lock);
> @@ -186,7 +188,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  		 */
>  		virtio_transport_deliver_tap_pkt(pkt);
>  
> -		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
> +		buf.in_len = sizeof(pkt->hdr) + payload_len;
> +		vhost_put_used_buf(vq, &buf);
>  		added = true;
>  
>  		pkt->off += payload_len;
> @@ -440,7 +443,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>  	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
>  						 dev);
>  	struct virtio_vsock_pkt *pkt;
> -	int head, pkts = 0, total_len = 0;
> +	int ret, pkts = 0, total_len = 0;
> +	struct vhost_buf buf;
>  	unsigned int out, in;
>  	bool added = false;
>  
> @@ -461,12 +465,13 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>  			goto no_more_replies;
>  		}
>  
> -		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> -					 &out, &in, NULL, NULL);
> -		if (head < 0)
> +		ret = vhost_get_avail_buf(vq, &buf,
> +					  vq->iov, ARRAY_SIZE(vq->iov),
> +					  &out, &in, NULL, NULL);
> +		if (ret < 0)
>  			break;
>  
> -		if (head == vq->num) {
> +		if (!ret) {
>  			if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
>  				vhost_disable_notify(&vsock->dev, vq);
>  				continue;
> @@ -494,7 +499,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>  			virtio_transport_free_pkt(pkt);
>  
>  		len += sizeof(pkt->hdr);
> -		vhost_add_used(vq, head, len);
> +		buf.in_len = len;
> +		vhost_put_used_buf(vq, &buf);
>  		total_len += len;
>  		added = true;
>  	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
> -- 
> MST
> 

