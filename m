Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0231F1E25
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 19:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730709AbgFHRI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 13:08:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730490AbgFHRI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 13:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591636135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sI72Ms6GymnWW5IgfsQfm5B7QZQFkpb/EFt5z5NFsqI=;
        b=ILrdMXY7VyUV77Xbdh+HTzXB0Fkgsn+bKnVpuKJuAdR5BvVRg/LDvVlq2dAZ7zxap6aqfg
        zdy9lKsA7oYyJ09Hc7/44HsGaowUUidL3XWPdXby3NIQUh4b5yPN+9snrRoUitvKmKGZXV
        Uc+N6jvw8/2YGAtghYQzw0+uB0pZ7c8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-oCC8YqFDPOiGw59nhUg-PQ-1; Mon, 08 Jun 2020 13:08:54 -0400
X-MC-Unique: oCC8YqFDPOiGw59nhUg-PQ-1
Received: by mail-wr1-f72.google.com with SMTP id n6so7436767wrv.6
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 10:08:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sI72Ms6GymnWW5IgfsQfm5B7QZQFkpb/EFt5z5NFsqI=;
        b=U7NGZ3NOLZVbYJ6YD6/Ptlc3dFIhxFa+irG/tVEBRKNi+A09wTiRtIe5hL3TO2xyAg
         JDDPMx72EgoebhnMJxg1+mC1WoWItfem/6afVZOIkADPz8lRPvP8YGKEErTXZsk1aqsX
         wbJnul0UCH1PW88KUqUuv4dH05ydluyjttxTToVza1Xoz60S6TnlvdHIp8UtpRwZgOl5
         Ivvw49APLq71IPF17USlHB5V+5KMzqhy0DSEnJSa5bJ9AfyQXJeA9ilaiKOHpBnrnEYA
         /jAPr94a4hYRQPgUmOVTN8p9FS1kPIRBv11rm+s46Il4LZzuRooSGZdPDes3wbOqLwqp
         HGAQ==
X-Gm-Message-State: AOAM533+PpHoVienW7nObsn4vlcQ6DYY3CQOnSESfRRhSPcECr8Pdfxm
        zJ8oSvUzsLKpMjgtc3I0qOf34rHzRkyzjOFYH8BFQ2D7jod8qoi/jkDWQFORgtxHn44SqyEjtsY
        BXlzaA5hMRM51
X-Received: by 2002:a1c:3b43:: with SMTP id i64mr339445wma.112.1591636132908;
        Mon, 08 Jun 2020 10:08:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4dUf9x3rgVZHJRvrEuMPKhxm/lCre/+sG86XOaArTyYsFZli8wP4z+s74imLE54MU9CeoNw==
X-Received: by 2002:a1c:3b43:: with SMTP id i64mr339413wma.112.1591636132598;
        Mon, 08 Jun 2020 10:08:52 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id l2sm342741wru.58.2020.06.08.10.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 10:08:51 -0700 (PDT)
Date:   Mon, 8 Jun 2020 19:08:49 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, eperezma@redhat.com,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH RFC v6 10/11] vhost/vsock: switch to the buf API
Message-ID: <20200608170849.udaxzmfzmhbonoi7@steredhat>
References: <20200608125238.728563-1-mst@redhat.com>
 <20200608125238.728563-11-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-11-mst@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 08:53:13AM -0400, Michael S. Tsirkin wrote:
> A straight-forward conversion.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)

I ran the vsock tests again with this new series and everything seems
to go well:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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

