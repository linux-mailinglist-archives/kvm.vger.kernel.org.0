Return-Path: <kvm+bounces-49983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 300C4AE0949
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 16:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EF4716377C
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 14:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E4F26F47D;
	Thu, 19 Jun 2025 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WexCz7SK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1792923FC54
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750344917; cv=none; b=hNWddERgqrJhvZowPYgH/SQMAZUUogirja3ARHLwrMisNYN3qoauNs1XFBtMcYz6S6H+OBsyaCBojPPBkrpi0oBYZhPfS+C/zeyQ0W3EMttoEvUhnmhFJM5OHu7StohMt3eBN5sctCbfb4bZt4976GJGXHfDtlzFV5lBTIRSCtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750344917; c=relaxed/simple;
	bh=lSpTfIEsz9+Pa1rTiqnA01KZPNUjGiqXdkwSBDLfJFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RA2tveBP57gNE9JsJB2sDLD4wBi3hfWB0g4ehe/NBkkFitm9UrT5CbC5mFPrLa2uyBD0f3NceNb7vEGZ7MjCE5DFyWHfLnnX7TFvRgy/w2GKm4xKw6JznO7ALty8pi0htZRMzM+AcEWwE9jKAS9Bnxm1wskw+0bHEdgTA190CBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WexCz7SK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750344910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nIR3s6WyChuWWIwaj4SIlo+aTHkYFJ52GIb7pLAwAo=;
	b=WexCz7SKhON+PQAsghwU36Bvq3uS+y/DvykHR0o89/vawugxx0D1oOPLQHjYMfR2PR4mG/
	r6oulGBqZECBmFDuzj72UDMwvUw+SjzjZCg30ajv7YolCXRPDMcRvPKhiRllCCbJ5hw+TK
	RD0ep771lP7mg/1Odu2YctpuyEPTWus=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-edzOMZcjNiyN8OyJE5jxfQ-1; Thu, 19 Jun 2025 10:55:06 -0400
X-MC-Unique: edzOMZcjNiyN8OyJE5jxfQ-1
X-Mimecast-MFC-AGG-ID: edzOMZcjNiyN8OyJE5jxfQ_1750344906
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c760637fe5so133859985a.0
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 07:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750344906; x=1750949706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+nIR3s6WyChuWWIwaj4SIlo+aTHkYFJ52GIb7pLAwAo=;
        b=oOZzji6jLYIdKQRDuCTdp3uobpgn/NiNlQRZKhVbkp0aM4rvlamVfCXNIPxpyTMzrG
         3t3ArwSIGyRmyXPepdeblm/K2CzRPf67VhBEwKX10UZg7M4LpqtAExPt4Ao01aeaOfVm
         6YAcQe2PoeKSNtJQT54R7QJWrS5Qry9Tfa18v9GZhKDCNWwwwjHURFClU5mx8yEAm5M3
         tTpE8mxbu1XS4SCH1X+Zp6uNYDMMxRGMTcXsTkCTKVEfIuSF8R8D6EyiMDhAziwl5pSw
         hiMHxHdshOMv4kGPNc/K7Mo/w+L4iEC2ks2GkF1ToVZVfGIWYFKsAIEJWM1+TAhzyAQy
         Oljg==
X-Forwarded-Encrypted: i=1; AJvYcCUGGN8AcIK8dtE83++Pygsf+d6M2jwQJrzpk2eYH91xowXm4iGZsVfB8ndGcEYramt2QPw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlGEoeSKsfZXRh//z9h1JeS9d44zYbAqTz7GuCxT/kBGGXDh2H
	cTnBx4lVtw7QOG/dtC/XMqusX0IXK4p36nXuQA5KV3AOuUdriWtxgArPIemhNRLc+PPPobG47Jw
	ihlz0hT59V0rRK1O7OE2/mZHKS1yncOXfCNHDul8X93GTLJdvuZlsAw==
