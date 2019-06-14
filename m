Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A392546449
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 18:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfFNQeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 12:34:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:49731 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNQeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 12:34:17 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 09:34:16 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jun 2019 09:34:16 -0700
Date:   Fri, 14 Jun 2019 09:34:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH 42/43] KVM: VMX: Leave preemption timer running when it's
 disabled
Message-ID: <20190614163416.GH12191@linux.intel.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
 <1560445409-17363-43-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560445409-17363-43-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 07:03:28PM +0200, Paolo Bonzini wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> VMWRITEs to the major VMCS controls, pin controls included, are
> deceptively expensive.  CPUs with VMCS caching (Westmere and later) also
> optimize away consistency checks on VM-Entry, i.e. skip consistency
> checks if the relevant fields have not changed since the last successful
> VM-Entry (of the cached VMCS).  Because uops are a precious commodity,
> uCode's dirty VMCS field tracking isn't as precise as software would
> prefer.  Notably, writing any of the major VMCS fields effectively marks
> the entire VMCS dirty, i.e. causes the next VM-Entry to perform all
> consistency checks, which consumes several hundred cycles.
> 
> As it pertains to KVM, toggling PIN_BASED_VMX_PREEMPTION_TIMER more than
> doubles the latency of the next VM-Entry (and again when/if the flag is
> toggled back).  In a non-nested scenario, running a "standard" guest
> with the preemption timer enabled, toggling the timer flag is uncommon
> but not rare, e.g. roughly 1 in 10 entries.  Disabling the preemption
> timer can change these numbers due to its use for "immediate exits",
> even when explicitly disabled by userspace.
> 
> Nested virtualization in particular is painful, as the timer flag is set
> for the majority of VM-Enters, but prepare_vmcs02() initializes vmcs02's
> pin controls to *clear* the flag since its the timer's final state isn't
> known until vmx_vcpu_run().  I.e. the majority of nested VM-Enters end
> up unnecessarily writing pin controls *twice*.
> 
> Rather than toggle the timer flag in pin controls, set the timer value
> itself to the largest allowed value to put it into a "soft disabled"
> state, and ignore any spurious preemption timer exits.
> 
> Sadly, the timer is a 32-bit value and so theoretically it can fire
> before the head death of the universe, i.e. spurious exits are possible.

s/head/heat

> But because KVM does *not* save the timer value on VM-Exit and because
> the timer runs at a slower rate than the TSC, the maximuma timer value

s/maximuma/maximum

> is still sufficiently large for KVM's purposes.  E.g. on a modern CPU
> with a timer that runs at 1/32 the frequency of a 2.4ghz constant-rate
> TSC, the timer will fire after ~55 seconds of *uninterrupted* guest
> execution.  In other words, spurious VM-Exits are effectively only
> possible if the *host* is tickless on the logical CPU, the guest is
> not using the preemption timer, and the guest is not generating VM-Exits
> for *any* other reason.
> 
> To be safe from bad/weird hardware, disable the preemption timer if its
> maximum delay is less than ten seconds.  Ten seconds is mostly arbitrary
> and was selected in no small part because it's a nice round number.
> For simplicity and paranoia, fall back to __kvm_request_immediate_exit()
> if the preemption timer is disabled by KVM or userspace.  Previously
> KVM continued to use the preemption timer to force immediate exits even
> when the timer was disabled by userspace.  Now that KVM leaves the timer
> running instead of truly disabling it, allow userspace to kill it
> entirely in the unlikely event the timer (or KVM) malfunctions.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
