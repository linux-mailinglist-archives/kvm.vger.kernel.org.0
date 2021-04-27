Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1E036BCC4
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 02:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhD0Aze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 20:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhD0Azd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 20:55:33 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493FAC061574;
        Mon, 26 Apr 2021 17:54:50 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id c18so48123007iln.7;
        Mon, 26 Apr 2021 17:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=trCHKRAUhqv/tT13nVtrEaW/g2fhlUeF1nzQbKflykE=;
        b=ZgSZ7sZW0fNf5v8T2unI68qMiSfWfqTR0Yz05VQyZg1f5TUJ1SnxYzhKm5kN9RlEXP
         lqgc+UGS3Tu3VwnC04iNroK68irL+6S/v5EXaQUVLWTQIn8jBB3JLhjzhVl2Kl8IoD1j
         KAIkQlGqDwKNPN88ZI0+M3GLD7nLoB93Oy8lAW5UtqYXqim4OjbsJSfb35rJPEussAxK
         xjUTDWYl2+tT1VfZo06qDM/e5/dz2/zks+DqxfGNxBxvUxd4H7Q0Ge9SXjLze67uk7FH
         8rUZz+f4cVQ/4932qAdZGn+hDkhgoCF6BUTsbPD6CC+ho8ezdMren+3+x1BycosAD1d9
         LaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trCHKRAUhqv/tT13nVtrEaW/g2fhlUeF1nzQbKflykE=;
        b=bOEK1fjcoeYD6n8LCuulHj1ma2r19f7CAcsciMs2u0h9fGqAEdHB5lCMgPFmwtw+UF
         uFc4sxXJ4L2NrfAkZu6mQpCw7aiwgQFUTGu9estoSytp0obweb/+IrgnGIdrlQl3jQeq
         Mrlp1CETxtLYKKk54UvOsc6W4CaSglpWT1NWHoH7spZ43aYLCWCFCXLSouWXxYLszq/j
         JeeQakL6F7tQDxB5sMJiezKmnzPv0bRHVggSeotETrQxtEM8viCmrTHFVtY6coxUVFbQ
         EokjT7XDE8kt6dAoSgF3O0fDs9eN8yPAo6ysKb4jhQLyF+l4pOZLSlMKI9MLd6z7SzW2
         Ek3A==
X-Gm-Message-State: AOAM530ZrcSGzZVGBHJXNFbo6Lhelr7D727pJQ5mOvVR5KZDCWQdTy99
        MQ0PK+w6jvFTKW2vKGUirI+yQZdpduMa82mlHDA=
X-Google-Smtp-Source: ABdhPJznUSoEihlkahDKB+0FBzVgGzCxwZqJbxWS1h7N8DmVb9WAxv6aVAyXpTeCxFyMb31L9YLbPsxG9qu6lPcdPjM=
X-Received: by 2002:a05:6e02:1282:: with SMTP id y2mr16492014ilq.308.1619484888671;
 Mon, 26 Apr 2021 17:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
 <20200915191505.10355-3-sean.j.christopherson@intel.com> <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
 <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com>
In-Reply-To: <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Tue, 27 Apr 2021 08:54:37 +0800
Message-ID: <CAJhGHyDrAwKO1iht=d0j+OKD1U7e1fzLminudxo2sPHbF53TKQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call
 instead of INTn
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(Correct Sean Christopherson's email address)

On Mon, Apr 26, 2021 at 6:40 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 26/04/21 11:33, Lai Jiangshan wrote:
> > When handle_interrupt_nmi_irqoff() is called, we may lose the
> > CPU-hidden-NMI-masked state due to IRET of #DB, #BP or other traps
> > between VMEXIT and handle_interrupt_nmi_irqoff().
> >
> > But the NMI handler in the Linux kernel*expects*  the CPU-hidden-NMI-masked
> > state is still set in the CPU for no nested NMI intruding into the beginning
> > of the handler.
> >
> > The original code "int $2" can provide the needed CPU-hidden-NMI-masked
> > when entering #NMI, but I doubt it about this change.
>
> How would "int $2" block NMIs?

Sorry, I haven't checked it.

> The hidden effect of this change (and I
> should have reviewed better the effect on the NMI entry code) is that
> the call will not use the IST anymore.
>
> However, I'm not sure which of the two situations is better: entering
> the NMI handler on the IST without setting the hidden NMI-blocked flag
> could be a recipe for bad things as well.

The change makes the ASM NMI entry called on the kernel stack.  But the
ASM NMI entry expects it on the IST stack and it plays with "NMI executing"
variable on the IST stack.  In this change, the stranded ASM NMI entry
will use the wrong/garbage "NMI executing" variable on the kernel stack
and may do some very wrong thing.

On Mon, Apr 26, 2021 at 9:59 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > But the NMI handler in the Linux kernel*expects*  the CPU-hidden-NMI-masked
> > > > state is still set in the CPU for no nested NMI intruding into the beginning
> > > > of the handler.
>
>
> This is incorrect. The Linux kernel has for some time handled the case of
> nested NMIs. It had to, to implement the ftrace break point updates, as it
> would trigger an int3 in an NMI which would "unmask" the NMIs. It has also
> been a long time bug where a page fault could do the same (the reason you
> could never do a dump all tasks from NMI without triple faulting!).
>
> But that's been fixed a long time ago, and I even wrote an LWN article
> about it ;-)
>
>  https://lwn.net/Articles/484932/
>
> The NMI handler can handle the case of nested NMIs, and implements a
> software "latch" to remember that another NMI is to be executed, if there
> is a nested one. And it does so after the first one has finished.

Sorry, in my reply, "the NMI handler" meant to be the ASM entry installed
on the IDT table which really expects to be NMI-masked at the beginning.

The C NMI handler can handle the case of nested NMIs, which is useful
here.  I think we should change it to call the C NMI handler directly
here as Andy Lutomirski suggested:

On Mon, Apr 26, 2021 at 11:09 PM Andy Lutomirski <luto@amacapital.net> wrote:
> The C NMI code has its own reentrancy protection and has for years.
> It should work fine for this use case.

I think this is the right way.
