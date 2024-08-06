Return-Path: <kvm+bounces-23297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 872B59486C3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 02:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6959F1C21FE8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABADB660;
	Tue,  6 Aug 2024 00:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8T2Gd8H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FB21388;
	Tue,  6 Aug 2024 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722905567; cv=none; b=CvycPpuLuVEbVCb9IJdrcbk5ZhTzArbPJ8tC3r4SwroyYuafCEQVzi9pDuOl3rbgHvKqaLG3WJJAOIcTP8//7wBh3/GxTxuzEYg67rAfpGQkIGWuNnctVzUent90YqUtljCN7L2iYjSVTDbRb7CX3hHy0fxD2zYYqspSSB4Bqfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722905567; c=relaxed/simple;
	bh=+m+W3mwS74dhm5CTDy5Jd1SPhQMqockB2uEXAZSjECM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bET47Ry+SDJ51qQM8qdx9CZnYyXRaYtVKweZAglGvYkzLIlD8CU8g3Zzt6eIDGrT0phLqDyAVkv5QI9qiw89AMz0UB0UnmArPWcFFwXMGpquxqVQgzmtmrLXUmgPC81Ri8r9+0qeiQ6B+TIpU45EyN93zrQeJZEElg8WLxb+nrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q8T2Gd8H; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4257d5fc9b7so880225e9.2;
        Mon, 05 Aug 2024 17:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722905564; x=1723510364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbMs5Emme3Wh6YV9L5YnP1YT4GqHd5pCxV5C0hflVMM=;
        b=Q8T2Gd8Hj7F5mrT0vvdF/G6iDE3FXHoEvYcTVWEliBAkeHo5IDmcESeMONRhtwnMq+
         C1jaCuZ08DTsODBlN25wWc2TzJea1v6KcLxs4HfZMUcP8Im6N1FgDyfowsYi//EpArTR
         x8EX0Blb8ifjnkoq8lLAymBQhiS5VEdwXH6YjH8K2ZXYjRCioIdQglsZ9UP38I2OFeNb
         dK6D1JXQHCN8b1v8t1oJUvgiQrJff4ta3A3cxCC7Mm27rmgpK6/4TWd5bcVfQHQCC14p
         R+y1XmKR7G+qP4ur1ehpu/ARNFEZytEUpmN1FlJZIfa0c8QfXJ2hVuiYcIGjYukl+QVQ
         KqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722905564; x=1723510364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbMs5Emme3Wh6YV9L5YnP1YT4GqHd5pCxV5C0hflVMM=;
        b=tBi/tT19Zjq1Bnz6mpXtc3QX1rxaKcrBygYxeeMe15uZZw6kiSwDC/ETZlXacGYaWV
         g1YlmCFM25SzE5RSgnenBmog34hq5rhfOhzbeXlC5qEirdTI/z2dAkQDSybJtxrmKHyH
         1XZJ/KXenJtCnYZdN7wcCpf+IcQVVsj5i8z3dqcgr9oIETo4I3/G+PSpEcwQOT6a8b3z
         Qx6PVtErc+PhKdZJdd+1KJH/09Zp+jHZ6Occ/Efq5SimhvaDN34OIiHRwT+9uw3wgWBS
         NjGfj6PU2I9ODqe3w2LcFg0Yxu9Ezv6otMIBINFHAic2lyOMOdzHUpOT3oUnb0dmQt+U
         pxaw==
X-Forwarded-Encrypted: i=1; AJvYcCVMySugepxudVKgOzIg+gEiiIps+el6q+zZVGWfYcx3DrnaJjFH0/HySlOTFM6q39LloD9+T8GDHPOwNLXVl6NzVrkl5296Jeo9kLKbli+UY8dH5Ep5kuYqEweXgNQUk9riaYHfef70gwSxapdvwh29v32sMEKWSYHTdsVGRiCUcMVzQNsOwkpbmwVKKmZlQNOEYbywQhOqo4oVn0sMhkSaXs/vW5dj17VM
X-Gm-Message-State: AOJu0YySGYqwbg8cw7WoMK2o+w8Krc4HGPH22OmpuMnUEWMyfx6fI+OO
	qC3ji1P3AQCTT+yYfcdCDxAJghK7w8YjHGo0u2v4Y4CFZm/qqRS/Y3IhsHSIbMvRya2tZp/l/jZ
	ubgA4rNAY5gtx+WgLT3fyDm8E8x0=
