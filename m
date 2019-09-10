Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BB2AF243
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 22:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfIJU0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 16:26:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:38771 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725263AbfIJU0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 16:26:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 13:26:25 -0700
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="175429665"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 13:26:24 -0700
Message-ID: <ab45e54fd81589c0e9a0645be5f0b9b4027b93ba.camel@linux.intel.com>
Subject: Re: [PATCH v9 3/8] mm: Move set/get_pcppage_migratetype to mmzone.h
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date:   Tue, 10 Sep 2019 13:26:24 -0700
In-Reply-To: <20190910174553.GC4023@dhcp22.suse.cz>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190907172528.10910.37051.stgit@localhost.localdomain>
         <20190910122313.GW2063@dhcp22.suse.cz>
         <CAKgT0Ud1xqhEy_LL4AfMgreP0uXrkF-fSDn=6uDXfn7Pvj5AAw@mail.gmail.com>
         <20190910174553.GC4023@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-09-10 at 19:45 +0200, Michal Hocko wrote:
> On Tue 10-09-19 07:46:50, Alexander Duyck wrote:
> > On Tue, Sep 10, 2019 at 5:23 AM Michal Hocko <mhocko@kernel.org> wrote:
> > > On Sat 07-09-19 10:25:28, Alexander Duyck wrote:
> > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > 
> > > > In order to support page reporting it will be necessary to store and
> > > > retrieve the migratetype of a page. To enable that I am moving the set and
> > > > get operations for pcppage_migratetype into the mm/internal.h header so
> > > > that they can be used outside of the page_alloc.c file.
> > > 
> > > Please describe who is the user and why does it needs this interface.
> > > This is really important because migratetype is an MM internal thing and
> > > external users shouldn't really care about it at all. We really do not
> > > want a random code to call those, especially the set_pcppage_migratetype.
> > 
> > I was using it to store the migratetype of the page so that I could
> > find the boundary list that contained the reported page as the array
> > is indexed based on page order and migratetype. However on further
> > discussion I am thinking I may just use page->index directly to index
> > into the boundary array. Doing that I should be able to get a very
> > slight improvement in lookup time since I am not having to pull order
> > and migratetype and then compute the index based on that. In addition
> > it becomes much more clear as to what is going on, and if needed I
> > could add debug checks to verify the page is "Reported" and that the
> > "Buddy" page type is set.
> 
> Be careful though. A free page belongs to the page allocator and it is
> free to reuse any fields for its purpose so using any of them nilly
> willy is no go. If you need to stuff something like that then there
> better be an api the allocator is aware of. My main objection is the
> abuse migrate type. There might be other ways to express what you need.
> Please make sure you clearly define that though.

I will. Basically if the Reported is set then it will mean that the index
value is in use and provides the index into the boundary array. The
Reported flag will be cleared when the page is pulled from the buddy list
and in the case of the page being allocated it is already overwritten by
__rmqueue_smallest calling set_pcppage_migratetype which is what gave me
the idea to just use that in the first place.

