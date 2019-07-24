Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62BFD74030
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 22:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfGXUis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 16:38:48 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46558 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfGXUis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 16:38:48 -0400
Received: by mail-qt1-f193.google.com with SMTP id h21so46830318qtn.13
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 13:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mYCnwlDrFOeB58JxVB5YgZuCp6wcmGxGKrxXr5i4nBc=;
        b=Q/CRKbIZ40QVZez34Z7yZ5+4DVVOmhgLdpv2ae/Fwbfg+m/QtOStG6Je+/qBT5u/0u
         qLiNHeMjrmpTKNkye6UIbNAQkWGPn2yjJJnhtgPGJ9AaevwN2A1xF9P5QoOpIkCvgWiA
         xbUxmy4e/RwN0nVz+NfaP2nOqxLbAYNXI7vR1lTAPVJZFBh4fEAymXgwjWaP/laIuTQp
         G/JpjBa0mzwzRmIdmFjS5D5dBBFLiZ3XrHvdeYrwsjtSsAD+5P7IOBRRP9Tdpkz+AepD
         l6Z1uo7LQIQUKIugACfBVi0+QjRjYYvqt0j63IUEBfAn7ZRAy6r9a7KbjKzvjbSr9QxA
         qKUQ==
X-Gm-Message-State: APjAAAW6DTRqG8Tm2iKh7r6UCtotjru1gnJRyYO0J/p7hd3gHD3FVAvZ
        NcMc1g9U/nv/hgGYS+cenHK/EQ==
X-Google-Smtp-Source: APXvYqwU3o8Gh0p3iTRF2eUwetU3mRzbYpX3En+58mi7Qps50FM4raDCZMFHQwALO71XaeJ6K+oBpg==
X-Received: by 2002:ac8:394b:: with SMTP id t11mr58254877qtb.286.1564000727125;
        Wed, 24 Jul 2019 13:38:47 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id a23sm19743310qtp.22.2019.07.24.13.38.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 13:38:46 -0700 (PDT)
Date:   Wed, 24 Jul 2019 16:38:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, riel@surriel.com, konrad.wilk@oracle.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Subject: Re: [PATCH v2 0/5] mm / virtio: Provide support for page hinting
Message-ID: <20190724163516-mutt-send-email-mst@kernel.org>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <0c520470-4654-cdf2-cf4d-d7c351d25e8b@redhat.com>
 <088abe33117e891dd6265179f678847bd574c744.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <088abe33117e891dd6265179f678847bd574c744.camel@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 24, 2019 at 01:27:35PM -0700, Alexander Duyck wrote:
