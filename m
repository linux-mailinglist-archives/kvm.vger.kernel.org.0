Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236E829649
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 12:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390491AbfEXKq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 06:46:58 -0400
Received: from outbound-smtp26.blacknight.com ([81.17.249.194]:39827 "EHLO
        outbound-smtp26.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389448AbfEXKq6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 May 2019 06:46:58 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2019 06:46:56 EDT
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp26.blacknight.com (Postfix) with ESMTPS id 49273B87BF
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 11:39:26 +0100 (IST)
Received: (qmail 32417 invoked from network); 24 May 2019 10:39:26 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[37.228.225.79])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 24 May 2019 10:39:26 -0000
Date:   Fri, 24 May 2019 11:39:24 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
        cai@lca.pw, linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: Re: mm/compaction: BUG: NULL pointer dereference
Message-ID: <20190524103924.GN18914@techsingularity.net>
References: <1558689619-16891-1-git-send-email-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1558689619-16891-1-git-send-email-suzuki.poulose@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 24, 2019 at 10:20:19AM +0100, Suzuki K Poulose wrote:
> Hi,
> 
> We are hitting NULL pointer dereferences while running stress tests with KVM.
> See splat [0]. The test is to spawn 100 VMs all doing standard debian
> installation (Thanks to Marc's automated scripts, available here [1] ).
> The problem has been reproduced with a better rate of success from 5.1-rc6
> onwards.
> 
> The issue is only reproducible with swapping enabled and the entire
> memory is used up, when swapping heavily. Also this issue is only reproducible
> on only one server with 128GB, which has the following memory layout:
> 
> [32GB@4GB, hole , 96GB@544GB]
> 
> Here is my non-expert analysis of the issue so far.
> 
> Under extreme memory pressure, the kswapd could trigger reset_isolation_suitable()
> to figure out the cached values for migrate/free pfn for a zone, by scanning through
> the entire zone. On our server it does so in the range of [ 0x10_0000, 0xa00_0000 ],
> with the following area of holes : [ 0x20_0000, 0x880_0000 ].
> In the failing case, we end up setting the cached migrate pfn as : 0x508_0000, which
> is right in the center of the zone pfn range. i.e ( 0x10_0000 + 0xa00_0000 ) / 2,
> with reset_migrate = 0x88_4e00, reset_free = 0x10_0000.
> 
> Now these cached values are used by the fast_isolate_freepages() to find a pfn. However,
> since we cant find anything during the search we fall back to using the page belonging
> to the min_pfn (which is the migrate_pfn), without proper checks to see if that is valid
> PFN or not. This is then passed on to fast_isolate_around() which tries to do :
> set_pageblock_skip(page) on the page which blows up due to an NULL mem_section pointer.
> 
> The following patch seems to fix the issue for me, but I am not quite convinced that
> it is the right fix. Thoughts ?
> 

I think the patch is valid and the alternatives would be unnecessarily
complicated. During a normal scan for free pages to isolate, there
is a check for pageblock_pfn_to_page() which uses a pfn_valid check
for non-contiguous zones in __pageblock_pfn_to_page. Now, while the
non-contiguous check could be made in the area you highlight, it would be a
relatively small optimisation that would be unmeasurable overall. However,
it is definitely the case that if the PFN you highlight is invalid that
badness happens. If you want to express this as a signed-off patch with
an adjusted changelog then I'd be happy to add

Reviewed-by: Mel Gorman <mgorman@techsingularity.net>

If you are not comfortable with rewriting the changelog and formatting
it as a patch then I can do it on your behalf and preserve your
Signed-off-by. Just let me know.

Thanks for researching this, I think it also applies to other people but
had not found the time to track it down.

-- 
Mel Gorman
SUSE Labs
