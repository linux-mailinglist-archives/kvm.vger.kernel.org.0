Return-Path: <kvm+bounces-20487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91FC4916948
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED0D3B21CF1
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A144A1607BA;
	Tue, 25 Jun 2024 13:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvgmyJqG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B621E494
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719323184; cv=none; b=TBJt/e//b78oByaIXoOZxqNzTRLCLUz5Cj7UVPViDo7gAauGKZ8DbHPWEG7a9xRUPVyGe0FUjOFZWWZFKRO53v5FygPJn479b+REfVHOSdwycakvS3KhABgjBv0MxJU04h9MdbiCMcVcvnPbou28iVoRcfv3huiS99FJT9cKQew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719323184; c=relaxed/simple;
	bh=vfo9iXqy/970YzrxmklBYDaq0RPH6PhseDRgP91Fz+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eY81BZYL1kzpI++SOQxHGRVanTvKU9ynGQUvocTArFDcKwhXaFVVEANm0/Ih+TxoVsAuX16RdvwsgbWsmSZjUSpKTsRzx/LehZyRo1Lzd49cLOvTiZ+jsWGeE6GzyYVUsVPL7XXqSWDpUzQzXLDq+KWsF1OmxPB3twuU9CUwU9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvgmyJqG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719323182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gPjoHIe5MDYXs/lRS7+72fRb4oaPZZtDvA0u547prQU=;
	b=dvgmyJqGx6gp8A3GK0RK4TDVYzr+fCz2FmP4fDF0f+bNiLvehkcGSzI4KnyZYJAZ26hkpz
	5D+HEfIYgbAyDhGFHZ5YbcoUHIYHO+nyzXlx1mJ3NpER8pK82Wmt6FuQp73aAaArd4E9A2
	zFBDyQMlgKqJYwKMu8KhJ7aK/w4+Sr0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-Wr_Cv5i3NqSEyoeUH0Cr3Q-1; Tue, 25 Jun 2024 09:46:20 -0400
X-MC-Unique: Wr_Cv5i3NqSEyoeUH0Cr3Q-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-422322e4abaso30148455e9.1
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 06:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719323179; x=1719927979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPjoHIe5MDYXs/lRS7+72fRb4oaPZZtDvA0u547prQU=;
        b=rgdxoazlG4b71Z4zaRct6akpiWbbiLzB1Y48gWCy+oh6LKbz1w6ZnA60BMBSfjAbSN
         vMcKP5ZYSS9AUsXFX6+eP8LqPSoWbMahxT1YyYKA7S0F4IndaoGmLu5Sc7M6VQ85hMhP
         9DTHiLBKDtHXa6Q7lt4Pn/joc40o6d31qv5HDCGww6a/e91gy8HxfiF3rKoKf56vHZnt
         NDjh+I6HAJd+OY9/oiedAYELulGod0dSyhS33bhYALbf6HeHiXWZIN+cS/c/4gOaAWgf
         CFQdWYLVzBgUS+1BRnbXVYIAcrfX1ruPN10FMBdbsHMv6u7/vvZEmw/Essqs+KP6TP20
         WSww==
X-Forwarded-Encrypted: i=1; AJvYcCVrRWatnqrrPNuOMtinLdQ2ueevlK58PemHk85Hff82Tsk8fZZcmNmD/6lsXxo651xIp7CfK1mhAuFgQNxtjIIbsFYt
X-Gm-Message-State: AOJu0YwKXoCqK3fDBfE8CADVnPrFqvrtJ7t8e7Tz9d2KeR3FtP05Uy1B
	Ps4dqCE9kIZWV7uTNcpCloeI5Pu3svU6IUI4l4MHD1h15xP0N1JqoOElwAlYnWGVf9SEhJjLeCy
	La127u4A9JO96m2gl8OPe0ONOvjgGjIh8cYJK4E+rEvNlzxYkbg==
X-Received: by 2002:a05:600c:3553:b0:424:84fb:9fd2 with SMTP id 5b1f17b1804b1-42489541879mr76820375e9.19.1719323179623;
        Tue, 25 Jun 2024 06:46:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEInYLknU3PDAumozrLMsLFwruhveRKJkmwMwzGi8w63OpSy5rfjaIFAi2mpghZFNrYBKRUUg==
X-Received: by 2002:a05:600c:3553:b0:424:84fb:9fd2 with SMTP id 5b1f17b1804b1-42489541879mr76820055e9.19.1719323178904;
        Tue, 25 Jun 2024 06:46:18 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.217.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4247d208dcesm211421255e9.31.2024.06.25.06.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 06:46:18 -0700 (PDT)
Date: Tue, 25 Jun 2024 15:46:12 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com, Alexander Graf <graf@amazon.com>
Subject: Re: [RFC PATCH v1 1/2] virtio/vsock: rework deferred credit update
 logic
