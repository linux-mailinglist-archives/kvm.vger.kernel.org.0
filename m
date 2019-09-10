Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DF7AEDA3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393607AbfIJOrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:47:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:48628 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbfIJOrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:47:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA491ABD2;
        Tue, 10 Sep 2019 14:47:14 +0000 (UTC)
Date:   Tue, 10 Sep 2019 16:47:13 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
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
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
Message-ID: <20190910144713.GF2063@dhcp22.suse.cz>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190910124209.GY2063@dhcp22.suse.cz>
 <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue 10-09-19 07:42:43, Alexander Duyck wrote:
> On Tue, Sep 10, 2019 at 5:42 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > I wanted to review "mm: Introduce Reported pages" just realize that I
> > have no clue on what is going on so returned to the cover and it didn't
> > really help much. I am completely unfamiliar with virtio so please bear
> > with me.
> >
> > On Sat 07-09-19 10:25:03, Alexander Duyck wrote:
> > [...]
> > > This series provides an asynchronous means of reporting to a hypervisor
> > > that a guest page is no longer in use and can have the data associated
> > > with it dropped. To do this I have implemented functionality that allows
> > > for what I am referring to as unused page reporting
> > >
> > > The functionality for this is fairly simple. When enabled it will allocate
> > > statistics to track the number of reported pages in a given free area.
> > > When the number of free pages exceeds this value plus a high water value,
> > > currently 32, it will begin performing page reporting which consists of
> > > pulling pages off of free list and placing them into a scatter list. The
> > > scatterlist is then given to the page reporting device and it will perform
> > > the required action to make the pages "reported", in the case of
> > > virtio-balloon this results in the pages being madvised as MADV_DONTNEED
> > > and as such they are forced out of the guest. After this they are placed
> > > back on the free list,
> >
> > And here I am reallly lost because "forced out of the guest" makes me
> > feel that those pages are no longer usable by the guest. So how come you
> > can add them back to the free list. I suspect understanding this part
> > will allow me to understand why we have to mark those pages and prevent
> > merging.
> 
> Basically as the paragraph above mentions "forced out of the guest"
> really is just the hypervisor calling MADV_DONTNEED on the page in
> question. So the behavior is the same as any userspace application
> that calls MADV_DONTNEED where the contents are no longer accessible
> from userspace and attempting to access them will result in a fault
> and the page being populated with a zero fill on-demand page, or a
> copy of the file contents if the memory is file backed.

As I've said I have no idea about virt so this doesn't really tell me
much. Does that mean that if somebody allocates such a page and tries to
access it then virt will handle a fault and bring it back?

-- 
Michal Hocko
SUSE Labs
