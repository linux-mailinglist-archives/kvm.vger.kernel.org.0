Return-Path: <kvm+bounces-65766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F75CB5FA1
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 85A903021F89
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 13:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC6F312817;
	Thu, 11 Dec 2025 13:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QYg6A8HJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UK0Gq4IQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306991E487
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765458321; cv=none; b=u2ON5ISpAGLlPHclBpdyeLFskIEERklX29BYea6nKrEiYu45eMEmUJcVeN5JA2vVEWTSPHSDamo9MaKvVTafOL+He6SoqsYqJVvIqyPJDM/yt/zHR1UATq2E0DejsGChMcFa+f8+bIQlCcSjxW+VyteZr5e4wTEQGvn/Wl1JIqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765458321; c=relaxed/simple;
	bh=4PmEx62E8ydX53H6/0G1uCp0HaldgwDpk3PidZ7yJt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxIoFTaYXhuIOwj9X20lvn0fi8aYd9SBm5TwZx0IXOtRDKlzd3iIMfVDGOVCaHGOzX25LcpwRY/QyTMv7QTjdbcSSh4Mejj1pPQUwrChRhzK8KPtY6SYymuYhOHE7NvvKnLki8hehqL/KOyovygRhcCQcgBj+xXlO5BjCQUuFEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QYg6A8HJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UK0Gq4IQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765458319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TYNnXnJ5gIMrbYv/zhSBQM+jvg2wwE07t89qnxBRHQ=;
	b=QYg6A8HJz3o+mBD+HTxF242EpMS0hrEldsRt/6IZUSyl2gBYKDjYJ/06LiPIBY66MjffLb
	OlKUGuTzExwPEJ0OkZZeYPVupHt+tz+s06NJ/QebCHYdSvSJIa7K4XDsfc22sxw/SetawR
	5aAFYJAjfW0rKsi5aIdGujlTt0XMQIM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660--bBzLSLIOgW8NOZQqJY_ew-1; Thu, 11 Dec 2025 08:05:18 -0500
X-MC-Unique: -bBzLSLIOgW8NOZQqJY_ew-1
X-Mimecast-MFC-AGG-ID: -bBzLSLIOgW8NOZQqJY_ew_1765458317
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so569975e9.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765458317; x=1766063117; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7TYNnXnJ5gIMrbYv/zhSBQM+jvg2wwE07t89qnxBRHQ=;
        b=UK0Gq4IQrIaQknKgiJCZQnph7PqEuo25MXgSz9eFSyhWytPrBue5H/G23ev+nWk05P
         hRWXoumLx1aiCClyJIqz9U5U6wlfkTQ09rE96GCAOv1q8OLRhDTxaVD5IdFkDlcdIyMG
         WsWW9BlKiHWyaID3TWUBIVuhnbn2lHDQPT2It+5zYGAX4NKwQLRyraD48ur6NRF1kXvG
         jDAxC3O9TmO2BGUjwNsymBysfBdJ/XY8LZgAdrcSXvVwBFebtArTXg+wOO8528ZKRwz2
         Gz/vojIWY0wlt/ARHh7PYGNEUcT0UjbS5q/v6XJpjAaUXevNx3n7EJlV8fatEVv/O2qG
         +G1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765458317; x=1766063117;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7TYNnXnJ5gIMrbYv/zhSBQM+jvg2wwE07t89qnxBRHQ=;
        b=tlWlnnuFnyyy66vZCilrYxKVId1HaHNRn7Ob6geYy5ylvz/tY8ZimwyTEqTdH2xvFe
         32hXKGaahMYO/LItjCUBUtg2z3dLEKwxVRVdbWsZlgOt5RkxPpy0yyGjtvX7o8Um3YxP
         RTYmVIscvh6rq9jNhT6hZA9oZXC8ROGQQ/FrTjxBw/KJHPDwH2ALjr2AgS1oIdMli41A
         5ZVzgkRYI0ZRIYDPKdR4J/Q1CIxBnIKjo4re+7UqhwuZm/3F2NpIfiEbvj/60A+Ku4uW
         9/BdHAZOmi4cwh7H32HPa6u3X08xUWYV+npqYnVFsd33NiAIPFuRx7Lc9pmMUcoF4/C7
         3/Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWHdvcIJ4Ih+FZF2e5TNISzi5XGDXAwtzvextIWCgP8s2rKkvEu5KiPmr9KwLKeAlWPkX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YysQpHYX2NZaT0nCHE+pAgzPOzVpOTR1YoRhH/2nh7q2H3azGVN
	hISSRarVOb5FSnvmv5kvhWUCbDSvWMHYVRIHBA1D7mx9dBQqqp18o0GIwCmYsHq9ufx0HQQg3ti
	yttVlIFvrzm1KYNm83sTFVqDx7z4vxS0ekoTtrOlmvhLQB7JJsL7pGw==
