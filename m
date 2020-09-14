Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50AD2697BA
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgINVbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgINVbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:31:39 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F997C06174A;
        Mon, 14 Sep 2020 14:31:38 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id t138so1993003qka.0;
        Mon, 14 Sep 2020 14:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbVYbUwuAgj0gZUzhMIQHhBdT+m+c8C6wWNEnv4NlZs=;
        b=YD9sRm5yT9owz3HKM14xky8JKTJx+V/EU9RqYee67PL2MQzDF+DC0DdZ1pRB9rONt+
         5DH5fiypxF2Ip2K1rW4qRMZkDTJxgw3hN8AoSolqiibS/7bHKjZEEHWftNJHwFHSsIun
         35a0rYoZ1IAxXNmcKzjQA9fLe3D7UGOrwSQnxrAEse4mstg3V1JhBTdzcTl720pPAP/e
         //AbavDIpMzrt7UO+Gx4JGERovmeTGefEBwlw3xbfasfMi+kQuWtxlbk4BaarGbliWNj
         rPCGOswv29fhlulzS2w3o0dgvkr5jSAuxQxpwJXHuLu9J28MLkqlBXuYdkSTMcyRCulj
         VHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbVYbUwuAgj0gZUzhMIQHhBdT+m+c8C6wWNEnv4NlZs=;
        b=B+XSXpQnbFSZSp+tKm++fm+IqHKq8MSGicw0/c5Mbu55IyhcDJk0d3uEB5JTrtjZ29
         +msJL6IHx74AnUi+1U1PE8zJdu84n06mcY01czkqQegXAw1cL4sHPVMO9NjKryW3cC+N
         YAi9PVL+4Cup7RDNMAnV+xFCHU2TTadgh1X/vXr2AYLF+Ni+QGgtt0Fai6rrc73bj2Im
         NoS64D2rcOgy/6BUfvug1P8agPfrGTPZhsf+rJ87u4SpbhBEOwquU1t4KZ3CuTbVZs0k
         XffBNsIlIJMBFPlLYmrpUJ4DymFinU2N0LZg6Rz0/7LFpENHlOzdCnj2hOH82pZySLlu
         fUtQ==
X-Gm-Message-State: AOAM532x6GHEj57bxDTUB2jWuckATo7oqRTHIro67EtX7VaDyoDFPXUP
        4ZX6za7odiAgjmvHG/6oNfukU57w+A+cx+iQskg=
X-Google-Smtp-Source: ABdhPJwRyAgl+QzcCijWEtni3+p0D9s2SnrN8uISflLGy6Y5Dvyux1wcPbi/mnd3XTTAAJikaARQVmqQAfEik4Gz/bU=
X-Received: by 2002:a37:9c8:: with SMTP id 191mr14533038qkj.292.1600119097641;
 Mon, 14 Sep 2020 14:31:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
 <20200914195634.12881-2-sean.j.christopherson@intel.com> <20200914204024.w3rpjon64d3fesys@treble>
 <20200914210719.GB7084@sjchrist-ice> <CAFULd4Z9-Btyqo+i=w5Zyr=vJ46FBXzN7ovWGFxpnLiU2JE6eg@mail.gmail.com>
In-Reply-To: <CAFULd4Z9-Btyqo+i=w5Zyr=vJ46FBXzN7ovWGFxpnLiU2JE6eg@mail.gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 14 Sep 2020 23:31:26 +0200
Message-ID: <CAFULd4YrhpPp+MvX5jeSfF54eEeQocs_Z5iY_N3rMGXMzx3RjQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 11:21 PM Uros Bizjak <ubizjak@gmail.com> wrote:
>
> On Mon, Sep 14, 2020 at 11:07 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, Sep 14, 2020 at 03:40:24PM -0500, Josh Poimboeuf wrote:
> > > On Mon, Sep 14, 2020 at 12:56:33PM -0700, Sean Christopherson wrote:
> > > > Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
> > > > into a proper subroutine.  Slightly rework the blob so that it plays
> > > > nice with objtool without any additional hints (existing hints aren't
> > > > able to handle returning with a seemingly modified stack size).
> > > >
> > > > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > > Cc: Uros Bizjak <ubizjak@gmail.com>
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/vmenter.S | 28 ++++++++++++++++++++++++++++
> > > >  arch/x86/kvm/vmx/vmx.c     | 33 +++------------------------------
> > > >  2 files changed, 31 insertions(+), 30 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > > > index 799db084a336..baec1e0fefc5 100644
> > > > --- a/arch/x86/kvm/vmx/vmenter.S
> > > > +++ b/arch/x86/kvm/vmx/vmenter.S
> > > > @@ -4,6 +4,7 @@
> > > >  #include <asm/bitsperlong.h>
> > > >  #include <asm/kvm_vcpu_regs.h>
> > > >  #include <asm/nospec-branch.h>
> > > > +#include <asm/segment.h>
> > > >
> > > >  #define WORD_SIZE (BITS_PER_LONG / 8)
> > > >
> > > > @@ -294,3 +295,30 @@ SYM_FUNC_START(vmread_error_trampoline)
> > > >
> > > >     ret
> > > >  SYM_FUNC_END(vmread_error_trampoline)
> > > > +
> > > > +SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
> > > > +   /*
> > > > +    * Unconditionally create a stack frame.  RSP needs to be aligned for
> > > > +    * x86-64, getting the correct RSP on the stack (for x86-64) would take
> > > > +    * two instructions anyways, and it helps make objtool happy (see below).
> > > > +    */
> > > > +   push %_ASM_BP
> > > > +   mov %rsp, %_ASM_BP
> > >
> > > RSP needs to be aligned to what?  How would this align the stack, other
> > > than by accident?
> >
> > Ah, yeah, that's lacking info.
> >
> > 16-byte aligned to correctly mimic CPU behavior when vectoring an IRQ/NMI.
> > When not changing stack, the CPU aligns RSP before pushing the frame.
> >
> > The above shenanigans work because the x86-64 ABI also requires RSP to be
> > 16-byte aligned prior to CALL.  RSP is thus 8-byte aligned due to CALL
> > pushing the return IP, and so creating the stack frame by pushing RBP makes
> > it 16-byte aliagned again.
>
> IIRC, the kernel violates x86_64 ABI and aligns RSP to 8 bytes prior
> to CALL. Please note -mpreferred-stack-boundary=3 in the compile
> flags.

+       push %_ASM_BP
+       mov %_ASM_SP, %_ASM_BP
+
+#ifdef CONFIG_X86_64
+       and $-16, %rsp"
+       push $__KERNEL_DS
+       push %rbp
+#endif
+       pushf
+       push $__KERNEL_CS
+       CALL_NOSPEC _ASM_ARG1
...
+       mov %_ASM_BP, %_ASM_SP
+       pop %_ASM_BP
+       ret

should work.

Uros.
