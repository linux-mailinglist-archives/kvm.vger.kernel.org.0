Return-Path: <kvm+bounces-38384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 292AFA38C89
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 20:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 533A2172CD2
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 19:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD69B1624F9;
	Mon, 17 Feb 2025 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fjsQM186"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E34223716F
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739820814; cv=none; b=iiJ9twKkuz1suOs53ktdt+PISEwrD8zZernh7JWnqdtbnoC1J4OssI37bgVB+mm9b5LM6i3yIp5ZsXO0DH6Bwy2kzczbmPrG1F8n43FQ+VygG8aG5TVZSLoifFqm+WFyEVTZnW0sWrQC9pj1UwLH2bV5BbjAh0wMOIqr0YJv5UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739820814; c=relaxed/simple;
	bh=ucDT6GBoStqHJkT20mNRRHWAgRMK5N5IVHD1p8ta3UI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/f4r2mIcDLF5ld8TOAh80UvgLbvdM7eaadYCgYY8xdnVApSHj060yS0IMrPgxPMFqh3bTGi+aR3YWAMYgGzdXGRps8PnwPqd7j3TuiThH5NPnEAXW4gYwDSntWyThj3uzngO1vcbTEyBCxn7QJU9uoc4MbcMHvQAIOQlPAwBjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fjsQM186; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739820810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kZtNzwN6oYPBtUXvcoMEcoLIKVzDBplhjbvzZSyIho0=;
	b=fjsQM186aXjhLdtUQG+en81jOYqMsi4BzND28Db7vBPDu1pIsPYHafcwARS0iay+jPhnv7
	UFvqHdHiHscOqgMJT+jBw/MiKNyORWWYxFyuhsX1vhpgZtEfhO9GxW06Qk1Rht2vcPgH/F
	Q4WyRnzpxT6aB/x3b7SChP2caWthjdg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-BQJO51cOOCi17jO7pmuvig-1; Mon, 17 Feb 2025 14:33:27 -0500
X-MC-Unique: BQJO51cOOCi17jO7pmuvig-1
X-Mimecast-MFC-AGG-ID: BQJO51cOOCi17jO7pmuvig_1739820806
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-84f54d63095so23039139f.2
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 11:33:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739820806; x=1740425606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kZtNzwN6oYPBtUXvcoMEcoLIKVzDBplhjbvzZSyIho0=;
        b=Irz7wKz/0l+xuDLNVMNIn6qIn39n5DYSQg+5N8quih7R7crw4tKoPywQMCX4EgJwyU
         3FafLGUTE+3pC9qxDN71KlHXnLNBWuDAT6WYpFiyixPLJDy4NfDIYkgbwlvsFUW5StrL
         /2rUm+4TVlB2XvVTWDfT6lvhGDEYxmVHfKVW6xsYI7s8FhRvcgivkCeJj77wY+gHSlt/
         7iu9LAZ6o4/p658wWte79gu4fRKOYLvT8WpogTXnHDcBUsBcEwMqG2AMSEiLMkFT9ztG
         sPPT0JosmObXWh9DEjSk8ipI9t7t35efYYcfYyrS2oRFFV0yNvK1k+BpjMFpjdfurGXS
         k7aA==
X-Gm-Message-State: AOJu0YyYkVss+tmTgRk6l+oWwjDOLfNUgBbcmNlvPBXgDwEKphd4q5EY
	Klp4tY25bq//J10cxaRcvuqAfMw8fuhaU25r3+6r7adUARdbSm4KJ5M2D2d9nk+tIpttM+DF+oz
	yaVBouTscL4mdMuqnNw3p+T+Hn+QKddn3x7UCXPuM3V0yYsxvig==
X-Gm-Gg: ASbGncs7ArrV6Mp+lafg7cqc8mnVn4Uq2I6tNdAOLsTjAVZavzF1jv+S5lan+/pjQH6
	Bbc5eI3WlmpXtQ7zdopUPropxVNfe49eZsQGQ1tRD+xivvGhxo0lMlGGtx12k2rnh226C/VFu2Y
	YtAmXQNn9iqHA+e0br5TFUe331kLJvoRKea7NLtWhuOllGNfxyeMYSltb40lx0XcT2gV3WtZwfg
	scf79Xbb54y+yg+R5xkD33apggPekzVfea0tZ/tdDuXgaozEV9kNxTgLlcCKknd/APcdxgTpZeJ
	Cm0rwlPp
X-Received: by 2002:a05:6602:6408:b0:855:505:e2c5 with SMTP id ca18e2360f4ac-8557a0c198emr258971039f.2.1739820806425;
        Mon, 17 Feb 2025 11:33:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFf69rFpHRBRUkpc6IQnX+RrUwLEtxZ5WL2tBVyd6sRG7DiWOFIsmQLCd6imqOjjp0RP03prA==
X-Received: by 2002:a05:6602:6408:b0:855:505:e2c5 with SMTP id ca18e2360f4ac-8557a0c198emr258969839f.2.1739820806146;
        Mon, 17 Feb 2025 11:33:26 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85566f8f7f6sm203761239f.42.2025.02.17.11.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 11:33:24 -0800 (PST)
Date: Mon, 17 Feb 2025 12:33:20 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
 mitchell.augustin@canonical.com, clg@redhat.com, akpm@linux-foundation.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 5/5] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <20250217123320.051fad67.alex.williamson@redhat.com>
In-Reply-To: <Z6-djlOXYTDU12mc@casper.infradead.org>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
	<20250205231728.2527186-6-alex.williamson@redhat.com>
	<Z6-djlOXYTDU12mc@casper.infradead.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Feb 2025 19:46:22 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> On Wed, Feb 05, 2025 at 04:17:21PM -0700, Alex Williamson wrote:
> > +			if (is_invalid_reserved_pfn(*pfn)) {
> > +				unsigned long epfn;
> > +
> > +				epfn = (((*pfn << PAGE_SHIFT) + ~pgmask + 1)
> > +					& pgmask) >> PAGE_SHIFT;
> > +				ret = min_t(int, npages, epfn - *pfn);  
> 
> You've really made life hard for yourself by passing around a page mask
> instead of an order (ie 0/PMD_ORDER/PUD_ORDER).  Why not:
> 
> 				epfn = round_up(*pfn + 1, 1 << order);
> 
> Although if you insist on passing around a mask, this could be:
> 
> 				unsigned long sz = (~pgmask >> PAGE_SHIFT) + 1;
> 				unsigned long epfn = round_up(*pfn + 1, sz)
> 

Hey Willy!

I was wishing I had an order, but I didn't want to mangle
follow_pfnmap_start() and follow_pfnmap_setup() too much.  Currently
the latter is doing:

	args->pfn = pfn_base + ((args->address & ~addr_mask) >> PAGE_SHIFT);

If follow_pfnmap_start() passed an order, this would need to change to
something equivalent to:

	args->pfn = pfn_base + ((args->address >> PAGE_SHIFT) & ((1UL << order) - 1));

Looks pretty ugly as well, so maybe I'm just shifting the ugliness
around, or maybe someone can spot a more elegant representation.
Thanks,

Alex


