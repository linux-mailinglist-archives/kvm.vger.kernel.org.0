Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA25AB2487
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 19:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbfIMRPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 13:15:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:44803 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730838AbfIMRPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 13:15:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 10:15:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="385483485"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 13 Sep 2019 10:15:22 -0700
Date:   Fri, 13 Sep 2019 10:15:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
Message-ID: <20190913171522.GD31125@linux.intel.com>
References: <20190912180928.123660-1-marcorr@google.com>
 <20190913152442.GC31125@linux.intel.com>
 <CALMp9eQmQ1NKAd8qS9jj5Ff0LWV_UmFLJm4A5knBpzEz=ofirg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQmQ1NKAd8qS9jj5Ff0LWV_UmFLJm4A5knBpzEz=ofirg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 13, 2019 at 09:26:04AM -0700, Jim Mattson wrote:
> On Fri, Sep 13, 2019 at 8:24 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> > This is a misleading name, e.g. it took me quite a while to realize this
> > is testing only the passing scenario.  For me, "limit test" implies that
> > it'd be deliberately exceeding the limit, or at least testing both the
> > passing and failing cases.  I suppose we can't easily test the VMX abort
> > cases, but we can at least test VM_ENTER_LOAD.
> 
> It's hard to test for "undefined behavior may result." :-)

Fortune favors the bold?

> One could check to see if the test is running under KVM, and then
> check for the behavior that Marc's other patch introduces, but even
> that is implementation-dependent.

Hmm, what if kvm-unit-tests accepts both VM-Enter success and fail as
passing conditions?  We can at least verify KVM doesn't explode, and if
VM-Enter fails, that the exit qual is correct.

The SDM state that the max is a recommendation, which leads me to believe
that bare metal will work just fine if the software exceeds the
recommended max by an entry or two, but can run into trouble if the list
is ludicrously big.  There's no way the CPU is tuned so finely that it
works at N but fails at N+1.
