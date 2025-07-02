Return-Path: <kvm+bounces-51341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC398AF63A2
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:00:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73DAA3AA5E3
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE47B279DCE;
	Wed,  2 Jul 2025 21:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TdyeUvUd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C14A279794
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 21:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751490004; cv=none; b=ZVsD6PWf8vl/6mUrW/jwsRdUvnlrYPgBFiuuaanWxiMW7ZYkJuGVIWmeCV082y6vkiRbtERrI0eTw541N+SG/Z+9w8mfMa0cWT+0sH78TruaOcGZfz47S2tEFopb9t+5amQvJytW5cQvuXYGMimFo7QF9fFYTuPNThtGYuM4EOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751490004; c=relaxed/simple;
	bh=eTPngYW+xIIJsPFNulV3zvN+v6Iqt2lDwz2DaFgqNr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwRK5h9X3xFuatoqe5XW+yxJuSzalfzF5vLuODUpVhLE1hr6tAz0vTr/i6FlmV/FM4sOzvjzEzhaga11O7H99qiVJmPbjTnDdy71lTKHYCrk9MO4aVPpcpR/LRcAVM2jqguh4UwkTCwiXu2q6yZyVa9L5pOwzMnT2Gr6wBkHu9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TdyeUvUd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751490001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WOTU+d2v5BAWQ3IDOfILW9WYtvyZL2oUTXZsgcEBv+A=;
	b=TdyeUvUd9da0Wuz/9PraOC8zCrbqc0v8hh7Fj6jHULXox1EBKvVoaLpr0krTF3jY6pvwDb
	QQuH7UhlOGHXIkct1hxLqbHnmgF6edY0So8ZfY+EsfGBn1fGrMGsSsaCwlRlLQQiWLAXSJ
	sHwVoIJGVx0h48h9zFGx0532MoECd9g=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-TAoWYlJsOr6pHVBXuQQwEw-1; Wed, 02 Jul 2025 16:58:51 -0400
X-MC-Unique: TAoWYlJsOr6pHVBXuQQwEw-1
X-Mimecast-MFC-AGG-ID: TAoWYlJsOr6pHVBXuQQwEw_1751489931
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6fabd295d12so138489686d6.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 13:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751489931; x=1752094731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOTU+d2v5BAWQ3IDOfILW9WYtvyZL2oUTXZsgcEBv+A=;
        b=hYpgpeR4Wc9Ake43er4qSCRPBvm08uq4psYE7Et9O+WRms+FoEL82ZFUuFIfbhkp6J
         mDs2Euh4yRsORB1ZGY1GPwfXtMe+ubZ+BY/XPW47rXhnj+JRWa8LnrSG8rgdQedVmSUm
         V5NSgnTWsnk3S65PxVlVrZu3pMRv3RY26pfosDtztQNpQmka26MjD8tdU26O5sjqfKBp
         yl7S5L8j2MJWLRZMeXqG3OsgEDqdKIA2o+7TuoMgSsjWho4ivNiS9rPCoR8+WTaG5M3k
         SpBMvQPK82y1ksB2F5vkmkbim8+WC8OQu3fqvqjay/jWetaR5CWcPMzdzIoc+B7VSoWu
         k/Kw==
X-Forwarded-Encrypted: i=1; AJvYcCWNTNJhI25FgWDFBXZ3kieaIEVyh+NY+C7YL1P1vpsr2BqgS7L1D710yxx81SFBAjNMafw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy7+hz7AA56BeQYiP/8/yU0JbCxrUZATnmEdYXJaYItZEz1utB
	+QLMuetE2SCA168bK8n4OOglmnpQwm2l+ejJrLWm2WXntaZ6/jpHyr7U4A5wMG1gY9+zh2RQo44
	A45jiams4NpqiOOJR8NcZcYhrDzVtcgrTqSOvY16CmGppfZJxxJUBkQ==
X-Gm-Gg: ASbGnctVrX1pBP5ZjyDrhqYFc8S2zD84uMzxfZmJTxL5GJ86LcwK60BLoxc+BFuZH5C
	XsClyiH26yi5VErSgJi+olegsuzDZjx1ule38d/UzhpsQ9JUnOpD3IzOv+cNcq19yDHOeqHQIxM
	aRIwklF3Hzss6cp59xW6UUuiMqcuaaHHYazcwVCBUqnVx+7yDf3nII9YqHdz9KGFY2EiHRcDNZ+
	aEY/ZironYBTgGR4zhMo7m1+akxxuOmQUM/s56Yf4oWzgAkD20izfXPEjzbvUxj5LaiNcHqh8rz
	SXN8iXirP/paew==
