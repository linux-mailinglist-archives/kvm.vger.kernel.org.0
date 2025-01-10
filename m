Return-Path: <kvm+bounces-35037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A26BFA08F2E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:26:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 329DF3A576C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E5E20D4EA;
	Fri, 10 Jan 2025 11:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NffOMgCO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF9820B215
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736508322; cv=none; b=e9aWEA7k9ofGIveZJeBp6wEfc9aOG/4dtXeRTBlVjFo2jquH8abgkwZrxjcpdhjG4YhiAyT19kIoSAnLe6qhbzf8TUSNI2uDskbJg+xv6MLdO3RGFcNB+/iOGQd9s9yRO48NdN1SxwchtGmVxIPL28TSMRRRGYV1Mu59/UVJ2c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736508322; c=relaxed/simple;
	bh=h+3V8Dg/wI18YbTuYBPBYgVfFTOtZGjB+ocTQMzeqlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcI4UtRbdg4t9Glucbpo0MOCnY0FEq6Eev0qH/QV/BWrNz/oZFjcNXH/tJ4SXIlzD/CS3+7GMz/Ia+SKH0NCDiF29TP1hpsQWxXoBMwncPJOOsN8lSyLiBeK0OG5HlX+G5KGQsl33Sj1dY2PFZrEKhuneSY+hCH2fuhtCDNu4dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NffOMgCO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736508320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4Ef2wLHVQGV1IsoMPeKXi5uZyvCqMew4uoHW3wntJAQ=;
	b=NffOMgCOAshceS8GokIk/LdN4Ak1N4IygtCeQDEfNXR8+qKbwrYfvNzrEemycOXSzZtf4J
	WPYi6KlkBD7E0RkDHPFWPNxqB3F4sB15gN/cNtYqJcJrCRJ9sH3+u1FMEkWapm4byuEMJ2
	MBkzEPmS1ydFf6nQRMXtldRz+RowVy8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-9F5cgMCTNwKpFQ8s45jV5g-1; Fri, 10 Jan 2025 06:25:18 -0500
X-MC-Unique: 9F5cgMCTNwKpFQ8s45jV5g-1
X-Mimecast-MFC-AGG-ID: 9F5cgMCTNwKpFQ8s45jV5g
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa66bc3b46dso150360066b.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:25:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736508318; x=1737113118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Ef2wLHVQGV1IsoMPeKXi5uZyvCqMew4uoHW3wntJAQ=;
        b=caxwpqyRJ2w3bQlu5lAOG+lj5x/655mUuOA820TbwFSEW3zb7evZSEVHVfHXPRMo98
         Z1cU09cFmCFqdoVTKk0x7RaH383Di3eZOKEXkGTp2ccIc2Vyfu2QW9VRHt1idomLr60d
         CV9XhZh8HEQ/Ygl941L9gXvxgq4zpd3dhvvisWkfA/QBj1l/SF4KCVcgqkBoVuxY7B28
         rmJvP8LKN4qhF609o0ul7Q5QNxxt4gZdIzdYAlUU1p2QvoP3pItSYbQm4EX+lXOTx+f8
         lXaVkhQ2MQr5FyQ1YviFHVD3Mjrv1fXpEth4hS2PSr1ryw7lpwzSr+VQGBweHfyec78f
         wA5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRzO3tC+ao+vNuPq31FxGSoZupIaum/CgTRfGCyo1p30r02h/GN4Uo8mdXRQ1Y2iyvNyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFD9funrFOJpgkDQ3BWcitUczDJU+GO/NM6GtQ4GHa1nDgSZlu
	3A8jgR86V5s/jPnO8b6nzMkHnBymOUgnfcMa8V9pRyo4hnoNgiZtiAf1NKyCOqe6JNteXJE3fQb
	WX8UhzdU+f3jCZa9edBhIpBqqYNLVmPxvbCv4FMWuuTRq99xHeg==
