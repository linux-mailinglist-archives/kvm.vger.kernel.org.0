Return-Path: <kvm+bounces-63752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A58C71186
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 21:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C2A5934C5E5
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 20:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BAB033A701;
	Wed, 19 Nov 2025 20:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIjVDXdy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C646372AA0;
	Wed, 19 Nov 2025 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763585665; cv=none; b=GC5Xr6Tot1rI3sGBOxLxJRtImgKEUw5fEm5lwPoMksWI5XeQPLBRQT48Q5h/SKtIriEu4240LZ1ft+I2b4bJes/UWhDAbovyJsNh7d1q2TOSe9o7eDH0oeYUAYbbrxIC2iSw7hKFj3OxqyowsnHB0KWcSMEMP4HrLC0zZq+eUV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763585665; c=relaxed/simple;
	bh=mwbqNvwrxL30F0hMKoNOTqnADhQUlj+4wIXlkWHn4Hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWbGNHPPWV/new0isFseSmfBecPVX4dJUxByXKMhhEhZ2ll8TERC1KryY1dSPLrasvThTSJ5co7zSY2MVTsAM5nUw+tIERZYfvQ5KH6LHFOUA0lMQqPprGlyKPBriMrqtO2x5r9nxZ5iWWG7cCD9bxrKFA5C0JbLBb5JhPeWDjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIjVDXdy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01C5C116C6;
	Wed, 19 Nov 2025 20:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763585664;
	bh=mwbqNvwrxL30F0hMKoNOTqnADhQUlj+4wIXlkWHn4Hs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIjVDXdygEdThL6V5YLCW0xD9Bt9YdcnAcPcnfKFzoBPmHe9+VFePoeh5FMXypqGq
	 V+S+LcEu8/NG3zTr4t6hmJUDNKfHgpg/5fKTjiz9WLK0hEzuCyuIhBVoCD4x4HGrUR
	 PKeUcvq5/isvXCO/hBigGUthi/F5yOtPdPUa5qTDD1B7rl5YtLMNm+5eCtnIx/tYkK
	 azw8wd+f0pUiG5a3AU2PQZjKxBRPnRZSceZC56Fjq2xd1k9ZVCcY0CJsQX1cbjmlTN
	 ZYssUYKWJAULk3czXXwVxGWnbZ5TaxSbT8lqrNnJ8A9uIgw3EwVlIC7JZfCZdOkKHp
	 VrP+1F9ywf3WQ==
Date: Wed, 19 Nov 2025 22:54:21 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119205421.GP18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251119193114.GP17968@ziepe.ca>

On Wed, Nov 19, 2025 at 03:31:14PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:

<...>

> So thanks, we can take the Acked-by and progress here. Interested
> parties can pick it up from this point when time allows.

Christian,

Can you please provide explicit Acked-by?

Thanks