X-Gm-Gg: AY/fxX7jpG+YxnncONSsSnNnzoiSf2MoHfZiqG37+m/3hBqXjHrDbXxtwL6RcrAgZWq
	n1QNwqhtTbVd7HdXz+Yn3DMv4gle3KIW9PMaFt0uJohTu4+mi/sQSDkktUOKmtRsWVAd3k0hFHQ
	fD2wpIFmxBproLyRP+3ZFC/0j2yzzGpRbN6DCn6tlvwPL9UNJcwQcs0S5M5EicAVvqhRypkuPA+
	C+iSbV2VaWZIHLx4Acs62dxr/8cxS59qAqSjgaYo1suFs/Nb1Bhwpd9ItZEx8hCHh1nx26xmoVB
	jA7m9VzMcK1nGftaPOuQ7G7UoltWBf3D5GGBD1tJZe+SKQ/dOtaZ10Kt1Ob/4VW7JmeM7T4mFkq
	QMpOfSB8Y4RRaLU/O56/S9yMXRNdQPjk=
X-Received: by 2002:a05:600c:4f90:b0:477:b734:8c52 with SMTP id 5b1f17b1804b1-47a83814567mr56139585e9.14.1765458316543;
        Thu, 11 Dec 2025 05:05:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiw9qORfMiukhfUqJHnTv2m1tahwL8gsL0GvKKtmbTJLCX9/pRrcqU6zB2PSWaKUWEi94q9A==
X-Received: by 2002:a05:600c:4f90:b0:477:b734:8c52 with SMTP id 5b1f17b1804b1-47a83814567mr56138995e9.14.1765458315872;
        Thu, 11 Dec 2025 05:05:15 -0800 (PST)
Received: from redhat.com (IGLD-80-230-32-59.inter.net.il. [80.230.32.59])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8a70665sm6062132f8f.17.2025.12.11.05.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 05:05:14 -0800 (PST)
Date: Thu, 11 Dec 2025 08:05:11 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, kvm@vger.kernel.org,
	netdev@vger.kernel.org, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org, jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org
Subject: Re: [PATCH net v3] vsock/virtio: cap TX credit to local buffer size
Message-ID: <20251211080251-mutt-send-email-mst@kernel.org>
References: <20251211125104.375020-1-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251211125104.375020-1-mlbnkm1@gmail.com>

