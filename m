Return-Path: <kvm+bounces-68531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 828A9D3B594
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 19:23:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 406063009D67
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F66274B5C;
	Mon, 19 Jan 2026 18:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kODgE/7I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76D1327C08;
	Mon, 19 Jan 2026 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768846986; cv=none; b=m5pZGptnFxU/+JXqU0kMlFY+mV77jtuWv/qyA+Vc77e4Qv8hf6wGe3ILhjscJ/H8teXr/LndlRHA1F3btZZYyPdgkWHR5d42JoqELaZqcIcMHqXF6clRjtvQ3PENT3ojAbtlhrZNu1TtjsgCZ8xzpODMVR0zsDIhuyr1xKqUm94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768846986; c=relaxed/simple;
	bh=Lii9Wo3zMBgNZu8BfSOY2bf+6SIZLbGpUqMsnL7Mo1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLicmvxJj9QjXPXJPoOCVfdgTdMo9VaUflCIvfAlXpXBo+lgTdmIy+Ownhw5McaTmXdlUEd2bs1Tm1vxLt83vBIe+Us3WKO0n1l/e9eQBhC+FkSgXt6Do5yOlwKVWqP6oQNwMYouvGB3Vr1e+lhJAqsdEO0ZI+5Mx9wke1MxBV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kODgE/7I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104A7C116C6;
	Mon, 19 Jan 2026 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768846985;
	bh=Lii9Wo3zMBgNZu8BfSOY2bf+6SIZLbGpUqMsnL7Mo1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kODgE/7I98Q5Jmc8h+EJtQ/PsgbfKxiuG7+i/OKTqySamVeiXJ1ev5n9Tu8e8+7Am
	 eWcBTByTaCuS0pN4zKkZls5MedNPAn4I+Hsbq1SmcbRlCuZl8IS6k6KUcZhOQ5cwPq
	 QEvQx8PMi6vRf/Cyws5p8kXrMKU7fcqSObgUcH6YasVT8Do8FUt//3CHGrsQYSZI57
	 JjtDLmYAxiJIjWc5xqiuIHK7ya1LGuV3tOBOZ43uv2pzg/gzqVH+Fg7JPomEkrSv71
	 pD+WzkHxHEeR8S/rk6YdY1H6mMFPgde202sJs+pg6vR5YElq7bO8BTz55Zfg/qynqM
	 P7D/uGSD1I3oQ==
Date: Mon, 19 Jan 2026 20:23:00 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] iommufd: Require DMABUF revoke semantics
Message-ID: <20260119182300.GO13201@unreal>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-3-a03bb27c0875@nvidia.com>
 <20260119165951.GI961572@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260119165951.GI961572@ziepe.ca>

On Mon, Jan 19, 2026 at 12:59:51PM -0400, Jason Gunthorpe wrote:
> On Sun, Jan 18, 2026 at 02:08:47PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > IOMMUFD does not support page fault handling, and after a call to
> > .invalidate_mappings() all mappings become invalid. Ensure that
> > the IOMMUFD DMABUF importer is bound to a revoke‑aware DMABUF exporter
> > (for example, VFIO).
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/iommu/iommufd/pages.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
> > index 76f900fa1687..a5eb2bc4ef48 100644
> > --- a/drivers/iommu/iommufd/pages.c
> > +++ b/drivers/iommu/iommufd/pages.c
> > @@ -1501,16 +1501,22 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
> >  		mutex_unlock(&pages->mutex);
> >  	}
> >  
> > -	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> > +	rc = dma_buf_pin(attach);
> >  	if (rc)
> >  		goto err_detach;
> >  
> > +	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> > +	if (rc)
> > +		goto err_unpin;
> > +
> >  	dma_resv_unlock(dmabuf->resv);
> >  
> >  	/* On success iopt_release_pages() will detach and put the dmabuf. */
> >  	pages->dmabuf.attach = attach;
> >  	return 0;
> 
> Don't we need an explicit unpin after unmapping?

Yes, but this patch is going to be dropped in v3 because of this
suggestion.
https://lore.kernel.org/all/a397ff1e-615f-4873-98a9-940f9c16f85c@amd.com

Thanks


> 
> Jason

