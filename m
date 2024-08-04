Return-Path: <kvm+bounces-23172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59A56946C23
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 06:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 891281C2143F
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 04:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA32ADDC7;
	Sun,  4 Aug 2024 04:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aKKSMq+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D6B2F2E;
	Sun,  4 Aug 2024 04:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722745840; cv=none; b=NwmbsWEw6zROZENcbiNqfm0b5tSo3ztGgZtMfHuXlH+OXOBaxegd5rsEZUUfd52hDYyKMPGFk5rmEYZQo66/fEzOP0MOmCvU0j2ZWJuLUd6AiHKfQ3SrB+fkPo8kveuzPMF7vMMPqYIkNPirM15vmBayUebt8chNio7BkkkTQcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722745840; c=relaxed/simple;
	bh=xoY1WzZPEPZ9zAsX+Nnqw7SzRfo1OpiTjGhSMUtJtEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NdNj8S68gi+JFTU4fa0c1nT/p478l7S2g3latHV/dnxXRFNGHgBX2OAe+KlAwZbFzSmn1QCTq9jTsJdy2q2RIGDF+uENTam+FdnCK38Z9t98EzhT1JEUwt97h4gW/GLSJfJ/bEaMhmh18AH9k6zFlptXEY5naeNlRtB/yW5wj3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aKKSMq+R; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-7a1be7b5d70so3307797a12.0;
        Sat, 03 Aug 2024 21:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722745838; x=1723350638; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xlk57dWXqV77ALqJZrDySJJvovhv9kbwJVS4WA6M5w0=;
        b=aKKSMq+RhNBYIt8V/r2WOc8MypCENcKF78dKysOu486R7FKA1pNZDndCE3MLJ7Hscm
         CGCFbOQiq4rfPH93aof/VpoA6EfGI8iWO2xo3KZsISA07ymH58i6h4cbhEZP5vhD0Spf
         rO+evI5+ZWYYD3aW7BVxtkQfratvg9eHVf79j4v2415M9TkUDGGZ3aSsX7QXFAHb3hop
         aly22D01kTwhWlvFpe9eOTFdiFtQg6dRgMSq2cqfWyHNYEaUIxI+T2AwIF6M0DnHL1l3
         f/li+FOYFj+6nu0oUg428wnuwDKxtyAOHVdoOGhVEY3++S+SduuGGRwULlqsITIWNjQ6
         23wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722745838; x=1723350638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xlk57dWXqV77ALqJZrDySJJvovhv9kbwJVS4WA6M5w0=;
        b=T3+dK+Ovs5O29pbUfwP+0nRGsJW0H4eUfaCeZcdaNFUTuKChHZXPCdDOXA3Fgdvveq
         QBPQf5nWOQOcGnF/Uy6mWg+XAPj6dbxK7/xHDQvvhf2xEEPrJ01x9dit62AYD6FsdMAl
         FZQs+xTi06nXevSgDtpVA1Ycx4YsJAvwif2Z0gumTwBbhcWBKh315M6c3nYfs9V2xIg0
         BA2AbIGfAvLie6bT8TzDp94Y/1PXLZX3/gx8i6qsVVchKY8F3l+X+hOeJSPscy/7u3ga
         oOba1mWCf/ZS477PwbaE1GQ0iahIRPjBJcJQcpRUVEFzLeBEFkqEzsZY7BGHbyHw4f+O
         DVwg==
X-Forwarded-Encrypted: i=1; AJvYcCX2QxRPToWRskOIhE+7hszw6xnqWu8NCYwGv5n0BbKJSev8qEI0KYMwhysLnliqD951kq78dWBmP6apwmBdXRi5jDyVZ3JO9u32DK+qsISyPaVmjWyMj2RqBZqKxkSYA8thEA0NyqBL+KTscyLSclR/SOd+O+sAl9QzEdpX4EWUyBvb52H5g6Cbz47sGqPEO5A3KcOQXL2Ze3Vpy/D2zzZK+rH1YVd6+Ps8
X-Gm-Message-State: AOJu0Yzx7X5KdnJQmkiBtHuuL1vB/fQbDfn7w+b6jUm8hIO1Wkiyv5dN
	3u+YbKYdnQTswSmEK1nvCRNmaz4HdB9KdDs6uxllfOhwuvkLPLJx
X-Google-Smtp-Source: AGHT+IGsvTDJ4EYqxMHnrnabL29RSd4zV3sYpylbcRFlgCkQFp8MTku4ddABSnqWe2wodzlqv0aHUA==
X-Received: by 2002:a05:6a21:3d8b:b0:1c6:9968:f4f4 with SMTP id adf61e73a8af0-1c699690eacmr14086917637.11.1722745837611;
        Sat, 03 Aug 2024 21:30:37 -0700 (PDT)
Received: from ?IPV6:2409:8a55:301b:e120:f82c:57ba:8bf:3093? ([2409:8a55:301b:e120:f82c:57ba:8bf:3093])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7b764fb4994sm3417427a12.62.2024.08.03.21.30.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Aug 2024 21:30:37 -0700 (PDT)
Message-ID: <2a29ce61-7136-4b9b-9940-504228b10cba@gmail.com>
Date: Sun, 4 Aug 2024 12:30:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v12 04/14] mm: page_frag: add '_va' suffix to
 page_frag API