X-Received: by 2002:a05:6214:2aa7:b0:6f8:e66b:578e with SMTP id 6a1803df08f44-702bcc67924mr11063146d6.32.1751489930988;
        Wed, 02 Jul 2025 13:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+QOp1gP5d1ygXeemNGH1JhDJQDSPwFCZsqWpTNaKH+tPWObjk5CcB+1Hqk3D9Ifq7DRzEeg==
X-Received: by 2002:a05:6214:2aa7:b0:6f8:e66b:578e with SMTP id 6a1803df08f44-702bcc67924mr11062776d6.32.1751489930414;
        Wed, 02 Jul 2025 13:58:50 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd7718da94sm106707176d6.24.2025.07.02.13.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 13:58:49 -0700 (PDT)
Date: Wed, 2 Jul 2025 16:58:46 -0400
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
Message-ID: <aGWdhnw7TKZKH5WM@x1.local>
References: <aFQkxg08fs7jwXnJ@x1.local>
 <20250619184041.GA10191@nvidia.com>
 <aFsMhnejq4fq6L8N@x1.local>
 <20250624234032.GC167785@nvidia.com>
 <aFtHbXFO1ZpAsnV8@x1.local>
 <20250625130711.GH167785@nvidia.com>
 <aFwt6wjuDzbWM4_C@x1.local>
 <20250625184154.GI167785@nvidia.com>
 <aFxNdDpIlx0fZoIN@x1.local>
 <20250630140537.GW167785@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250630140537.GW167785@nvidia.com>

On Mon, Jun 30, 2025 at 11:05:37AM -0300, Jason Gunthorpe wrote:
> On Wed, Jun 25, 2025 at 03:26:44PM -0400, Peter Xu wrote:
> > On Wed, Jun 25, 2025 at 03:41:54PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Jun 25, 2025 at 01:12:11PM -0400, Peter Xu wrote:
> > > 
> > > > After I read the two use cases, I mostly agree.  Just one trivial thing to
> > > > mention, it may not be direct map but vmap() (see io_region_init_ptr()).
> > > 
> > > If it is vmapped then this is all silly, you should vmap and mmmap
> > > using the same cache colouring and, AFAIK, pgoff is how this works for
> > > purely userspace.
> > > 
> > > Once vmap'd it should determine the cache colour and set the pgoff
> > > properly, then everything should already work no?
> > 
> > I don't yet see how to set the pgoff.  Here pgoff is passed from the
> > userspace, which follows io_uring's definition (per io_uring_mmap).
> 
> That's too bad
> 
> So you have to do it the other way and pass the pgoff to the vmap so
> the vmap ends up with the same colouring as a user VMa holding the
> same pages..

Not sure if I get that point, but.. it'll be hard to achieve at least.

The vmap() happens (submit/complete queues initializes) when io_uring
instance is created.  The mmap() happens later, and it can also happen
multiple times, so that all of the VAs got mmap()ed need to share the same
colouring with the vmap()..  In this case it sounds reasonable to me to
have the alignment done at mmap(), against the vmap() results.

> 
> > So if we want the new API to be proposed here, and make VFIO use it first
> > (while consider it to be applicable to all existing MMU users at least,
> > which I checked all of them so far now), I'd think this proper:
> > 
> >     int (*mmap_va_hint)(struct file *file, unsigned long *pgoff, size_t len);
> > 
> > The changes comparing to previous:
> > 
> >     (1) merged pgoff and *phys_pgoff parameters into one unsigned long, so
> >     the hook can adjust the pgoff for the va allocator to be used.  The
> >     adjustment will not be visible to future mmap() when VMA is created.
> 
> It seems functional, but the above is better, IMHO.

Do you mean we can start with no modification allowed on *pgoff?  I'd
prefer having *pgoff modifiable from the start, as it'll not only work for
io_uring / parisc above since the 1st day (so we don't need to introduce it
on top, modifying existing users..), but it'll also be cleaner to be used
in the current VFIO's use case.

> 
> >     (2) I renamed it to mmap_va_hint(), because *pgoff will be able to be
> >     updated, so it's not only about ordering, but "order" and "pgoff
> >     adjustment" hints that the core mm will use when calculating the VA.
> 
> Where does order come back though? Returns order?

Yes.

> 
> It seems viable

After I double check with the API above, I can go and prepare a new version.

Thanks a lot, Jason.

-- 
Peter Xu


