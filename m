Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC4B124061
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 08:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLRHbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 02:31:44 -0500
Received: from outbound-smtp37.blacknight.com ([46.22.139.220]:54094 "EHLO
        outbound-smtp37.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726633AbfLRHbn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 02:31:43 -0500
Received: from mail.blacknight.com (unknown [81.17.255.152])
        by outbound-smtp37.blacknight.com (Postfix) with ESMTPS id 6EDEADB3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 07:31:42 +0000 (GMT)
Received: (qmail 21674 invoked from network); 18 Dec 2019 07:31:42 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.57])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 18 Dec 2019 07:31:42 -0000
Date:   Wed, 18 Dec 2019 07:31:39 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, vbabka@suse.cz, yang.zhang.wz@gmail.com,
        konrad.wilk@oracle.com, david@redhat.com, pagupta@redhat.com,
        riel@surriel.com, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de
Subject: Re: [PATCH v15 4/7] mm: Introduce Reported pages
Message-ID: <20191218073139.GE3178@techsingularity.net>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
 <20191205162238.19548.68238.stgit@localhost.localdomain>
 <0bb29ec2-9dcb-653c-dda5-0825aea7d4b0@redhat.com>
 <537e970f062e0c7f89723f63fc1f3ec6e53614a5.camel@linux.intel.com>
 <06ca452e-90b3-c1b5-f2c0-e8da2444bcfe@redhat.com>
 <03e1e95c2cc8d6e3206212df48a971e9696d3b20.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <03e1e95c2cc8d6e3206212df48a971e9696d3b20.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 08:31:59AM -0800, Alexander Duyck wrote:
> > > > I think you recently switched to using an atomic variable for maintaining page
> > > > reporting status as I was doing in v12.
> > > > Which is good, as we will not have a disagreement on it now.
> > >
> > > There is still some differences between our approaches if I am not
> > > mistaken. Specifically I have code in place so that any requests to report
> > > while we are actively working on reporting will trigger another pass being
> > > scheduled after we completed. I still believe you were lacking any logic
> > > like that as I recall.
> > > 
> > 
> > Yes, I was specifically referring to the atomic state variable.
> > Though I am wondering if having an atomic variable to track page reporting state
> > is better than having a page reporting specific unsigned long flag, which we can
> > manipulate via __set_bit() and __clear_bit().
> 
> So the reason for using an atomic state variable is because I only really
> have 3 possible states; idle, active, and requested. It allows for a
> pretty simple state machine as any transition from idle indicates that we
> need to schedule the worker, transition from requested to active when the
> worker starts, and if at the end of a pass if we are still in the active
> state it means we can transition back to idle, otherwise we reschedule the
> worker.
> 
> In order to do the same sort of thing using the bitops would require at
> least 2 bits. In addition with the requirement that I cannot use the zone
> lock for protection of the state I cannot use the non-atomic versions of
> things such as __set_bit and __clear_bit so they would require additional
> locking protections.
> 

I completely agree with this. I had pointed out in an earlier review
that expanding the scope of the zone lock was inappropriate, the
non-atomic operations on separate flags potentially misses updates and
in general, I prefer the atomic variable approach a lot more than the
previous zone->flag based approach.

-- 
Mel Gorman
SUSE Labs
