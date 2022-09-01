Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A105D5A8CFE
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 06:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiIAE5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 00:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiIAE5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 00:57:52 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586C2114C6A
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 21:57:51 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id 190so16608833vsz.7
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 21:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=B8g7g91aP9xKSAm6D4rDZLFf8Csm7hufubO+9r3JISE=;
        b=lR76BHAsKGqCqMAip83JIRKcbQrOqP4WBI3OO2OIUEhzs6mqBVrr0ya265N0efAC0J
         Tg3Ku1w8X8Q2kxcqD4PjQpW+GehgIpRt4244KMkt+q8ulVShTe12Pq7HfO0WRCQpWd+i
         ml6RZb/mry+f4xONOSFDMJGLCRDpEiiFFXlJZWU2Q3g7VdUpc22vXBaqp/cEmBiSS5LL
         KvXUJ5QbxbU9f4bd7oB+n3R7Vq3pvXnrXCxB7sFIXoBz1jZSTaJkPFZbZwmIG8cQ67Jx
         zSbEJHu39pttOE0iA7SLzuvqkCIS+GcOpKFIfDt2Dmc0jkQwC17aBZdKFECoGt+uAuHx
         x9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=B8g7g91aP9xKSAm6D4rDZLFf8Csm7hufubO+9r3JISE=;
        b=jyevZkfuCdLlsGHKmD8c7H4+Hx5dmxrWKWbF/LNXji2UwsxQEdaMusPVwSFMz5uyFd
         hm5ioZTl4Gs+1RZ5KZ3YyQ/Cx4phzVqQks5reUQnzsCW+TCHaaD1H4E/JAZM1XUSVaUA
         kOQHoZtFNOy4C8Sqg8UxsqTLH81ljM/j2PUA1ejvtQ6dflco9X7RS4u5fE2xU1WMO/Ls
         v56W9Six+sIslIfW2d36Qyw6BAQz0VjYTQMz2M/MP2bqZ9BzF4wQPg9lFGsrVRPYgO9r
         HTZyPQVuw1u9qvCvih84Ex7zLXIF1ODfywqG8lyUba7S9Nwy/L9k4NEEdy2lrKlGCojE
         4ExQ==
X-Gm-Message-State: ACgBeo1FYDXbtKSwVx12J81y1OZrW6TwdSRSs9J5sMw7cwJZXfRJcLak
        3MwMsRkjZpiLls48pYmZxtswSM1RqDiuHMVp3/2Sdw==
X-Google-Smtp-Source: AA6agR7b1cPfhtU9ZPhbpcg9h3wsuJqViFmM9NHos3Zouc5tJCy7g1KD65lghrbB5BHfCwx7uUFsJigcc9iDRwoW6h8=
X-Received: by 2002:a67:b009:0:b0:38a:e0f2:4108 with SMTP id
 z9-20020a67b009000000b0038ae0f24108mr8091964vse.9.1662008270405; Wed, 31 Aug
 2022 21:57:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-5-oliver.upton@linux.dev> <CAAeT=FzQkgf7g3yXP++u_2zio1XL9mRSzPZ6hxmanwVk4QUNbQ@mail.gmail.com>
 <Yw9zQaxuSFlVsf5O@google.com>
In-Reply-To: <Yw9zQaxuSFlVsf5O@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 31 Aug 2022 21:57:34 -0700
Message-ID: <CAAeT=FyjM2n1KL-9JSTfZ=RMDKSfmgN23PCnhBmvVwDz-9ZjXQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: arm64: Add a visibility bit to ignore user writes
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 7:42 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Tue, Aug 30, 2022 at 08:29:37PM -0700, Reiji Watanabe wrote:
> > Hi Oliver,
> >
> > On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > We're about to ignore writes to AArch32 ID registers on AArch64-only
> > > systems. Add a bit to indicate a register is handled as write ignore
> > > when accessed from userspace.
> > >
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 3 +++
> > >  arch/arm64/kvm/sys_regs.h | 7 +++++++
> > >  2 files changed, 10 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 26210f3a0b27..9f06c85f26b8 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1232,6 +1232,9 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >  {
> > >         bool raz = sysreg_visible_as_raz(vcpu, rd);
> > >
> > > +       if (sysreg_user_write_ignore(vcpu, rd))
> > > +               return 0;
> >
> > Since the visibility flags are not ID register specific,
> > have you considered checking REG_USER_WI from kvm_sys_reg_set_user()
> > rather than the ID register specific function ?
>
> Yeah, that's definitely a better place to wire it in.
>
> > This patch made me reconsider my comment for the patch-2.
> > Perhaps it might be more appropriate to check RAZ visibility from
> > kvm_sys_reg_get_user() rather than the ID register specific function ?
>
> REG_RAZ hides the register value from the guest as well as userspace, so it
> might be better to leave it in place. REG_RAZ also has implications for
> writing a register from userspace, as we still apply the expectation of
> invariance to ID registers that set this flag.
>
> It all 'just works' right now with the check buried in the ID register
> accessors. Going the other way around would require sprinkling the check
> in several locations.

Ah, I see the handling of REG_RAZ is a bit tricky...
I kind of suspect that REG_RAZ won't probably be used for any registers
other than ID registers even in the future...

Anyway, yes, it might be better to leave it in place at least for now.

Thank you,
Reiji
