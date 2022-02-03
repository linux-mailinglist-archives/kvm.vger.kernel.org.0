Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D754A7F51
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 07:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241786AbiBCGbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 01:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiBCGbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 01:31:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44839C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 22:31:43 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cq9-20020a17090af98900b001b8262fe2d5so3422976pjb.0
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 22:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0JNpO1ucHTB5rovgBwcJawd8MgNnFQ/vVwnrdVHs7Eo=;
        b=GV+al4vvcrVDiYt4J6drbxHFusxaYYYIH+tgwk+Z4EUyLUls5xyfIGwVnZE+XnXdOK
         kFoVCBpfgOxRsexDDOrvMa4+2WxWWQzH4r0n5nPoYYABraOUh5m0o0O8QocuntehY/qy
         Rdpi1YX+MHzBOQ4aaBk1Ykxf8smNnfIi3gG6e5JQXN1XRkwRhfVkyQcH3fvww9lGcRPr
         Oof8UfzU40BjBDuvYX2mCnJEsbbc+IBRPB5Bb3+3XAzowXVJg81Io8WP4zca4KKxf7zW
         cY8mCMdR7kEpg/cTy7VxbOfEzOBBh6huJeSC3uhpDpq+rM+mVY+RV22uy1v0InnhiXQT
         2Bkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0JNpO1ucHTB5rovgBwcJawd8MgNnFQ/vVwnrdVHs7Eo=;
        b=p3Sgox6JGAU7DrxljGdF1degZpIiXSyffeRpdoTjVIvPsAp7vj6P+XiyvUKvUcTFlG
         q3maTPX9Ei6qGYqGUGKqCo7TPqx4GdCSVxxfvxhBvvUG1bYIOwxwG6bnELfuVzpcUZNa
         pIytjVNVntjugVThj2J0+VyQ/BNKM3iu/vEFreQkOvh4NQSs/bj/nxI9Ct7/j42AH92Z
         kC2bK7MjeZ49Aj0YuvWKsWWGYt8Laa7qetDm1gLmBU5KY/1mqbbWS8Gbd0CouEAEWVvp
         rVC2XI8Uv0m3HxEbztOBeHNH6hOYkT8l7nmjcmP/JKSrEv+oDpRcH2iXsx2L1254An2m
         qHLw==
X-Gm-Message-State: AOAM5333+NNEZCz05EB9cfurTVDBCqY3jr7H9ZirlU6e237SYbz+F6x2
        dbpx/DN1Dx8gGH5vEA+boiNtM3tp+x9mzDt8oZZmNw==
X-Google-Smtp-Source: ABdhPJzV5CQCylmu3Fo67mmLFmgt6kPWTZOnGXHJNAnJAu4+wYihWOop8lLL85tltXjivylZ1q87IJf70fcHwjumZtU=
X-Received: by 2002:a17:902:bc83:: with SMTP id bb3mr35070581plb.172.1643869902551;
 Wed, 02 Feb 2022 22:31:42 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com> <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
 <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
 <YfdaKpBqFkULxgX/@google.com> <CAAeT=Fw7Fr2=sWyMZ85Ky-rhQJ3WQTa8fE8tNDHinwFYm3ksBQ@mail.gmail.com>
 <Yfl+Pz4MWOyEHfhf@google.com>