To: Alexander Duyck <alexander.duyck@gmail.com>,
 Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Subbaraya Sundeep <sbhatta@marvell.com>,
 Jeroen de Borst <jeroendb@google.com>,
 Praveen Kaligineedi <pkaligineedi@google.com>,
 Shailend Chand <shailend@google.com>, Eric Dumazet <edumazet@google.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Sunil Goutham <sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>,
 hariprasad <hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>,
 Sean Wang <sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Chaitanya Kulkarni <kch@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Neil Brown <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 intel-wired-lan@lists.osuosl.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-mm@kvack.org,
 bpf@vger.kernel.org, linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org
References: <20240731124505.2903877-1-linyunsheng@huawei.com>
 <20240731124505.2903877-5-linyunsheng@huawei.com>
 <CAKgT0UcqdeSJdjZ_FfwyCnT927TwOkE4zchHLOkrBEmhGzex9g@mail.gmail.com>
 <22fda86c-d688-42e7-99e8-e2f8fcf1a5ba@huawei.com>
 <CAKgT0UcuGj8wvC87=A+hkarRupfhjGM0BPzLUT2AJc8Ovg_TFg@mail.gmail.com>
 <877efebe-f316-4192-aada-dd2657b74125@huawei.com>
 <CAKgT0UfUkqR2TJQt6cSEdANNxQEOkjGqpPXhaXmrrxB0KwXmEQ@mail.gmail.com>
Content-Language: en-US
From: Yunsheng Lin <yunshenglin0825@gmail.com>
In-Reply-To: <CAKgT0UfUkqR2TJQt6cSEdANNxQEOkjGqpPXhaXmrrxB0KwXmEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/3/2024 1:00 AM, Alexander Duyck wrote:

>>
>>>
>>> As far as your API extension and naming maybe you should look like
>>> something like bio_vec and borrow the naming from that since that is
>>> essentially what you are passing back and forth is essentially that
>>> instead of a page frag which is normally a virtual address.
>>
>> I thought about adding something like bio_vec before, but I am not sure
>> what you have in mind is somthing like I considered before?
>> Let's say that we reuse bio_vec like something below for the new APIs:
>>
>> struct bio_vec {
>>          struct page     *bv_page;
>>          void            *va;
>>          unsigned int    bv_len;
>>          unsigned int    bv_offset;
>> };
> 
> I wasn't suggesting changing the bio_vec. I was suggesting that be
> what you pass as a pointer reference instead of the offset. Basically
> your use case is mostly just for populating bio_vec style structures
> anyway.

I wasn't trying/going to reuse/change bio_vec for page_frag, I was just
having a hard time coming with a good new name for it.
The best one I came up with is pfrag_vec, but I am not sure about the
'vec' as the "vec" portion of the name would suggest, iovec structures 
tend to come in arrays, mentioned in the below article:
https://lwn.net/Articles/625077/

Anther one is page_frag, which is currently in use.

Or any better one in your mind?

> 
>> It seems we have the below options for the new API:
>>
>> option 1, it seems like a better option from API naming point of view, but
>> it needs to return a bio_vec pointer to the caller, it seems we need to have
>> extra space for the pointer, I am not sure how we can avoid the memory waste
>> for sk_page_frag() case in patch 12:
>> struct bio_vec *page_frag_alloc_bio(struct page_frag_cache *nc,
>>                                      unsigned int fragsz, gfp_t gfp_mask);
>>
>> option 2, it need both the caller and callee to have a its own local space
>> for 'struct bio_vec ', I am not sure if passing the content instead of
>> the pointer of a struct through the function returning is the common pattern
>> and if it has any performance impact yet:
>> struct bio_vec page_frag_alloc_bio(struct page_frag_cache *nc,
>>                                     unsigned int fragsz, gfp_t gfp_mask);
>>
>> option 3, the caller passes the pointer of 'struct bio_vec ' to the callee,
>> and page_frag_alloc_bio() fills in the data, I am not sure what is the point
>> of indirect using 'struct bio_vec ' instead of passing 'va' & 'fragsz' &
>> 'offset' through pointers directly:
>> bool page_frag_alloc_bio(struct page_frag_cache *nc,
>>                           unsigned int fragsz, gfp_t gfp_mask, struct bio_vec *bio);
>>
>> If one of the above option is something in your mind? Yes, please be more specific
>> about which one is the prefer option, and why it is the prefer option than the one
>> introduced in this patchset?
>>
>> If no, please be more specific what that is in your mind?
> 
> Option 3 is more or less what I had in mind. Basically you would
> return an int to indicate any errors and you would be populating a
> bio_vec during your allocation. In addition you would use the bio_vec

Actually using this new bio_vec style structures does not seem to solve
the APIs naming issue this patch is trying to solve as my understanding,
as the new struct is only about passing one pointer or multi-pointers
from API naming perspective. It is part of the API naming, but not all
of it.

> as a tracker of the actual fragsz so when you commit you are
> committing with the fragsz as it was determined at the time of putting
> the bio_vec together so you can theoretically catch things like if the
> underlying offset had somehow changed from the time you setup the

I think we might need a stronger argument than the above to use the new
*vec thing other than the above debugging feature.

I looked throught the bio_vec related info, and come along somewhat not
really related, but really helpful "What’s all this get us" section:
https://docs.kernel.org/block/biovecs.html

So the question seems to be: what is this new struct for page_frag get
us?

Generally, I am argeed with the new struct thing if it does bring us
something other than the above debugging feature. Otherwise we should
avoid introducing a new thing which is hard to argue about its existent.

> allocation. It would fit well into your probe routines since they are
> all essentially passing the page, offset, and fragsz throughout the
> code.

For the current probe routines, the 'va' need to be passed, do you
expect the 'va' to be passed by function return, double pointer, or
new the *_vec pointer?

> 



