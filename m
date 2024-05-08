Return-Path: <kvm+bounces-16987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8338BF86B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 10:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 673B91F238E3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874DD45957;
	Wed,  8 May 2024 08:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="O051azcW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485A02C861
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 08:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715156594; cv=none; b=cc5CORwWQho/euhUp0Rw36ub3DFSfo14pkUMfyq4q4DAdvqFF0mXNacj7jRdvcYqdEBMpILNA68sPJiMLy1Geo0WI5DH+SEK5QmRsShChp6KBsZwU3eUwxU5ni1fHc2IDog1AmZ5lGbO8Fb6vGSfMvQm/cea/389JhwVVWZ68aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715156594; c=relaxed/simple;
	bh=L9G2zXTS16Mb+4am/gUrC3INgoVtn6qnR/OXIt3yAGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WsD2DQGpsAqsOeEvDwj2LmCqJs5CDvDMjefKjpgYEKR9I7reBy4+kMTSJcGWsexL1uXL/OzFbDHf+yr2OzVcXUoOtSXft0sQYM8RmE8M70OjNW3f8hLbOFv5TD8YvOkOm9wgaPN2fm85Gb7vyvbFUakejQix6GtS/t8kYUFjp2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=O051azcW; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a59c0d5423aso59577266b.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 01:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1715156591; x=1715761391; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xX8T7z7JX/d3uw4bZ2bZEEE/EwwDbdoePKTyocl8yug=;
        b=O051azcWeaUdieG5z6eGWGsCxpkth8aoKM7Uxqs31yUSx1RF57dkPOV4vdKxMp5/dy
         fsau1jvbVsPyEXRadd0Z/cGo70XACc/u5KEalTe9iMLz5YM0GJGTsygKzU5aKD2PConV
         NPMRZ2Q9gxEprU9MbE8FoGNLB1+a6OY0Pxf7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715156591; x=1715761391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xX8T7z7JX/d3uw4bZ2bZEEE/EwwDbdoePKTyocl8yug=;
        b=jIAFrpeM0xPfPBuISNaENTLjEj2R3qY/SVLxomq1WGkSwElYkzIgDhGtJjJuCdl/qF
         T0xwNXdx9Jo1HCms6pLj45wX7VucHkIZoHwcFw1UorChJ0F+ZTVknJrhPjAJDb0GdJe+
         ASMhPiBy2qlNQHDTzArZltd8at7wEbImvgFeFgZmxEJdS/XjUbJ1LRMPy8OwTpA1M/zl
         sbjKYXtGmZEEG4EPxL5yDpuPJEmneIQr676g5mqFiQ/qaICVRnsIhvZg13bNvMpefPQM
         Zck+OhykhyDh45isF0aJ9mfsjGHxkPb3QlEBkRSSJv9wwcoVleaKD/WtWk7Y4ejhwQK7
         4VZA==
X-Forwarded-Encrypted: i=1; AJvYcCWRAbTce74cKL4Bn+RQwaHO0Lgao5zYX7wCPplbX/oYNeAJnchLblEDwHicWuuzE+kqzMvN5KL89eAvW1JRGvTdqFLN
X-Gm-Message-State: AOJu0YzygbmlVVjYnYGKSE+IvEhRMlQwEpCprtt6FX5CErfYu7y/jgFH
	B8e3MTCrHFv2mzu9gQjUTpsyfVug7Vu0ZkL8bmAjk5R2QTjSHLosOr0nbEOVAYA=
X-Google-Smtp-Source: AGHT+IERZtXNeoCiRmo1mqas8Y/UQ6pzLyLJDXpgtWRZ1RzE0ZKKFqa1dMwitwttSdKyrV7CIRB1ew==
X-Received: by 2002:a17:906:f359:b0:a59:dbb0:ddcf with SMTP id a640c23a62f3a-a59fb6fba8fmr121830766b.0.1715156591554;
        Wed, 08 May 2024 01:23:11 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id g8-20020a1709067c4800b00a59a9cfec7esm5128792ejp.133.2024.05.08.01.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 01:23:11 -0700 (PDT)
Date: Wed, 8 May 2024 10:23:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 2/2] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <Zjs2bVVxBHEGUhF_@phenom.ffwll.local>
References: <20240422063602.3690124-1-vivek.kasireddy@intel.com>
 <20240422063602.3690124-3-vivek.kasireddy@intel.com>
 <20240430162450.711f4616.alex.williamson@redhat.com>
 <20240501125309.GB941030@nvidia.com>
 <IA0PR11MB718509BB8B56455710DB2033F8182@IA0PR11MB7185.namprd11.prod.outlook.com>
 <20240508003153.GC4650@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508003153.GC4650@nvidia.com>
X-Operating-System: Linux phenom 6.6.15-amd64 

On Tue, May 07, 2024 at 09:31:53PM -0300, Jason Gunthorpe wrote:
> On Thu, May 02, 2024 at 07:50:36AM +0000, Kasireddy, Vivek wrote:
> > Hi Jason,
> > 
> > > 
> > > On Tue, Apr 30, 2024 at 04:24:50PM -0600, Alex Williamson wrote:
> > > > > +static vm_fault_t vfio_pci_dma_buf_fault(struct vm_fault *vmf)
> > > > > +{
> > > > > +	struct vm_area_struct *vma = vmf->vma;
> > > > > +	struct vfio_pci_dma_buf *priv = vma->vm_private_data;
> > > > > +	pgoff_t pgoff = vmf->pgoff;
> > > > > +
> > > > > +	if (pgoff >= priv->nr_pages)
> > > > > +		return VM_FAULT_SIGBUS;
> > > > > +
> > > > > +	return vmf_insert_pfn(vma, vmf->address,
> > > > > +			      page_to_pfn(priv->pages[pgoff]));
> > > > > +}
> > > >
> > > > How does this prevent the MMIO space from being mmap'd when disabled
> > > at
> > > > the device?  How is the mmap revoked when the MMIO becomes disabled?
> > > > Is it part of the move protocol?
> > In this case, I think the importers that mmap'd the dmabuf need to be tracked
> > separately and their VMA PTEs need to be zapped when MMIO access is revoked.
> 
> Which, as we know, is quite hard.
> 
> > > Yes, we should not have a mmap handler for dmabuf. vfio memory must be
> > > mmapped in the normal way.
> > Although optional, I think most dmabuf exporters (drm ones) provide a mmap
> > handler. Otherwise, there is no easy way to provide CPU access (backup slow path)
> > to the dmabuf for the importer.
> 
> Here we should not, there is no reason since VFIO already provides a
> mmap mechanism itself. Anything using this API should just call the
> native VFIO function instead of trying to mmap the DMABUF. Yes, it
> will be inconvient for the scatterlist case you have, but the kernel
> side implementation is much easier ..

Just wanted to confirm that it's entirely legit to not implement dma-buf
mmap. Same for the in-kernel vmap functions. Especially for really funny
buffers like these it's just not a good idea, and the dma-buf interfaces
are intentionally "everything is optional".

Similarly you can (and should) reject and dma_buf_attach to devices where
p2p connectevity isn't there, or well really for any other reason that
makes stuff complicated and is out of scope for your use-case. It's better
to reject strictly and than accidentally support something really horrible
(we've been there).

The only real rule with all the interfaces is that when attach() worked,
then map must too (except when you're in OOM). Because at least for some
drivers/subsystems, that's how userspace figures out whether a buffer can
be shared.
-Sima
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

