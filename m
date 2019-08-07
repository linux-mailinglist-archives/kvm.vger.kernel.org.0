Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C48A856AA
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 01:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbfHGXyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 19:54:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:34651 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387536AbfHGXyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 19:54:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 16:54:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="182430251"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Aug 2019 16:54:23 -0700
Date:   Wed, 7 Aug 2019 16:54:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jintack Lim <incredible.tack@gmail.com>
Cc:     KVM General <kvm@vger.kernel.org>,
        Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: Why are we using preemption timer on x86?
Message-ID: <20190807235423.GD16491@linux.intel.com>
References: <CAHyh4xhDZdr0gOJCrSBB5rXYXw7Kpxsw_Oe=tSHMCgi_2G3ouQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHyh4xhDZdr0gOJCrSBB5rXYXw7Kpxsw_Oe=tSHMCgi_2G3ouQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 07, 2019 at 02:52:19PM -0700, Jintack Lim wrote:
> Hi,
> 
> I'm just wondering what's the reason why we use the preemption timer
> instead of emulating VM's timer using hrtimer in software? Is there
> anything the the preemption timer can do that can't be done with
> hrtimer?
> 
> I guess the x86 architecture provides the preemption timer for *some*
> reason, but I'm not sure what they are.

Assuming you're referring to Intel/VMX's preemption timer, programming
the preemption timer and servicing its VM-Exits both have lower overhead
than going through hrtimer.

commit ce7a058a2117f0bca2f42f2870a97bfa9aa8e099
Author: Yunhong Jiang <yunhong.jiang@gmail.com>
Date:   Mon Jun 13 14:20:01 2016 -0700

    KVM: x86: support using the vmx preemption timer for tsc deadline timer

    The VMX preemption timer can be used to virtualize the TSC deadline timer.
    The VMX preemption timer is armed when the vCPU is running, and a VMExit
    will happen if the virtual TSC deadline timer expires.

    When the vCPU thread is blocked because of HLT, KVM will switch to use
    an hrtimer, and then go back to the VMX preemption timer when the vCPU
    thread is unblocked.

    This solution avoids the complex OS's hrtimer system, and the host
    timer interrupt handling cost, replacing them with a little math
    (for guest->host TSC and host TSC->preemption timer conversion)
    and a cheaper VMexit.  This benefits latency for isolated pCPUs.

    [A word about performance... Yunhong reported a 30% reduction in average
     latency from cyclictest.  I made a similar test with tscdeadline_latency
     from kvm-unit-tests, and measured

     - ~20 clock cycles loss (out of ~3200, so less than 1% but still
       statistically significant) in the worst case where the test halts
       just after programming the TSC deadline timer

     - ~800 clock cycles gain (25% reduction in latency) in the best case
       where the test busy waits.

     I removed the VMX bits from Yunhong's patch, to concentrate them in the
     next patch - Paolo]

    Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
