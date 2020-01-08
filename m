Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87971347F7
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 17:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgAHQ3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 11:29:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:35418 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgAHQ3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 11:29:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 08:29:02 -0800
X-IronPort-AV: E=Sophos;i="5.69,410,1571727600"; 
   d="scan'208";a="395791419"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 08:29:02 -0800
Message-ID: <7d17cfca5edc9b26f194b7086e4a7ef7aaedf5db.camel@linux.intel.com>
Subject: Re: [PATCH v16 0/9] mm / virtio: Provide support for free page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Wed, 08 Jan 2020 08:29:02 -0800
In-Reply-To: <aebf72d6-3383-fcc5-7cea-efb930e4e245@redhat.com>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
         <aebf72d6-3383-fcc5-7cea-efb930e4e245@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-01-08 at 02:57 -0500, Nitesh Narayan Lal wrote:
> On 1/3/20 4:16 PM, Alexander Duyck wrote:

<snip>

> > Below are the results from various benchmarks. I primarily focused on two
> > tests. The first is the will-it-scale/page_fault2 test, and the other is
> > a modified version of will-it-scale/page_fault1 that was enabled to use
> > THP. I did this as it allows for better visibility into different parts
> > of the memory subsystem. The guest is running with 32G for RAM on one
> > node of a E5-2630 v3. The host has had some features such as CPU turbo
> > disabled in the BIOS.
> > 
> > Test                   page_fault1 (THP)    page_fault2
> > Name            tasks  Process Iter  STDEV  Process Iter  STDEV
> > Baseline            1    1012402.50  0.14%     361855.25  0.81%
> >                    16    8827457.25  0.09%    3282347.00  0.34%
> > 
> > Patches Applied     1    1007897.00  0.23%     361887.00  0.26%
> >                    16    8784741.75  0.39%    3240669.25  0.48%
> > 
> > Patches Enabled     1    1010227.50  0.39%     359749.25  0.56%
> >                    16    8756219.00  0.24%    3226608.75  0.97%
> > 
> > Patches Enabled     1    1050982.00  4.26%     357966.25  0.14%
> >  page shuffle      16    8672601.25  0.49%    3223177.75  0.40%
> > 
> > Patches Enabled     1    1003238.00  0.22%     360211.00  0.22%
> >  shuffle w/ RFC    16    8767010.50  0.32%    3199874.00  0.71%
> 
> Just to be sure that I understand your test setup correctly:
> - You have a 32GB guest with a single node affined to a single node of your host
> (E5-2630).
> - You have THP in both host and the guest enabled and set to 'madvise'.
> - On top of the default x86_64 config and other virtio config options you have
> CONFIG_SLAB_FREELIST_RANDOM and CONFIG_SHUFFLE_PAGE_ALLOCATOR enabled for the
> third observation (Patches Enabled page shuffle).
> did I miss anything?

So the only things I think you overlooked was that CPU turbo was disbled
int eh BIOS. Without that my numbers were much more unpredictable as the
CPUs were turboing up and down and me and giving me inconsistent results.

Also one thing I forgot to mention is that I had to modify the grub kernel
command line to include page_alloc.shuffle=Y so that the page shuffling
was actually active.

> Can you also remind me of the reason you have skipped recording the number of
> threads count reported as part of page_fault tests? Was it because you were
> observing different values with every fresh boot?

Mainly because the threads test gave me data that was all over the place
at higher task counts and because it doesn't scale as well as the
processes test case. The averages between the two worked out to be about
the same, but the standard deviation was maxing out at 7% for the baseline
and 8% for the patches enabled case. However the differences in the
averages is still less than 1%.

So for example the same data using the threads values for Baseline vs
Patches enabled comes out as follows:
Baseline                1    1133900.25  0.24%     358395.25  0.30%
                       16    5848684.75  6.96%    2181989.00  1.69%

Patches Enabled         1    1132748.50  0.20%     356615.00  0.11%
                       16    5796647.00  8.38%    2160475.50  1.84%

> > The results above are for a baseline with a linux-next-20191219 kernel,
> > that kernel with this patch set applied but page reporting disabled in
> > virtio-balloon, the patches applied and page reporting fully enabled, the
> > patches enabled with page shuffling enabled, and the patches applied with
> > page shuffling enabled and an RFC patch that makes used of MADV_FREE in
> > QEMU. These results include the deviation seen between the average value
> > reported here versus the high and/or low value. I observed that during the
> > test memory usage for the first three tests never dropped whereas with the
> > patches fully enabled the VM would drop to using only a few GB of the
> > host's memory when switching from memhog to page fault tests.
> 
> Do you mean that in the later case you run the page fault tests after memhog?
> If so how much memory do you pass to memhog?

For every test I would run memhog 32g in the guest to make sure all memory
was allocated at least once before running the page fault tests. I was
using that to make certain that the page reporting was working before
running the test.

That way the baseline gives more consistent results as we don't have to
worry about there being any memory the guest has yet to fault in.

