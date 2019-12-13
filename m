Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D811E286
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 12:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfLMLIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 06:08:21 -0500
Received: from outbound-smtp09.blacknight.com ([46.22.139.14]:40572 "EHLO
        outbound-smtp09.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfLMLIV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 06:08:21 -0500
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp09.blacknight.com (Postfix) with ESMTPS id B479E1C26C1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 11:08:17 +0000 (GMT)
Received: (qmail 3412 invoked from network); 13 Dec 2019 11:08:17 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.57])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 13 Dec 2019 11:08:17 -0000
Date:   Fri, 13 Dec 2019 11:08:06 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        vbabka@suse.cz, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        konrad.wilk@oracle.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Subject: Re: [PATCH v15 0/7] mm / virtio: Provide support for free page
 reporting
Message-ID: <20191213110806.GA3178@techsingularity.net>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
 <ead08075-c886-dc7d-2c7b-47b20e00b515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <ead08075-c886-dc7d-2c7b-47b20e00b515@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 11:00:42AM +0100, David Hildenbrand wrote:
> > A brief history on the background of free page reporting can be found at:
> > https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.camel@linux.intel.com/
> > 
> > Changes from v13:
> > https://lore.kernel.org/lkml/20191105215940.15144.65968.stgit@localhost.localdomain/
> > Rewrote core reporting functionality
> >   Merged patches 3 & 4
> >   Dropped boundary list and related code
> >   Folded get_reported_page into page_reporting_fill
> >   Folded page_reporting_fill into page_reporting_cycle
> > Pulled reporting functionality out of free_reported_page
> >   Renamed it to __free_isolated_page
> >   Moved page reporting specific bits to page_reporting_drain
> > Renamed phdev to prdev since we aren't "hinting" we are "reporting"
> > Added documentation to describe the usage of unused page reporting
> > Updated cover page and patch descriptions to avoid mention of boundary
> > 
> > Changes from v14:
> > https://lore.kernel.org/lkml/20191119214454.24996.66289.stgit@localhost.localdomain/
> > Renamed "unused page reporting" to "free page reporting"
> >   Updated code, kconfig, and patch descriptions
> > Split out patch for __free_isolated_page
> >   Renamed function to __putback_isolated_page
> > Rewrote core reporting functionality
> >   Added logic to reschedule worker in 2 seconds instead of run to completion
> >   Removed reported_pages statistics
> >   Removed REPORTING_REQUESTED bit used in zone flags
> >   Replaced page_reporting_dev_info refcount with state variable
> >   Removed scatterlist from page_reporting_dev_info
> >   Removed capacity from page reporting device
> >   Added dynamic scatterlist allocation/free at start/end of reporting process
> >   Updated __free_one_page so that reported pages are not always added to tail
> >   Added logic to handle error from report function
> > Updated virtio-balloon patch that adds support for page reporting
> >   Updated patch description to try and highlight differences in approaches
> >   Updated logic to reflect that we cannot limit the scatterlist from device
> 
> Last time Mel said
> 
> "Ok, I'm ok with how this hooks into the allocator as the overhead is
> minimal. However, the patch itself still includes a number of
> optimisations instead of being a bare-boned implementation of the
> feature with optimisations layered on top."
> 

I didn't get the chance to take a close look as I'm trying to clear as
much as possible from my table on the run-up to Christmas so I don't come
back to a disaster inbox. I also noted that the Acks for earlier patches
were not included so I was uncertain if doing a full review would still
be a good use of time when time was tight.

That said, some optimisations are still included but much reduced. For
example, list rotations are still there but it's very straight-forward.
The refcount is gone which is good and replaced by a state, which could be
be better documented, but is more straight forward and the zone->lock is
back protecting the free lists primarily and not zone metadata or prdev
metadata (at least not obviously). I didn't put in the time to see if
the atomic_set in page_reporting_process() is ok or whether state could
be lost but I *think* it's ok because it should be called from just one
workqueue request and they shouldn't be stacked. A comment there explaining
why atomic_set is definitely correct would be helpful.

I'm inclined to decide that yes, this version is potentially ok as a
bare minimum but didn't put in the time to be 100% sure.
 
-- 
Mel Gorman
SUSE Labs
