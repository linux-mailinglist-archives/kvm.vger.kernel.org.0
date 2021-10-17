Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84804306B2
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 06:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241437AbhJQEqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 00:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbhJQEqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Oct 2021 00:46:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395C0C061765
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 21:44:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t11so9005942plq.11
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 21:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8hxkkjC59Lk20UqzTDUhRF4a3QLCPerXoGaMuMIfbA=;
        b=T+yExjczlNVce32AnKsOADeGvIvc9/hmv9tJkGiZ38+EWDlFw7dH0wi3W76abD1qyo
         0kK2PgXS2Xxrlf4mC8oqUQNcm5dP5/Iq115Yus8QGdF+vhFKhVAFMffRLbv25M4OkojR
         QQfbYmm86orFpJ5wuDeeOqL9fhlXeXzK89Ijh2BW2FmI1a7X4LE1Wd8/XVSlQkDtXrhB
         /BWkmbswgoRE7nvPdb4MT129rJo0JtNFdJFEX40I2JxfBD5lPbWusu3UbbZGTRuyl1sD
         Mcl+oaeIjpHFsSe75mZFb12Gh8kP6yV+xCQxQVU3+LwC655JurIhP8Ygg8T+qGAkT9Kd
         akIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8hxkkjC59Lk20UqzTDUhRF4a3QLCPerXoGaMuMIfbA=;
        b=YS3qV/p/6BqtYY4vHMGahRt5Y9EKm5Z6pyFdv/Ay7lnpnbU1/kZe8QWs3NTpmrum7P
         bsLVMMaVovYBXmBVtuzYbXIbViP7jwBN8wCCP55FUyykz1cWBVwQzuUrJSpbYUAbS8Ua
         fgMvxhC6o6nvFxJPu1Ytq0RvkhCpLGQ/Y1BteXD7NWwgb2qiHLVDWzJzY2/7tm6n/Q0s
         Lt98EZ8X4yTHoRyfTj7loZ2ibHzEENz1LDO8rWTkOZxpfZ0XV4mWO6nPLdVwWZZIqiro
         vkfNGvcjVFTML9HFE279wGqdw72h564iG/FFsdyhIKAQvh3DLX8LjsXRj9lbU9advjQ5
         z5Ew==
X-Gm-Message-State: AOAM530VM3F7E/bKiPGUz8b0SpTk7MRabzLcK1l3NIY9M1Z9aym4He20
        9WBDo56c5xbrmXoX9GOikZbNf2FiSuXY8ZzAnm69RQ==
X-Google-Smtp-Source: ABdhPJyKMiTmY39aaGR53moXzMQSfsCG990gr+68UwPJI39g1bF/oHnDrzgDbR9D57bdYzAnc0v/bWSYRHrmATRzOTM=
X-Received: by 2002:a17:90b:38c3:: with SMTP id nn3mr25207656pjb.110.1634445848472;
 Sat, 16 Oct 2021 21:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com> <20211012043535.500493-5-reijiw@google.com>
 <20211015134741.b7jahdmypu6tqkt2@gator>
In-Reply-To: <20211015134741.b7jahdmypu6tqkt2@gator>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 16 Oct 2021 21:43:52 -0700
Message-ID: <CAAeT=Fw-ECM0n1C1HvtiiNEm-xhcK2-R0fWbA7hd38BJge+2RQ@mail.gmail.com>
Subject: Re: [RFC PATCH 04/25] KVM: arm64: Introduce struct id_reg_info
To:     Andrew Jones <drjones@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -263,6 +263,76 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >               return read_zero(vcpu, p);
> >  }
> >
> > +struct id_reg_info {
> > +     u32     sys_reg;        /* Register ID */
> > +     u64     sys_val;        /* Sanitized system value */
> > +
> > +     /*
> > +      * Limit value of the register for a vcpu. The value is sys_val
> > +      * with bits cleared for unsupported features for the guest.
> > +      */
> > +     u64     vcpu_limit_val;
>
> Maybe I'll see a need for both later, but at the moment I'd think we only
> need sys_val with the bits cleared for disabled features.

Uh, yes, sys_val is used in patch-15 and I should have introduced
the field in the patch.  I will fix it in v2.


> > -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> > +static int __set_id_reg(struct kvm_vcpu *vcpu,
> >                       const struct sys_reg_desc *rd, void __user *uaddr,
> >                       bool raz)
> >  {
> >       const u64 id = sys_reg_to_index(rd);
> > +     u32 encoding = reg_to_encoding(rd);
> >       int err;
> >       u64 val;
> >
> > @@ -1252,10 +1327,18 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
> >       if (err)
> >               return err;
> >
> > -     /* This is what we mean by invariant: you can't change it. */
> > -     if (val != read_id_reg(vcpu, rd, raz))
> > +     /* Don't allow to change the reg unless the reg has id_reg_info */
> > +     if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
> >               return -EINVAL;
> >
> > +     if (raz)
> > +             return (val == 0) ? 0 : -EINVAL;
>
> This is already covered by the val != read_id_reg(vcpu, rd, raz) check.

Yes, it can simply return 0 for raz case in this patch.
I will fix this in v2.


> > +     err = validate_id_reg(vcpu, rd, val);
> > +     if (err)
> > +             return err;
> > +
> > +     __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(encoding)) = val;
> >       return 0;
> >  }
> >
> > @@ -2818,6 +2901,23 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >       return write_demux_regids(uindices);
> >  }
> >
> > +static void id_reg_info_init_all(void)
> > +{
> > +     int i;
> > +     struct id_reg_info *id_reg;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
> > +             id_reg = (struct id_reg_info *)id_reg_info_table[i];
> > +             if (!id_reg)
> > +                     continue;
> > +
> > +             if (id_reg->init)
> > +                     id_reg->init(id_reg);
> > +             else
> > +                     id_reg_info_init(id_reg);
>
> Maybe call id_reg->init(id_reg) from within id_reg_info_init() in case we
> wanted to apply some common id register initialization at some point?

Thank you for the nice suggestion.
That sounds like a better idea. I'll look into fixing it in v2.

Thanks,
Reiji
