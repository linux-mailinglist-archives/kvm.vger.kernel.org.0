Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78256C8EB
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 07:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfGRFvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 01:51:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:11596 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfGRFvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 01:51:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 22:51:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="367248561"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2019 22:51:30 -0700
Message-ID: <5D300A32.4090300@intel.com>
Date:   Thu, 18 Jul 2019 13:57:06 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: use of shrinker in virtio balloon free page hinting
References: <20190717071332-mutt-send-email-mst@kernel.org> <286AC319A985734F985F78AFA26841F73E16D4B2@shsmsx102.ccr.corp.intel.com> <20190718000434-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190718000434-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/18/2019 12:13 PM, Michael S. Tsirkin wrote:
>
> It makes sense for pages in the balloon (requested by hypervisor).
> However free page hinting can freeze up lots of memory for its own
> internal reasons. It does not make sense to ask hypervisor
> to set flags in order to fix internal guest issues.

Sounds reasonable to me. Probably we could move the flag check to
shrinker_count and shrinker_scan as a reclaiming condition for
ballooning pages only?


>
> Right. But that does not include the pages in the hint vq,
> which could be a significant amount of memory.

I think it includes, as vb->num_free_page_blocks records the total number
of free page blocks that balloon has taken from mm.

For shrink_free_pages, it calls return_free_pages_to_mm, which pops pages
from vb->free_page_list (this is the list where pages get enlisted after 
they
are put to the hint vq, see get_free_page_and_send).


>
>
>>> - if free pages are being reported, pages freed
>>>    by shrinker will just get re-allocated again
>> fill_balloon will re-try the allocation after sleeping 200ms once allocation fails.
> Even if ballon was never inflated, if shrinker frees some memory while
> we are hinting, hint vq will keep going and allocate it back without
> sleeping.

Still see get_free_page_and_send. -EINTR is returned when page 
allocation fails,
and reporting ends then.

Shrinker is called on system memory pressure. On memory pressure
get_free_page_and_send will fail memory allocation, so it stops 
allocating more.


Best,
Wei
