Return-Path: <kvm+bounces-31283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8489C20C6
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBED9285F9F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F93921B453;
	Fri,  8 Nov 2024 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="aexEmqOU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A7B21B424
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731080330; cv=none; b=tEcyl7/jC9/qCZmE5TMcz1j8S+2mN1Sm8i++T/ofsOu1ovDWSeT8wDQy9GyqWNRXdzQHVZQKM+QAmqW7M7czh/00leIF/pM8aTcDjdXcR/S/8+Vf9vZgzsW7ubH5dV/FGdZWH1cQj4LDlrw63UJpEaD77y3cQPRPwnffqFJfNIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731080330; c=relaxed/simple;
	bh=OaBx3Fh/Km3ELqbio7v031NeuRfzJ9+4kTiWipNjW34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDT/TYddYnpiUsz+FE/ykWlkYRcra4SQAjUaPIQWVWsB6pCPWsszwxVTYADEKT5p4cdNx8WkXxClmPclNSiTHwod497QiISQiMSg5KRmOF49Zm4JoR9/+5Dle3LODNwA4cTHhTCmfc4iJ+3QgJzzRC3CWwR4C48bcZZp9ReaS0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=aexEmqOU; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7b1474b1377so148271585a.2
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 07:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1731080328; x=1731685128; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7sMW5Kuv5sIzIjhBbBygI9fJdJpSk6eqM7+xgs0I9dY=;
        b=aexEmqOUtoWo0nIxpp53mWmhgcdamtlMoWnc7v23Dq2R4nF+XhtjhKeEQukniU5tde
         Vce5KIwE2ZP9zCpfoy/YAiCAgwmM+QhLn3FHxZhCVqcMcnaWCLkDNsKSdaR7TEYQYQny
         I7V8/zeoQnhPgNDMziuf1jeRFibRMTmxh1Jfgd73c+9VMrzfs8b59x9r8L0WM1bTzHZG
         X4YyruWQtaCHeiW6iXjx8oFUyTMzlhRe6kIpwqDXRLz/HFKrM3zjhj7yegME3+gB8JUw
         w3XqR9e5cqtLx9oPgONMCEZKywjVgwCbdxTX4YQWSbGgXCYWTAg8upYA74ViTR7IznHA
         v2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731080328; x=1731685128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sMW5Kuv5sIzIjhBbBygI9fJdJpSk6eqM7+xgs0I9dY=;
        b=wgnd72C3/Bj90OszO4F0PFIMMpUK9DiGoBk33L+zAKFd6OSLO74GKnqun95RCyLQuk
         /CCQnIm5gbLQrHR5SbBCxAV687jXaYioViF8NE+fE+uTtOSbKB5NI8DM8Ulgb+8ZRxuA
         g4t1KoogZ7JRH6qDv3vxLP4rWKDCSj0Cs4PEou/bB+HHhB0y2XzpunWkhhJnRSpztRNv
         yg+O+cRaAOvrYsNsLlzA6VgRmCCrXuttBWYpEEfp+QzFFeQgnj1kdGM2ozBUSivegbht
         Ke3Ss19L1v2MLWVy61M6q6Zgje1rOhFVzXicmVLbeIskJeCIJdCe0FuvSyynS9ihh0Np
         MZ0g==
X-Forwarded-Encrypted: i=1; AJvYcCW8QACIJYCKjzOp7nmo6HdXUlGIDwKHDdZJtDmLsaC0aGP2RxlucMr6h3u0QGbBT2CLghk=@vger.kernel.org
X-Gm-Message-State: AOJu0YypHCRd2ZUyEe1e0T1Wgf+W1VAdJmNyFNHasTVzCrMF6+u/HQEl
	p9N3bXvD79Xat3AscAl2RTTvpvNmGQ+qN/dqkahDN8qfUPbfjF902JskK1jnuTA=
X-Google-Smtp-Source: AGHT+IHfTg/iLCK5GxrqZ9aoCzAZ7JH1FinF3HAR4KRwwnugOPp1CtA3KrYQyOs3W/lc98NgBjpBFQ==
X-Received: by 2002:a05:620a:1a21:b0:7ac:bb00:cd42 with SMTP id af79cd13be357-7b331dd2d55mr406755285a.27.1731080327649;
        Fri, 08 Nov 2024 07:38:47 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b32ac2dd1fsm170869085a.15.2024.11.08.07.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 07:38:47 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1t9R4Q-00000002a9N-29Xq;
	Fri, 08 Nov 2024 11:38:46 -0400
Date: Fri, 8 Nov 2024 11:38:46 -0400
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
Message-ID: <20241108153846.GO35848@ziepe.ca>
References: <3567312e-5942-4037-93dc-587f25f0778c@arm.com>
 <20241104095831.GA28751@lst.de>
 <20241105195357.GI35848@ziepe.ca>
 <20241107083256.GA9071@lst.de>
 <20241107132808.GK35848@ziepe.ca>
 <20241107135025.GA14996@lst.de>
 <20241108150226.GM35848@ziepe.ca>
 <20241108150500.GA10102@lst.de>
 <20241108152537.GN35848@ziepe.ca>
 <20241108152956.GA12130@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108152956.GA12130@lst.de>

On Fri, Nov 08, 2024 at 04:29:56PM +0100, Christoph Hellwig wrote:
> On Fri, Nov 08, 2024 at 11:25:37AM -0400, Jason Gunthorpe wrote:
> > I'm asking how it will work if you change the struct page argument to
> > physical, because today dma_direct_map_page() has:
> > 
> > 		if (is_pci_p2pdma_page(page))
> > 			return DMA_MAPPING_ERROR;
> > 
> > Which is exactly the sorts of things I'm looking at when when I say to
> > get rid of struct page.
> 
> It will have to look up the page from the physical address obviously.
> But at least only in the error path.

I'm thinking we can largely avoid searching on physical, or at least
we can optimize this so there is only one search on physical at the
start of the DMA mapping. (since we are now saying all pages are the
same type)

> > What I'm thinking about is replacing code like the above with something like:
> > 
> > 		if (p2p_provider)
> > 			return DMA_MAPPING_ERROR;
> > 
> > And the caller is the one that would have done is_pci_p2pdma_page()
> > and either passes p2p_provider=NULL or page->pgmap->p2p_provider.
> 
> And where do you get that one from?

Which one?

The caller must know the p2p properties of what it is doing because it
is driving all the P2P logic around what APIs to call.

Either because it is already working with struct page and gets it out
of the pgmap.

Or it is working with non-struct page memory and has a (MMIO address,
p2p_provider) tuple that it got from the original driver that gave it
the MMIO address.

Or it really does have a naked phys_addr_t and it did the search on
physical, but only once.

Jason

