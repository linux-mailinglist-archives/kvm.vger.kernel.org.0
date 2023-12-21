Return-Path: <kvm+bounces-5096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CA881BCE1
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 18:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9387D1C26063
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 17:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87812634FA;
	Thu, 21 Dec 2023 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GTOJe2Ee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788A85993E;
	Thu, 21 Dec 2023 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5942259ca62so526238eaf.3;
        Thu, 21 Dec 2023 09:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703179040; x=1703783840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6k/akrlSrIkTy3hb1h59+fzAYQnpfHVd+WuEcLTR0W4=;
        b=GTOJe2Ee9wmgRpnln3+gnL71cwdoHwKOvQeCpEcuDGw5Dqav2JWIGBwbFU/caAODgY
         xhHQSX0fbs23LywpwOeKYTXQRfNjABtrg8T6fKmhI9lVaW2O84BpVAwd4hxlGofSLcZA
         8PIYwxchzxuiE0EgA96FT7GiiJvumFrNFCDsT5Qn5lwE83VGsGpnhM8TtWw37ARezPXP
         nAHXk4MRBrvbrNiVfSjAYBf7XfPlMbhze8r8CYO346R4CzcbwTzl2eim7hSQJwfeGotf
         Vf8PmUrR8vS3ZH+eAyx+mG+lN319dDVskeYXt0o+jBBXB/KIMaqis2VWdEDwI7CZNE2e
         aLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703179040; x=1703783840;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6k/akrlSrIkTy3hb1h59+fzAYQnpfHVd+WuEcLTR0W4=;
        b=gdquXdxIPRKc6ZpFNt1+4zI6b0n7u21OrF1EzfKT+30ycVT3QD8u5ZR/hWe34OqN4m
         RXfNeDU4KxOil9mfXLvIFlTSz8I07HWWuzxa3VUbTWdJcpdbkC95WJz4EY27A3XKQguR
         ulHyGda8DqhZF/umOwV+qfzPqYvv2YABccNg0gjiBsibjsJv5UdEFIRFb2wyZCw7swCk
         WatoqoeIUNCiAzwLNzLt5Mikn73gRGOIk+zNaGsEsoSLEBuUfby2b0dnF+r62uYQDmgT
         FZZGbjshn3iXr5vq+WuBXcdncwTOrvrf4hkQEg2JGDEks1Y7Q20ejRl+BGDaJ6BT2HMU
         491w==
X-Gm-Message-State: AOJu0YzBJErQ6krGApEwQ6fDrj8s95kZUUGy3sVOXgYJJ9abNd9auNfI
	GQhOyFVxFYudE1xKtkdA41U=
X-Google-Smtp-Source: AGHT+IFki5T/xVwmQL5dFmzj3FLdojbmNHX5QYyCXzO6/5w9UYlzrO/BVHdyKVcnD9nmaK33+NEfQg==
X-Received: by 2002:a05:6358:724a:b0:172:ae6e:bdd4 with SMTP id i10-20020a056358724a00b00172ae6ebdd4mr57936rwa.7.1703179040274;
        Thu, 21 Dec 2023 09:17:20 -0800 (PST)
Received: from localhost (114.66.194.35.bc.googleusercontent.com. [35.194.66.114])
        by smtp.gmail.com with ESMTPSA id bo9-20020a05621414a900b0067f7b0904c3sm755136qvb.83.2023.12.21.09.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 09:17:19 -0800 (PST)
Date: Thu, 21 Dec 2023 12:17:19 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Mina Almasry <almasrymina@google.com>, 
 linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev
Cc: Mina Almasry <almasrymina@google.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Jason Gunthorpe <jgg@nvidia.com>, 
 =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, 
 Shakeel Butt <shakeelb@google.com>, 
 Yunsheng Lin <linyunsheng@huawei.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <6584731f9eab1_82de3294d0@willemb.c.googlers.com.notmuch>
In-Reply-To: <20231220214505.2303297-2-almasrymina@google.com>
References: <20231220214505.2303297-1-almasrymina@google.com>
 <20231220214505.2303297-2-almasrymina@google.com>
Subject: Re: [PATCH net-next v3 1/3] vsock/virtio: use skb_frag_*() helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Mina Almasry wrote:
> Minor fix for virtio: code wanting to access the fields inside an skb
> frag should use the skb_frag_*() helpers, instead of accessing the
> fields directly. This allows for extensions where the underlying
> memory is not a page.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> ---
> 
> v2:
> 
> - Also fix skb_frag_off() + skb_frag_size() (David)
> - Did not apply the reviewed-by from Stefano since the patch changed
> relatively much.
> 
> ---
>  net/vmw_vsock/virtio_transport.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index f495b9e5186b..1748268e0694 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -153,10 +153,10 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  				 * 'virt_to_phys()' later to fill the buffer descriptor.
>  				 * We don't touch memory at "virtual" address of this page.
>  				 */
> -				va = page_to_virt(skb_frag->bv_page);
> +				va = page_to_virt(skb_frag_page(skb_frag));
>  				sg_init_one(sgs[out_sg],
> -					    va + skb_frag->bv_offset,
> -					    skb_frag->bv_len);
> +					    va + skb_frag_off(skb_frag),
> +					    skb_frag_size(skb_frag));
>  				out_sg++;
>  			}
>  		}

If there are requests for further revision in the series, can send
this virtio cleanup on its own to get it off the stack.

> -- 
> 2.43.0.472.g3155946c3a-goog
> 



