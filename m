Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D02459B48
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 05:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhKWEmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 23:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhKWEmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 23:42:51 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79460C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 20:39:44 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u80so6544239pfc.9
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 20:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JZECwSvXg0MwYpcw/lT1xG0xEMMAh0EHotR98E/tTUA=;
        b=PWqHevJs+bq9UN9gwN2aFq2+fwq425MeYgrrioyKiiN1cCCza9b42qYr1ENBfAdLHY
         Ejg+Xfy1J/EEVC5Rj55hTArkewbGIfslYO8+e8PJ9+457cGvTOnEwrnYXY+VZKMLZOJQ
         NFQfBJsuSIpbnIMgPtsoq7sHo+wr23hhBiXzabS4JgI5a26+COLpw02rY/Nd8xEyawZq
         jQCXNig79ITPzvs8CzPXDknaxM2JUnxVbQJg3fL+pZoUTOxOm7PtuLISagRd5AIT81sh
         SVzpdwtwvQDHpB+26yyd/L74AGwcefc9jhM+fLFOwZbc5NgfFqg5aTMhkZ1fL3bXigFp
         +yWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JZECwSvXg0MwYpcw/lT1xG0xEMMAh0EHotR98E/tTUA=;
        b=o/pMLRz2Uq8AU5u3ZBH4vzomLJkfWayxKOr5YykOAX9k/vf4NUJJdLF6M2NdTSsNvI
         Pw/dKKPnlGVRKCc8SHC+WsPawtWc1oaD8GDUQUdvv1RxWvj5M1tSzNQXUnXc503PM7Xv
         1BFoEhyw3nX5/OC/fjMie5yfZ5aJKo1z+wmS1iHw0+p2GypcPCGIc88cmUTOTa85RW8F
         yxrOrEilXPXRLrfuvdvMCK9weMywvBqOErk3N8vJKYiAWX5gyo/qF1sKe6HjNFW16dfl
         nzlf36p137Ma/xIrrZBiEZZTkiz80ZfCx+F7ouhfcPt1TL4CAvHKRkmPCtNWgP+bLusJ
         hQzQ==
X-Gm-Message-State: AOAM530KJ0vOgNl9oEz2+9EossfAK9mVDL+TKt9lnxKi1pVJnH1W/n5b
        n3lJBsccFTHLBOO1xVJswJEDIvfhYxiNHfAK3Bo+Gg==
X-Google-Smtp-Source: ABdhPJyegAX27Q4ZmfdkoCLcAk4V9INtgvTmDNc65NtpQ43unJw2bVPyzHKuMXESV5tSMJHj1ocMLRNeBY+/ugIckl0=
X-Received: by 2002:aa7:9438:0:b0:4a2:c941:9ac4 with SMTP id
 y24-20020aa79438000000b004a2c9419ac4mr2437622pfo.12.1637642383746; Mon, 22
 Nov 2021 20:39:43 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-3-reijiw@google.com>
 <87lf1hsn11.wl-maz@kernel.org>
In-Reply-To: <87lf1hsn11.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 22 Nov 2021 20:39:27 -0800
Message-ID: <CAAeT=Fxcd9ExAXP-c6N-LYAT8_SGYUMHHeGO5dCW8=K+m=WTMQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 17 Nov 2021 06:43:32 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > registers' sanitized value in the array for the vCPU at the first
> > vCPU reset. Use the saved ones when ID registers are read by
> > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 10 +++++++
> >  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
> >  2 files changed, 37 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index edbe2cb21947..72db73c79403 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
> >       u64 disr_el1;           /* Deferred [SError] Status Register */
> >  };
> >
> > +/*
> > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > + * where 0<=crm<8, 0<=op2<8.
> > + */
> > +#define KVM_ARM_ID_REG_MAX_NUM 64
> > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > +
> >  enum vcpu_sysreg {
> >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > @@ -210,6 +218,8 @@ enum vcpu_sysreg {
> >       CNTP_CVAL_EL0,
> >       CNTP_CTL_EL0,
> >
> > +     ID_REG_BASE,
> > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
>
> It is rather unclear to me why we want these registers to be
> replicated on a per-CPU basis. Yes, this fits the architecture, but
> that's also a total waste of memory if you have more than a single
> CPU, because we make a point in only exposing homogeneous properties
> to the VM (I don't think anyone intends to support vcpu asymmetry in a
> VM, and 64 registers per vcpu is not an insignificant memory usage).
>
> If there are no reasons for this to be per-CPU, please move it to be
> global to the VM. This also mean that once a vcpu has reset, it
> shouldn't be possible to affect the registers. This shouldn't affect
> the userspace API though.


Currently, userspace can configure different CPU features for each vCPU
with KVM_ARM_VCPU_INIT, which indirectly affect ID registers.
I'm not sure if anyone actually does that though.

Since I personally thought having ID registers per vCPU more naturally
fits the behavior of KVM_ARM_VCPU_INIT and makes more straightforward
behavior of KVM_SET_ONE_REG, I chose that.
(That would be also better in terms of vCPUs scalability for live migration
 considering a case where userspace tries to restore ID registers for
 many vCPUs in parallel during live migration.  Userspace could avoid that,
 and there are ways for KVM to mitigate that though.)

Having ID registers per-VM is of course feasible even while maintaining
the current behavior of KVM_ARM_VCPU_INIT though.

Thanks,
Reiji
