Return-Path: <kvm+bounces-64614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E108C8840A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A41B83AF33A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A70B318143;
	Wed, 26 Nov 2025 06:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hHu6uOLB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GKdDXgaY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94683315D5B
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 06:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764138019; cv=none; b=WMTWQkpgY17dyg2HyX+K2k9zdRr9VvlshGkyyRWttVSTZ/6Jsjnbio2agjqIq9a88M+4yiSYRxYpxptImIvTsx1oGKIrJpdTFI/lEk2KTJPcDBigyDJ2cTvggbrqPq5IGHOdSR5hhqQ1OV/AmGtDfM91R5Ka6iYdKCxKeq/imKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764138019; c=relaxed/simple;
	bh=u1oUf2OSFhiIYY4ofHuJY6uzFP6fqE5gY3D8/VlwNJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYJt2EDkl03N7wz2qg+EpGgC4oi8747UbngJy+KdKxZD/WOtSXhy3iy/SoukNs8/6RV+IbpucANlzUwgvTb+41nBCrKd0PhUxoJr1PqIEIyz+bh0iISxSwOCQVpIkdB4wZDt+ZPkYcRbFfpzSo7O3EalisZzNECn6YqMWxGcUGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hHu6uOLB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GKdDXgaY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764138016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SAogFKr5/YF6b2LjdB/TyJNbwXFg1+M89AI+AhVEeGQ=;
	b=hHu6uOLBtcAsEWY89KT+jGd2YyW+ZQCI3hvq4mgiNwbcXWAzHqu9LjKUyi8bNSuwMsv23m
	UUOQDn6OUHG9UugZG0tl1BLZyORjCARphOGKUKGPdkDz6TF5tywngQ09Wt8bFGHyeA1/AV
	jeat+39Pme4sYsMbI08g04YYQmuB3CY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-1ZHJwEKVMnacPc01ks1ctw-1; Wed, 26 Nov 2025 01:20:14 -0500
X-MC-Unique: 1ZHJwEKVMnacPc01ks1ctw-1
X-Mimecast-MFC-AGG-ID: 1ZHJwEKVMnacPc01ks1ctw_1764138013
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-429c76c8a1bso5631547f8f.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 22:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764138012; x=1764742812; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SAogFKr5/YF6b2LjdB/TyJNbwXFg1+M89AI+AhVEeGQ=;
        b=GKdDXgaYjfvv01N8gmqsAPtk5aMlS698CIbT3ctgV4/PuFQV6YNIcM2Fa2JYX9iZCU
         WlDYhvMivn3tK0rAHG4swD8NS/Us0eZWf31qigbeUHYdGOEll3PPz/xO2YDlLaRCdVIl
         aFqyTrrXu4ukR3UmD2MociUy3NEQSRLhnk1/4AVajUOULJOExLmU2v0CfXFamBwkq0BW
         TWFffyJH/TlDsmN5BhRU7Mf/chGU/mKHwHVlSYcSnUIltnOP3BPHBbDgflWMaUusy/wB
         DvAyuQ66zHtjciMXR8hEprauI8IF5/qRhRTyzHogfaD82LqQwSaLtfOL4OJ3N6/+wEdh
         lzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764138012; x=1764742812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAogFKr5/YF6b2LjdB/TyJNbwXFg1+M89AI+AhVEeGQ=;
        b=ZUm2T8BspxqQqNtopwF9T7tH6DhcdvGSzbKo5qazciMrwth58/AR3wmnJcsvYa06aL
         Y+OeVKutO2ze7/JKCbLgBofdSDLsfbpwCUL/bkqnXGRSeudknHWieyBhBYk0JJlK4hRM
         mfuUK6TuGpNRNmlINxm+HCniwzvgeBQSWw4B0KlOEFs1j8CG9R5qCwqzqJRLVmyp7bI8
         M8QZ9xjAL+ZNx1+LJKef43p2urpSw9InlEqYblCAkIR8/TrEI7kSdlVjAuvgFsdjZRew
         eaggj2lilySRy/aHRHDs6lO2x7CPmwdn1yFIjzvQkbMPA3sRPcWcNwo4LF3CaJRYF6Rb
         nQug==
