Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C66E10B48C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 18:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfK0RgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 12:36:07 -0500
Received: from mga07.intel.com ([134.134.136.100]:39510 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0RgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 12:36:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 09:36:06 -0800
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="359568518"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 09:36:06 -0800
Message-ID: <57f4c78f298a5e3d929c0026f7b323a3bb911848.camel@linux.intel.com>
Subject: Re: [PATCH v14 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Wed, 27 Nov 2019 09:36:06 -0800
In-Reply-To: <905bf376-b8a5-d101-fb8e-ec8aa9ce500e@redhat.com>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
         <052f7442-4500-cd02-af2e-56d2f97a232c@redhat.com>
         <2cd804f781b55d5c20e970dcd67b472fba6e1387.camel@linux.intel.com>
         <905bf376-b8a5-d101-fb8e-ec8aa9ce500e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-11-27 at 11:01 +0100, David Hildenbrand wrote:
> On 26.11.19 17:45, Alexander Duyck wrote:
> > On Tue, 2019-11-26 at 13:20 +0100, David Hildenbrand wrote:
> > > On 19.11.19 22:46, Alexander Duyck wrote:

<snip>

> > > > Below are the results from various benchmarks. I primarily focused on two
> > > > tests. The first is the will-it-scale/page_fault2 test, and the other is
> > > > a modified version of will-it-scale/page_fault1 that was enabled to use
> > > > THP. I did this as it allows for better visibility into different parts
> > > > of the memory subsystem. The guest is running with 32G for RAM on one
> > > > node of a E5-2630 v3. The host has had some power saving features disabled
> > > > by setting the /dev/cpu_dma_latency value to 10ms.
> > > > 
> > > > Test                page_fault1 (THP)     page_fault2
> > > > Name         tasks  Process Iter  STDEV  Process Iter  STDEV
> > > > Baseline         1    1203934.75  0.04%     379940.75  0.11%
> > > >                 16    8828217.00  0.85%    3178653.00  1.28%
> > > > 
> > > > Patches applied  1    1207961.25  0.10%     380852.25  0.25%
> > > >                 16    8862373.00  0.98%    3246397.25  0.68%
> > > > 
> > > > Patches enabled  1    1207758.75  0.17%     373079.25  0.60%
> > > >  MADV disabled  16    8870373.75  0.29%    3204989.75  1.08%
> > > > 
> > > > Patches enabled  1    1261183.75  0.39%     373201.50  0.50%
> > > >                 16    8371359.75  0.65%    3233665.50  0.84%
> > > > 
> > > > Patches enabled  1    1090201.50  0.25%     376967.25  0.29%
> > > >  page shuffle   16    8108719.75  0.58%    3218450.25  1.07%
> > > > 
> > > > The results above are for a baseline with a linux-next-20191115 kernel,
> > > > that kernel with this patch set applied but page reporting disabled in
> > > > virtio-balloon, patches applied but the madvise disabled by direct
> > > > assigning a device, the patches applied and page reporting fully
> > > > enabled, and the patches enabled with page shuffling enabled.  These
> > > > results include the deviation seen between the average value reported here
> > > > versus the high and/or low value. I observed that during the test memory
> > > > usage for the first three tests never dropped whereas with the patches
> > > > fully enabled the VM would drop to using only a few GB of the host's
> > > > memory when switching from memhog to page fault tests.
> > > > 
> > > > Most of the overhead seen with this patch set enabled seems due to page
> > > > faults caused by accessing the reported pages and the host zeroing the page
> > > > before giving it back to the guest. This overhead is much more visible when
> > > > using THP than with standard 4K pages. In addition page shuffling seemed to
> > > > increase the amount of faults generated due to an increase in memory churn.
> > > 
> > > MADV_FREE would be interesting.
> > 
> > I can probably code something up. However that is going to push a bunch of
> > complexity into the QEMU code and doesn't really mean much to the kernel
> > code. I can probably add it as another QEMU patch to the set since it is
> > just a matter of having a function similar to ram_block_discard_range that
> > uses MADV_FREE instead of MADV_DONTNEED.
> 
> Yes, addon patch makes perfect sense. The nice thing about MADV_FREE is
> that you only take back pages from a process when really under memory
> pressure (before going to SWAP). You will still get a pagefault on the
> next access (to identify that the page is still in use after all), but
> don't have to fault in a fresh page.

So I got things running with a proof of concept using MADV_FREE.
Apparently another roadblock I hadn't realized is that you have to have
the right version of glibc for MADV_FREE to be present.

Anyway with MADV_FREE the numbers actually look pretty close to the
numbers with the madvise disabled. Apparently the page fault overhead
isn't all that significant. When I push the next patch set I will include
the actual numbers, but even with shuffling enabled the results were in
the 8.7 to 8.8 million iteration range.

