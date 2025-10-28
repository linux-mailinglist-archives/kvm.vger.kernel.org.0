Return-Path: <kvm+bounces-61293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED49C14B2E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 13:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BE6E1B22A1E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 12:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2D6330338;
	Tue, 28 Oct 2025 12:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="HtaJBjZT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881672F60A4
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 12:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761655711; cv=none; b=s5Cdu5r5OOjXMpTwSGBVjIZupT9ORp6sBjWMHDVFXRiwh4vXMZX27bKPN21UKbkUPgrYJ/9qM8Mg2eVYs9X5gERJAAWpW1ikPrzAQFAzH7FWbZR80g7XPDXeBrTn0yQ2ESkSR45HvU6ZehO64FTfcMjBNRwBxZgN55NOFxy0mmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761655711; c=relaxed/simple;
	bh=gCnXXMQ8+yEkwBLJ50Cu/DQrX5xFcQ3EXfOwIcPhh30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E41lIFOu8OGTt3Usr3oGoAhJpGGqtVRphRqN5cVU0ilWq0KHgV0njNCuLj1s9gLPuuiDeXdj898jg3+/p26kdRd953zoJhiN5yBZKPm7IqBilIvBciWgxKtcK7oU6HTj2uB7Eh9lfuc00+93K/W/A1P8mPMwgA4bbibumajP1CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=HtaJBjZT; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-81efcad9c90so70653756d6.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 05:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761655708; x=1762260508; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Olopx85j++3FTIQ4p47k6xJ/f5lMguJl5tBEftSDYws=;
        b=HtaJBjZT/raqwscTxIjkznlmEulX2sj3GBKKVysGgV/I4gvR3LZGMDdNc1ulwbPDeT
         /L7RvkJBKdFSfVsvAMwa3Rve7wy2tptRPGeZj0SwGF+4RUAeOx3OTRYxrem5SMo7E8Ai
         2iKC5CNZfCuvv9fLmrN1EoDNDwLnHQnUXZz9KWdJ4KzvGg/JYu4KEthxpJ/APNc6BHHF
         A5+FIVt1U2rlV/JfSLBMzQyqaGaifiyfhxDYujWfj0Osnm3koOamkWTWz2Bs66HFaatT
         kuDGGZS4wO83ByLjdiydmjeOCr96VqOmOIqIsAatfqmxzuhY8Vx+IklcuHcrZkfWWz90
         5V0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761655708; x=1762260508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Olopx85j++3FTIQ4p47k6xJ/f5lMguJl5tBEftSDYws=;
        b=iB5m+xMVXiHigAtpsbj7f97hei9TkyJDkrO4wK2Hfym9pXFn6nLmoKdnG2Q3SIgGU7
         bBuug+s9GAdpFligHfbpE5j44JFddshv5dQbD66ICAHgtXvVegeadI54eYkpazRA0aRp
         N0heLnkmqCFYHHZaFZfbpCR01ggcszG61uQmj87LGTvd3syblEINgMAfzKvfIqafgsLt
         K7weCwpL6ywS2BcQjgyKfM1ECtRm+x4n1Z28hH5kPsHbNgG/liN1BQiQCvPDmkszWY6A
         +mcJBh508qwxKykA5x+Xa6ln+OAUelZetFJ5qmcHOy6ezZES7XR5v9wqCplr0rh3QnF1
         Z2bw==
X-Forwarded-Encrypted: i=1; AJvYcCW9UscH7Fid+Iy427J3uv30dsPRoNDWo4VOIuSEiulkSjQv3aAV/0n50j2UDJHdpuE7eTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG4e0t6azPpvn++AssVEVf+LkJB6qCx16pMeGq0u28BhMJZdSu
	YSj7yoBP4fCMiJAghDAMdrkCyzKFE5sVwPbhiwN2MqIU7KtIgXfpuqkbu560W/sqAYM=
X-Gm-Gg: ASbGncsYo6/WtTVP2nkOh7adfo301tJ7EogMePrEmijs2liCic+nt1liYloysgeTYtA
	di7aLH/F60MPRzP7fgRLPnO1f4ky329Wtmp4+SijwnS1LyHPjwTL+2CSe0HtuXKtGJHY6CPqfL0
	zxYmLFRs6p/CQwevMi20z0rOmjzwVYwQRQTaf5L15+M4WZPQH8dkYe3sNul9l1o8GqZ72sBw3dA
	ejQt7I5hFB6c3RFVGsmT4XwPlFihpOBbMGPhLnUbKEcZd9v9SsPXHC5YKK4PhZKSfe5MAE7jpOd
	A4cqXoJMM9n6sqI914iKZo2yVedF/PVTxbbmTf3LSIyPzR2jcunqou2abl8NGx6yO6/AY1F4WMm
	l0f4jiE0t8wnnRuoihbsdztjdykrdSdhOubOjaOFgNqdvG2Dt7+dquCtZICFfwcPDuxDN54Po02
	maMWksoN89Sv2mvIc1hLffzhsVqYqVHPNzocq0mzYHDuVVTg==
X-Google-Smtp-Source: AGHT+IHiUNJHwvr/nLoj/e7qPf6JckrC19yXD6gHtAA14Gx8htpJ7qO77Enxzi9C2v+UJSUvbdZfVQ==
X-Received: by 2002:ad4:5c65:0:b0:87c:1889:6a7f with SMTP id 6a1803df08f44-87ffb000afdmr37515826d6.5.1761655708162;
        Tue, 28 Oct 2025 05:48:28 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48e08d3sm76769836d6.19.2025.10.28.05.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 05:48:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vDj7a-00000004Oq0-01nS;
	Tue, 28 Oct 2025 09:48:18 -0300
Date: Tue, 28 Oct 2025 09:48:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] remove is_swap_[pte, pmd]() + non-swap
 confusion
