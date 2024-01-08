Return-Path: <kvm+bounces-5837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B7682746C
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CAC8B22C7A
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 15:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB5652F70;
	Mon,  8 Jan 2024 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKiHVVQk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A6F5103E;
	Mon,  8 Jan 2024 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-28c2b8d6f2aso1084519a91.2;
        Mon, 08 Jan 2024 07:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704728777; x=1705333577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ABIEatGvpONoYLEnM8zujVINLyFvWCQbpURBZGHqyc=;
        b=mKiHVVQktys16d1/b7MkCrWnZpxoc85LXFsbfPNgCTaSKxzoEVLjYAGOJTC3BJs0Ri
         gL+zJO9U+OG2jhMKU8xNhWqXKGp8UYZ6Mls75foj0jYdK47r0avg7bNJXwnyasj1ZcrO
         sPnNK6VpmYnJ2QePsIi/5W3xfqVSTnfKppGBvRi5rTMzDwjGLWZsCcLNmjjiCukNDrrG
         Xj9LJ2k3ZKNFkc9qGPhV68i2yOQ19fwGsCH71zj6BrM09uNKjdtpMBMgzCBwaQH8abz6
         uF/B2dNgnZRla6DBZSpbl8NQrlIZ9qMgOf1oCtX4Fe2U0ufnceUG6yZ3wF83rYAXWAWS
         Nr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704728777; x=1705333577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ABIEatGvpONoYLEnM8zujVINLyFvWCQbpURBZGHqyc=;
        b=DRNJ9ccm3E1JS+xYu+dDCA5ArlD9Har8fv3orStiZ+OfN492TEFY6WyC4n8LOU8xku
         gzD9wxTHLzgCmtITiazSTStFtLfKSPTeoh7kkaHEqXlpfHnN4JdamoZmcA9SIdljWuxZ
         fysQjfFNNxyBS/aIF2i7VXotREOT0hL/HWKGMrFjFWfBAkJ8eTvqNos2T/ohDkPauiEk
         Db9uJ19HX2G82pNEahfFADiwgtNxddbsA2fGYWnSg8T8n8Gd4KC6y9FkvTyVqOteDaQq
         53op73ytnw9V8zsNwz6HOFA7tEIEvBtrVWAtuiIasoOpCThcQORgFchS27I5DGoO0ET9
         yZFQ==
X-Gm-Message-State: AOJu0Yx9imv/mZvKyOkJzI1wnz8vrI37Y4ymdzoeaL/4ZjNNZCWipJWC
	LQ0/3uAZESRxiyj/6jFaIroZDhLxj7gqcCR8Vm37dVqT
X-Google-Smtp-Source: AGHT+IHZJe1ZY74k1Lg4LUidpgawMu0QAPQhvu8GZrpY+cE2pAX9oNfGVAG8ljK3e18QPKlpOElMC5jvPt+GMAfHuo0=
X-Received: by 2002:a17:90a:d315:b0:28c:d85:9807 with SMTP id
 p21-20020a17090ad31500b0028c0d859807mr1131248pju.78.1704728776801; Mon, 08
 Jan 2024 07:46:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103095650.25769-1-linyunsheng@huawei.com>
 <20240103095650.25769-5-linyunsheng@huawei.com> <1a66f99173de36e1ae639569582feaf76202361d.camel@gmail.com>
 <705e59c2-6f46-5d39-b8da-8e2310904d71@huawei.com>
In-Reply-To: <705e59c2-6f46-5d39-b8da-8e2310904d71@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Mon, 8 Jan 2024 07:45:40 -0800
Message-ID: <CAKgT0UdLA820trYGWkgNR8KFX=QbFbiR_AcrWXwFwrmQzaVmKA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] vhost/net: remove vhost_net_page_frag_refill()
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 8, 2024 at 1:06=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:
>
> On 2024/1/6 0:06, Alexander H Duyck wrote:
> >>
> >>  static void handle_tx_copy(struct vhost_net *net, struct socket *sock=
)
> >> @@ -1353,8 +1318,7 @@ static int vhost_net_open(struct inode *inode, s=
truct file *f)
> >>                      vqs[VHOST_NET_VQ_RX]);
> >>
> >>      f->private_data =3D n;
> >> -    n->page_frag.page =3D NULL;
> >> -    n->refcnt_bias =3D 0;
> >> +    n->pf_cache.va =3D NULL;
> >>
> >>      return 0;
> >>  }
> >> @@ -1422,8 +1386,9 @@ static int vhost_net_release(struct inode *inode=
, struct file *f)
> >>      kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
> >>      kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
> >>      kfree(n->dev.vqs);
> >> -    if (n->page_frag.page)
> >> -            __page_frag_cache_drain(n->page_frag.page, n->refcnt_bias=
);
> >> +    if (n->pf_cache.va)
> >> +            __page_frag_cache_drain(virt_to_head_page(n->pf_cache.va)=
,
> >> +                                    n->pf_cache.pagecnt_bias);
> >>      kvfree(n);
> >>      return 0;
> >>  }
> >
> > I would recommend reordering this patch with patch 5. Then you could
> > remove the block that is setting "n->pf_cache.va =3D NULL" above and ju=
st
> > make use of page_frag_cache_drain in the lower block which would also
> > return the va to NULL.
>
> I am not sure if we can as there is no zeroing for 'struct vhost_net' in
> vhost_net_open().
>
> If we don't have "n->pf_cache.va =3D NULL", don't we use the uninitialize=
d data
> when calling page_frag_alloc_align() for the first time?

I see. So kvmalloc is used instead of kvzalloc when allocating the
structure. That might be an opportunity to clean things up a bit by
making that change to reduce the risk of some piece of memory
initialization being missed.

That said, I still think reordering the two patches might be useful as
it would help to make it so that the change you make to vhost_net is
encapsulated in one patch to fully enable the use of the new page pool
API.

