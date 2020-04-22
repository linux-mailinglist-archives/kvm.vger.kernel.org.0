Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BFB1B4F63
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 23:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDVV1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 17:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgDVV1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 17:27:45 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D948C03C1A9
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 14:27:45 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id r2so3505300ilo.6
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 14:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xcWDakBTb4wWp+y8qqY98n+VmK8hXyzSR0t8WU80d7U=;
        b=BJ4khznGG1SZIenbv+R6HnaxLxXk1GfF9O/b2+ByBIdrmz1cI+hy0vI2eNnjSMUVhh
         UP0Xd+0e8JxdTZBRDU0FEo+v0B+0ioZRViCxCVctYgv1aHYTPoFrOHKymtsTbpmfTEFn
         tfa1a/wxKpXMRjUvPJtwgmRQv17m063cqNiJOhHgRTT8NT/KUTN5UEgOKXZZ+OCQHtq3
         qfS/sPWIITvoQK8exO7+pZVBXQyO34ufoh/KBtRpDb5bcCCI+SAQ8FWQhKhaYMVeJ833
         dKIHpxGZuCiz1Pa0yLUMeioBBVHvyxEgl9lmKCyzQb/G9a9uL+rq989UUnQKJZVQwE5R
         FFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xcWDakBTb4wWp+y8qqY98n+VmK8hXyzSR0t8WU80d7U=;
        b=CVDecZNDkZGtNmYyc9aJp2LJFUUaQbx3Lwmr4o7GhB0jc9130oEquR2+XVe3/Pzo77
         qQ28EdLiru4qldOI2tdE6YR1hyHACnrugZk4ubyabc0ofIU6ijeq5njYD8QNjJsg+FJ9
         5EyyGtnpPgG6BeaZ8anIorUKahqYUiRV8p+k6JJyQRzuh2iQTV5MWtiOxJum/GdPXLEN
         sOV3W4dSKsEnstwXns4ODA2I84VIOTUOkyNCmQioEKGYrOHYLkWzc7/8gjguJN8NFR8b
         PQyCpAM6sp7Bd2VOT11Jg0x7dmgsVdm7G2WL07ItNKJH/VdpqOC6iE+ZQdHFXty63Uci
         xKNA==
X-Gm-Message-State: AGi0PuYsxuZMLIpTHjbQ2WyZlP3hCycoXQiIumJ+WoCMzge2w088TWRT
        /jEgyU7bvQJLMVLwahUyBGPnVpO/mG4qGRz19V9hEw==
X-Google-Smtp-Source: APiQypIRIvKqd7J8rzmX3Gsct+9GW4a+VFZkk2bru2zaIPAQ/1txgzzwSLGUJSTSeKX3QFoO9VyvU7cBJ5H/aRMAVO8=
X-Received: by 2002:a92:d8ca:: with SMTP id l10mr466482ilo.118.1587590864660;
 Wed, 22 Apr 2020 14:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200414000946.47396-1-jmattson@google.com> <20200422210649.GA5823@linux.intel.com>
In-Reply-To: <20200422210649.GA5823@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 22 Apr 2020 14:27:33 -0700
Message-ID: <CALMp9eSHyYvRfNe+X+Hd4i2c2phssakxr_5zV9tMQjtk1Usm9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: nVMX: Pending debug exceptions trump expired
 VMX-preemption timer
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 2:06 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Apr 13, 2020 at 05:09:45PM -0700, Jim Mattson wrote:
> > Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
>
> ...
>
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 83050977490c..aae01253bfba 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4682,7 +4682,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >                       if (is_icebp(intr_info))
> >                               WARN_ON(!skip_emulated_instruction(vcpu));
> >
> > -                     kvm_queue_exception(vcpu, DB_VECTOR);
> > +                     kvm_requeue_exception(vcpu, DB_VECTOR);
>
> This isn't wrong per se, but it's effectively papering over an underlying
> bug, e.g. the same missed preemption timer bug can manifest if the timer
> expires while in KVM context (because the hr timer is left running) and KVM
> queues an exception for _any_ reason.  Most of the scenarios where L0 will
> queue an exception for L2 are fairly contrived, but they are possible.

I'm now thinking that this is actually wrong, since requeued
exceptions may make their way into the vmcs12 IDT-vectoring info, and
I believe that ultimately the vmcs12 IDT-vectoring info should be
populated only from the vmcs02 IDT-vectoring info (by whatever
circuitous route KVM likes).

> I believe the correct fix is to open a "preemption timer window" like we do
> for pending SMI, NMI and IRQ.  It's effectively the same handling a pending
> SMI on VMX, set req_immediate_exit in the !inject_pending_event() path.

The KVM code that deals with all of these events is really hard to
follow. I wish we could take a step back and just implement Table 6-2
from the SDM volume 3 (augmented with the scattered information about
VMX events and their priorities relative to their nearest neighbors.
Lumping priorities 7 - 10 together (faults that we either intercepted
or synthesized in emulation), I think these are the various things we
need to check, in this order...

0. Is there a fault to be delivered? (In L2, is it intercepted by L1?)
1. Is there a RESET or machine check event?
2. Is there a trap on task switch?
3. Is there an SMI or an INIT?
3.5 In L2, is there an MTF VM-exit?
4. Is there a #DB trap on the previous instruction? (In L2, is it
intercepted by L1?)
4.3 In L2, has the VMX-preemption timer expired?
4.6 In L2, do we need to synthesize an NMI-window VM-exit?
5. Is there an NMI? (In L2, is it intercepted by L1?)
5.3 In L2 do we need to synthesize an interrupt-window VM-exit?
5.6 In L2, do we need to virtualize virtual-interrupt delivery?
6. Is there a maskable interrupt? (In L2, is it intercepted by L1?)
7. Now, we can enter VMX non-root mode.
