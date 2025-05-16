Return-Path: <kvm+bounces-46818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD493AB9E7D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 16:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBF3C4E3D64
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC901A0BE1;
	Fri, 16 May 2025 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZJ1fvfyI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8976C199FAC
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747405101; cv=none; b=Hur4CC9tNojhZjBHLn/d6VZ/43H4DtR9BWb00ARvcrPO/zmKBRC1cGmmTPLgXUADbwEroy4snjVpyQS7CHECxabJsoeLIhLhnVIhVanBeMcv0uf2/ymHpxIZKfTI3ZeOXTYToJRSegpM7xKEuDOIP0Q28EGQ5Le1H4MyObesCR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747405101; c=relaxed/simple;
	bh=Mg6g1/TzH+Xhtn16KUSbRqht0teHBbYz5hWZnb6szNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4k3sH0o6aVsGXDZlQ1fwyGqzwTioqeR0nsWOos9LRr19dsS+JxDCCV1qQOxfdw0hie98TKOqjPmTGCCnQXQljIC3Ex55zFomslCftRIizKT8PDF4W2MmoJ+g+w4OI4jw9+kItSHRWdHP8UhyJI+PPAdhxe7eEHwCnln62OoA60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZJ1fvfyI; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6f8b47c5482so10321896d6.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 07:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1747405097; x=1748009897; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oku1snLMpD2EhPjxkL/jicRSSroCJrOHGMPvLIw4vjs=;
        b=ZJ1fvfyIoPLhOUTfFLPr2CV0SxTY9jmFKzOClANqq33HzLbTTit4sVHm3+pv/ET8Nd
         unQVmiHNboGffcxc0Rp/3UKZyQ9IOugXQ1AtwalwgujlN1gNlXpirN+i81W0rdbMFJfF
         XgsS3J2RWJVcwqzdQ8n0SlNqakXit4pYwveCXj63pvD3XwDaLWwU9rfrzuyRhucdyvCS
         xXXe3XUhPmXwMl4S0AEWT5aCNwaj6PxFrEModJVAP/KZgk21sKe7cs9shJeV/C1MV+nC
         oIOcl9xeFgoWC2Pq4KP8G3fpvdp4RJOWZGJvuGuKdaW4tCPRt9OjQfzbHAXAfeJ4O+hc
         yedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747405097; x=1748009897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oku1snLMpD2EhPjxkL/jicRSSroCJrOHGMPvLIw4vjs=;
        b=eoh1lAhfWdoqEZtd6QAwfmFO0Wg3UgI7+xB+imLAmi40KYXwpCroBDR3Zw2z4lYbyU
         KUZ3m4+T02N9qadw1hENRMEB/74ZLdsp9xh2oQa15X5A/rcSBv0uAFWEBQLsBMDKd2mF
         vySYf+2nU7ibeG3cU95oIyD6JtJaExp6cd3JNU+pgifTywEaYTeEAHX2aDiosD/hOH1u
         7UKOtCuTvrrbko7S3DDrViqOuSuRQ4cFG9D69ONCBc8NKw6P7CKjnm5EI+x4JjtoiEuP
         fg4AdGH1ChN5inhBO7+IvkRs6IQz1p2eJePwXV/sWdN/2LK1i/vw99om8YfraSDvitVf
         erng==
X-Forwarded-Encrypted: i=1; AJvYcCURZTDbqzBk+wMW01JE8zBDqsRV6E7NCg4zlM+mH0SgjndutWUzyT7/4xH2wiJjRRbHPg4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTO+gP85omYDsR49WdzbFSJDOgC/erdZI1cdl2PojFciOqP4eE
	YUI564USdY0l7qq/+wIaUAJ7+NyJ7D+Zz+y+Ukc+aJyrOB/h+UDzpuUAnvSc5+Hu5/E=
X-Gm-Gg: ASbGncsBU9yP3/evfP7ke4PA6OE/pNV0GKxAUCc0RfEhlH/233rnjttufBcucTnObzE
	h++YFLHwbaxdEODVEj01vGDE+3U611xB6CeEDbfFwtcl6HwbtNLOrQsx8IoB9PjKHjHTGPSZ1MJ
	FxnF/iqFBqeE3ytp2VWcqBWgi4CKp4aYYXqbfW+87HydLvEV5ueFfN/+WKtQFZrUXfZFrXTVJD/
	BYKsR66vqA2njHrmutBkkkjXTbds7PjwmNAnvDOSeS5JWG38F09B1eRmI5LE5wAYqiGICI4TyJt
	5tFgqihZlb/nwy62uWHbjrUCF6CjqbTdC/Co6+bn+fg8iFouNYaPqSmcAYhpkAzaibjRBdCQr17
	5tJgUfMNYG4Fts12l7boEJYXZ8aM=
X-Google-Smtp-Source: AGHT+IFtHK6p6wGrGRp+/Uark86W3HpnkGxzK5no2sq/+GtMDf7N3+z/MjO6uU/3WYiZf7Bgzm5AWQ==
X-Received: by 2002:a05:6214:27e2:b0:6f5:4055:83d9 with SMTP id 6a1803df08f44-6f8b2c32c7bmr45344226d6.6.1747405097419;
        Fri, 16 May 2025 07:18:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b096dda9sm12537746d6.71.2025.05.16.07.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 07:18:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uFvtA-00000002g0J-0A2r;
	Fri, 16 May 2025 11:18:16 -0300
Date: Fri, 16 May 2025 11:18:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: lizhe.67@bytedance.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, muchun.song@linux.dev,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] vfio/type1: optimize vfio_pin_pages_remote() for
 hugetlbfs folio
Message-ID: <20250516141816.GB530183@ziepe.ca>
References: <20250513035730.96387-1-lizhe.67@bytedance.com>
 <20250515151946.1e6edf8b.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515151946.1e6edf8b.alex.williamson@redhat.com>

On Thu, May 15, 2025 at 03:19:46PM -0600, Alex Williamson wrote:
> On Tue, 13 May 2025 11:57:30 +0800
> lizhe.67@bytedance.com wrote:
> 
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > When vfio_pin_pages_remote() is called with a range of addresses that
> > includes hugetlbfs folios, the function currently performs individual
> > statistics counting operations for each page. This can lead to significant
> > performance overheads, especially when dealing with large ranges of pages.
> > 
> > This patch optimize this process by batching the statistics counting
> > operations.
> > 
> > The performance test results for completing the 8G VFIO IOMMU DMA mapping,
> > obtained through trace-cmd, are as follows. In this case, the 8G virtual
> > address space has been mapped to physical memory using hugetlbfs with
> > pagesize=2M.
> > 
> > Before this patch:
> > funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
> > 
> > After this patch:
> > funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> 
> Hi,
> 
> Thanks for looking at improvements in this area...

Why not just use iommufd? Doesn't it already does all these
optimizations?

Indeed today you can use iommufd with a memfd handle which should
return the huge folios directly from the hugetlbfs and we never
iterate with 4K pages.

Jason

