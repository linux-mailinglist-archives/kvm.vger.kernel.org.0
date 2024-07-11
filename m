Return-Path: <kvm+bounces-21458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC2592F293
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 01:22:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBB52B21865
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 23:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B879C1A0AE7;
	Thu, 11 Jul 2024 23:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nIPKSS+K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434901A01CB
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 23:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720740109; cv=none; b=anDFZC1bacBO7B9nnzeGdS5H9R2Vbwxyo0sjsH1XZmdTl2tl9AJPC5BI+XICh6IRjXf5QN9mg11u6Qb8ddbYD/rbLsNrF/Jx4PH3Hg8bOdgGnJ981zG/4gVub47drfz343cPAoL7dWAFzZoHArEMrJiEKYlHdlyWPkx9oeHMEJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720740109; c=relaxed/simple;
	bh=yBzw/fpawDv/KPcPaY2/FkE3DGz3iFhkQCMcidhYJy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTDoXEWj4/cVPtyOIzzigmV11YJJFBio5t+0nvv1Qsayh71YxCmyk7zseKpdoENk7n3P4sQLaajCkONv8MEivYpSqLDxp9qPeEoYskwEd/zXH+1PLeSSsjHzDzzROcTqpLxUsGWe0Uu8U/n7Q1QzLn9WUQ/ctr8tlUxF1cX9dyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nIPKSS+K; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6b5dfa44f24so8082866d6.3
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 16:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1720740107; x=1721344907; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iA5EkoKdOMHWMqTqv30k2JtFjPGSRguy2LMuZP+mDPQ=;
        b=nIPKSS+KTzMPGs/qhTb/4shsJL1+iGXNyq3KD9UF+NJO+MJdrFqd2U8wHvKOpCv6Bp
         vMhprI2QaXObRppIrhKXDvr0k13uEHaJ0VvqaWRKuCA5P+yzacerw3YQEj0OdWdxAZ95
         qrbqmqtYdQH3D6ISXGGxdeuuy3lasqj02WoRVtPW7QRsDUuRuHcLsHmqvfp5toIAvZDC
         6h43YjEE8/7M2usehzHD94FO6bNCoqaee9TIk1HYXGgZl1KqTKiVlqMc1NboIyptS6pQ
         VPL2KtBPU0tv1GT7TemzEtXkiYBjECJ9W3HEBL5maqCxvIwpGpL3Ke6qed/HfnzmF7cl
         198A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720740107; x=1721344907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iA5EkoKdOMHWMqTqv30k2JtFjPGSRguy2LMuZP+mDPQ=;
        b=A2YG5oenhggn5sZYtbZjsS4vPYfNn3tz7+nVZIwQkD3X7oCV+lDdYb50q3HhEuX8L5
         guF5V2bFEpxyz6UJfq/XKPMjmzjfyqCYNTU5QX4PdjHrFEzsHvS+FajWP9zBWWrRBl4q
         xxr+gfHghaMZMqFhir8Rg8+19sO/2Tg3tpZGDX7WRDLeagZQX3gxxyTN0puLrYPg3RBq
         9S1r3lGNU2mOyY7KuC3/TOoSjcHNQN24pNZ6z/XCM6pONjnlJ7MfqOig5xTnb3HhTNqY
         Rjt32av/gnf7A12AqE8B7DolkzpQLnlysRuSheuxSalqpOaG4dhimZhJTxEa5hYHIfkU
         7/EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVUQHsL5TFGjcN33yg3ApzwOT2QvHJK55PnQ9GNUpPCBjROyjWaMZCTX/xjtZgJ2A0r81xAo+nKzOPTr172fQxGdEz
X-Gm-Message-State: AOJu0YywA5sAvuhqNxXiVBrpkj2zCkCtOIeQ0fdFe2pFjzIxMpJ2MKgg
	dMU7wehGt2+ez7rmOJ6aMDY27jhm1WtzSaNaa9KdCPwK0C2LUaUIY0tIsHc8PY0=
X-Google-Smtp-Source: AGHT+IE3EReOFfP9Gp9yOBbEQdd9ZoxHQTHmzRvm3onKx9Jai/yPhMccTCjhIICDfGTUxTuCo6A+VA==
X-Received: by 2002:a05:6214:1c83:b0:6b0:6a57:c982 with SMTP id 6a1803df08f44-6b61bcff6edmr121290886d6.28.1720740107241;
        Thu, 11 Jul 2024 16:21:47 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.90])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b61ba7a437sm29827036d6.85.2024.07.11.16.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 16:21:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sS36e-00FPgi-P3;
	Thu, 11 Jul 2024 20:21:44 -0300
Date: Thu, 11 Jul 2024 20:21:44 -0300
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
Message-ID: <20240711232144.GQ14050@ziepe.ca>
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de>
 <20240703105253.GA95824@unreal>
 <20240703143530.GA30857@lst.de>
 <20240703155114.GB95824@unreal>
 <20240704074855.GA26913@lst.de>
 <20240708165238.GE14050@ziepe.ca>
 <20240709061721.GA16180@lst.de>
 <20240709185315.GM14050@ziepe.ca>
 <20240710062704.GA25953@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710062704.GA25953@lst.de>

On Wed, Jul 10, 2024 at 08:27:04AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 09, 2024 at 03:53:15PM -0300, Jason Gunthorpe wrote:
> > > That whole thing of course opens the question if we want a pure
> > > in-memory version of the dma_addr_t/len tuple.  IMHO that is the best
> > > way to migrate and allows to share code easily.  We can look into ways
> > > to avoiding that more for drivers that care, but most drivers are
> > > probably best serve with it to keep the code simple and make the
> > > conversion easier.
> > 
> > My feeling has been that this RFC is the low level interface and we
> > can bring our own data structure on top.
> >
> > It would probably make sense to build a scatterlist v2 on top of this
> > that has an in-memory dma_addr_t/len list close to today
> 
> Yes, the usage of the dma_vec would be in a higher layer.  But I'd
> really like to see it from the beginning.

Well, lets start with agreeing on this layer's API and be confident it
can succeed.

Then I'd say to look at RDMA as it is a logical place to build such a
data structure and we can build something that at least does what RDMA
needs.

I need something anyhow to plumb through to DMABUF and over to iommufd
and VFIO, can't skip out on it :)

> Yes, I don't think the dma_vec should be the low-level interface.
> I think a low-level interface based on physical address is the right
> one.  I'll see what I can do to move the single segment map interface
> to be physical address based instead of page based so that we can
> unify them.

Yeah, I've been talking to Matthew explaining that starting at the DMA
API makes the most sense and lets remove mandatory struct page
entanglements there. Then we can start to examine other layers. Having
a consistent option in the DMA API to be physically based with a
memory type fits with that plan.

Jason

