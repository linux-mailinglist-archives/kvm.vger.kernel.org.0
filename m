Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3656269767
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgINVIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:08:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:32504 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgINVIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:08:11 -0400
IronPort-SDR: aZwxG13IRNdWtKCjMm97HUq6Tw014BYFyH3uZs9nrCCU1TnNG48CTOmNPQ20K3qzxOPRo38yLI
 jWylPzA2DLKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="243992776"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="243992776"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:08:10 -0700
IronPort-SDR: U9N+DKLdMu+ewb++IVuN349jio0EA0DdYQq4BLqyw4wSagQO+4hwxOqBqHnyxlKQT0UkUrqb6L
 fF1EIgHcCQ5A==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482495517"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:08:09 -0700
Date:   Mon, 14 Sep 2020 14:08:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
Message-ID: <20200914210808.GC7084@sjchrist-ice>
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
 <20200914195634.12881-2-sean.j.christopherson@intel.com>
 <CAFULd4aNVW1Wzs=Y9+-wwFw2FyjHZRKe=SPkJ7uBdGmbN6i47A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4aNVW1Wzs=Y9+-wwFw2FyjHZRKe=SPkJ7uBdGmbN6i47A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 10:37:25PM +0200, Uros Bizjak wrote:
> On Mon, Sep 14, 2020 at 9:56 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
> > into a proper subroutine.  Slightly rework the blob so that it plays
> > nice with objtool without any additional hints (existing hints aren't
> > able to handle returning with a seemingly modified stack size).
> >
> > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Cc: Uros Bizjak <ubizjak@gmail.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmenter.S | 28 ++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.c     | 33 +++------------------------------
> >  2 files changed, 31 insertions(+), 30 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 799db084a336..baec1e0fefc5 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -4,6 +4,7 @@
> >  #include <asm/bitsperlong.h>
> >  #include <asm/kvm_vcpu_regs.h>
> >  #include <asm/nospec-branch.h>
> > +#include <asm/segment.h>
> >
> >  #define WORD_SIZE (BITS_PER_LONG / 8)
> >
> > @@ -294,3 +295,30 @@ SYM_FUNC_START(vmread_error_trampoline)
> >
> >         ret
> >  SYM_FUNC_END(vmread_error_trampoline)
> > +
> > +SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
> > +       /*
> > +        * Unconditionally create a stack frame.  RSP needs to be aligned for
> > +        * x86-64, getting the correct RSP on the stack (for x86-64) would take
> > +        * two instructions anyways, and it helps make objtool happy (see below).
> > +        */
> > +       push %_ASM_BP
> > +       mov %rsp, %_ASM_BP
> 
> _ASM_SP instead of %rsp to avoid assembly failure for 32bit targets.

*sigh*  Thanks!  I'll build i386 this time...
