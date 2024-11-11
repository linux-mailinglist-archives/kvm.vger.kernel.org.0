Return-Path: <kvm+bounces-31486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D099C415A
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53D551F2224B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B711A0BF8;
	Mon, 11 Nov 2024 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="U7Qof0wu"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD2B1E481;
	Mon, 11 Nov 2024 14:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731337169; cv=none; b=MtwU2kB5x4wUnF5zREa89UWPM4AlGiKzSef9HxYRmj/9wdAJ6Z/KOGLEO0TSMO68UoqDOISjUqFyxZMEkl6iJqB3BYBmWPoHZ2/wDsJyyR8vMHn+nDfyXpCvOtImR419J1TSw1vujD9hhTd7vgQkCLF6nz40gVMfVT0bemjpwaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731337169; c=relaxed/simple;
	bh=gg3nV1iKgs4bbxPK/uru5pPDw51yAhWHVenuhfd8RSY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=E1hbJAEALqlb5yL56DaF3Qdv35CRbOZUjo41njnTAapQEJ0PfjTeAMJlktQn6zFocYAD5AcntSDzEzxG0egw/joVNiqqGP+s2PtjzedHUpp4kPCeNPoPiPCIlkzq6cGu7gK+PF8oeOV3JldOMHb+qdPl62rL7Yt8XyMFS58xoNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=U7Qof0wu; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 45E36403F1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1731337167; bh=GwVTmx4eIglWLWGHYmk31OoK5pzNvXaKVe73vYEWSTk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=U7Qof0wuVnJGcnP06ChHK+MJPNdREQXE7RLUzC2W70ULBaY9a9VnJ9vQEtqDAf9Ah
	 A3HwpVCu8PJVyEMghvrqu/hNDOC8sGYBt3mN173rM33gAFqU2dKpLTqp9ac4bjnapP
	 A1UN+AgpzI588tU7KIuantdLBUeWBgXdiFu11n7kGDH4ZxFGW1T97qYFC9t3FAzyYo
	 fgA7YQdK+SYmrHtsukzfx/wT5vFef/DoXSOK38XKAVdsxtI+fq2uPWuv8CV5NUKrxx
	 iQj4S70o2yK54j7jT8p8fewkBThJBXMBi2CZoLIkGaK5OJDLnfOOJSXDckk3X1rExZ
	 HhL9BYc+PyPqw==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 45E36403F1;
	Mon, 11 Nov 2024 14:59:27 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: anish kumar <yesanishhere@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jason
 Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>, Joerg
 Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Sagi Grimberg
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
 kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
In-Reply-To: <CABCoZhBVWY=aUQtQ5b=mF8hXqpgJw21_jAPf9YvEvdgPf_GALA@mail.gmail.com>
References: <cover.1730298502.git.leon@kernel.org>
 <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
 <87ttchwmde.fsf@trenco.lwn.net> <20241108200355.GC189042@unreal>
 <87h68hwkk8.fsf@trenco.lwn.net> <20241108202736.GD189042@unreal>
 <20241110104130.GA19265@unreal> <20241111063847.GB23992@lst.de>
 <CABCoZhBVWY=aUQtQ5b=mF8hXqpgJw21_jAPf9YvEvdgPf_GALA@mail.gmail.com>
Date: Mon, 11 Nov 2024 07:59:26 -0700
Message-ID: <87o72lu88h.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

anish kumar <yesanishhere@gmail.com> writes:

> On Sun, Nov 10, 2024 at 10:39=E2=80=AFPM Christoph Hellwig <hch@lst.de> w=
rote:
>>
>> On Sun, Nov 10, 2024 at 12:41:30PM +0200, Leon Romanovsky wrote:
>> > I tried this today and the output (HTML) in the new section looks
>> > so different from the rest of dma-api.rst that I lean to leave
>> > the current doc implementation as is.
>>
>> Yeah.  The whole DMA API documentation shows it's age and could use
>> a major revamp, but for now I'd prefer to stick to the way it is done.
>>
>> If we have any volunteers for bringing it up to standards I'd be glad
>> to help with input and review.
>
> Jonathan, if you agree, I can take this up?

I am happy to see help with the documentation, but agreement from the
authors and maintainers of the DMA-mapping documentation is rather more
important than agreement from me.

jon

