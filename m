Return-Path: <kvm+bounces-49619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A00EADB2B7
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 15:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1ACCD7A7FBC
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9E32DF3E4;
	Mon, 16 Jun 2025 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FzGnlYMW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B546F2877DF
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750082048; cv=none; b=CDciXyngyYv8p6d+5PndTZAMoemiplNjqe6LzNyMODW3a3I19RMgkk7A9PU8XVNv5Ie9zOghCQhCtPMyEREpgfUE/aV3AK6WdtN6UKhKnMSw1XytpVrqC78HHifbj0vvRCRl3nwYDVIIkPeIcNAJsYOACbZmOeyxvuAqUQECBxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750082048; c=relaxed/simple;
	bh=ALufLifN8ET5GUUo9VdmBMb2kiTd+JEXg3vJP9CcLJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TD9mWj7859ZS/exsoGrXoPu9IhAANeF+4Y6PTp6u0DbaLzPcS5xs4xL2mSb/zoCtfujWIYpEJi4Z6875QT2DwrUnZMa/y0GdknRMYTWPVEjASiPR+648rvDWHNvnsh7ebSY/ltH538TpYXtNulQVFg7NJObm8afahjwZM2qAc1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FzGnlYMW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750082044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HXRSgHsBoykaoCkGaODkCk80Pz+wKzFt/0k3tccKi30=;
	b=FzGnlYMW0DefksNaJ8K60nt15cqmriHP8gDVM2KeIHpVQdnT0janqupyXTRtFBb8A/ocgN
	ZqCdm5YWUF3Q0rsHPE5LZQ/RKzhUiiXGCaiJt9zxEIT0CX3Z4MSh/Abd8joDJ2A5ieAShU
	Il8KLSBMHqHvyaw/ZyQss6iHJgya3qA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-kiIDfAU2PTq1TXqVLymXrQ-1; Mon, 16 Jun 2025 09:54:02 -0400
X-MC-Unique: kiIDfAU2PTq1TXqVLymXrQ-1
X-Mimecast-MFC-AGG-ID: kiIDfAU2PTq1TXqVLymXrQ_1750082041
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451dda846a0so34786275e9.2
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 06:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750082041; x=1750686841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXRSgHsBoykaoCkGaODkCk80Pz+wKzFt/0k3tccKi30=;
        b=m2v6Z5xQTWcs0jj8RGsCmU2p/+n6NibYigOZCcIzS74Y578FS1U2yB1S2biV3T70fW
         UxSDwJySmU5pzKyCLAb4K2HD2DIcO4GQbFMfIQnnluoetj+Ok55/SqL+bjTaqjLVe5gQ
         vJo74fwI52omxOvCqUxRgNHuw/zJBzxD8KhwKxizaqS4nU6svPp5vmY5++Z5gaTlQhz/
         0H4RFDi83JArqtpBqkbg23SHjgQuWBAOiIcKfljjlgpE2ryyLZxLQn+anrdUx2zNTalo
         SJI+csVvCj7fuchOlv9z6nJNziB58HdUEtQrEVtwNcAVTUoiHQQWZwSIeZvaFXok6/PK
         OSYA==
X-Forwarded-Encrypted: i=1; AJvYcCXm8iizZ0KjdCT5U5yYWbV3KzEnSkeK5bbzoXOI8WgBV9l+jEzG18ZX4pnQ+horRt+VKxk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz90+kMtTN/ejVdCtIM4SlCrtB9UKf3QI7LsVD3MnjcH9SGYNN1
	8rL6NfV6mhGjsSACpTR+mgDvNn9za+QyTJRQ0t2QjMpmWQXlmtLdO5kRSzZUDZZVrkb6ZP6Gcio
	6FD0O+AtyM6LngBNTO7P1AblQwCBxErnwBgHG7yeQFlNKa4E60uHOEw==
