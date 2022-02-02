Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B284A6BE0
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 07:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244834AbiBBGwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 01:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244726AbiBBGwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 01:52:37 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AB1C06177A
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 22:46:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so5870495pjt.5
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 22:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n4I2R/hpf5Fa4L81XJ6bvxceN9VV7gkH/UQIc45psZ4=;
        b=tIMuSrNzRH+KWp61Vo/OMMvaDkFTGOZvrsS0v4SKqfShDl+PQ3OrxwXGO10cig7KH0
         brcJBL/bKE0lhbtp/HBpjl8yUDAZIr+3+OAp3aHtGlVyz8pl2ZDkN2dD93zpt/5KHz02
         0E/PovCbpnSEtik2Y/iWeVjuCFFXvfJs8Vwshd3VGIeFzjV1j3CLTqG67f4uqtl0i2ka
         ifuPeeci4ApuXeShICr+eGBiR+8gyLw5sre/ZFpDIg5UlGuKCxhjyTzyD36/s2RrvTX3
         LuNCPHae9QrMzdR+0IJY5XUrXrrXz70jc5K8PUm3ajXy5lZj7CEpMJ+5hqPJptRHP17l
         4N7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n4I2R/hpf5Fa4L81XJ6bvxceN9VV7gkH/UQIc45psZ4=;
        b=0+UihHbVQkkbSaXc8z/bkG0dLSuSBSxoy9pHofdhVHM2lJbQfi75yhgiUTnof44uqY
         rYv3WWzuJ+YUBSbcFkUPtRXok6uM5RXXQvze+yg3ZMp8c/PGINFer/X1K8rBHnd1VPHk
         GGenFLhMXNT8D46kYRyvAiqoeRhY/wsq+NEZKk1JoYpiCTdIvqFEZQBJSR/W12gGXsyt
         Y7xIfrTK3gn5cmH6lnW7RVeDE2FOI1Qk2BAYlnKVxedRSW4MEghDDtK81UJ2BQxmKblN
         GQviW15lCXJNJFq6hmyGXlweAMptEH1RfVSmktS1CRQ1BXF+7LC/iERp8mS1JrGbJLz4
         zn5Q==
X-Gm-Message-State: AOAM5301GdwMqQYidh2Y1I2wq8eMeMOTOTyarLCQohuEKNbAWM7pkB5l
        S+tJT+xL+pTpTESUmul8azo0s9VdLgQH9tSsnCuYEg==
X-Google-Smtp-Source: ABdhPJxoAC726UM4u8e1ITpNdSeFTzBmsKFwQ8RsnfrQGMs41DYzrOEDXws/ljWMGL4oA33Cq0yVqGM2HhAprUNIMQw=
X-Received: by 2002:a17:902:b684:: with SMTP id c4mr1249326pls.122.1643784391037;
 Tue, 01 Feb 2022 22:46:31 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-2-reijiw@google.com>
 <CA+EHjTx+b0ZVw30riW4OUVP4BCPeJZe+gr5_ycHkPbwU=y7sqA@mail.gmail.com>
 <CAAeT=Fy8AXaM1SGs1wRssTZ9QW9bH-d1d_sCdSrC7EitZLPKBw@mail.gmail.com> <CA+EHjTwRiNpGq=i8LyuH4M3kCdTHFQKALXWNJcTZ+J5SQD87Wg@mail.gmail.com>
In-Reply-To: <CA+EHjTwRiNpGq=i8LyuH4M3kCdTHFQKALXWNJcTZ+J5SQD87Wg@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 1 Feb 2022 22:46:14 -0800
Message-ID: <CAAeT=FzDVbLsCdshTP+jszn_E_CqK3fN0V5bXeozf98abCdTZg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 01/26] KVM: arm64: Introduce a validation function
 for an ID register
To:     Fuad Tabba <tabba@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fuad,

On Tue, Feb 1, 2022 at 6:14 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> ...
>
> > > Could you please explain using ftr_temp[] and changing the value in
> > > arm64_ftr_bits_kvm_override, rather than just
> > > arm64_ftr_reg_bits_overrite(bits->ftr_bits, o_bits->ftr_bits)?
> >
> > I would like to maintain the order of the entries in the original
> > ftr_bits so that (future) functions that work for the original ones
> > also work for the KVM's.
> > The copy and override is an easy way to do that.  The same thing can
> > be done without ftr_temp[], but it would look a bit tricky.
> >
> > If we assume the order shouldn't matter or entries in ftr_bits
> > are always in descending order, just changing the value in
> > arm64_ftr_bits_kvm_override would be a much simpler way though.
>
> Could you please add a comment in that case? I did find it to be
> confusing until I read your explanation here.

Yes, I will add a comment for it.

