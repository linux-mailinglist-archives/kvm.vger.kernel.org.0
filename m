Return-Path: <kvm+bounces-41510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 297A8A6975C
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 19:03:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 411E94662F0
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2C720A5DF;
	Wed, 19 Mar 2025 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="JswssZao"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B963D20A5F7
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 17:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742407124; cv=none; b=iTxTqnK4L2mInHmP0UrJnm7KHjkUYMd1Qnw5zYzA1x9uRdICM69Ca37mu0mHPE5hKRD7D+yxEgmLk8UVySd49WfcmGbbeYwdMQj0TbycjPw10MNMaxlj1HWkXJMJ5iz9u4e2l6pFwUqkiHa3wpEwNzOeAUzm6lTza166KT4p+bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742407124; c=relaxed/simple;
	bh=O1aeb0KFlrkj4Yiw1nWYiPzizeq56+6Mn3GDJKk7WrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqSCf9xEfppRrlgkAIbht10ur8YDrOCIp9gQdzD7GnCTG4kwCWlyFhDRi1bW2asPsGAJhi9A7DbZ+gvcGZZ4Mufru+nl5J/f8NscXBwBFI3up8f3d5d8alFvTzvmOApqnY/kxeFZIbd9BVqfor21hQfGziHpmqSZcW6in6Yv9B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=JswssZao; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c597760323so241751485a.3
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 10:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1742407121; x=1743011921; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tk5ycb3N9meE73NCm46CD0AtZuFHAdivFMZfwt24RPU=;
        b=JswssZaoSvcGZ3Nb3HuBG6yTTepkbVvops9jz8GX0QPSsMZFW5TAmeqJyqUmyrXh5e
         9yd0D5+xit2h+NbfDPGcgydDHXSJ2ZawWNZlNKWiPsbscwgJO3I/D/ccaEd6sXaQefXL
         P8IaxLiPCwfg4vuJ9yijo8Qifjg8jhUnuqW3o6y37oeE1UjF0yLhoJ0ffNsqWWhVLzbx
         03eQ6VGcXdRNbfKzRLeEWywvgzyxONJ2hS86uSYluPzy0M0PxKuFPIYJfQH/xuM5OYQ5
         s5XDR6OMjA+U7S70WxOERiIXTMPnvEsyw3TOvGC0iyLiroIrIpuMe5vEkwUAUWF5OZqs
         GzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742407121; x=1743011921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tk5ycb3N9meE73NCm46CD0AtZuFHAdivFMZfwt24RPU=;
        b=vVlyDTEeiIZSDwjGC7dKpVGjVJHC75lrpqQEhGZkEHj0k2aDOLuJU6euZH+ceQAswF
         3AvHaB/UkLjRw2JUe9nJKV1ZGPbvJstYa5gEppPNrR+j5CmcjhHiFfiaJcjWOUz8exlG
         6rIVZYEKstAT7kk5qd0Zr+mXeSEG67yileynmhl5V9GTVScWFea2l37ZGbZqKOFWZWqX
         UFOlkna6EN0+POSJdY9lCH8TuQaMsuIvnk+Y5D8GfmJzK3hk+nhAT0pgJelYhghTqt4a
         gCu9KzYUsUtq8M9glczEh041TgYrg3kPQa748/r6I1DI0AmRXE7X3DedmU2ICZDCelxK
         TSig==
X-Forwarded-Encrypted: i=1; AJvYcCVdzm94ceSTrLBa5O+L0l+KM9+6IFiaOaKD5SZTR0ztFUtLc3CRNhzQpxX8DpWIVqWt6vM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt0BdmQxGoZ1zOpqmdOBQZFGK/+ffQtMtDkvgJyJJsyVAxleXK
	7YWr0xTb1R7OUZ/wd/j8aA8q20FgmjLBrFwxlPCNdjvnm1mhHvgFOdUrYOzn9i0=