X-Forwarded-Encrypted: i=1; AJvYcCXgwdrql4sMcPReM3G62dlfdPgtAi4cZYwFnUKKQdTJ5d7m/6yI3p7hAOBW7woE/YdiY2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YygISv2SSZ+ZF6og8LtXRqrkjPtER1MUs4a6cBpFTF54rkEngL+
	P2bmUw38Yw3PR4R1oQcc7bZOJYSY93HrM725DcyzCjOplJ8etMBGUcpYjRKMyjaYCNSI0dQk1as
	6JAujZ1T068yPz3KovPIzW11+uIiSDdvPT5z6DXtgbR3rrEKtkuwU54IsFNyjFg==
X-Gm-Gg: ASbGncuPXu+WoBsbhEI2vRA/8nMBMvulj740915b8Tw9BeZCAjoKrhQyMIsMkq/3tbj
	mWKx9k8PejDkt6quMGg9B8H3xTg5kNefkHy2KwOTSeSjdXjeZABe23q41YttZ/N+T1mycv0zM4g
	FDhHGb+BvwAcbJ442cdO13BVsPIYt2KPhh9kRFTWn+9Ie2ObfYSBm9gpxnDlrk+++UVhI844N5+
	ENDIEAMXo5GhGXzYRr23w5o25n1tv9K/Tst+5bvIvFQ+vr1p3+Fmvwj4089O/iRGpcoObdOf9vi
	pCkLSJQW/Oe1YJ0LjIXbbfhQEuqpy6jvbysOy23ozsE5UvWjwe1etjm1PN6VZWPVuSd/7aX5gqP
	nqTBKIaGlkw9CWOAnflV/d3eGJFHfRQ==
X-Received: by 2002:a05:6000:1a8f:b0:42b:3c25:cd06 with SMTP id ffacd0b85a97d-42cc1cee419mr19313952f8f.22.1764138012383;
        Tue, 25 Nov 2025 22:20:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFfwhaLGB6swLQTl5LVAvRNoAEV+KntNR0iSr/FxtzIW8dbxgFO02p8yqlvXMiGsaulPRh5lA==
X-Received: by 2002:a05:6000:1a8f:b0:42b:3c25:cd06 with SMTP id ffacd0b85a97d-42cc1cee419mr19313925f8f.22.1764138011775;
        Tue, 25 Nov 2025 22:20:11 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fd8d97sm37948174f8f.42.2025.11.25.22.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 22:20:11 -0800 (PST)
Date: Wed, 26 Nov 2025 01:20:08 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eperezma@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net V2] vhost: rewind next_avail_head while discarding
 descriptors
Message-ID: <20251126001542-mutt-send-email-mst@kernel.org>
References: <20251120022950.10117-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120022950.10117-1-jasowang@redhat.com>