>
> >
> > >
> > >
> > > > +static const struct arm64_ftr_bits *get_arm64_ftr_bits_kvm(u32 sys_id)
> > > > +{
> > > > +       const struct __ftr_reg_bits_entry *ret;
> > > > +       int err;
> > > > +
> > > > +       if (!arm64_ftr_bits_kvm) {
> > > > +               /* arm64_ftr_bits_kvm is not initialized yet. */
> > > > +               err = init_arm64_ftr_bits_kvm();
> > >
> > > Rather than doing this check, can we just initialize it earlier, maybe
> > > (indirectly) via kvm_arch_init_vm() or around the same time?
> >
> > Thank you for the comment.
> > I will consider when it should be initialized.
> > ( perhaps even earlier than kvm_arch_init_vm())
> >
> > >
> > >
> > > > +               if (err)
> > > > +                       return NULL;
> > > > +       }
> > > > +
> > > > +       ret = bsearch((const void *)(unsigned long)sys_id,
> > > > +                     arm64_ftr_bits_kvm,
> > > > +                     arm64_ftr_bits_kvm_nentries,
> > > > +                     sizeof(arm64_ftr_bits_kvm[0]),
> > > > +                     search_cmp_ftr_reg_bits);
> > > > +       if (ret)
> > > > +               return ret->ftr_bits;
> > > > +
> > > > +       return NULL;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Check if features (or levels of features) that are indicated in the ID
> > > > + * register value @val are also indicated in @limit.
> > > > + * This function is for KVM to check if features that are indicated in @val,
> > > > + * which will be used as the ID register value for its guest, are supported
> > > > + * on the host.
> > > > + * For AA64MMFR0_EL1.TGranX_2 fields, which don't follow the standard ID
> > > > + * scheme, the function checks if values of the fields in @val are the same
> > > > + * as the ones in @limit.
> > > > + */
> > > > +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> > > > +{
> > > > +       const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);
> > > > +       u64 exposed_mask = 0;
> > > > +
> > > > +       if (!ftrp)
> > > > +               return -ENOENT;
> > > > +
> > > > +       for (; ftrp->width; ftrp++) {
> > > > +               s64 ftr_val = arm64_ftr_value(ftrp, val);
> > > > +               s64 ftr_lim = arm64_ftr_value(ftrp, limit);
> > > > +
> > > > +               exposed_mask |= arm64_ftr_mask(ftrp);
> > > > +
> > > > +               if (ftr_val == ftr_lim)
> > > > +                       continue;
> > >
> > > At first I thought that this check isn't necessary, it should be
> > > covered by the check below (arm64_ftr_safe_value. However, I think
> > > that it's needed for the FTR_HIGHER_OR_ZERO_SAFE case. If my
> > > understanding is correct, it might be worth adding a comment, or even
> > > encapsulating this logic in a arm64_is_safe_value() function for
> > > clarity.
> >
> > In my understanding, arm64_ftr_safe_value() provides a safe value
> > when two values are different, and I think there is nothing special
> > about the usage of this function (This is actually how the function
> > is used by update_cpu_ftr_reg()).
> > Without the check, it won't work for FTR_EXACT, but there might be
> > more in the future.
> >
> > Perhaps it might be more straightforward to add the equality check
> > into arm64_ftr_safe_value() ?
>
> I don't think this would work for all callers of
> arm64_ftr_safe_value(). The thing is arm64_ftr_safe_value() doesn't
> check whether the value is safe, but it returns the safe value that
> supports the highest feature. Whereas arm64_check_features() on the
> other hand is trying to determine whether a value is safe.
>
> If you move the equality check there it would work for
> arm64_check_features(), but I am not convinced it wouldn't change the
> behavior for init_cpu_ftr_reg() in the case of FTR_EXACT, unless this
> never applies to override->val. What do you think?

The equality check (simply returns the new value if new == cur) could
change a return value of arm64_ftr_safe_value only if ftr_ovr == ftr_new
for FTR_EXACT case.  For init_cpu_ftr_reg, since ftr_ovr value doesn't
matter if ftr_ovr == ftr_new, I would think the override behavior itself
stays the same although the message that will be printed by
init_cpu_ftr_reg() will change ("ignoring override" => "already set").

Having said that, since the change (having arm64_ftr_safe_value does
the equality check) isn't necessary, either way is fine, and
I can keep the current implementation of arm64_ftr_safe_value().

Thanks,
Reiji


>
> Thanks,
> /fuad
>
>
> > >
> > > > +
> > > > +               if (ftr_val != arm64_ftr_safe_value(ftrp, ftr_val, ftr_lim))
> > > > +                       return -E2BIG;
> > > > +       }
> > > > +
> > > > +       /* Make sure that no unrecognized fields are set in @val. */
> > > > +       if (val & ~exposed_mask)
> > > > +               return -E2BIG;
> > > > +
> > > > +       return 0;
> > > > +}
> >
> > Thanks,
> > Reiji
