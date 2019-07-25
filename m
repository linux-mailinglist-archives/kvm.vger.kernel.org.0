Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04982758F8
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 22:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfGYUhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 16:37:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:58797 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfGYUhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 16:37:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 13:37:02 -0700
X-IronPort-AV: E=Sophos;i="5.64,308,1559545200"; 
   d="scan'208";a="161090207"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 13:37:02 -0700
Message-ID: <5f78cccab8273cb759538ef6e088886a507ce438.camel@linux.intel.com>
Subject: Re: [PATCH v2 4/5] mm: Introduce Hinted pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Matthew Wilcox <willy@infradead.org>
Date:   Thu, 25 Jul 2019 13:37:02 -0700
In-Reply-To: <c200d5cf-90f7-9dca-5061-b6e0233ca089@redhat.com>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
         <20190724170259.6685.18028.stgit@localhost.localdomain>
         <a9f52894-52df-cd0c-86ac-eea9fbe96e34@redhat.com>
         <CAKgT0Ud-UNk0Mbef92hDLpWb2ppVHsmd24R9gEm2N8dujb4iLw@mail.gmail.com>
         <f0ac7747-0e18-5039-d341-5dfda8d5780e@redhat.com>
         <b3568a5422d0f6b88f7c5cb46577db1a43057c04.camel@linux.intel.com>
         <c200d5cf-90f7-9dca-5061-b6e0233ca089@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-07-25 at 20:32 +0200, David Hildenbrand wrote:
> On 25.07.19 19:38, Alexander Duyck wrote:
> > On Thu, 2019-07-25 at 18:48 +0200, David Hildenbrand wrote:
> > > On 25.07.19 17:59, Alexander Duyck wrote:
> > > > On Thu, Jul 25, 2019 at 1:53 AM David Hildenbrand <david@redhat.com> wrote:
> > > > > On 24.07.19 19:03, Alexander Duyck wrote:
> > > > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > <snip>
> > 
> > > > > Can't we reuse one of the traditional page flags for that, not used
> > > > > along with buddy pages? E.g., PG_dirty: Pages that were not hinted yet
> > > > > are dirty.
> > > > 
> > > > Reusing something like the dirty bit would just be confusing in my
> > > > opinion. In addition it looks like Xen has also re-purposed PG_dirty
> > > > already for another purpose.
> > > 
> > > You brought up waste page management. A dirty bit for unprocessed pages
> > > fits perfectly in this context. Regarding XEN, as long as it's not used
> > > along with buddy pages, no issue.
> > 
> > I would rather not have to dirty all pages that aren't hinted. That starts
> > to get too invasive. Ideally we only modify pages if we are hinting on
> > them. That is why I said I didn't like the use of a dirty bit. What we
> > want is more of a "guaranteed clean" bit.
> 
> Not sure if that is too invasive, but fair enough.
> 
> > > FWIW, I don't even thing PG_offline matches to what you are using it
> > > here for. The pages are not logically offline. They were simply buddy
> > > pages that were hinted. (I'd even prefer a separate page type for that
> > > instead - if we cannot simply reuse one of the other flags)
> > > 
> > > "Offline pages" that are not actually offline in the context of the
> > > buddy is way more confusing.
> > 
> > Right now offline and hinted are essentially the same thing since the
> > effect is identical.
> 
> No they are not the same thing. Regarding virtio-balloon: You are free
> to reuse any hinted pages immediate. Offline pages (a.k.a. inflated) you
> might not generally reuse before deflating.

Okay, so it sounds like your perspective is a bit different than mine. I
was thinking of it from the perspective of the host OS where in either
case the guest has set the page as MADV_DONTNEED. You are looking at it
from the guest perspective where Offline means the guest cannot use it.

> > There may be cases in the future where that is not the case, but with the
> > current patch set they both result in the pages being evicted from the
> > guest.
> > 
> > > > If anything I could probably look at seeing if the PG_private flags
> > > > are available when a page is in the buddy allocator which I suspect
> > > > they probably are since the only users I currently see appear to be
> > > > SLOB and compound pages. Either that or maybe something like PG_head
> > > > might make sense since once we start allocating them we are popping
> > > > the head off of the boundary list.
> > > 
> > > Would also be fine with me.
> > 
> > Actually I may have found an even better bit if we are going with the
> > "reporting" name. I could probably use "PG_uptodate" since it looks like
> > most of its uses are related to filesystems. I will wait till I hear from
> > Matthew on what bits would be available for use before I update things.
> 
> Also fine with me. In the optimal case we (in my opinion)
> a) Don't reuse PG_offline
> b) Don't use another page type

That is fine. I just need to determine the exact flag to use then. I'll do
some more research and wait to see if anyone else from MM comunity has
input or suggestions on the page flag to be used. From what I can tell it
looks like there are a bunch of flag bits that are unused as far as the
buddy pages are concerned so I should have a few to choose from.