On Thu, Nov 20, 2025 at 10:29:50AM +0800, Jason Wang wrote:
> When discarding descriptors with IN_ORDER, we should rewind
> next_avail_head otherwise it would run out of sync with
> last_avail_idx. This would cause driver to report
> "id X is not a head".
> 
> Fixing this by returning the number of descriptors that is used for
> each buffer via vhost_get_vq_desc_n() so caller can use the value
> while discarding descriptors.
> 
> Fixes: 67a873df0c41 ("vhost: basic in order support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> Changes since V1:
> - Add the function document
> - Tweak the variable name
> ---
>  drivers/vhost/net.c   | 53 ++++++++++++++++++------------
>  drivers/vhost/vhost.c | 76 +++++++++++++++++++++++++++++++++++--------
>  drivers/vhost/vhost.h | 10 +++++-
>  3 files changed, 103 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 35ded4330431..8f7f50acb6d6 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -592,14 +592,15 @@ static void vhost_net_busy_poll(struct vhost_net *net,
>  static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
>  				    struct vhost_net_virtqueue *tnvq,
>  				    unsigned int *out_num, unsigned int *in_num,
> -				    struct msghdr *msghdr, bool *busyloop_intr)
> +				    struct msghdr *msghdr, bool *busyloop_intr,
> +				    unsigned int *ndesc)
>  {
>  	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
>  	struct vhost_virtqueue *rvq = &rnvq->vq;
>  	struct vhost_virtqueue *tvq = &tnvq->vq;
>  
> -	int r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> -				  out_num, in_num, NULL, NULL);
> +	int r = vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> +				    out_num, in_num, NULL, NULL, ndesc);
>  
>  	if (r == tvq->num && tvq->busyloop_timeout) {
>  		/* Flush batched packets first */
> @@ -610,8 +611,8 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
>  
>  		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
>  
> -		r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> -				      out_num, in_num, NULL, NULL);
> +		r = vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
> +					out_num, in_num, NULL, NULL, ndesc);
>  	}
>  
>  	return r;
> @@ -642,12 +643,14 @@ static int get_tx_bufs(struct vhost_net *net,
>  		       struct vhost_net_virtqueue *nvq,
>  		       struct msghdr *msg,
>  		       unsigned int *out, unsigned int *in,
> -		       size_t *len, bool *busyloop_intr)
> +		       size_t *len, bool *busyloop_intr,
> +		       unsigned int *ndesc)
>  {
>  	struct vhost_virtqueue *vq = &nvq->vq;
>  	int ret;
>  
> -	ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg, busyloop_intr);
> +	ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg,
> +				       busyloop_intr, ndesc);
>  
>  	if (ret < 0 || ret == vq->num)
>  		return ret;
> @@ -766,6 +769,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  	int sent_pkts = 0;
>  	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
>  	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> +	unsigned int ndesc = 0;
>  
>  	do {
>  		bool busyloop_intr = false;
> @@ -774,7 +778,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  			vhost_tx_batch(net, nvq, sock, &msg);
>  
>  		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
> -				   &busyloop_intr);
> +				   &busyloop_intr, &ndesc);
>  		/* On error, stop handling until the next kick. */
>  		if (unlikely(head < 0))
>  			break;
> @@ -806,7 +810,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  				goto done;
>  			} else if (unlikely(err != -ENOSPC)) {
>  				vhost_tx_batch(net, nvq, sock, &msg);
> -				vhost_discard_vq_desc(vq, 1);
> +				vhost_discard_vq_desc(vq, 1, ndesc);
>  				vhost_net_enable_vq(net, vq);
>  				break;
>  			}
> @@ -829,7 +833,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  		err = sock->ops->sendmsg(sock, &msg, len);
>  		if (unlikely(err < 0)) {
>  			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> -				vhost_discard_vq_desc(vq, 1);
> +				vhost_discard_vq_desc(vq, 1, ndesc);
>  				vhost_net_enable_vq(net, vq);
>  				break;
>  			}
> @@ -868,6 +872,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  	int err;
>  	struct vhost_net_ubuf_ref *ubufs;
>  	struct ubuf_info_msgzc *ubuf;
> +	unsigned int ndesc = 0;
>  	bool zcopy_used;
>  	int sent_pkts = 0;
>  
> @@ -879,7 +884,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  
>  		busyloop_intr = false;
>  		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
> -				   &busyloop_intr);
> +				   &busyloop_intr, &ndesc);
>  		/* On error, stop handling until the next kick. */
>  		if (unlikely(head < 0))
>  			break;
> @@ -941,7 +946,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  					vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
>  			}
>  			if (retry) {
> -				vhost_discard_vq_desc(vq, 1);
> +				vhost_discard_vq_desc(vq, 1, ndesc);
>  				vhost_net_enable_vq(net, vq);
>  				break;
>  			}
> @@ -1045,11 +1050,12 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
>  		       unsigned *iovcount,
>  		       struct vhost_log *log,
>  		       unsigned *log_num,
> -		       unsigned int quota)
> +		       unsigned int quota,
> +		       unsigned int *ndesc)
>  {
>  	struct vhost_virtqueue *vq = &nvq->vq;
>  	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> -	unsigned int out, in;
> +	unsigned int out, in, desc_num, n = 0;
>  	int seg = 0;
>  	int headcount = 0;
>  	unsigned d;
> @@ -1064,9 +1070,9 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
>  			r = -ENOBUFS;
>  			goto err;
>  		}
> -		r = vhost_get_vq_desc(vq, vq->iov + seg,
> -				      ARRAY_SIZE(vq->iov) - seg, &out,
> -				      &in, log, log_num);
> +		r = vhost_get_vq_desc_n(vq, vq->iov + seg,
> +					ARRAY_SIZE(vq->iov) - seg, &out,
> +					&in, log, log_num, &desc_num);
>  		if (unlikely(r < 0))
>  			goto err;
>  
> @@ -1093,6 +1099,7 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
>  		++headcount;
>  		datalen -= len;
>  		seg += in;
> +		n += desc_num;
>  	}
>  
>  	*iovcount = seg;
> @@ -1113,9 +1120,11 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
>  		nheads[0] = headcount;
>  	}
>  
> +	*ndesc = n;
> +
>  	return headcount;
>  err:
> -	vhost_discard_vq_desc(vq, headcount);
> +	vhost_discard_vq_desc(vq, headcount, n);
>  	return r;
>  }
>  
> @@ -1151,6 +1160,7 @@ static void handle_rx(struct vhost_net *net)
>  	struct iov_iter fixup;
>  	__virtio16 num_buffers;
>  	int recv_pkts = 0;
> +	unsigned int ndesc;
>  
>  	mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
>  	sock = vhost_vq_get_backend(vq);
> @@ -1182,7 +1192,8 @@ static void handle_rx(struct vhost_net *net)
>  		headcount = get_rx_bufs(nvq, vq->heads + count,
>  					vq->nheads + count,
>  					vhost_len, &in, vq_log, &log,
> -					likely(mergeable) ? UIO_MAXIOV : 1);
> +					likely(mergeable) ? UIO_MAXIOV : 1,
> +					&ndesc);
>  		/* On error, stop handling until the next kick. */
>  		if (unlikely(headcount < 0))
>  			goto out;
> @@ -1228,7 +1239,7 @@ static void handle_rx(struct vhost_net *net)
>  		if (unlikely(err != sock_len)) {
>  			pr_debug("Discarded rx packet: "
>  				 " len %d, expected %zd\n", err, sock_len);
> -			vhost_discard_vq_desc(vq, headcount);
> +			vhost_discard_vq_desc(vq, headcount, ndesc);
>  			continue;
>  		}
>  		/* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
> @@ -1252,7 +1263,7 @@ static void handle_rx(struct vhost_net *net)
>  		    copy_to_iter(&num_buffers, sizeof num_buffers,
>  				 &fixup) != sizeof num_buffers) {
>  			vq_err(vq, "Failed num_buffers write");
> -			vhost_discard_vq_desc(vq, headcount);
> +			vhost_discard_vq_desc(vq, headcount, ndesc);
>  			goto out;
>  		}
>  		nvq->done_idx += headcount;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 8570fdf2e14a..a78226b37739 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2792,18 +2792,34 @@ static int get_indirect(struct vhost_virtqueue *vq,
>  	return 0;
>  }
>  
> -/* This looks in the virtqueue and for the first available buffer, and converts
> - * it to an iovec for convenient access.  Since descriptors consist of some
> - * number of output then some number of input descriptors, it's actually two
> - * iovecs, but we pack them into one and note how many of each there were.
> +/**
> + * vhost_get_vq_desc_n - Fetch the next available descriptor chain and build iovecs
> + * @vq: target virtqueue
> + * @iov: array that receives the scatter/gather segments
> + * @iov_size: capacity of @iov in elements
> + * @out_num: the number of output segments
> + * @in_num: the number of input segments
> + * @log: optional array to record addr/len for each writable segment; NULL if unused
> + * @log_num: optional output; number of entries written to @log when provided
> + * @ndesc: optional output; number of descriptors consumed from the available ring
> + *         (useful for rollback via vhost_discard_vq_desc)
>   *
> - * This function returns the descriptor number found, or vq->num (which is
> - * never a valid descriptor number) if none was found.  A negative code is
> - * returned on error. */
> -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> -		      struct iovec iov[], unsigned int iov_size,
> -		      unsigned int *out_num, unsigned int *in_num,
> -		      struct vhost_log *log, unsigned int *log_num)
> + * Extracts one available descriptor chain from @vq and translates guest addresses
> + * into host iovecs.
> + *
> + * On success, advances @vq->last_avail_idx by 1 and @vq->next_avail_head by the
> + * number of descriptors consumed (also stored via @ndesc when non-NULL).
> + *
> + * Return:
> + * - head index in [0, @vq->num) on success;
> + * - @vq->num if no descriptor is currently available;
> + * - negative errno on failure
> + */
> +int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
> +			struct iovec iov[], unsigned int iov_size,
> +			unsigned int *out_num, unsigned int *in_num,
> +			struct vhost_log *log, unsigned int *log_num,
> +			unsigned int *ndesc)
>  {
>  	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>  	struct vring_desc desc;
> @@ -2921,17 +2937,49 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>  	vq->last_avail_idx++;
>  	vq->next_avail_head += c;
>  
> +	if (ndesc)
> +		*ndesc = c;
> +
>  	/* Assume notifications from guest are disabled at this point,
>  	 * if they aren't we would need to update avail_event index. */
>  	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
>  	return head;
>  }
> +EXPORT_SYMBOL_GPL(vhost_get_vq_desc_n);
> +
> +/* This looks in the virtqueue and for the first available buffer, and converts
> + * it to an iovec for convenient access.  Since descriptors consist of some
> + * number of output then some number of input descriptors, it's actually two
> + * iovecs, but we pack them into one and note how many of each there were.
> + *
> + * This function returns the descriptor number found, or vq->num (which is
> + * never a valid descriptor number) if none was found.  A negative code is
> + * returned on error.
> + */
> +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> +		      struct iovec iov[], unsigned int iov_size,
> +		      unsigned int *out_num, unsigned int *in_num,
> +		      struct vhost_log *log, unsigned int *log_num)
> +{
> +	return vhost_get_vq_desc_n(vq, iov, iov_size, out_num, in_num,
> +				   log, log_num, NULL);
> +}
>  EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
>  
> -/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
> -void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> +/**
> + * vhost_discard_vq_desc - Reverse the effect of vhost_get_vq_desc_n()
> + * @vq: target virtqueue
> + * @nbufs: number of buffers to roll back
> + * @ndesc: number of descriptors to roll back
> + *
> + * Rewinds the internal consumer cursors after a failed attempt to use buffers
> + * returned by vhost_get_vq_desc_n().
> + */
> +void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int nbufs,
> +			   unsigned int ndesc)
>  {
> -	vq->last_avail_idx -= n;
> +	vq->next_avail_head -= ndesc;
> +	vq->last_avail_idx -= nbufs;
>  }
>  EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
>  
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 621a6d9a8791..b49f08e4a1b4 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -230,7 +230,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
>  		      struct iovec iov[], unsigned int iov_size,
>  		      unsigned int *out_num, unsigned int *in_num,
>  		      struct vhost_log *log, unsigned int *log_num);
> -void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
> +
> +int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
> +			struct iovec iov[], unsigned int iov_size,
> +			unsigned int *out_num, unsigned int *in_num,
> +			struct vhost_log *log, unsigned int *log_num,
> +			unsigned int *ndesc);
> +
> +void vhost_discard_vq_desc(struct vhost_virtqueue *, int nbuf,
> +			   unsigned int ndesc);
>  
>  bool vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
>  bool vhost_vq_has_work(struct vhost_virtqueue *vq);
> -- 
> 2.31.1


