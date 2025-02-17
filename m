Return-Path: <kvm+bounces-38391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0356BA38E4E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 22:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9F1C3B0B2E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 21:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFC31A5BA5;
	Mon, 17 Feb 2025 21:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HR+R4ZLu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73426224F0
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 21:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739829151; cv=none; b=TIR5hqdnPnN5KQtB2H+z6yBpiyqjZXhh94QmerGoEdcJ2Z7vZHIDtAcSR0DQCggVHPXIJxODb+etp0zhcA93iKc245YzGvuXslDiPH0AfEbqsUnCdzOQknGoWzQlNCtbbXWhVcSt+T6u6MfteVVshJ+14jfbgrcAbdB5HBWRp0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739829151; c=relaxed/simple;
	bh=5A/eoP0FjR04mTWc33USNK/LsikyDThap9qxzPVPIDk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2LNF+wQs9xQLuYVktJZfHDoskMGPpWhoBfZmWGP2wShMlvh1cCTVZgx6xTdCai2ZBbyJ/VSU9ovRXqPZ4ZI/3H4HTbp/SxwYGM+wn2zhoQ1B8wAzIp0w6VkXUVnBWpKCqGUpI8YAPMcXcrMoNSeRdwhw3yxfyFdVxvtuFySEKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HR+R4ZLu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739829148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SxDh0EJ+8MUCjnDi1tBCK0C6PrjOgADbhlB47WIcbEI=;
	b=HR+R4ZLuiop9hUXsdYJchr+A2Xx0pG/2tAZhkvHMZGEk5SXzPPQDA7HVCcZCxHiGQXDN8C
	A1GVdgcjjKDavlWUu5F7jCBvrxy5KM+YNFUUtJ+D6U8DdMnKX2b4C+xmcEo1IvnKf/vlmx
	N2C/8S2HeiXJ/++GGeRZ1OuirZnovMs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-W1y0qvluPhSAaQITl_CAXA-1; Mon, 17 Feb 2025 16:52:27 -0500
X-MC-Unique: W1y0qvluPhSAaQITl_CAXA-1
X-Mimecast-MFC-AGG-ID: W1y0qvluPhSAaQITl_CAXA_1739829146
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d18f59b9d0so3747535ab.2
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 13:52:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739829146; x=1740433946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SxDh0EJ+8MUCjnDi1tBCK0C6PrjOgADbhlB47WIcbEI=;
        b=qWBwwQUE9YxYcVKBUqYQUkxXiVpEg9cvd46boddrxX2ErgcTooj+jI+8kZlRgJchtz
         1Hc8j2MwS9X3AsBahHspJn9HVGcgaTgtiIYIBQXzJ71geFis8Isu8PpTmI2Ir791Uv0v
         goPv/OaIjTo+/2NixXzoi9LY57WNESMlHSzeR1WvPnB6Q2FB/JtbONhGv+r6WpyrEhiw
         LSG1Ex88LKv5CQZIyql2c1q8jwpUtySsWabt8xC56xhR27DNcwUxDwUVAndZzHbMo+VG
         0cgjUkFfKR/uQjr16DYjFEgATjcG2lEqk89Rt1RmVgK1fLqiaVepMHcWTCuOcLWCaIKl
         46FA==
X-Gm-Message-State: AOJu0Yxoxc0+Yv1m5iMAcNppNr+x12Rx4Qj8awVVF5VFqL8UXTYwhSTR
	HL7iZsyKbQNd8kKTU1+0zo6zCy3BDH0LxtaqC5Ryn92gG7Sp7bz08m+hHjQgmdD+84d4OiMGKBh
	nZqVOng8vH/hSTbsCi0FbA5ckFf0i9uemoAmxM2NB9BtYNyLVHg==
X-Gm-Gg: ASbGncve2DiyTmdrI0aTnAFJ90HvNfce00bBbGbt1ryvz3ttARMzg5lQGshoIyMlNVA
	J+DdLYpyx1vhjja6PgBLR7UHOVK4vmax4Ikm9gGKXgFNbuwUp2wwy4bBanMFPHxEirhUHxT7W0i
	VxjC+W2561lqMJlCReZOiRH5zWe3Lau0bNAyySWfavYS5llmQkuAosjiiXW+M620mvsJp1LhGDz
	B2Z9IZlw8cbCu2QUiHHeM/ODMtZxdpJvmMxTHu63qIVYNbSJ62b8mALatG7bJ9UFrOfV9h2M+PV
	NBj2nGqL
X-Received: by 2002:a05:6e02:8:b0:3d1:9236:ca49 with SMTP id e9e14a558f8ab-3d2796851eamr27424015ab.0.1739829146277;
        Mon, 17 Feb 2025 13:52:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFP4VXmbfSBjTKUdOsf+KSjwWeNwg2r4M9vtE2mjCOTGm7KPENFhTB2d63tVL9BSSKWgsj0lA==
X-Received: by 2002:a05:6e02:8:b0:3d1:9236:ca49 with SMTP id e9e14a558f8ab-3d2796851eamr27423965ab.0.1739829145936;
        Mon, 17 Feb 2025 13:52:25 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d28b060646sm10369835ab.16.2025.02.17.13.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 13:52:24 -0800 (PST)
Date: Mon, 17 Feb 2025 14:52:21 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
 mitchell.augustin@canonical.com, clg@redhat.com, akpm@linux-foundation.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 5/5] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <20250217145221.20f17b7a.alex.williamson@redhat.com>
In-Reply-To: <20250214192704.GD3696814@ziepe.ca>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
	<20250205231728.2527186-6-alex.williamson@redhat.com>
	<20250214192704.GD3696814@ziepe.ca>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Feb 2025 15:27:04 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, Feb 05, 2025 at 04:17:21PM -0700, Alex Williamson wrote:
> > @@ -590,15 +592,23 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> >  	vma = vma_lookup(mm, vaddr);
> >  
> >  	if (vma && vma->vm_flags & VM_PFNMAP) {
> > -		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
> > +		unsigned long pgmask;
> > +
> > +		ret = follow_fault_pfn(vma, mm, vaddr, pfn, &pgmask,
> > +				       prot & IOMMU_WRITE);
> >  		if (ret == -EAGAIN)
> >  			goto retry;
> >  
> >  		if (!ret) {
> > -			if (is_invalid_reserved_pfn(*pfn))
> > -				ret = 1;
> > -			else
> > +			if (is_invalid_reserved_pfn(*pfn)) {
> > +				unsigned long epfn;
> > +
> > +				epfn = (((*pfn << PAGE_SHIFT) + ~pgmask + 1)
> > +					& pgmask) >> PAGE_SHIFT;  
> 
> That seems a bit indirect
> 
>  epfn = ((*pfn) | (~pgmask >> PAGE_SHIFT)) + 1;
> 
> ?

That is simpler, for sure.  Thanks!

> > +				ret = min_t(int, npages, epfn - *pfn);  
> 
> It is nitty but the int's here should be long, and npages should be
> unsigned long..

Added a new patch that uses unsigned long consistently for passed page
counts and long for returns.  Now we just need a system with a 16TiB
huge page size.  Thanks,

Alex


