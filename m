Return-Path: <kvm+bounces-67764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F90CD136C6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3B934303DACA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6859E2C1589;
	Mon, 12 Jan 2026 14:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ja8gTeB5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858902BD035;
	Mon, 12 Jan 2026 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229242; cv=none; b=tW5fHrU1Rw+JWEyzmOXXatUWRKpcT8zwbzWxfdpS/AUpNGhNeBZv+aFDZybCyIg0nvyA3YpAM9kk/UfBExI0pI2HX4UFz6Onjl2yowZ5WlJ0XvlGfZ2KF9hv8pLiRHaGzl+bTjuPCe2qvKmwMerUf4mrBtny5fEnfJsKUagvchI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229242; c=relaxed/simple;
	bh=vBh5+7wjLDHMjWPyGtwhZ1my9Rro606jkpR3pcAw3YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JDDL5pxGYASYRTT0LtgmqJcJgpIbvqiJ7iFh58wldul1W7mNyNO6mKlILQz38NmKnDX6AxHPd3cU3Hp7iVcBy+P6gsIRafNDNNdgsZK244XsxuT3zjR56ZLo3RMXDmKgwuAwxAnEX8fXsNAXMUIExbhRe2o1RT8cgLzy+5pyF/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ja8gTeB5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CD3C16AAE;
	Mon, 12 Jan 2026 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229242;
	bh=vBh5+7wjLDHMjWPyGtwhZ1my9Rro606jkpR3pcAw3YI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ja8gTeB5MahdT23MVQBoYgJrO93p0hWyv5JUUGX3QoI1ZyxeX/ep04GYPubefUxwp
	 DMTeCAoAa1NUMi76WVlvlfE+etWgXgDk1LndNWRrIjc1aXJ4yKFCO1GeZMEdP0m/ss
	 AILsKaV4OzNnTChZErOf3yuzDXtWW46O3nFPP2zX8Ff+9jJtcDXRJUIaWqkcYwv4J/
	 uOZQiQOkE++PZ+zT3bjIPNUzaUwYARCc70pOwFp3BPEFVg6Bfm3lAPYIIMqUFGmpyV
	 9pqcSJ1cNiFX50QSWtbg0Jwatt7FBCV+NFw9WPxt2vlizh6kK1aGeeUlP6ItpIpjyh
	 p0nS0bUoEr/jA==
Date: Mon, 12 Jan 2026 16:47:16 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Williamson <alex@shazbot.org>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH 0/4] dma-buf: add revoke mechanism to invalidate shared
 buffers
Message-ID: <20260112144716.GA179508@unreal>
References: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
 <eed9fd4c-ca36-4f6a-af10-56d6e0997d8c@amd.com>
 <20260112121956.GE14378@unreal>
 <2db90323-9ddc-4408-9074-b44d9178bc68@amd.com>
 <20260112141440.GE745888@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260112141440.GE745888@ziepe.ca>

On Mon, Jan 12, 2026 at 10:14:40AM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 12, 2026 at 01:57:25PM +0100, Christian König wrote:
> > Clear NAK to that plan. This is not something DMA-buf should need to
> > deal with and as far as I can see is incompatible with the UAPI.
> 
> We had this discussion with Simona and you a while back and there was
> a pretty clear direction we needed to add a revoke to sit inbetween
> pin and move. I think Leon has no quite got the "dmabuf lingo" down
> right to explain this.
> 
>  https://lore.kernel.org/dri-devel/Z4Z4NKqVG2Vbv98Q@phenom.ffwll.local/

<...>

> It is not intended to be UAPI changing, and Leon is not trying to say
> that importers have to drop their attachment. The attachment just
> becomes permanently non-present.

Leon also ensures that no UAPI semantic changes are introduced here; the
existing interface is simply extended.

Thanks

> 
> Jason

