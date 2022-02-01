Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECFA4A6419
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 19:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbiBASjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 13:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiBASjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 13:39:00 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BB4C061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 10:39:00 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z5so16072994plg.8
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 10:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cjMVwAHRzuneEUKCTGxfeEiXs54VyjggPNF5H89xF7w=;
        b=JTwSqzw1ISkkD95jXW49KDQXWIJU7LMPf79YGR5OHzdcWgTDFD2vZnmClEK8S9sIm7
         JG1sjCJ4GHPHwknL7z/u6qBHDhfxVFHX/NZR9aig2Fs23tpjwAAQ0Gjiys78JXDkn1HY
         dFBT9lQgnvLP5aD9U4HLgAiiOZ3h0N7wdeSCgbqTYWaw7czW4M15Q1uzshu0XbP1xikS
         7RNnaQcvhA/21FQgG4dgj1WwLpDt9hu5ENsX4NCqQ/oncRs+0wQnR9kzkWdb1iJNk5zA
         st0u3wgIde9hqiufaNdkLeO7+tGoj3tsm/SNjAzE/J4+XhFc2Z7l2rQqxNCTkSSuKloa
         nToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cjMVwAHRzuneEUKCTGxfeEiXs54VyjggPNF5H89xF7w=;
        b=Ah6f5xLyz27l6AhhfbQmnsMGw3yMz/KA7fxuaxuiJELrXMHHe6FxWeGeVfZCmpT6iO
         n7GkUb1V2xZYKSYmboxZ5bT3bFPmfEWDwlolbVIqosUgAznF51MCZzLGk2rMe0LUvylf
         X6Z8cxZ470mykExy92q31eFEMzCegeYGDq+5E3UJh6BN/pF0ZAXsaH/Af7wyjA+4GYHE
         GSwKe35dXsvRhal8rtDNYBuTwxTXlvXYkhTEmqXsKDMfWOS6YBN+UBbv8BZSNxmIXSzC
         l7VLmLCfi5PWyLQE9kOunnPIpBxHIoPoOY4xwY642ewcK+joqFBr6i2kghjW4Qi2g0/y
         0mGA==
X-Gm-Message-State: AOAM531GqeETei6I+axBRmsiFiuFJaL9ftFIkpMdKbkq8asl362DwPLC
        iFxcXHnJ1DNiSLFmT3qLxNMmSQ==
X-Google-Smtp-Source: ABdhPJwABX4STQVMJpby2CBINrprsj+frRBmFwkzRq9nIq5ueQaSjnpQnxERileNsQ4/lJqG9fqj5w==
X-Received: by 2002:a17:903:41c1:: with SMTP id u1mr21030773ple.91.1643740739772;
        Tue, 01 Feb 2022 10:38:59 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id f8sm20287551pfv.24.2022.02.01.10.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 10:38:59 -0800 (PST)
Date:   Tue, 1 Feb 2022 10:38:55 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Reiji Watanabe <reijiw@google.com>
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
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
Message-ID: <Yfl+Pz4MWOyEHfhf@google.com>
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com>
 <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
 <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
 <YfdaKpBqFkULxgX/@google.com>
 <CAAeT=Fw7Fr2=sWyMZ85Ky-rhQJ3WQTa8fE8tNDHinwFYm3ksBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fw7Fr2=sWyMZ85Ky-rhQJ3WQTa8fE8tNDHinwFYm3ksBQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Reiji,

On Mon, Jan 31, 2022 at 10:00:40PM -0800, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> On Sun, Jan 30, 2022 at 7:40 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > On Fri, Jan 28, 2022 at 09:52:21PM -0800, Reiji Watanabe wrote:
> > > Hi Ricardo,
> > >
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > > > > + */
> > > > > > > +void set_default_id_regs(struct kvm *kvm)
> > > > > > > +{
> > > > > > > +     int i;
> > > > > > > +     u32 id;
> > > > > > > +     const struct sys_reg_desc *rd;
> > > > > > > +     u64 val;
> > > > > > > +
> > > > > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > > > > +             rd = &sys_reg_descs[i];
> > > > > > > +             if (rd->access != access_id_reg)
> > > > > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > > > > +                     continue;
> > > > > > > +
> > > > > > > +             id = reg_to_encoding(rd);
> > > > > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > > > > +                     /* Shouldn't happen */
> > > > > > > +                     continue;
> > > > > > > +
> > > > > > > +             val = read_sanitised_ftr_reg(id);
> > > > > >
> > > > > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > > > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> > > > >
> > > > > I'm not sure if I understand your question.
> > > > > arm64_ftr_bits_kvm is used for feature support checkings when
> > > > > userspace tries to modify a value of ID registers.
> > > > > With this patch, KVM just saves the sanitized values in the kvm's
> > > > > buffer, but userspace is still not allowed to modify values of ID
> > > > > registers yet.
> > > > > I hope it answers your question.
> > > >
> > > > Based on the previous commit I was assuming that some registers, like
> > > > id_aa64dfr0,
> > > > would default to the overwritten values as the sanitized values. More
> > > > specifically: if
> > > > userspace doesn't modify any ID reg, shouldn't the defaults have the
> > > > KVM overwritten
> > > > values (arm64_ftr_bits_kvm)?
> > >
> > > arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
> > > and arm64_ftr_bits_kvm doesn't have the sanitized values.
> > >
> > > Thanks,
> >
> > Hey Reiji,
> >
> > Sorry, I wasn't very clear. This is what I meant.
> >
> > If I set DEBUGVER to 0x5 (w/ FTR_EXACT) using this patch on top of the
> > series:
> >
> >  static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
> >         S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
> > -       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
> > +       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x5),
> >
> > it means that userspace would not be able to set DEBUGVER to anything
> > but 0x5. But I'm not sure what it should mean for the default KVM value
> > of DEBUGVER, specifically the value calculated in set_default_id_regs().
> > As it is, KVM is still setting the guest-visible value to 0x6, and my
> > "desire" to only allow booting VMs with DEBUGVER=0x5 is being ignored: I
> > booted a VM and the DEBUGVER value from inside is still 0x6. I was
> > expecting it to not boot, or to show a warning.
>
> Thank you for the explanation!
> 
> FTR_EXACT (in the existing code) means that the safe_val should be
> used if values of the field are not identical between CPUs (see how
> update_cpu_ftr_reg() uses arm64_ftr_safe_value()). For KVM usage,
> it means that if the field value for a vCPU is different from the one
> for the host's sanitized value, only the safe_val can be used safely
> for the guest (purely in terms of CPU feature).

Let me double check my understanding using the DEBUGVER example, please.
The safe_value would be DEBUGVER=5, and it contradicts the initial VM
value calculated on the KVM side. Q1: Can a contradiction like this
occur in practice? Q2: If the user saves and restores this id-reg on the
same kernel, the AA64DFR0 userspace write would fail (ftr_val !=
arm64_ftr_safe_value), right?

> 
> If KVM wants to restrict some features due to some reasons (e.g.
> a feature for guests is not supported by the KVM yet), it should
> be done by KVM (not by cpufeature.c), and  'validate' function in
> "struct id_reg_info", which is introduced in patch-3, will be used
> for such cases (the following patches actually use).
> 

Got it, thanks.

> Thanks,
> Reiji
> 

Thanks,
Ricardo

> >
> > I think this has some implications for migrations. It would not be
> > possible to migrate the example VM on the patched kernel from above: you
> > can boot a VM with DEBUGVER=0x5 but you can't migrate it.
> >
> > Thanks,
> > Ricardo
