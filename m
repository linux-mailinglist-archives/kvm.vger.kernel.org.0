Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA7CAF2D5
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 00:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfIJWOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 18:14:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:57998 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfIJWOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 18:14:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 15:14:48 -0700
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="178822353"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 15:14:48 -0700
Message-ID: <ac75ce0302faa234860a49cc965a6d342b3ca685.camel@linux.intel.com>
Subject: Re: [PATCH v9 1/8] mm: Add per-cpu logic to page shuffling
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Date:   Tue, 10 Sep 2019 15:14:47 -0700
In-Reply-To: <20190910121130.GU2063@dhcp22.suse.cz>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190907172512.10910.74435.stgit@localhost.localdomain>
         <0df2e5d0-af92-04b4-aa7d-891387874039@redhat.com>
         <0ca58fea280b51b83e7b42e2087128789bc9448d.camel@linux.intel.com>
         <20190910121130.GU2063@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-09-10 at 14:11 +0200, Michal Hocko wrote:
> On Mon 09-09-19 08:11:36, Alexander Duyck wrote:
> > On Mon, 2019-09-09 at 10:14 +0200, David Hildenbrand wrote:
> > > On 07.09.19 19:25, Alexander Duyck wrote:
> > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > 
> > > > Change the logic used to generate randomness in the suffle path so that we
> > > > can avoid cache line bouncing. The previous logic was sharing the offset
> > > > and entropy word between all CPUs. As such this can result in cache line
> > > > bouncing and will ultimately hurt performance when enabled.
> > > 
> > > So, usually we perform such changes if there is real evidence. Do you
> > > have any such performance numbers to back your claims?
> > 
> > I'll have to go rerun the test to get the exact numbers. The reason this
> > came up is that my original test was spanning NUMA nodes and that made
> > this more expensive as a result since the memory was both not local to the
> > CPU and was being updated by multiple sockets.
> 
> What was the pattern of page freeing in your testing? I am wondering
> because order 0 pages should be prevailing and those usually go via pcp
> lists so they do not get shuffled unless the batch is full IIRC.

So I am pretty sure my previous data was faulty. One side effect of the
page reporting is that it was evicting pages out of the guest and when the
pages were faulted back in they were coming from local page pools. This
was throwing off my early numbers and making tests look better than they
should have for the reported case.

I had this patch previously merged with another one so I wasn't testing it
on its own, it was instead a part of a bigger set. Now that I have tried
testing it on its own I can see that it has no significant impact on
performance. With that being the case I will probably just drop it.

