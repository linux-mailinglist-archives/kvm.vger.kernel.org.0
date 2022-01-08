Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04194880D3
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 03:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiAHCJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 21:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiAHCJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 21:09:10 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6680BC061574;
        Fri,  7 Jan 2022 18:09:10 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id j83so21831364ybg.2;
        Fri, 07 Jan 2022 18:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7h91m8QgRh+qiSrsUgRoesNuNjxf0DUMijvzYemGZOw=;
        b=mN82rEM2nXPEcJn05mmRCgetWyZvLxhs7lRPRbN6vihJtz21ZbB0cJ49cvAVu9i9r2
         lViB28+iSjOME/OrGno/dO3jsIm7e79roVg5jbFkHodiEXxmU4zGoQmutCklHXTpBs4L
         aDLmOyYzlOJGTkqQ5VloAKE4cHSY+9K4D7t5V6SGac74R6eUsJna+OSQkL4wQJ7Yfxnc
         CQb0YJ+r2xRXuF4egCnYqf+O+ipHNlAvOT9MS72J0v1QYRBGpzL4TCfWiefO8MMRamBM
         odtaBpiOd0+JqEhNst9NCBn3STqTU9gOYsEy54zXmhkudcSkZw3xgwXEfDIMh3TQ+h/R
         XoqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7h91m8QgRh+qiSrsUgRoesNuNjxf0DUMijvzYemGZOw=;
        b=6sR2CDyQ50LOVfE9K6hWG1RqPZdR6ZteW9MB1EECnXAJvVKgoTalGwpQkU045tnXoc
         zDZjkQomwfweCbSr6gqAPldJKiKhbrVfrfwXD5OBGCZtHz4AezrZeJ/nH3S8ZZsJrzTD
         O2OOm+J0QyBL0rKft5Bkq0tLqUxCFoH3keiZr6KBbK5ptOu6mJsqF/UNO/zp0soFsgPl
         NY2pqxfEMwMCXs0uVGryJ5tNFjdMplDnG6jDcN/fCgtdo+RFDzlfg7q1MCb1ClAem0jv
         cqKTJwA+x5bzsZiN+I8tSDH5ozEv09QWzkwQG4eNZRaZQQd8RogM/lWFAw/ToChIekg6
         HTYg==
X-Gm-Message-State: AOAM530kxZzi5IfNiM+mSZFWD4esBzzaq6QV0zI4U7i1vVtnFPFbwupd
        KSAJMTomw4S+hwewSkVMn1swMpLFapIIDNbsctU=
X-Google-Smtp-Source: ABdhPJz7MkCjTEyiz+NK7oEvCsuYoUVLt4MhDKFMJnhT7dLj1HchoBu5mJT+/G85d3wBLha0ezafgUn+3rf1rFlXuYY=
X-Received: by 2002:a25:abcf:: with SMTP id v73mr66297958ybi.459.1641607749650;
 Fri, 07 Jan 2022 18:09:09 -0800 (PST)
