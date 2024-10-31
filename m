Return-Path: <kvm+bounces-30250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1149B84CB
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF49FB22EAB
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FC91CDFAC;
	Thu, 31 Oct 2024 20:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KQItnnFo"
X-Original-To: kvm@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5211CC8B3;
	Thu, 31 Oct 2024 20:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730408345; cv=none; b=KWb0lFl/sfnAU+kaeKm8eBZ/JPrnFaBY3ccbB+R/86o+TqbSuZLFn6fO6o2844mfjmUahm6ocn9MfcWIchpfBLthB0rdlW4M7fc0kz9VJbfRzZvth5/59WrRh9Hj3IIFimun2+xLg4Hr76lLuQnxWzol42CWX0qg4zsBZvZeZeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730408345; c=relaxed/simple;
	bh=7mUD4I9cbXdRGvKvEga1xf/cghvf/DMenSSv8W2QQ60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BXk+IyXYWv9JF3tSr5CF45eAPV9wkAETUGbAdPGy++7cY3yjIgYUUMG/CfyQNIzF6e5ZARXE2P2AbbbxRqLu3vkp6zQyLEfIS8VFHmCQHWxssqTDB2hH70YCDmb83zp+DgD1G4XcB+/9VKkPY1hsCxP6oCblTIixDNA96KqRwE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KQItnnFo; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XfbvQ5NP0zlgMVV;
	Thu, 31 Oct 2024 20:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730408329; x=1733000330; bh=ZlDdWjIwcF/8pUBLz0z5Lqqx
	Mf6+H+v/mtLue+A0j/A=; b=KQItnnFo7mG7FWlSn3t8mhT5t9clJf67jiW5lKnA
	ZppzqrwKZgP8zNGovmxHxm4CgKw1QIgMkZL2m/uWgA9EFnGppkBxNloFeY2nBD1s
	ZZ07cMTdtM3ysyJ9elPwZuRYvrT0OrA/gN1i6yMy2myCM+hqyS+zYZ+UjaGfu7R2
	fngVCGsv9pCcGdCAX0ZD8Ou0QW/I9uJWEEMJX7Iy7N4DsjR03B2mVlP4fjVQ0dvh
	UJP2d9IJ4Ng9+UjXBh5e2JDMfcPA0PjQLHmFQzdvAtVj63xiEvvV2PLxyQOlpYxj
	pR/9i5KIYfJjjDVF135v4xvdMr5gQhkX72qeykrLw4SqHQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fkPnSCZ1Z4-b; Thu, 31 Oct 2024 20:58:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xfbv36gp4zlgTWK;
	Thu, 31 Oct 2024 20:58:39 +0000 (UTC)
Message-ID: <d4378502-6bc2-4064-8c35-191738105406@acm.org>
Date: Thu, 31 Oct 2024 13:58:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/7] block: don't merge different kinds of P2P
 transfers in a single bio
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
 <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/24 7:21 AM, Leon Romanovsky wrote:
> +		/*
> +		 * When doing ZONE_DEVICE-based P2P transfers, all pages in a
> +		 * bio must be P2P pages from the same device.
> +		 */
> +		if ((bio->bi_opf & REQ_P2PDMA) &&
> +		    !zone_device_pages_have_same_pgmap(bv->bv_page, page))
> +			return 0;

It's probably too late to change the "zone_device_" prefix into
something that cannot be confused with a reference to zoned block
devices?

Thanks,

Bart.


