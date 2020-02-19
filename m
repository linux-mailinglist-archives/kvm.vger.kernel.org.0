Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFDD164795
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 15:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgBSO7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 09:59:14 -0500
Received: from outbound-smtp22.blacknight.com ([81.17.249.190]:54369 "EHLO
        outbound-smtp22.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726569AbgBSO7N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 09:59:13 -0500
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp22.blacknight.com (Postfix) with ESMTPS id 4F262BA9D0
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 14:59:11 +0000 (GMT)
Received: (qmail 18112 invoked from network); 19 Feb 2020 14:59:10 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.57])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 19 Feb 2020 14:59:10 -0000
Date:   Wed, 19 Feb 2020 14:59:08 +0000
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
Subject: Re: [PATCH v17 7/9] mm/page_reporting: Rotate reported pages to the
 tail of the list
Message-ID: <20200219145908.GT3466@techsingularity.net>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
 <20200211224708.29318.16862.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20200211224708.29318.16862.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:47:08PM -0800, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Rather than walking over the same pages again and again to get to the pages
> that have yet to be reported we can save ourselves a significant amount of
> time by simply rotating the list so that when we have a full list of
> reported pages the head of the list is pointing to the next non-reported
> page. Doing this should save us some significant time when processing each
> free list.
> 
> This doesn't gain us much in the standard case as all of the non-reported
> pages should be near the top of the list already. However in the case of
> page shuffling this results in a noticeable improvement. Below are the
> will-it-scale page_fault1 w/ THP numbers for 16 tasks with and without
> this patch.
> 
> Without:
> tasks   processes       processes_idle  threads         threads_idle
> 16      8093776.25      0.17            5393242.00      38.20
> 
> With:
> tasks   processes       processes_idle  threads         threads_idle
> 16      8283274.75      0.17            5594261.00      38.15
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Thanks for pulling this patch out and noting its impact. I think the
rotation is ok and if it turns out I missed something, it'll be
relatively easy to back out just the optimisation and leave the rest of
the feature intact.

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
