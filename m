Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D3493544
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 08:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345322AbiASHL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 02:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbiASHL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 02:11:56 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8123C061574;
        Tue, 18 Jan 2022 23:11:55 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id z25-20020a0568301db900b005946f536d85so1869891oti.9;
        Tue, 18 Jan 2022 23:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ikn30aUM99gJ2VagExPBsGnL9B0l2A0Fm2qzqrsZrWM=;
        b=fHVkdFn2/ftk1e6EgW6ct6a13sFymBmnGq2Q5ExseIC0cm4npxL16ZjgqksNIZt1LA
         GOmm/zW906DpabEAKfNxJdU2rnqKqtQCQ7xtzqAgoCEvXBH1D7hFfgogM45hL0IS1x7t
         iuIv6MHnNn1lL5H6Z5pVjKs0tDUkxmHM/1Si2h7Hz/Y2JPPeJd9BXgMZFuFm/Cb4v2UF
         AvWxgJNHPPWkeH6gjnzIIKcG0s9yK63U5y2as3xJXeCnppNOD01DJ9c+kjhCK05KWn5M
         IyDhgzP6T0r2sYZ+wT84oeHDo0TdOzxLCH9XsK2pTcISTXOGubQUtyBlCMS1mUZcEbXV
         KUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ikn30aUM99gJ2VagExPBsGnL9B0l2A0Fm2qzqrsZrWM=;
        b=p2cXb2XO8HB4U30VxuNaYJNyPY4I/yOzx5Qr6p1wvD5o8vbAUC0yH99Ljq0lZhahSD
         5Ea0AmZ7oFUR3WY7qCuS8aaPsfYUlueFarMxHwsYYfFZkPvI5O9O762c/B1oUR0agPKs
         wXSrw54FvOdyxrWHs+/37s4ueXTpbdmmb33IyjL6XUJiwmGNr+6DR9IqS9oXp1jfoPfp
         QCvbpkNi9vzybiCteDCCQHka8RekZS7jF1L48zzs7UFXQ0DIKXEGBfHtERFu96qeAMYz
         +K171TyckLCcP9Pp6XVKZP4/yzQwriS3wLF0jtpeKNGLTh6ldZEI8BXae2gI4eIKOvdo
         51mQ==
X-Gm-Message-State: AOAM530apMRHBfPBWxvgY8oMrvPaT5ULrHup24lFvNAS4CxHTUPePR2+
        85I1GVRxxV9ZqImAuX558sbGEBkiT0aPIxNFdBU=
X-Google-Smtp-Source: ABdhPJxpWVsNDwvYvhfhHlV2c55Ksx+vNGO6Com+s2zSvnDxkyrR/5NtQm7hWIc9dyoPsU0Q2howNQqmkF7JHCtzqSY=
X-Received: by 2002:a9d:4b11:: with SMTP id q17mr7621371otf.55.1642576315304;
 Tue, 18 Jan 2022 23:11:55 -0800 (PST)
MIME-Version: 1.0
References: <1641609762-39471-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1641609762-39471-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 19 Jan 2022 15:11:44 +0800
Message-ID: <CANRm+Cx_CQ_SgpT3QvptRy2HZeQEyDkM7Uzh4keJ1XfT6gwX6w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: VMX: Dont' send posted IRQ if vCPU == this vCPU
 and vCPU is IN_GUEST_MODE
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kindly ping, :)
On Sat, 8 Jan 2022 at 10:43, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> When delivering a virtual interrupt, don't actually send a posted interrupt
> if the target vCPU is also the currently running vCPU and is IN_GUEST_MODE,
> in which case the interrupt is being sent from a VM-Exit fastpath and the
> core run loop in vcpu_enter_guest() will manually move the interrupt from
> the PIR to vmcs.GUEST_RVI.  IRQs are disabled while IN_GUEST_MODE, thus
> there's no possibility of the virtual interrupt being sent from anything
> other than KVM, i.e. KVM won't suppress a wake event from an IRQ handler
> (see commit fdba608f15e2, "KVM: VMX: Wake vCPU when delivering posted IRQ
> even if vCPU == this vCPU").
>
> Eliding the posted interrupt restores the performance provided by the
> combination of commits 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt
> delivery for timer fastpath") and 26efe2fd92e5 ("KVM: VMX: Handle
> preemption timer fastpath").
>
> Thanks Sean for better comments.
>
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fe06b02994e6..e06377c9a4cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3908,31 +3908,33 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
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
>
> -               apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
> +               if (vcpu != kvm_get_running_vcpu())
> +                       apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
>                 return;
>         }
>  #endif
> --
> 2.25.1
>