MIME-Version: 1.0
References: <1641471171-34232-1-git-send-email-wanpengli@tencent.com> <YdjX//gxZtP/ZMME@google.com>
In-Reply-To: <YdjX//gxZtP/ZMME@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 8 Jan 2022 10:08:59 +0800
Message-ID: <CANRm+Cz6NE_72V-_sCQxEvHQxuHEtBVsmYX1tE02+Y6EPRFzkA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Dont' deliver posted IRQ if vCPU == this vCPU
 and vCPU is IN_GUEST_MODE
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 8 Jan 2022 at 08:17, Sean Christopherson <seanjc@google.com> wrote:
>
> Nit, s/deliver/send, "deliver" reads as though KVM is ignoring an event that was
> sent by something else.
>
> On Thu, Jan 06, 2022, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Commit fdba608f15e2 (KVM: VMX: Wake vCPU when delivering posted IRQ even
> > if vCPU == this vCPU) fixes wakeup event is missing when it is not from
> > synchronous kvm context by dropping vcpu == running_vcpu checking completely.
> > However, it will break the original goal to optimise timer fastpath, let's
> > move the checking under vCPU is IN_GUEST_MODE to restore the performance.
>
> Please (a) explain why this is safe and (b) provide context for exactly what
> fastpath this helpers.  Lack of context is partly what led to the optimization
> being reverted instead of being fixed as below, and forcing readers to jump through
> multiple changelogs to understand what's going on is unnecessarily mean.
>
> E.g.
>
>   When delivering a virtual interrupt, don't actually send a posted interrupt
>   if the target vCPU is also the currently running vCPU and is IN_GUEST_MODE,
>   in which case the interrupt is being sent from a VM-Exit fastpath and the
>   core run loop in vcpu_enter_guest() will manually move the interrupt from
>   the PIR to vmcs.GUEST_RVI.  IRQs are disabled while IN_GUEST_MODE, thus
>   there's no possibility of the virtual interrupt being sent from anything
>   other than KVM, i.e. KVM won't suppress a wake event from an IRQ handler
>   (see commit fdba608f15e2, "KVM: VMX: Wake vCPU when delivering posted IRQ
>   even if vCPU == this vCPU").
>
>   Eliding the posted interrupt restores the performance provided by the
>   combination of commits 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt
>   delivery for timer fastpath") and 26efe2fd92e5 ("KVM: VMX: Handle
>   preemption timer fastpath").
>
> The comment above send_IPI_mask() also needs to be updated.  There are a few
> existing grammar and style nits that can be opportunistically cleaned up, too.
>
> Paolo, if Wanpeng doesn't object, can you use the above changelog and the below
> comment?

Thanks for these updates, Sean.

    Wanpeng

>
> With that,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> ---
>  arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fe06b02994e6..730df0e183d6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3908,31 +3908,32 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
>  #ifdef CONFIG_SMP
>         if (vcpu->mode == IN_GUEST_MODE) {
>                 /*
> -                * The vector of interrupt to be delivered to vcpu had
> -                * been set in PIR before this function.
> +                * The vector of the virtual has already been set in the PIR.
> +                * Send a notification event to deliver the virtual interrupt
> +                * unless the vCPU is the currently running vCPU, i.e. the
> +                * event is being sent from a fastpath VM-Exit handler, in
> +                * which case the PIR will be synced to the vIRR before
> +                * re-entering the guest.
>                  *
> -                * Following cases will be reached in this block, and
> -                * we always send a notification event in all cases as
> -                * explained below.
> +                * When the target is not the running vCPU, the following
> +                * possibilities emerge:
>                  *
> -                * Case 1: vcpu keeps in non-root mode. Sending a
> -                * notification event posts the interrupt to vcpu.
> +                * Case 1: vCPU stays in non-root mode. Sending a notification
> +                * event posts the interrupt to the vCPU.
>                  *
> -                * Case 2: vcpu exits to root mode and is still
> -                * runnable. PIR will be synced to vIRR before the
> -                * next vcpu entry. Sending a notification event in
> -                * this case has no effect, as vcpu is not in root
> -                * mode.
> +                * Case 2: vCPU exits to root mode and is still runnable. The
> +                * PIR will be synced to the vIRR before re-entering the guest.
> +                * Sending a notification event is ok as the host IRQ handler
> +                * will ignore the spurious event.
>                  *
> -                * Case 3: vcpu exits to root mode and is blocked.
> -                * vcpu_block() has already synced PIR to vIRR and
> -                * never blocks vcpu if vIRR is not cleared. Therefore,
> -                * a blocked vcpu here does not wait for any requested
> -                * interrupts in PIR, and sending a notification event
> -                * which has no effect is safe here.
> +                * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
> +                * has already synced PIR to vIRR and never blocks the vCPU if
> +                * the vIRR is not empty. Therefore, a blocked vCPU here does
> +                * not wait for any requested interrupts in PIR, and sending a
> +                * notification event also results in a benign, spurious event.
>                  */
> -
> -               apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
> +               if (vcpu != kvm_get_running_vcpu())
> +                       apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
>                 return;
>         }
>  #endif
>
