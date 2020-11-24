Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA20C2C19D1
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 01:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgKXALC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 19:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgKXALB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 19:11:01 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858FDC0613CF
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 16:11:01 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y16so20038865ljk.1
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 16:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oDPscW+3Pqb48YFXIQw7JjNfifFgp0K+x7GlPl0xIUg=;
        b=TQhPvCakdJtPIqs5mH+25P364cPp5txchbuvSJj9PsnVmwYy6xD75CN2RbUM8JL5MG
         hK4yDkXgXklWHwnDWEZhd0PW7MfhmPf+sx5C+LasksxIVatn8VAU+QA5thrjbASVgcYs
         eRe3xn2w3vPZhXkOh6wdLXGXpwJnzi8ZOOEj3uUylXplOCyXHGTqV1ohiJt9dOrebCNk
         ACoq1EAuc7wZiKy+H6Xki0P9HmYZDNznqeFsvJFVp6MyG9NcmDlI+jui3eY0V3/0cy4J
         vFEaXUI/aN9ibqSfoh6aXl6XZgyw51j2V2b8OeMrwlcet2J93QrztT6I8H/kTQia0RvV
         CbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDPscW+3Pqb48YFXIQw7JjNfifFgp0K+x7GlPl0xIUg=;
        b=SF2i+QlKsneUr5E7L4Inq5kkhal3ErmEuMqgGNGUwtjdiOuGOp2WSPZSkU6RI09s09
         gOk3FpenRu3XEcBgdP20CeePYUoBEQeMleWR2vvFD0ZZrmbkiwaTdEIGS7y/k+SUzK9Z
         +LwP6A1XZ4FimO87kTRl/jjrhBl5bt4daYUFPVdaMXBvYdXlqqRPwxhxLY8+z0QzhAre
         5hBVZjSwMhfjrr9/qUz4YHbACi9cqyMdnyTky5rRWP+MipZpA3CYjpPmn59Pc2M5/ShR
         +xJKDFZfdWzY9MDiMLJ/Qgzmi4iOZPd9CclUEoNIx7zUQt/iTVCXQWfkmX79rwwfdS77
         3mug==
X-Gm-Message-State: AOAM53379sBSIw/esrChcgNAKEveK3cVU2nXVzCJ41H1fe1bSVQLp+bG
        qb3cXtaKby0sAZu5MAyvreDs4RJjhCxVmJ9jLvNT5MZ3VDD/xk6A
X-Google-Smtp-Source: ABdhPJyZSRGvJLpxUsXKVUttXCUvTYtnlV3g0zsiU592LFZsZTETE4H1Kc+G+Tv0+Kv3u/lEc51rt9YEORWdW9CanbI=
X-Received: by 2002:a2e:9dcd:: with SMTP id x13mr685726ljj.147.1606176659693;
 Mon, 23 Nov 2020 16:10:59 -0800 (PST)
MIME-Version: 1.0
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com> <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
In-Reply-To: <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 23 Nov 2020 16:10:48 -0800
Message-ID: <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     idan.brown@oracle.com, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 23, 2020 at 2:42 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/11/20 20:22, Oliver Upton wrote:
> > The pi_pending bit works rather well as it is only a hint to KVM that it
> > may owe the guest a posted-interrupt completion. However, if we were to
> > set the guest's nested PINV as pending in the L1 IRR it'd be challenging
> > to infer whether or not it should actually be injected in L1 or result
> > in posted-interrupt processing for L2.
>
> Stupid question: why does it matter?  The behavior when the PINV is
> delivered does not depend on the time it enters the IRR, only on the
> time that it enters ISR.  If that happens while the vCPU while in L2, it
> would trigger posted interrupt processing; if PINV moves to ISR while in
> L1, it would be delivered normally as an interrupt.
>
> There are various special cases but they should fall in place.  For
> example, if PINV is delivered during L1 vmentry (with IF=0), it would be
> delivered at the next inject_pending_event when the VMRUN vmexit is
> processed and interrupts are unmasked.
>
> The tricky case is when L0 tries to deliver the PINV to L1 as a posted
> interrupt, i.e. in vmx_deliver_nested_posted_interrupt.  Then the
>
>                  if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
>                          kvm_vcpu_kick(vcpu);
>
> needs a tweak to fall back to setting the PINV in L1's IRR:
>
>                  if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true)) {
>                          /* set PINV in L1's IRR */
>                         kvm_vcpu_kick(vcpu);
>                 }

Yeah, I think that's fair. Regardless, the pi_pending bit should've
only been set if the IPI was actually sent. Though I suppose

> but you also have to do the same *in the PINV handler*
> sysvec_kvm_posted_intr_nested_ipi too, to handle the case where the
> L2->L0 vmexit races against sending the IPI.

Indeed, there is a race but are we assured that the target vCPU thread
is scheduled on the target CPU when that IPI arrives?

I believe there is a 1-to-many relationship here, which is why I said
each CPU would need to maintain a linked list of possible vCPUs to
iterate and find the intended recipient. The process of removing vCPUs
from the list where we caught the IPI in L0 is quite clear, but it
doesn't seem like we could ever know to remove vCPUs from the list
when hardware catches that IPI.

If the ISR thing can be figured out then that'd be great, though it
seems infeasible because we are racing with scheduling on the target.

Could we split the difference and do something like:

        if (kvm_vcpu_trigger_posted_interrupt(vcpu, true)) {
                vmx->nested.pi_pending = true;
        } else {
                /* set PINV in L1's IRR */
                kvm_vcpu_kick(vcpu);
        }

which ensures we only set the hint when KVM might actually have
something to do. Otherwise, it'll deliver to L1 like a normal
interrupt or trigger posted-interrupt processing on nested VM-entry if
IF=0.

> What am I missing?
>
> Paolo
>
