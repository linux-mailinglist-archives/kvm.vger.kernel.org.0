Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3D2697A1
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgINVVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgINVV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:21:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786B1C06174A;
        Mon, 14 Sep 2020 14:21:26 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f142so1852184qke.13;
        Mon, 14 Sep 2020 14:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GiOBvH13WvdSWhELrU2Dx+x+3G1sac0Kq9zW3R8hwho=;
        b=HnELad8YKNRNHTJSFzXMAznwqWJeZMiT7DzWwq1p0kCJFncXjUo1TwUrIILdvbe5I8
         1hWX6svpSKqFW1hFn2bfanvvQUqfAyKtSSNJIRlHdG9oEItoeF3gvq1YLmLfJqQMv/nN
         7s8/5xKSnBko5289iuSxIDzKE48l9idRroUc/CWr8mrdJeFNELzq8TZ1psToDKDwOEZW
         EebMPwBlHIaqSI2Po3HpkDU/lGhYdsijkvDxfHMxk8rcph08kf4Ck3hblKVDy+8ivteg
         dJrCh8Lh0DOABiaQqWCMTun71PJLlpJQPQtOSs5FQ3Iqc/KfyGfiBfSMno/Wwo9iIyE/
         iF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GiOBvH13WvdSWhELrU2Dx+x+3G1sac0Kq9zW3R8hwho=;
        b=NcRRhZQTT6BcxESRkHRDa/HUDwXwekbc2aW0ZDcPPRGcodr2b9hCiRpgO+QvVpy0XI
         jhli1K5mID0JahtkHBeqKAaLCMg/cXDE6KXuBjGoG9UDgKe2/vONz/Ut/7mTe8a6k2dW
         vS3dF8E1u602H85Sq9BY2s59gU5TRIdmGOWQb2g9aarPqSZ/h7ErUdXDUfudeSI4q+3r
         6j+MSryYhYuGzDdWCEqe26+xuFfltYukeD76mCimlskU2a5F+pxD0XJQ75GhbAVMQXmH
         ExS1iE+dH/qO5a7bh9BAOOOyoKEMY0g6dhwI3sd/fF/JqnO7AKqfzKhgPfTwuq/UpYXb
         DpYA==
X-Gm-Message-State: AOAM531jfO9ZDXlxiHgZbQ5mWzjlk1+htAdSqZEcv7F7yuy4zptIwdZ7
        wh1sMxFPxWjbIoInvHarDRdIUB08NpnP2U6g4C8=
X-Google-Smtp-Source: ABdhPJypIYZMEGtvZp161L+fs5vHYN/Nvc0OHCXGLfPgXmFxHbFQLkkodTTFk+wzu5ctkXpr0+Peip+zhIZEdDdJG9c=
X-Received: by 2002:a37:9d8:: with SMTP id 207mr14254489qkj.465.1600118485597;
 Mon, 14 Sep 2020 14:21:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
 <20200914195634.12881-2-sean.j.christopherson@intel.com> <20200914204024.w3rpjon64d3fesys@treble>
 <20200914210719.GB7084@sjchrist-ice>
In-Reply-To: <20200914210719.GB7084@sjchrist-ice>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 14 Sep 2020 23:21:14 +0200
Message-ID: <CAFULd4Z9-Btyqo+i=w5Zyr=vJ46FBXzN7ovWGFxpnLiU2JE6eg@mail.gmail.com>
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

On Mon, Sep 14, 2020 at 11:07 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Sep 14, 2020 at 03:40:24PM -0500, Josh Poimboeuf wrote:
> > On Mon, Sep 14, 2020 at 12:56:33PM -0700, Sean Christopherson wrote:
> > > Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
> > > into a proper subroutine.  Slightly rework the blob so that it plays
> > > nice with objtool without any additional hints (existing hints aren't
> > > able to handle returning with a seemingly modified stack size).
> > >
> > > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Cc: Uros Bizjak <ubizjak@gmail.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmenter.S | 28 ++++++++++++++++++++++++++++
> > >  arch/x86/kvm/vmx/vmx.c     | 33 +++------------------------------
> > >  2 files changed, 31 insertions(+), 30 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > > index 799db084a336..baec1e0fefc5 100644
> > > --- a/arch/x86/kvm/vmx/vmenter.S
> > > +++ b/arch/x86/kvm/vmx/vmenter.S
> > > @@ -4,6 +4,7 @@
> > >  #include <asm/bitsperlong.h>
> > >  #include <asm/kvm_vcpu_regs.h>
> > >  #include <asm/nospec-branch.h>
> > > +#include <asm/segment.h>
> > >
> > >  #define WORD_SIZE (BITS_PER_LONG / 8)
> > >
> > > @@ -294,3 +295,30 @@ SYM_FUNC_START(vmread_error_trampoline)
> > >
> > >     ret
> > >  SYM_FUNC_END(vmread_error_trampoline)
> > > +
> > > +SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
> > > +   /*
> > > +    * Unconditionally create a stack frame.  RSP needs to be aligned for
> > > +    * x86-64, getting the correct RSP on the stack (for x86-64) would take
> > > +    * two instructions anyways, and it helps make objtool happy (see below).
> > > +    */
> > > +   push %_ASM_BP
> > > +   mov %rsp, %_ASM_BP
> >
> > RSP needs to be aligned to what?  How would this align the stack, other
> > than by accident?
>
> Ah, yeah, that's lacking info.
>
> 16-byte aligned to correctly mimic CPU behavior when vectoring an IRQ/NMI.
> When not changing stack, the CPU aligns RSP before pushing the frame.
>
> The above shenanigans work because the x86-64 ABI also requires RSP to be
> 16-byte aligned prior to CALL.  RSP is thus 8-byte aligned due to CALL
> pushing the return IP, and so creating the stack frame by pushing RBP makes
> it 16-byte aliagned again.

IIRC, the kernel violates x86_64 ABI and aligns RSP to 8 bytes prior
to CALL. Please note -mpreferred-stack-boundary=3 in the compile
flags.

Uros.
