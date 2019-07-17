Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7A16BE61
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 16:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfGQOeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 10:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfGQOeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 10:34:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2B22A8553A;
        Wed, 17 Jul 2019 14:34:36 +0000 (UTC)
Received: from redhat.com (ovpn-125-71.rdu2.redhat.com [10.10.125.71])
        by smtp.corp.redhat.com (Postfix) with SMTP id 654AF19C59;
        Wed, 17 Jul 2019 14:34:16 +0000 (UTC)
Date:   Wed, 17 Jul 2019 10:34:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, wei.w.wang@intel.com,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: use of shrinker in virtio balloon free page hinting
Message-ID: <20190717103208-mutt-send-email-mst@kernel.org>
References: <20190717071332-mutt-send-email-mst@kernel.org>
 <959237f9-22cc-1e57-e07d-b8dc3ddf9ed6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <959237f9-22cc-1e57-e07d-b8dc3ddf9ed6@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 17 Jul 2019 14:34:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 17, 2019 at 04:10:47PM +0200, David Hildenbrand wrote:
> On 17.07.19 13:20, Michael S. Tsirkin wrote:
> > Wei, others,
> > 
> > ATM virtio_balloon_shrinker_scan will only get registered
> > when deflate on oom feature bit is set.
> > 
> > Not sure whether that's intentional.  Assuming it is:
> > 
> > virtio_balloon_shrinker_scan will try to locate and free
> > pages that are processed by host.
> > The above seems broken in several ways:
> > - count ignores the free page list completely
> > - if free pages are being reported, pages freed
> >   by shrinker will just get re-allocated again
> 
> Trying to answer your questions (not sure if I fully understood what you
> mean)
> 
> virtio_balloon_shrinker_scan() will not be called due to inflation
> requests (balloon_page_alloc()). It will be called whenever the system
> is OOM, e.g., when starting a new application.
> 
> I assume you were expecting the shrinker getting called due to
> balloon_page_alloc(). however, that is not the case as we pass
> "__GFP_NORETRY".

Right but it's possible we exhaust all memory, then
someone else asks for a single page and that invokes
the shrinker.

> 
> To test, something like:
> 
> 1. Start a VM with
> 
> -device virtio-balloon-pci,deflate-on-oom=true
> 
> 2. Inflate the balloon, e.g.,
> 
> QMP: balloon 1024
> QMP: info balloon
> -> 1024
> 
> See how "MemTotal" in /proc/meminfo in the guest won't change
> 
> 3. Run a workload that exhausts memory in the guest (OOM).
> 
> See how the balloon was automatically deflated
> 
> QMP: info balloon
> -> Something bigger than 1024
> 
> 
> Not sure if it is broken, last time I played with it, it worked, but
> that was ~1-2 years ago.
> 
> -- 
> 
> Thanks,
> 
> David / dhildenb

Sorry I was unclear.  The question was about
VIRTIO_BALLOON_F_FREE_PAGE_HINT specifically.

-- 
MST
