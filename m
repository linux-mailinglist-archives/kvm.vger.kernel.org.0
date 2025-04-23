Return-Path: <kvm+bounces-43975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F94EA9948D
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 443AB4C0BB8
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A0E28C5C1;
	Wed, 23 Apr 2025 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SNCEYJdo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEA746447
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423601; cv=none; b=uKdIDcK3bVzZIdFd2uMBPo6XhzGIBoZqLJoxY77f+AOM7ExRHq6yxzXZ/73gbSuO2sZbI/vltjSzm3RYY0nd0brHfnbUYNe0ebyzXcJMP3BMWzLF+lfGzfxX0sZJD4nBFrZrIU6Xwk3xxMjTmWPj8b33ZI4+JP8I+MH6sfzj7CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423601; c=relaxed/simple;
	bh=9F5t42L4T7DlrKAbIEzJacTshtoofiMJhhUWO+3Np/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqAZZ2rg1gN2UmcsZ303/rkQBgixPq6kSalWtuD2uDd1ObNRBuLrZDlBXAOv/GgEl+QRM3QnxkY6/L7LxhLWzYo84BjdKAWC3EJ7JnQMkL1blFIAm39IdOJMilJp9zQ5eoGa4pd+tfKyySXoy5v85qCR2DgJ8Tkz2P00dlGxWsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SNCEYJdo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745423598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4vXjdITA2otLqOLfSkM93EoHhrqfeYMofeR1JyUMjL4=;
	b=SNCEYJdo7nhpxVk8M+AtmeH8RaV0IxA6XwD6HCL23i/4NP8KrMxho1FEIiyOSmMkzOuEG8
	G+tuVJzgliwLhrtwJLS55wyikg+SQky0cUxZ3lMPu/x4ntTP1ZHPWLImhhoNOU0rIWCopB
	m8gb+LW+Sor8aDBVtLKqeCub3cCg5Rs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319--cfZ4CdGMlO0l4fjwjdI7A-1; Wed, 23 Apr 2025 11:53:16 -0400
X-MC-Unique: -cfZ4CdGMlO0l4fjwjdI7A-1
X-Mimecast-MFC-AGG-ID: -cfZ4CdGMlO0l4fjwjdI7A_1745423596
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39c30f26e31so3592657f8f.3
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 08:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745423595; x=1746028395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vXjdITA2otLqOLfSkM93EoHhrqfeYMofeR1JyUMjL4=;
        b=SQ8/0AInYZpz/t3t/+RfEAwh322xX2H08TOfv0VdqsYej4iyTzAnhMCbFI9UQx1oE4
         9cDYzffGVp9tlSNkSckRyrO71fkIhOMQpotIo8x1U7Fmug9jz4SmS/aIgM4ZEtMgtFYB
         HVyfn+r2G1iWlS0kN8i6kWOTS9t9oVGa9WuRSf4aTfZpTaMXLL1OhtACnoWaY2Q7CjgU
         0a7UHj6/MH7NeNFlAGlskK8oQU0f914QtA9wdx9mc3NWhVF2GIxfxAdULxxqZdz9zSMv
         ZOwXofcfjlHPCtGvtjKogr6cYuIrexdiwBwQn1ReLw5Mv5cYx++sTqgY7mjD3w5FwH+J
         LM8A==
X-Forwarded-Encrypted: i=1; AJvYcCWBk4UvZ8Wohx3nmEl/tIoodqQESOt0Kw9knbfdLG8OuJnI9mnieLgmFh2QRelr6kSQ/Gg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzqxS49eWWZNvzNMGY81wIyYEhQmDs/JKvHU+WbVeH0QwwV+Zn
	qHDEKNmsBS3KtQ32PedQeGDneZL+em/uo9I9IGD/jiQd9Go1uqEFyuUEx5eN9BMY4cBva5ionAA
	5LLz3QMrCK7Eo3+ma9uN5hUEBqG6XPY4zez4n6CHuWSgKJIEiYw==
