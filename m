Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA081D1488
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 18:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbfJIQuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 12:50:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:41840 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbfJIQuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 12:50:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 09:50:10 -0700
X-IronPort-AV: E=Sophos;i="5.67,276,1566889200"; 
   d="scan'208";a="187674509"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 09:50:10 -0700
Message-ID: <4b6a9bda0a19c20b04338fd1d9b4f96086480355.camel@linux.intel.com>
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        David Hildenbrand <david@redhat.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 09 Oct 2019 09:50:09 -0700
In-Reply-To: <9bd52b8e-fa9e-a5ad-de39-660684757cdb@redhat.com>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
         <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
         <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
         <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
         <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
         <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com>
         <CAKgT0Ud6TT=XxqFx6ePHzbUYqMp5FHVPozRvnNZK3tKV7j2xjg@mail.gmail.com>
         <0a16b11e-ec3b-7196-5b7f-e7395876cf28@redhat.com>
         <d96f744d2c48f5a96c6962c6a0a89d2429e5cab8.camel@linux.intel.com>
         <7fc13837-546c-9c4a-1456-753df199e171@redhat.com>
         <5b6e0b6df46c03bfac906313071ac0362d43c432.camel@linux.intel.com>
         <c2fd074b-1c86-cd93-41ea-ae1a6b2ca841@redhat.com>
         <CAKgT0Uecy96y-bOj4TpXBxSwJhn3jaCtGjD2+Zswh9gN7i+Otg@mail.gmail.com>
         <9bd52b8e-fa9e-a5ad-de39-660684757cdb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-10-09 at 12:25 -0400, Nitesh Narayan Lal wrote:
> On 10/7/19 1:20 PM, Alexander Duyck wrote:
> > On Mon, Oct 7, 2019 at 10:07 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> > > On 10/7/19 12:27 PM, Alexander Duyck wrote:
> > > > On Mon, 2019-10-07 at 12:19 -0400, Nitesh Narayan Lal wrote:
> > > > > On 10/7/19 11:33 AM, Alexander Duyck wrote:
> > > > > > On Mon, 2019-10-07 at 08:29 -0400, Nitesh Narayan Lal wrote:
> > > > > > > On 10/2/19 10:25 AM, Alexander Duyck wrote:
> > <snip>
> > 
> > > > > > > page_reporting.c change:
> > > > > > > @@ -101,8 +101,12 @@ static void scan_zone_bitmap(struct page_reporting_config
> > > > > > > *phconf,
> > > > > > >                 /* Process only if the page is still online */
> > > > > > >                 page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
> > > > > > >                                           zone->base_pfn);
> > > > > > > -               if (!page)
> > > > > > > +               if (!page || !PageBuddy(page)) {
> > > > > > > +                       clear_bit(setbit, zone->bitmap);
> > > > > > > +                       atomic_dec(&zone->free_pages);
> > > > > > >                         continue;
> > > > > > > +               }
> > > > > > > 
> > > > > > I suspect the zone->free_pages is going to be expensive for you to deal
> > > > > > with. It is a global atomic value and is going to have the cacheline
> > > > > > bouncing that it is contained in. As a result thinks like setting the
> > > > > > bitmap with be more expensive as every tome a CPU increments free_pages it
> > > > > > will likely have to take the cache line containing the bitmap pointer as
> > > > > > well.
> > > > > I see I will have to explore this more. I am wondering if there is a way to
> > > > > measure this If its effect is not visible in will-it-scale/page_fault1. If
> > > > > there is a noticeable amount of degradation, I will have to address this.
> > > > If nothing else you might look at seeing if you can split up the
> > > > structures so that the bitmap and nr_bits is in a different region
> > > > somewhere since those are read-mostly values.
> > > ok, I will try to understand the issue and your suggestion.
> > > Thank you for bringing this up.
> > > 
> > > > Also you are now updating the bitmap and free_pages both inside and
> > > > outside of the zone lock so that will likely have some impact.
> > > So as per your previous suggestion, I have made the bitmap structure
> > > object as a rcu protected pointer. So we are safe from that side.
> > > The other downside which I can think of is a race where one page
> > > trying to increment free_pages and other trying to decrements it.
> > > However, being an atomic variable that should not be a problem.
> > > Did I miss anything?
> > I'm not so much worried about a race as the cache line bouncing
> > effect. Basically your notifier combined within this hinting thread
> > will likely result in more time spent by the thread that holds the
> > lock since it will be trying to access the bitmap to set the bit and
> > the free_pages to report the bit, but at the same time you will have
> > this thread clearing bits and decrementing the free_pages values.
> > 
> > One thing you could consider in your worker thread would be to do
> > reallocate and replace the bitmap every time you plan to walk it. By
> > doing that you would avoid the cacheline bouncing on the bitmap since
> > you would only have to read it, and you would no longer have another
> > thread dirtying it. You could essentially reset the free_pages at the
> > same time you replace the bitmap. It would need to all happen with the
> > zone lock held though when you swap it out.
> 
> If I am not mistaken then from what you are suggesting, I will have to hold
> the zone lock for the entire duration of swap & scan which would be costly if
> the bitmap is large, isn't? Also, we might end up missing free pages that are
> getting
> freed while we are scanning.

You would only need to hold the zone lock when you swap the bitmap. Once
it is swapped you wouldn't need to worry about the locking again for
bitmap access since your worker thread would be the only one holding the
current bitmap. Think of it as a batch clearing of the bits.

You already end up missing pages freed while scanning since you are doing
it linearly.

> As far as free_pages count is concerned, I am thinking if I should
> replace it with zone->free_area[REPORTING_ORDER].nr_free which is already there
> (I still need to explore this in a bit more depth).
> 
> > - Alex

So there ends up being two ways you could use nr_free. One is to track it
the way I did with the number of reported pages being tracked, however
that requires reducing the count when reported pages are pulled from the
free_area and identifying reported pages vs unreported ones.

The other option would be to look at converting nr_free into a pair of
free running counters, one tracking frees, and another tracking
allocations. Then you just need to record a snapshot of the nr_free values
when you do something like the bitmap swap, and then you would be able to
track churn, but it wouldn't give you an exact count of unreported pages
since it is possible to just alloc/free a single page multiple times to
make it look like you have freed a number of pages even though you really
haven't.

