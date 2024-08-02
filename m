Return-Path: <kvm+bounces-23083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A6A946237
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 482761C21006
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 17:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC4515C12A;
	Fri,  2 Aug 2024 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bsmO4F2k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700D116BE14;
	Fri,  2 Aug 2024 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722618080; cv=none; b=oDyqWrK3Ao6zUanKYIFR+bu5rC4v9tuKG9rpAVpmH+I8MWVidki0miVt91WwPdJRTY1EzVCC0iemZnzEyNO8diFkJna8p3cylzzP9HxNugV/Ebqtd7vKv+h4gT29WPbb9OqyB9BWKSaz9ePne7Mzl0igfTH00tld60vmOqSJSi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722618080; c=relaxed/simple;
	bh=PlUfNCqxVe9v+v7ZCfIJKFswC6CmaMtq9PjiV01p50s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hW8WrFGq6WlIhbzryoRb946xZQZ1vCkWg+jvx+We9hbYOdOC4U5/sV2/yX6MWZb7sLCEb7ULDnjKChxogLtOtRDAdVNB9sRVwq3qfDtprQD22fhhXy0V1YjEtGg9C9Qr2CcrRYeAnQs5/ACGxMdWU4YRr0j0JnGBpbzaoUK9uTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bsmO4F2k; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3685a564bafso4082088f8f.3;
        Fri, 02 Aug 2024 10:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722618077; x=1723222877; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vpcsgqmtuPo+pz6tWtSNKqkTo9JxSymPCppu91onA2Q=;
        b=bsmO4F2knRDOZMfNEU8Azk/GNULiAXnxS80JPpv+axd85tLDm6m6LntUcX8SZSJQe1
         IS3Cv2SuD5kKrwgvB/OOQegjQQveY4am6XzsMLOwSWU498byLpxFCjTBuy9ffp6q4F9i
         Ru8kpokPX9W4PQ2yQvLPm87LFk/dfKVlNhzpokwERjCUSp/M16r7M4Y8PQGm231Nv7fj
         3QEirIC3qXOygmk1THZfjsGDyVVamcMNQ4i9zbTp+MWVMkTbdW/rAw82gLqdizp+rUiW
         jUblW154JJ9xY4VWKAVaxf7Xg8xTl85Y2DOe917+hEiN15FBuCRMLPkhg5UdlNi1JMVp
         YAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722618077; x=1723222877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vpcsgqmtuPo+pz6tWtSNKqkTo9JxSymPCppu91onA2Q=;
        b=KDDVxN/D5HYlBLQSJViX6rMhqE843Bcii5kyGewydbuag6RnpmBM+c2SbJbkJa+ec0
         z5fPmoQFSPsnO2Vcvh7vl1TmR3V/mvfcVW32+SU+UTL1vUb4SXBfgrrvREC2HF8NUFaJ
         MO3T+6CPLolZIsDjrMJexYzk2g33MVDOZwnDC46kfjZr0ckT1CjQMkuDexXb3OI2Fltu
         iy3AcQ6kGqWeR2HQaO2AuNdPX2peDi77XucsmQ7wxx567xxWOrOtMYhaDR7QtIcUe2g0
         i31mENT9oZfxMxHIbupahaWUjek+abfLzY+eneR0jmerBAZUtPKFsPmNEwj7198XOoQD
         Cr+A==
X-Forwarded-Encrypted: i=1; AJvYcCXG6dVZmnAKzqHrqFaAiBzhvS1MW1TTlJqRsJ1WzEnpE5zd7UMa44qEYu5lsaJxKqFTjKCp3ngAf4E/DmPRJDVcKLtuPMIBc9S/Qj7H8FK1X76/9NaX7f/jQ0qxyYpECCiXPmmoj9H50rPKWdd26MbwmfeeAv3vFpHthI0/aFnBzEPPezcwSbAVmQY6HqEjs2ubW3cI/PD9i70xGJpqmO3roidaKrCsofil
X-Gm-Message-State: AOJu0YyvfFSIpqJCSXRFCzchI/w6empGhWLOTgBIUok3AXaBJ3j+yI1s
	o9pCL4N0SYmqbtMU8FAcQMSvShsjcGUosd0rUlEtMV1crQOWGQdh3voxpDebB265+IdOaCde53r
	j635c7p4VOxtNL8tQliGgabKRX/s=
X-Google-Smtp-Source: AGHT+IH75FU4JpBvhRKVqmFn8me2clEuJ7/a5V8Xhv6OElYPF/ofyi1s2L5ZzsGAeeZuvfLRALy59I0v9WsGM6Mhk90=
X-Received: by 2002:adf:e98a:0:b0:368:4d33:9aac with SMTP id
 ffacd0b85a97d-36bbc0fc757mr2416504f8f.31.1722618076415; Fri, 02 Aug 2024
 10:01:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240731124505.2903877-1-linyunsheng@huawei.com>
 <20240731124505.2903877-5-linyunsheng@huawei.com> <CAKgT0UcqdeSJdjZ_FfwyCnT927TwOkE4zchHLOkrBEmhGzex9g@mail.gmail.com>
 <22fda86c-d688-42e7-99e8-e2f8fcf1a5ba@huawei.com> <CAKgT0UcuGj8wvC87=A+hkarRupfhjGM0BPzLUT2AJc8Ovg_TFg@mail.gmail.com>
 <877efebe-f316-4192-aada-dd2657b74125@huawei.com>
