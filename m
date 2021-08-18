Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B603F0B2A
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhHRSmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhHRSmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:42:49 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B311AC061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:42:14 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id f25so1414083uam.1
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Ng1WTSvGZfgMb8v7uO3fX7kJHxGGsPeDrhYAtssMjo=;
        b=FCFhANXc7mQxpbwR01iX9xsG9YdDJu18csNeMdwwPRJp97wQ6bgZ1hEDmtGaKl84QQ
         mDbY0oWVa8Yl2hsjUhrY1hCsRnaWkSKfKh8mOem0jit7Go1mhRS5NUTKKBfaXGG3QQUY
         Cwf35BzM6HewqEh6yuZ9FvxFvFFt9JpDQn63SRNdO4hjVWh/+LlLXVeCF2Pr1HvRJf/X
         i67jgtF/qnCz2MH5focYtOQovIVaPOB2WGpGxkSe4BkQ3wZ+VIVM8aod8yxBzDuQJXOq
         zw28BweF2reGP8BOMWpPEzSLMRgKB7ZEus/26gI6pJwqpugS6Ibfj1KEwsZYYHEuSN1g
         7low==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Ng1WTSvGZfgMb8v7uO3fX7kJHxGGsPeDrhYAtssMjo=;
        b=dWvioGf4+W0HNm9RrQA1rYy1WdFTKjCwsccvMrmJPgESilo5nShAFDRGmUR+K1JbKl
         fbZZsj3iZvN7fjctWjoSfk99z8Xs31aDMLb7yR2TrIhakGHFWOek2nsqStMYu8VDh4fI
         Bfs8UB++WX4MIzc6TfuyvP/xbEk0f7s3jGQtbujwmA4e3TEiWr51Nd2PzmlzMEbxvtgi
         XbM2HHvwJK8QiCNfxfTpGMt1qeIEk2XvOF2nzOwi5L+u/eVMbrtRnGb+jXC5+8jSwwEK
         5XlC8gPj96oIj0a64yYv+H3SqQE0ze9KqDMEQD33xdWGINUhy9UT+tungavI87qPjQrT
         gSzA==
X-Gm-Message-State: AOAM533IuDDK1oKGSx4V/vv8kt1rRVnVgnK314NSjsPxCH6B3ns5QQgB
        4Obp6TsOok4B4kKAE4xvWDBt4B8ogIB3+XZE0jYRFA==
X-Google-Smtp-Source: ABdhPJxD2TsqeJAu62OQI9GJbfnHm0E/nNI7HgtCLesglhFdiEu2JJtzEl0++gNNcsrTStCnIgoDo+CKE1MjNFtghVw=
X-Received: by 2002:ab0:3a8f:: with SMTP id r15mr8202775uaw.13.1629312133633;
 Wed, 18 Aug 2021 11:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210818184057.515187-1-rananta@google.com>
In-Reply-To: <20210818184057.515187-1-rananta@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 18 Aug 2021 11:42:03 -0700
Message-ID: <CAJHc60z9AQ1huwan_WE5etEV0BAq_ZtNea+0u1AqgGHdAFmKQw@mail.gmail.com>
Subject: Re: KVM: arm64: vgic: Resample HW pending state on deactivation
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please ignore this. Sent by accident.

Regards,
Raghavendra

