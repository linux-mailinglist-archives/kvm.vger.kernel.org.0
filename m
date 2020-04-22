Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C56D1B4FD8
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 00:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgDVWGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 18:06:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:27263 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVWGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 18:06:37 -0400
IronPort-SDR: ruk9Jd06KF759dBwMw/DuUHLseBFIK7G8QIbtKYCt975xwV67SJA+tmWMhkJroJUVd2RZES8k/
 x4g2JHtMTVCA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 15:06:37 -0700
IronPort-SDR: 1fHNQs6YerVTl9db/RG3UYOLHnAFOQ/q/qgrFrrnlDyvUbe1CzzuXb979XtTJ+r70WbBjnGBUe
 EFXMG2eWcyIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,304,1583222400"; 
   d="scan'208";a="430086473"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 22 Apr 2020 15:06:37 -0700
Date:   Wed, 22 Apr 2020 15:06:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] kvm: nVMX: Pending debug exceptions trump expired
 VMX-preemption timer
Message-ID: <20200422220637.GC5823@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200422210649.GA5823@linux.intel.com>
 <CALMp9eSHyYvRfNe+X+Hd4i2c2phssakxr_5zV9tMQjtk1Usm9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSHyYvRfNe+X+Hd4i2c2phssakxr_5zV9tMQjtk1Usm9A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 02:27:33PM -0700, Jim Mattson wrote:
> On Wed, Apr 22, 2020 at 2:06 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> The KVM code that deals with all of these events is really hard to
> follow. I wish we could take a step back and just implement Table 6-2
> from the SDM volume 3 (augmented with the scattered information about
> VMX events and their priorities relative to their nearest neighbors.
> Lumping priorities 7 - 10 together (faults that we either intercepted
> or synthesized in emulation), I think these are the various things we
> need to check, in this order...
> 
> 0. Is there a fault to be delivered? (In L2, is it intercepted by L1?)
> 1. Is there a RESET or machine check event?
> 2. Is there a trap on task switch?
> 3. Is there an SMI or an INIT?
> 3.5 In L2, is there an MTF VM-exit?
> 4. Is there a #DB trap on the previous instruction? (In L2, is it
> intercepted by L1?)
> 4.3 In L2, has the VMX-preemption timer expired?
> 4.6 In L2, do we need to synthesize an NMI-window VM-exit?
> 5. Is there an NMI? (In L2, is it intercepted by L1?)
> 5.3 In L2 do we need to synthesize an interrupt-window VM-exit?
> 5.6 In L2, do we need to virtualize virtual-interrupt delivery?
> 6. Is there a maskable interrupt? (In L2, is it intercepted by L1?)
> 7. Now, we can enter VMX non-root mode.

100% agreed.  I even tried to go down that path, multiple times, while
sorting this stuff out.  The big problem that isn't easily resolved is
kvm_vcpu_running(), which currently calls .check_nested_events()
even if KVM_REQ_EVENT isn't set.  Its existence makes it annoyingly
difficult to provide a unified single-pass flow for exiting and
non-exiting events, e.g. we'd either have to duplicate a big pile of
logic (eww) or significantly rework the event handling (scary).

Having the INIT and SIPI handling buried in kvm_apic_accept_events() is
also a pain, but that's less scary to change.

In the long term, I absolutely think it'd be worth revamping the event
handling so that it's not scattered all over tarnation, but that's
something that should probably have a full kernel cycle or two of
testing and performance analysis.

If someone does pick up that torch, I think it'd also be worth experimenting
with removing KVM_REQ_EVENT, i.e. processing events on _every_ run.  IMO
that would simplify the code, or at least how one reasons about the code, a
great deal.