In-Reply-To: <877efebe-f316-4192-aada-dd2657b74125@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Aug 2024 10:00:39 -0700
Message-ID: <CAKgT0UfUkqR2TJQt6cSEdANNxQEOkjGqpPXhaXmrrxB0KwXmEQ@mail.gmail.com>
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

On Fri, Aug 2, 2024 at 3:05=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:
>
> On 2024/8/1 23:21, Alexander Duyck wrote:
> > On Thu, Aug 1, 2024 at 6:01=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei=
.com> wrote:
> >>
> >> On 2024/8/1 2:13, Alexander Duyck wrote:
> >>> On Wed, Jul 31, 2024 at 5:50=E2=80=AFAM Yunsheng Lin <linyunsheng@hua=
wei.com> wrote:
> >>>>
> >>>> Currently the page_frag API is returning 'virtual address'
> >>>> or 'va' when allocing and expecting 'virtual address' or
> >>>> 'va' as input when freeing.
> >>>>
> >>>> As we are about to support new use cases that the caller
> >>>> need to deal with 'struct page' or need to deal with both
> >>>> 'va' and 'struct page'. In order to differentiate the API
> >>>> handling between 'va' and 'struct page', add '_va' suffix
> >>>> to the corresponding API mirroring the page_pool_alloc_va()
> >>>> API of the page_pool. So that callers expecting to deal with
> >>>> va, page or both va and page may call page_frag_alloc_va*,
> >>>> page_frag_alloc_pg*, or page_frag_alloc* API accordingly.
> >>>>
> >>>> CC: Alexander Duyck <alexander.duyck@gmail.com>
> >>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >>>> Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> >>>
> >>> I am naking this patch. It is a pointless rename that is just going t=
o
> >>> obfuscate the git history for these callers.
> >>
> >> I responded to your above similar comment in v2, and then responded mo=
re
> >> detailedly in v11, both got not direct responding, it would be good to
> >> have more concrete feedback here instead of abstract argument.
> >>
> >> https://lore.kernel.org/all/74e7259a-c462-e3c1-73ac-8e3f49fb80b8@huawe=
i.com/
> >> https://lore.kernel.org/all/11187fe4-9419-4341-97b5-6dad7583b5b6@huawe=
i.com/
> >
> > I will make this much more understandable. This patch is one of the
> > ones that will permanently block this set in my opinion. As such I
> > will never ack this patch as I see no benefit to it. Arguing with me
> > on this is moot as you aren't going to change my mind, and I don't
> > have all day to argue back and forth with you on every single patch.
>
> Let's move on to more specific technical discussion then.
>
> >
> > As far as your API extension and naming maybe you should look like
> > something like bio_vec and borrow the naming from that since that is
> > essentially what you are passing back and forth is essentially that
> > instead of a page frag which is normally a virtual address.
>
> I thought about adding something like bio_vec before, but I am not sure
> what you have in mind is somthing like I considered before?
> Let's say that we reuse bio_vec like something below for the new APIs:
>
> struct bio_vec {
>         struct page     *bv_page;
>         void            *va;
>         unsigned int    bv_len;
>         unsigned int    bv_offset;
> };

I wasn't suggesting changing the bio_vec. I was suggesting that be
what you pass as a pointer reference instead of the offset. Basically
your use case is mostly just for populating bio_vec style structures
anyway.

> It seems we have the below options for the new API:
>
> option 1, it seems like a better option from API naming point of view, bu=
t
> it needs to return a bio_vec pointer to the caller, it seems we need to h=
ave
> extra space for the pointer, I am not sure how we can avoid the memory wa=
ste
> for sk_page_frag() case in patch 12:
> struct bio_vec *page_frag_alloc_bio(struct page_frag_cache *nc,
>                                     unsigned int fragsz, gfp_t gfp_mask);
>
> option 2, it need both the caller and callee to have a its own local spac=
e
> for 'struct bio_vec ', I am not sure if passing the content instead of
> the pointer of a struct through the function returning is the common patt=
ern
> and if it has any performance impact yet:
> struct bio_vec page_frag_alloc_bio(struct page_frag_cache *nc,
>                                    unsigned int fragsz, gfp_t gfp_mask);
>
> option 3, the caller passes the pointer of 'struct bio_vec ' to the calle=
e,
> and page_frag_alloc_bio() fills in the data, I am not sure what is the po=
int
> of indirect using 'struct bio_vec ' instead of passing 'va' & 'fragsz' &
> 'offset' through pointers directly:
> bool page_frag_alloc_bio(struct page_frag_cache *nc,
>                          unsigned int fragsz, gfp_t gfp_mask, struct bio_=
vec *bio);
>
> If one of the above option is something in your mind? Yes, please be more=
 specific
> about which one is the prefer option, and why it is the prefer option tha=
n the one
> introduced in this patchset?
>
> If no, please be more specific what that is in your mind?

Option 3 is more or less what I had in mind. Basically you would
return an int to indicate any errors and you would be populating a
bio_vec during your allocation. In addition you would use the bio_vec
as a tracker of the actual fragsz so when you commit you are
committing with the fragsz as it was determined at the time of putting
the bio_vec together so you can theoretically catch things like if the
underlying offset had somehow changed from the time you setup the
allocation. It would fit well into your probe routines since they are
all essentially passing the page, offset, and fragsz throughout the
code.

