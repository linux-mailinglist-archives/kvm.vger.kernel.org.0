Return-Path: <kvm+bounces-61184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA64C0F2E8
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D256119C213A
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A63311942;
	Mon, 27 Oct 2025 16:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kC9k2C1i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264283115A1
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761581367; cv=none; b=KdW4krnZVdK5iqrcjEZr1xmmszRB4sj6qvURIsF8xCyQoJC+GM1JJanuR4bTcAZpMkAOGi29onXpv5Y2kwBJ28Phu48z7Y5hFosbrB8Beu37JRSW5dD0kqw0KASHlgC44As8cLoMkf0BpQaE7aIzUiuDr/UsE9ExLq4Bs6HVCj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761581367; c=relaxed/simple;
	bh=Ip6risDW9tTbsO2jqPpdXFWuol17OZMU9AeN0DDZC0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=laLS/4oOFJXc3KcHdAVlPLZpY8QHMiQvrKbE4RCCAcavSh5RANF0TzKSM555+2cPgpaJ3QX68E8BHjcZnm/qR09jTPJI10RUqlJWjyQgy+/MWIMFH/yKczWPKDGbrn+AfkGJmIvXyBe81HE4gxzq2pYioLfjiMLhI/Kc1ZDyNns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kC9k2C1i; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-893c373500cso493734385a.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761581365; x=1762186165; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=anSGbOUh9PRDsyCb0fgwZTMvbpzdcHnK6psdZLJfHyQ=;
        b=kC9k2C1ipB0+8n0nDWV75bFcRvL16rGr//zO4g2ezNYzc8ibboc9Zs5rmRW7okfp9v
         KopeJr+kws+jhfq0fZmMCiBiRti6OMf9RdiPLOcmUZAqpS63TxOtRtGWXWE8Q5lqfpE0
         NrM673GKnBk5KHQAuN4kS1BmUvuiUs47eQ2Zvtzi1vK3bAzGm8xeKcwwhe0L/5uQmQER
         QA/S9+XxULInuMBS0xIGXOZDPwhZDsE59jnGgg7KSs5iete7eY5t0xIHXWJWXUi9kWg0
         aJyKPS7GRYfHJS9hlMnkVvENbtR/hTzMszY4O/KuBknMNAg0XqetkaokiwRVA98WqbgI
         dK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581365; x=1762186165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anSGbOUh9PRDsyCb0fgwZTMvbpzdcHnK6psdZLJfHyQ=;
        b=nYMdo6VN6q9xneGMvslxsWhY0ajMSpDSFwmv3CHaRHlNeFWbCvE3sSQqV6Txf4SCz2
         YNPG9L845rJXCjSpISli5ANO24npJnqjHK4FMnhaNwNW/jME2Zuhz5QgZm7xN6o8Pj0E
         snO5d7pwf5MrCL9a2+NutDush33QPr65Gz/3g1vV0RaXWtwI2WZT/3y+jaxMyZSEnVD4
         K/p18/5C+X6Zgnan33Ppgr32a/LVpzjOhSZpQHKl66F2JW3xZLYBMg39rkrLQAAWIeSh
         fZV+p5JlU9ThroSqmbH+R0H6s0gD5jirl5d7Ngu675PldV2FaaVs4GsBuJmeim5RDnj8
         LOiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwfb68kBAl2gW6JvVEBWrwt6pRbNQBQNvJZwXIYQ4DvnAfAhETg9I3FVzbkIr6bAaEddo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRFyxZtxEdYCsd7yQ1Vx+T+/2+1UW/pWOdzSChYYD/YuVow1Fa
	nfkpu+JdF4/bYLZjBxf6PugdQY1u4s8jJYSjjj96hMRY7z5BK1JEktcftEI7iJcmyY4=
X-Gm-Gg: ASbGncvcMdh51hdacqV8gV/qfJB2+vlV2LI4B7fq7CMBsYi98JWptp7jfJHtGsU5vN9
	8hyjm/Io7e2xYk/lHII2lqokPPx+aJEngsLn+sRsfu4gfafQTp12CDCKS0ErcZVg5oJcO4jlc38
	0pUbagUOTT7TAypTRIfPefWEqdhdRd3VUB+BnwhVinSUsjZdf4nfuTjs1TfBUso+EcKdFp+VhrD
	x74Ir83XqFzNBKHhWLsHvX+qAoPF84gux7o8BzYqJbtC1KK5WioygSqph7MSlyzIx5TsR2OwXHS
	vkEMX9CaeeZqSULurvOrNJcFdWQrvL0NQFlGsHPKLKYdXWqyGltz83P7vtYcOfTAOKI16TNaQPl
	TWW1JZyN0yxakCG5cjRGtYefxajLr+X0661WtJ8mWqR+BXubzLytYDvHzgsDgzhomwXp6iKDDFi
	zXQc4PqlkGee1SjAaDlObMw+1P97RtWkLU3a3oOg8fKYrx8MluW+uszozq
