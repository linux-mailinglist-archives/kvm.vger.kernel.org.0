Return-Path: <kvm+bounces-4075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 501B180D1DB
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08F0D2818F1
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6E31F16B;
	Mon, 11 Dec 2023 16:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IMw7ytCL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A1B91
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702312427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bzIkbZpiRzJdrc6a6vDeJqlwsyKzW2Z5OW2xriwEAsQ=;
	b=IMw7ytCLi2monybRlcj8JSOMhfyBFpVdwa5MKXWH0QkExQlITZpPmU0y/JmYut2WGMJzJX
	RsLdMMMl+1J7z5rK9AtJQbSa33UNBge8OlZyqpXe5kgrWnagiGbGQKX7pIRXhdgR7bV6uu
	rK7w3p+xY0twgeYmuzIvWAeAELm6P2A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-iIO8g2ImPJaOc9hI2IJPeA-1; Mon, 11 Dec 2023 11:33:45 -0500
X-MC-Unique: iIO8g2ImPJaOc9hI2IJPeA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3334e7d1951so4077932f8f.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:33:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702312425; x=1702917225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzIkbZpiRzJdrc6a6vDeJqlwsyKzW2Z5OW2xriwEAsQ=;
        b=uKxr6Yk5ZX/NyjZV/6/AXSjvwBEoWzwl+bFlQP+z98PFY1MpPwsqTbZi/cUj2iUxmI
         pw2ba3gTy502A4azLOB5sc1JcDcOlZgAVWam5tqyqRRdMjY60zEYTgwIEw/4y2C3h0jF
         X0itI0AW4YSPmRgdwmChBkn1rgcP21nC6z3V/1rbjMsJN8r7zDkiMvooB3gkTsHWN9pC
         7bBQYRTbmjlEopcBndIntRsk2hlfy4yGNwHq1NEEAmEFXoYF/kS1o83PyQixP9HEUMP4
         pbkRTATm5WciCR3YIqfdlqgSylchCtDiZFvp2FPS7b4PU56/VEI4a1r+AI5M29yuN7tt
         XMXA==
X-Gm-Message-State: AOJu0Yyy5Yqj4TlfJonue5j8guLDOCc/maawSieqsM9NKghskTF31YEL
	opTXZb79e4eWFWj9GTTs/CgE9bgp2Zg3b0P9Sejit1xNHUOsyN5DI+sbjemS9g3GXtnsLJ18Y7I
	9v6Tn3qpPauQZ
X-Received: by 2002:a05:600c:501e:b0:40c:25c7:b340 with SMTP id n30-20020a05600c501e00b0040c25c7b340mr1172681wmr.281.1702312424866;
        Mon, 11 Dec 2023 08:33:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVGkZ4+oYYezirnB3Q25N7aHGvQW9MmXB7XVlCjjG2JGiHt8ONICyX4hMLT/PJy3biQX9FqQ==
X-Received: by 2002:a05:600c:501e:b0:40c:25c7:b340 with SMTP id n30-20020a05600c501e00b0040c25c7b340mr1172674wmr.281.1702312424427;
        Mon, 11 Dec 2023 08:33:44 -0800 (PST)
Received: from sgarzare-redhat ([95.131.45.143])
        by smtp.gmail.com with ESMTPSA id t13-20020a05600c450d00b00405c7591b09sm13524344wmo.35.2023.12.11.08.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 08:33:43 -0800 (PST)
Date: Mon, 11 Dec 2023 17:33:39 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v2] vsock/virtio: Fix unsigned integer wrap around in
 virtio_transport_has_space()
Message-ID: <nuyxku7erp67jjs2uw4kpufwxcgdrevl2lqys5fyltzgz6ikgk@3db26gkjghjw>
References: <t6mnn7lyusvwt4knlxkgaajphhs6es5xr6hr7iixtwrfcljw67@foceocwkayk2>
 <20231211162317.4116625-1-kniv@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231211162317.4116625-1-kniv@yandex-team.ru>

On Mon, Dec 11, 2023 at 07:23:17PM +0300, Nikolay Kuratov wrote:
>We need to do signed arithmetic if we expect condition
>`if (bytes < 0)` to be possible
>
>Found by Linux Verification Center (linuxtesting.org) with SVACE
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
>---
>
>V1 -> V2: Added Fixes section

Please, next time carry also R-b tags.

>
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

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
> 	if (bytes < 0)
> 		bytes = 0;
>
>-- 
>2.34.1
>
>


