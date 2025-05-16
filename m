Return-Path: <kvm+bounces-46823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8972BAB9F04
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 16:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70E721C0050B
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8191A7045;
	Fri, 16 May 2025 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+ATuetr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452E01A08CA
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747407328; cv=none; b=pfRJ3gU4QFkr/OefjhFXeGsSnXy0iror3sOvLRY8uzIWIkGW/vqFj43Bn+NLMOFczGJBHI2G2jmL9qNe1TnpMjLjdzsBXt40lx+kXE0iyaDKr5dRaaNtHpJqOGrEX1pW9VLYAbgRKXXzvPmZ0zHQJ+N1yRf9X4c4S6JfEDGJ65w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747407328; c=relaxed/simple;
	bh=g3GmjB2vnMjLb0vAOdgXRlLN/cSrVNrh70Eka0zXYMg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsbjbIPctmRv9iLH8qj83wDhV3h4oAKvDiEcEpQjHlVr+8UuUiarRzkrV34mF1izj5AkwM9bMmGOzK3PcQLoYAMcYLGpa2iln8cCaJLmKAQ2EwZOib1QDB/+6enSyP0dUWFTnQP1s6mrCR3JSJEjOitBic+CTzDEnKCWSkX1/8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+ATuetr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747407326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RCpEW9dWij2GPvehpQ+X4jy2d+EX1S58wCrFKFNBOw4=;
	b=e+ATuetrn4W3g88rJ2jgTFS38WIgNlgLedlQOKfHC9AKx6JS9h6naE0TlvBnta6RYZs8Bo
	jAvFT9rh1N670ljuzexyuHLqowiFNN5sREVdK4aMTHWMuCzmqLKYpx/x9MfDlRUPOG1P+W
	pJvyEpfq93Ywj77dsQOX8wzmysSi8m0=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-ULNmqpcBOsqs3AHkOFXZsg-1; Fri, 16 May 2025 10:55:24 -0400
X-MC-Unique: ULNmqpcBOsqs3AHkOFXZsg-1
X-Mimecast-MFC-AGG-ID: ULNmqpcBOsqs3AHkOFXZsg_1747407323
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85b5c68c390so38703739f.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 07:55:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747407323; x=1748012123;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RCpEW9dWij2GPvehpQ+X4jy2d+EX1S58wCrFKFNBOw4=;
        b=hrGf4mDwbw4xARS8r6YXussGbAvzNSJzVvucRyrN/348AHxRdEKh82tkEWq+dETr1p
         K8PBP8qhHHuq1ze21ZaOMNLQF4Q/2NW3/6+q8NESoqjYo/S9o7wX1mysMHg3+eipPy+8
         HjbU4o0jwOWsDhV4skBShInZF7l0Teim3eptTrurEMEAtJAcSAYtvLBooWUv2bnqrueo
         KFUooc1Uzsz1bSI3LmLptLKPpO/6EIvM+W5nT6bbtkXiD+vzQrUhh+5hH4uUxUCCatrg
         f0+btk8Esu0wKtDt/aFuZiI7DAZ6mlgXtPgtFoemSwsvucv6WITuWPk13/uH0GLCoOd+
         oq/w==
X-Forwarded-Encrypted: i=1; AJvYcCVUGayu+2L41sesKotS6EqwnD1ufO2VJDIJb1laxC3YP+u2EbaaIvkTjQH37JhdSeH4j84=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw00fofnZ1O3xSB8m/uowG+u0LHIb0Hx5WXLKm4rZuCnhh4Xbq5
	lIXryxHhWkmlDG5l1o9WXPJBAB3EPF2OoOySm2JOCo9mXRfH64LpTe3p9r+nMsj8p725ZUkoo3n
	mOw0AsAA0oa8/FVcgRmsDL5P4TjNM2VLhTvh2J0r8yeZ6vFJ+tsxo7w==
