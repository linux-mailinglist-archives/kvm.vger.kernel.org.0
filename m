Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F75181BA
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 23:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfEHVno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 17:43:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:47687 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfEHVno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 17:43:44 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 14:43:43 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 08 May 2019 14:43:43 -0700
Date:   Wed, 8 May 2019 14:43:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v4 0/4] KVM: lapic: Fix a variety of timer adv issues
Message-ID: <20190508214343.GF19656@linux.intel.com>
References: <20190417171534.10385-1-sean.j.christopherson@intel.com>
 <CANRm+CxcmjzV_6q-nf59dZ+4nbifM389kqQy514XFDQSKjxZvg@mail.gmail.com>
 <20190430193102.GA4523@linux.intel.com>
 <CANRm+CyUbJM8syuF1FGhrM4nSQgB_KUYsLNg3nr7RT2vzbuxfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CyUbJM8syuF1FGhrM4nSQgB_KUYsLNg3nr7RT2vzbuxfw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 05, 2019 at 08:43:24AM +0800, Wanpeng Li wrote:
> On Wed, 1 May 2019 at 03:31, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Sun, Apr 28, 2019 at 08:54:30AM +0800, Wanpeng Li wrote:
> > > Hi Sean,
> > > On Thu, 18 Apr 2019 at 01:18, Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > KVM's recently introduced adaptive tuning of lapic_timer_advance_ns has
> > > > several critical flaws:
> > > [.../...]
> > > >
> > > >   - TSC scaling is done on a per-vCPU basis, while the advancement value
> > > >     is global.  This issue is also present without adaptive tuning, but
> > > >     is now more pronounced.
> > >
> > > Did you test this against overcommit scenario? Your per-vCPU variable
> > > can be a large number(yeah, below your 5000ns) when neighbour VMs on
> > > the same host consume cpu heavily, however, kvm will wast a lot of
> > > time to wait when the neighbour VMs are idle. My original patch
> > > evaluate the conservative hypervisor overhead when the first VM is
> > > deployed on the host. It doesn't matter whether or not the VMs on this
> > > host alter their workload behaviors later. Unless you tune the
> > > per-vCPU variable always, however, I think it will introduce more
> > > overhead. So Liran's patch "Consider LAPIC TSC-Deadline Timer expired
> > > if deadline too short" also can't depend on this.
> >
> > I didn't test it in overcommit scenarios.  I wasn't aware of how the
> 
> I think it should be considered.
> 
> > automatic adjustments were being used in real deployments.
> >
> > The best option I can think of is to expose a vCPU's advance time to
> > userspace (not sure what mechanism would be best).  This would allow
> > userspace to run a single vCPU VM with auto-tuning enabled, snapshot
> > the final adjusted advancment, and then update KVM's parameter to set
> > an explicit advancement and effectively disable auto-tuning.
> 
> This step is too complex to deploy in real environment, the same as
> w/o auto-tuning. My auto-tuning patch evaluates the conservative
> hypervisor overhead when the first VM is deployed on the host, and
> auto-tuning it only once for the whole machine.

But even then the advancement could be corrupted or wildly inaccurate
unless that first VM has a single vCPU.

I thought of an idea that will hopefully fix the overcommit scenario and
in general reduce the time spent auto-adjusting.  Patch incoming...
