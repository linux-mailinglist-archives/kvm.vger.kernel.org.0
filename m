Return-Path: <kvm+bounces-35101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A330A09BEF
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 20:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 487FD16A331
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 19:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAC52135C9;
	Fri, 10 Jan 2025 19:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="B2f+33Tp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5EF213E77
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 19:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736537702; cv=none; b=A096S+SOVdYOmR3vsFfTYmWyzB4x91skqjiS5KXQF1zrQFif9fPIxNQ7IJSWXSWGet3AisjDmBgy7SGFBjYLnYqPgejZKAhj0auSV7n3Jxf03gRqSKfgUuhjvl/5g0ozcmtpU9UdyjFeCZIIRKLTsmEID5G+u9iLqnaSB9OVAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736537702; c=relaxed/simple;
	bh=qsnOLM6HyKJlI9V1EmDU909JMGZm5wjBuBkJfJCbY0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2B28n6ukN1O+7HUj9jQMYXBXWbcbsSvx1vEThzjEc71lFEoMZqFUUtL36Fu1xlCeAjVeAfslR8nzBxX5pDe31ahTtiIjZ3RTxpAKtjL8pdqSfKDtMij8tbQLG2ciyCPpcJrEW10d5f5fwn7hM8XgPOztE9d7JfSosHVEyw2cvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=B2f+33Tp; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-436202dd730so17936695e9.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1736537698; x=1737142498; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kWAcn2HdAkzhLxO4py5Jy0oNRzwsuvt23AwwagkjAw=;
        b=B2f+33TpSEZFAU11axJpCBykw7HInyPJIsPUfZj/DI9y+6poE+SuyNuMaZ9SnLHYsz
         g0wXWvcnecrjbOMzC9voUdX0nHGav8+mQh9j3Kl5v4k5FAp4XkETEXKD7YyH7qamJ+aE
         L0qnTPKk2PsPLhGd2X5CKxTMZctVumQOdnZRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736537698; x=1737142498;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7kWAcn2HdAkzhLxO4py5Jy0oNRzwsuvt23AwwagkjAw=;
        b=CB+ClD3F/MbILxoGs2dLmQAUaruBbaWtgBq+ZOM9gOsos1J2tnxV6oQmxZixzqqsrD
         1bXw/rL9CMHI7LFEA3OjDYjNMh+QT+GkGn/yXpjxpaH15K0dPt+HREs5etx17xapgwpn
         Taf0D5X7v0aolo1IbdJjSpBWglBmf0Jo51b9aMSJJvtnDXu9r6k2vyLb71858ERThhUK
         knzXtOoHHaXPoUPKZiaiwCvEOJEkv/1BtxxL+uEiDGgnALNONMknWEulRPF5Wco/KVGt
         k/Zro7JJoGXF0FrC4qTutBFnpcPfIW73dsyXNItqg9FmOp5x5/MSmg/aueC+n4mC6lZM
         FGRA==
X-Forwarded-Encrypted: i=1; AJvYcCWSSVDuP0rCpqlbkHYbUyN5Pklx9dKEGAolUJase2nBPo/+zroZ9dmtw5ho/7HZ8MaXPoI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5gzJrvyyEPCGdTwXIxBUzL1zXFuldGb9rfyOZh0V/4b3VphOA
	yzPwpH9KuP22hcMF3ib1Wy56T0134FJQseH34dd/Bh01r/zwa4iAcma+B2ZExkU=
X-Gm-Gg: ASbGnctV4jPQDoi9l5Z17ex7kNCPPLpijQoAtsQ8Ozv67qzKUk4e/Imn0BTFxC0KieB
	p48UtS1Va4ETbP/9lA7kb6DHNIWDfFFljDCSQi1yQnZc1RPzibkTafWrAzw+vyS+zFNfDeksDQ/
	6UN6wUFqF8xx/1Sp+lFQDkHz08fehHUSIrOTbwvX5iXOytaXA3QJuUdM6q7ur+5HOCyhCwj5M4e
	9AaExjVmn1X/vgpiq1futtoPE4oFZ+dcYl/LCG6acGepmOvj54uJbd7wPz3nngLWdo/
X-Google-Smtp-Source: AGHT+IEG18CSISXY84VJBWraGNluA4sVqJHq96BnG6t/WiH07yy9ye9bYCNc0ZRatrla1bgxtE/aQg==
X-Received: by 2002:a05:600c:138d:b0:433:c76d:d57e with SMTP id 5b1f17b1804b1-436e26849f1mr121839695e9.5.1736537698379;
        Fri, 10 Jan 2025 11:34:58 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:5485:d4b2:c087:b497])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436dd1682e4sm64030085e9.1.2025.01.10.11.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 11:34:57 -0800 (PST)
