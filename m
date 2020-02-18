Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D057162ACB
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgBRQhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:37:47 -0500
Received: from mga18.intel.com ([134.134.136.126]:50244 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgBRQhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 11:37:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 08:37:46 -0800
X-IronPort-AV: E=Sophos;i="5.70,456,1574150400"; 
   d="scan'208";a="224189171"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 08:37:46 -0800
Message-ID: <31383bb111737c9f8ffbb1e6e4446cb4fd620a53.camel@linux.intel.com>
Subject: Re: [PATCH v17 0/9] mm / virtio: Provide support for free page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     mgorman@techsingularity.net
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org, vbabka@suse.cz,
        osalvador@suse.de
Date:   Tue, 18 Feb 2020 08:37:46 -0800
In-Reply-To: <20200211161927.1068232d044e892782aef9ae@linux-foundation.org>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
         <20200211150510.ca864143284c8ccaa906f524@linux-foundation.org>
         <c45a6e8ab6af089da1001c0db28783dcea6bebd5.camel@linux.intel.com>
         <20200211161927.1068232d044e892782aef9ae@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-02-11 at 16:19 -0800, Andrew Morton wrote:
> On Tue, 11 Feb 2020 15:55:31 -0800 Alexander Duyck <alexander.h.duyck@linux.intel.com> wrote:
> 
> > On the host I just have to monitor /proc/meminfo and I can see the
> > difference. I get the following results on the host, in the enabled case
> > it takes about 30 seconds for it to settle into the final state since I
> > only report page a bit at a time:
> > Baseline/Applied
> >   MemTotal:    131963012 kB
> >   MemFree:      95189740 kB
> > 
> > Enabled:
> >   MemTotal:    131963012 kB
> >   MemFree:     126459472 kB
> > 
> > This is what I was referring to with the comment above. I had a test I was
> > running back around the first RFC that consisted of bringing up enough VMs
> > so that there was a bit of memory overcommit and then having the VMs in
> > turn run memhog. As I recall the difference between the two was  something
> > like a couple minutes to run through all the VMs as the memhog would take
> > up to 40+ seconds for one that was having to pull from swap while it took
> > only 5 to 7 seconds for the VMs that were all running the page hinting.
> > 
> > I had referenced it here in the RFC:
> > https://lore.kernel.org/lkml/20190204181118.12095.38300.stgit@localhost.localdomain/
> > 
> > I have been verifying the memory has been getting freed but didn't feel
> > like the test added much value so I haven't added it to the cover page for
> > a while since the time could vary widely and is dependent on things like
> > the disk type used for the host swap since my SSD is likely faster than
> > spinning rust, but may not be as fast as other SSDs on the market. Since
> > the disk speed can play such a huge role I wasn't comfortable posting
> > numbers since the benefits could vary so widely.
> 
> OK, thanks.  I'll add the patches to the mm pile.  The new
> mm/page_reporting.c is unreviewed afaict, so I guess you own that for
> now ;)
> 
> It would be very nice to get some feedback from testers asserting "yes,
> this really helped my workload" but I understand this sort of testing
> is hard to obtain at this stage.
> 

Mel,

Any ETA on when you would be available to review these patches? They are
now in Andrew's tree and in linux-next. I am hoping to get any remaining
review from the community sorted out in the next few weeks so I can move
onto focusing on how best to exert pressure on the page cache so that we
can keep the guest memory footprint small.

Thanks.

- Alex