Message-ID: <qkxvvvahksbz2n52s5eqk6s5yxsjjtyp4uehwy5gvrcq3sftvh@rred7jd2qsd4>
References: <20240621192541.2082657-1-avkrasnov@salutedevices.com>
 <20240621192541.2082657-2-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240621192541.2082657-2-avkrasnov@salutedevices.com>

On Fri, Jun 21, 2024 at 10:25:40PM GMT, Arseniy Krasnov wrote:
>Previous calculation of 'free_space' was wrong (but worked as expected
>in most cases, see below), because it didn't account number of bytes in
>rx queue. Let's rework 'free_space' calculation in the following way:
>as this value is considered free space at rx side from tx point of view,
>it must be equal to return value of 'virtio_transport_get_credit()' at
>tx side. This function uses 'tx_cnt' counter and 'peer_fwd_cnt': first
>is number of transmitted bytes (without wrap), second is last 'fwd_cnt'
>value received from rx. So let's use same approach at rx side during
>'free_space' calculation: add 'rx_cnt' counter which is number of
>received bytes (also without wrap) and subtract 'last_fwd_cnt' from it.
>Now we have:
>1) 'rx_cnt' == 'tx_cnt' at both sides.
>2) 'last_fwd_cnt' == 'peer_fwd_cnt' - because first is last 'fwd_cnt'
>   sent to tx, while second is last 'fwd_cnt' received from rx.
>
>Now 'free_space' is handled correctly and also we don't need

mmm, I don't know if it was wrong before, maybe we could say it was less 
accurate.

That said, could we have the same problem now if we have a lot of 
producers and the virtqueue becomes full?

>'low_rx_bytes' flag - this was more like a hack.
>
>Previous calculation of 'free_space' worked (in 99% cases), because if
>we take a look on behaviour of both expressions (new and previous):
>
>'(rx_cnt - last_fwd_cnt)' and '(fwd_cnt - last_fwd_cnt)'
>
>Both of them always grows up, with almost same "speed": only difference
>is that 'rx_cnt' is incremented earlier during packet is received,
>while 'fwd_cnt' in incremented when packet is read by user. So if 'rx_cnt'
>grows "faster", then resulting 'free_space' become smaller also, so we
>send credit updates a little bit more, but:
>
>  * 'free_space' calculation based on 'rx_cnt' gives the same value,
>    which tx sees as free space at rx side, so original idea of

Ditto, what happen if the virtqueue is full?

>    'free_space' is now implemented as planned.
>  * Hack with 'low_rx_bytes' now is not needed.

Yeah, so this patch should also mitigate issue reported by Alex (added 
in CC), right?

If yes, please mention that problem and add a Reported-by giving credit 
to Alex.

>
>Also here is some performance comparison between both versions of
>'free_space' calculation:
>
> *------*----------*----------*
> |      | 'rx_cnt' | previous |
> *------*----------*----------*
> |H -> G|   8.42   |   7.82   |
> *------*----------*----------*
> |G -> H|   11.6   |   12.1   |
> *------*----------*----------*

How many seconds did you run it? How many repetitions? There's a little 
discrepancy anyway, but I can't tell if it's just noise.

>
>As benchmark 'vsock-iperf' with default arguments was used. There is no
>significant performance difference before and after this patch.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> include/linux/virtio_vsock.h            | 1 +
> net/vmw_vsock/virtio_transport_common.c | 8 +++-----
> 2 files changed, 4 insertions(+), 5 deletions(-)

Thanks for working on this, I'll do more tests but the approach LGTM.

Thanks,
Stefano

>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index c82089dee0c8..3579491c411e 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -135,6 +135,7 @@ struct virtio_vsock_sock {
> 	u32 peer_buf_alloc;
>
> 	/* Protected by rx_lock */
>+	u32 rx_cnt;
> 	u32 fwd_cnt;
> 	u32 last_fwd_cnt;
> 	u32 rx_bytes;
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 16ff976a86e3..1d4e2328e06e 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -441,6 +441,7 @@ static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
> 		return false;
>
> 	vvs->rx_bytes += len;
>+	vvs->rx_cnt += len;
> 	return true;
> }
>
>@@ -558,7 +559,6 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	size_t bytes, total = 0;
> 	struct sk_buff *skb;
> 	u32 fwd_cnt_delta;
>-	bool low_rx_bytes;
> 	int err = -EFAULT;
> 	u32 free_space;
>
>@@ -603,9 +603,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	}
>
> 	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
>-	free_space = vvs->buf_alloc - fwd_cnt_delta;
>-	low_rx_bytes = (vvs->rx_bytes <
>-			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
>+	free_space = vvs->buf_alloc - (vvs->rx_cnt - vvs->last_fwd_cnt);
>
> 	spin_unlock_bh(&vvs->rx_lock);
>
>@@ -619,7 +617,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	 * number of bytes in rx queue is not enough to wake up reader.
> 	 */
> 	if (fwd_cnt_delta &&
>-	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
>+	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE))
> 		virtio_transport_send_credit_update(vsk);
>
> 	return total;
>-- 
>2.25.1
>
>