X-Gm-Gg: ASbGncuPEuaJLw2Zd6rd0XHuB4C5ZMTHAkPlOTEbZuMFt5MMkd1xpzYAxEQOn0swmll
	wEAGx7G7DlW3eUEsmrakj3eaOyJE3O0WXgadHaTnUvSC/ny6u7tykjasloT70O2a3fsu+ZaZf7Z
	bkBTOEIEtrH/QNhX6LUo70VX8WXwGr9yPvlK5EicCnfvc1G1hBzYinUiOECTH6euJf6lVQLsdXQ
	4VZurWlfh+LJ627Vq79gtfBjv66SaN7r18e2NrmdwEldNbwbwyGhRGiLlyUa3YPVo54ATFaX/7V
	wS8K6H+Hzz/YpTU=
X-Received: by 2002:a05:6e02:2197:b0:3d4:712e:29ed with SMTP id e9e14a558f8ab-3db8437e424mr12110015ab.7.1747407323456;
        Fri, 16 May 2025 07:55:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQbpd9KQH/jJZUZUDSw0rCGlc5WOQdQeyDRQO/nVepccE4W5LuVworj0XnDyBRYAbwKOlM1w==
X-Received: by 2002:a05:6e02:2197:b0:3d4:712e:29ed with SMTP id e9e14a558f8ab-3db8437e424mr12109895ab.7.1747407323014;
        Fri, 16 May 2025 07:55:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a289sm422759173.6.2025.05.16.07.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 07:55:22 -0700 (PDT)
Date: Fri, 16 May 2025 08:55:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: lizhe.67@bytedance.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev, Peter Xu
 <peterx@redhat.com>
Subject: Re: [PATCH] vfio/type1: optimize vfio_pin_pages_remote() for
 hugetlbfs folio
Message-ID: <20250516085520.4f9477ea.alex.williamson@redhat.com>
In-Reply-To: <20250516141816.GB530183@ziepe.ca>
References: <20250513035730.96387-1-lizhe.67@bytedance.com>
	<20250515151946.1e6edf8b.alex.williamson@redhat.com>
	<20250516141816.GB530183@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 May 2025 11:18:16 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Thu, May 15, 2025 at 03:19:46PM -0600, Alex Williamson wrote:
> > On Tue, 13 May 2025 11:57:30 +0800
> > lizhe.67@bytedance.com wrote:
> >   
> > > From: Li Zhe <lizhe.67@bytedance.com>
> > > 
> > > When vfio_pin_pages_remote() is called with a range of addresses that
> > > includes hugetlbfs folios, the function currently performs individual
> > > statistics counting operations for each page. This can lead to significant
> > > performance overheads, especially when dealing with large ranges of pages.
> > > 
> > > This patch optimize this process by batching the statistics counting
> > > operations.
> > > 
> > > The performance test results for completing the 8G VFIO IOMMU DMA mapping,
> > > obtained through trace-cmd, are as follows. In this case, the 8G virtual
> > > address space has been mapped to physical memory using hugetlbfs with
> > > pagesize=2M.
> > > 
> > > Before this patch:
> > > funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
> > > 
> > > After this patch:
> > > funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();
> > > 
> > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > ---
> > >  drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++++++++++++++++
> > >  1 file changed, 49 insertions(+)  
> > 
> > Hi,
> > 
> > Thanks for looking at improvements in this area...  
> 
> Why not just use iommufd? Doesn't it already does all these
> optimizations?

We don't have feature parity yet (P2P DMA), we don't have libvirt
support, and many users are on kernels or product stacks where iommufd
isn't available yet.

> Indeed today you can use iommufd with a memfd handle which should
> return the huge folios directly from the hugetlbfs and we never
> iterate with 4K pages.

Good to know we won't need to revisit this, and maybe "good enough"
here, without tackling the batch size or gup page pointers is enough to
hold users over until iommufd.  Thanks,

Alex


