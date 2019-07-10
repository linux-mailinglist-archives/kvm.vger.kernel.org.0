Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BA164A94
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfGJQPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:15:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:19396 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbfGJQPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:15:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 09:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="156544806"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga007.jf.intel.com with ESMTP; 10 Jul 2019 09:15:19 -0700
Date:   Wed, 10 Jul 2019 09:15:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, jmattson@google.com
Subject: Re: [PATCH 0/5] KVM: nVMX: Skip vmentry checks that are necessary
 only if VMCS12 is dirty
Message-ID: <20190710161519.GC4348@linux.intel.com>
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190708181759.GB20791@linux.intel.com>
 <4a9a76e4-a40c-58a6-4768-1125f6193c81@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a9a76e4-a40c-58a6-4768-1125f6193c81@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 04:35:46PM +0200, Paolo Bonzini wrote:
> On 08/07/19 20:17, Sean Christopherson wrote:
> > On Sun, Jul 07, 2019 at 03:11:42AM -0400, Krish Sadhukhan wrote:
> >> The following functions,
> >>
> >> 	nested_vmx_check_controls
> >> 	nested_vmx_check_host_state
> >> 	nested_vmx_check_guest_state
> >>
> >> do a number of vmentry checks for VMCS12. However, not all of these checks need
> >> to be executed on every vmentry. This patchset makes some of these vmentry
> >> checks optional based on the state of VMCS12 in that if VMCS12 is dirty, only
> >> then the checks will be executed. This will reduce performance impact on
> >> vmentry of nested guests.
> > 
> > All of these patches break vmx_set_nested_state(), which sets dirty_vmcs12
> > only after the aforementioned consistency checks pass.
> > 
> > The new nomenclature for the dirty paths is "rare", not "full".
> > 
> > In general, I dislike directly associating the consistency checks with
> > dirty_vmcs12.
> > 
> >   - It's difficult to assess the correctness of the resulting code, e.g.
> >     changing CPU_BASED_VM_EXEC_CONTROL doesn't set dirty_vmcs12, which
> >     calls into question any and all SECONDARY_VM_EXEC_CONTROL checks since
> >     an L1 could toggle CPU_BASED_ACTIVATE_SECONDARY_CONTROLS.
> 
> Yes, CPU-based controls are tricky and should not be changed.  But I
> don't see a big issue apart from the CPU-based controls, and the other
> checks can also be quite expensive---and the point of dirty_vmcs12 and
> shadow VMCS is that we _can_ exclude them most of the time.

No argument there.  My thought was do something like the following so that
all of the "which checks should we perform" logic is consolidated in a
single location and not spread piecemeal throughout the checks themselves.

static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
{
	unsigned long dirty_checks;

	...

	if (vmx->nested.dirty_vmcs12)
		dirty_checks = ENTRY_CONTROLS | EXIT_CONTROLS | HOST_STATE |
			       GUEST_STATE;
	else
		dirty_checks = 0;
}