X-Gm-Gg: ASbGnctMjmO3G1a9dR/PnmZSGGhAjzjnWYbWQYb2DxQxZKeL+bzQ79QhclVroQcBwHn
	vlCyBDxk1XqU+OauMcTUe3vcR0ruPC71UidtZd3YJYTBlqgFPqSEX5epNeYWkaVBRodbK5evk8U
	BfnAW6cbr/YnK9BoSquMzSn3jeeHEld9weqC9fjwWnxD9AvaPd0ywvf97DtgCRrJEsjmoUWmLCI
	0gQsOQB/PvvwgvFAKrDiZ5RiBOFwXLKzD66Hs79pp+21MTBXpo73b+e5aikP49XIjvw3gDLLXzB
	RFZZ3kkBwvFamw==
X-Received: by 2002:a05:620a:40cb:b0:7d0:97b1:bfa with SMTP id af79cd13be357-7d3c6c0d376mr3689365685a.8.1750344905706;
        Thu, 19 Jun 2025 07:55:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFzfYtvhWciWVVF5GyT6JlUpid1yuToLPfDm2d7WEu2TrPd8D0c+sMxu0V7+LQLYejLfKHqA==
X-Received: by 2002:a05:620a:40cb:b0:7d0:97b1:bfa with SMTP id af79cd13be357-7d3c6c0d376mr3689362885a.8.1750344905302;
        Thu, 19 Jun 2025 07:55:05 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3f8e5ac5esm4759385a.79.2025.06.19.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 07:55:04 -0700 (PDT)
Date: Thu, 19 Jun 2025 10:55:02 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aFQkxg08fs7jwXnJ@x1.local>
References: <20250613231657.GO1174925@nvidia.com>
 <aFCVX6ubmyCxyrNF@x1.local>
 <20250616230011.GS1174925@nvidia.com>
 <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
 <aFH76GjnWfeHI5fA@x1.local>
 <aFLvodROFN9QwvPp@x1.local>
 <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
 <20250619135852.GC1643312@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250619135852.GC1643312@nvidia.com>

On Thu, Jun 19, 2025 at 10:58:52AM -0300, Jason Gunthorpe wrote:
> On Wed, Jun 18, 2025 at 03:15:50PM -0400, Peter Xu wrote:
> > > > So I changed my mind, slightly.  I can still have the "order" parameter to
> > > > make the API cleaner (even if it'll be a pure overhead.. because all
> > > > existing caller will pass in PUD_SIZE as of now), 
> > > 
> > > That doesn't seem right, the callers should report the real value not
> > > artifically cap it.. Like ARM does have page sizes greater than PUD
> > > that might be interesting to enable someday for PFN users.
> > 
> > It needs to pass in PUD_SIZE to match what vfio-pci currently supports in
> > its huge_fault().
> 
> Hm, OK that does make sense. I would add a small comment though as it
> is not so intuitive and may not apply to something using ioremap..

Sure, I'll remember to add some comment if I'll go back to the old
interface.  I hope it won't happen..

> 
> > So this will introduce a new file operation that will only be used so far
> > in VFIO, playing similar role until we start to convert many
> > get_unmapped_area() to this one.
> 
> Yes, if someone wants to do a project here you can markup
> memfds/shmem/hugetlbfs/etc/etc to define their internal folio orders
> and hopefully ultimately remove some of that alignment logic from the
> arch code.

I'm a bit refrained to touch all of the files just for this, but I can
definitely add very verbose explanation into the commit log when I'll
introduce the new API, on not only the relationship of that and the old
APIs, also possible future works.

Besides the get_unmapped_area() -> NEW API conversions which is arch
independent in most cases, indeed if it would be great to reduce per-arch
alignment requirement as much as possible.  At least that should apply for
hugetlbfs that it shouldn't be arch-dependent.  I am not sure about the
rest, though.  For example, I see archs may treat PF_RANDOMIZE differently.
There might be a lot of trivial details to look at.

OTOH, one other thought (which may not need to monitor all archs) is it
does look confusing to have two layers of alignment operation, which is at
least the case of THP right now.  So it might be good to at least punch it
through to use vm_unmapped_area_info.align_mask / etc. if possible, to
avoid double-padding: after all, unmapped_area() also did align paddings.
It smells like something we overlooked when initially support THP.

Thanks,

-- 
Peter Xu


