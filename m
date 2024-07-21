Return-Path: <kvm+bounces-22027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC7993861C
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 22:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4EE428100F
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 20:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B2C16B73E;
	Sun, 21 Jul 2024 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bL2VJESt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDFE2FB2;
	Sun, 21 Jul 2024 20:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721594557; cv=none; b=gYQ2M9p5XxxyyajiDjb9HF/1qa5VxAm1/Z27aa5s9jrzgSgQMfE6FQzYCYIU89zBNOV5Zd94zHs5pyJXtYk01xRGiO4CBiVR/BN5iUqzu/bpTK2IqH0a98hYdmpTVQP5BxsGe2HF7X+8XMzPdThYkyL4wt8gmLcAkQ2F8Uzpsk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721594557; c=relaxed/simple;
	bh=Y2Prf/IbMk4LMsyq34wH1row2ki7pR91wfPtg73kQoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b8ifo0FRHrAYsDkqDdDXzqArkWCcOEDzx/TrzZPHK+254Ze+ffDOZ5yHT3GQ4YU35TbTEZCtmXBbXuWad0Iq6dGK/g6k7r+7bJlL+Cr/egr+m4T6/t8jmjq/6MjHSg1EoERfuz4U77QGpbjlPZ6qC3h174TWn5I0/sb/nSW/L7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bL2VJESt; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3686b554cfcso1568602f8f.1;
        Sun, 21 Jul 2024 13:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721594553; x=1722199353; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2Prf/IbMk4LMsyq34wH1row2ki7pR91wfPtg73kQoQ=;
        b=bL2VJEStDzeIZVqJMCBd6V/dPkfYG1CMJv4rz3zTYXp8irUh2UeYvwCr54n9eT59L9
         NJzG5lE4uiTkj9JgoPeD0LJ++puwNqn6WWiJy55O72OUoXnVNiLl9y9oxVqftcDuhp88
         jkaR/AdwPdUN23mofGCZayNW4Z/3U9qRpf06Jy9roejdXKLYk/8GC3m2M78WfsnXFf7o
         AA0JHNm89+jo72PZs32Tg5YgiKsLBv39oljWppiHUzcO7DuMzGLgZCDGnohSixT6WFNO
         AK92sVVJxiksakOoFvvuHAvTC2ok3wcn2rw3XzMWS5F7wdqIN5ADPxrBTtYehlzCJnRo
         fJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721594553; x=1722199353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y2Prf/IbMk4LMsyq34wH1row2ki7pR91wfPtg73kQoQ=;
        b=n5UQ4CRW0WCXQuaTtdmi5iSkbg3BNFZvns7ZoLZ+EJJjM0fDkw/cJstgJRLT8witdO
         qkXf0a/ftmAj0Nr8scIYGWKQ3twKEJSoFfh0S2AxtD8EU5kEIJPo4tzWgIsUJaLEydw0
         xKwQZ3PLbgHDWmqh37+JBkJ2FgoafWi00hTwzxwDXo7dVhFPDjGp561UpJGUvbs21mm/
         ZEWV/GJIAfLX5qfeF0W8gXlA9Tk2ZkTZMP9fVAAfQYFtC+Wo5N1Ia1avxkD1mDTcGi0z
         ZKNasuMxUqVIF8156PM8TCa+db31INz35h4k2VlH+q9B1PenbDM5brI7H/fGCZ8W5hix
         AgUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3/CQRxd9PhjKN8X7w12sTE3nD5psLckXN9qqee4mCcxiaKPYVtOzo7AKBlBPRrZSjZCI40W3Yv0TgpGc9NzfZFnMWjoSeT1Veu8PESUbc0e0ZcPIDMjW9MHBPHCLYqbpuwMncEfosp2PNREGPMz0I08W9z2VbHpJWzYYtSZ4KJt/+HcvG+PEEfwNSBa7NtitSCF0KtIknC3uIdGrKpTOiWxkueIlEkttF
X-Gm-Message-State: AOJu0YxEE+p4skg09aqRAHNRa1+6qBUoraQZuHZCdvJqc+XWqVaLQG6R
	MsY6h+/fPWp70ZnbIqX5BhxH42AekJCCGD0gM/yHlXelyPrhcijnLcEoo/wGM+B3FcXNKwF6RTL
	o+GWr4Mihkpn/UiwLyrN8vQD+7Ok=
X-Google-Smtp-Source: AGHT+IHzyJqN1Q0WaIfDKyj2SqhKg2oxhBaiBXCVTaoG5f0KmwGrOsY8JwrfF4zCan/VnZBfTxjvlG6f3HfT9iOc4L4=
X-Received: by 2002:a5d:59a4:0:b0:366:e838:f5d4 with SMTP id
 ffacd0b85a97d-369bbbb4b95mr3333434f8f.3.1721594552579; Sun, 21 Jul 2024
 13:42:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719093338.55117-1-linyunsheng@huawei.com> <20240719093338.55117-5-linyunsheng@huawei.com>
In-Reply-To: <20240719093338.55117-5-linyunsheng@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Sun, 21 Jul 2024 13:41:55 -0700
Message-ID: <CAKgT0UcqELiXntRA_uD8eJGjt-OCLO64ax=YFXrCHNnaj9kD8g@mail.gmail.com>
Subject: Re: [RFC v11 04/14] mm: page_frag: add '_va' suffix to page_frag API
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Subbaraya Sundeep <sbhatta@marvell.com>, Jeroen de Borst <jeroendb@google.com>, 
	Praveen Kaligineedi <pkaligineedi@google.com>, Shailend Chand <shailend@google.com>, 
	Eric Dumazet <edumazet@google.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Sunil Goutham <sgoutham@marvell.com>, 
	Geetha sowjanya <gakula@marvell.com>, hariprasad <hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>, 
	Sean Wang <sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Keith Busch <kbusch@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>, 
	Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	intel-wired-lan@lists.osuosl.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	bpf@vger.kernel.org, linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 2:37=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> Currently the page_frag API is returning 'virtual address'
> or 'va' when allocing and expecting 'virtual address' or
> 'va' as input when freeing.
>
> As we are about to support new use cases that the caller
> need to deal with 'struct page' or need to deal with both
> 'va' and 'struct page'. In order to differentiate the API
> handling between 'va' and 'struct page', add '_va' suffix
> to the corresponding API mirroring the page_pool_alloc_va()
> API of the page_pool. So that callers expecting to deal with
> va, page or both va and page may call page_frag_alloc_va*,
> page_frag_alloc_pg*, or page_frag_alloc* API accordingly.
>
> CC: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>

Rather than renaming the existing API I would rather see this follow
the same approach as we use with the other memory subsystem functions.
A specific example being that with free_page it is essentially passed
a virtual address, while the double underscore version is passed a
page. I would be more okay with us renaming the double underscore
version of any functions we might have to address that rather than
renaming all the functions with "va".

In general I would say this patch is adding no value as what it is
doing is essentially pushing the primary users of this API to change
to support use cases that won't impact most of them. It is just
creating a ton of noise in terms of changes with no added value so we
can reuse the function names.

