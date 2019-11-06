Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224D2F0B53
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 01:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbfKFA60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 19:58:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:57238 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbfKFA60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 19:58:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 16:58:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,272,1569308400"; 
   d="scan'208";a="403557226"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 05 Nov 2019 16:58:06 -0800
Date:   Tue, 5 Nov 2019 16:58:06 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 00/14] KVM: x86: Remove emulation_result enums
Message-ID: <20191106005806.GK23297@linux.intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
 <8dec39ac-7d69-b1fd-d07c-cf9d014c4af3@redhat.com>
 <686b499e-7700-228e-3602-8e0979177acb@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <686b499e-7700-228e-3602-8e0979177acb@amazon.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 01:00:03PM +0200, Alexander Graf wrote:
> On 17.09.19 17:14, Paolo Bonzini wrote:
> >On 27/08/19 23:40, Sean Christopherson wrote:
> >>Rework the emulator and its users to handle failure scenarios entirely
> >>within the emulator.
> >>
> >>{x86,kvm}_emulate_instruction() currently returns a tri-state value to
> >>indicate success/continue, userspace exit needed, and failure.  The
> >>intent of returning EMULATE_FAIL is to let the caller handle failure in
> >>a manner that is appropriate for the current context.  In practice,
> >>the emulator has ended up with a mixture of failure handling, i.e.
> >>whether or not the emulator takes action on failure is dependent on the
> >>specific flavor of emulation.
> >>
> >>The mixed handling has proven to be rather fragile, e.g. many flows
> >>incorrectly assume their specific flavor of emulation cannot fail or
> >>that the emulator sets state to report the failure back to userspace.
> >>
> >>Move everything inside the emulator, piece by piece, so that the
> >>emulation routines can return '0' for exit to userspace and '1' for
> >>resume the guest, just like every other VM-Exit handler.
> >>
> >>Patch 13/14 is a tangentially related bug fix that conflicts heavily with
> >>this series, so I tacked it on here.
> >>
> >>Patch 14/14 documents the emulation types.  I added it as a separate
> >>patch at the very end so that the comments could reference the final
> >>state of the code base, e.g. incorporate the rule change for using
> >>EMULTYPE_SKIP that is introduced in patch 13/14.
> >>
> >>v1:
> >>   - https://patchwork.kernel.org/cover/11110331/
> >>
> >>v2:
> >>   - Collect reviews. [Vitaly and Liran]
> >>   - Squash VMware emultype changes into a single patch. [Liran]
> >>   - Add comments in VMX/SVM for VMware #GP handling. [Vitaly]
> >>   - Tack on the EPT misconfig bug fix.
> >>   - Add a patch to comment/document the emultypes. [Liran]
> >>
> >>Sean Christopherson (14):
> >>   KVM: x86: Relocate MMIO exit stats counting
> >>   KVM: x86: Clean up handle_emulation_failure()
> >>   KVM: x86: Refactor kvm_vcpu_do_singlestep() to remove out param
> >>   KVM: x86: Don't attempt VMWare emulation on #GP with non-zero error
> >>     code
> >>   KVM: x86: Move #GP injection for VMware into x86_emulate_instruction()
> >>   KVM: x86: Add explicit flag for forced emulation on #UD
> >>   KVM: x86: Move #UD injection for failed emulation into emulation code
> >>   KVM: x86: Exit to userspace on emulation skip failure
> >>   KVM: x86: Handle emulation failure directly in kvm_task_switch()
> >>   KVM: x86: Move triple fault request into RM int injection
> >>   KVM: VMX: Remove EMULATE_FAIL handling in handle_invalid_guest_state()
> >>   KVM: x86: Remove emulation_result enums, EMULATE_{DONE,FAIL,USER_EXIT}
> >>   KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on EPT misconfig
> >>   KVM: x86: Add comments to document various emulation types
> >>
> >>  arch/x86/include/asm/kvm_host.h |  40 +++++++--
> >>  arch/x86/kvm/mmu.c              |  16 +---
> >>  arch/x86/kvm/svm.c              |  62 ++++++--------
> >>  arch/x86/kvm/vmx/vmx.c          | 147 +++++++++++++-------------------
> >>  arch/x86/kvm/x86.c              | 133 ++++++++++++++++-------------
> >>  arch/x86/kvm/x86.h              |   2 +-
> >>  6 files changed, 195 insertions(+), 205 deletions(-)
> >>
> >
> >Queued, thanks (a couple conflicts had to be sorted out, but nothing
> >requiring a respin).
> 
> Ugh, I just stumbled over this commit. Is this really the right direction to
> move towards?

As you basically surmised below, removing the enum was just a side effect
of cleaning up the emulation error handling, it wasn't really a goal in
and of itself.

> I appreciate the move to reduce the emulator logic from the many-fold enum
> into a simple binary "worked" or "needs a user space exit". But are "0" and
> "1" really the right names for that? I find the readability of the current
> intercept handlers bad enough, trickling that into even more code sounds
> like a situation that will decrease readability even more.
> 
> Why can't we just use names throughout? Something like
> 
> enum kvm_return {
>     KVM_RET_USER_EXIT = 0,
>     KVM_RET_GUEST = 1,
> };
> 
> and then consistently use them as return values? That way anyone who has not
> worked on kvm before can still make sense of the code.

Hmm, I think it'd make more sense to use #define instead of enum to
hopefully make it clear that they aren't the *only* values that can be
returned.  That'd also prevent anyone from changing the return types from
'int' to 'enum kvm_return', which IMO would hurt readability overall.

And maybe KVM_EXIT_TO_USERSPACE and KVM_RETURN_TO_GUEST?
