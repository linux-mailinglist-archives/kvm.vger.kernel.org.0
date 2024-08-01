Return-Path: <kvm+bounces-22954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DDE944F11
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFF33283EA2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13901B14FB;
	Thu,  1 Aug 2024 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BB3xU6xq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440C713B5A6;
	Thu,  1 Aug 2024 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722525760; cv=none; b=NzfT4qyh7++TenrkXk+HqwMOrhr3dQzKDNhFzwZiKF7xuJlNoN0HhZ4bDnE8R6sqHZ4SXMsR3QdlA5WhMtSkrmS9c9IlkdG1bU1WYvCHmExnq8l4QpcEjci2ZrZmJChJzTAVY7qbNcIq1YCzytl5XozJZ+MkBNSQrpcnzfov8cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722525760; c=relaxed/simple;
	bh=8Dx2Bv0d2od3Km7MjoXRYzhl1VfhP4WqwsY5gBZHcjc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fE28F938iGfEfrdV3ayPQWECxkFMpXRpAzBGiKNtkYo9eJZ6Ygx5s6Th173Pm8FW1UIuKKQQs03VY0Fgmr5njGUiD0iRT58zM/xTkc7L4QU4GlknEXI+U33HdGZaZXYaR5/pCQcK+UhO5/D0mJr9wZop1sdijWtrEpjtc1d6J/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BB3xU6xq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-426526d30aaso46929135e9.0;
        Thu, 01 Aug 2024 08:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722525756; x=1723130556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Dx2Bv0d2od3Km7MjoXRYzhl1VfhP4WqwsY5gBZHcjc=;
        b=BB3xU6xqyjIDBDJY6xQRQSs2g+U8g4KWO3GVaMTLDo/c73ZZXKOTjNDNNB77bGcK0x
         A4rSPtsyYAtviEyI8OHk286hWeeSH5jvzUlZQcWAmPpWApJMvPVAzVMj0JFhGDljkK59
         DvkXy+ZR8bKlk2+6J2ZEFSmftPM/axmwuYyiRZhrf2DoMRtoI1HJWPYlQZ3PKu2FBWmR
         XJWe+jDEeulvqlgTl5Caj586Bx53AJBwqt2aJ5s1qcozJN/aK9qQFyHXKTW+j9BmoLU7
         2CUl+cqw5ZhykD9MtN9TqeesXDIAvJ0Eh59Hf30Soqx7kco0t+utR8G45Wu1/8iJNW9e
         HVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722525756; x=1723130556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Dx2Bv0d2od3Km7MjoXRYzhl1VfhP4WqwsY5gBZHcjc=;
        b=RzoW+fVbzTpYCPrHQklGSuXcgV0fJqNe2AL4UrEjyjDTMNc343lj2CBFFQ7fDOUm7/
         x0O1kXeEFHQ3FWEKs1aeaqdwqVX0+PYi9Esoi1X4P8YPKG1aRp0LkyXQY1kWXT6DaEfy
         JeRUVJ2VZ50hOdomFgOJuxx2Saw9NpvDGt3pxP/ApsyYYfnngtTde1sh5zXsZY6G/Mxr
         MOaILnyxkWF1pXoznz/7dsLS43+RlBMenTPrQszSR/rANU4PYbJl7OuOcml3fZcKcq20
         TCgKG2w7sFU9OjQUsZznYq6IOl+TqALM7OHJzSO8sO7eMp5NBiaTogiV3Ovrbg2xvGYZ
         595Q==
