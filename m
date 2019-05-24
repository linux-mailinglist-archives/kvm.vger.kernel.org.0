Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B239829813
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 14:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391595AbfEXMaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 08:30:52 -0400
Received: from outbound-smtp24.blacknight.com ([81.17.249.192]:46111 "EHLO
        outbound-smtp24.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391383AbfEXMaw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 May 2019 08:30:52 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp24.blacknight.com (Postfix) with ESMTPS id 22E09B8871
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 13:30:49 +0100 (IST)
Received: (qmail 27446 invoked from network); 24 May 2019 12:30:49 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[37.228.225.79])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 24 May 2019 12:30:48 -0000
Date:   Fri, 24 May 2019 13:30:47 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Anshuman Khandual <anshuman.khandual@arm.com>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, mhocko@suse.com, cai@lca.pw,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: Re: mm/compaction: BUG: NULL pointer dereference
Message-ID: <20190524123047.GO18914@techsingularity.net>
References: <1558689619-16891-1-git-send-email-suzuki.poulose@arm.com>
 <cfddd75a-b302-5557-05b8-2b328bba27c8@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <cfddd75a-b302-5557-05b8-2b328bba27c8@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 24, 2019 at 04:26:16PM +0530, Anshuman Khandual wrote:
> 
> 
> On 05/24/2019 02:50 PM, Suzuki K Poulose wrote:
> > Hi,
> > 
> > We are hitting NULL pointer dereferences while running stress tests with KVM.
> > See splat [0]. The test is to spawn 100 VMs all doing standard debian
> > installation (Thanks to Marc's automated scripts, available here [1] ).
> > The problem has been reproduced with a better rate of success from 5.1-rc6
> > onwards.
> > 
> > The issue is only reproducible with swapping enabled and the entire
> > memory is used up, when swapping heavily. Also this issue is only reproducible
> > on only one server with 128GB, which has the following memory layout:
> > 
> > [32GB@4GB, hole , 96GB@544GB]
> > 
> > Here is my non-expert analysis of the issue so far.
> > 
> > Under extreme memory pressure, the kswapd could trigger reset_isolation_suitable()
> > to figure out the cached values for migrate/free pfn for a zone, by scanning through
> > the entire zone. On our server it does so in the range of [ 0x10_0000, 0xa00_0000 ],
> > with the following area of holes : [ 0x20_0000, 0x880_0000 ].
> > In the failing case, we end up setting the cached migrate pfn as : 0x508_0000, which
> > is right in the center of the zone pfn range. i.e ( 0x10_0000 + 0xa00_0000 ) / 2,
> > with reset_migrate = 0x88_4e00, reset_free = 0x10_0000.
> > 
> > Now these cached values are used by the fast_isolate_freepages() to find a pfn. However,
> > since we cant find anything during the search we fall back to using the page belonging
> > to the min_pfn (which is the migrate_pfn), without proper checks to see if that is valid
> > PFN or not. This is then passed on to fast_isolate_around() which tries to do :
> > set_pageblock_skip(page) on the page which blows up due to an NULL mem_section pointer.
> > 
> > The following patch seems to fix the issue for me, but I am not quite convinced that
> > it is the right fix. Thoughts ?
> > 
> > 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index 9febc8c..9e1b9ac 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -1399,7 +1399,7 @@ fast_isolate_freepages(struct compact_control *cc)
> >  				page = pfn_to_page(highest);
> >  				cc->free_pfn = highest;
> >  			} else {
> > -				if (cc->direct_compaction) {
> > +				if (cc->direct_compaction && pfn_valid(min_pfn)) {
> >  					page = pfn_to_page(min_pfn);
> 
> pfn_to_online_page() here would be better as it does not add pfn_valid() cost on
> architectures which does not subscribe to CONFIG_HOLES_IN_ZONE. But regardless if
> the compaction is trying to scan pfns in zone holes, then it should be avoided.

CONFIG_HOLES_IN_ZONE typically applies in special cases where an arch
punches holes within a section. As both do a section lookup, the cost is
similar but pfn_valid in general is less subtle in this case. Normally
pfn_valid_within is only ok when a pfn_valid check has been made on the
max_order aligned range as well as a zone boundary check. In this case,
it's much more straight-forward to leave it as pfn_valid.

-- 
Mel Gorman
SUSE Labs
