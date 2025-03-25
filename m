Return-Path: <kvm+bounces-41970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EBC7A700C0
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 14:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02D641766F9
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 13:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF1526B087;
	Tue, 25 Mar 2025 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="R6aoxlLP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F1C29CB20
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906202; cv=none; b=B4k0G+YpyabpIsRmN+dEe7Q6p40uFDaOIwMZaWJzGBYuFcoKo5lgbWiBJYrcOg9BAmHoASGOZtWhonvmqQvd8GjuNkvDrEPeQ0ggtdFLUp0349Tbri6zLVthHU95LAbI5Bc/knzzfTSmyQZ9HdktJ8CFJJ/EuQqKI9Cov12vgbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906202; c=relaxed/simple;
	bh=kF/4SP83eP8Xbwc4RoYXxSygK8pZn4d3t2Dba+Ka8B8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aIxl3s1BETCyNnOlwYouZz7WwYXHan81bXGgSk5xTOCD0/hJNWETV2G6stA9EP2Wpcyo/fXwxGEzsZQo0FfyrAbTybSujTzvrixuQo7n3vrYZLuueetCe83GJzE8uYVom7Q1RHuNW01LmfynJ+8S52bxlNuYAOGZjfehkrdx2hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=R6aoxlLP; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-47688ae873fso56414241cf.0
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 05:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1742906199; x=1743510999; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kF/4SP83eP8Xbwc4RoYXxSygK8pZn4d3t2Dba+Ka8B8=;
        b=R6aoxlLPQAkjRJPVn6UQKY+axJtOgCb9opi7uMwdqzSxq6yDpzVJboXoMURzqFNmXG
         L4O6evUJSpFvB1ok/nkAvZ2ctxsJoJGXuCD5Hfcl44KP64YYXU13GEP0YO8Nau/AluDo
         dwmvpAQBTe1LqtUycADgDK7X5PVMkLiTdnUNXX0D9l0eroks0GyGaEG2e0DV8VX4ddgC
         7zSjqhv0fWoL3gPf+VGU1+rXRM5Nwx0srQafUgfbqXPk3xjimSWRPzLHwxPFJ/VzIJm8
         styI2AyIntvNjgTTu1Uz79TV7Z9P2nkoB/bDnkzGibSm9AMzCtsSkHlsSbxQRi2emnYn
         A+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742906199; x=1743510999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kF/4SP83eP8Xbwc4RoYXxSygK8pZn4d3t2Dba+Ka8B8=;
        b=JKgbkuNOEfYikJqmg/BDAkLTiVhjqfirJX3QApRSSf+7gwlipkQSdk5MIHJf9GygCc
         AbRJL7dnPY8EZ0eZT5iXL+DFk9lS4ySSBUCEnrlWlXAusoIjZdhJs1qu3Dx5oRF8y5lT
         +kDvpGZrnnMl1h2QBmXGmeUJSzYKl6ADC+0WtHlswRmz2v7Nr94bquTiboWAK+b9C54d
         B/jYDa4V0HB2YIu1o1cSmRZ9RVD5sOhy1eLluRmg6mRDp/w1p0VTKSk8agNu+cKxHTBa
         8O06G3qJfkjaC4mqqLElzf/wceeCe4TfZC4MwQBQVX79SidTYiDAsN7WuhYeoN3QzGWw
         YOvA==
X-Forwarded-Encrypted: i=1; AJvYcCUxOlTvOC4yr8PC0UVnqn35EdIj9UdvPNULApGSXzAQ802hh4CWs6UsUwk+9V0OJorZpaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPs3KTE0Q0ro6h038QWahmVhD5/cDaU9I91KEFEH+glpvFh8zK
	Mo6sRgm3wTmRy6m3BEs14VBzO6rHifJuOl5uvFMnXbot9uoyjx+uCeb9lqmBeao=
X-Gm-Gg: ASbGncuOtm3/sIIJGIiZKW+BY6rjvC3kYRm86OV6W93OsEMHUPTsUY0XPkz4s1dd/ir
	hbOIWMhc3wOR77Es8XCOD5MoRO49TIE41WgZ3iaKz0m2FhK+z5LWK0MC7PtifpUlIx3d3VREwwF
	f0Oo/Dt7mBTwwRxJaFsdP3/SlJvzfHk/x5YLzU8XvQ+J2d35qZXCA6iVeFNBfluPt3HLzPr8V5O
	l8zzHaRStb8nj7tHkWVkYm/gGz338f8C3hoas5bGrwRxbRTMFFdRMN61GqMUs0ngh6iSRc8PU8H
	w0oz0vVnlh8E4MsahA==
X-Google-Smtp-Source: AGHT+IFaGG2Y6kZs0f1G4EEOh4+V+xY6UlM60nMPDSox/R89SepA61uky3NuOhrbXo7zMnxqikKbBQ==
X-Received: by 2002:a05:622a:4106:b0:477:cc4:cb76 with SMTP id d75a77b69052e-4771dd54452mr310138501cf.3.1742906199124;
        Tue, 25 Mar 2025 05:36:39 -0700 (PDT)
Received: from ziepe.ca ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4771d63597dsm59500991cf.71.2025.03.25.05.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 05:36:38 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1tx3WH-0003AX-NS;
	Tue, 25 Mar 2025 09:36:37 -0300
Date: Tue, 25 Mar 2025 09:36:37 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
Message-ID: <Z+KjVVpPttE3Ci62@ziepe.ca>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
 <20250302085717.GO53094@unreal>
 <e024fe3d-bddf-4006-8535-656fd0a3fada@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e024fe3d-bddf-4006-8535-656fd0a3fada@arm.com>

On Fri, Mar 21, 2025 at 04:05:22PM +0000, Robin Murphy wrote:

> What everyone seems to have missed is that while it is technically true that
> the streaming DMA API doesn't need a literal struct page, it still very much
> depends on something which having a struct page makes it sufficiently safe
> to assume: that what it's being given is valid kernel memory that it can do
> things like phys_to_virt() or kmap_atomic() on.

No one has missed this, we are not yet at the point of implementing a
non-struct page PFN only path. That is going to be a followup series,
and yes there are going to need to be some cases where DMA will get
EOPNOTSUPP. You can't swiotlb something without a kmap, or MMIO for
instance.

> efficiently. And pushing the complexity into every caller to encourage and
> normalise drivers calling virt_to_phys() all over (_so_ many bugs there...)

That is unlikely to be how things end up.

> and pass magic flags to influence internal behaviour of the API
> implementation clearly isn't scalable. Don't think I haven't seen the other
> thread where Christian had the same concern that this "sounds like an
> absolutely horrible design."

Christian's perspective is thinking about DMABUF exporters using CPU
PFNs to mmap them to VMAs. Which is a uniquely DRM API abuse.

I think everyone who has really dug into this stuff understands that
the driver that is going to perform the DMA should be the one to do
the DMA mapping. It makes little sense for the driver providing the
memory to do the DMA mapping on behalf of the driver programming the
HW for DMA.

Regardless it doesn't really change this series as the same DMA API
interface to the driver is required to do the work. It doesn't matter
if the DMABUF API puts the calls on the exporter or importer side of
it's API.

> So what is it now, a layering violation in a hat with still no clear path to
> support SWIOTLB?

I was under the impression Leon had been testing SWIOTLB?

What does "no clear path to support SWIOTLB" mean?

Jason

