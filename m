Return-Path: <kvm+bounces-63750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B135C7110E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 21:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AA88B347032
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 20:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8342D979B;
	Wed, 19 Nov 2025 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlv5a0X0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C1B1DE4CD;
	Wed, 19 Nov 2025 20:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763585146; cv=none; b=nguCEI8d0P0FNGn69GxiRwBsyZStbeB/dmgIWLMFkJCrcPhTgXyaS8toMe+bkAgV2HPiowfsEEKrVuAPunL2tUDmlwIV+TYGDUb24jFEIAq7vIx4EDPfsWALQ6PpayXBEtfwB+ldzMWI+nRGzV2R5ER+rjK+JqQh6uczYIUhVvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763585146; c=relaxed/simple;
	bh=5rI8lrrVbFn1InvbQielmCucdPk01bWsAxmwyIxRJJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJuSyct+GPCygQk9Zw98w/rjga6nd4WpXX01vrfL0EG2EmHE6o7proW66pZeAB6TdltHHc/EDflieot5dAVXiJM3rmqFzrFmfH4INC2eQZan8StqfBlSzURmKC3lFKiFnWheXWE9cC3LhidW/22NRHSDH2daT+2l3YSD+tGizT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlv5a0X0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F3FC4CEF5;
	Wed, 19 Nov 2025 20:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763585145;
	bh=5rI8lrrVbFn1InvbQielmCucdPk01bWsAxmwyIxRJJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qlv5a0X0ngRKyFh2JKVmpc2TkyYK/DU2m5BSvUPEl7BnF5Z4h3h/m+RqO7z1bx61m
	 rbyyfMoS9aqKBh0aUmaaII2BVk6WpQkAzGGpg1rUG+s8HZmAW8WSgoYrh4VjU5XyVE
	 cn3LgrCO1dpfJBw5cCJ/USdlN3JLkb+DpB22klLCEqHAbG4qjTuayYPjr+pzzDi4EO
	 R0Qx5aJ2BOOXu+TPpbSpmwtVpBrFTUylK5laErKZm5ellYru+TJRCMyV7sgWpV4Qxc
	 Y4Mw7ZQsZniCIYFf6yWIotwra9fYcCXVMUXRBjbCK8S0k+X0tqBTMuTL7f8E/JttUG
	 kQjOcbKaf5FSw==
Date: Wed, 19 Nov 2025 22:45:41 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
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
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251119204541.GN18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-5-fd9aa5df478f@nvidia.com>
 <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
 <20251119133529.GL17968@ziepe.ca>
 <ad36ef4e-a485-4bbf-aaa9-67cd517ca018@amd.com>
 <20251119194506.GS17968@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251119194506.GS17968@ziepe.ca>

On Wed, Nov 19, 2025 at 03:45:06PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 19, 2025 at 03:06:18PM +0100, Christian König wrote:
> > On 11/19/25 14:35, Jason Gunthorpe wrote:
> > > On Wed, Nov 19, 2025 at 10:18:08AM +0100, Christian König wrote:
> > >>> +As this is not well-defined or well-supported in real HW the kernel defaults to
> > >>> +blocking such routing. There is an allow list to allow detecting known-good HW,
> > >>> +in which case P2P between any two PCIe devices will be permitted.

<...>

> > The documentation makes it sound like DMA-buf is limited to not
> > using struct pages and direct I/O, but that is not true.
> 
> Okay, I see what you mean, the intention was to be very strong and say
> if you are not using struct pages then you must using DMABUF or
> something like it to control lifetime. Not to say that was the only
> way how DMABUF can be used.
> 
> Leon let's try to clarify that a bit more

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 32e9b691508b..280673b50350 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -156,7 +156,8 @@ Usage With DMABUF
 =================
 
 DMABUF provides an alternative to the above struct page-based
-client/provider/orchestrator system. In this mode the exporting driver will wrap
+client/provider/orchestrator system and should be used when struct page
+doesn't exist. In this mode the exporting driver will wrap
 some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
 
 Userspace can then pass the FD to an importing driver which will ask the


> 
> Jason

