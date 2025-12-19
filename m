Return-Path: <kvm+bounces-66347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 245FECD0A4F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D98D630836F3
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9C0361DCB;
	Fri, 19 Dec 2025 15:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XoexSVUm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYpuoG96"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F808361DB0
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159620; cv=none; b=nDylT0xyKWlk7L87sf+CwlVwI6HO2bpMEw4bmnbd5t7FfTX3hHkg+6muo072YM4ws6pRyYJyuIQ9bWCWVOinVIb7fU1yrbfoWlCSzftJxXGq2dE2sUjOtgNloXz2o2EXidDmPUrc/FxjmRVjiJgpTQX+8hcfhkH00D/+lPpuAus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159620; c=relaxed/simple;
	bh=HGu5ujBF26oUozqxf92lQiU8WCo4Uwymerm0mV/65Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ir/jtzzM+bKqd2F2MkMAPiFwxpmAKtHTpfqR9FIq00Wzt2GzRVtMMJBT2P1FD3frVdMKxNE5hbbBxqscX66ImGWGCco/mVSZkO1GKTevlM9tLCnjE+o5kvD54mVIIoWBWgSWeGKZibSGr/NzFbThuoKUQVx6lwnao0HOR+H6BnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XoexSVUm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cYpuoG96; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766159617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L/jqv3cJiOiniBhqPGj3ePpHhUWqhzpVBGmNIJAgyrQ=;
	b=XoexSVUmXXpVnWG6JzICABwjYTRotfwSJpfIvc/pRR0lqprz5RVF3/WbflWybAllq1fmCM
	ZdGmBQUX14X+ThQBuE8Xt2CIFmXqASAOPHRH1obBKihFGLZ8UUPb5UHfQtTf4Vd9Qg1Ie/
	45HaOUMTTosHTd5KRJCkaAfIfSLovYU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-9UaC-xmBOlK5tfhR7Jja0w-1; Fri, 19 Dec 2025 10:53:36 -0500
X-MC-Unique: 9UaC-xmBOlK5tfhR7Jja0w-1
X-Mimecast-MFC-AGG-ID: 9UaC-xmBOlK5tfhR7Jja0w_1766159615
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4f4a5dba954so35559461cf.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 07:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766159615; x=1766764415; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/jqv3cJiOiniBhqPGj3ePpHhUWqhzpVBGmNIJAgyrQ=;
        b=cYpuoG96qs5PIwY7b/UYWdPGN9Y0jHbd37uCxB3klz1jHElpqq5qONCbb9npaN6FjC
         m/W52CNTF6IiVjWXDdNcAbcFbd4FcnFT0My6iOHySTg4kuyC4s6Z1mhto0p4zkk7vyUa
         C+EkBVrSmNyOA5iZuqlFp9cePIFG4fo56zbeFY1HtyM0VkpSvYKrd8UdrewyJK6GIb6q
         oD1HsNYYF3AHnYJ5J5gMBO2l00BlvVRTBoZ2aPbVNeTUXdjeKqG2d9ptJ9yeV7Rw5jg4
         xAsd+3ViR9s++51J8EHNeS6arCQtWouoMylHQzC9kozjmA5Ns/fBHOZVWfQJbOC4GB8q
         jY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159615; x=1766764415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/jqv3cJiOiniBhqPGj3ePpHhUWqhzpVBGmNIJAgyrQ=;
        b=lUo+xcF3z59eHTGHWk1caGeIsLUQn24bKrfAO4y7tRz5ToPj3LaLAcqtjYtXbsNr9f
         HPNgKEbGI5MjE61NRoGAux3X+NaEw90bXN4Ofvt/cUwMZYMnB+R6J8qasYOz5lzwzCO3
         R9wTIMofgMC3LVkjOvQh7PbTmJIew289Ewd/gQqjdYkuA+v5xtiep7jLZ08X6njd8V7B
         eE1FAwoYsY/KHUWXpNpATzZ6VzNL86/Yy05Ui+y7X/GFMh0roqdCvqnpw9y1uFc2LzmW
         AGYnYwkXpPqWgnVWIcVBE+aP8r8rf320Q86HpsapZ+sFtWCv7dujI5DZJlVogUiuWazk
         BPGA==
