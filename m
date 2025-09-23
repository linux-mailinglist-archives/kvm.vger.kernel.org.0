Return-Path: <kvm+bounces-58597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28795B9772B
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 22:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 189A71B230DE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 20:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4FE30AAC8;
	Tue, 23 Sep 2025 20:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLFqnU6d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D592F3620
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 20:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758658053; cv=none; b=HbDbLhnz53qi/XDZJcbiS70UBXFOAKxsT1IJSGPP10j5xWnZqft+rX5OJgJ03JTHBjUhCowq5IQ0X/lK6APN/uoFQyVYHaFZ8GfDi0X+tcu0ReQAOwVUpJjE9FCh4/OtWneKTZmeCIz6P1yBmOf3TkIaiQfjsgrjaPAnEOcQcfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758658053; c=relaxed/simple;
	bh=/cNMCmhs2+2GgzKjW2K7MV1lRjCXVMAS8z1dlxsrJ7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFHtCmunNjDPdRP/dgaiHu9fsbkOH4h7u3KWNnjXWwD98O4+lIf3AZt1IlIPi/bjLXTjsKHixKW6Zm03tLs6N5pkloAlvy3fftmHJTDJg8VTClVVfgsEJ2aaqnFqWJl3dGoY5vXM+GVqysDOdpzwQeFBOGx8Ob41iK0sRKojBBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZLFqnU6d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758658050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TkF/1TIVCdQ8I35UWInq/5XGtjT7LO6t3DfocUuGzJk=;
	b=ZLFqnU6d+6znjZm1pAwJ06tM7mu3sevqZlUrT8MjnxwlkXnkTcyAXiAA6TG2ugWnXotjoI
	TdSoPOFUBZUupSa72gNvmK6pOUe++iUCJ2LAaZQ+ZbW03xt+Z/3dlVMHZjvF6jguJV9+zY
	anHh/hhO8vGM/0FtG3uQIIO8IH4Ytj4=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-6JT9l2TKNNyozqVJ-pJhxA-1; Tue, 23 Sep 2025 16:07:29 -0400
X-MC-Unique: 6JT9l2TKNNyozqVJ-pJhxA-1
X-Mimecast-MFC-AGG-ID: 6JT9l2TKNNyozqVJ-pJhxA_1758658048
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4258981d664so852235ab.3
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 13:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758658048; x=1759262848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TkF/1TIVCdQ8I35UWInq/5XGtjT7LO6t3DfocUuGzJk=;
        b=tAFPndUYLLg4CcsNmm18JXHPyDhUCAaWHTd5LMHPqjy60mkKBMw/kKcghZQYDciepH
         4oJn9At1yFP/46sS/Ii5gMvT0m+FAGWkufoEbjm//uSPWhfrtIO8P/Aqo4EAxHjiyqhn
         BhEpI+qv/qG4b3phfJH0DH1LArMHgX/B53dGrehpBxhs+MKsLm8MlWL8q74UcZ75FOpT
         gj9Wr1/gKZJx3dzHVei2j32Uw6rxGly0aAMTcUL9FY/h4dOWkTQW0TgzDnuD8p48OxMf
         yxhT45bn/PFSPCVaHeImCWo7mIXQFX7d80H92XHN1TW+jDRuyV542dcIYqHJUIPOKGkn
         yi7g==
X-Forwarded-Encrypted: i=1; AJvYcCW+sKy1a8edD5HlC5wzjFO8/oaJnhGb2Xd/3zRwWoAIJpsYXHY3AxcGe+/ZFor/8BtsfiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhVkQVQrptn88y6huJUaZOxb5DLeKJ8caRvxaXebAWq8FCRVUz
	wsVoAJ3L7teupDquVn+TyeAvct6Pa5d4iyHIkNIzNfoAToXyi3dK0MRoNYcb5Qb6hT70+t+Pbkp
	gZRKfOa/McNvlaxAmM1qpiDzOhzscbLoke4BrubuLDktEp84MJhvc/w==
X-Gm-Gg: ASbGncvGtpz9ZiKlVYXp3zIupZJCk8rT2azPzsvhV3j8QMTuB83eEB7Jd379r56O/h2
	ApkrOZ/FZUU2NvAZB0GAsjMhPql7XRIFGm9thpcE0jE2MdebnPL64EUBJkpZM4l5t7zf2sbYpqS
	YLWdt6YhM0w29oOSszRqseFnrhynk282YpdlLmgit458GqUIgNEmjOUiSfEP7JuIwjMJqEkvmJG
	/nNvYvVsjcK5oIQGg+h1D/1RYsmhXLdQWTRqDUtAoifxPy6UJCr1wLk1SJaf71CySOxe2v5155y
	FT/RLk5ujBqAgu1EpHcU/l5BSYQTkr2YV0eCB455NQY=
