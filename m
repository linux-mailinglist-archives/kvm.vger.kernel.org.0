Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F93B0D9B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 13:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfILLLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 07:11:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:55794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730268AbfILLLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 07:11:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1AB9AB764;
        Thu, 12 Sep 2019 11:11:52 +0000 (UTC)
Date:   Thu, 12 Sep 2019 13:11:50 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
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
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
Message-ID: <20190912111150.GQ4023@dhcp22.suse.cz>
References: <20190910124209.GY2063@dhcp22.suse.cz>
 <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
 <20190910144713.GF2063@dhcp22.suse.cz>
 <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
 <20190910175213.GD4023@dhcp22.suse.cz>
 <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
 <20190911113619.GP4023@dhcp22.suse.cz>
 <CAKgT0UfOp1c+ov=3pBD72EkSB9Vm7mG5G6zJj4=j=UH7zCgg2Q@mail.gmail.com>
 <20190912091925.GM4023@dhcp22.suse.cz>
 <20190912102425.wzhhe6ygfgg64sma@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912102425.wzhhe6ygfgg64sma@box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu 12-09-19 13:24:25, Kirill A. Shutemov wrote:
> On Thu, Sep 12, 2019 at 11:19:25AM +0200, Michal Hocko wrote:
> > On Wed 11-09-19 08:12:03, Alexander Duyck wrote:
> > > On Wed, Sep 11, 2019 at 4:36 AM Michal Hocko <mhocko@kernel.org> wrote:
> > > >
> > > > On Tue 10-09-19 14:23:40, Alexander Duyck wrote:
> > > > [...]
> > > > > We don't put any limitations on the allocator other then that it needs to
> > > > > clean up the metadata on allocation, and that it cannot allocate a page
> > > > > that is in the process of being reported since we pulled it from the
> > > > > free_list. If the page is a "Reported" page then it decrements the
> > > > > reported_pages count for the free_area and makes sure the page doesn't
> > > > > exist in the "Boundary" array pointer value, if it does it moves the
> > > > > "Boundary" since it is pulling the page.
> > > >
> > > > This is still a non-trivial limitation on the page allocation from an
> > > > external code IMHO. I cannot give any explicit reason why an ordering on
> > > > the free list might matter (well except for page shuffling which uses it
> > > > to make physical memory pattern allocation more random) but the
> > > > architecture seems hacky and dubious to be honest. It shoulds like the
> > > > whole interface has been developed around a very particular and single
> > > > purpose optimization.
> > > 
> > > How is this any different then the code that moves a page that will
> > > likely be merged to the tail though?
> > 
> > I guess you are referring to the page shuffling. If that is the case
> > then this is an integral part of the allocator for a reason and it is
> > very well obvious in the code including the consequences. I do not
> > really like an idea of hiding similar constrains behind a generic
> > looking feature which is completely detached from the allocator and so
> > any future change of the allocator might subtly break it.
> 
> I don't necessary follow why shuffling is more integral to page allocator
> than reporting would be. It's next to shutffle.c under mm/ and integrated
> in a simillar way.

The main difference from my understanding is that the page reporting is
a more generic looking feature which might grow different users over
time yet there is a hardcoded set of restrictions to the allocator. Page
shuffling is an integral part of the allocator without any other
visibility outside.

-- 
Michal Hocko
SUSE Labs