In-Reply-To: <Yfl+Pz4MWOyEHfhf@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 2 Feb 2022 22:31:26 -0800
Message-ID: <CAAeT=Fx3oBoyUmJjyMWmeyzMJJxcAZAYWDQuv4DUqZztm8ooKQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Tue, Feb 1, 2022 at 10:39 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Hey Reiji,
>
> On Mon, Jan 31, 2022 at 10:00:40PM -0800, Reiji Watanabe wrote:
> > Hi Ricardo,
> >
> > On Sun, Jan 30, 2022 at 7:40 PM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > > On Fri, Jan 28, 2022 at 09:52:21PM -0800, Reiji Watanabe wrote:
> > > > Hi Ricardo,
> > > >
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > > > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > > > > > + */
> > > > > > > > +void set_default_id_regs(struct kvm *kvm)
> > > > > > > > +{
> > > > > > > > +     int i;
> > > > > > > > +     u32 id;
> > > > > > > > +     const struct sys_reg_desc *rd;
> > > > > > > > +     u64 val;
> > > > > > > > +
> > > > > > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > > > > > +             rd = &sys_reg_descs[i];
> > > > > > > > +             if (rd->access != access_id_reg)
> > > > > > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > > > > > +                     continue;
> > > > > > > > +
> > > > > > > > +             id = reg_to_encoding(rd);
> > > > > > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > > > > > +                     /* Shouldn't happen */
> > > > > > > > +                     continue;
> > > > > > > > +
> > > > > > > > +             val = read_sanitised_ftr_reg(id);
> > > > > > >
> > > > > > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > > > > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> > > > > >
> > > > > > I'm not sure if I understand your question.
> > > > > > arm64_ftr_bits_kvm is used for feature support checkings when
> > > > > > userspace tries to modify a value of ID registers.
> > > > > > With this patch, KVM just saves the sanitized values in the kvm's
> > > > > > buffer, but userspace is still not allowed to modify values of ID
> > > > > > registers yet.
> > > > > > I hope it answers your question.
> > > > >
> > > > > Based on the previous commit I was assuming that some registers, like
> > > > > id_aa64dfr0,
> > > > > would default to the overwritten values as the sanitized values. More
> > > > > specifically: if
> > > > > userspace doesn't modify any ID reg, shouldn't the defaults have the
> > > > > KVM overwritten
> > > > > values (arm64_ftr_bits_kvm)?
> > > >
> > > > arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
> > > > and arm64_ftr_bits_kvm doesn't have the sanitized values.
> > > >
> > > > Thanks,
> > >
> > > Hey Reiji,
> > >
> > > Sorry, I wasn't very clear. This is what I meant.
> > >
> > > If I set DEBUGVER to 0x5 (w/ FTR_EXACT) using this patch on top of the
> > > series:
> > >
> > >  static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
> > >         S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
> > > -       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
> > > +       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x5),
> > >
> > > it means that userspace would not be able to set DEBUGVER to anything
> > > but 0x5. But I'm not sure what it should mean for the default KVM value
> > > of DEBUGVER, specifically the value calculated in set_default_id_regs().
> > > As it is, KVM is still setting the guest-visible value to 0x6, and my
> > > "desire" to only allow booting VMs with DEBUGVER=0x5 is being ignored: I
> > > booted a VM and the DEBUGVER value from inside is still 0x6. I was
> > > expecting it to not boot, or to show a warning.
> >
> > Thank you for the explanation!
> >
> > FTR_EXACT (in the existing code) means that the safe_val should be
> > used if values of the field are not identical between CPUs (see how
> > update_cpu_ftr_reg() uses arm64_ftr_safe_value()). For KVM usage,
> > it means that if the field value for a vCPU is different from the one
> > for the host's sanitized value, only the safe_val can be used safely
> > for the guest (purely in terms of CPU feature).
>
> Let me double check my understanding using the DEBUGVER example, please.
> The safe_value would be DEBUGVER=5, and it contradicts the initial VM
> value calculated on the KVM side. Q1: Can a contradiction like this
> occur in practice? Q2: If the user saves and restores this id-reg on the
> same kernel, the AA64DFR0 userspace write would fail (ftr_val !=
> arm64_ftr_safe_value), right?

Thank you for the comment!

For Q1, yes, we might possibly create a bug that makes a contradiction
between KVM and cpufeature.c.
For Q2, even with such a contradiction, userspace will still be able to
save and restore the id reg on the same kernel on the same system in most
cases because @limit that KVM will specify for arm64_check_features()
will mostly be the same as the initial value for the guest (except for
fields corresponding to opt-in CPU features, which are configured with
KVM_ARM_VCPU_INIT or etc) and arm64_check_features does an equality check
per field.  Having said that, as you suggested, it might be better to run
arm64_check_features for the initial value against the host value so we
can catch such a bug. I'll look into doing that in v5.

Thanks,
Reiji
