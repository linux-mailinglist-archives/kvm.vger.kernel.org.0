Return-Path: <kvm+bounces-30249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A18309B84B8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D326E1C223AC
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5B31CF7D8;
	Thu, 31 Oct 2024 20:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZtIOVQTD"
X-Original-To: kvm@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63141CC8B3;
	Thu, 31 Oct 2024 20:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730408146; cv=none; b=gM6KgDcvUG20Kd70L5smkXzgD1fYNJj1x4A5wkEVCoWf7isqpY3/Ek2KaDvVabcGvxBNWX6xkGvT5VwGJEPjEIuxmX9mmTxqxSRmVPGd0YpXRC0GwhvkmfDr/FW4IE4v+RtRNw8040pD9iNp+PK75rjjchaSMU7EGSarj5RGQ8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730408146; c=relaxed/simple;
	bh=Vx/GpNQjaPyOsXHD40m4L/SC/SsXyalg3igIGxAFPZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M2luBDeeXre3+YfyShK56TiSFgkfN3Pvq7BP7stCvyevqh8IkrAmznUULC9zeqs5tSy+BzffABhOqmZwACW/C1Ypyvi3QhFeF6bSl37AhVAOFF5CdADzxw8TaHdffCBaXgdh/SYX9kbvdHPkot4UD/A4vIbZnfJDYNhMLk4JHp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZtIOVQTD; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XfbqT6Dh1zlgMVS;
	Thu, 31 Oct 2024 20:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730408124; x=1733000125; bh=B/pEQTczTiq8UIkWg7TPO3VM
	Ag1G//4dSD/mob7u6xE=; b=ZtIOVQTDUxy4QOQyeqVfTWcwWtIKOOg1Jac03tiI
	A7rCqvb9vtKSHPFTp3wF/OdOCTXggfRQmjW1Xz2AyQuoNB4AiXSB6jL3uB70g+in
	79BqU7XO0OVtBFrfJD3PLeY1HqTIVPag3Az5jepT8ofoaTAMY/ewHawQhH4R+bvg
	NqlDCexeZlHL8u4+B7neARRpjrmuBRu8CaY9eoTp1+/XajADX9rfWmgbndjW9rLQ
	XuadQP3u1OUiJL6NnXZlZfO6UYtdFeZQhmbg7NR4i+B2vLIqZ50DBphSoU0yOLfj
	+sqOmryDNyCHXB3zQKpW/jPG+KIxEnZasIOEgmoiYq7Z1g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 27aSEBHRr0Fw; Thu, 31 Oct 2024 20:55:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xfbq63bYdzlgTWK;
	Thu, 31 Oct 2024 20:55:14 +0000 (UTC)
Message-ID: <4c7e679a-d3e6-4426-a679-ee581b5c728c@acm.org>
Date: Thu, 31 Oct 2024 13:55:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/7] block: share more code for bio addition helpers
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
References: <cover.1730037261.git.leon@kernel.org>
 <e6be9d87a3ca1a2f9c27bce73fbab559c21c765f.1730037261.git.leon@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e6be9d87a3ca1a2f9c27bce73fbab559c21c765f.1730037261.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/24 7:21 AM, Leon Romanovsky wrote:
> +static int bio_add_zone_append_page_int(struct bio *bio, struct page *page,
> +		unsigned int len, unsigned int offset, bool *same_page)
> +{
> +	struct block_device *bdev = bio->bi_bdev;
> +
> +	if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_ZONE_APPEND))
> +		return 0;
> +	if (WARN_ON_ONCE(!bdev_is_zoned(bdev)))
> +		return 0;
> +	return bio_add_hw_page(bdev_get_queue(bdev), bio, page, len, offset,
> +			bdev_max_zone_append_sectors(bdev), same_page);
> +}

Does "_int" stand for "_internal"? If so, please consider changing it
into "_impl". I think that will prevent that anyone confuses this suffix
with the "int" data type.

Thanks,

Bart.

