Return-Path: <kvm+bounces-49474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CA2AD9478
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A09561BC2BEC
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544FB236457;
	Fri, 13 Jun 2025 18:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BiD3JfXr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BB42236FC
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839490; cv=none; b=VWpL7gocmexxc7JF7wQyEfuHnYlh6PyArQm62gHqG2R5Qhpdu1eP3r0I5vxK3rhrpLIxb/gCd8PNbALLkOht58bksXw+YNjLMShH0fDPm1WM95LXGSIcgxIE66a7KOW0uQ/+ZXFyl7YsZpa7OBb2yeLRFddR3H3bgJIx4AuqHoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839490; c=relaxed/simple;
	bh=0Xnneww3/PFszSCOvv5j2eaodIflSS1NySvaG/CLxVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELcOT9tYyanQyhAf8oLNweE1lM/vSEhTZuSR8GlhAsAmJD5lT59BHoXg3hhh81CXeBLgSoYLZ131Hb/sp+yoo9QkvOsh4bY77ajgZACZJkZlPzOy5itFsCxFnW7LF/atbH3i9Ua3l93UiAOy8E6PnbPfnNvCH8FDYdQyf7aHljE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BiD3JfXr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749839487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ABrGU8rVjmHN2cPq2PVD204TdB4R7E4BJeclzHtUZeU=;
	b=BiD3JfXraD/5dL3k5/Ekyq+qIAp5wcRkH1qxq2gkRBnFJUN/t1WU70SP8XF4jjInBicfis
	W2z68xG/JGyaPzxQh3M18rw8wB9YyNl0lYJoTBWq3t63+fjIImf6S3vw8NFXJ26SHOLIRf
	RMPB/gdyWRLn94a2gra7AKSP0OUuEP8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-ZXDsWOG4NOeIJ9QXLbCEpw-1; Fri, 13 Jun 2025 14:31:26 -0400
X-MC-Unique: ZXDsWOG4NOeIJ9QXLbCEpw-1
X-Mimecast-MFC-AGG-ID: ZXDsWOG4NOeIJ9QXLbCEpw_1749839486
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6fac45de153so34682246d6.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 11:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839486; x=1750444286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ABrGU8rVjmHN2cPq2PVD204TdB4R7E4BJeclzHtUZeU=;
        b=bR1rLn85Ml1KdeW74l6ZHZHn9Yu5om9sjHXA9ty8Exz+YL2oAt5uiEYrIA/WyP4Axv
         lFPQQHkjRFx7DqfdPaSfhGtwA+Om65lCEyURG+4XEoi/5l5WIgJzKfHJWJoDa1xe76j9
         wFHMWuUJkzLj3XJCpYF1IMW2pzhgaIhmnqLR8sUJ8S6X8wJ6OrEBw6eYU8zVNfAqvukL
         I+ZaJzsmzhvu/1HWRMm21BsjroCN5ddTWCNOnGJz+b8ZgTmuJ1AnqE5zzrsVJq6zqbf/
         yPRLUzaq+0u8YZ4F3155PU3iW4ZJ6qLe68kRLMC1dAmbGLx6suzKuFhHAA+/zT+okKEb
         atOw==
X-Forwarded-Encrypted: i=1; AJvYcCXXTQg2DFz4XbqI9tX/i9pd2ozNiLPFcV+qbMBc5P9s5UpEfUKzcum2022fpvO/hDy6+fU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW1jWzP+bFrlsHnSLGc5mp03su0Z9LLYh30/i9/Akm5MivP7pt
	nfsmU1ftpwLwtc/9cS8qNQhbJepIX6SsOSKNr/asZiP/HSCJWwCvO3uuJjh5j4XwRR5JowUcMnQ
	mBUiIB2APccjpk7jLGzuCUnS5Uye7apkw70sGauT7fPszSN+6g/g5/A==
