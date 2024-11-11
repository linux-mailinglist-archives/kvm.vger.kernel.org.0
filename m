Return-Path: <kvm+bounces-31396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3839C36C4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 03:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86D911F21FF6
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 02:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED6C1411EB;
	Mon, 11 Nov 2024 02:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="P6ZlMDKu"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085F7137930;
	Mon, 11 Nov 2024 02:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731293921; cv=none; b=la3SHHcEKUpz9XjOTooZ2/Jueu2g1y0X9XpLUmRX3fRio5HpzJip/O2f4/OYb5iEuO3J6OY0iTd+DO3uE6Hn2WvWsmZtcET3TaCIh4/SiuJ3Vjh3xI6DTYcF433ZUz6nUdRqVQ8XSdSbt0TYqFjGp4JV/z0m6BBtjJ6okX0Fi1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731293921; c=relaxed/simple;
	bh=TXUjXTHL0gZIfdJ3mRDyIitRCP4DKtW7kpcpVpBjQW0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Y+N0HnGDlBvJutikMNX9Pi3pKoMgZmvNJqAH3ZuJQadYbPxWQ/8iAnkQicxfh3IDx3g2fwFfBQO1gRhyK3DNX3/zrj3Ip5/Z0oGYfAwX1Qoww6WiY4EDZNIp0MusPzFqcI7AcMKEYxjNnC6X0Fczj9WTyCHNiW98cBZadBWM1mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=P6ZlMDKu; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 04194403E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1731293919; bh=LZzQtmhOW2A0Cbau7zJcHxp+bCIY31NKdrMFpZxwDXo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=P6ZlMDKuMAATbHo1fiGbEgO4Fdf7nPT7SqDPMzQuradyDOv6suOb6fxutsindrE+7
	 YAqe/nrrvIXe19T+BoIJr/MCECgPllblWRKx8hLHqgoYKi4NLzXbeUsRzQpHT46Apk
	 16WvyKjjWECdMAXfC++MoWNfnbZX+wQ26rLDNJXwPHBBonUUml1zP30i+yuASAkjfu
	 vyYGpz9zJfCirLY0C0kPoVZJ2DwCt1B305HCUxe1W4/wxWkSW8SGY7ATGH6Tlu1/oF
	 bK8Iuk+1i1x1IgiBH4F39RZX0SXtnRWWPHBQU2Di1gdMOpHExP/t+4A4PrTP3krfc3
	 mdt6p5c5a5xeg==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 04194403E9;
	Mon, 11 Nov 2024 02:58:39 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: anish kumar <yesanishhere@gmail.com>, Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>, Robin
 Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
 <will@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas
 <yishaih@nvidia.com>, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse
 <jglisse@redhat.com>, Andrew
 Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, Randy Dunlap
 <rdunlap@infradead.org>
Subject: Re: [PATCH v3 09/17] docs: core-api: document the IOVA-based API
In-Reply-To: <CABCoZhAN-eeu=E5r+ZbZGTNwQta5yUw86sy8e_Je+Yri-+iuoQ@mail.gmail.com>
References: <cover.1731244445.git.leon@kernel.org>
 <dca3aecdeeaa962c7842bc488378cdf069201d65.1731244445.git.leon@kernel.org>
 <CABCoZhAN-eeu=E5r+ZbZGTNwQta5yUw86sy8e_Je+Yri-+iuoQ@mail.gmail.com>
Date: Sun, 10 Nov 2024 19:58:38 -0700
Message-ID: <875xouv5lt.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

anish kumar <yesanishhere@gmail.com> writes:

> On Sun, Nov 10, 2024 at 5:50=E2=80=AFAM Leon Romanovsky <leon@kernel.org>=
 wrote:
>>
>> From: Christoph Hellwig <hch@lst.de>
>>
>> Add an explanation of the newly added IOVA-based mapping API.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>  Documentation/core-api/dma-api.rst | 70 ++++++++++++++++++++++++++++++
>>  1 file changed, 70 insertions(+)
>>
>> diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api=
/dma-api.rst
>> index 8e3cce3d0a23..61d6f4fe3d88 100644
>> --- a/Documentation/core-api/dma-api.rst
>> +++ b/Documentation/core-api/dma-api.rst
>> @@ -530,6 +530,76 @@ routines, e.g.:::
>>                 ....
>>         }
>>
>> +Part Ie - IOVA-based DMA mappings
>> +---------------------------------
>> +
>> +These APIs allow a very efficient mapping when using an IOMMU.  They ar=
e an
>
> "They" doesn't sound nice.
>> +optional path that requires extra code and are only recommended for dri=
vers
>> +where DMA mapping performance, or the space usage for storing the DMA a=
ddresses
>> +matter.  All the considerations from the previous section apply here as=
 well.
>
> These APIs provide an efficient mapping when using an IOMMU. However, they
> are optional and require additional code. They are recommended primarily =
for
> drivers where performance in DMA mapping or the storage space for DMA
> addresses are critical. All the considerations discussed in the previous =
section
> also apply in this case.
>
> You can disregard this comment, as anyone reading this paragraph will
> understand the intended message.

I don't understand the comment, honestly.  You say "they" doesn't "sound
nice", whatever that means, but your suggestion retains the "they"...?

I'm all for reviews that improve our documentation, but it is
*incredibly* easy to fall into the trivial bikeshed mode.  I've
certainly done it myself.  The end result is less documentation as
people decide, understandably, that it's not worth the pain.  Hopefully
we can all try to do a bit less of that.

FWIW, I think the paragraph is fine as written.

Thanks,

jon