X-Google-Smtp-Source: AGHT+IGqdqorrE2wlr/gRUXIf6uZerGtzKcZj5VR2LPXl0lkIPBaNlvbUHmQ57kNpAjkgdSFWmDjnDGMqxYFtJZpI1s=
X-Received: by 2002:a5d:6042:0:b0:368:7f8f:ca68 with SMTP id
 ffacd0b85a97d-36bbc117fd0mr8920631f8f.30.1722905564079; Mon, 05 Aug 2024
 17:52:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240731124505.2903877-1-linyunsheng@huawei.com>
 <20240731124505.2903877-5-linyunsheng@huawei.com> <CAKgT0UcqdeSJdjZ_FfwyCnT927TwOkE4zchHLOkrBEmhGzex9g@mail.gmail.com>
 <22fda86c-d688-42e7-99e8-e2f8fcf1a5ba@huawei.com> <CAKgT0UcuGj8wvC87=A+hkarRupfhjGM0BPzLUT2AJc8Ovg_TFg@mail.gmail.com>
 <877efebe-f316-4192-aada-dd2657b74125@huawei.com> <CAKgT0UfUkqR2TJQt6cSEdANNxQEOkjGqpPXhaXmrrxB0KwXmEQ@mail.gmail.com>
 <2a29ce61-7136-4b9b-9940-504228b10cba@gmail.com>
In-Reply-To: <2a29ce61-7136-4b9b-9940-504228b10cba@gmail.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Tue, 6 Aug 2024 06:22:08 +0530
Message-ID: <CAKgT0Uc6yw4u5Tjw1i0cV=C_ph+A5w0b_mtQMXmnBfKN_vvaDA@mail.gmail.com>
Subject: Re: [PATCH net-next v12 04/14] mm: page_frag: add '_va' suffix to
 page_frag API
To: Yunsheng Lin <yunshenglin0825@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
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
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>, 
	Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, intel-wired-lan@lists.osuosl.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	linux-nvme@lists.infradead.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 4, 2024 at 10:00=E2=80=AFAM Yunsheng Lin <yunshenglin0825@gmail=
.com> wrote:
>
> On 8/3/2024 1:00 AM, Alexander Duyck wrote:
>
> >>
> >>>
> >>> As far as your API extension and naming maybe you should look like
> >>> something like bio_vec and borrow the naming from that since that is
> >>> essentially what you are passing back and forth is essentially that
> >>> instead of a page frag which is normally a virtual address.
> >>
> >> I thought about adding something like bio_vec before, but I am not sur=
e
> >> what you have in mind is somthing like I considered before?
> >> Let's say that we reuse bio_vec like something below for the new APIs:
> >>
> >> struct bio_vec {
> >>          struct page     *bv_page;
> >>          void            *va;
> >>          unsigned int    bv_len;
> >>          unsigned int    bv_offset;
> >> };
> >
> > I wasn't suggesting changing the bio_vec. I was suggesting that be
> > what you pass as a pointer reference instead of the offset. Basically
> > your use case is mostly just for populating bio_vec style structures
> > anyway.
>
> I wasn't trying/going to reuse/change bio_vec for page_frag, I was just
> having a hard time coming with a good new name for it.
> The best one I came up with is pfrag_vec, but I am not sure about the
> 'vec' as the "vec" portion of the name would suggest, iovec structures
> tend to come in arrays, mentioned in the below article:
> https://lwn.net/Articles/625077/
>
> Anther one is page_frag, which is currently in use.
>
> Or any better one in your mind?

I was suggesting using bio_vec, not some new structure. The general
idea is that almost all the values you are using are exposed by that
structure already in the case of the page based calls you were adding,
so it makes sense to use what is there rather than reinventing the
wheel.

