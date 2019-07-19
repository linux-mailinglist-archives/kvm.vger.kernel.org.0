Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A6E6EAA4
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 20:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbfGSS1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 14:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbfGSS1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 14:27:41 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC97E307D983;
        Fri, 19 Jul 2019 18:27:40 +0000 (UTC)
Received: from treble (ovpn-122-211.rdu2.redhat.com [10.10.122.211])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5480610A6;
        Fri, 19 Jul 2019 18:27:39 +0000 (UTC)
Date:   Fri, 19 Jul 2019 13:27:37 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: VMX: Preemptivly optimize VMX instrs
Message-ID: <20190719182737.3h662ydfvrvjaka7@treble>
References: <20190719172540.7697-1-sean.j.christopherson@intel.com>
 <dc2e7ed5-bc1c-6392-9e12-ff9284e7a9f4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dc2e7ed5-bc1c-6392-9e12-ff9284e7a9f4@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 19 Jul 2019 18:27:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 19, 2019 at 08:01:23PM +0200, Paolo Bonzini wrote:
> On 19/07/19 19:25, Sean Christopherson wrote:
> > An in-flight patch[1] to make __kvm_handle_fault_on_reboot() play nice
> > with objtool will add a JMP after most VMX instructions so that the reboot
> > macro can use an actual CALL to kvm_spurious_fault() instead of a funky
> > PUSH+JMP facsimile.
> > 
> > Rework the low level VMX instruction helpers to handle unexpected faults
> > manually instead of relying on the "fault on reboot" macro.  By using
> > asm-goto, most helpers can branch directly to an in-function call to
> > kvm_spurious_fault(), which can then be optimized by compilers to reside
> > out-of-line at the end of the function instead of inline as done by
> > "fault on reboot".
> > 
> > The net impact relative to the current code base is more or less a nop
> > when building with a compiler that supports __GCC_ASM_FLAG_OUTPUTS__.
> > A bunch of code that was previously in .fixup gets moved into the slow
> > paths of functions, but the fast paths are more basically unchanged.
> > 
> > Without __GCC_ASM_FLAG_OUTPUTS__, manually coding the Jcc is a net
> > positive as CC_SET() without compiler support almost always generates a
> > SETcc+CMP+Jcc sequence, which is now replaced with a single Jcc.
> > 
> > A small bonus is that the Jcc instrs are hinted to predict that the VMX
> > instr will be successful.
> > 
> > [1] https://lkml.kernel.org/r/64a9b64d127e87b6920a97afde8e96ea76f6524e.1563413318.git.jpoimboe@redhat.com
> > 
> > Sean Christopherson (4):
> >   objtool: KVM: x86: Check kvm_rebooting in kvm_spurious_fault()
> >   KVM: VMX: Optimize VMX instruction error and fault handling
> >   KVM: VMX: Add error handling to VMREAD helper
> >   KVM: x86: Drop ____kvm_handle_fault_on_reboot()
> > 
> >  arch/x86/include/asm/kvm_host.h |  6 +--
> >  arch/x86/kvm/vmx/ops.h          | 93 ++++++++++++++++++++-------------
> >  arch/x86/kvm/vmx/vmx.c          | 42 +++++++++++++++
> >  arch/x86/kvm/x86.c              |  3 +-
> >  tools/objtool/check.c           |  1 -
> >  5 files changed, 102 insertions(+), 43 deletions(-)
> > 
> 
> Sean, would you mind basing these on top of Josh's patches, so that
> Peter can add them to his tree?

Sean, FYI, my patches are already in tip/master so these can be based on
that.  I'm guessing the commit IDs are presumably stable, so the commits
can be referenced instead of the lkml link.

-- 
Josh
