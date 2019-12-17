Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F751234BF
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 19:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfLQSYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 13:24:47 -0500
Received: from mga12.intel.com ([192.55.52.136]:58527 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbfLQSYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 13:24:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 10:24:46 -0800
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="209789792"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 10:24:46 -0800
Message-ID: <1a6e4646f570bf193924e099557841eb6e77a80d.camel@linux.intel.com>
Subject: Re: [PATCH v15 3/7] mm: Add function __putback_isolated_page
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
Date:   Tue, 17 Dec 2019 10:24:46 -0800
In-Reply-To: <1fc997cf-b1f3-3fe6-b699-efb9ef7f17cf@redhat.com>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <20191205162230.19548.70198.stgit@localhost.localdomain>
         <cb49bbc7-b0c0-65cc-1d9d-a3aaef075650@redhat.com>
         <9eb9173278370dd604c4cefd30ed10be36600854.camel@linux.intel.com>
         <8a4b0337-0bad-2978-32e8-6f90c7365f00@redhat.com>
         <753e2991e3e632b9c179c45197bfb05669625e9a.camel@linux.intel.com>
         <1fc997cf-b1f3-3fe6-b699-efb9ef7f17cf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-12-17 at 18:24 +0100, David Hildenbrand wrote:
>  >>> Also there are some scenarios where __page_to_pfn is not that simple a
> > > > call with us having to get the node ID so we can find the pgdat structure
> > > > to perform the calculation. I'm not sure the compiler would be ble to
> > > > figure out that the result is the same for both calls, so it is better to
> > > > make it explicit.
> > > 
> > > Only in case of CONFIG_SPARSEMEM we have to go via the section - but I
> > > doubt this is really worth optimizing here.
> > > 
> > > But yeah, I'm fine with this change, only "IMHO
> > > get_pageblock_migratetype() would be nicer" :)
> > 
> > Aren't most distros running with CONFIG_SPARSEMEM enabled? If that is the
> > case why not optimize for it?
> 
> Because I tend to dislike micro-optimizations without performance
> numbers for code that is not on a hot path. But I mean in this case, as
> you said, you need the pfn either way, so it's completely fine with.
> 
> I do wonder, however, if you should just pass in the migratetype from
> the caller. That would be even faster ;)

The problem is page isolation. We can end up with a page being moved to an
isolate pageblock while we aren't holding the zone lock, and as such we
likely need to test it again anyway. So there isn't value in storing and
reusing the value for cases like page reporting.

In addition, the act of isolating the page can cause the migratetype to
change as __isolate_free_page will attempt to change the migratetype to
movable if it is one of the standard percpu types and we are pulling at
least half a pageblock out. So storing the value before we isolate it
would be problematic as well.

Undoing page isolation is the exception to the issues pointed out above,
but in that case we are overwriting the pageblock migratetype anyway so
the cache lines involved should all be warm from having just set the
value.