X-Forwarded-Encrypted: i=1; AJvYcCVl01zG6UUQ1XDs0gL9S5A1aEkFb/3Pddyt71VtDHFRi5aSj9UQOxx+j5Xb9dBILHig7HshD/jtyrGvU7oDulqO6ENfiYfXhBzVqcsDNIktT79yi0Cy0aVSu3ysaJ9n1Mw8OKVjhdDo0Sb3F542ToPEF/n3I0gPvsEi7MwNPzw3/XiQ87EvRg5KwU7jvAepJRIYssRZC8ZeUxOjtSvj0rdRkxnrcQIM7h0H
X-Gm-Message-State: AOJu0YyRpQ9lWZHSGLkixepwVwikJEzEvX7qO/Ozj478Yy4QFqFbDxTZ
	PHTkvFm1vByaEdG3DzNCRXiVdmAVw0Cb+NXSBjNoRbmP3+9suS3rwlh0WOZZH3Ef1Ox0QybNHwa
	rM0ppu2HGIH18T3uhIq3UAasX4zE=
X-Google-Smtp-Source: AGHT+IHJwpMJUuvVBDGd0+iVwndbV1UbEfs+MYBNb+0c/veShsqCR+fklPSjDi/gK00dEDB9UQYZf/nj06+15imHIwM=
X-Received: by 2002:adf:f14d:0:b0:368:4bc0:9211 with SMTP id
 ffacd0b85a97d-36bbc0f3459mr125871f8f.17.1722525756248; Thu, 01 Aug 2024
 08:22:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240731124505.2903877-1-linyunsheng@huawei.com>
 <20240731124505.2903877-5-linyunsheng@huawei.com> <CAKgT0UcqdeSJdjZ_FfwyCnT927TwOkE4zchHLOkrBEmhGzex9g@mail.gmail.com>
 <22fda86c-d688-42e7-99e8-e2f8fcf1a5ba@huawei.com>
In-Reply-To: <22fda86c-d688-42e7-99e8-e2f8fcf1a5ba@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Thu, 1 Aug 2024 08:21:59 -0700
Message-ID: <CAKgT0UcuGj8wvC87=A+hkarRupfhjGM0BPzLUT2AJc8Ovg_TFg@mail.gmail.com>
Subject: Re: [PATCH net-next v12 04/14] mm: page_frag: add '_va' suffix to
 page_frag API
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
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>, 
	Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, intel-wired-lan@lists.osuosl.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	linux-nvme@lists.infradead.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 6:01=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:
>
> On 2024/8/1 2:13, Alexander Duyck wrote:
> > On Wed, Jul 31, 2024 at 5:50=E2=80=AFAM Yunsheng Lin <linyunsheng@huawe=
i.com> wrote:
> >>
> >> Currently the page_frag API is returning 'virtual address'
> >> or 'va' when allocing and expecting 'virtual address' or
> >> 'va' as input when freeing.
> >>
> >> As we are about to support new use cases that the caller
> >> need to deal with 'struct page' or need to deal with both
> >> 'va' and 'struct page'. In order to differentiate the API
> >> handling between 'va' and 'struct page', add '_va' suffix
> >> to the corresponding API mirroring the page_pool_alloc_va()
> >> API of the page_pool. So that callers expecting to deal with
> >> va, page or both va and page may call page_frag_alloc_va*,
> >> page_frag_alloc_pg*, or page_frag_alloc* API accordingly.
> >>
> >> CC: Alexander Duyck <alexander.duyck@gmail.com>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > I am naking this patch. It is a pointless rename that is just going to
> > obfuscate the git history for these callers.
>
> I responded to your above similar comment in v2, and then responded more
> detailedly in v11, both got not direct responding, it would be good to
> have more concrete feedback here instead of abstract argument.
>
> https://lore.kernel.org/all/74e7259a-c462-e3c1-73ac-8e3f49fb80b8@huawei.c=
om/
> https://lore.kernel.org/all/11187fe4-9419-4341-97b5-6dad7583b5b6@huawei.c=
om/

I will make this much more understandable. This patch is one of the
ones that will permanently block this set in my opinion. As such I
will never ack this patch as I see no benefit to it. Arguing with me
on this is moot as you aren't going to change my mind, and I don't
have all day to argue back and forth with you on every single patch.

As far as your API extension and naming maybe you should look like
something like bio_vec and borrow the naming from that since that is
essentially what you are passing back and forth is essentially that
instead of a page frag which is normally a virtual address.