Message-ID: <20251028124817.GH760669@ziepe.ca>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
 <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>

On Mon, Oct 27, 2025 at 05:33:57PM +0000, Lorenzo Stoakes wrote:
> (Note I never intended this to be an RFC, it was only because of
> series-likely-to-be-dropped causing nasty conflicts this isn't an 'out
> there' series rather a practical submission).
> 
> To preface, as I said elsewhere, I intend to do more on this, renaming
> swp_entry_t to probably leaf_entry_t (thanks Gregory!)
> 
> The issue is no matter how I do this people will theorise different
> approaches, I'm trying to practically find a way forward that works
> iteratively.

It is why I suggested that swp_entry_t is the name we have (for this
series at least) and lean into it as the proper name for the abstract
idea of a multi-type'd value. Having a following series to rename
"swp_entry_t" to some "leaf entry" will resolve the poor naming.

But for now, "swp_entry_t" does not mean *swap* entry, it means "leaf
entry with a really bad type name".

And swpent_* is the namespace prefix for things dealing with
swp_entry_t.

If done consistently then the switch to leaf entry naming is just a
simple mass rename of swpent/leafent.

> > That suggests functions like this:
> >
> > swpent_is_swap()
> > swpent_is_migration()
> > ..
> 
> The _whole point_ of this series is to separate out the idea that you're
> dealing with swap entries so I don't like swpent as a name obviously.

As you say we can't fix everything at once, but if you do the above
and then rename the end state would be

leafent_is_swap()
leafent_is_migration()
 ..

And that seems like a good end state.

So pick the small steps, either lean into swpent in this series as the
place holder for leafent in the next..

Or this seems like a good idea too:

> We could also just pre-empt and prefix functions with leafent_is_swap() if
> you prefer.
> 
> We could even do:
> 
> /* TODO: Rename swap_entry_t to leaf_entry_t */
> typedef swap_entry_t leaf_entry_t;
>
> And use the new type right away.

Then the followup series is cleaning away swap_entry_t as a name.

> > /* True if the pte is a swpent_is_swap() */
> > static inline bool swpent_get_swap_pte(pte_t pte, swp_entry_t *entryp)
> > {
> >    if (pte_present(pte))
> >         return false;
> >    *swpent = pte_to_swp_entry(pte);
> >    return swpent_is_swap(*swpent);
> > }
> 
> I already implement in the series a pte_to_swp_entry_or_zero() function

I saw, but I don't think it is a great name.. It doesn't really give
"zero" it gives a swp_entry_t that doesn't pass any of the
swpent_is_XX() functions. ie a none type.

> that goes one further - checks pte_present() for you, if pte_none() you
> just get an empty swap entry, so this can be:

And I was hoping to see a path to get rid of the pte_none() stuff, or
at least on most arches. It is pretty pointless to check for pte_none
if the arch has a none-pte that already is 0..

So pte_none can be more like:
   swpent_is_none(pte_to_swp_entry(pte))

Where pte_to_swp_entry is just some bit maths with no conditionals.

> > I also think it will be more readable to keep all these things under a
> > swpent namespace instead of using unstructured english names.
> 
> Nope. Again, the whole point of the series is to avoid referencing
> swap. swpent_xxx() is just eliminating the purpose of the series right?
> 
> Yes it sucks that the type name is what it is, but this is an iterative
> process.

Sure, but don't add a bunch of new names with *no namespace*. As above
either accept swpent is a placeholder for leafent in the next series,
or do this:

> But as above, we could pre-empt future changes and prefix with a
> leafent_*() prefix if that works for you?

Which seems like a good idea to me.

> > I'd expect a safe function should be more like
> >
> >    *swpent = pte_to_swp_entry_safe(pte);
> >    return swpent_is_swap(*swpent);
> >
> > Where "safe" means that if the PTE is None or Present then
> > swpent_is_XX() == false. Ie it returns a 0 swpent and 0 swpent is
> > always nothing.
> 
> Not sure it's really 'safe', the name is unfortunate, but you could read
> this as 'always get a valid swap entry to operate on'...

My suggestion was the leaf entry has a type {none, swap, migration, etc}

And this _safe version returns the none type'd leaf entry for a
present pte.

We move toward eliminating the idea of pte_none by saying a
non-present pte is always a leaf_entry and what we call a "none pte"
is a "none leaf entry"

> leaf_entry_t leafent_from_pte()...?

Probably this one?
> > static inline bool get_pte_swap_entry(pte_t pte, swp_entry_t *entryp)
> > {
> >    return swpent_is_swap(*swpent = pte_to_swp_entry_safe(pte));
> > }
> 
> I absolutely hate that embedded assignment, but this is equivalent to what
> I suggested above, so agreed this is a good suggestion broadly.
> 
> >
> > Maybe it doesn't even need an inline at that point?
> 
> Don't understand what you mean by that. It's in a header file?

I mean just write it like this in the callers:

  swp_entry_t leafent = pte_to_swp_entry_safe(pte);

  if (swpent_is_swap(leafent)) {
  }

It is basically the same # lines as the helper version.

> > > * is_huge_pmd() - Determines if a PMD contains either a present transparent
> > >   huge page entry or a huge non-present entry. This again simplifies a lot
> > >   of logic that simply open-coded this.
> >
> > is_huge_or_swpent_pmd() would be nicer, IMHO. I think it is surprising
> > when any of these APIs accept swap entries without being explicit
> 
> Again, I'm not going to reference swap in a series intended to eliminate
> this, it defeats the purpose.
> 
> And the non-present (or whatever you want to call it) entry _is_ huge. So
> it's just adding more confusion that way IMO.

Then this:

  pmd_is_present_or_leafent(pmd)

Jason

