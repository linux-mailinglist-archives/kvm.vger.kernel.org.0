Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49FC3A64
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 18:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389972AbfJAQVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 12:21:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:35793 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389966AbfJAQVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 12:21:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 09:21:46 -0700
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="181738489"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 09:21:46 -0700
Message-ID: <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Date:   Tue, 01 Oct 2019 09:21:46 -0700
In-Reply-To: <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
         <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-10-01 at 17:35 +0200, David Hildenbrand wrote:
> On 01.10.19 17:29, Alexander Duyck wrote:
> > This series provides an asynchronous means of reporting to a hypervisor
> > that a guest page is no longer in use and can have the data associated
> > with it dropped. To do this I have implemented functionality that allows
> > for what I am referring to as unused page reporting. The advantage of
> > unused page reporting is that we can support a significant amount of
> > memory over-commit with improved performance as we can avoid having to
> > write/read memory from swap as the VM will instead actively participate
> > in freeing unused memory so it doesn't have to be written.
> > 
> > The functionality for this is fairly simple. When enabled it will allocate
> > statistics to track the number of reported pages in a given free area.
> > When the number of free pages exceeds this value plus a high water value,
> > currently 32, it will begin performing page reporting which consists of
> > pulling non-reported pages off of the free lists of a given zone and
> > placing them into a scatterlist. The scatterlist is then given to the page
> > reporting device and it will perform the required action to make the pages
> > "reported", in the case of virtio-balloon this results in the pages being
> > madvised as MADV_DONTNEED. After this they are placed back on their
> > original free list. If they are not merged in freeing an additional bit is
> > set indicating that they are a "reported" buddy page instead of a standard
> > buddy page. The cycle then repeats with additional non-reported pages
> > being pulled until the free areas all consist of reported pages.
> > 
> > In order to try and keep the time needed to find a non-reported page to
> > a minimum we maintain a "reported_boundary" pointer. This pointer is used
> > by the get_unreported_pages iterator to determine at what point it should
> > resume searching for non-reported pages. In order to guarantee pages do
> > not get past the scan I have modified add_to_free_list_tail so that it
> > will not insert pages behind the reported_boundary. Doing this allows us
> > to keep the overhead to a minimum as re-walking the list without the
> > boundary will result in as much as 18% additional overhead on a 32G VM.
> > 
> > 

<snip>

> > As far as possible regressions I have focused on cases where performing
> > the hinting would be non-optimal, such as cases where the code isn't
> > needed as memory is not over-committed, or the functionality is not in
> > use. I have been using the will-it-scale/page_fault1 test running with 16
> > vcpus and have modified it to use Transparent Huge Pages. With this I see
> > almost no difference with the patches applied and the feature disabled.
> > Likewise I see almost no difference with the feature enabled, but the
> > madvise disabled in the hypervisor due to a device being assigned. With
> > the feature fully enabled in both guest and hypervisor I see a regression
> > between -1.86% and -8.84% versus the baseline. I found that most of the
> > overhead was due to the page faulting/zeroing that comes as a result of
> > the pages having been evicted from the guest.
> 
> I think Michal asked for a performance comparison against Nitesh's
> approach, to evaluate if keeping the reported state + tracking inside
> the buddy is really worth it. Do you have any such numbers already? (or
> did my tired eyes miss them in this cover letter? :/)
> 

I thought what Michal was asking for was what was the benefit of using the
boundary pointer. I added a bit up above and to the description for patch
3 as on a 32G VM it adds up to about a 18% difference without factoring in
the page faulting and zeroing logic that occurs when we actually do the
madvise.

Do we have a working patch set for Nitesh's code? The last time I tried
running his patch set I ran into issues with kernel panics. If we have a
known working/stable patch set I can give it a try.

- Alex

