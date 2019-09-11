Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D270AFD2B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 14:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfIKMyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 08:54:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:59640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727806AbfIKMyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 08:54:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D587B635;
        Wed, 11 Sep 2019 12:54:51 +0000 (UTC)
Date:   Wed, 11 Sep 2019 14:54:13 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
Message-ID: <20190911125413.GY4023@dhcp22.suse.cz>
References: <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
 <20190910144713.GF2063@dhcp22.suse.cz>
 <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
 <20190910175213.GD4023@dhcp22.suse.cz>
 <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
 <20190911113619.GP4023@dhcp22.suse.cz>
 <20190911080804-mutt-send-email-mst@kernel.org>
 <20190911121941.GU4023@dhcp22.suse.cz>
 <20190911122526.GV4023@dhcp22.suse.cz>
 <4748a572-57b3-31da-0dde-30138e550c3a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4748a572-57b3-31da-0dde-30138e550c3a@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed 11-09-19 14:42:41, David Hildenbrand wrote:
> On 11.09.19 14:25, Michal Hocko wrote:
> > On Wed 11-09-19 14:19:41, Michal Hocko wrote:
> >> On Wed 11-09-19 08:08:38, Michael S. Tsirkin wrote:
> >>> On Wed, Sep 11, 2019 at 01:36:19PM +0200, Michal Hocko wrote:
> >>>> On Tue 10-09-19 14:23:40, Alexander Duyck wrote:
> >>>> [...]
> >>>>> We don't put any limitations on the allocator other then that it needs to
> >>>>> clean up the metadata on allocation, and that it cannot allocate a page
> >>>>> that is in the process of being reported since we pulled it from the
> >>>>> free_list. If the page is a "Reported" page then it decrements the
> >>>>> reported_pages count for the free_area and makes sure the page doesn't
> >>>>> exist in the "Boundary" array pointer value, if it does it moves the
> >>>>> "Boundary" since it is pulling the page.
> >>>>
> >>>> This is still a non-trivial limitation on the page allocation from an
> >>>> external code IMHO. I cannot give any explicit reason why an ordering on
> >>>> the free list might matter (well except for page shuffling which uses it
> >>>> to make physical memory pattern allocation more random) but the
> >>>> architecture seems hacky and dubious to be honest. It shoulds like the
> >>>> whole interface has been developed around a very particular and single
> >>>> purpose optimization.
> >>>>
> >>>> I remember that there was an attempt to report free memory that provided
> >>>> a callback mechanism [1], which was much less intrusive to the internals
> >>>> of the allocator yet it should provide a similar functionality. Did you
> >>>> see that approach? How does this compares to it? Or am I completely off
> >>>> when comparing them?
> >>>>
> >>>> [1] mostly likely not the latest version of the patchset
> >>>> http://lkml.kernel.org/r/1502940416-42944-5-git-send-email-wei.w.wang@intel.com
> >>>
> >>> Linus nacked that one. He thinks invoking callbacks with lots of
> >>> internal mm locks is too fragile.
> >>
> >> I would be really curious how much he would be happy about injecting
> >> other restrictions on the allocator like this patch proposes. This is
> >> more intrusive as it has a higher maintenance cost longterm IMHO.
> > 
> > Btw. I do agree that callbacks with internal mm locks are not great
> > either. We do have a model for that in mmu_notifiers and it is something
> > I do consider PITA, on the other hand it is mostly sleepable part of the
> > interface which makes it the real pain. The above callback mechanism was
> > explicitly documented with restrictions and that the context is
> > essentially atomic with no access to particular struct pages and no
> > expensive operations possible. So in the end I've considered it
> > acceptably painful. Not that I want to override Linus' nack but if
> > virtualization usecases really require some form of reporting and no
> > other way to do that push people to invent even more interesting
> > approaches then we should simply give them/you something reasonable
> > and least intrusive to our internals.
> > 
> 
> The issue with "[PATCH v14 4/5] mm: support reporting free page blocks"
>  is that it cannot really handle the use case we have here if I am not
> wrong. While a page is getting processed by the hypervisor (e.g.
> MADV_DONTNEED), it must not get reused.

What prevents to use the callback to get a list of pfn ranges to work on
and then use something like start_isolate_page_range on the collected
pfn ranges to make sure nobody steals pages from under your feet, do
your thing and drop the isolated state afterwards.

I am saying somethig like because you wouldn't really want a generic
has_unmovable_pages but rather
                if (!page_ref_count(page)) {
                        if (PageBuddy(page))
                                iter += (1 << page_order(page)) - 1;
                        continue;
                }
subset of it.
-- 
Michal Hocko
SUSE Labs