X-Gm-Gg: ASbGncttTk+OSDGpbNYga7QjOZQfCHm31W2AAZHNNv54P6GRZX+F/UHjKh2sK1CYBNe
	y3tJtb/Mk7v18NqNhsl4p2k4nXB72sY4FQQvvKhGCnP80BVnYORY+hWD4Z6BUE6koSBD7xCSUY3
	gsG+BiN5ma6Z6RSd+wrFczLOiJRdNozBYhnm1Nu9fiiuV7j/hBTYHGMf0QhsMDC/kTNtUWoqhTf
	J+cGuTKHFGRRD6Ra+RRPS+/GgEBagqJFBLRnzX0ycImJPZg0a6Dc08xmIt4qxVbdRqaxVXLSdkE
	T+wV9UxxDPAUXpGAL0gyjZsczgM/BTt8A5Xw9iWr5SQM8oib89XidJ1AeVmIpL+AgMbRNBP4BY3
	GNVkVR1SgYpPH0Mt6ew==
X-Google-Smtp-Source: AGHT+IH//pIx1EBbRFqDU6QPhXC6odo+Ppd2dshOt/mNgQMR0e3nRHsssO7Vo2UonDgQd/fB3+YCbw==
X-Received: by 2002:a05:620a:3189:b0:7c5:5154:cb2 with SMTP id af79cd13be357-7c5a839688cmr568357985a.15.1742407121681;
        Wed, 19 Mar 2025 10:58:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573d8a62asm885096585a.96.2025.03.19.10.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 10:58:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tuxge-00000000Wns-1mXJ;
	Wed, 19 Mar 2025 14:58:40 -0300
Date: Wed, 19 Mar 2025 14:58:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leon@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
Message-ID: <20250319175840.GG10600@ziepe.ca>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <CGME20250228195423eucas1p221736d964e9aeb1b055d3ee93a4d2648@eucas1p2.samsung.com>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
 <d408b1c7-eabf-4a1e-861c-b2ddf8bf9f0e@samsung.com>
 <20250312193249.GI1322339@unreal>
 <adb63b87-d8f2-4ae6-90c4-125bde41dc29@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adb63b87-d8f2-4ae6-90c4-125bde41dc29@samsung.com>

On Fri, Mar 14, 2025 at 11:52:58AM +0100, Marek Szyprowski wrote:

> > The only way to do so is to use dma_map_sg_attrs(), which relies on SG
> > (the one that we want to remove) to map P2P pages.
> 
> That's something I don't get yet. How P2P pages can be used with 
> dma_map_sg_attrs(), but not with dma_map_page_attrs()? Both operate 
> internally on struct page pointer.

It is a bit subtle, I ran in to this when exploring enabling proper
P2P for dma_map_resource() too.

The API signatures are:

dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
		size_t offset, size_t size, enum dma_data_direction dir,
		unsigned long attrs);
void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
		enum dma_data_direction dir, unsigned long attrs);

The thing to notice immediately is that the unmap path does not get
passed a struct page.

So, lets think about the flow when the iommu is turned on. 

For normal struct page memory:

 - dma_map_page_attrs() allocates some IOVA and returns it in the
   dma_addr_t and then maps the struct page to the iommu page table

 - dma_unmap_page_attrs() frees the IOVA from the given dma_addr_t
 
If we think about P2P now:

 - dma_map_page_attrs() can inspect the struct page and determine it
   is P2P. It computes a bus address which is not an IOVA, and does
   not transit through the IOMMU. No IOVA allocation is performed. the
   bus address is returned as the dma_addr_t

 - dma_unmap_page_attrs() ... is impossible. We just get this
   dma_addr_t that doesn't have enough information to tell anymore if
   the address is a P2P bus address or not, so we can't tell if we
   should unmap an iova from the dma_addr_t :\

The sg path fixes this because it introduced a new flag in the
scatterlist, SG_DMA_BUS_ADDRESS, that allows the sg map path to record
the information for the unmap path so it can do the right thing.

Leon's approach fixes this by putting an overarching transaction state
around the DMA operation so that map and unmap operations can look in
the state and determine if this is a P2P or non P2P map and then know
how to unmap.

For some background here, Christoph gave me this idea back at LSF/MM
in Vancouver (two years ago now). At the time I was looking at
replacing scatterlist and giving new DMA API ops to operate on a
"scatterlist v2" structure.

Christoph's vision was to make a performance DMA API path that could
be used to implement any scatterlist-like data structure very
efficiently without having to teach the DMA API about all sorts of 
scatterlist-like things.

Jason

