Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BB5193C7
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 22:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfEIUsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 16:48:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:6534 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfEIUsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 16:48:40 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 May 2019 13:48:39 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 09 May 2019 13:48:39 -0700
Date:   Thu, 9 May 2019 13:48:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: nVMX: Set guest as active after
 NMI/INTR-window tests
Message-ID: <20190509204838.GC12810@linux.intel.com>
References: <20190508102715.685-1-namit@vmware.com>
 <20190508102715.685-3-namit@vmware.com>
 <CALMp9eTE8vsrSC0K7KVArT_KFA_NGBZ5t6eW_Gh8cdJ_88JM+Q@mail.gmail.com>
 <E388EB3A-CB2C-436D-94D2-1157B3328EAD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E388EB3A-CB2C-436D-94D2-1157B3328EAD@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 04:38:10PM -0700, Nadav Amit wrote:
> > On May 8, 2019, at 4:21 PM, Jim Mattson <jmattson@google.com> wrote:
> > 
> > From: Nadav Amit <nadav.amit@gmail.com>
> > Date: Wed, May 8, 2019 at 10:47 AM
> > To: Paolo Bonzini
> > Cc: <kvm@vger.kernel.org>, Nadav Amit, Jim Mattson, Sean Christopherson
> > 
> >> From: Nadav Amit <nadav.amit@gmail.com>
> >> 
> >> Intel SDM 26.6.5 says regarding interrupt-window exiting that: "These
> >> events wake the logical processor if it just entered the HLT state
> >> because of a VM entry." A similar statement is told about NMI-window
> >> exiting.
> >> 
> >> However, running tests which are similar to verify_nmi_window_exit() and
> >> verify_intr_window_exit() on bare-metal suggests that real CPUs do not
> >> wake up. Until someone figures what the correct behavior is, just reset
> >> the activity state to "active" after each test to prevent the whole
> >> test-suite from getting stuck.
> >> 
> >> Cc: Jim Mattson <jmattson@google.com>
> >> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> >> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > 
> > I think I have been assuming that "wake the logical processor" means
> > "causes the logical processor to enter the 'active' activity state."
> > Maybe that's not what "wake" means?
> 
> I really don’t know. Reading the specifications, I thought that the test is
> valid. I don’t manage to read it any differently than you did.

"logic processor" in this context means the physical CPU, it doesn't
imply anything about what gets saved into the VMCS.  I assume the purpose
of that blurb is to make it clear that the guest won't get stuck in HLT
state if there's a virtual interrupt pending.

The relevant SDM section is "Saving Non-Register State":

  The activity-state field is saved with the logical processor's activity
  state before the VM exit[1].  See Section 27.1 for details of how events
  leading to a VM exit may affect the activity state.

The revelant bits of Section 27.1 - "Architectural State Before a VM Exit":

  If the logical processor is in an inactive state and not executing
  instructions, some events may be blocked but other may return the logical
  processor to the active state.  Unblocked events may cause VM exits. If
  an unblocked event causes a VM exit directly, a return to the active state
  occurs only after the VM exit completes.  <more irrevelant words>

In other words, because the CPU was in HLT before VM-Exit, that's what gets
saved into the VMCS.  My guess is that the behavior is defined this way
because technically the vCPU hasn't received a wake event, the VMM has
simply requested a VM Exit.  The wake event (from the vCPU's perspective)
comes when the VMM actually injects an interrupt/NMI.