Date: Fri, 10 Jan 2025 20:34:55 +0100
From: Simona Vetter <simona.vetter@ffwll.ch>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <Z4F2X7Fu-5lprLrk@phenom.ffwll.local>
Mail-Followup-To: Xu Yilun <yilun.xu@linux.intel.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
References: <b1f3c179-31a9-4592-a35b-b96d2e8e8261@amd.com>
 <20250108132358.GP5556@nvidia.com>
 <f3748173-2bbc-43fa-b62e-72e778999764@amd.com>
 <20250108145843.GR5556@nvidia.com>
 <5a858e00-6fea-4a7a-93be-f23b66e00835@amd.com>
 <20250108162227.GT5556@nvidia.com>
 <Z37HpvHAfB0g9OQ-@phenom.ffwll.local>
 <Z37QaIDUgiygLh74@yilunxu-OptiPlex-7050>
 <58e97916-e6fd-41ef-84b4-bbf53ed0e8e4@amd.com>
 <Z38FCOPE7WPprYhx@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z38FCOPE7WPprYhx@yilunxu-OptiPlex-7050>
X-Operating-System: Linux phenom 6.12.3-amd64 

On Thu, Jan 09, 2025 at 07:06:48AM +0800, Xu Yilun wrote:
> >  So I guess my first question is, which locking rules do you want here for
> >  pfn importers?
> > 
> >  follow_pfn() is unwanted for private MMIO, so dma_resv_lock.
> > 
> >    As Sima explained you either have follow_pfn() and mmu_notifier or you
> >    have DMA addresses and dma_resv lock / dma_fence.
> > 
> >    Just giving out PFNs without some lifetime associated with them is one of
> >    the major problems we faced before and really not something you can do.
> 
> I'm trying to make exporter give out PFN with lifetime control via
> move_notify() in this series. May not be conceptually correct but seems
> possible.
> 
> > 
> > 
> >  If mmu notifiers is fine, then I think the current approach of follow_pfn
> >  should be ok. But if you instead dma_resv_lock rules (or the cpu mmap
> >  somehow is an issue itself), then I think the clean design is create a new
> > 
> >  cpu mmap() is an issue, this series is aimed to eliminate userspace
> >  mapping for private MMIO resources.
> > 
> >    Why?
> 
> OK, I can start from here.
> 
> It is about the Secure guest, or CoCo VM. The memory and MMIOs assigned
> to this kind of guest is unaccessable to host itself, by leveraging HW
> encryption & access control technology (e.g. Intel TDX, AMD SEV-SNP ...).
> This is to protect the tenant data being stolen by CSP itself.
> 
> The impact is when host accesses the encrypted region, bad things
> happen to system, e.g. memory corruption, MCE. Kernel is trying to
> mitigate most of the impact by alloc and assign user unmappable memory
> resources (private memory) to guest, which prevents userspace
> accidents. guest_memfd is the private memory provider that only allows
> for KVM to position the page/pfn by fd + offset and create secondary
> page table (EPT, NPT...), no host mapping, no VMA, no mmu_notifier. But
> the lifecycle of the private memory is still controlled by guest_memfd.
> When fallocate(fd, PUNCH_HOLE), the memory resource is revoked and KVM
> is notified to unmap corresponding EPT.
> 
> The further thought is guest_memfd is also suitable for normal guest.
> It makes no sense VMM must build host mapping table before guest access.
> 
> Now I'm trying to seek a similar way for private MMIO. A MMIO resource
> provider that is exported as an fd. It controls the lifecycle of the
> MMIO resource and notify KVM when revoked. dma-buf seems to be a good
> provider which have done most of the work, only need to extend the
> memory resource seeking by fd + offset.

So if I'm getting this right, what you need from a functional pov is a
dma_buf_tdx_mmap? Because due to tdx restrictions, the normal dma_buf_mmap
is not going to work I guess?

Also another thing that's a bit tricky is that kvm kinda has a 3rd dma-buf
memory model:
- permanently pinned dma-buf, they never move
- dynamic dma-buf, they move through ->move_notify and importers can remap
- revocable dma-buf, which thus far only exist for pci mmio resources

Since we're leaning even more on that 3rd model I'm wondering whether we
should make it something official. Because the existing dynamic importers
do very much assume that re-acquiring the memory after move_notify will
work. But for the revocable use-case the entire point is that it will
never work.

I feel like that's a concept we need to make explicit, so that dynamic
importers can reject such memory if necessary.

So yeah there's a bunch of tricky lifetime questions that need to be
sorted out with proper design I think, and the current "let's just use pfn
directly" proposal hides them all under the rug. I agree with Christian
that we need a bit more care here.
-Sima

> 
> > 
> >  separate access mechanism just for that. It would be the 5th or so (kernel
> >  vmap, userspace mmap, dma_buf_attach and driver private stuff like
> >  virtio_dma_buf.c where you access your buffer with a uuid), so really not
> >  a big deal.
> > 
> >  OK, will think more about that.
> > 
> >    Please note that we have follow_pfn() + mmu_notifier working for KVM/XEN
> 
> Folow_pfn & mmu_notifier won't work here, cause no VMA, no host mapping
> table.
> 
> Thanks,
> Yilun
> >    with MMIO mappings and P2P. And that required exactly zero DMA-buf changes
> >    :)
> > 
> >    I don't fully understand your use case, but I think it's quite likely that
> >    we already have that working.
> > 
> >    Regards,
> >    Christian.

-- 
Simona Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

