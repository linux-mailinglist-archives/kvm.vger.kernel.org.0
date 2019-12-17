Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954CD123288
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbfLQQcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:32:01 -0500
Received: from mga06.intel.com ([134.134.136.31]:56872 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbfLQQcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 11:32:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 08:32:00 -0800
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="205526225"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 08:32:00 -0800
Message-ID: <03e1e95c2cc8d6e3206212df48a971e9696d3b20.camel@linux.intel.com>
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
Date:   Tue, 17 Dec 2019 08:31:59 -0800
In-Reply-To: <06ca452e-90b3-c1b5-f2c0-e8da2444bcfe@redhat.com>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <20191205162238.19548.68238.stgit@localhost.localdomain>
         <0bb29ec2-9dcb-653c-dda5-0825aea7d4b0@redhat.com>
         <537e970f062e0c7f89723f63fc1f3ec6e53614a5.camel@linux.intel.com>
         <06ca452e-90b3-c1b5-f2c0-e8da2444bcfe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-12-17 at 03:55 -0500, Nitesh Narayan Lal wrote:
> On 12/16/19 11:28 AM, Alexander Duyck wrote:
> > On Mon, 2019-12-16 at 05:17 -0500, Nitesh Narayan Lal wrote:
> > > On 12/5/19 11:22 AM, Alexander Duyck wrote:
> > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > 
> > > > In order to pave the way for free page reporting in virtualized
> > > > environments we will need a way to get pages out of the free lists and
> > > > identify those pages after they have been returned. To accomplish this,
> > > > this patch adds the concept of a Reported Buddy, which is essentially
> > > > meant to just be the Uptodate flag used in conjunction with the Buddy
> > > > page type.
> > > [...]
> > > 
> > > > +enum {
> > > > +	PAGE_REPORTING_IDLE = 0,
> > > > +	PAGE_REPORTING_REQUESTED,
> > > > +	PAGE_REPORTING_ACTIVE
> > > > +};
> > > > +
> > > > +/* request page reporting */
> > > > +static void
> > > > +__page_reporting_request(struct page_reporting_dev_info *prdev)
> > > > +{
> > > > +	unsigned int state;
> > > > +
> > > > +	/* Check to see if we are in desired state */
> > > > +	state = atomic_read(&prdev->state);
> > > > +	if (state == PAGE_REPORTING_REQUESTED)
> > > > +		return;
> > > > +
> > > > +	/*
> > > > +	 *  If reporting is already active there is nothing we need to do.
> > > > +	 *  Test against 0 as that represents PAGE_REPORTING_IDLE.
> > > > +	 */
> > > > +	state = atomic_xchg(&prdev->state, PAGE_REPORTING_REQUESTED);
> > > > +	if (state != PAGE_REPORTING_IDLE)
> > > > +		return;
> > > > +
> > > > +	/*
> > > > +	 * Delay the start of work to allow a sizable queue to build. For
> > > > +	 * now we are limiting this to running no more than once every
> > > > +	 * couple of seconds.
> > > > +	 */
> > > > +	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> > > > +}
> > > > +
> > > I think you recently switched to using an atomic variable for maintaining page
> > > reporting status as I was doing in v12.
> > > Which is good, as we will not have a disagreement on it now.
> > There is still some differences between our approaches if I am not
> > mistaken. Specifically I have code in place so that any requests to report
> > while we are actively working on reporting will trigger another pass being
> > scheduled after we completed. I still believe you were lacking any logic
> > like that as I recall.
> > 
> 
> Yes, I was specifically referring to the atomic state variable.
> Though I am wondering if having an atomic variable to track page reporting state
> is better than having a page reporting specific unsigned long flag, which we can
> manipulate via __set_bit() and __clear_bit().

So the reason for using an atomic state variable is because I only really
have 3 possible states; idle, active, and requested. It allows for a
pretty simple state machine as any transition from idle indicates that we
need to schedule the worker, transition from requested to active when the
worker starts, and if at the end of a pass if we are still in the active
state it means we can transition back to idle, otherwise we reschedule the
worker.

In order to do the same sort of thing using the bitops would require at
least 2 bits. In addition with the requirement that I cannot use the zone
lock for protection of the state I cannot use the non-atomic versions of
things such as __set_bit and __clear_bit so they would require additional
locking protections.

