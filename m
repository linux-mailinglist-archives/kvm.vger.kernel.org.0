Return-Path: <kvm+bounces-3793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FBEF808065
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 613471C20A96
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 05:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535EB12E46;
	Thu,  7 Dec 2023 05:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bUuLd1zA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9D4D4B
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 21:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701928342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSUZB2MS9IXq3JbO5o9diZppcpNs8joa8PI6k/pJS1g=;
	b=bUuLd1zAB94Wp3czypK6KO1DTShTcZhE4ZWPboHv4K20/bMl0XIBjYI+hWHcFzkvSElpQb
	6DP4jwMyk0p1Fb/q/KsrEFg+l6STM9SOFKdGP4dHV9ymL40pjvFs0OJ7+pwa5ehWhHa4ZC
	TBwUVQV1rx3f9F8IdI/zNExebeKBo8Q=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-3_ExshEZPKayZ0dv_sumgw-1; Thu, 07 Dec 2023 00:52:21 -0500
X-MC-Unique: 3_ExshEZPKayZ0dv_sumgw-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2868fb54e3eso717020a91.3
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 21:52:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701928339; x=1702533139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSUZB2MS9IXq3JbO5o9diZppcpNs8joa8PI6k/pJS1g=;
        b=ftj9BSKPgyXKQXsg7leVyHDtLRSz2zgOVI1YGuivb7SY839pFVdvRI8BrIaBY53j0K
         2DV1twIcQnCxvjtGXKmJLnOkBxaenA30bkC2QtM2ehDpoqSRPzvQP4SreCRcDQ2DfTrw
         /XxY7ekbCw6LBs8OyprQ5AZJtNECesXqjEnlf6hHHLfZTQmy3gr11SP82baggK3281Ny
         i8CAVcKIrFqEKvsidUYK54iMsMxYRyFnBAsLxbkX3gCV7QpyX6ixt/JZx6ASwgfNm2vR
         8awvweIARg0M6RU8AyHRgmXS85JGiqQXUu42/uReUQpf+CQp05FXyMUwQGElDfIV2Vmq
         gvAg==
X-Gm-Message-State: AOJu0YyzwoCXu8R54eCh2ywjSIY7XqK/O6Dg6HgH4o8PGPYP73xh8ZOk
	xkKsKv1Z7T2WQBO8+4BFo+fPrK06P6C1zYjoEQZnMlci6QSGJtQw8PtRE2nxbZB3HM1XEBEhPek
	hX4bueUNFaPbKuCxGx2Gqp5b22gHjs1uLtspbX+oZrA==
X-Received: by 2002:a17:90a:fd09:b0:286:6cc0:cad3 with SMTP id cv9-20020a17090afd0900b002866cc0cad3mr1949093pjb.74.1701928339217;
        Wed, 06 Dec 2023 21:52:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmSjJEJticrA6iI+yH1lm5XAyMtFr/azBvGsGe1XMJiQigUQ9nLH+oU43aD6xf+IguxCTdguGcxA4sxW4hVuw=
X-Received: by 2002:a17:90a:fd09:b0:286:6cc0:cad3 with SMTP id
 cv9-20020a17090afd0900b002866cc0cad3mr1949085pjb.74.1701928338997; Wed, 06
 Dec 2023 21:52:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205113444.63015-1-linyunsheng@huawei.com> <20231205113444.63015-5-linyunsheng@huawei.com>
In-Reply-To: <20231205113444.63015-5-linyunsheng@huawei.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 7 Dec 2023 13:52:08 +0800
Message-ID: <CACGkMEvwG6EvZ3me9ReqA-YSR1Y_6fb_kotT=+PFARaLS1FTmg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] vhost/net: remove vhost_net_page_frag_refill()
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Michael S. Tsirkin" <mst@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 7:35=E2=80=AFPM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:
>
> The page frag in vhost_net_page_frag_refill() uses the
> 'struct page_frag' from skb_page_frag_refill(), but it's
> implementation is similar to page_frag_alloc_align() now.
>
> This patch removes vhost_net_page_frag_refill() by using
> 'struct page_frag_cache' instead of 'struct page_frag',
> and allocating frag using page_frag_alloc_align().
>
> The added benefit is that not only unifying the page frag
> implementation a little, but also having about 0.5% performance
> boost testing by using the vhost_net_test introduced in the
> last patch.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