X-Gm-Gg: ASbGnctmYf6Mj2kGKo6jiEkXx68LG+cSV9AG+khddG9vmS17FdfK5+8c9TTCv9TvuY+
	ZK55HsWt+41sRa1q8Hv4JLqdfjKGYBSZodmy0VyezSwHkcSM0WMhQf9YWTq4wOELq9Dqx3LEtpE
	p0DrdqxDEc0aXnmUDXmhtXllPf9KUWjGoBHGj+gIzHNT/LODVXLEP2qLtPkE+vb8ZoQUYbSaLkH
	Je3os8rTyy4syXdombwl2nNm/3oQPKvLjMr0BMOhFS6vXvHX2GtGjlcSyFHyGFXCiGmwzt17WcB
	yPej4zxYSgSHuA==
X-Received: by 2002:ad4:4ea7:0:b0:6fa:d956:243b with SMTP id 6a1803df08f44-6fb477926d9mr6788166d6.37.1749839485948;
        Fri, 13 Jun 2025 11:31:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJOS9hRKQi3Bj5CwhVVbf6JvljFhJrSLc5HsQ6rHSGhKFYSvsg6Z6aF2Ee1Sxv4NazF/xpCQ==
X-Received: by 2002:ad4:4ea7:0:b0:6fa:d956:243b with SMTP id 6a1803df08f44-6fb477926d9mr6787716d6.37.1749839485531;
        Fri, 13 Jun 2025 11:31:25 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35c315cbsm24603416d6.67.2025.06.13.11.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:31:24 -0700 (PDT)
Date: Fri, 13 Jun 2025 14:31:21 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <aExueZPrt7z-jRdc@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <20250613141745.GJ1174925@nvidia.com>
 <aExANjUUpmkpo3p4@x1.local>
 <20250613160020.GM1174925@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250613160020.GM1174925@nvidia.com>

On Fri, Jun 13, 2025 at 01:00:20PM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 13, 2025 at 11:13:58AM -0400, Peter Xu wrote:
> > > I didn't intuitively guess how it works or why there are two
> > > length/size arguments. It seems to have an exciting return code as
> > > well.
> > > 
> > > I suppose size is the alignment target? Maybe rename the parameter too?
> > 
> > Yes, when the kdoc is there it'll be more obvious.  So far "size" is ok to
> > me, but if you have better suggestion please shoot - whatever I came up
> > with so far seems to be too long, and maybe not necessary when kdoc will be
> > available too.
> 
> I would call it align not size

Sure thing.

> 
> > > For the purposes of VFIO do we need to be careful about math overflow here:
> > > 
> > > 	loff_t off_end = off + len;
> > > 	loff_t off_align = round_up(off, size);
> > > 
> > > ?
> > 
> > IIUC the 1st one was covered by the latter check here:
> > 
> >         (off + len_pad) < off
> > 
> > Indeed I didn't see what makes sure the 2nd won't overflow.
> 
> I'm not sure the < tests are safe in this modern world. I would use
> the overflow helpers directly and remove the < overflow checks.

Good to learn the traps, and I also wasn't aware of the helpers.  I'll
switch to that, thanks!

> 
> > +/**
> > + * mm_get_unmapped_area_aligned - Allocate an aligned virtual address
> > + * @filp: file target of the mmap() request
> > + * @addr: hint address from mmap() request
> > + * @len: len of the mmap() request
> > + * @off: file offset of the mmap() request
> > + * @flags: flags of the mmap() request
> > + * @size: the size of alignment the caller requests
> 
> Just "the alignment the caller requests"

Sure.

> 
> > + * @vm_flags: the vm_flags passed from get_unmapped_area() caller
> > + *
> > + * This function should normally be used by a driver's specific
> > + * get_unmapped_area() handler to provide a properly aligned virtual
> > + * address for a specific mmap() request.  The caller should pass in most
> > + * of the parameters from the get_unmapped_area() request, but properly
> > + * specify @size as the alignment needed.
> 
>  .. "The function willl try to return a VMA starting address such that
>  ret % size == 0"

This is not true though when pgoff isn't aligned..

For example, an allocation with (len=32M, size=2M, pgoff=1M) will return an
address that is N*2M+1M, so that starting from pgoff=2M it'll be completely
aligned.  In this case the returned mmap() address must not be aligned to
make it happen, and the range within pgoff=1M-2M will be mapped with 4K.

-- 
Peter Xu


