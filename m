Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2079159DE0
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 01:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgBLATa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 19:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgBLATa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 19:19:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4DF1206D6;
        Wed, 12 Feb 2020 00:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581466768;
        bh=w9zWL4o2HAKds3LpMaqdUwP5gcbuhFqnYi3cxNKDsT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jDUI8gnVwIzyE5ZFs/uNqKwQrQ7QYN7VBXMtsDohVxxnUH9dh6iOM9LNSKNDF+PXy
         OYBfkKCBSzhwo4Qeu5YfTRLcG3vguj5B13PRIz8r4WtTtF8DxP/ERu9ib+3bchW2vw
         kTJmZR3eqlWwTQQMHDMiUrmOGETamNHy+pzbRERk=
Date:   Tue, 11 Feb 2020 16:19:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        david@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org, vbabka@suse.cz,
        osalvador@suse.de
Subject: Re: [PATCH v17 0/9] mm / virtio: Provide support for free page
 reporting
Message-Id: <20200211161927.1068232d044e892782aef9ae@linux-foundation.org>
In-Reply-To: <c45a6e8ab6af089da1001c0db28783dcea6bebd5.camel@linux.intel.com>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
        <20200211150510.ca864143284c8ccaa906f524@linux-foundation.org>
        <c45a6e8ab6af089da1001c0db28783dcea6bebd5.camel@linux.intel.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Feb 2020 15:55:31 -0800 Alexander Duyck <alexander.h.duyck@linux.intel.com> wrote:

> On the host I just have to monitor /proc/meminfo and I can see the
> difference. I get the following results on the host, in the enabled case
> it takes about 30 seconds for it to settle into the final state since I
> only report page a bit at a time:
> Baseline/Applied
>   MemTotal:    131963012 kB
>   MemFree:      95189740 kB
> 
> Enabled:
>   MemTotal:    131963012 kB
>   MemFree:     126459472 kB
> 
> This is what I was referring to with the comment above. I had a test I was
> running back around the first RFC that consisted of bringing up enough VMs
> so that there was a bit of memory overcommit and then having the VMs in
> turn run memhog. As I recall the difference between the two was  something
> like a couple minutes to run through all the VMs as the memhog would take
> up to 40+ seconds for one that was having to pull from swap while it took
> only 5 to 7 seconds for the VMs that were all running the page hinting.
> 
> I had referenced it here in the RFC:
> https://lore.kernel.org/lkml/20190204181118.12095.38300.stgit@localhost.localdomain/
> 
> I have been verifying the memory has been getting freed but didn't feel
> like the test added much value so I haven't added it to the cover page for
> a while since the time could vary widely and is dependent on things like
> the disk type used for the host swap since my SSD is likely faster than
> spinning rust, but may not be as fast as other SSDs on the market. Since
> the disk speed can play such a huge role I wasn't comfortable posting
> numbers since the benefits could vary so widely.

OK, thanks.  I'll add the patches to the mm pile.  The new
mm/page_reporting.c is unreviewed afaict, so I guess you own that for
now ;)

It would be very nice to get some feedback from testers asserting "yes,
this really helped my workload" but I understand this sort of testing
is hard to obtain at this stage.

