Return-Path: <kvm+bounces-62989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AA66BC5635A
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 09:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 85BD635134D
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 08:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C94E5330B14;
	Thu, 13 Nov 2025 08:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXT2YJTY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tQ8ygYT2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03C82F3618
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 08:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763021591; cv=none; b=DN4Vs7ONbBojyzlOArM04NJ0/L7Ree8A/+OBwaz4ntKOo4sYMRirgl3QncRG3ET4/HqoPOqfmqELFLnLeNWaIHAMf44ESG17uWseCwOzQel7KTR5FmEy0xCrHBG07v5M5StNRDpG17D0m/Ncmn//sIQidZf97ylIZv5+T0c66zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763021591; c=relaxed/simple;
	bh=Ap2yBhzXTU6O9fGE+Hj6HPv06KYwiyh5Yi2mJXSIy64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=an8Nm1n2H20kMdubBt80yXDMnIA8T/C8Dz6D3O57YlRKtrYrN103qE1pphVnSz0t1zoW62Wl9BhwOb5yBxB933l84W4ByZtnfbpPRGf6TGmlNoXRPeEFbAxvGQkibpaTp6a0rGfz1kpUSOJ5UPDrdNUE4onAdaEhZ3xVMdr3m4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXT2YJTY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tQ8ygYT2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763021588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4DGVaSw4kPeGIDKxD03tfYFZ4BdD6dssNRKM1w0msCk=;
	b=CXT2YJTY1Nqk/lRMblEf1ThTmZhqk+8CDp6xVJiLsccz5izRRKz1GAssE17iBPgQwl0yy+
	oTtGgPrQ9MJyIFlK/we2QuBsSuldxlFYqYbGLWeGZtg9FwZK4iy3wMhRlVZvgJRpdgnE6j
	Ebd9Wwv+deY7u9OdakQxUYs985309G0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-4qU_L2rKNYCkmhNxfakWTg-1; Thu, 13 Nov 2025 03:13:06 -0500
X-MC-Unique: 4qU_L2rKNYCkmhNxfakWTg-1
X-Mimecast-MFC-AGG-ID: 4qU_L2rKNYCkmhNxfakWTg_1763021586
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477563e531cso4744725e9.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 00:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763021585; x=1763626385; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4DGVaSw4kPeGIDKxD03tfYFZ4BdD6dssNRKM1w0msCk=;
        b=tQ8ygYT2KXIVLTxEqOnYpfU84+aeEYs/ynC0ksVdF7l5gHr1901LuF71ejSpa1I+6V
         96EYNgfnxsR9WBD+c3aq3cuG3VN7C93KyPQvMmrdBnqjysj0Te5uSw9oFKXHexaRUN4f
         BujKbbWoF/YQgeK+Y7bGxC1bit36qBhgHp4UQB86ynuRDpyrvsyBfxiS7hTl9utNeuus
         s1htUObCPi4RUWNzMUUaX1XWWfyxkaEp2n7o1LE6cE9Cfp+PhuOrxFVaSXjJcnIgEkDR
         dgBXwVZwanH0/Eor2PD8irjT2aeYJTWYJeS6I2rB0NaDvJ2cQhq+7bAHQQKfilAghTya
         Xd5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763021585; x=1763626385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DGVaSw4kPeGIDKxD03tfYFZ4BdD6dssNRKM1w0msCk=;
        b=rEioCXqvljTqj1Osqki5fZvgUQpDzA2bZymHWQmxToVpE1f/o+32sESaqSuEW3Y3um
         vnWNp90QU8G1eucYwo9WGhoqS4jC4grLx3CeanH/CDczml43+GDUTHaIcojWT6C2Ngbz
         DQy8mI+i2ogLcdTUSa8Kv/R1EuHG4rWhtHArzl8g1+GXKdZRfiZTnBlwsZPt3D8L2MsN
         cSls+A4bAiIjBjJAjyKYR1DG75K+LKLCyTAHPX6gH8utYevjiTb3n5XvFe2kAxp9S5BQ
         70y/Rdq2NT49DJ9YWDRkC0z1h5iqP37cWuXCU0fMw+CYKmSKU81OMHzpURKCEXCMFcVv
         5guw==
X-Gm-Message-State: AOJu0YylLhXJi9SHeXvbXt9rQ7o66XWFSk+gxqCUNtEGALP9FlIL/NYZ
	8emLv/NdvjphEAnr9ky9H0gBfSAM5/MCcIuSgCx5n6SNss4BoFoJ1hN2+vHsofmk5Rjl+EbBnis
	f4eU3G3oHXm8hh1AAHx8wPD/ScV8D1I/dPqAKya+y66qyadeWxoHu9g==