X-Gm-Message-State: AOJu0YweG9TKDrZO19VvTQkOyu82V9q205Wh7tCeYfvfgrEyHD+Dkf9O
	9p/Ki8J4WdwTUgOUJyF04OtniUc0UcXErdfhjRpKZ4UA0PdHoK6dYs8EtCsLDgu1HxKKVqSf46k
	UE/tLeW8RKbkWg6mR9vZAQNg6Py8pPDgjOs7EuQv/R4xHE99fFWQyaA==
X-Gm-Gg: AY/fxX7tgxzcYnRXFit49DDmwepyPvBvTbyV323kP90/MforG/GV7GKuLdzXbxVsF78
	uo/wNxguwxs0/B0iYUWLwSN3V+Y2a3dl26v7wje6L8NJeTDEI39wMmuJqU96ysp+TV+rQPn3CfD
	kC67XSScHwFTmpJ88CYHhIT+bDU/tshnXGmVgHdHaPlKwgURjh8LDf3O4hxkbyZlAbD7+aBjJiB
	8K3c6o+ZyYzPoy51VqjdCxozaM7j9eU84BTQjVkMkYB54CKjApN1/2sia1ceefEBcdRXEM1FITC
	bqNsf5cn1062zZaf9mZLH6vy2rPeNV93KVja9Nq1aabTIB9zGBAVL99cSe1ofq4yPkfEfFll844
	Y9Y4=
X-Received: by 2002:a05:622a:613:b0:4ee:2423:d538 with SMTP id d75a77b69052e-4f4abcf11f4mr44817061cf.18.1766159615310;
        Fri, 19 Dec 2025 07:53:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFouxtlBTlJ/HrUU+MwNoFw+6sCgUDeVcjckP1nM19pQghsLhFECfIT9+YLku6qXfDkEDxFlQ==
X-Received: by 2002:a05:622a:613:b0:4ee:2423:d538 with SMTP id d75a77b69052e-4f4abcf11f4mr44816581cf.18.1766159614863;
        Fri, 19 Dec 2025 07:53:34 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9623fdd8sm21404906d6.4.2025.12.19.07.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 07:53:34 -0800 (PST)
Date: Fri, 19 Dec 2025 10:53:33 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUV0_TH56QeZIBXU@x1.local>
References: <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
 <aUG2ne_zMyR0eCLX@x1.local>
 <20251219145957.GD254720@nvidia.com>
 <aUVrfs1w6Sg0jfRw@x1.local>
 <20251219152030.GA371266@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251219152030.GA371266@nvidia.com>

On Fri, Dec 19, 2025 at 11:20:30AM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 19, 2025 at 10:13:02AM -0500, Peter Xu wrote:
> > On Fri, Dec 19, 2025 at 10:59:57AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Dec 16, 2025 at 02:44:29PM -0500, Peter Xu wrote:
> > > > > > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > > > > > let me know; some example would be greatly helpful.
> > > > > 
> > > > > Just document the 'VA % order = pgoff % order' equation in the kdoc
> > > > > for the new op.
> > > > 
> > > > When it's "related to PTEs", it's talking about (2) above, so that's really
> > > > what I want to avoid mentioning.
> > > 
> > > You can't avoid it. Drivers must ensure that
> > > 
> > >   pgoff % order == physical % order
> > > 
> > > And that is something only drivers can do by knowing about this
> > > requirement.
> > 
> > This is a current limitation that above must be guaranteed, there's not
> > much the driver can do, IMHO.
> 
> There is alot the driver can do! The driver decides on the pgoff
> values it is using, it needs to keep the above in mind when it builds
> its pgoff number space!

Yeah, if so, it's reassuring. :)

> 
> > If you could remember, that's the only reason why I used to suggest (while
> > we were discussing this in v1) to make it *pgoff instead of pgoff, so that
> > drivers can change *pgoff to make it relevant to HPA.
> 
> What? That's nonsense. The pgoff space is assigned by the driver and
> needs to remain a fixed relationship to the underlying phys the driver
> is mapping in. It shouldn't be changing pgoff during mmap!

I meant, return *pgoff as a hint, not changing the pgoff to be used.. Only
changing the pgoff (as an integer) to be used in the VA calculations.

Thanks for sharing above information to ease my mind, if drivers are all
smart enough (I'll trust you more than myself on driver knowledges!) I
think we're all good..

-- 
Peter Xu


