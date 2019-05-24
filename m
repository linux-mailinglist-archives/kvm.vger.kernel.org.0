Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EE929624
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 12:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390726AbfEXKm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 06:42:58 -0400
Received: from foss.arm.com ([217.140.101.70]:39864 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390374AbfEXKm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 06:42:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D473B374;
        Fri, 24 May 2019 03:42:57 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5690D3F703;
        Fri, 24 May 2019 03:42:56 -0700 (PDT)
Subject: Re: mm/compaction: BUG: NULL pointer dereference
To:     mgorman@techsingularity.net
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
        cai@lca.pw, linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <1558689619-16891-1-git-send-email-suzuki.poulose@arm.com>
 <20190524103924.GN18914@techsingularity.net>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <98b93f38-64a7-dcd1-c027-6d1195f3380f@arm.com>
Date:   Fri, 24 May 2019 11:42:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524103924.GN18914@techsingularity.net>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mel,

Thanks for your quick response.

On 24/05/2019 11:39, Mel Gorman wrote:
> On Fri, May 24, 2019 at 10:20:19AM +0100, Suzuki K Poulose wrote:
>> Hi,
>>
>> We are hitting NULL pointer dereferences while running stress tests with KVM.
>> See splat [0]. The test is to spawn 100 VMs all doing standard debian
>> installation (Thanks to Marc's automated scripts, available here [1] ).
>> The problem has been reproduced with a better rate of success from 5.1-rc6
>> onwards.
>>
>> The issue is only reproducible with swapping enabled and the entire
>> memory is used up, when swapping heavily. Also this issue is only reproducible
>> on only one server with 128GB, which has the following memory layout:
>>
>> [32GB@4GB, hole , 96GB@544GB]
>>
>> Here is my non-expert analysis of the issue so far.
>>
>> Under extreme memory pressure, the kswapd could trigger reset_isolation_suitable()
>> to figure out the cached values for migrate/free pfn for a zone, by scanning through
>> the entire zone. On our server it does so in the range of [ 0x10_0000, 0xa00_0000 ],
>> with the following area of holes : [ 0x20_0000, 0x880_0000 ].
>> In the failing case, we end up setting the cached migrate pfn as : 0x508_0000, which
>> is right in the center of the zone pfn range. i.e ( 0x10_0000 + 0xa00_0000 ) / 2,
>> with reset_migrate = 0x88_4e00, reset_free = 0x10_0000.
>>
>> Now these cached values are used by the fast_isolate_freepages() to find a pfn. However,
>> since we cant find anything during the search we fall back to using the page belonging
>> to the min_pfn (which is the migrate_pfn), without proper checks to see if that is valid
>> PFN or not. This is then passed on to fast_isolate_around() which tries to do :
>> set_pageblock_skip(page) on the page which blows up due to an NULL mem_section pointer.
>>
>> The following patch seems to fix the issue for me, but I am not quite convinced that
>> it is the right fix. Thoughts ?
>>
> 
> I think the patch is valid and the alternatives would be unnecessarily
> complicated. During a normal scan for free pages to isolate, there
> is a check for pageblock_pfn_to_page() which uses a pfn_valid check
> for non-contiguous zones in __pageblock_pfn_to_page. Now, while the

I had the initial version with the pageblock_pfn_to_page(), but as you said,
it is a complicated way of perform the same check as pfn_valid().

> non-contiguous check could be made in the area you highlight, it would be a
> relatively small optimisation that would be unmeasurable overall. However,
> it is definitely the case that if the PFN you highlight is invalid that
> badness happens. If you want to express this as a signed-off patch with
> an adjusted changelog then I'd be happy to add

Sure, will send it right away.

> 
> Reviewed-by: Mel Gorman <mgorman@techsingularity.net>
> 

Thanks.

Suzuki