X-Gm-Gg: ASbGnctG6mgMRVwn7Yr/MsemWP7km+8OMSBSVvM+v8j4yTsICfs0s6YJmCjYjdzdQgp
	eamDeBTC1MchUX2LQ4saHjanE1abo5aWiaIianvc9r5tCDThipdX5HLtlJEQ/Krl9tlh5rk6atp
	4v6s+UdAz1agEw70gtdikUK14t/t9bNMQYgV4jPestvm91Lnp7CORphlUMF6AyPpJ0hlqdDEcWi
	H9G4SdkSWeRlc1c03RlZWv/OOD0WKl6y+I6BiBvqWOcOkVnRk9HvulnUQgcCsSa7ZMc7ee4cnkJ
	lckqcnCkCB2P1EeGZawYdViERBE0PsDvma+cD5n+RhpMYG+wmEtgkYSHoh3yqG4uPQ+svvysuoB
	+ytHb/A0SdMejDPRK09o=
X-Received: by 2002:a05:600c:a44:b0:477:832c:86ae with SMTP id 5b1f17b1804b1-4778707ca20mr55192355e9.12.1763021585445;
        Thu, 13 Nov 2025 00:13:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIQgN138Wh9SyzvdeVmx3/FSQLTRYGtc1iBG+F/973cdwN4YYhSCw6TLEU3JsjzbHZAdvt9g==
X-Received: by 2002:a05:600c:a44:b0:477:832c:86ae with SMTP id 5b1f17b1804b1-4778707ca20mr55191905e9.12.1763021584764;
        Thu, 13 Nov 2025 00:13:04 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4778c8a992bsm20321275e9.16.2025.11.13.00.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 00:13:04 -0800 (PST)
Date: Thu, 13 Nov 2025 03:13:01 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] vhost: rewind next_avail_head while discarding
 descriptors
Message-ID: <20251113030230-mutt-send-email-mst@kernel.org>
References: <20251113015420.3496-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113015420.3496-1-jasowang@redhat.com>

On Thu, Nov 13, 2025 at 09:54:20AM +0800, Jason Wang wrote:
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

Wow that change really caused a lot of fallout.

Thanks for the patch! Yet something to improve:


> ---
>  drivers/vhost/net.c   | 53 ++++++++++++++++++++++++++-----------------
>  drivers/vhost/vhost.c | 43 ++++++++++++++++++++++++-----------
>  drivers/vhost/vhost.h |  9 +++++++-
>  3 files changed, 70 insertions(+), 35 deletions(-)
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

So here ndesc and n are the same, but below in vhost_discard_vq_desc
they are different. Fun.

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
> index 8570fdf2e14a..b56568807588 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2792,18 +2792,11 @@ static int get_indirect(struct vhost_virtqueue *vq,
>  	return 0;
>  }
>  
> -/* This looks in the virtqueue and for the first available buffer, and converts
> - * it to an iovec for convenient access.  Since descriptors consist of some
> - * number of output then some number of input descriptors, it's actually two
> - * iovecs, but we pack them into one and note how many of each there were.
> - *
> - * This function returns the descriptor number found, or vq->num (which is
> - * never a valid descriptor number) if none was found.  A negative code is
> - * returned on error. */

A new module API with no docs at all is not good.
Please add documentation to this one. vhost_get_vq_desc
is a subset and could refer to it.

> -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> -		      struct iovec iov[], unsigned int iov_size,
> -		      unsigned int *out_num, unsigned int *in_num,
> -		      struct vhost_log *log, unsigned int *log_num)
> +int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
> +			struct iovec iov[], unsigned int iov_size,
> +			unsigned int *out_num, unsigned int *in_num,
> +			struct vhost_log *log, unsigned int *log_num,
> +			unsigned int *ndesc)

>  {
>  	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>  	struct vring_desc desc;
> @@ -2921,16 +2914,40 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
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
>  /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
> -void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> +void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n,
> +			   unsigned int ndesc)

ndesc is number of descriptors? And n is what, in that case?


>  {
> +	vq->next_avail_head -= ndesc;
>  	vq->last_avail_idx -= n;
>  }
>  EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 621a6d9a8791..69a39540df3d 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -230,7 +230,14 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
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
> +void vhost_discard_vq_desc(struct vhost_virtqueue *, int n, unsigned int ndesc);
>  
>  bool vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
>  bool vhost_vq_has_work(struct vhost_virtqueue *vq);
> -- 
> 2.31.1


