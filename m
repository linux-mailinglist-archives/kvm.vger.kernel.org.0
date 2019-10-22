Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50BAE0E6C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 01:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbfJVXBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 19:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731850AbfJVXBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 19:01:43 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34DE620700;
        Tue, 22 Oct 2019 23:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571785301;
        bh=2T9O9f/svRRLRKxyJkkAcXdX4HnJ/q4asftEJqtbMwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fq6CI2JNFZcVfartOJC/tzum1u9mn84eNLVA7RSwwc6E2UqvQDeJ+ejcVU+f3GdyP
         nsXZ6EEEh4h2WkVVdxek8GFB00LJR+I5Z41r4Vz99xahSks1Jr2urIbcypYLqVfW8m
         YdOIWILtkmOuSmIVK0ATPlwQITNrqGNxAkvl6g9Q=
Date:   Tue, 22 Oct 2019 16:01:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, vbabka@suse.cz,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Subject: Re: [PATCH v12 0/6] mm / virtio: Provide support for unused page
 reporting
Message-Id: <20191022160140.a6954868d59f47b36334b504@linux-foundation.org>
In-Reply-To: <20191022221223.17338.5860.stgit@localhost.localdomain>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Oct 2019 15:27:52 -0700 Alexander Duyck <alexander.duyck@gmail.com> wrote:

> Below are the results from various benchmarks. I primarily focused on two
> tests. The first is the will-it-scale/page_fault2 test, and the other is
> a modified version of will-it-scale/page_fault1 that was enabled to use
> THP. I did this as it allows for better visibility into different parts
> of the memory subsystem. The guest is running on one node of a E5-2630 v3
> CPU with 48G of RAM that I split up into two logical nodes in the guest
> in order to test with NUMA as well.
> 
> Test		    page_fault1 (THP)     page_fault2
> Baseline	 1  1256106.33  +/-0.09%   482202.67  +/-0.46%
>                 16  8864441.67  +/-0.09%  3734692.00  +/-1.23%
> 
> Patches applied  1  1257096.00  +/-0.06%   477436.00  +/-0.16%
>                 16  8864677.33  +/-0.06%  3800037.00  +/-0.19%
> 
> Patches enabled	 1  1258420.00  +/-0.04%   480080.00  +/-0.07%
>  MADV disabled  16  8753840.00  +/-1.27%  3782764.00  +/-0.37%
> 
> Patches enabled	 1  1267916.33  +/-0.08%   472075.67  +/-0.39%
>                 16  8287050.33  +/-0.67%  3774500.33  +/-0.11%
> 
> The results above are for a baseline with a linux-next-20191021 kernel,
> that kernel with this patch set applied but page reporting disabled in
> virtio-balloon, patches applied but the madvise disabled by direct
> assigning a device, and the patches applied and page reporting fully
> enabled.  These results include the deviation seen between the average
> value reported here versus the high and/or low value. I observed that
> during the test the memory usage for the first three tests never dropped
> whereas with the patches fully enabled the VM would drop to using only a
> few GB of the host's memory when switching from memhog to page fault tests.
> 
> Most of the overhead seen with this patch set fully enabled is due to the
> fact that accessing the reported pages will cause a page fault and the host
> will have to zero the page before giving it back to the guest. The overall
> guest size is kept fairly small to only a few GB while the test is running.
> This overhead is much more visible when using THP than with standard 4K
> pages. As such for the case where the host memory is not oversubscribed
> this results in a performance regression, however if the host memory were
> oversubscribed this patch set should result in a performance improvement
> as swapping memory from the host can be avoided.

I'm trying to understand "how valuable is this patchset" and the above
resulted in some headscratching.

Overall, how valuable is this patchset?  To real users running real
workloads?

> There is currently an alternative patch set[1] that has been under work
> for some time however the v12 version of that patch set could not be
> tested as it triggered a kernel panic when I attempted to test it. It
> requires multiple modifications to get up and running with performance
> comparable to this patch set. A follow-on set has yet to be posted. As
> such I have not included results from that patch set, and I would
> appreciate it if we could keep this patch set the focus of any discussion
> on this thread.

Actually, the rest of us would be interested in a comparison ;)  