On Wed, Aug 18, 2021 at 11:41 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> From: Marc Zyngier <maz@kernel.org>
>
> When a mapped level interrupt (a timer, for example) is deactivated
> by the guest, the corresponding host interrupt is equally deactivated.
> However, the fate of the pending state still needs to be dealt
> with in SW.
>
> This is specially true when the interrupt was in the active+pending
> state in the virtual distributor at the point where the guest
> was entered. On exit, the pending state is potentially stale
> (the guest may have put the interrupt in a non-pending state).
>
> If we don't do anything, the interrupt will be spuriously injected
> in the guest. Although this shouldn't have any ill effect (spurious
> interrupts are always possible), we can improve the emulation by
> detecting the deactivation-while-pending case and resample the
> interrupt.
>
> Reported-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v2.c | 25 ++++++++++++++++++-------
>  arch/arm64/kvm/vgic/vgic-v3.c | 25 ++++++++++++++++++-------
>  2 files changed, 36 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index 2c580204f1dc9..3e52ea86a87ff 100644
> --- a/arch/arm64/kvm/vgic/vgic-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> @@ -60,6 +60,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                 u32 val = cpuif->vgic_lr[lr];
>                 u32 cpuid, intid = val & GICH_LR_VIRTUALID;
>                 struct vgic_irq *irq;
> +               bool deactivated;
>
>                 /* Extract the source vCPU id from the LR */
>                 cpuid = val & GICH_LR_PHYSID_CPUID;
> @@ -75,7 +76,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>
>                 raw_spin_lock(&irq->irq_lock);
>
> -               /* Always preserve the active bit */
> +               /* Always preserve the active bit, note deactivation */
> +               deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
>                 irq->active = !!(val & GICH_LR_ACTIVE_BIT);
>
>                 if (irq->active && vgic_irq_is_sgi(intid))
> @@ -105,6 +107,12 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                  * device state could have changed or we simply need to
>                  * process the still pending interrupt later.
>                  *
> +                * We could also have entered the guest with the interrupt
> +                * active+pending. On the next exit, we need to re-evaluate
> +                * the pending state, as it could otherwise result in a
> +                * spurious interrupt by injecting a now potentially stale
> +                * pending state.
> +                *
>                  * If this causes us to lower the level, we have to also clear
>                  * the physical active state, since we will otherwise never be
>                  * told when the interrupt becomes asserted again.
> @@ -115,12 +123,15 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                 if (vgic_irq_is_mapped_level(irq)) {
>                         bool resample = false;
>
> -                       if (val & GICH_LR_PENDING_BIT) {
> -                               irq->line_level = vgic_get_phys_line_level(irq);
> -                               resample = !irq->line_level;
> -                       } else if (vgic_irq_needs_resampling(irq) &&
> -                                  !(irq->active || irq->pending_latch)) {
> -                               resample = true;
> +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> +                               if (!(irq->active || irq->pending_latch))
> +                                       resample = true;
> +                       } else {
> +                               if ((val & GICH_LR_PENDING_BIT) ||
> +                                   (deactivated && irq->line_level)) {
> +                                       irq->line_level = vgic_get_phys_line_level(irq);
> +                                       resample = !irq->line_level;
> +                               }
>                         }
>
>                         if (resample)
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 66004f61cd83d..74f9aefffd5e0 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -46,6 +46,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                 u32 intid, cpuid;
>                 struct vgic_irq *irq;
>                 bool is_v2_sgi = false;
> +               bool deactivated;
>
>                 cpuid = val & GICH_LR_PHYSID_CPUID;
>                 cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> @@ -68,7 +69,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>
>                 raw_spin_lock(&irq->irq_lock);
>
> -               /* Always preserve the active bit */
> +               /* Always preserve the active bit, note deactivation */
> +               deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
>                 irq->active = !!(val & ICH_LR_ACTIVE_BIT);
>
>                 if (irq->active && is_v2_sgi)
> @@ -98,6 +100,12 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                  * device state could have changed or we simply need to
>                  * process the still pending interrupt later.
>                  *
> +                * We could also have entered the guest with the interrupt
> +                * active+pending. On the next exit, we need to re-evaluate
> +                * the pending state, as it could otherwise result in a
> +                * spurious interrupt by injecting a now potentially stale
> +                * pending state.
> +                *
>                  * If this causes us to lower the level, we have to also clear
>                  * the physical active state, since we will otherwise never be
>                  * told when the interrupt becomes asserted again.
> @@ -108,12 +116,15 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                 if (vgic_irq_is_mapped_level(irq)) {
>                         bool resample = false;
>
> -                       if (val & ICH_LR_PENDING_BIT) {
> -                               irq->line_level = vgic_get_phys_line_level(irq);
> -                               resample = !irq->line_level;
> -                       } else if (vgic_irq_needs_resampling(irq) &&
> -                                  !(irq->active || irq->pending_latch)) {
> -                               resample = true;
> +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> +                               if (!(irq->active || irq->pending_latch))
> +                                       resample = true;
> +                       } else {
> +                               if ((val & ICH_LR_PENDING_BIT) ||
> +                                   (deactivated && irq->line_level)) {
> +                                       irq->line_level = vgic_get_phys_line_level(irq);
> +                                       resample = !irq->line_level;
> +                               }
>                         }
>
>                         if (resample)
> --
> cgit 1.2.3-1.el7
>
