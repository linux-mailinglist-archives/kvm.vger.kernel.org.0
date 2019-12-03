Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E9911046E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 19:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfLCSqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 13:46:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:20032 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfLCSqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 13:46:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 10:46:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,274,1571727600"; 
   d="scan'208";a="412293415"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 03 Dec 2019 10:46:00 -0800
Date:   Tue, 3 Dec 2019 10:46:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191203184600.GB19877@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1>
 <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 02:48:10PM +0100, Paolo Bonzini wrote:
> On 02/12/19 22:50, Sean Christopherson wrote:
> >>
> >> I discussed this with Paolo, but I think Paolo preferred the per-vm
> >> ring because there's no good reason to choose vcpu0 as what (1)
> >> suggested.  While if to choose (2) we probably need to lock even for
> >> per-cpu ring, so could be a bit slower.
> > Ya, per-vm is definitely better than dumping on vcpu0.  I'm hoping we can
> > find a third option that provides comparable performance without using any
> > per-vcpu rings.
> > 
> 
> The advantage of per-vCPU rings is that it naturally: 1) parallelizes
> the processing of dirty pages; 2) makes userspace vCPU thread do more
> work on vCPUs that dirty more pages.
> 
> I agree that on the producer side we could reserve multiple entries in
> the case of PML (and without PML only one entry should be added at a
> time).  But I'm afraid that things get ugly when the ring is full,
> because you'd have to wait for all vCPUs to finish publishing the
> entries they have reserved.

Ah, I take it the intended model is that userspace will only start pulling
entries off the ring when KVM explicitly signals that the ring is "full"?

Rather than reserve entries, what if vCPUs reserved an entire ring?  Create
a pool of N=nr_vcpus rings that are shared by all vCPUs.  To mark pages
dirty, a vCPU claims a ring, pushes the pages into the ring, and then
returns the ring to the pool.  If pushing pages hits the soft limit, a
request is made to drain the ring and the ring is not returned to the pool
until it is drained.

Except for acquiring a ring, which likely can be heavily optimized, that'd
allow parallel processing (#1), and would provide a facsimile of #2 as
pushing more pages onto a ring would naturally increase the likelihood of
triggering a drain.  And it might be interesting to see the effect of using
different methods of ring selection, e.g. pure round robin, LRU, last used
on the current vCPU, etc...

> It's ugly that we _also_ need a per-VM ring, but unfortunately some
> operations do not really have a vCPU that they can refer to.
