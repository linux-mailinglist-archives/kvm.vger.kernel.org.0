Return-Path: <kvm+bounces-31325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CD19C2655
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 21:13:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C86BD1F21D48
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81051F26C3;
	Fri,  8 Nov 2024 20:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="SGj7NgT5"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565641C1F0E;
	Fri,  8 Nov 2024 20:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731096810; cv=none; b=MVcWI0cZIV0J1Lce4ToC2TrWtIJjcFARp/SBVM8ME1gz0cB8/7Sh92gxQ1Kb55Ye3rNPtrxWzWOk3c3X0kgWwBAJZ4KiQW7uBDW/PrDA1EIqjpgAKxLKx285ee1yfk0sCcqumekyfuqb2gjuvbEiyKSWVuJn8nNopRqhB8t5Q/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731096810; c=relaxed/simple;
	bh=Mjx2T+tJQq8AXBQuf6hhh98vDiAkZyRq4BVYSn8ScZU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fXWffeO2xhytDaaOLFURsGNGxLe9ca4tma0AAUYfX4fmplnzwylmAIykS0tyaYZvZwWQzH18jSaw4S8XUxLGx19628GgipJptSPPMxGfx1P5BWZh+qLMoO36rgZ3cvCUj6fA6BBBbT2VG/0BVXcuGSUE4K01+agESzEAEnk+st0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=SGj7NgT5; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 5DC3F42C17
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1731096808; bh=SdL8Q8EQQQJJ8xM8160z/ZDZmIkZmULZbC6xpHvhB2g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=SGj7NgT5pCq9qMZMXNJKG2UgQ/lP9zZE4YbKvUXqgPrUznXNr6/HcfYciET1a180c
	 4CQEBIeK0nih1ZtSbGeYgYPx/hYb6yPDREd8OyH5nekdazyQhbd0FntwwvCDHijkAQ
	 AiRe9/OS3QLp/eLystk6jgqxf76GfzScZi/3peY4z6raTJ/W27faMyuX0o0Qblo8bn
	 kulpZfzb4/cWAHAGIm0JQYi2CeCfIdC74UulY5RY8yhiiQV9VTsz3uVWHk/HuMjiz7
	 crwtMtMpBsv4BAZjxgb2arxdBkDSSgw/l0R41+5urv/u4+CiW8A60jFzuPQy7tWs5l
	 BT3AAiFW7pn8Q==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 5DC3F42C17;
	Fri,  8 Nov 2024 20:13:28 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Leon Romanovsky <leon@kernel.org>
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
 kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
In-Reply-To: <20241108200355.GC189042@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
 <87ttchwmde.fsf@trenco.lwn.net> <20241108200355.GC189042@unreal>
Date: Fri, 08 Nov 2024 13:13:27 -0700
Message-ID: <87h68hwkk8.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Leon Romanovsky <leon@kernel.org> writes:

>> So, I see that you have nice kernel-doc comments for these; why not just
>> pull them in here with a kernel-doc directive rather than duplicating
>> the information?
>
> Can I you please point me to commit/lore link/documentation with example
> of such directive and I will do it?

Documentation/doc-guide/kernel-doc.rst has all the information you need.
It could be as simple as replacing your inline descriptions with:

  .. kernel-doc:: drivers/iommu/dma-iommu.c
     :export:

That will pull in documentation for other, unrelated functions, though;
assuming you don't want those, something like:

  .. kernel-doc:: drivers/iommu/dma-iommu.c
     :identifiers: dma_iova_try_alloc dma_iova_free ...

Then do a docs build and see the nice results you get :)

Thanks,

jon