> >
> >> It seems we have the below options for the new API:
> >>
> >> option 1, it seems like a better option from API naming point of view,=
 but
> >> it needs to return a bio_vec pointer to the caller, it seems we need t=
o have
> >> extra space for the pointer, I am not sure how we can avoid the memory=
 waste
> >> for sk_page_frag() case in patch 12:
> >> struct bio_vec *page_frag_alloc_bio(struct page_frag_cache *nc,
> >>                                      unsigned int fragsz, gfp_t gfp_ma=
sk);
> >>
> >> option 2, it need both the caller and callee to have a its own local s=
pace
> >> for 'struct bio_vec ', I am not sure if passing the content instead of
> >> the pointer of a struct through the function returning is the common p=
attern
> >> and if it has any performance impact yet:
> >> struct bio_vec page_frag_alloc_bio(struct page_frag_cache *nc,
> >>                                     unsigned int fragsz, gfp_t gfp_mas=
k);
> >>
> >> option 3, the caller passes the pointer of 'struct bio_vec ' to the ca=
llee,
> >> and page_frag_alloc_bio() fills in the data, I am not sure what is the=
 point
> >> of indirect using 'struct bio_vec ' instead of passing 'va' & 'fragsz'=
 &
> >> 'offset' through pointers directly:
> >> bool page_frag_alloc_bio(struct page_frag_cache *nc,
> >>                           unsigned int fragsz, gfp_t gfp_mask, struct =
bio_vec *bio);
> >>
> >> If one of the above option is something in your mind? Yes, please be m=
ore specific
> >> about which one is the prefer option, and why it is the prefer option =
than the one
> >> introduced in this patchset?
> >>
> >> If no, please be more specific what that is in your mind?
> >
> > Option 3 is more or less what I had in mind. Basically you would
> > return an int to indicate any errors and you would be populating a
> > bio_vec during your allocation. In addition you would use the bio_vec
>
> Actually using this new bio_vec style structures does not seem to solve
> the APIs naming issue this patch is trying to solve as my understanding,
> as the new struct is only about passing one pointer or multi-pointers
> from API naming perspective. It is part of the API naming, but not all
> of it.

I have no idea what you are talking about. The issue was you were
splitting things page_frag_alloc_va and page_frag_alloc_pg. Now it
would be page_frag_alloc and page_frag_alloc_bio or maybe
page_frag_fill_bio which would better explain what you are doing with
this function.

> > as a tracker of the actual fragsz so when you commit you are
> > committing with the fragsz as it was determined at the time of putting
> > the bio_vec together so you can theoretically catch things like if the
> > underlying offset had somehow changed from the time you setup the
>
> I think we might need a stronger argument than the above to use the new
> *vec thing other than the above debugging feature.
>
> I looked throught the bio_vec related info, and come along somewhat not
> really related, but really helpful "What=E2=80=99s all this get us" secti=
on:
> https://docs.kernel.org/block/biovecs.html
>
> So the question seems to be: what is this new struct for page_frag get
> us?
>
> Generally, I am argeed with the new struct thing if it does bring us
> something other than the above debugging feature. Otherwise we should
> avoid introducing a new thing which is hard to argue about its existent.

I don't want a new structure. I just want you to use the bio_vec for
spots where you are needing to use a page because you are populating a
bio_vec.

> > allocation. It would fit well into your probe routines since they are
> > all essentially passing the page, offset, and fragsz throughout the
> > code.
>
> For the current probe routines, the 'va' need to be passed, do you
> expect the 'va' to be passed by function return, double pointer, or
> new the *_vec pointer?

I would suggest doing so via the *_vec pointer. The problem as I see
it is that the existing code is exposing too much of the internals and
setting up the possibility for a system to get corrupted really
easily. At least if you are doing this with a bio_vec you can verify
that you have the correct page and offset before you move the offset
up by the length which should have been provided by the API in the
first place and not just guessed at based on what the fragsz was that
you requested.

