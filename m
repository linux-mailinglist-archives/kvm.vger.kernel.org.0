Return-Path: <kvm+bounces-12450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB4A88636F
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A375B21DE1
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149E779F9;
	Thu, 21 Mar 2024 22:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dnT/TDYG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D13717CD
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 22:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711061207; cv=none; b=thw+E3js8o2jqUFh12OGj34g4SA4FR69kXsZrR0Fs3p/ZD93TwybllLcNWDRbbVbpwO6p0u3J841q4d2/kbfYHiV/Ky+Ux6so6y5S+7Ujtms0Y2C2m6Syvm/jPxjiTxaYyBxHISbRAAPRWTH9Ua4hcCLXFhKj31mtF180vYZUPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711061207; c=relaxed/simple;
	bh=vNGqhhjcjfvIkP3k/1YJ9OCzOqm/zrEoLPEYsL0lby0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icNzccX+jLVfQHCiLxW5ejFoulgtaRbWn8tjniO6KL9WBH7nBsMSIX4sowemJqC3JQQnekcuRqxGfWan/bQZOLluTI2Q/EujtOZO1EuJ/ERD8ZVOhX1tf0gwXnN0UsPco/JEBC+nYi9V7MnPbKcbwLTDYFKp8Q0uU7aA1jKwOnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dnT/TDYG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711061203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X+ogJgpF1gr7B2+yDkmrhnOgUU+a3QN7Ii9aLHiqC4o=;
	b=dnT/TDYGrEHrHHi23ffETfkIaG+ujf6hQ9L/CFTc4YtnsTMe7lus+pq7ruyutVaCvU045U
	8RKD9I66xRQJiq75OatHAv0e6FEgQz0mvcQD9otj+3MugY8DK7uDwGqAqb5UwCuZud1BA3
	KxkyEI3i4mdR6C9QX/LwKTKS2ZLd5nk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228--BgN2gFCOP6ZRZUoQbDcHA-1; Thu, 21 Mar 2024 18:46:41 -0400
X-MC-Unique: -BgN2gFCOP6ZRZUoQbDcHA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-690d3f5af86so3124256d6.0
        for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 15:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711061201; x=1711666001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+ogJgpF1gr7B2+yDkmrhnOgUU+a3QN7Ii9aLHiqC4o=;
        b=Q0gtPOIvJdnK0qKrudjIrDSNBZ7rPvCCBsBOz/rPynh+Kkhd8sGNinP21D+guDl4Ef
         tZXXFTbxSyxwBqIBMrB8ZkixYIZLjJAJPtXaDi+WFr7ujZwLzehGozplMwhgzutCgrsU
         PF/h9poYVf58UoBNTAhzKHZnR0BHsL9gmHu6w5h5NvUoMmS0ryhYS86SGvfiKI4ivrde
         /9To9C249JFFoFmI7uqZj5xzOywKjFHeS2QALPovbEWip1xxbAv6vMd3WHd0/dpJuSiF
         lBCmCbg7o4Vc2cpI/0uFfzhi22S+gbpDhRU+V0H+725h1+/4lSg3rQti09mkzbtBiH9k
         vjWg==
X-Forwarded-Encrypted: i=1; AJvYcCUwQ4Xp8cgIK9PB6oEWRHE1Ypj6gmV9grSRyD7IEnSmCBvPDl5vwaC7uBAtYPltwXIeUwSKcziZuAI5OFRt4X9Eml79
X-Gm-Message-State: AOJu0YxgVq59/0/Hoof9GQuDlIkmVdAIy8ZGpO4aYcWbXehpTeCfeYgg
	APX5xLlV/AXzOeMV66GCa0/OGRwaeoeo99ufbMVk4DlOfSu1m+LwV8rIa06UF2H7L3JHjGziWUL
	BRe8/RNDtLoDBNBbmQ65F6ISohsXIePdScyPq/y1Si7iDhlCigg==
X-Received: by 2002:a05:6214:5984:b0:68f:dc8d:8ad3 with SMTP id qp4-20020a056214598400b0068fdc8d8ad3mr341922qvb.0.1711061201390;
        Thu, 21 Mar 2024 15:46:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGD/qtGTqYjBzfPurMsA4o89HBOzVGzjAKR5TaLhk1CCqmmBcLG97jKPtGk7lOvUP2Rb2c/CQ==
