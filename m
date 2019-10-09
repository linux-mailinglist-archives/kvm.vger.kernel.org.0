Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82800D1421
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 18:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731719AbfJIQfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 12:35:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:46952 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbfJIQfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 12:35:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 09:35:18 -0700
X-IronPort-AV: E=Sophos;i="5.67,276,1566889200"; 
   d="scan'208";a="187670690"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 09:35:17 -0700
Message-ID: <22ce946f7a5cf0b7b4c8058c400d8b9b4c63a5a5.camel@linux.intel.com>
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 09 Oct 2019 09:35:17 -0700
In-Reply-To: <5c640ecb-cfef-2fa6-57aa-1352f1036f4e@redhat.com>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
         <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
         <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
         <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
         <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
         <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com>
         <CAKgT0Ud6TT=XxqFx6ePHzbUYqMp5FHVPozRvnNZK3tKV7j2xjg@mail.gmail.com>
         <0a16b11e-ec3b-7196-5b7f-e7395876cf28@redhat.com>
         <d96f744d2c48f5a96c6962c6a0a89d2429e5cab8.camel@linux.intel.com>
         <7fc13837-546c-9c4a-1456-753df199e171@redhat.com>
         <5b6e0b6df46c03bfac906313071ac0362d43c432.camel@linux.intel.com>
         <c2fd074b-1c86-cd93-41ea-ae1a6b2ca841@redhat.com>
         <5c640ecb-cfef-2fa6-57aa-1352f1036f4e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-10-09 at 11:21 -0400, Nitesh Narayan Lal wrote:
> On 10/7/19 1:06 PM, Nitesh Narayan Lal wrote:
> [...]
> > > So what was the size of your guest? One thing that just occurred to me is
> > > that you might be running a much smaller guest than I was.
> > I am running a 30 GB guest.
> > 
> > > > >  If so I would have expected a much higher difference versus
> > > > > baseline as zeroing/faulting the pages in the host gets expensive fairly
> > > > > quick. What is the host kernel you are running your test on? I'm just
> > > > > wondering if there is some additional overhead currently limiting your
> > > > > setup. My host kernel was just the same kernel I was running in the guest,
> > > > > just built without the patches applied.
> > > > Right now I have a different host-kernel. I can install the same kernel to the
> > > > host as well and see if that changes anything.
> > > The host kernel will have a fairly significant impact as I recall. For
> > > example running a stock CentOS kernel lowered the performance compared to
> > > running a linux-next kernel. As a result the numbers looked better since
> > > the overall baseline was lower to begin with as the host OS was
> > > introducing additional overhead.
> > I see in that case I will try by installing the same guest kernel
> > to the host as well.
> 
> As per your suggestion, I tried replacing the host kernel with an
> upstream kernel without my patches i.e., my host has a kernel built on top
> of the upstream kernel's master branch which has Sept 23rd commit and the guest
> has the same kernel for the no-hinting case and same kernel + my patches
> for the page reporting case.
> 
> With the changes reported earlier on top of v12, I am not seeing any further
> degradation (other than what I have previously reported).
> 
> To be sure that THP is actively used, I did an experiment where I changed the
> MEMSIZE in the page_fault. On doing so THP usage checked via /proc/meminfo also
> increased as I expected.
> 
> In any case, if you find something else please let me know and I will look into it
> again.
> 
> 
> I am still looking into your suggestion about cache line bouncing and will reply
> to it, if I have more questions.
> 
> 
> [...]

I really feel like this discussion has gone off course. The idea here is
to review this patch set[1] and provide working alternatives if there are
issues with the current approach.

The bitmap based approach still has a number of outstanding issues
including sparse memory and hotplug which have yet to be addressed. We can
gloss over that, but there is a good chance that resolving those would
have potential performance implications. With this most recent change
there is now also the fact that it can only really support reporting at
one page order so the solution is now much more prone to issues with
memory fragmentation than it was before. I would consider the fact that my
solution works with multiple page orders while the bitmap approach
requires MAX_ORDER - 1 seems like another obvious win for my solution.
Until we can get back to the point where we are comparing apples to apples
I would prefer not to benchmark the bitmap solution as without the extra
order limitation it was over 20% worse then my solution performance wise.

Ideally I would like to get code review for patches 3 and 4, and spend my
time addressing issues reported there. The main things I need input on is
if the solution of allowing the list iterators to be reset is good enough
to address the compaction issues that were pointed out several releases
ago or if I have to look for another solution. Also I have changed things
so that page_reporting.h was split over two files with the new one now
living in the mm/ folder. By doing that I was hoping to reduce the
exposure of the internal state of the free-lists so that essentially all
we end up providing is an interface for the notifier to be used by virtio-
balloon.

Thanks.

- Alex

[1]: https://lore.kernel.org/lkml/20191001152441.27008.99285.stgit@localhost.localdomain/

