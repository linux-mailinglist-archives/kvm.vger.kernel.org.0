Return-Path: <kvm+bounces-61185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EE64FC0F34E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 639F44FCCF5
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA6631196F;
	Mon, 27 Oct 2025 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ohx/7NO4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CCB31158A
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761581511; cv=none; b=twModxG9h0l6XR5mmNbD4PncfOaMShFVb1B9sRWbeU27R+iWbuYl7V3PlZBFRP92MVCYFtFC4Cv7IGGgd3OB/PcCNMSkVR+zFKcGxQuZliV4j5Vck0LyHDEyx89qrO5ZR2jnRqgy01raRt0T0WuGppDFuThMV1z+74luE0IpmeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761581511; c=relaxed/simple;
	bh=QASK2aUkAxKfkFOMA/cYGhoLhloD9yCkGn3YMzpW+18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3ZxF5VBa9Hca/uFYXRZmG3oNPLd7j5LQVXOztu5yQkIwAI9QakB+Cu5TzJrEF1TmoYwHxhMuk9T/hwObQollGY6pkt3a1CkyWsdbY84GPBtEUekrFkDfU/upVst1d1XAilJ9rWYkgOWtZ/U/E1OWgdOIkrk3nvqe6HMjhGkaIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ohx/7NO4; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8a479c772cfso68958785a.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761581508; x=1762186308; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YUcoeTWEWXvPiJKMdWmX3nawwIDQdRa9/4C7h6Fu0G0=;
        b=Ohx/7NO4ciCWHNL73Cns7VAJ1PwwArjUkkOkpZszVRjDT/J1ZHSrYFfu6AeFhiv9hy
         rfv6DKkzI8zzm/s7UbRRFKdYqrEEHcVxOo+x/By7F5iTQ5J7uGND1htBgXYn/B7WCcfE
         RFrAJAvyaWQ7jSp5JtYVoOQ2fCyiCPhCT/vT/n8Xymi+ShqmJ43M2EEVpiFEiMQ6/K4y
         nZIXxOiiIFj/97EJczGs+oUlgG57l8e6hACg3+pJOPl5W9ijwpOHIU6x0FjUXG2R+cow
         PKCE/wfleDyFf38YFwiBxDNFxNYPEG9IjLiwd26ygh30jWHQZzcZ8eL9mbeLpTpEYd6Q
         5BWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581508; x=1762186308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUcoeTWEWXvPiJKMdWmX3nawwIDQdRa9/4C7h6Fu0G0=;
        b=TCw3XBomw43euIREaQAqzfpiGtXVC3zmffiGeMqn4sWoai37TmIqnSkpBNxRiAaHZU
         urHwlkrQPTfzem+pHpsLyAlSS/1aQzJACtmRIsmKrgJv29YcmcEWnldq1Yd7z167jT8A
         C2F+mmUy09EZYgRvod7P10sLMNGeqfLkTipkycj9nvnw6kJlx4civmwsnP+/msKG1EFf
         SuZYZOqijxroTUw0RFEAT5BES/z7PPR9XnuUwcRTWsq1qWwjhK4hjNBLAtLdRFxUTkGA
         ttCvAzKogGjNbLrw+l5QdPxt798kk6+6rKm0/doqwXFdSt9R2IgKGD+cBgHAhex3Mxh5
         7HKw==
X-Forwarded-Encrypted: i=1; AJvYcCUgDp4+IQnro1+BbuyyrY8Zya0214jv9G50YatyxMgcUE02S9huqncTuaW5v6iMbC/uvRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxeZI0YQxvTwO96twYFQty7crV1HRJ9651ytNBdHToCUNXdpF+
	fd2nfjj6BQHOqcb/9urQY3/dCqfthBtyRM4kjafL/S7o2ZZR0E31aZY4EGShy6ar5qw=
X-Gm-Gg: ASbGncsJRVyzKg2D/PuyVrt+L5EoGglMv1B2sk7Jm8Z72eEgFQbKBlByXiQdGz3INAr
	R8sCkLoTyzn7vVZl81m5y/UPnTaZHSdv5VvMXYbF0apUtJJLEApsme4VXnOLnmOliwm7YFldXfi
	sBZ4trRauzCZ+vR3gLzHeoB8O6UH2RkiWRsFw7pLgFcK/l8B2I0q9GvlheH64oz777puH8Ezt6m
	n13KVo4XNFC9g4qKQSoHf4HAZ+m4H4mz7BGdNFzimn0/KCF43+AJI5hXovb8TZT20ifjIIcRHxy
	o4/r+TgTeAFSpKZoaZjReKq//wqAGn2voAugU731uIvgLY4phkG9O11H8QocmxVvrvgZyfROQ0i
	SL/EqJkaqhXwqGWiAZxiE664Y1oZyhKyPHqDYHCi4iJCexL0WQnONliwlFglvEkEAdWA64jcAUe
	Ur98eA+ulQEI8Z1dETZDi9VC/FCt0es/Ucp0LFywbHYzjNzLrdmwRxjE7n
X-Google-Smtp-Source: AGHT+IFJf0BibtsNlfavgV+F1phwUBGZobfoErAK4Dl+j0mvBEo1idyt8ArsRwOA8zB/HM5HTcYQOw==
X-Received: by 2002:a05:620a:4627:b0:8a2:2233:c151 with SMTP id af79cd13be357-8a70118c82fmr40354785a.75.1761581507673;
        Mon, 27 Oct 2025 09:11:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25c8b517sm628453785a.45.2025.10.27.09.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 09:11:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vDPow-00000004HUZ-2jWh;
	Mon, 27 Oct 2025 13:11:46 -0300
Date: Mon, 27 Oct 2025 13:11:46 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <20251027161146.GG760669@ziepe.ca>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>

On Fri, Oct 24, 2025 at 04:37:18PM -0400, Gregory Price wrote:
> On Fri, Oct 24, 2025 at 09:15:59PM +0100, Lorenzo Stoakes wrote:
> > On Fri, Oct 24, 2025 at 03:12:08PM -0400, Gregory Price wrote:
> > 
> > So maybe actually that isn't too bad of an idea...
> > 
> > Could also be
> > 
> > nonpresent_or_swap_t but that's kinda icky...
> 
> clearly we need:
> 
> union {
> 	swp_entry_t swap;
> 	nonpresent_entry_t np;
> 	pony_entry_t pony;
> 	plum_emtry_t beer;
> } leaf_entry_t;
> 
> with
> 
> leaf_type whats_that_pte(leaf_entry_t);

I think if you are going to try to rename swp_entry_t that is a pretty
good idea. Maybe swleaf_entry_t to pace emphasis that it is not used
by the HW page table walker would be a good compromise to the ugly
'non-present entry' term.

Jason