X-Received: by 2002:a05:6214:5984:b0:68f:dc8d:8ad3 with SMTP id qp4-20020a056214598400b0068fdc8d8ad3mr341902qvb.0.1711061200836;
        Thu, 21 Mar 2024 15:46:40 -0700 (PDT)
Received: from x1n ([99.254.121.117])
        by smtp.gmail.com with ESMTPSA id gw8-20020a0562140f0800b0068f6e1c3582sm380456qvb.146.2024.03.21.15.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 15:46:40 -0700 (PDT)
Date: Thu, 21 Mar 2024 18:46:38 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/userfaultfd: don't place zeropages when
 zeropages are disallowed
Message-ID: <Zfy4zhzWtyrHenlp@x1n>
References: <20240321215954.177730-1-david@redhat.com>
 <20240321215954.177730-2-david@redhat.com>
 <ZfyyodKYWtGki7MO@x1n>
 <48d1282c-e4db-4b55-ab3f-3344af2440c4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48d1282c-e4db-4b55-ab3f-3344af2440c4@redhat.com>

On Thu, Mar 21, 2024 at 11:29:45PM +0100, David Hildenbrand wrote:
> On 21.03.24 23:20, Peter Xu wrote:
> > On Thu, Mar 21, 2024 at 10:59:53PM +0100, David Hildenbrand wrote:
> > > s390x must disable shared zeropages for processes running VMs, because
> > > the VMs could end up making use of "storage keys" or protected
> > > virtualization, which are incompatible with shared zeropages.
> > > 
> > > Yet, with userfaultfd it is possible to insert shared zeropages into
> > > such processes. Let's fallback to simply allocating a fresh zeroed
> > > anonymous folio and insert that instead.
> > > 
> > > mm_forbids_zeropage() was introduced in commit 593befa6ab74 ("mm: introduce
> > > mm_forbids_zeropage function"), briefly before userfaultfd went
> > > upstream.
> > > 
> > > Note that we don't want to fail the UFFDIO_ZEROPAGE request like we do
> > > for hugetlb, it would be rather unexpected. Further, we also
> > > cannot really indicated "not supported" to user space ahead of time: it
> > > could be that the MM disallows zeropages after userfaultfd was already
> > > registered.
> > > 
> > > Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > 
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > 
> > Still, a few comments below.
> > 
> > > ---
> > >   mm/userfaultfd.c | 35 +++++++++++++++++++++++++++++++++++
> > >   1 file changed, 35 insertions(+)
> > > 
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index 712160cd41eca..1d1061ccd1dea 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -316,6 +316,38 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
> > >   	goto out;
> > >   }
> > > +static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> > > +		 struct vm_area_struct *dst_vma, unsigned long dst_addr)
> > > +{
> > > +	struct folio *folio;
> > > +	int ret;
> > 
> > nitpick: we can set -ENOMEM here, then
> > 
> > > +
> > > +	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> > > +	if (!folio)
> > > +		return -ENOMEM;
> > 
> > return ret;
> > 
> > > +
> > > +	ret = -ENOMEM;
> > 
> > drop.
> 
> Sure!
> 
> > 
> > > +	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> > > +		goto out_put;
> > > +
> > > +	/*
> > > +	 * The memory barrier inside __folio_mark_uptodate makes sure that
> > > +	 * preceding stores to the page contents become visible before
> > > +	 * the set_pte_at() write.
> > > +	 */
> > 
> > This comment doesn't apply.  We can drop it.
> > 
> 
> I thought the same until I spotted that comment (where uffd originally
> copied this from I strongly assume) in do_anonymous_page().
> 
> "Preceding stores" here are: zeroing out the memory.

Ah.. that's okay then.

Considering that userfault used to be pretty cautious on such ordering, as
its specialty to involve many user updates on the page, would you mind we
mention those details out?

	/*
	 * __folio_mark_uptodate contains the memory barrier to make sure 
         * the page updates to the zero page will be visible before
	 * installing the pgtable entries.  See do_anonymous_page().
	 */

Or anything better than my wordings.

Thanks!

-- 
Peter Xu


