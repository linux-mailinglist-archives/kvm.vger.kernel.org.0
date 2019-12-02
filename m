Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C199410F25F
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 22:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfLBVuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 16:50:50 -0500
Received: from mga04.intel.com ([192.55.52.120]:63295 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbfLBVuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 16:50:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 13:50:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="242122776"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 02 Dec 2019 13:50:49 -0800
Date:   Mon, 2 Dec 2019 13:50:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191202215049.GB8120@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202211640.GF31681@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 04:16:40PM -0500, Peter Xu wrote:
> On Mon, Dec 02, 2019 at 12:10:36PM -0800, Sean Christopherson wrote:
> > On Fri, Nov 29, 2019 at 04:34:54PM -0500, Peter Xu wrote:
> > > Currently, we have N+1 rings for each VM of N vcpus:
> > > 
> > >   - for each vcpu, we have 1 per-vcpu dirty ring,
> > >   - for each vm, we have 1 per-vm dirty ring
> > 
> > Why?  I assume the purpose of per-vcpu rings is to avoid contention between
> > threads, but the motiviation needs to be explicitly stated.  And why is a
> > per-vm fallback ring needed?
> 
> Yes, as explained in previous reply, the problem is there could have
> guest memory writes without vcpu contexts.
> 
> > 
> > If my assumption is correct, have other approaches been tried/profiled?
> > E.g. using cmpxchg to reserve N number of entries in a shared ring.
> 
> Not yet, but I'd be fine to try anything if there's better
> alternatives.  Besides, could you help explain why sharing one ring
> and let each vcpu to reserve a region in the ring could be helpful in
> the pov of performance?

The goal would be to avoid taking a lock, or at least to avoid holding a
lock for an extended duration, e.g. some sort of multi-step process where
entries in the ring are first reserved, then filled, and finally marked
valid.  That'd allow the "fill" action to be done in parallel.

In case it isn't clear, I haven't thought through an actual solution :-).

My point is that I think it's worth exploring and profiling other
implementations because the dual per-vm and per-vcpu rings has a few warts
that we'd be stuck with forever.

> > IMO,
> > adding kvm_get_running_vcpu() is a hack that is just asking for future
> > abuse and the vcpu/vm/as_id interactions in mark_page_dirty_in_ring()
> > look extremely fragile.
> 
> I agree.  Another way is to put heavier traffic to the per-vm ring,
> but the downside could be that the per-vm ring could get full easier
> (but I haven't tested).

There's nothing that prevents increasing the size of the common ring each
time a new vCPU is added.  Alternatively, userspace could explicitly
request or hint the desired ring size.

> > I also dislike having two different mechanisms
> > for accessing the ring (lock for per-vm, something else for per-vcpu).
> 
> Actually I proposed to drop the per-vm ring (actually I had a version
> that implemented this.. and I just changed it back to the per-vm ring
> later on, see below) and when there's no vcpu context I thought about:
> 
>   (1) use vcpu0 ring
> 
>   (2) or a better algo to pick up a per-vcpu ring (like, the less full
>       ring, we can do many things here, e.g., we can easily maintain a
>       structure track this so we can get O(1) search, I think)
> 
> I discussed this with Paolo, but I think Paolo preferred the per-vm
> ring because there's no good reason to choose vcpu0 as what (1)
> suggested.  While if to choose (2) we probably need to lock even for
> per-cpu ring, so could be a bit slower.

Ya, per-vm is definitely better than dumping on vcpu0.  I'm hoping we can
find a third option that provides comparable performance without using any
per-vcpu rings.
