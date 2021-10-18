Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDB9431FBB
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 16:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhJROc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 10:32:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230344AbhJROc5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 10:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634567446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16lgWy6r2ijeFvmyYBWNBFj6OUleKDb2cTJh8BDi66E=;
        b=SGFXuGrTTxzQ86NL2hRGT/ETTz3DcqLVY1sye/vp6GW0yScUOWF7/5/0cx072ssdoHipWN
        GNoohbn7IZnzImk1V+o5eG5eagu1U28MSLeOQpLxEHKdMJCH5+/Hk6OBOogMeUHh4cFLTH
        4NSUP4sY/IRXyTSgs8xcrYjNWjO6iHk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-mN5a_xx1N8yi28qR-kgt9Q-1; Mon, 18 Oct 2021 10:30:44 -0400
X-MC-Unique: mN5a_xx1N8yi28qR-kgt9Q-1
Received: by mail-ed1-f70.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so14530834edi.12
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 07:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=16lgWy6r2ijeFvmyYBWNBFj6OUleKDb2cTJh8BDi66E=;
        b=htLkuuNMLKHSe/46w73bYW1c6og91lcF/M3RbYNmZJcavMu1xi22APjf1goc0ZVJLg
         yamB/28dxKoQNlvWJKzQbuskuwTRqkOlIC8rYIHWTizXwQvcyXwyym+KLeAU6Q4IxMOp
         zzqGOw+Mqzu9rKYcNJmJKhjSOcsx8GC56eL1ys6dtBGjMQVynVrL5QnO8rfBgqeW3o1W
         yR6aCN/GKieG+eJ3g2CW1WChrceU/aR9Ptbq6DCE/S0kJXurV+QFZmtd7Tgo7Gw2uW4U
         vKgW/XdXZRE8lFYdzCCpvNpJ/i7RHjyFkNn7VyhDq5ftMkeyMBBiQuB/pLoXFi3iCcDA
         6Raw==
X-Gm-Message-State: AOAM530r1ghVf7LG6OO6BWlf45EcU37L2fy4l/kmkAMWCRuHt5TCWYKS
        OAkfQ0YqorUisoY6wJDq14xtZecjP+5P2NdGyujSpC59PMz82eF8sSH9iXJiXDFxZER4XNZ0JWI
        h6qu+FeMMB202
X-Received: by 2002:aa7:cd8b:: with SMTP id x11mr45193824edv.384.1634567443444;
        Mon, 18 Oct 2021 07:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOPhN4B7GDbBSZ7+1OX/c4MoxhYUWo11/O3rb3LVvmuMXMvo3tDY2r0PmKoGrxiNYc9rNOlg==
X-Received: by 2002:aa7:cd8b:: with SMTP id x11mr45193777edv.384.1634567443091;
        Mon, 18 Oct 2021 07:30:43 -0700 (PDT)
Received: from gator.home (cst2-174-2.cust.vodafone.cz. [31.30.174.2])
        by smtp.gmail.com with ESMTPSA id jg21sm5789033ejc.14.2021.10.18.07.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 07:30:42 -0700 (PDT)
Date:   Mon, 18 Oct 2021 16:30:40 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value
 per vCPU
Message-ID: <20211018143040.nhkv67cxni6ind6k@gator.home>
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-3-reijiw@google.com>
 <20211015130918.ezlygga73doepbw6@gator>
 <CAAeT=Fx9zUet2HvFe8dwhXjyozuggn+qcQBoyb_8hUGJNKFNTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fx9zUet2HvFe8dwhXjyozuggn+qcQBoyb_8hUGJNKFNTQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 16, 2021 at 05:42:59PM -0700, Reiji Watanabe wrote:
> On Fri, Oct 15, 2021 at 6:09 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Mon, Oct 11, 2021 at 09:35:12PM -0700, Reiji Watanabe wrote:
> > > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > > registers' sanitized value in the array for the vCPU at the first
> > > vCPU reset. Use the saved ones when ID registers are read by
> > > userspace (via KVM_GET_ONE_REG) or the guest.
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> > >  arch/arm64/kvm/sys_regs.c         | 26 ++++++++++++++++++--------
> > >  2 files changed, 28 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 9b5e7a3b6011..0cd351099adf 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
> > >       u64 disr_el1;           /* Deferred [SError] Status Register */
> > >  };
> > >
> > > +/*
> > > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > > + * where 0<=crm<8, 0<=op2<8.
> >
> > crm is 4 bits, so this should be 0 <= crm < 16 and...
> >
> > > + */
> > > +#define KVM_ARM_ID_REG_MAX_NUM 64
> >
> > ...this should be 128. Or am I missing something?
> 
> Registers with (3, 0, 0, 0<=crm<8, op2) are defined/allocated including
> reserved (RAZ) ones (please see Table D12-2 in ARM DDI 0487G.b),
> and the code supports those only for now.
> 
> I understand that registers with crm >= 8 could be defined in the future
> (I'm not so sure if they will be really ID registers though),
> but then we can include them later as needed.

Oh, I see. Thanks. Looking at the table I see CRm=0,op2={1,2,3,4,7} are
also missing, but it certainly doesn't matter that we allocate a few
unused entries, especially since we also allocate entries for all the
RAZ ones.

> 
> > > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > > +
> > >  enum vcpu_sysreg {
> > >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> > >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > > @@ -209,6 +217,8 @@ enum vcpu_sysreg {
> > >       CNTP_CVAL_EL0,
> > >       CNTP_CTL_EL0,
> > >
> > > +     ID_REG_BASE,
> > > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> > >       /* Memory Tagging Extension registers */
> > >       RGSR_EL1,       /* Random Allocation Tag Seed Register */
> > >       GCR_EL1,        /* Tag Control Register */
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 1d46e185f31e..72ca518e7944 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> > >                         struct sys_reg_params *p,
> > >                         const struct sys_reg_desc *r)
> > >  {
> > > -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > > +     u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
> > >       u32 sr = reg_to_encoding(r);
> > >
> > >       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > > @@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> > >       return true;
> > >  }
> > >
> > > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > >               struct sys_reg_desc const *r, bool raz)
> > >  {
> > >       u32 id = reg_to_encoding(r);
> > > -     u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> > > +     u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> > >
> > >       switch (id) {
> > >       case SYS_ID_AA64PFR0_EL1:
> > > @@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> > >       return REG_HIDDEN;
> > >  }
> > >
> > > +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> >
> > Since not all ID registers will use this, then maybe name it
> > reset_sanitised_id_reg?
> 
> Thank you for the suggestion.
> 
> I named it 'reset_id_reg' according to the naming conventions of
> set_id_reg, get_id_reg, and access_id_reg which are used for the same
> set of ID registers (ID_SANITISED ones) as reset_id_reg.
> I would think it's better to use consistent names for all of them.
> So, I am a bit reluctant to change only the name of reset_id_reg.
> 
> What do you think about the names of those other three functions ?

I think I like the shorter names, so please disregard my suggestion.

Thanks,
drew