> On Wed, 2019-07-24 at 14:40 -0400, Nitesh Narayan Lal wrote:
> > On 7/24/19 12:54 PM, Alexander Duyck wrote:
> > > This series provides an asynchronous means of hinting to a hypervisor
> > > that a guest page is no longer in use and can have the data associated
> > > with it dropped. To do this I have implemented functionality that allows
> > > for what I am referring to as page hinting
> > > 
> > > The functionality for this is fairly simple. When enabled it will allocate
> > > statistics to track the number of hinted pages in a given free area. When
> > > the number of free pages exceeds this value plus a high water value,
> > > currently 32,
> > Shouldn't we configure this to a lower number such as 16?
> 
> Yes, we could do 16.
> 
> > >  it will begin performing page hinting which consists of
> > > pulling pages off of free list and placing them into a scatter list. The
> > > scatterlist is then given to the page hinting device and it will perform
> > > the required action to make the pages "hinted", in the case of
> > > virtio-balloon this results in the pages being madvised as MADV_DONTNEED
> > > and as such they are forced out of the guest. After this they are placed
> > > back on the free list, and an additional bit is added if they are not
> > > merged indicating that they are a hinted buddy page instead of a standard
> > > buddy page. The cycle then repeats with additional non-hinted pages being
> > > pulled until the free areas all consist of hinted pages.
> > > 
> > > I am leaving a number of things hard-coded such as limiting the lowest
> > > order processed to PAGEBLOCK_ORDER,
> > Have you considered making this option configurable at the compile time?
> 
> We could. However, PAGEBLOCK_ORDER is already configurable on some
> architectures. I didn't see much point in making it configurable in the
> case of x86 as there are only really 2 orders that this could be used in
> that provided good performance and that MAX_ORDER - 1 and PAGEBLOCK_ORDER.
> 
> > >  and have left it up to the guest to
> > > determine what the limit is on how many pages it wants to allocate to
> > > process the hints.
> > It might make sense to set the number of pages to be hinted at a time from the
> > hypervisor.
> 
> We could do that. Although I would still want some upper limit on that as
> I would prefer to keep the high water mark as a static value since it is
> used in an inline function. Currently the virtio driver is the one
> defining the capacity of pages per request.
> 
> > > My primary testing has just been to verify the memory is being freed after
> > > allocation by running memhog 79g on a 80g guest and watching the total
> > > free memory via /proc/meminfo on the host. With this I have verified most
> > > of the memory is freed after each iteration. As far as performance I have
> > > been mainly focusing on the will-it-scale/page_fault1 test running with
> > > 16 vcpus. With that I have seen at most a 2% difference between the base
> > > kernel without these patches and the patches with virtio-balloon disabled.
> > > With the patches and virtio-balloon enabled with hinting the results
> > > largely depend on the host kernel. On a 3.10 RHEL kernel I saw up to a 2%
> > > drop in performance as I approached 16 threads,
> > I think this is acceptable.
> > >  however on the the lastest
> > > linux-next kernel I saw roughly a 4% to 5% improvement in performance for
> > > all tests with 8 or more threads. 
> > Do you mean that with your patches the will-it-scale/page_fault1 numbers were
> > better by 4-5% over an unmodified kernel?
> 
> Yes. That is the odd thing. I am wondering if there was some improvement
> in the zeroing of THP pages or something that is somehow improving the
> cache performance for the accessing of the pages by the test in the guest.

Well cache is indexed by the PA on intel, right?  So if you end up never
writing into the pages, reading them will be faster because you will end
up with a zero page. This will be offset by a fault when you finally do
write into the page.

> > > I believe the difference seen is due to
> > > the overhead for faulting pages back into the guest and zeroing of memory.
> > It may also make sense to test these patches with netperf to observe how much
> > performance drop it is introducing.
> 
> Do you have some test you were already using? I ask because I am not sure
> netperf would generate a large enough memory window size to really trigger
> much of a change in terms of hinting. If you have some test in mind I
> could probably set it up and run it pretty quick.
> 
> > > Patch 4 is a bit on the large side at about 600 lines of change, however
> > > I really didn't see a good way to break it up since each piece feeds into
> > > the next. So I couldn't add the statistics by themselves as it didn't
> > > really make sense to add them without something that will either read or
> > > increment/decrement them, or add the Hinted state without something that
> > > would set/unset it. As such I just ended up adding the entire thing as
> > > one patch. It makes it a bit bigger but avoids the issues in the previous
> > > set where I was referencing things before they had been added.
> > > 
> > > Changes from the RFC:
> > > https://lore.kernel.org/lkml/20190530215223.13974.22445.stgit@localhost.localdomain/
> > > Moved aeration requested flag out of aerator and into zone->flags.
> > > Moved bounary out of free_area and into local variables for aeration.
> > > Moved aeration cycle out of interrupt and into workqueue.
> > > Left nr_free as total pages instead of splitting it between raw and aerated.
> > > Combined size and physical address values in virtio ring into one 64b value.
> > > 
> > > Changes from v1:
> > > https://lore.kernel.org/lkml/20190619222922.1231.27432.stgit@localhost.localdomain/
> > > Dropped "waste page treatment" in favor of "page hinting"
> > We may still have to try and find a better name for virtio-balloon side changes.
> > As "FREE_PAGE_HINT" and "PAGE_HINTING" are still confusing.
> 
> We just need to settle on a name. Essentially all this requires is just a
> quick find and replace with whatever name we decide on.
