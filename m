Return-Path: <kvm+bounces-4058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B6C780D004
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:47:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B416DB215C0
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 15:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB8A4BABB;
	Mon, 11 Dec 2023 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPorHHnr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453B910F
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 07:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702309640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IZlJdJgXVbL3FV2sl0lv/ikQI4rT8wZ5WPDilRcK534=;
	b=jPorHHnrSjn9oejcUCp7SHchnmlAZB5M9Fl7S+y0A69Lw6PpxP7y7dTGGjGyrsQtpoqznL
	PToImhlQIMOdk1tRxHwUlDnBI8alh3xgfyKwLtpOcgqeGjoL/7Bn3wXeTFUjo1eWhe4qvd
	h7z33BqxkG98a8ayiSBgqYC0v8akyMA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-O-2T5zrMPeKYLEYcVkMFzg-1; Mon, 11 Dec 2023 10:47:18 -0500
X-MC-Unique: O-2T5zrMPeKYLEYcVkMFzg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40c1d2b1559so33318805e9.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 07:47:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702309637; x=1702914437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZlJdJgXVbL3FV2sl0lv/ikQI4rT8wZ5WPDilRcK534=;
        b=eIBJ8Nh0VjQcLab+CffOVmiBa0EiQVsGcPsjloAMFkkp8yl7Gr/6O8mGOj7NDiZLz+
         P9C6nCGnpo71V/EvfN/e7vjnRJ6bpgWjHthn8dCrjWhq8FdVtWbvydLIOKaRKcokmIgz
         //G98nq66pHGj1TkfELJUp1VfXI1w/e6zj78haVsIsxCnD9PM66MXoFpVSqaqvjCWPQM
         RL6Q2J1yOnfL0aM49XUQkeaXA63BGT6S/NkQFlY8Jm8rhgBonLopoorwff8PyaBLWsO7
         Du6b2QkvXbly3MtjsPVX7aY0o40fdRxSE3OywGVZGOOCmvIOL11lRQNzEEcKhsXL6zFw
         E1NQ==
X-Gm-Message-State: AOJu0YxaCJZqqW07UrLUjwStoLQrpOH7pXDnQ54/6ysc2ZgDTI04bWdo
	JYs/dyh45cv4vHCX0RbexlguDkuVoUhOoEdbhhqV2U3nEOHE80LJSkD09m0xdfVvxfHImLK86Lr
	j8vk0LHsS6Bug
X-Received: by 2002:a05:600c:1f08:b0:40c:3e98:5309 with SMTP id bd8-20020a05600c1f0800b0040c3e985309mr2116104wmb.98.1702309637346;
        Mon, 11 Dec 2023 07:47:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpH0te5s/Q1Xr8W7VeRGbO99gtL3UMDIEk2Fm7MvD8T4ecMB/fJcg5Sa0456ul8XolChfdVA==
X-Received: by 2002:a05:600c:1f08:b0:40c:3e98:5309 with SMTP id bd8-20020a05600c1f0800b0040c3e985309mr2116092wmb.98.1702309636881;
        Mon, 11 Dec 2023 07:47:16 -0800 (PST)
Received: from sgarzare-redhat ([78.209.43.40])
        by smtp.gmail.com with ESMTPSA id t13-20020a05600c450d00b00405c7591b09sm13401013wmo.35.2023.12.11.07.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 07:47:16 -0800 (PST)
Date: Mon, 11 Dec 2023 16:45:09 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: Fix unsigned integer wrap around in
 virtio_transport_has_space()
Message-ID: <t6mnn7lyusvwt4knlxkgaajphhs6es5xr6hr7iixtwrfcljw67@foceocwkayk2>
References: <20231211142505.4076725-1-kniv@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231211142505.4076725-1-kniv@yandex-team.ru>

On Mon, Dec 11, 2023 at 05:25:05PM +0300, Nikolay Kuratov wrote:
>We need to do signed arithmetic if we expect condition
>`if (bytes < 0)` to be possible
>
>Found by Linux Verification Center (linuxtesting.org) with SVACE
>

We should add:

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")

>Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index c8e162c9d1df..6df246b53260 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -843,7 +843,7 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
> 	struct virtio_vsock_sock *vvs = vsk->trans;
> 	s64 bytes;
>
>-	bytes = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>+	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);

If we respect the credit, this should not happen. It can happen, though,
that the receiver changes its buffer size while we're communicating,
and if it reduces it, this could happen. So yes, we need to fix it!

Thanks!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

> 	if (bytes < 0)
> 		bytes = 0;
>
>-- 
>2.34.1
>


