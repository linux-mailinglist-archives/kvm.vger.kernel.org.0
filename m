Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F2126986A
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgINVz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:55:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:26291 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgINVzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:55:24 -0400
IronPort-SDR: MXvbmpvQpLTABb2QX/iGeOai1nm3yQXqZWw8ZM8g3a/IgWbnbYh5p3XDpP8AArZ/Wiw1bu5T1P
 2RnvvwouEmJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="156598035"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="156598035"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:55:24 -0700
IronPort-SDR: R/iVU5aCQQWyUGqhn9MQzVnzWaGoIJQHmmT3eF3wD8sB6fhDirSQAvY/i3l5NYUicCMBnG7hkd
 lv/djkZiy+BQ==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482509332"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:55:23 -0700
Date:   Mon, 14 Sep 2020 14:55:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
Message-ID: <20200914215522.GG7192@sjchrist-ice>
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
 <20200914195634.12881-2-sean.j.christopherson@intel.com>
 <20200914204024.w3rpjon64d3fesys@treble>
 <20200914210719.GB7084@sjchrist-ice>
 <CAFULd4Z9-Btyqo+i=w5Zyr=vJ46FBXzN7ovWGFxpnLiU2JE6eg@mail.gmail.com>
 <CAFULd4YrhpPp+MvX5jeSfF54eEeQocs_Z5iY_N3rMGXMzx3RjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4YrhpPp+MvX5jeSfF54eEeQocs_Z5iY_N3rMGXMzx3RjQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 11:31:26PM +0200, Uros Bizjak wrote:
> On Mon, Sep 14, 2020 at 11:21 PM Uros Bizjak <ubizjak@gmail.com> wrote:
> >
> > On Mon, Sep 14, 2020 at 11:07 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Mon, Sep 14, 2020 at 03:40:24PM -0500, Josh Poimboeuf wrote:
> > > > On Mon, Sep 14, 2020 at 12:56:33PM -0700, Sean Christopherson wrote:
> > > > > Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
> > > > > into a proper subroutine.  Slightly rework the blob so that it plays
> > > > > nice with objtool without any additional hints (existing hints aren't
> > > > > able to handle returning with a seemingly modified stack size).
> > > > >
> > > > > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > > > Cc: Uros Bizjak <ubizjak@gmail.com>
> > > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > ---
> > > > >  arch/x86/kvm/vmx/vmenter.S | 28 ++++++++++++++++++++++++++++
> > > > >  arch/x86/kvm/vmx/vmx.c     | 33 +++------------------------------
> > > > >  2 files changed, 31 insertions(+), 30 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > > > > index 799db084a336..baec1e0fefc5 100644
> > > > > --- a/arch/x86/kvm/vmx/vmenter.S
> > > > > +++ b/arch/x86/kvm/vmx/vmenter.S
> > > > > @@ -4,6 +4,7 @@
> > > > >  #include <asm/bitsperlong.h>
> > > > >  #include <asm/kvm_vcpu_regs.h>
> > > > >  #include <asm/nospec-branch.h>
> > > > > +#include <asm/segment.h>
> > > > >
> > > > >  #define WORD_SIZE (BITS_PER_LONG / 8)
> > > > >
> > > > > @@ -294,3 +295,30 @@ SYM_FUNC_START(vmread_error_trampoline)
> > > > >
> > > > >     ret
> > > > >  SYM_FUNC_END(vmread_error_trampoline)
> > > > > +
> > > > > +SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
> > > > > +   /*
> > > > > +    * Unconditionally create a stack frame.  RSP needs to be aligned for
> > > > > +    * x86-64, getting the correct RSP on the stack (for x86-64) would take
> > > > > +    * two instructions anyways, and it helps make objtool happy (see below).
> > > > > +    */
> > > > > +   push %_ASM_BP
> > > > > +   mov %rsp, %_ASM_BP
> > > >
> > > > RSP needs to be aligned to what?  How would this align the stack, other
> > > > than by accident?
> > >
> > > Ah, yeah, that's lacking info.
> > >
> > > 16-byte aligned to correctly mimic CPU behavior when vectoring an IRQ/NMI.
> > > When not changing stack, the CPU aligns RSP before pushing the frame.
> > >
> > > The above shenanigans work because the x86-64 ABI also requires RSP to be
> > > 16-byte aligned prior to CALL.  RSP is thus 8-byte aligned due to CALL
> > > pushing the return IP, and so creating the stack frame by pushing RBP makes
> > > it 16-byte aliagned again.
> >
> > IIRC, the kernel violates x86_64 ABI and aligns RSP to 8 bytes prior
> > to CALL. Please note -mpreferred-stack-boundary=3 in the compile
> > flags.
> 
> +       push %_ASM_BP
> +       mov %_ASM_SP, %_ASM_BP
> +
> +#ifdef CONFIG_X86_64
> +       and $-16, %rsp"
> +       push $__KERNEL_DS
> +       push %rbp
> +#endif
> +       pushf
> +       push $__KERNEL_CS
> +       CALL_NOSPEC _ASM_ARG1
> ...
> +       mov %_ASM_BP, %_ASM_SP
> +       pop %_ASM_BP
> +       ret
> 
> should work.

Yar, I thought I was being super clever to avoid the AND :-/
