Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB3D10F2C4
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 23:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLBWTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 17:19:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:9938 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBWTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 17:19:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 14:19:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="242131555"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 02 Dec 2019 14:19:49 -0800
Date:   Mon, 2 Dec 2019 14:19:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 03/15] KVM: Add build-time error check on kvm_run size
Message-ID: <20191202221949.GD8120@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-4-peterx@redhat.com>
 <20191202193027.GH4063@linux.intel.com>
 <20191202205315.GD31681@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202205315.GD31681@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 03:53:15PM -0500, Peter Xu wrote:
> On Mon, Dec 02, 2019 at 11:30:27AM -0800, Sean Christopherson wrote:
> > On Fri, Nov 29, 2019 at 04:34:53PM -0500, Peter Xu wrote:
> > > It's already going to reach 2400 Bytes (which is over half of page
> > > size on 4K page archs), so maybe it's good to have this build-time
> > > check in case it overflows when adding new fields.
> > 
> > Please explain why exceeding PAGE_SIZE is a bad thing.  I realize it's
> > almost absurdly obvious when looking at the code, but a) the patch itself
> > does not provide that context and b) the changelog should hold up on its
> > own,
> 
> Right, I'll enhance the commit message.
> 
> > e.g. in a mostly hypothetical case where the allocation of vcpu->run
> > were changed to something else.
> 
> And that's why I added BUILD_BUG_ON right beneath that allocation. :)

My point is that if the allocation were changed to no longer be a
straightforward alloc_page() then someone reading the combined code would
have no idea why the BUILD_BUG_ON() exists.  It's a bit ridiculous for
this case because the specific constraints of vcpu->run make it highly
unlikely to use anything else, but that's beside the point.

> It's just a helper for developers when adding new kvm_run fields, not
> a risk for anyone who wants to start allocating more pages for it.

But by adding a BUILD_BUG_ON without explaining *why*, you're placing an
extra burden on someone that wants to increase the size of kvm->run, e.g.
it's not at all obvious from the changelog whether this patch is adding
the BUILD_BUG_ON purely because the code allocates memory for vcpu->run
via alloc_page(), or if there is some fundamental aspect of vcpu->run that
requires it to never span multiple pages.
