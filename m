Return-Path: <kvm+bounces-66084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69EE7CC4BB8
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 18:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A18893035D39
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 17:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A256F327C14;
	Tue, 16 Dec 2025 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GumWBLd4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HaklLlg9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ED622B8C5
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 17:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765906579; cv=none; b=a3Z2CVzL6sgy4vI0RbpKs5BUPdKi7YoZMzie+sJJMBTLO6oS5DNswW6IfYN1w2VmvZQofkbgdrbKwQEimHBe7X3XUnXrf0S8hknqqcfXKA3wcXJSkAlnK7qKAMIkpBucA2+RdkaHcPTW5DdopcbFxpBfy1b5S5/WtNuWP650OaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765906579; c=relaxed/simple;
	bh=JZ1GxNJeSzcq+MlfYZbz6YFqFMtBkU/nA7q7A2H9Qnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABWl4ZuQcLPZM8Yk2ndwWvtVaRGnf+miskb0UJCf6zj5EnBH9YvB7P6rYd+yYbzBDE+mB9u4pNNT/3GfrLn18HWUR2VJeZheWFZw/hmwR+ANpzxFUTWyov+31eJeBVDiSYoQJrX3VxwmrO7NMPRUowCfLmCf8pxOOQj/+Bia0is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GumWBLd4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HaklLlg9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765906577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hsPacWIswoNkPxm/WEWv6XOaNR0HsYkw9lp2v40LAGM=;
	b=GumWBLd4z2asNYH0kd6m/qpBaculq4LCb1WaJtYyBSPl+ENrh6ARELjUYIOZY7/ugpCMR1
	SahaYaBHarQtbdWhk/o0/xY8TcyAs4zVaCDY7zUsWjqTTiXgkwYEHKfWHn7CmBQIsNb3pq
	mxz6Jsj0aA2C0lXBJAlURVdIlR0qKnE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-5cBAZH09NmqrBVb8QqYswg-1; Tue, 16 Dec 2025 12:36:15 -0500
X-MC-Unique: 5cBAZH09NmqrBVb8QqYswg-1
X-Mimecast-MFC-AGG-ID: 5cBAZH09NmqrBVb8QqYswg_1765906575
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b51db8ebd9so1640282685a.2
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 09:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765906575; x=1766511375; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hsPacWIswoNkPxm/WEWv6XOaNR0HsYkw9lp2v40LAGM=;
        b=HaklLlg9aYa1SKOel+zBysa7lmPyjc/tTInK9YPWpjHgaGAxCBc7LsTygugXbTz1nd
         WkjfRwr+vxCIp9eXQYUQw4R2zQ5YNXRUUmisvJbGEkucspjG1miNsSvBQ0p3i7957cuU
         31x5OUJJG3Qe5hsvT3SRzJoKYVn0luFoSbDgA3WTc4l9ZnhmqnhYOmlXKGtw6b8Dm5mX
         JQK5AcCpWPfTIfX8CzVgWEUV1Eme/ppaY1Oo/liwG0a4H78julH5YW/fOvvo+044M5o3
         rWDNytxDuwpwts1L5imzW+l6XlXuoTt2ka4KGbWhocgtt1Edk4XZK8g1iIHMVl/4FEjR
         vzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765906575; x=1766511375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsPacWIswoNkPxm/WEWv6XOaNR0HsYkw9lp2v40LAGM=;
        b=gxsFfUJiHL5paZY3N2BZZXSiPOdEB1a2F0IOfvicI/mb23dMO3of8lEyLRpjULY3Q2
         CuNSn995iDjXMZcY0IWLNt1+uasLtjyOWQ+yJyyD9Km/Zp5yQpS3Ok+z0OIsc8pmTE6C
         WESv5bP+nc6cZVAG06Ne+bPXKJ4dtPRuE0J2Z1/ipYBUjnMcjUSsrGIiSxp3qWCejPXi
         bmzO5NS04bDThS21Y/kHNMq2F/bWHyBUkSDzRBsrWgRZIFZhnEw/GEgKtpzQ/NysA6ps
         vhnVL6URYDGxjIEFnJXMhFGdk3BP8FiYsnGWvIRT/LnuMhr5WasRA33tc8kUx/tOgjYJ
         Er2g==
X-Gm-Message-State: AOJu0YzW+m0gnziu6P2EjmuJZsf5+uvTLKoZXj/jcDWVXqCALrhvJHKi
	7Cq0s/Qtd1Adulm5Afgn7HIrZDyaBQpdmMHzROX5AsFJcR5vRVe29tmuv2m35HMPzpDcZgP1YE1
	rkrUvK3udeWddoUPvGDdTaI9jAq9hrmcCHIvpSeOk1V056fBspX/N/Q==
X-Gm-Gg: AY/fxX4jVk1KMaBidcn4YUxefR2koFyE0T73DJL5it80Z1/96P8Tnf1YVHVHOVJ3Lhx
	BIeNsOW1JU+TTngpbwrrK1hFKUMTkttDAejeJ4Cu5ssVgVTPLXphVblgOgLxQ7VhDubaZHJvtrN
	+JVI/cDgikEYJDEBIBqcMPSWsBXl9k090xI9waWVndDmuSYPkjgAy9dyUOoZxSbporSVFlweMgN
	ZaN3/73b/cK2Hdy9OoMJXGm74LDiNYIawPK2aPuiTaL/Uf6ByW6ipQ6qe7WSmVDeKPMIvmTXwrv
	7hf8hEGKbVl0TeBtxdBm1ulUOx2UmFGOnWePkolQYhVaW1Xt850MCzG56ePS6GonLvVNFeAxqOk
	qPTc=
X-Received: by 2002:a05:620a:448b:b0:8b2:f31f:ae20 with SMTP id af79cd13be357-8bb39adbbcemr2032248285a.24.1765906575341;
        Tue, 16 Dec 2025 09:36:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrrAnQyi8tUGXbUTgBDtrC2LqsXXW6sIsNBRadKPa5Jo0RMegb7ho96xN3vIijiKehMDr3nA==
X-Received: by 2002:a05:620a:448b:b0:8b2:f31f:ae20 with SMTP id af79cd13be357-8bb39adbbcemr2032243185a.24.1765906574822;
        Tue, 16 Dec 2025 09:36:14 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8be30d8693fsm225390785a.18.2025.12.16.09.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 09:36:14 -0800 (PST)
Date: Tue, 16 Dec 2025 12:36:13 -0500
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
Message-ID: <aUGYjfE7mlSUfL_3@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251216171944.GG6079@nvidia.com>

On Tue, Dec 16, 2025 at 01:19:44PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 16, 2025 at 10:42:39AM -0500, Peter Xu wrote:
> > Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
> > with len_pad (not len), and pad the retval at last.
> > 
> > Please let me know if it didn't work like it, then it might be a bug.
> 
> It should all be documented then in the kdoc for the new ops, in this
> kind of language that the resulting VA flows from pgoff

IMHO that's one of the major benefits of this API, so that there's no need
to mention impl details like this.

I thought that's also what you wanted as well.. as you're further
suggesting to offload order adjustments to core mm, which I tend to agree.

Here the point is, the driver should only care about the size of mapping,
nothing else like how exactly the alignments will be calculated, and how
that interacts with pgoff.  The kernel mm manages that. It's done exactly
like what anon thp does already when len is pmd aligned.

Or maybe I misunderstood what you're suggesting to document?  If so, please
let me know; some example would be greatly helpful.

Thanks,

-- 
Peter Xu


