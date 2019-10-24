Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8F6E3663
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 17:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503043AbfJXPTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 11:19:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:22168 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403837AbfJXPTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 11:19:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 08:19:18 -0700
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="188617592"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 08:19:17 -0700
Message-ID: <e750dab283e0bc17658486e0f3070c55b7923eb2.camel@linux.intel.com>
Subject: Re: [PATCH v12 2/6] mm: Use zone and order instead of free area in
 free_list manipulators
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Thu, 24 Oct 2019 08:19:17 -0700
In-Reply-To: <78caedba-fc29-20d8-3043-2d7598aa3652@redhat.com>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
         <20191022222805.17338.3243.stgit@localhost.localdomain>
         <c3544859-606d-4e8f-2e48-2d7868e0fa13@redhat.com>
         <860dda361b6e0b94908d94beb0ad9f5519c8f2cf.camel@linux.intel.com>
         <78caedba-fc29-20d8-3043-2d7598aa3652@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-10-24 at 11:32 +0200, David Hildenbrand wrote:
> On 23.10.19 17:16, Alexander Duyck wrote:
> > On Wed, 2019-10-23 at 10:26 +0200, David Hildenbrand wrote:
> > > On 23.10.19 00:28, Alexander Duyck wrote:
> > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > 
> > > > In order to enable the use of the zone from the list manipulator functions
> > > > I will need access to the zone pointer. As it turns out most of the
> > > > accessors were always just being directly passed &zone->free_area[order]
> > > > anyway so it would make sense to just fold that into the function itself
> > > > and pass the zone and order as arguments instead of the free area.
> > > > 
> > > > In order to be able to reference the zone we need to move the declaration
> > > > of the functions down so that we have the zone defined before we define the
> > > > list manipulation functions. Since the functions are only used in the file
> > > > mm/page_alloc.c we can just move them there to reduce noise in the header.
> > > > 
> > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > > Reviewed-by: Pankaj Gupta <pagupta@redhat.com>
> > > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > ---
> > > >    include/linux/mmzone.h |   32 -----------------------
> > > >    mm/page_alloc.c        |   67 +++++++++++++++++++++++++++++++++++-------------
> > > >    2 files changed, 49 insertions(+), 50 deletions(-)
> > > 
> > > Did you see
> > > 
> > > https://lore.kernel.org/lkml/20191001152928.27008.8178.stgit@localhost.localdomain/T/#m4d2bc2f37bd7bdc3ae35c4f197905c275d0ad2f9
> > > 
> > > this time?
> > > 
> > > And the difference to the old patch is only an empty line.
> > > 
> > 
> > I saw the report. However I have not had much luck reproducing it in order
> > to get root cause. Here are my results for linux-next 20191021 with that
> > patch running page_fault2 over an average of 3 runs:
> 
> It would have been good if you'd reply to the report or sth. like that. 
> Then people (including me) are aware that you looked into it and what 
> your results of your investigation were.

I'll try to be more careful to remember to do that in the future.

> > Baseline:   3734692.00
> > This patch: 3739878.67
> > 
> > Also I am not so sure about these results as the same patch had passed
> > previously before and instead it was patch 3 that was reported as having a
> > -1.2% regression[1]. All I changed in response to that report was to add
> 
> Well, previously there was also a regression in the successor 
> PageReported() patch, not sure how they bisect in this case.

This is one of the things that has me thinking this is a possible code
alignment type issue. In the past when chasing down network performance
issues I would see these kind of things when a loop went from being cache
line aligned to not being aligned.

> > page_is_reported() which just wrapped the bit test for the reported flag
> > in a #ifdef to avoid testing it for the blocks that were already #ifdef
> > wrapped anyway.
> > 
> > I am still trying to see if I can get access to a system that would be a
> > better match for the one that reported the issue. My working theory is
> 
> I barely see false positives (well, I also barely see reports at all) on 
> MM, that's why I asked.

Like I said, I will dig into this.

> > that maybe it requires a high core count per node to reproduce. Either
> > that or it is some combination of the kernel being tested on and the patch
> > is causing some loop to go out of alignment and become more expensive.
> 
> Yes, double check that the config and the setup roughly matches what has 
> been reported.

I've been testing with the same .config and version of gcc. The last bit I
am trying now is to test with the same exact kernel source. I figure if I
can reproduce the issue with that then I can figure out exact root cause,
even if there isn't much we can do since the issue doesn't appear with the
latest patch set.