X-Gm-Gg: ASbGncte9eEP7myYwbXHEU5f7AEs8Y/fjOciDXD5HxJgpA4JBfltBarkKZ5xTPW9Tkn
	N5Q3weUGvdvnNhneiJ4IPwWo9uttHHFmnwBSwMLjAj2DL0pp3XNLTKxPg+fmEBo8tzbiu05jPqw
	IkgDH4dQaDwJZekb9z7MMkNK/8rcpi/oVPoL3w3t8EAzjIr0PhsAXxJAKVdZsp/t6I7HYlt6i2l
	JiU1Wyy+vyDt8wMQhgOLVhYB60uHHbY7MtKjEmlxPH8iJ4QvB60AMwzDBgcixal594xdMU7p14z
	uTP0UUCPaRwy+g==
X-Received: by 2002:a05:6000:402b:b0:39c:e0e:bb46 with SMTP id ffacd0b85a97d-39efba383d1mr15395527f8f.4.1745423595608;
        Wed, 23 Apr 2025 08:53:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3Ev46g9NwPjawD8USomZKAsrAiFv9uPuXFN35OxT/qY5CZ5sbL5NV6EP3Ne7VxwIqM91Svg==
X-Received: by 2002:a05:6000:402b:b0:39c:e0e:bb46 with SMTP id ffacd0b85a97d-39efba383d1mr15395506f8f.4.1745423595246;
        Wed, 23 Apr 2025 08:53:15 -0700 (PDT)
Received: from leonardi-redhat ([151.29.33.62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa493212sm19371776f8f.66.2025.04.23.08.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 08:53:14 -0700 (PDT)
Date: Wed, 23 Apr 2025 17:53:12 +0200
From: Luigi Leonardi <leonardi@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Stefano Garzarella <sgarzare@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] vsock: Linger on unsent data
Message-ID: <km2nad6hkdi3ngtho2xexyhhosh4aq37scir2hgxkcfiwes2wd@5dyliiq7cpuh>
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
 <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co>

Hi Michal,

On Mon, Apr 21, 2025 at 11:50:41PM +0200, Michal Luczaj wrote:
>Currently vsock's lingering effectively boils down to waiting (or timing
>out) until packets are consumed or dropped by the peer; be it by receiving
>the data, closing or shutting down the connection.
>
>To align with the semantics described in the SO_LINGER section of man
>socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>of a lingering close(): instead of waiting for all data to be handled,
>block until data is considered sent from the vsock's transport point of
>view. That is until worker picks the packets for processing and decrements
>virtio_vsock_sock::bytes_unsent down to 0.
>
>Note that such lingering is limited to transports that actually implement
>vsock_transport::unsent_bytes() callback. This excludes Hyper-V and VMCI,
>under which no lingering would be observed.
>
>The implementation does not adhere strictly to man page's interpretation of
>SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++--
> 1 file changed, 11 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 7f7de6d8809655fe522749fbbc9025df71f071bd..aeb7f3794f7cfc251dde878cb44fdcc54814c89c 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1196,12 +1196,21 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
> {
> 	if (timeout) {
> 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>+		ssize_t (*unsent)(struct vsock_sock *vsk);
>+		struct vsock_sock *vsk = vsock_sk(sk);
>+
>+		/* Some transports (Hyper-V, VMCI) do not implement
>+		 * unsent_bytes. For those, no lingering on close().
>+		 */
>+		unsent = vsk->transport->unsent_bytes;
>+		if (!unsent)
>+			return;

IIUC if `unsent_bytes` is not implemented, virtio_transport_wait_close 
basically does nothing. My concern is that we are breaking the userspace 
due to a change in the behavior: Before this patch, with a vmci/hyper-v 
transport, this function would wait for SOCK_DONE to be set, but not 
anymore.

>
> 		add_wait_queue(sk_sleep(sk), &wait);
>
> 		do {
>-			if (sk_wait_event(sk, &timeout,
>-					  sock_flag(sk, SOCK_DONE), 
>&wait))
>+			if (sk_wait_event(sk, &timeout, unsent(vsk) == 
>0,
>+					  &wait))
> 				break;
> 		} while (!signal_pending(current) && timeout);
>
>
>-- 2.49.0
>

Thanks,
Luigi


