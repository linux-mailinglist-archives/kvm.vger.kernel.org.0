Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910E5B125E
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfILPmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 11:42:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:14349 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732723AbfILPmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 11:42:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 08:42:09 -0700
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="197265089"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 08:42:08 -0700
Message-ID: <b84a3916202a67bcf36da0b6f0e833eb3408339a.camel@linux.intel.com>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Michal Hocko <mhocko@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>
Date:   Thu, 12 Sep 2019 08:42:08 -0700
In-Reply-To: <20190912091925.GM4023@dhcp22.suse.cz>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190910124209.GY2063@dhcp22.suse.cz>
         <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
         <20190910144713.GF2063@dhcp22.suse.cz>
         <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
         <20190910175213.GD4023@dhcp22.suse.cz>
         <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
         <20190911113619.GP4023@dhcp22.suse.cz>
         <CAKgT0UfOp1c+ov=3pBD72EkSB9Vm7mG5G6zJj4=j=UH7zCgg2Q@mail.gmail.com>
         <20190912091925.GM4023@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-09-12 at 11:19 +0200, Michal Hocko wrote:
> On Wed 11-09-19 08:12:03, Alexander Duyck wrote:
> > On Wed, Sep 11, 2019 at 4:36 AM Michal Hocko <mhocko@kernel.org> wrote:
> > > On Tue 10-09-19 14:23:40, Alexander Duyck wrote:
> > > [...]
> > > > We don't put any limitations on the allocator other then that it needs to
> > > > clean up the metadata on allocation, and that it cannot allocate a page
> > > > that is in the process of being reported since we pulled it from the
> > > > free_list. If the page is a "Reported" page then it decrements the
> > > > reported_pages count for the free_area and makes sure the page doesn't
> > > > exist in the "Boundary" array pointer value, if it does it moves the
> > > > "Boundary" since it is pulling the page.
> > > 
> > > This is still a non-trivial limitation on the page allocation from an
> > > external code IMHO. I cannot give any explicit reason why an ordering on
> > > the free list might matter (well except for page shuffling which uses it
> > > to make physical memory pattern allocation more random) but the
> > > architecture seems hacky and dubious to be honest. It shoulds like the
> > > whole interface has been developed around a very particular and single
> > > purpose optimization.
> > 
> > How is this any different then the code that moves a page that will
> > likely be merged to the tail though?
> 
> I guess you are referring to the page shuffling. If that is the case
> then this is an integral part of the allocator for a reason and it is
> very well obvious in the code including the consequences. I do not
> really like an idea of hiding similar constrains behind a generic
> looking feature which is completely detached from the allocator and so
> any future change of the allocator might subtly break it.
> 
> > In our case the "Reported" page is likely going to be much more
> > expensive to allocate and use then a standard page because it will be
> > faulted back in. In such a case wouldn't it make sense for us to want
> > to keep the pages that don't require faults ahead of those pages in
> > the free_list so that they are more likely to be allocated?
> 
> OK, I was suspecting this would pop out. And this is exactly why I
> didn't like an idea of an external code imposing a non obvious constrains
> to the allocator. You simply cannot count with any ordering with the
> page allocator. We used to distinguish cache hot/cold pages in the past
> and pushed pages to the specific end of the free list but that has been
> removed. There are other potential changes like that possible. Shuffling
> is a good recent example.
> 
> Anyway I am not a maintainer of this code. I would really like to hear
> opinions from Mel and Vlastimil here (now CCed - the thread starts
> http://lkml.kernel.org/r/20190907172225.10910.34302.stgit@localhost.localdomain.

One alternative I could do if we are wanting to make things more obvious
would be to add yet another add_to_free_list_XXX function that would be
used specifically for reported pages. The only real requirement I have is
that we have to insert reported pages such that we generate a continuous
block without interleaving non-reported pages in between. So as long as
reported pages are always inserted at the boundary/iterator when we are
actively reporting on a section then I can guarantee the list won't have
gaps formed.

Also as far as the concerns about this being an external user, one thing I
can do is break up the headers a bit and define an internal header in mm/
that defines all the items used by the page allocator, and another in
include/linux/ that defines what is used by devices when receiving the
notifications. It would then help to reduce the likelihood of an outside
entity messing with the page allocator too much.