On Thu, Dec 11, 2025 at 01:51:04PM +0100, Melbin K Mathew wrote:
> The virtio vsock transport currently derives its TX credit directly from
> peer_buf_alloc, which is populated from the remote endpoint's
> SO_VM_SOCKETS_BUFFER_SIZE value.
> 
> On the host side, this means the amount of data we are willing to queue
> for a given connection is scaled purely by a peer-chosen value, rather
> than by the host's own vsock buffer configuration. A guest that
> advertises a very large buffer and reads slowly can cause the host to
> allocate a correspondingly large amount of sk_buff memory for that
> connection.
> 
> In practice, a malicious guest can:
> 
>   - set a large AF_VSOCK buffer size (e.g. 2 GiB) with
>     SO_VM_SOCKETS_BUFFER_MAX_SIZE / SO_VM_SOCKETS_BUFFER_SIZE, and
> 
>   - open multiple connections to a host vsock service that sends data
>     while the guest drains slowly.
> 
> On an unconstrained host this can drive Slab/SUnreclaim into the tens of
> GiB range, causing allocation failures and OOM kills in unrelated host
> processes while the offending VM remains running.
> 
> On non-virtio transports and compatibility:
> 
>   - VMCI uses the AF_VSOCK buffer knobs to size its queue pairs per
>     socket based on the local vsk->buffer_* values; the remote side
>     can’t enlarge those queues beyond what the local endpoint
>     configured.
> 
>   - Hyper-V’s vsock transport uses fixed-size VMBus ring buffers and
>     an MTU bound; there is no peer-controlled credit field comparable
>     to peer_buf_alloc, and the remote endpoint can’t drive in-flight
>     kernel memory above those ring sizes.
> 
>   - The loopback path reuses virtio_transport_common.c, so it
>     naturally follows the same semantics as the virtio transport.
> 
> Make virtio-vsock consistent with that model by intersecting the peer’s
> advertised receive window with the local vsock buffer size when
> computing TX credit. We introduce a small helper and use it in
> virtio_transport_get_credit(), virtio_transport_has_space() and
> virtio_transport_seqpacket_enqueue(), so that:
> 
>     effective_tx_window = min(peer_buf_alloc, buf_alloc)
> 
> This prevents a remote endpoint from forcing us to queue more data than
> our own configuration allows, while preserving the existing credit
> semantics and keeping virtio-vsock compatible with the other transports.
> 
> On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
> 32 guest vsock connections advertising 2 GiB each and reading slowly
> drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB and the system only
> recovered after killing the QEMU process.
> 
> With this patch applied, rerunning the same PoC yields:
> 
>   Before:
>     MemFree:        ~61.6 GiB
>     MemAvailable:   ~62.3 GiB
>     Slab:           ~142 MiB
>     SUnreclaim:     ~117 MiB
> 
>   After 32 high-credit connections:
>     MemFree:        ~61.5 GiB
>     MemAvailable:   ~62.3 GiB
>     Slab:           ~178 MiB
>     SUnreclaim:     ~152 MiB
> 
> i.e. only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the
> guest remains responsive.
> 
> Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 27 ++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index dcc8a1d58..02eeb96dd 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -491,6 +491,25 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>  
> +/* Return the effective peer buffer size for TX credit computation.
> + *
> + * The peer advertises its receive buffer via peer_buf_alloc, but we
> + * cap that to our local buf_alloc (derived from
> + * SO_VM_SOCKETS_BUFFER_SIZE and already clamped to buffer_max_size)
> + * so that a remote endpoint cannot force us to queue more data than
> + * our own configuration allows.
> + */
> +static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
> +{
> +	return min(vvs->peer_buf_alloc, vvs->buf_alloc);
> +}
> +
>  u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
>  {
>  	u32 ret;
> @@ -499,7 +518,8 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
>  		return 0;
>  
>  	spin_lock_bh(&vvs->tx_lock);
> -	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> +	ret = virtio_transport_tx_buf_alloc(vvs) -
> +		(vvs->tx_cnt - vvs->peer_fwd_cnt);
>  	if (ret > credit)
>  		ret = credit;
>  	vvs->tx_cnt += ret;
> @@ -831,7 +851,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>  
>  	spin_lock_bh(&vvs->tx_lock);
>  
> -	if (len > vvs->peer_buf_alloc) {
> +	if (len > virtio_transport_tx_buf_alloc(vvs)) {
>  		spin_unlock_bh(&vvs->tx_lock);
>  		return -EMSGSIZE;
>  	}
> @@ -882,7 +902,8 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
>  	struct virtio_vsock_sock *vvs = vsk->trans;
>  	s64 bytes;
>  
> -	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> +	bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
> +		(vvs->tx_cnt - vvs->peer_fwd_cnt);
>  	if (bytes < 0)
>  		bytes = 0;
>  

Acked-by: Michael S. Tsirkin <mst@redhat.com>


Looking at this, why is one place casting to s64 the other is not?




> -- 
> 2.34.1


