Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85157120F6E
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 17:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfLPQ2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 11:28:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:7994 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfLPQ2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 11:28:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 08:28:09 -0800
X-IronPort-AV: E=Sophos;i="5.69,322,1571727600"; 
   d="scan'208";a="297748698"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 08:28:09 -0800
Message-ID: <537e970f062e0c7f89723f63fc1f3ec6e53614a5.camel@linux.intel.com>
Subject: Re: [PATCH v15 4/7] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Mon, 16 Dec 2019 08:28:09 -0800
In-Reply-To: <0bb29ec2-9dcb-653c-dda5-0825aea7d4b0@redhat.com>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <20191205162238.19548.68238.stgit@localhost.localdomain>
         <0bb29ec2-9dcb-653c-dda5-0825aea7d4b0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-12-16 at 05:17 -0500, Nitesh Narayan Lal wrote:
> On 12/5/19 11:22 AM, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > In order to pave the way for free page reporting in virtualized
> > environments we will need a way to get pages out of the free lists and
> > identify those pages after they have been returned. To accomplish this,
> > this patch adds the concept of a Reported Buddy, which is essentially
> > meant to just be the Uptodate flag used in conjunction with the Buddy
> > page type.
> 
> [...]
> 
> > +enum {
> > +	PAGE_REPORTING_IDLE = 0,
> > +	PAGE_REPORTING_REQUESTED,
> > +	PAGE_REPORTING_ACTIVE
> > +};
> > +
> > +/* request page reporting */
> > +static void
> > +__page_reporting_request(struct page_reporting_dev_info *prdev)
> > +{
> > +	unsigned int state;
> > +
> > +	/* Check to see if we are in desired state */
> > +	state = atomic_read(&prdev->state);
> > +	if (state == PAGE_REPORTING_REQUESTED)
> > +		return;
> > +
> > +	/*
> > +	 *  If reporting is already active there is nothing we need to do.
> > +	 *  Test against 0 as that represents PAGE_REPORTING_IDLE.
> > +	 */
> > +	state = atomic_xchg(&prdev->state, PAGE_REPORTING_REQUESTED);
> > +	if (state != PAGE_REPORTING_IDLE)
> > +		return;
> > +
> > +	/*
> > +	 * Delay the start of work to allow a sizable queue to build. For
> > +	 * now we are limiting this to running no more than once every
> > +	 * couple of seconds.
> > +	 */
> > +	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> > +}
> > +
> 
> I think you recently switched to using an atomic variable for maintaining page
> reporting status as I was doing in v12.
> Which is good, as we will not have a disagreement on it now.

There is still some differences between our approaches if I am not
mistaken. Specifically I have code in place so that any requests to report
while we are actively working on reporting will trigger another pass being
scheduled after we completed. I still believe you were lacking any logic
like that as I recall.

> On a side note, apologies for not getting involved actively in the
> discussions/reviews as I am on PTO.

No problem. I've been mostly looking for input from the core MM
maintainers anyway as we sorted most of the virtualization pieces some
time ago.

