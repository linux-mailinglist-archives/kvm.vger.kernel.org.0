Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D2F75216
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388871AbfGYPFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 11:05:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:45598 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388312AbfGYPFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 11:05:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 08:05:30 -0700
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="321690255"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 08:05:30 -0700
Message-ID: <bc162a5eaa58ac074c8ad20cb23d579aa04d0f43.camel@linux.intel.com>
Subject: Re: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble
 hinting"
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, riel@surriel.com, konrad.wilk@oracle.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Date:   Thu, 25 Jul 2019 08:05:30 -0700
In-Reply-To: <fed474fe-93f4-a9f6-2e01-75e8903edd81@redhat.com>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
         <20190724171050.7888.62199.stgit@localhost.localdomain>
         <20190724173403-mutt-send-email-mst@kernel.org>
         <ada4e7d932ebd436d00c46e8de699212e72fd989.camel@linux.intel.com>
         <fed474fe-93f4-a9f6-2e01-75e8903edd81@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-07-25 at 07:35 -0400, Nitesh Narayan Lal wrote:
> On 7/24/19 6:03 PM, Alexander Duyck wrote:
> > On Wed, 2019-07-24 at 17:38 -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > 
> > > > Add support for what I am referring to as "bubble hinting". Basically the
> > > > idea is to function very similar to how the balloon works in that we
> > > > basically end up madvising the page as not being used. However we don't
> > > > really need to bother with any deflate type logic since the page will be
> > > > faulted back into the guest when it is read or written to.
> > > > 
> > > > This is meant to be a simplification of the existing balloon interface
> > > > to use for providing hints to what memory needs to be freed. I am assuming
> > > > this is safe to do as the deflate logic does not actually appear to do very
> > > > much other than tracking what subpages have been released and which ones
> > > > haven't.
> > > > 
> > > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > BTW I wonder about migration here.  When we migrate we lose all hints
> > > right?  Well destination could be smarter, detect that page is full of
> > > 0s and just map a zero page. Then we don't need a hint as such - but I
> > > don't think it's done like that ATM.
> > I was wondering about that a bit myself. If you migrate with a balloon
> > active what currently happens with the pages in the balloon? Do you
> > actually migrate them, or do you ignore them and just assume a zero page?
> > I'm just reusing the ram_block_discard_range logic that was being used for
> > the balloon inflation so I would assume the behavior would be the same.
> I agree, however, I think it is worth investigating to see if enabling hinting
> adds some sort of overhead specifically in this kind of scenarios. What do you
> think?

I suspect that the hinting/reporting would probably improve migration
times based on the fact that from the sound of things it would just be
migrated as a zero page.

I don't have a good setup for testing migration though and I am not that
familiar with trying to do a live migration. That is one of the reasons
why I didn't want to stray too far from the existing balloon code as that
has already been tested with migration so I would assume as long as I am
doing almost the exact same thing to hint the pages away it should behave
exactly the same.

> > > I also wonder about interaction with deflate.  ATM deflate will add
> > > pages to the free list, then balloon will come right back and report
> > > them as free.
> > I don't know how likely it is that somebody who is getting the free page
> > reporting is likely to want to also use the balloon to take up memory.
> I think it is possible. There are two possibilities:
> 1. User has a workload running, which is allocating and freeing the pages and at
> the same time, user deflates.
> If these new pages get used by this workload, we don't have to worry as you are
> already handling that by not hinting the free pages immediately.
> 2. Guest is idle and the user adds up some memory, for this situation what you
> have explained below does seems reasonable.

Us hinting on pages that are freed up via deflate wouldn't be too big of a
deal. I would think that is something we could look at addressing as more
of a follow-on if we ever needed to since it would just add more
complexity.

Really what I would like to see is the balloon itself get updated first to
perhaps work with variable sized pages first so that we could then have
pages come directly out of the balloon and go back into the freelist as
hinted, or visa-versa where hinted pages could be pulled directly into the
balloon without needing to notify the host.

