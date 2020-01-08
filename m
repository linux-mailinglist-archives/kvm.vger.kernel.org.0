Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6CA134735
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 17:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgAHQH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 11:07:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:65235 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbgAHQH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 11:07:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 08:07:55 -0800
X-IronPort-AV: E=Sophos;i="5.69,410,1571727600"; 
   d="scan'208";a="211581775"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 08:07:52 -0800
Message-ID: <783a534b37500c36a0255b5a7615b667a89b5b76.camel@linux.intel.com>
Subject: Re: [PATCH v16 7/9] mm: Rotate free list so reported pages are
 moved to the tail of the list
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Wed, 08 Jan 2020 08:07:52 -0800
In-Reply-To: <1ee73115-b5b7-9de8-08b0-528035111ea8@redhat.com>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
         <20200103211657.29237.50194.stgit@localhost.localdomain>
         <1ee73115-b5b7-9de8-08b0-528035111ea8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-01-08 at 14:38 +0100, David Hildenbrand wrote:
> On 03.01.20 22:16, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Rather than walking over the same pages again and again to get to the pages
> > that have yet to be reported we can save ourselves a significant amount of
> > time by simply rotating the list so that when we have a full list of
> > reported pages the head of the list is pointing to the next non-reported
> > page. Doing this should save us some significant time when processing each
> > free list.
> > 
> > This doesn't gain us much in the standard case as all of the non-reported
> > pages should be near the top of the list already. However in the case of
> > page shuffling this results in a noticeable improvement. Below are the
> > will-it-scale page_fault1 w/ THP numbers for 16 tasks with and without
> > this patch.
> > 
> > Without:
> > tasks   processes       processes_idle  threads         threads_idle
> > 16      8093776.25      0.17            5393242.00      38.20
> > 
> > With:
> > tasks   processes       processes_idle  threads         threads_idle
> > 16      8283274.75      0.17            5594261.00      38.15
> > 
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  mm/page_reporting.c |   30 ++++++++++++++++++++++--------
> >  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> Just a minor comment while scanning over the patches (will do more
> review soon), you might want to switch to "mm/page_reporting: " styled
> subjects for these optimizations.
> 

Okay, I will update if needed for the next version.

