Return-Path: <kvm+bounces-31277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D26989C1FED
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 812131F2491A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FF81F585B;
	Fri,  8 Nov 2024 15:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Gzo8EmuD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42C51E3772
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731078152; cv=none; b=QxcMPWzu4LeqCmGbH0P/EgacsgqJmvksVNoydoS12xzR170SnMxD77sBji6YALdhpYQJ0iFe4g1scChml6MqMNaguD5BmpIWx6T4W3YEMkWk4v+2TvkJU3fALYUZEZa7sKQN/gzoV5pUbWFdnTmUlU8XgTATveWSIVGoGfkFHos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731078152; c=relaxed/simple;
	bh=IxhOLucIOyD3NJcUrGUU7C5jfdypTBHb2lCNw7COT0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aD0BBVMkvFH4cCxdCHv7uZ9dwxP0zV0ifULusM61fLB4lR3JLcMijNJo5Q0FnYji5gDKAcREEb8brtqvLHSiMdTjJa05QqNh+1lT1mlypkULfxNTG3Mjb0E7A2NvstbQr+IxAYc1PRdbMyYhpcrEobJP1FcKdtzSB835UGLLNuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Gzo8EmuD; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-460c316fc37so13719801cf.0
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 07:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1731078150; x=1731682950; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hubkZwx3K6QSYt4MPDN5HJUCdcIscdXdSF4J6blze28=;
        b=Gzo8EmuD5bmXgwC24UxZMao0oAmQw8DA9LdIAfBYofFdCjGSy3l7mo8cjM57VvytrS
         pzd8CBdlunVBoDWbiiqDwhre3b8Rma7b9T1inYm5PJENo0dwJMCPS1CLWolrwhrFdyuN
         gt+6VCSPZb2kqCcOAaAUgyayDL3lDyoIa8z5Tm5jkSD2dDLO3p5zuzIGfn/MaGf7nw94
         OwMF5rT4/G6y3jF7FNndQLuVjn6ilaMH/a7RHfljrxO3loMGgDH8HgdcTwwXSaU0hChN
         85FwBqX4zrixJlu9fk6PHalyy1IkEwMq/bkfdAaD4Y4vGm8AtfDJNKlaYX7PospJr9FE
         +XPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731078150; x=1731682950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hubkZwx3K6QSYt4MPDN5HJUCdcIscdXdSF4J6blze28=;
        b=sazDB3LnxA87xx6SfLa+qFApqJgAqKaptVYfoOpVHEQTGsb0z1RssbTaIbFXEmNPGZ
         cFfQovkVAHHVcfG2FNffhafuC5r91m+A7yOe+JLmeTAD/Vr5UYeFcVPq9Baigajbc5TE
         WXleGTfAJQaqfgXd68nuDTkx+C6TxSRSVPF3NHczdN63wg5wNKQ7wRtdBY1ylVm72huV
         rV3633h1u9OipbqTRASoJq1EP9XCojKKCLOHBIcvZOiZ4T7udxmV03bCICbeglxNmFY3
         FqYMm3b/SvOHMGEeezKVDnZWosSCZC1ItFoN1Fb4oC5pCvI03lL/5HhTHw7GWIJKoxLP
         PZSw==
X-Forwarded-Encrypted: i=1; AJvYcCX/gAJ5zO/iHiax6AOxR+r5tMUGnZY32ag41x0wV1Ld95bukYNLCUYx8rdS2Tk8w9EKsx4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu0QpND1FGMGGQ/G2oVkpTXajn0ygUGvrC936pH70qg9D1uoJe
	POEGYgrz6os6Mt70lEfzh3tvwKIuhE5gxaMEAvpYIvVlREf889968ipDVpDptyg=
X-Google-Smtp-Source: AGHT+IHrKrTFhKn6qkYBk/Mpkl+n+kU6F5VUVqIGxdFUtkBdvXhYcgcHiG/stLr7VzGEyxS593kC3g==
X-Received: by 2002:a05:622a:1a92:b0:461:17e6:27af with SMTP id d75a77b69052e-463093698f2mr35032151cf.28.1731078149644;
        Fri, 08 Nov 2024 07:02:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ff3df53fsm21177001cf.8.2024.11.08.07.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 07:02:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1t9QVG-00000002ZlF-2kIP;
	Fri, 08 Nov 2024 11:02:26 -0400
Date: Fri, 8 Nov 2024 11:02:26 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>, Leon Romanovsky <leon@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
	Thomas.Hellstrom@linux.intel.com, brian.welty@intel.com,
	himal.prasad.ghimiray@intel.com, krishnaiah.bommu@intel.com,
	niranjana.vishwanathapura@intel.com
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241108150226.GM35848@ziepe.ca>
References: <cover.1730298502.git.leon@kernel.org>
 <3567312e-5942-4037-93dc-587f25f0778c@arm.com>
 <20241104095831.GA28751@lst.de>
 <20241105195357.GI35848@ziepe.ca>
 <20241107083256.GA9071@lst.de>
 <20241107132808.GK35848@ziepe.ca>
 <20241107135025.GA14996@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107135025.GA14996@lst.de>

On Thu, Nov 07, 2024 at 02:50:25PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 07, 2024 at 09:28:08AM -0400, Jason Gunthorpe wrote:
> > Once we are freed from scatterlist we can explore a design that would
> > pass the P2P routing information directly. For instance imagine
> > something like:
> > 
> >    dma_map_p2p(dev, phys, p2p_provider);
> > 
> > Then dma_map_page(dev, page) could be something like
> > 
> >    if (is_pci_p2pdma_page(page))
> >       dev_map_p2p(dev, page_to_phys(page), page->pgmap->p2p_provider)
> 
> One thing that this series does is to move the P2P mapping decisions out
> of the low-level dma mapping helpers and into the caller (again) for
> the non-sg callers and moves the special switch based bus mapping into
> a routine that can be called directly.
> 
> Take a look at blk_rq_dma_map_iter_start, which now literally uses
> dma_map_page for the no-iommu, no-switch P2P case.  It also is a good
> use case for the proposed dma_map_phys.

It is fully OK? Can't dma_map_page() trigger swiotlb? It must not do
that for P2P. How does it know the difference if it just gets a phys?

Jason

