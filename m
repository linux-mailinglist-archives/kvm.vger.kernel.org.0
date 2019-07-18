Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C406C969
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 08:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfGRGsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 02:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfGRGsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 02:48:04 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9342D30BC590;
        Thu, 18 Jul 2019 06:48:03 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5B13B19C65;
        Thu, 18 Jul 2019 06:47:53 +0000 (UTC)
Date:   Thu, 18 Jul 2019 02:47:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wei Wang <wei.w.wang@intel.com>
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
Message-ID: <20190718024408-mutt-send-email-mst@kernel.org>
References: <20190717071332-mutt-send-email-mst@kernel.org>
 <286AC319A985734F985F78AFA26841F73E16D4B2@shsmsx102.ccr.corp.intel.com>
 <20190718000434-mutt-send-email-mst@kernel.org>
 <5D300A32.4090300@intel.com>
 <20190718015319-mutt-send-email-mst@kernel.org>
 <5D3011E9.4040908@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D3011E9.4040908@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 18 Jul 2019 06:48:03 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 02:30:01PM +0800, Wei Wang wrote:
> On 07/18/2019 01:58 PM, Michael S. Tsirkin wrote:
> > 
> > what if it does not fail?
> > 
> > 
> > > Shrinker is called on system memory pressure. On memory pressure
> > > get_free_page_and_send will fail memory allocation, so it stops allocating
> > > more.
> > Memory pressure could be triggered by an unrelated allocation
> > e.g. from another driver.
> 
> As memory pressure is system-wide (no matter who triggers it), free page
> hinting
> will fail on memory pressure, same as other drivers.

That would be good.  Except instead of failing it can hit a race
condition where it will reallocate memory freed by shrinker. Not good.

Yes lots of drivers do that but they do not drink up memory
quite as aggressively as page hinting.


> As long as the page allocation succeeds, we could just think the system is
> not in
> the memory pressure situation, then thing could go on normally.

Given we have a shrinker callback we can't pretend we don't
know or care.

> Also, the VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG includes NORETRY and
> NOMEMALLOC,
> which makes it easier than most other drivers to fail allocation first.
> 
> Best,
> Wei

It's a classic race condition and I don't see why do arguments
about probability matter. With a big fleet of machines
it is guaranteed to happen on some.

-- 
MST
