Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF0610050
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 21:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfD3TbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 15:31:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:51210 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfD3TbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 15:31:02 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 12:31:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="140188377"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga006.jf.intel.com with ESMTP; 30 Apr 2019 12:31:02 -0700
Date:   Tue, 30 Apr 2019 12:31:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v4 0/4] KVM: lapic: Fix a variety of timer adv issues
Message-ID: <20190430193102.GA4523@linux.intel.com>
References: <20190417171534.10385-1-sean.j.christopherson@intel.com>
 <CANRm+CxcmjzV_6q-nf59dZ+4nbifM389kqQy514XFDQSKjxZvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CxcmjzV_6q-nf59dZ+4nbifM389kqQy514XFDQSKjxZvg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 28, 2019 at 08:54:30AM +0800, Wanpeng Li wrote:
> Hi Sean,
> On Thu, 18 Apr 2019 at 01:18, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > KVM's recently introduced adaptive tuning of lapic_timer_advance_ns has
> > several critical flaws:
> [.../...]
> >
> >   - TSC scaling is done on a per-vCPU basis, while the advancement value
> >     is global.  This issue is also present without adaptive tuning, but
> >     is now more pronounced.
> 
> Did you test this against overcommit scenario? Your per-vCPU variable
> can be a large number(yeah, below your 5000ns) when neighbour VMs on
> the same host consume cpu heavily, however, kvm will wast a lot of
> time to wait when the neighbour VMs are idle. My original patch
> evaluate the conservative hypervisor overhead when the first VM is
> deployed on the host. It doesn't matter whether or not the VMs on this
> host alter their workload behaviors later. Unless you tune the
> per-vCPU variable always, however, I think it will introduce more
> overhead. So Liran's patch "Consider LAPIC TSC-Deadline Timer expired
> if deadline too short" also can't depend on this.

I didn't test it in overcommit scenarios.  I wasn't aware of how the
automatic adjustments were being used in real deployments.

The best option I can think of is to expose a vCPU's advance time to
userspace (not sure what mechanism would be best).  This would allow
userspace to run a single vCPU VM with auto-tuning enabled, snapshot
the final adjusted advancment, and then update KVM's parameter to set
an explicit advancement and effectively disable auto-tuning.