X-Google-Smtp-Source: AGHT+IHlNcX7M4ho1Hgm07pKSXRDLSWwAqfcPM4p2At44BY4PwXR6XnbKFaciXa2MkD0JUoTO3ORTg==
X-Received: by 2002:a05:620a:1aa1:b0:8a3:9a05:ec15 with SMTP id af79cd13be357-8a6d072570emr95429085a.19.1761581364508;
        Mon, 27 Oct 2025 09:09:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25c8a34dsm624408985a.48.2025.10.27.09.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 09:09:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vDPmd-00000004HT9-1p2Z;
	Mon, 27 Oct 2025 13:09:23 -0300
Date: Mon, 27 Oct 2025 13:09:23 -0300
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
Message-ID: <20251027160923.GF760669@ziepe.ca>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1761288179.git.lorenzo.stoakes@oracle.com>

On Fri, Oct 24, 2025 at 08:41:16AM +0100, Lorenzo Stoakes wrote:
> There's an established convention in the kernel that we treat leaf page
> tables (so far at the PTE, PMD level) as containing 'swap entries' should
> they be neither empty (i.e. p**_none() evaluating true) nor present
> (i.e. p**_present() evaluating true).

I have to say I've never liked the none-vs-present naming either.

> This is deeply confusing, so this series goes further and eliminates the
> non_swap_entry() predicate, replacing it with is_non_present_entry() - with
> an eye to a new convention of referring to these non-swap 'swap entries' as
> non-present.

I'm not keen on is_non_present_entry(), it seems confusing again.

It looks like we are stuck with swp_entry_t as the being the handle
for a non-present pte. Oh well, not a great name, but fine..

So we think of that swp_entry_t having multiple types: swap, migration,
device private, etc, etc

Then I'd think the general pattern should be to get a swp_entry_t:

    if (pte_present(pte))
        return;
    swpent = pte_to_swp_entry(pte);

And then evaluate the type:

    if (swpent_is_swap()) {
    }


If you keep the naming as "swp_entry" indicates the multi-type value,
then "swap" can mean a swp_entry which is used by the swap subsystem.

That suggests functions like this:

swpent_is_swap()
swpent_is_migration()
..

and your higher level helpers like:

/* True if the pte is a swpent_is_swap() */
static inline bool swpent_get_swap_pte(pte_t pte, swp_entry_t *entryp)
{
   if (pte_present(pte))
        return false;
   *swpent = pte_to_swp_entry(pte);
   return swpent_is_swap(*swpent);
}

I also think it will be more readable to keep all these things under a
swpent namespace instead of using unstructured english names.

> * pte_to_swp_entry_or_zero() - allows for convenient conversion from a PTE
>   to a swap entry if present, or an empty swap entry if none. This is
>   useful as many swap entry conversions are simply checking for flags for
>   which this suffices.

I'd expect a safe function should be more like

   *swpent = pte_to_swp_entry_safe(pte);
   return swpent_is_swap(*swpent);

Where "safe" means that if the PTE is None or Present then
swpent_is_XX() == false. Ie it returns a 0 swpent and 0 swpent is
always nothing.

> * get_pte_swap_entry() - Retrieves a PTE swap entry if it truly is a swap
>   entry (i.e. not a non-present entry), returning true if so, otherwise
>   returns false. This simplifies a lot of logic that previously open-coded
>   this.

Like this is still a tortured function:

+static inline bool get_pte_swap_entry(pte_t pte, swp_entry_t *entryp)
+{
+       if (pte_present(pte))
+               return false;
+       if (pte_none(pte))
+               return false;
+
+       *entryp = pte_to_swp_entry(pte);
+       if (non_swap_entry(*entryp))
+               return false;
+
+       return true;
+}
+

static inline bool get_pte_swap_entry(pte_t pte, swp_entry_t *entryp)
{
   return swpent_is_swap(*swpent = pte_to_swp_entry_safe(pte));
}

Maybe it doesn't even need an inline at that point?

> * is_huge_pmd() - Determines if a PMD contains either a present transparent
>   huge page entry or a huge non-present entry. This again simplifies a lot
>   of logic that simply open-coded this.

is_huge_or_swpent_pmd() would be nicer, IMHO. I think it is surprising
when any of these APIs accept swap entries without being explicit

Jason