X-Gm-Gg: ASbGncv0qQuADpn7ydXsNIbXtaqc6vjEFbDEhxUQhh8O+uKcrMoPlF6kjAMXE0lAgHT
	zIV9U3bwkuRxWvJtFh2GmdFGVDdGR9Y3IEmXYI7pXEiduJyt0TqBJ1fs3GrGiftzeAu9pbDRsPX
	4kkReWxysjq9MQH4Ia7FVMUDQ69zztDTuEBaq+yEgX0EC6mLD9n5DySGZwJxzz9C+D12IFstylU
	yn53GiQGPZTx2Wq9JKuIoVAbOnjFcbmqyCATwHCqdd2D2m1DO7RxUDgMsz24sg=
X-Received: by 2002:a05:6402:5194:b0:5d0:fb56:3f with SMTP id 4fb4d7f45d1cf-5d972e0e341mr23290989a12.12.1736508317710;
        Fri, 10 Jan 2025 03:25:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3mqsKI2idLOS3bFseUHtOVmXbXG31Er639vFwFDT2akA/HfPxaQl8uNFpTeEdJZcPXxQTRg==
X-Received: by 2002:a05:6402:5194:b0:5d0:fb56:3f with SMTP id 4fb4d7f45d1cf-5d972e0e341mr23290897a12.12.1736508317029;
        Fri, 10 Jan 2025 03:25:17 -0800 (PST)
Received: from sgarzare-redhat ([193.207.202.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95af694sm159293266b.144.2025.01.10.03.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:25:16 -0800 (PST)
Date: Fri, 10 Jan 2025 12:25:09 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <leonardi@redhat.com>
Cc: netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Wongi Lee <qwerty@theori.io>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Eric Dumazet <edumazet@google.com>, kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Simon Horman <horms@kernel.org>, Hyunwoo Kim <v4bel@theori.io>, Jakub Kicinski <kuba@kernel.org>, 
	Michal Luczaj <mhal@rbox.co>, virtualization@lists.linux.dev, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH net v2 4/5] vsock: reset socket state when de-assigning
 the transport
Message-ID: <fjx4nkajq3cnaxdbvs3dd2sxtc35tkqlqti3h44t3xuefclwar@havkg6jfisxu>
References: <20250110083511.30419-1-sgarzare@redhat.com>
 <20250110083511.30419-5-sgarzare@redhat.com>
 <esoasx64en34ixiylalt2hldqi5duvvzrpt65xq7nioro7gbbb@rhp6lth5grj4>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <esoasx64en34ixiylalt2hldqi5duvvzrpt65xq7nioro7gbbb@rhp6lth5grj4>

On Fri, Jan 10, 2025 at 11:56:28AM +0100, Luigi Leonardi wrote:
>On Fri, Jan 10, 2025 at 09:35:10AM +0100, Stefano Garzarella wrote:
>>Transport's release() and destruct() are called when de-assigning the
>>vsock transport. These callbacks can touch some socket state like
>>sock flags, sk_state, and peer_shutdown.
>>
>>Since we are reassigning the socket to a new transport during
>>vsock_connect(), let's reset these fields to have a clean state with
>>the new transport.
>>
>>Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>>Cc: stable@vger.kernel.org
>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>---
>>net/vmw_vsock/af_vsock.c | 9 +++++++++
>>1 file changed, 9 insertions(+)
>>
>>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>index 5cf8109f672a..74d35a871644 100644
>>--- a/net/vmw_vsock/af_vsock.c
>>+++ b/net/vmw_vsock/af_vsock.c
>>@@ -491,6 +491,15 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>>		 */
>>		vsk->transport->release(vsk);
>>		vsock_deassign_transport(vsk);
>>+
>>+		/* transport's release() and destruct() can touch some socket
>>+		 * state, since we are reassigning the socket to a new transport
>>+		 * during vsock_connect(), let's reset these fields to have a
>>+		 * clean state.
>>+		 */
>>+		sock_reset_flag(sk, SOCK_DONE);
>>+		sk->sk_state = TCP_CLOSE;
>>+		vsk->peer_shutdown = 0;
>>	}
>>
>>	/* We increase the module refcnt to prevent the transport unloading
>>-- 
>>2.47.1
>>
>
>Hi Stefano,
>I spent some time investigating what would happen if the scheduled work
>ran before `virtio_transport_cancel_close_work`. IIUC that should do 
>no harm and all the fields are reset correctly.

Yep, after transport->destruct() call, the delayed work should have 
already finished or canceled.

>
>Thank you,
>Luigi
>
>Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
>

Thanks for the review,
Stefano


