Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FC61238DD
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 22:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfLQVuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 16:50:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:63078 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfLQVuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 16:50:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 13:50:16 -0800
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="389970373"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 13:50:16 -0800
Message-ID: <70b3e09ce40ab8bc54a8509e3ea2ec13bfeb3e47.camel@linux.intel.com>
Subject: Re: [PATCH v15 3/7] mm: Add function __putback_isolated_page
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Tue, 17 Dec 2019 13:50:16 -0800
In-Reply-To: <08EFF184-E727-4A79-ABEF-52F2463860C3@redhat.com>
References: <1a6e4646f570bf193924e099557841eb6e77a80d.camel@linux.intel.com>
         <08EFF184-E727-4A79-ABEF-52F2463860C3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-12-17 at 19:46 +0100, David Hildenbrand wrote:
> > Am 17.12.2019 um 19:25 schrieb Alexander Duyck <alexander.h.duyck@linux.intel.com>:
> > 
> > ﻿On Tue, 2019-12-17 at 18:24 +0100, David Hildenbrand wrote:
> > > > > > Also there are some scenarios where __page_to_pfn is not that simple a
> > > > > > call with us having to get the node ID so we can find the pgdat structure
> > > > > > to perform the calculation. I'm not sure the compiler would be ble to
> > > > > > figure out that the result is the same for both calls, so it is better to
> > > > > > make it explicit.
> > > > > 
> > > > > Only in case of CONFIG_SPARSEMEM we have to go via the section - but I
> > > > > doubt this is really worth optimizing here.
> > > > > 
> > > > > But yeah, I'm fine with this change, only "IMHO
> > > > > get_pageblock_migratetype() would be nicer" :)
> > > > 
> > > > Aren't most distros running with CONFIG_SPARSEMEM enabled? If that is the
> > > > case why not optimize for it?
> > > 
> > > Because I tend to dislike micro-optimizations without performance
> > > numbers for code that is not on a hot path. But I mean in this case, as
> > > you said, you need the pfn either way, so it's completely fine with.
> > > 
> > > I do wonder, however, if you should just pass in the migratetype from
> > > the caller. That would be even faster ;)
> > 
> > The problem is page isolation. We can end up with a page being moved to an
> > isolate pageblock while we aren't holding the zone lock, and as such we
> > likely need to test it again anyway. So there isn't value in storing and
> > reusing the value for cases like page reporting.
> > 
> > In addition, the act of isolating the page can cause the migratetype to
> > change as __isolate_free_page will attempt to change the migratetype to
> > movable if it is one of the standard percpu types and we are pulling at
> > least half a pageblock out. So storing the value before we isolate it
> > would be problematic as well.
> > 
> > Undoing page isolation is the exception to the issues pointed out above,
> > but in that case we are overwriting the pageblock migratetype anyway so
> > the cache lines involved should all be warm from having just set the
> > value.
> 
> Nothing would speak against querying the migratetype in the caller and
> passing it on. After all you‘re holding the zone lock, so it can‘t
> change.

That's a fair argument. I will go ahead and make that change since it only
really adds one line to patch 4 and allows us to drop several lines from
patch 3.

