Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637C1B33DA
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 02:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgDVAQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 20:16:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:1468 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgDVAQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 20:16:07 -0400
IronPort-SDR: fvPwy0/GJtuK6yD02tIDsYdH0FzXcviKcZuIXpvm32vESBivF8tvOfjZXR0oKTXqaO3uUNC+vA
 qLKVprk2S4fQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 17:16:07 -0700
IronPort-SDR: 4Z7xSpRSKXq2YQuB0qLz81M9c80sF1K1MyvId7f9Ik6WN2lJumK419t4i/BK56oKGkTnP4L9qW
 8cDFOqIfJmYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,412,1580803200"; 
   d="scan'208";a="290649427"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2020 17:16:07 -0700
Date:   Tue, 21 Apr 2020 17:16:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
Message-ID: <20200422001607.GA17836@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com>
 <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
 <20200415001212.GA12547@linux.intel.com>
 <CALMp9eS-s5doptTzVkE2o9jDYuGU3T=5azMhm3fCqLJPcABAOg@mail.gmail.com>
 <20200418042108.GF15609@linux.intel.com>
 <CALMp9eQpwnhD7H3a9wC=TnL3=OKmvHAmVFj=r9OBaWiBEGhR4Q@mail.gmail.com>
 <20200421044141.GE11134@linux.intel.com>
 <CALMp9eST-Fpbsg_x5exDxdAC-S+ekk+smyx5e0ymDqHLi-y8xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eST-Fpbsg_x5exDxdAC-S+ekk+smyx5e0ymDqHLi-y8xQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 11:28:23AM -0700, Jim Mattson wrote:
> The more I look at that call to kvm_clear_exception_queue(), the more
> convinced I am that it's wrong. The comment above it says:
> 
> /*
> * Drop what we picked up for L2 via vmx_complete_interrupts. It is
> * preserved above and would only end up incorrectly in L1.
> */
> 
> The first sentence is just wrong. Vmx_complete_interrupts may not be
> where the NMI/exception/interrupt came from. And the second sentence
> is not entirely true. Only *injected* events are "preserved above" (by
> the call to vmcs12_save_pending_event). However,
> kvm_clear_exception_queue zaps both injected events and pending
> events. Moreover, vmcs12_save_pending_event "preserves" the event by
> stashing it in the IDT-vectoring info field of vmcs12, even when the
> current VM-exit (from L2 to L1) did not (and in some cases cannot)
> occur during event delivery (e.g. VMX-preemption timer expired).

The comments are definitely wrong, or perhaps incomplete, but the behavior
isn't "wrong, assuming the rest of the nested event handling is correct
(hint, it's not).  Even with imperfect event handling, clearing
queued/pending exceptions on nested exit isn't terrible behavior as VMX
doesn't have a notion of queued/pending excpetions (ignoring #DBs for now).
If the VM-Exit occured while vectoring an event, that event is captured in
IDT_VECTORING_INFO.  Everything else that might have happened is an
alternate timeline.

The piece that's likely missing is updating GUEST_PENDING_DBG_EXCEPTIONS if
a single-step #DB was pending after emulation.  KVM currently propagates
the field as-is from vmcs02, which would miss any emulated #DB.  But, that
is effectively orthogonal to kvm_clear_exception_queue(), e.g. KVM needs to
"save" the pending #DB like it "saves" an injected event, but clearing the
#DB from the queue is correct.

The main issue I have with the nested event code is that the checks are
effectively grouped by exiting versus non-exiting instead of being grouped
by priority.  That makes it extremely difficult to correctly prioritize
events because each half needs to know the other's behavior, even though
the code is "separated"  E.g. my suggestion to return immediatel if an NMI
is pending and won't VM-Exit is wrong, as the behavior should also be
conditioned on NMIs being unmasked in L2.  Actually implementing that check
is a gigantic mess in the current code base and simply isn't worth the
marginal benefit.

Unwinding the mess, i.e. processing each event class exactly once per run
loop, is extremely difficult because there one-off cases that have been
piled on top, e.g. calling check_nested_events() from kvm_vcpu_running()
and processing INIT and SIPI in kvm_apic_accept_events(), whose full impact
is impossible to ascertain simply by reading the code.  The KVM_REQ_EVENT
optimization also exacerbates the problem, i.e. the event checking really
should be done unconditionally on every loop.