X-Gm-Gg: ASbGncueWcXwCsSAkbRS8OCsF6x2JlHBLAlXvtO7GP2SAB3/oqbXpjkUWS1orokR94y
	YfKzreZzoLszLkyGdnr+Ich0yU4ni9Is5cnuAyAPqIYz8bwoxkm54nb6X1XIh4YlVv7qdGjF7j4
	+e6FcZNCiFTawIxUlcg+j6bqU12ihfRz4WqjaKttyeKSv/ru1y1Ri4VIN1Vx+Ijppi8l3qAh0ye
	zzHnxp8+XJ+JQGIiaYv2NZj7Jg6c0kjr6bIAy2PZiNn3oGUyEv/fRw+wTRjjg3mk2InfBteLJ92
	rQ+xGetfWCMWoSiQwb80OsF0Dus=
X-Received: by 2002:a5d:5f8d:0:b0:3a4:fa6a:9174 with SMTP id ffacd0b85a97d-3a5723a36b1mr7744980f8f.33.1750082041415;
        Mon, 16 Jun 2025 06:54:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9KK52CE4TM7xQev5LOLheuW7Ek08zbqpia8Xus0jUc0uv2rsRw4izzQxnWbncAFqkbNkuqg==
X-Received: by 2002:a5d:5f8d:0:b0:3a4:fa6a:9174 with SMTP id ffacd0b85a97d-3a5723a36b1mr7744946f8f.33.1750082040864;
        Mon, 16 Jun 2025 06:54:00 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.202.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b403b4sm10933571f8f.80.2025.06.16.06.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 06:54:00 -0700 (PDT)
Date: Mon, 16 Jun 2025 15:53:53 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, pabeni@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org, stefanha@redhat.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fupan.lfp@antgroup.com, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH net-next v2 1/3] vsock: Add support for SIOCINQ ioctl
Message-ID: <xshb6hrotqilacvkemcraz3xdqcdhuxp3co6u3jz3heea3sxfi@eeys5zdpcfxb>
References: <20250613031152.1076725-1-niuxuewei.nxw@antgroup.com>
 <20250613031152.1076725-2-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250613031152.1076725-2-niuxuewei.nxw@antgroup.com>

On Fri, Jun 13, 2025 at 11:11:50AM +0800, Xuewei Niu wrote:
>This patch adds support for SIOCINQ ioctl, which returns the number of
>bytes unread in the socket.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> include/net/af_vsock.h   |  2 ++
> net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
> 2 files changed, 24 insertions(+)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index d56e6e135158..723a886253ba 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -171,6 +171,8 @@ struct vsock_transport {
>
> 	/* SIOCOUTQ ioctl */
> 	ssize_t (*unsent_bytes)(struct vsock_sock *vsk);
>+	/* SIOCINQ ioctl */
>+	ssize_t (*unread_bytes)(struct vsock_sock *vsk);

Instead of adding a new callback, can we just use 
`vsock_stream_has_data()` ?

Maybe adjusting it or changing something in the transports, but for 
virtio-vsock, it seems to me it does exactly what the new 
`virtio_transport_unread_bytes()` does, right?

Thanks,
Stefano

>
> 	/* Shutdown. */
> 	int (*shutdown)(struct vsock_sock *, int);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 2e7a3034e965..466b1ebadbbc 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
> 	vsk = vsock_sk(sk);
>
> 	switch (cmd) {
>+	case SIOCINQ: {
>+		ssize_t n_bytes;
>+
>+		if (!vsk->transport || !vsk->transport->unread_bytes) {
>+			ret = -EOPNOTSUPP;
>+			break;
>+		}
>+
>+		if (sock_type_connectible(sk->sk_type) &&
>+		    sk->sk_state == TCP_LISTEN) {
>+			ret = -EINVAL;
>+			break;
>+		}
>+
>+		n_bytes = vsk->transport->unread_bytes(vsk);
>+		if (n_bytes < 0) {
>+			ret = n_bytes;
>+			break;
>+		}
>+		ret = put_user(n_bytes, arg);
>+		break;
>+	}
> 	case SIOCOUTQ: {
> 		ssize_t n_bytes;
>
>-- 
>2.34.1
>