X-Received: by 2002:a05:6e02:b27:b0:423:fd07:d3fe with SMTP id e9e14a558f8ab-42581e0924amr21638585ab.2.1758658048119;
        Tue, 23 Sep 2025 13:07:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmMxIqHNMDHwq6jPuldjwSxK84807XGPUliuEF5qCvF8SuPWmF0LqQLkrDELCWNHqAt6pi1g==
X-Received: by 2002:a05:6e02:b27:b0:423:fd07:d3fe with SMTP id e9e14a558f8ab-42581e0924amr21638385ab.2.1758658047638;
        Tue, 23 Sep 2025 13:07:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-425813f3053sm15141865ab.21.2025.09.23.13.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 13:07:26 -0700 (PDT)
Date: Tue, 23 Sep 2025 14:07:23 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250923140723.14c63741.alex.williamson@redhat.com>
In-Reply-To: <20250923171228.GL10800@unreal>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
	<20250922150032.3e3da410.alex.williamson@redhat.com>
	<20250923171228.GL10800@unreal>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Sep 2025 20:12:28 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Mon, Sep 22, 2025 at 03:00:32PM -0600, Alex Williamson wrote:
> > On Thu, 11 Sep 2025 14:33:07 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Refactor the PCI P2PDMA subsystem to separate the core peer-to-peer DMA
> > > functionality from the optional memory allocation layer. This creates a
> > > two-tier architecture:
> > > 
> > > The core layer provides P2P mapping functionality for physical addresses
> > > based on PCI device MMIO BARs and integrates with the DMA API for
> > > mapping operations. This layer is required for all P2PDMA users.
> > > 
> > > The optional upper layer provides memory allocation capabilities
> > > including gen_pool allocator, struct page support, and sysfs interface
> > > for user space access.
> > > 
> > > This separation allows subsystems like VFIO to use only the core P2P
> > > mapping functionality without the overhead of memory allocation features
> > > they don't need. The core functionality is now available through the
> > > new pci_p2pdma_enable() function that returns a p2pdma_provider
> > > structure.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  drivers/pci/p2pdma.c       | 129 +++++++++++++++++++++++++++----------
> > >  include/linux/pci-p2pdma.h |   5 ++
> > >  2 files changed, 100 insertions(+), 34 deletions(-)  
> 
> <...>
> 
> > > -static int pci_p2pdma_setup(struct pci_dev *pdev)
> > > +/**
> > > + * pcim_p2pdma_enable - Enable peer-to-peer DMA support for a PCI device
> > > + * @pdev: The PCI device to enable P2PDMA for
> > > + * @bar: BAR index to get provider
> > > + *
> > > + * This function initializes the peer-to-peer DMA infrastructure for a PCI
> > > + * device. It allocates and sets up the necessary data structures to support
> > > + * P2PDMA operations, including mapping type tracking.
> > > + */
> > > +struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
> > >  {
> > > -	int error = -ENOMEM;
> > >  	struct pci_p2pdma *p2p;
> > > +	int i, ret;
> > > +
> > > +	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
> > > +	if (p2p)
> > > +		/* PCI device was "rebound" to the driver */
> > > +		return &p2p->mem[bar];
> > >    
> > 
> > This seems like two separate functions rolled into one, an 'initialize
> > providers' and a 'get provider for BAR'.  The comment above even makes
> > it sound like only a driver re-probing a device would encounter this
> > branch, but the use case later in vfio-pci shows it to be the common
> > case to iterate BARs for a device.
> > 
> > But then later in patch 8/ and again in 10/ why exactly do we cache
> > the provider on the vfio_pci_core_device rather than ask for it on
> > demand from the p2pdma?  
> 
> In addition to what Jason said about locking. The whole p2pdma.c is
> written with assumption that "pdev->p2pdma" pointer is assigned only
> once during PCI device lifetime. For example, see how sysfs files
> are exposed and accessed in p2pdma.c.

Except as Jason identifies in the other thread, the p2pdma is a devm
object, so it's assigned once during the lifetime of the driver, not
the device.  It seems that to get the sysfs attributes exposed, a
driver would need to call pci_p2pdma_add_resource() to setup a pool,
but that pool setup is only done if pci_p2pdma_add_resource() itself
calls pcim_p2pdma_enable():

        p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
        if (!p2pdma) {
                mem = pcim_p2pdma_enable(pdev, bar);
                if (IS_ERR(mem))
                        return PTR_ERR(mem);

                error = pci_p2pdma_setup_pool(pdev);
		...
        } else
                mem = &p2pdma->mem[bar];

Therefore as proposed here a device bound to vfio-pci would never have
these sysfs attributes.

> Once you initialize p2pdma, it is much easier to initialize all BARs at
> the same time.

I didn't phrase my question above well.  We can setup all the providers
on the p2pdma at once, that's fine.  My comment is related to the
awkward API we're creating and what seems to be gratuitously caching
the providers on the vfio_pci_core_device when it seems much more
logical to get the provider for a specific dmabuf and cache it on the
vfio_pci_dma_buf object in the device feature ioctl.  We could also
validate the provider at that point rather than the ad-hoc, parallel
checks for MMIO BARs.  Thanks,

Alex


