Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661F045A9C4
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 18:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhKWRQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 12:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhKWRQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 12:16:22 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4CDC06173E
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 09:13:14 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z6so16440975plk.6
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 09:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fv8jHJnT3Eva2oaobFBXfDkuR9RNjkJvSl3tDLrQc7A=;
        b=NJo/Ri2OK5QjvagXOJR7sjckD5MHFxoeoaed7q56nfJgpAAvhgb0/PSStStdVFT51F
         xI9tQf5K2pq/P8LJg0Iscf7x6/TmbxgDihx7Qz99u5jrCgDQmNEjEHEYkm7bx+erYs6h
         3J79Xm1VfHwKvZjX/admw8cnxdFmksCn2XHrei5Sm96S9S/6GntqqYqkvV2cyzG69LVR
         5fv0Uhh4ZuRXw2WiZRCtbH4QsMeC+2W+IC+/wiDNET5yyNLZOAXK3ruhatdZMcgsWvzr
         IlLOmi6ezrvlivdxLRDT+8DAyTEnz+80ZTMARp14egKXvyC4JUncP+Fzm+jNndJ2PEF8
         a3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fv8jHJnT3Eva2oaobFBXfDkuR9RNjkJvSl3tDLrQc7A=;
        b=TQsmqouOf3p/53mQEVkunhP6lY7XfpD84OS+65MBZEpfFjO0p2kHH1auyPIEOCkSx7
         z6GZVdUcJisdFcna5zb7RAwpLezu+KIB34Of/XliumMveqIHNs6O296vminSAUfyrLDG
         oyObijNykcd1NmkF+sYG82w6KNToxNHgoi3IBwrnrG+4u5FyuOvhKw3TD8a0cPpEAaIn
         toPD+PiVOCigWb2RBz6gk736hWu2Yn233aXnjV4AjmdzLQGo1c7ie5vwKNHVspYRELIg
         hW9Ebpzdk3oe329GEUv/fnRedhqMzhhDQ4zAQcKgDTF8wmkfUh8vGI4p8KH9uTZGX4MZ
         bxBw==
X-Gm-Message-State: AOAM5314hXi2zqLpwWvD3nXlDcxSykRMQCxJghS1yeuMCkxOzxorcDt/
        xyks0Ae0Ct6Mtz8im1yazxSMCr4jmcUTmGYlnHcS8A==
X-Google-Smtp-Source: ABdhPJwGNpwXwzgcbpUJXRwFkigAhlLEETdVhhn3ua5dVVlxqditNpcRsDJafoTxLjrJHMyDiMB3dAQp3IG3EeeChIE=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr4956330pjb.110.1637687593623;
 Tue, 23 Nov 2021 09:13:13 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-3-reijiw@google.com>
 <87lf1hsn11.wl-maz@kernel.org> <CAAeT=Fxcd9ExAXP-c6N-LYAT8_SGYUMHHeGO5dCW8=K+m=WTMQ@mail.gmail.com>
 <87o86bchok.wl-maz@kernel.org>
In-Reply-To: <87o86bchok.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 23 Nov 2021 09:12:56 -0800
Message-ID: <CAAeT=FzoafZXEoG+xxiQywEpLBaQEE=0bu9c+O6UraDE1BN3_A@mail.gmail.com>
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

On Tue, Nov 23, 2021 at 2:03 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 23 Nov 2021 04:39:27 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Wed, 17 Nov 2021 06:43:32 +0000,
> > > Reiji Watanabe <reijiw@google.com> wrote:
> > > >
> > > > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > > > registers' sanitized value in the array for the vCPU at the first
> > > > vCPU reset. Use the saved ones when ID registers are read by
> > > > userspace (via KVM_GET_ONE_REG) or the guest.
> > > >
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h | 10 +++++++
> > > >  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
> > > >  2 files changed, 37 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index edbe2cb21947..72db73c79403 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
> > > >       u64 disr_el1;           /* Deferred [SError] Status Register */
> > > >  };
> > > >
> > > > +/*
> > > > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > > > + * where 0<=crm<8, 0<=op2<8.
> > > > + */
> > > > +#define KVM_ARM_ID_REG_MAX_NUM 64
> > > > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > > > +
> > > >  enum vcpu_sysreg {
> > > >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> > > >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > > > @@ -210,6 +218,8 @@ enum vcpu_sysreg {
> > > >       CNTP_CVAL_EL0,
> > > >       CNTP_CTL_EL0,
> > > >
> > > > +     ID_REG_BASE,
> > > > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> > >
> > > It is rather unclear to me why we want these registers to be
> > > replicated on a per-CPU basis. Yes, this fits the architecture, but
> > > that's also a total waste of memory if you have more than a single
> > > CPU, because we make a point in only exposing homogeneous properties
> > > to the VM (I don't think anyone intends to support vcpu asymmetry in a
> > > VM, and 64 registers per vcpu is not an insignificant memory usage).
> > >
> > > If there are no reasons for this to be per-CPU, please move it to be
> > > global to the VM. This also mean that once a vcpu has reset, it
> > > shouldn't be possible to affect the registers. This shouldn't affect
> > > the userspace API though.
> >
> >
> > Currently, userspace can configure different CPU features for each vCPU
> > with KVM_ARM_VCPU_INIT, which indirectly affect ID registers.
> > I'm not sure if anyone actually does that though.
>
> But the way the ID regs are affected is always global AFAICT. For
> example, if you instantiate a PMU, you do so on all vcpus, even of the
> architecture allows you to build something completely asymmetric.
>
> > Since I personally thought having ID registers per vCPU more naturally
> > fits the behavior of KVM_ARM_VCPU_INIT and makes more straightforward
> > behavior of KVM_SET_ONE_REG, I chose that.
>
> I agree that this is the logical approach from an architectural PoV.
>
> > (That would be also better in terms of vCPUs scalability for live migration
> >  considering a case where userspace tries to restore ID registers for
> >  many vCPUs in parallel during live migration.  Userspace could avoid that,
> >  and there are ways for KVM to mitigate that though.)
>
> I think these are orthogonal things. We can expose a per-vcpu view,
> but there is no need to have per-vcpu storage and to allow asymmetric
> VMs. If I have anything to say about the future of KVM/arm64, it will
> be that I don't want to support this at all.
>
> > Having ID registers per-VM is of course feasible even while maintaining
> > the current behavior of KVM_ARM_VCPU_INIT though.
>
> Exactly. per-VM storage, and per-vcpu visibility. It will prevent all
> sort of odd behaviours.

Thank you so much for all your comments.
I will make it per VM storage.

Regards,
Reiji
