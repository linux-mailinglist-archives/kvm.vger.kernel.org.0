Return-Path: <kvm+bounces-14793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EE28A70F4
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 393AD285131
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D891E13248D;
	Tue, 16 Apr 2024 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNYd/+WM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C6B131726;
	Tue, 16 Apr 2024 16:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713283938; cv=none; b=UV1qUmnZ4BkxM8W9OlcTxkV+WRELxfWf3m6KM8f0EATt10F7uAPVK3X5HpUP0sBXLBGRIrmSngqWrDhOsvY3T4IUCSngPShP5D6dPhcdyAb+JfhFa3S2wN2MKiN9n3qGHnvMZhjC5ZGk/53OUWpJEFJ0NyFwuJz/Qf7GJPsIj3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713283938; c=relaxed/simple;
	bh=EKrDgIJgNXo/R8quzpUy0yW7erzp8PxvHvcTe/50ujU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q7UxvlvWIMrRYgIqavvjuZXm4TWeJvaYaQKqnjkrro0MXCmAbgj+dBsv/sJfDssMNJhQLfk5Jg9l6fc14Hk5uVvMC/Xf6WARZ9oBWxrfhgs6cAOyhbJMjm9hZP9qmRTd6Phch63S5xwkhyk7rtP/wgzMYWGqJqNa7y7sGo+14hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PNYd/+WM; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e5715a9ebdso36956275ad.2;
        Tue, 16 Apr 2024 09:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713283935; x=1713888735; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EKrDgIJgNXo/R8quzpUy0yW7erzp8PxvHvcTe/50ujU=;
        b=PNYd/+WMCJkxq3lys23g1hgaUEyZDH1rNd3cGHTeIZzcTbiGxR4EJSJfGjllMpxSRE
         zVGBGd5oBS2dqmpSQXwo9F5Jd0Uc6F4W0NHSefezL2ECSOf0Ol9weMtdjPRDiNxQ8Veh
         Otl5fuAjZMdnHg8Xryp27Np2YneqRbR4up7gua7mzTdj6YEEBSE3njQfHDHaZA5WfbPU
         hJk6I7oY1eYDa8eJIdBhQJH02XnfXL6L6yt8cGeR5cp5POgzfyrt8VCgB0DV0IHLshmO
         +Cy1H8oHpuS/p7BI12gVvm3quEpQLICCIUrgUjtUh9jdY+zA+nB5VEsEZhInhr4zx1bL
         wfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713283935; x=1713888735;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EKrDgIJgNXo/R8quzpUy0yW7erzp8PxvHvcTe/50ujU=;
        b=uIhZvmNcPkotHAjbcXNcvgaGy9oZV/gOuvauDmOAkT4wf5M3ANTTEabBcVqZMGghwa
         f7Zb4d9GRAZOkrhSjMT7AHbbsYWmP9dT6EZbSzPfi96/Lz7BTV7egzW0vX1MX+fmquRR
         rnCYyKKYFrK/Ei3r1zfT6Fmzx5pZfCCpxVqnuC23Aiq0G/Eer+zHcNSYhfY37IixN96Q
         VUFJuKijSmsBK0SOCSj3pKVohMAUf5iCnd/y1P9bbIxY7bUA/2jUglcA8rlBgvcd0NrC
         bxpIyUrAotBypc0OGDIKH9nSTS8I8AIzkxZU/arxOWxiOMp9F7krPJdxvRb849xj/wkz
         WxwA==
X-Forwarded-Encrypted: i=1; AJvYcCVS0MgTdoo7wFMTLSulSEvz+2b7OO/s6+WmAyns19h5rAmY/ze0RUpCsuu6PmdQgy+K9TKk5Z89wqfaXUV1RiUgrMEBS32EopEE79EK07YJqNBMguwwapqcpH6UrfR79mNhYs08tcWb+fGBRmBCVbrJMibsLExNth2xNi865QDetTSXhSQQ5lcgPeU1yLQckkNK
X-Gm-Message-State: AOJu0YzWpY1EXhk3exoVoit84aRuoDx8ttU6/o+KVRDblvcLjVSUwj/s
	8cGcGaBsXKVhs4Y0PoAdSDp+ndNr69++X0C0/owHehkAqwTKIyrf
X-Google-Smtp-Source: AGHT+IEaBhKQrtE4y17EN+JRfoZ0nAtlgq9TOIgtvD46kDZyqFoPetYC3y2iMwccARAF9quBrezxcQ==
X-Received: by 2002:a17:903:595:b0:1e3:e4ff:7054 with SMTP id jv21-20020a170903059500b001e3e4ff7054mr10328895plb.38.1713283934861;
        Tue, 16 Apr 2024 09:12:14 -0700 (PDT)
Received: from ?IPv6:2605:59c8:43f:400:82ee:73ff:fe41:9a02? ([2605:59c8:43f:400:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id lf16-20020a170902fb5000b001e5119c1923sm10005822plb.71.2024.04.16.09.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 09:12:14 -0700 (PDT)
Message-ID: <18ca19fa64267b84bee10473a81cbc63f53104a0.camel@gmail.com>
Subject: Re: [PATCH net-next v2 07/15] mm: page_frag: add '_va' suffix to
 page_frag API
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org,  pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Jeroen de Borst
 <jeroendb@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>, 
 Shailend Chand <shailend@google.com>, Eric Dumazet <edumazet@google.com>,
 Jesse Brandeburg <jesse.brandeburg@intel.com>, Tony Nguyen
 <anthony.l.nguyen@intel.com>,  Sunil Goutham <sgoutham@marvell.com>, Geetha
 sowjanya <gakula@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
 hariprasad <hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>, Sean Wang
 <sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>, Lorenzo
 Bianconi <lorenzo@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Keith
 Busch <kbusch@kernel.org>,  Jens Axboe <axboe@kernel.dk>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,  Chaitanya Kulkarni
 <kch@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
 <jasowang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend
 <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin
 KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP
 Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo
 <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,  David Howells
 <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown
 <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Trond Myklebust
 <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, 
 intel-wired-lan@lists.osuosl.org, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org, 
 kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-mm@kvack.org, 
 bpf@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-nfs@vger.kernel.org
Date: Tue, 16 Apr 2024 09:12:01 -0700
In-Reply-To: <20240415131941.51153-8-linyunsheng@huawei.com>
References: <20240415131941.51153-1-linyunsheng@huawei.com>
	 <20240415131941.51153-8-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-04-15 at 21:19 +0800, Yunsheng Lin wrote:
> Currently most of the API for page_frag API is returning
> 'virtual address' as output or expecting 'virtual address'
> as input, in order to differentiate the API handling between
> 'virtual address' and 'struct page', add '_va' suffix to the
> corresponding API mirroring the page_pool_alloc_va() API of
> the page_pool.
>=20
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

This patch is a total waste of time. By that logic we should be
renaming __get_free_pages since it essentially does the same thing.

This just seems like more code changes for the sake of adding code
changes rather than fixing anything. In my opinion it should be dropped
from the set.


