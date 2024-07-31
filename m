Return-Path: <kvm+bounces-22803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38CCC943580
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 20:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE4CB1F2200E
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 18:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B33482DB;
	Wed, 31 Jul 2024 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XdxtNm5j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148B03BBF2;
	Wed, 31 Jul 2024 18:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722449674; cv=none; b=R0NNgvW/qUIgbA6IgSdWYWp3sVC8tuVD1cD8nIUcNaSxx5VoLvG+u/ec807ExJbeBH8FNPMzz0X2cGbf4JmNWkI9DmM7jbq/K6xib5b7iS9vJPNitoH/On3vcBTZGmSItUuXqjivOThvLt4ifIwP3ZxkxFCXehrU9FyvpRBZNmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722449674; c=relaxed/simple;
	bh=Pp0vWyL7VeDKadleGOEHNTdhDMPNVXeakIX5tgvvsCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m5cXv0CFfIuWTKgBURXbCUV6jNQ8yuMOsiysmwOiXYk7D+Oz2hPEkbJLfEXs9i4pQJL0sPgKtagVG7dwjR8Qhh4WB4PaetWPGzYcccs8Dz0WG9jrqsbamoVhNfq+E7NP7pBTvLhTuHnIQDJ2q7DISYmDt0fJISSELkt/apR35SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XdxtNm5j; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3684e8220f9so695951f8f.1;
        Wed, 31 Jul 2024 11:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722449671; x=1723054471; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pp0vWyL7VeDKadleGOEHNTdhDMPNVXeakIX5tgvvsCU=;
        b=XdxtNm5jvf2ukVXdfu/2pFEfwrjpiI25CyYbxqrDGe2klH14/y3aSQ6XSI+YwkGQbw
         atNUcciuw+dJ5lqTkV62dyTEeoV96ta6vcjEm8nNNDPDPpwf7Tnzgqmj4IzPofm93WdS
         thwQnbsiQvm1BSwS8AAPGHJPiobLitebFssQIlRb8ToE46q1/pL9+M/zVHrmaqKH6HlQ
         fEpdcjapz/+23AA7D5d5ApoLedbJ+4Iqms8TQ0ETQx/w+vbwo3UnSmSvv5cTL3phwgXD
         IhDgxwI+VbnkcxJ0NkZZwJdUiOb9i5aMHcGnsbk8+jSqHEULAcRl7RLoMdVBLed9hiw4
         +jUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722449671; x=1723054471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pp0vWyL7VeDKadleGOEHNTdhDMPNVXeakIX5tgvvsCU=;
        b=DFSYsgb/4FTbifeganFqZPbe5CBf3ArKeD3jSkB1W4wJd4vYFruG+6BPbFCQf4vtdv
         u5GEw8M2Kr7mMvH1rBtNvPX79Y20PmhdSm6P7/D1mXzk/XuqXN17GKO+YQntvQKeuWNo
         YNJQx0WlT9fqdDvLW+JlV7UmUGIAYe+MdkR0N4Zjpv0/wu6j0e64ivDvmdbNHf3mfgQo
         uGHPB+hAAUmrER9eHyum5yPZfZVUSHjyGlRKXHyELonSFVnG9tsxzTdcNXsw0pw46MV7
         uEUPK5nXNbD7llH9QbRQ7B6T0pdU3bPr2b6qdkSWVAg29esOgygIPWMdNwUhjsFGv0BE
         NMwA==
X-Forwarded-Encrypted: i=1; AJvYcCUlB+ZaOqV6VX+u9BVl1k133RSwYXFHdLu0mS1h2tlYeiKf6Qkobg/L7xZVeaf6Ec7CM6J+925rOxFg2AUp97FksRIUgv3qDUSeqPRfOR3AmlVze3mJsotkt+CT3SWncO9eCmRrLQObjhGtukCTotb8e6/6y9nY5sDiHdjrR0gXxzzCFEej+v3DL3O/rj7TQ4PS/pzywsY62Mn4wBW5JNPbuSHm9nKl5rMU
X-Gm-Message-State: AOJu0YwnvVtCrT2Dc6h4nVjzlEsSUvG40QNthfZ12B4FjHjEAvn/S2aq
	S/EU9sH0ZURS/UFd9eZtMIvd4jLGar3ORYtltEkG/uOBSfHa/8ocJLtEuM1gFLGA5Ocawub2Afk
	DuUWu8SkXeKOKaurw+n6uLq82qQM=
X-Google-Smtp-Source: AGHT+IGv2ta3BQ/aeYaFuo6uJnDIs2Oh1PDBCcZrH55JaT3W4vssxSHelAFkF3XSYf9nggWCe12LvyT/WHK2KvkPs3c=
X-Received: by 2002:a05:6000:4582:b0:365:aec0:e191 with SMTP id
 ffacd0b85a97d-36b8c8fdbdbmr4052808f8f.21.1722449671103; Wed, 31 Jul 2024
 11:14:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240731124505.2903877-1-linyunsheng@huawei.com> <20240731124505.2903877-5-linyunsheng@huawei.com>
In-Reply-To: <20240731124505.2903877-5-linyunsheng@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Wed, 31 Jul 2024 11:13:54 -0700
Message-ID: <CAKgT0UcqdeSJdjZ_FfwyCnT927TwOkE4zchHLOkrBEmhGzex9g@mail.gmail.com>
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

On Wed, Jul 31, 2024 at 5:50=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
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

I am naking this patch. It is a pointless rename that is just going to
obfuscate the git history for these callers.

As I believe I said before I would prefer to see this work more like
the handling of __get_free_pages and __free_pages in terms of the use
of pages versus pointers and/or longs. Pushing this API aside because
you want to reuse the name for something different isn't a valid
reason to rename an existing API and will just lead to confusion.

