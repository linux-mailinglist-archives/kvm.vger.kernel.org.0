Return-Path: <kvm+bounces-21230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEEB92C3A0
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 21:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF4421C22894
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 19:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E415182A61;
	Tue,  9 Jul 2024 19:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="A6g2pnoa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0C81B86D8
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 19:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720551798; cv=none; b=KifyI0hHKuh++McMC5WI3NYH1bHTw1t1QBR1tjOH2bUtQ6G3rL2I9E+jESlNMTx1oNqTo5C0NHg8l/Bs/WxoQUa276dEh3sIm5G+iJq+A3NqGkAK8G58ktX3oa6+WaNvy8nrFLn5YbtvjDWFNx5zuYlLt+Pm15R3iz1hT6MmqEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720551798; c=relaxed/simple;
	bh=UmMx48wnc0FnxjTp1WjNlbVccTNxzM4x83j7igXR7TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3Y0xZF6bX7oc5oAvCJ9VRPB8tdoO62T1D/uywbCBldHgMrAN5HjbqBcZGIxCKn2nKGqrzKr5JZimtpnrZWTdvAdzqLYNeP+CgXZ6HSu2n+LiOOaLXcZ95PrJcrPEzsVqNcTjfSFWak/vtmXuCIJ6ppQFe5US7xvs/eiYoMrySE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=A6g2pnoa; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6b5eb69e04cso33242466d6.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 12:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1720551796; x=1721156596; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tz4SKanGT0p7B5kijsG/hyAEtWawoOPO2+O2oyG1KXg=;
        b=A6g2pnoaWkIIc0CimeecaG6mN13v3n+vMZWH1a2eisPl7oElZ5j8RpC7cpUSns7z7E
         SaXhh3hjwvo58JADJ4Lw0s/jnqxlC0BzTQIPpK7tnTw3bVo/e3D+fRbRqyUbjlLnjChe
         VcL/iF5vlClZpPkk1kOVxFIVZXTJH4WsBu1HbMB3pT8UgIlpcPiRTcjlKhpPxR7637Fk
         DRUQkMUNORI+3EPdhjl+QzUQN9nItiNZ6HEzDLm0u+TDbYIPjlW+C8lfjk3FVZ8v7AWW
         V8oJikbmctWxcgEg3nIGGAnSdH/wLtsUGiM83M8YX4/0gceq+z/kwqBSB9Rw6gHC0ZcK
         NqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720551796; x=1721156596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tz4SKanGT0p7B5kijsG/hyAEtWawoOPO2+O2oyG1KXg=;
        b=KaX0lhBMlMENIH2oS0JKGfjESHQ+9nU67K+vlPFsO9WEZU/m1d09lv+EiQEcGbwJDd
         juTU+NuisBp4N5DA/pgMV4KbScQL1jPHrY/fSJAdFYGIIMpAyT0ZUSa5B09PZcimaLHA
         OknDSBSVcgiq6l+X/KVqDMlu58+lZcrBclhCECxVIwn3vEFfyga3dvoMOhvxdsvy2Grc
         wwbkam3wYEgspJWqxaqPIR21JGswcuhUJd120RsZxCu/eLjIRpTqtGdh1rGmemIj3fGd
         68kCMc5M4fPlWONmn1gqkAZrh8wiUmb/KUAo9S/oTMpZVqzVJHvfdEkGhYxBx0UTP5Bn
         emeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVg7XB62LSf3WmjXKJ2VO3IeLEeI5eqfFp9g3AV3VJrlwwbZuNYyK76Xjvv5C6V85hNhyXCojSrtFSbO12ocnGPO6eO
X-Gm-Message-State: AOJu0YxL6uWBOIk4xzVzOuPM68SinU3Mf+r4/zs1eFBrl4FKioBkVWfW
	kvblgr/SgW2wNdBpaTts8lUF48faW08Fdtn94Mu8Eq6C7LpHZGznSllzqE0BInc=
X-Google-Smtp-Source: AGHT+IFhetxp9iNMwbY2wmkBlgDvT9+MA6GFJVeq9xE0noHusNzmV7TqInccd4H71Z7ysufi1Iri/Q==
X-Received: by 2002:a05:6214:1cc2:b0:6b5:52da:46f2 with SMTP id 6a1803df08f44-6b61bc80504mr38822486d6.6.1720551795800;
        Tue, 09 Jul 2024 12:03:15 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.90])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b61ba797c0sm11232896d6.91.2024.07.09.12.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 12:03:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sRFxj-002sHI-8S;
	Tue, 09 Jul 2024 15:53:15 -0300
Date: Tue, 9 Jul 2024 15:53:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240709185315.GM14050@ziepe.ca>
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de>
 <20240703105253.GA95824@unreal>
 <20240703143530.GA30857@lst.de>
 <20240703155114.GB95824@unreal>
 <20240704074855.GA26913@lst.de>
 <20240708165238.GE14050@ziepe.ca>
 <20240709061721.GA16180@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709061721.GA16180@lst.de>

On Tue, Jul 09, 2024 at 08:17:21AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 08, 2024 at 01:52:38PM -0300, Jason Gunthorpe wrote:
> > Ideally we'd have some template code that consolidates these loops to
> > common code with driver provided hooks - there are a few ways to get
> > that efficiently in C.
> > 
> > I think it will be clearer when we get to RDMA and there we have the
> > same SGL/PRP kind of split up and we can see what is sharable.
> 
> I really would not want to build common code for PRPs - this is a concept
> very specific to RDMA and NVMe.  

I think DRM has it too. If you are populating a GPU page table then it
is basically a convoluted PRP. Probably requires different splitting
logic than what RDMA does, but I've never looked.

> OTOH more common code SGLs would be nice.  If you look at e.g. SCSI
> drivers most of them have a simpe loop of mapping the SG table and
> then copying the fields into the hardware SGL.  This would be a very
> common case for a helper.

Yes, I belive this is very common.

> That whole thing of course opens the question if we want a pure
> in-memory version of the dma_addr_t/len tuple.  IMHO that is the best
> way to migrate and allows to share code easily.  We can look into ways
> to avoiding that more for drivers that care, but most drivers are
> probably best serve with it to keep the code simple and make the
> conversion easier.

My feeling has been that this RFC is the low level interface and we
can bring our own data structure on top.

It would probably make sense to build a scatterlist v2 on top of this
that has an in-memory dma_addr_t/len list close to today. Yes it costs
a memory allocation, or a larger initial allocation, but many places
may not really care. Block drivers have always allocated a SGL, for
instance.

Then the verbosity of this API is less important as we may only use it
in a few places.

My main take away was that we should make the dma_ops interface
simpler and more general so we can have this choice instead of welding
a single datastructure through everything.

> > I'm also cooking something that should let us build a way to iommu map
> > a bio_vec very efficiently, which should transform this into a single
> > indirect call into the iommu driver per bio_vec, and a single radix
> > walk/etc.
>
> I assume you mean array of bio_vecs here.  That would indeed nice.
> We'd still potentially need a few calls for block drivers as
> requests can have multiple bios and thus bio_vec arrays, but it would
> still be a nice reduction of calls.

Yes. iommufd has performance needs here, not sure what it will turn
into but bio_vec[] direct to optimized radix manipuilation is
something I'd be keen to see.

Jason

