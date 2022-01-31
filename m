Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531A84A3CBE
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 04:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357504AbiAaDke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jan 2022 22:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiAaDkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jan 2022 22:40:31 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7FCC061714
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 19:40:31 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t32so11060755pgm.7
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 19:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kKkdVczReHlJmEq2mHCzOlF2f9zOsI8Qlek1CLGRtXg=;
        b=gv2/52IHXhxJ9V+CpUkuE8dj13TXoUzbfqNmRA89Z8RxAggQ29fLbrg/TdohGYCGSN
         epfA+Wly5u0v1Nx+89fgyFvCuAxqUB1+uAfDYmOdC9BofPSGSqFqKnpQACBXfQlOKKsM
         +2eRoGjDdz7lRlO+Bp8JWFrK6/khewbv7ZCqyl2edW/X3iTiLFoAruAsFfZ3PcQNyH0Z
         wr9saZ31sYhvjT2tG2f/gMzb2jo+TJ2r82NuCxKfFVUv0uxjTV8Pjvml3lgYvje/3qjK
         VWrOQqtFQcpjE+Nei63rhSfgH9jC52UKbOzVjej4FYqNmJEGPiwpu7GUUfoHFjwjD0lQ
         S11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kKkdVczReHlJmEq2mHCzOlF2f9zOsI8Qlek1CLGRtXg=;
        b=Wzrw0m5qPkgmr7Q0Xz7wfyZVy/Sl2CATPpzf6Xg+vqJG2/VY/DJ8BSbQEsqGQxa50J
         QdpEqb91tBiyd+aLHOX1WwCR8YYYFWKPFxmzPePdyAfppjjCfSe+1frBmRQxc8el03xH
         RlWoe4RO8/8lOgMHwsgHHJ90+LzOVZMCH0fvuhhDYnbPuZ7/1gvZDnoXcPzaBAJo4sBN
         wVQoF6npZvNkH4VMR4HnPOf5HlnIXOW9MBwZr5t7/GdM/P/X+9r+mGtRx5EGPdnwgZuB
         MngWl3r6UuAyLa1fvgbpjwDs09Z/pQG8cBV3dlveyqhG/QpJnAdYuuNo7xr6gt/UL/6a
         RzPw==
X-Gm-Message-State: AOAM533wRCKMME5WfPtu2TVIlNk9pGKFNW3bjrNoSQ1uhCwRDpT/XwWD
        1erpfL+grGpVCI2/Tiw0eu4EQA==
X-Google-Smtp-Source: ABdhPJw80u0ql8gqDhxSKNzAHP5XbIa8eMWvNhJoZHnaH+q7E1P+ygb864/BAuMsFe+9AhCI1lRiGA==
X-Received: by 2002:a05:6a00:1a86:: with SMTP id e6mr18886798pfv.2.1643600430510;
        Sun, 30 Jan 2022 19:40:30 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id y15sm16663120pfi.87.2022.01.30.19.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 19:40:29 -0800 (PST)
Date:   Sun, 30 Jan 2022 19:40:26 -0800
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
Message-ID: <YfdaKpBqFkULxgX/@google.com>
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com>
 <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
 <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022 at 09:52:21PM -0800, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> > > > > +
> > > > > +/*
> > > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > > + */
> > > > > +void set_default_id_regs(struct kvm *kvm)
> > > > > +{
> > > > > +     int i;
> > > > > +     u32 id;
> > > > > +     const struct sys_reg_desc *rd;
> > > > > +     u64 val;
> > > > > +
> > > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > > +             rd = &sys_reg_descs[i];
> > > > > +             if (rd->access != access_id_reg)
> > > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > > +                     continue;
> > > > > +
> > > > > +             id = reg_to_encoding(rd);
> > > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > > +                     /* Shouldn't happen */
> > > > > +                     continue;
> > > > > +
> > > > > +             val = read_sanitised_ftr_reg(id);
> > > >
> > > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> > >
> > > I'm not sure if I understand your question.
> > > arm64_ftr_bits_kvm is used for feature support checkings when
> > > userspace tries to modify a value of ID registers.
> > > With this patch, KVM just saves the sanitized values in the kvm's
> > > buffer, but userspace is still not allowed to modify values of ID
> > > registers yet.
> > > I hope it answers your question.
> >
> > Based on the previous commit I was assuming that some registers, like
> > id_aa64dfr0,
> > would default to the overwritten values as the sanitized values. More
> > specifically: if
> > userspace doesn't modify any ID reg, shouldn't the defaults have the
> > KVM overwritten
> > values (arm64_ftr_bits_kvm)?
> 
> arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
> and arm64_ftr_bits_kvm doesn't have the sanitized values.
> 
> Thanks,

Hey Reiji,

Sorry, I wasn't very clear. This is what I meant.

If I set DEBUGVER to 0x5 (w/ FTR_EXACT) using this patch on top of the
series:

 static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
        S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
-       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
+       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x5),

it means that userspace would not be able to set DEBUGVER to anything
but 0x5. But I'm not sure what it should mean for the default KVM value
of DEBUGVER, specifically the value calculated in set_default_id_regs().
As it is, KVM is still setting the guest-visible value to 0x6, and my
"desire" to only allow booting VMs with DEBUGVER=0x5 is being ignored: I
booted a VM and the DEBUGVER value from inside is still 0x6. I was
expecting it to not boot, or to show a warning.

I think this has some implications for migrations. It would not be
possible to migrate the example VM on the patched kernel from above: you
can boot a VM with DEBUGVER=0x5 but you can't migrate it.

Thanks,
Ricardo
