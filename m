Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81536C841
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 06:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfGRENa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 00:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfGRENa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 00:13:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E1FFC053B34;
        Thu, 18 Jul 2019 04:13:29 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1D7AC600D1;
        Thu, 18 Jul 2019 04:13:16 +0000 (UTC)
Date:   Thu, 18 Jul 2019 00:13:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: use of shrinker in virtio balloon free page hinting
Message-ID: <20190718000434-mutt-send-email-mst@kernel.org>
References: <20190717071332-mutt-send-email-mst@kernel.org>
 <286AC319A985734F985F78AFA26841F73E16D4B2@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <286AC319A985734F985F78AFA26841F73E16D4B2@shsmsx102.ccr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 18 Jul 2019 04:13:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 17, 2019 at 03:46:57PM +0000, Wang, Wei W wrote:
> On Wednesday, July 17, 2019 7:21 PM, Michael S. Tsirkin wrote:
> > 
> > Wei, others,
> > 
> > ATM virtio_balloon_shrinker_scan will only get registered when deflate on
> > oom feature bit is set.
> > 
> > Not sure whether that's intentional. 
> 
> Yes, we wanted to follow the old oom behavior, which allows the oom notifier
> to deflate pages only when this feature bit has been negotiated.

It makes sense for pages in the balloon (requested by hypervisor).
However free page hinting can freeze up lots of memory for its own
internal reasons. It does not make sense to ask hypervisor
to set flags in order to fix internal guest issues.

> > Assuming it is:
> > 
> > virtio_balloon_shrinker_scan will try to locate and free pages that are
> > processed by host.
> > The above seems broken in several ways:
> > - count ignores the free page list completely
> 
> Do you mean virtio_balloon_shrinker_count()? It just reports to
> do_shrink_slab the amount of freeable memory that balloon has.
> (vb->num_pages and vb->num_free_page_blocks are all included )

Right. But that does not include the pages in the hint vq,
which could be a significant amount of memory.


> > - if free pages are being reported, pages freed
> >   by shrinker will just get re-allocated again
> 
> fill_balloon will re-try the allocation after sleeping 200ms once allocation fails.

Even if ballon was never inflated, if shrinker frees some memory while
we are hinting, hint vq will keep going and allocate it back without
sleeping.

>  
> > I was unable to make this part of code behave in any reasonable way - was
> > shrinker usage tested? What's a good way to test that?
> 
> Please see the example that I tested before : https://lkml.org/lkml/2018/8/6/29
> (just the first one: *1. V3 patches)
> 
> What problem did you see?
> I just tried the latest code, and find ballooning reports a #GP (seems caused by
> 418a3ab1e). 
> I'll take a look at the details in the office tomorrow.
> 
> Best,
> Wei

I saw that VM hangs. Could be the above problem, let me know how it
goes.

