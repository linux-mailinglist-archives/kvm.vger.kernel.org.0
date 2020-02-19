Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC961647B0
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 16:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgBSPCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 10:02:21 -0500
Received: from outbound-smtp30.blacknight.com ([81.17.249.61]:37157 "EHLO
        outbound-smtp30.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726528AbgBSPCV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 10:02:21 -0500
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp30.blacknight.com (Postfix) with ESMTPS id CE3F3BA9E0
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 15:02:18 +0000 (GMT)
Received: (qmail 8528 invoked from network); 19 Feb 2020 15:02:18 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.57])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 19 Feb 2020 15:02:18 -0000
Date:   Wed, 19 Feb 2020 15:02:15 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, konrad.wilk@oracle.com, nitesh@redhat.com,
        riel@surriel.com, willy@infradead.org, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, vbabka@suse.cz,
        osalvador@suse.de
Subject: Re: [PATCH v17 8/9] mm/page_reporting: Add budget limit on how many
 pages can be reported per pass
Message-ID: <20200219150215.GU3466@techsingularity.net>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
 <20200211224719.29318.72113.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20200211224719.29318.72113.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:47:19PM -0800, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> In order to keep ourselves from reporting pages that are just going to be
> reused again in the case of heavy churn we can put a limit on how many
> total pages we will process per pass. Doing this will allow the worker
> thread to go into idle much more quickly so that we avoid competing with
> other threads that might be allocating or freeing pages.
> 
> The logic added here will limit the worker thread to no more than one
> sixteenth of the total free pages in a given area per list. Once that limit
> is reached it will update the state so that at the end of the pass we will
> reschedule the worker to try again in 2 seconds when the memory churn has
> hopefully settled down.
> 
> Again this optimization doesn't show much of a benefit in the standard case
> as the memory churn is minmal. However with page allocator shuffling
> enabled the gain is quite noticeable. Below are the results with a THP
> enabled version of the will-it-scale page_fault1 test showing the
> improvement in iterations for 16 processes or threads.
> 
> Without:
> tasks   processes       processes_idle  threads         threads_idle
> 16      8283274.75      0.17            5594261.00      38.15
> 
> With:
> tasks   processes       processes_idle  threads         threads_idle
> 16      8767010.50      0.21            5791312.75      36.98
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Seems fair. The test case you used would have been pounding on the zone
lock at fairly high frequency so it represents a worst-case scenario but
not necessarily an unrealistic one

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
