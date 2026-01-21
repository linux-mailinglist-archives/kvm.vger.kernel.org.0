Return-Path: <kvm+bounces-68709-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMmNJHfDcGkNZwAAu9opvQ
	(envelope-from <kvm+bounces-68709-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:15:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C82C56999
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2D78850CEC7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 12:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9685F41322D;
	Wed, 21 Jan 2026 12:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoZ9WNtn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TT4lfn2s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973543A9DA4
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 12:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768997246; cv=none; b=piDLJd9xyZ3HfOnL64CkwzJx9isKGWGyaeDzS2AKzIzK4MjpDHLOo2TlWe6fWdpyrYk7RRDqFylydZaG7gtdnfIpupen9GYbotDjAXY/8xwLD49RTjh9n52w3VCke0Zl3iDL+KaNk+FoZYynTc3OCZUWjc8a2U7D4PgIiBUX2V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768997246; c=relaxed/simple;
	bh=sRJH0LcPiGEMiEKO6ssQ7+EoDIhVQvOD4UKf23OY3vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uusR4KndNIaWZOC9uCWwsSeuOfkhgscb0A58/uEBwDG98BgQUaPybbLLAq5h5ZOiV26GapMPwpKmpVd/zm0JZbtbZOBPS8xLAuMu1FwDaXrif9HKdHkvbsLwZBk5a4ysfp7q7STvd+TsG+uD8Lc7kfRxatop1JUINt3j73ySc+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UoZ9WNtn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TT4lfn2s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768997243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dRcVrBqhQujwyY3t8+ooFMd21puB/4S+X1pfO3AW+ug=;
	b=UoZ9WNtnzrZj/fh35Z+uNAFJO3PYsu5hB3DfMitohaFUmAsz7bfgRaROfPwQsoci3rZNsB
	UIwJxkoAR7z3QB/Rpm7X1BLIfBF2kuSUilheNzz62KoakLbL04gFGy2m2dugBVophJ4rXB
	wWjVBjycB8JdYcpQrnprBIrcLMcOXEY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-vz9GlnR0NqCcU-lrD9uZJA-1; Wed, 21 Jan 2026 07:07:22 -0500
X-MC-Unique: vz9GlnR0NqCcU-lrD9uZJA-1
X-Mimecast-MFC-AGG-ID: vz9GlnR0NqCcU-lrD9uZJA_1768997241
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48025e12b5bso38796755e9.2
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 04:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768997241; x=1769602041; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dRcVrBqhQujwyY3t8+ooFMd21puB/4S+X1pfO3AW+ug=;
        b=TT4lfn2sSGIKKmGEFjXuJ+gDHTb4eBFDlCoigiVvx4ghQtF6sx/ehFf+TaiH+C85X6
         ufbuZYdyiGHR9WK9+vbYoLBP6btx2S/eUnK1J6TP2jPRwiCwpmgJMkoj53mxxIC4BT+y
         Tyu4vwfv9rH+eZHaSMImnCkoKW5oNlJgTuRhvbqyYUVRY2tb+tj//Xz0B0NllXpV/wD7
         ESc+l2Tu922YtRvmNXXeGUg8ll2qPoY7HUX8QgGlxtaMdaMjYq+r0FFTt2hW+gkPd6O7
         cRx2Iu06Q1zYPvnmF+wqTlPlPe+yWofTOPPEC17fET6VqXfLDm46rTlUkdb3J7IpuMPJ
         /kVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768997241; x=1769602041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRcVrBqhQujwyY3t8+ooFMd21puB/4S+X1pfO3AW+ug=;
        b=CGlHtN6d99L8lQCbJfRHWT7Kka3Ws4PlfUS79sFpMnS8Zun4u+Vkcj+TaOG78ms5mU
         lTIIqzmMWyU0cBhd0qrAOxhLw8RX3h88kmU7r7RH+6rcVK8r+L7MvfPqW26VAjCVYjxX
         B2IrPQHtPsnpXxn2/117jnb8zuJWrnCykSH4SYHchtp6v8iz7JpNVEjwy5PtIPemTeEl
         Xcf3KLFZV825PuAlMjS9On3NsJ6Fjfe/Vze8N4La4+hVULxrsQ3GcbTlGxvXF1nBuNOS
         2vOA3vgEY53VI+ip+YVLW5cYv6t0Krz1TDA3GT4b/DK5mDrItUchGEyrWtqWGC6RBO5i
         SZRw==
X-Forwarded-Encrypted: i=1; AJvYcCVcH1UxNz8wG/zWpzIFI6IQxpEoeAqTOEWOABoJ9TZMJff6wdoaru7Xi+l3no/0nAQIBPM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGguc/plHcm9/a+Hj7FA4/y6BbBQiwfjARzf3ACNEcQNz/mjmW
	ezvJbBvH5R9mKxJjDnSsD3mDDXu1jBRyGi+VkHho/umDkKgE7aky+MkrY2LNdsiyWumEQYsSjUX
	v6bwSPnHfhN5jnatxPuzJR1a2PliGVWovzzrdiuji7cOQLA26CF33+g==
X-Gm-Gg: AZuq6aKWhNXzDE5m6g0X29E0yWmj+QlREfqiKrIyzm3mFSOYZhT9IEzR9VWntaznOJo
	CeTQcmmgoFtHJLOrXzt6HjEPVnZT3A1oW8C4Bt48/in6SZjq5F7VexJ/K5ChsjZa71sIZZgUHeg
	sRMnZtYSvLWMm412AhMztHbmo6kK1U283zkFAFG+AHxA2pClvijvHEOFDzE/8k21qlwgj3auVuU
	3XK2jkqWyWyOwaiKPhylqJBWBvYIoKoHQkP06hUX4hA3nI2hzb5Shp1pWC2imhk0tZ07SKeRsLO
	mgTUP2d/EATbNLnkROw40PkX/bv8HDVYM8mUODBUf2vGjXRt8AQDV/ocbSDBmqD4Y4hK5hYx9lI
	6TzsazQHzH84R3k4=
X-Received: by 2002:a05:600c:3e0e:b0:480:3ad0:6509 with SMTP id 5b1f17b1804b1-4803e7a2da0mr80803005e9.12.1768997240987;
        Wed, 21 Jan 2026 04:07:20 -0800 (PST)
X-Received: by 2002:a05:600c:3e0e:b0:480:3ad0:6509 with SMTP id 5b1f17b1804b1-4803e7a2da0mr80802465e9.12.1768997240572;
        Wed, 21 Jan 2026 04:07:20 -0800 (PST)
Received: from leonardi-redhat ([176.206.16.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-480424a37dasm22002135e9.2.2026.01.21.04.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 04:07:20 -0800 (PST)
Date: Wed, 21 Jan 2026 13:07:17 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>, 
	Jakub Kicinski <kuba@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Asias He <asias@redhat.com>, Melbin K Mathew <mlbnkm1@gmail.com>
Subject: Re: [PATCH net v6 1/4] vsock/virtio: fix potential underflow in
 virtio_transport_get_credit()
Message-ID: <aXDBKc0HyN8f-8l7@leonardi-redhat>
References: <20260121093628.9941-1-sgarzare@redhat.com>
 <20260121093628.9941-2-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260121093628.9941-2-sgarzare@redhat.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68709-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,google.com,redhat.com,sberdevices.ru,davemloft.net,lists.linux.dev,linux.vnet.ibm.com,linux.alibaba.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leonardi@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 3C82C56999
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 10:36:25AM +0100, Stefano Garzarella wrote:
>From: Melbin K Mathew <mlbnkm1@gmail.com>
>
>The credit calculation in virtio_transport_get_credit() uses unsigned
>arithmetic:
>
>  ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>
>If the peer shrinks its advertised buffer (peer_buf_alloc) while bytes
>are in flight, the subtraction can underflow and produce a large
>positive value, potentially allowing more data to be queued than the
>peer can handle.
>
>Reuse virtio_transport_has_space() which already handles this case and
>add a comment to make it clear why we are doing that.
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
>[Stefano: use virtio_transport_has_space() instead of duplicating the code]
>[Stefano: tweak the commit message]
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 16 +++++++++-------
> 1 file changed, 9 insertions(+), 7 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 26b979ad71f0..6175124d63d3 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -28,6 +28,7 @@
>
> static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
> 					       bool cancel_timeout);
>+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs);
>
> static const struct virtio_transport *
> virtio_transport_get_ops(struct vsock_sock *vsk)
>@@ -499,9 +500,7 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> 		return 0;
>
> 	spin_lock_bh(&vvs->tx_lock);
>-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>-	if (ret > credit)
>-		ret = credit;
>+	ret = min_t(u32, credit, virtio_transport_has_space(vvs));
> 	vvs->tx_cnt += ret;
> 	vvs->bytes_unsent += ret;
> 	spin_unlock_bh(&vvs->tx_lock);
>@@ -877,11 +876,14 @@ u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_has_data);
>
>-static s64 virtio_transport_has_space(struct vsock_sock *vsk)
>+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
> {
>-	struct virtio_vsock_sock *vvs = vsk->trans;
> 	s64 bytes;
>
>+	/* Use s64 arithmetic so if the peer shrinks peer_buf_alloc while
>+	 * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction
>+	 * does not underflow.
>+	 */
> 	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> 	if (bytes < 0)
> 		bytes = 0;
>@@ -895,7 +897,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk)
> 	s64 bytes;
>
> 	spin_lock_bh(&vvs->tx_lock);
>-	bytes = virtio_transport_has_space(vsk);
>+	bytes = virtio_transport_has_space(vvs);
> 	spin_unlock_bh(&vvs->tx_lock);
>
> 	return bytes;
>@@ -1492,7 +1494,7 @@ static bool virtio_transport_space_update(struct sock *sk,
> 	spin_lock_bh(&vvs->tx_lock);
> 	vvs->peer_buf_alloc = le32_to_cpu(hdr->buf_alloc);
> 	vvs->peer_fwd_cnt = le32_to_cpu(hdr->fwd_cnt);
>-	space_available = virtio_transport_has_space(vsk);
>+	space_available = virtio_transport_has_space(vvs);
> 	spin_unlock_bh(&vvs->tx_lock);
> 	return space_available;
> }
>-- 2.52.0
>

LGTM!

Reviewed-by: Luigi Leonardi <leonardi@redhat.com>


