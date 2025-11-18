Return-Path: <kvm+bounces-63595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F3940C6B95A
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 21:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B142D361D79
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 20:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2994A2FB96A;
	Tue, 18 Nov 2025 20:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jQfDsn61"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675F22F5A09;
	Tue, 18 Nov 2025 20:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763497133; cv=none; b=PrcQYKssrnp0xvulveCyYeXju5TZSATElKZJVtAnFngskku1KB4I5yCRo67jAeFsDJH3Zq9j4sFnzCfksC+6B/W1kd9JOCB50tvPSEuPn24l95e0uH1gx/woB6btgfBsa+EDyXW6vV93hhjVAKRMbs54HwEVjy6O3VboXP4edek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763497133; c=relaxed/simple;
	bh=1gK/eOl0lFoJx/Qsgws6pSF6IokRCQEg1Ra5CF1IxTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DyAz4EJaMZTVcVlGGJXT/6+F/txgIqLpC1ZCNYwhnEU9DwE7kXmDCsJkJCDnU61Lt9zstkg9koojiD0cAanBHByamiCI1lSnj8zcguY/4RP1CIfDx+zppuIJpMXZqouZr1+QJVbY8PhFkBvtasPswJdnlT5DPefrgauuC0+ABTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jQfDsn61; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6C3C19423;
	Tue, 18 Nov 2025 20:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763497133;
	bh=1gK/eOl0lFoJx/Qsgws6pSF6IokRCQEg1Ra5CF1IxTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jQfDsn61vufo6YOfQo79y+Ndb5/49pM+Kzub8NVaHCny22FBzQnFTrSLg2XdPo1s4
	 q4Q7m4B585DTvH5HVWQ0DO/E2wa7u3fFCYB85WskqwPYKBTtnUrrPrWPRE5C2Ymwu9
	 XI6NikQcB+qyFCqrr5w+MjHt0GyCFcaWHiNnpAZuQe+VtouSDZ9qJ1I29igbCkZOyV
	 6JDMlf1DxIGJwl0KrKoWkLUy0geHXeEkVLKutwvuAT1n5/hnFBjFl+IVPa8640+D5j
	 uK0n9LGxWeIjzuFUFMy16vZC128qAY115S6xdY8r0buoE9dRHyEPS8qfYYbszF8xDd
	 vw0kkKc8fqFoQ==
Date: Tue, 18 Nov 2025 13:18:46 -0700
From: Keith Busch <kbusch@kernel.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <aRzUpmUkDy-qN5c1@kbusch-mbp>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
 <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Tue, Nov 18, 2025 at 07:18:36AM +0000, Tian, Kevin wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, November 11, 2025 5:58 PM
> > 
> > From: Leon Romanovsky <leonro@nvidia.com>
> 
> not required with only your own s-o-b

That's automatically appended when the sender and signer don't match.
It's not uncommon for developers to send from a kernel.org email but
sign off with a corporate account, or the other way around.

