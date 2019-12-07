Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C752A115A22
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 01:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfLGA3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 19:29:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:11091 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbfLGA3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 19:29:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 16:29:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="214583796"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 06 Dec 2019 16:29:04 -0800
Date:   Fri, 6 Dec 2019 16:29:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191207002904.GA29396@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1>
 <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 04, 2019 at 11:05:47AM +0100, Paolo Bonzini wrote:
> On 03/12/19 19:46, Sean Christopherson wrote:
> > Rather than reserve entries, what if vCPUs reserved an entire ring?  Create
> > a pool of N=nr_vcpus rings that are shared by all vCPUs.  To mark pages
> > dirty, a vCPU claims a ring, pushes the pages into the ring, and then
> > returns the ring to the pool.  If pushing pages hits the soft limit, a
> > request is made to drain the ring and the ring is not returned to the pool
> > until it is drained.
> > 
> > Except for acquiring a ring, which likely can be heavily optimized, that'd
> > allow parallel processing (#1), and would provide a facsimile of #2 as
> > pushing more pages onto a ring would naturally increase the likelihood of
> > triggering a drain.  And it might be interesting to see the effect of using
> > different methods of ring selection, e.g. pure round robin, LRU, last used
> > on the current vCPU, etc...
> 
> If you are creating nr_vcpus rings, and draining is done on the vCPU
> thread that has filled the ring, why not create nr_vcpus+1?  The current
> code then is exactly the same as pre-claiming a ring per vCPU and never
> releasing it, and using a spinlock to claim the per-VM ring.

Because I really don't like kvm_get_running_vcpu() :-)

Binding the rings to vCPUs also makes for an inflexible API, e.g. the
amount of memory required for the rings scales linearly with the number of
vCPUs, or maybe there's a use case for having M:N vCPUs:rings.

That being said, I'm pretty clueless when it comes to implementing and
tuning the userspace side of this type of stuff, so feel free to ignore my
thoughts on the API.
