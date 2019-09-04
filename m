Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C85A8D90
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731777AbfIDROY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 13:14:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:32656 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbfIDROX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 13:14:23 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 10:14:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="173647865"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 04 Sep 2019 10:14:23 -0700
Date:   Wed, 4 Sep 2019 10:14:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested
 guests
Message-ID: <20190904171423.GF24079@linux.intel.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com>
 <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com>
 <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
 <CALMp9eRWSvg22JPUKOssOHwOq=uXn6GumXP1-LB2ZiYbd0N6bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRWSvg22JPUKOssOHwOq=uXn6GumXP1-LB2ZiYbd0N6bQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 01, 2019 at 05:33:26PM -0700, Jim Mattson wrote:
> Actually, you're right. There is a problem. With the current
> implementation, there's a priority inversion if the vmcs12 contains
> both illegal guest state for which the checks are deferred to
> hardware, and illegal entries in the VM-entry MSR-load area. In this
> case, we will synthesize a "VM-entry failure due to MSR loading"
> rather than a "VM-entry failure due to invalid guest state."
> 
> There are so many checks on guest state that it's really compelling to
> defer as many as possible to hardware. However, we need to fix the
> aforesaid priority inversion. Instead of returning early from
> nested_vmx_enter_non_root_mode() with EXIT_REASON_MSR_LOAD_FAIL, we
> could induce a "VM-entry failure due to MSR loading" for the next
> VM-entry of vmcs02 and continue with the attempted vmcs02 VM-entry. If
> hardware exits with EXIT_REASON_INVALID_STATE, we reflect that to L1,
> and if hardware exits with EXIT_REASON_INVALID_STATE, we reflect that
> to L1 (along with the appropriate exit qualification).
> 
> The tricky part is in undoing the successful MSR writes if we reflect
> EXIT_REASON_INVALID_STATE to L1. Some MSR writes can't actually be
> undone (e.g. writes to IA32_PRED_CMD), but maybe we can get away with
> those. (Fortunately, it's illegal to put x2APIC MSRs in the VM-entry
> MSR-load area!) Other MSR writes are just a bit tricky to undo (e.g.
> writes to IA32_TIME_STAMP_COUNTER).
> 
> Alternatively, we could perform validity checks on the entire vmcs12
> VM-entry MSR-load area before writing any of the MSRs. This may be
> easier, but it would certainly be slower. We would have to be wary of
> situations where processing an earlier entry affects the validity of a
> later entry. (If we take this route, then we would also have to
> process the valid prefix of the VM-entry MSR-load area when we reflect
> EXIT_REASON_MSR_LOAD_FAIL to L1.)

Maybe a hybrid of the two, e.g. updates that are difficult to unwind
are deferred until all checks pass.  I suspect the set of MSRs that are
difficult to unwind doesn't overlap with the set of MSRs that can affect
the legality of a downstream WRMSR.

> Note that this approach could be extended to permit the deferral of
> some control field checks to hardware as well. As long as the control
> field is copied verbatim from vmcs12 to vmcs02 and the virtual CPU
> enforces the same constraints as the physical CPU, deferral should be
> fine.

I doubt it's worth the effort/complexity to defer control checks to
hardware.  There aren't any control fields that are guaranteed to be
copied verbatim, e.g. we'd need accurate prediction of the final value.
Eliminating the basic vmx_control_verify() doesn't save much as those are
quite speedy, whereas eliminating the individual checks would need to
ensure that *all* fields involved in the check are copied verbatim.

> We just have to make sure that we induce a "VM-entry failure due
> to invalid guest state" for the next VM-entry of vmcs02 if any
> software checks on guest state fail, rather than immediately
> synthesizing an "VM-entry failure due to invalid guest state" during
> the construction of vmcs02.

