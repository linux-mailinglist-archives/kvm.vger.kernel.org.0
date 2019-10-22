Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A11E0EA1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 01:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389778AbfJVXnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 19:43:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:55396 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732854AbfJVXnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 19:43:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 16:43:23 -0700
X-IronPort-AV: E=Sophos;i="5.68,218,1569308400"; 
   d="scan'208";a="372703092"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 16:43:23 -0700
Message-ID: <03b350f7de4b8f75cc3579e6c43f36aa09fd16b2.camel@linux.intel.com>
Subject: Re: [PATCH v12 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        david@redhat.com
Cc:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, vbabka@suse.cz,
        yang.zhang.wz@gmail.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Tue, 22 Oct 2019 16:43:23 -0700
In-Reply-To: <20191022160140.a6954868d59f47b36334b504@linux-foundation.org>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
         <20191022160140.a6954868d59f47b36334b504@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-10-22 at 16:01 -0700, Andrew Morton wrote:
> On Tue, 22 Oct 2019 15:27:52 -0700 Alexander Duyck <alexander.duyck@gmail.com> wrote:
> 
> > Below are the results from various benchmarks. I primarily focused on two
> > tests. The first is the will-it-scale/page_fault2 test, and the other is
> > a modified version of will-it-scale/page_fault1 that was enabled to use
> > THP. I did this as it allows for better visibility into different parts
> > of the memory subsystem. The guest is running on one node of a E5-2630 v3
> > CPU with 48G of RAM that I split up into two logical nodes in the guest
> > in order to test with NUMA as well.
> > 
> > Test		    page_fault1 (THP)     page_fault2
> > Baseline	 1  1256106.33  +/-0.09%   482202.67  +/-0.46%
> >                 16  8864441.67  +/-0.09%  3734692.00  +/-1.23%
> > 
> > Patches applied  1  1257096.00  +/-0.06%   477436.00  +/-0.16%
> >                 16  8864677.33  +/-0.06%  3800037.00  +/-0.19%
> > 
> > Patches enabled	 1  1258420.00  +/-0.04%   480080.00  +/-0.07%
> >  MADV disabled  16  8753840.00  +/-1.27%  3782764.00  +/-0.37%
> > 
> > Patches enabled	 1  1267916.33  +/-0.08%   472075.67  +/-0.39%
> >                 16  8287050.33  +/-0.67%  3774500.33  +/-0.11%
> > 
> > The results above are for a baseline with a linux-next-20191021 kernel,
> > that kernel with this patch set applied but page reporting disabled in
> > virtio-balloon, patches applied but the madvise disabled by direct
> > assigning a device, and the patches applied and page reporting fully
> > enabled.  These results include the deviation seen between the average
> > value reported here versus the high and/or low value. I observed that
> > during the test the memory usage for the first three tests never dropped
> > whereas with the patches fully enabled the VM would drop to using only a
> > few GB of the host's memory when switching from memhog to page fault tests.
> > 
> > Most of the overhead seen with this patch set fully enabled is due to the
> > fact that accessing the reported pages will cause a page fault and the host
> > will have to zero the page before giving it back to the guest. The overall
> > guest size is kept fairly small to only a few GB while the test is running.
> > This overhead is much more visible when using THP than with standard 4K
> > pages. As such for the case where the host memory is not oversubscribed
> > this results in a performance regression, however if the host memory were
> > oversubscribed this patch set should result in a performance improvement
> > as swapping memory from the host can be avoided.
> 
> I'm trying to understand "how valuable is this patchset" and the above
> resulted in some headscratching.
> 
> Overall, how valuable is this patchset?  To real users running real
> workloads?

A more detailed reply is in my response to your comments on patch 3.
Basically the value is for host memory overcommit in that we can avoid
having to go to swap nearly as often and can potentially pack the guests
even tighter with better performance.

> > There is currently an alternative patch set[1] that has been under work
> > for some time however the v12 version of that patch set could not be
> > tested as it triggered a kernel panic when I attempted to test it. It
> > requires multiple modifications to get up and running with performance
> > comparable to this patch set. A follow-on set has yet to be posted. As
> > such I have not included results from that patch set, and I would
> > appreciate it if we could keep this patch set the focus of any discussion
> > on this thread.
> 
> Actually, the rest of us would be interested in a comparison ;)  

I understand that. However, the last time I tried benchmarking that patch
set it blew up into a thread where we kept having to fix things on that
patch set and by the time we were done we weren't benchmarking the v12
patch set anymore since we had made so many modifications to it, and that 
assumes Nitesh and I were in sync. Also I don't know what the current
state of his patch set is as he was working on some additional changes
when we last discussed things.

Ideally that patch set can be reposted with the necessary fixes and then
we can go through any necessary debug, repair, and addressing limitations
there.


