Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BD450956B
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 05:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383952AbiDUDeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 23:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383951AbiDUDeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 23:34:20 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44CC641A
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 20:31:31 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w1so6385280lfa.4
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 20:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWdUpnsb47o1FNM4DoFpuEPQUv5HBP0fq0XE67umR3Y=;
        b=Em7H+xBAsQLN4Gfkl0tOWFxTWA6mp3EJVkxmQrtP7FkeppyKVEhkOkbeDkfOJnIK6e
         4GzQiMgAJRysMw6qNPLW2RQ4BeQcSzeHannnjEvhUUlSea8L/xq6lL84CDPqelwEC66/
         DjpoRulaMnTXmCkyRprav16+4wsDsMY//k2DxY03iB/h550gC8zPbKV8LjoCIo1Xi5s1
         ny0TjWryT9M3G8tYAdPC4Mc4hYySvojuaGF6RUhoe/r0qeVx/o4fLJhE4rRz5szl6b/3
         IMzexZ8YSnVyIih1HgYxFSqH+5p7csAdXh9f2Ig63ym8CG7j9xbBciEtcAMfu5ib1ubL
         qa+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWdUpnsb47o1FNM4DoFpuEPQUv5HBP0fq0XE67umR3Y=;
        b=IsD4X7dIAA0GhZYHisBWp2kdMgWMcllbeZF/lqlUsILyb2Oq94CKW7qN+5ZcMFiAxr
         3P6SYert6PIkpYqy/0cCibdE2I9QsRFfXQ73yNPl1Me1AfsOtkw8qJbOAR2KYYR6ms0J
         ZUPORvjLjdHg5PpWVW2oGLM5GeHDlgHVStRnwdNJFWC9y6IulVyHp/BR83qYO3unmBFp
         fBxBlQPp4C/C5UZHw+V2OKZuPeOqRn1wEygiAudsyTmPXROLvE21/ltuLCZrhWJTxHuk
         SvzWJN9yVRoBkdUyPjuESAFvgSvxj92HrXTGCSSKncVSxBl6bs4CidM//dmkSLVzMTLo
         cAeQ==
X-Gm-Message-State: AOAM532uRnyti+sZR+hhFG/gGBzb95258CMnp4e++FCoXnXWWGhHhNiv
        pb//u1xpWHGYN55zAVhKN+vvM7X/XJM7ODTG3wLQZAoQgwc=
X-Google-Smtp-Source: ABdhPJx6nIHUt1znd18RCHDSGPMHuur2dCYr/WggeHytHt7gs5Kiuo7HWarJ3QIphs0ibhh1V0k2ShQlVVJDHLWEv84=
X-Received: by 2002:a05:6512:3b9b:b0:471:8e54:2ecf with SMTP id
 g27-20020a0565123b9b00b004718e542ecfmr12971220lfv.286.1650511889850; Wed, 20
 Apr 2022 20:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com> <20220409184549.1681189-4-oupton@google.com>
 <CAAeT=FxQ5qBMrYZpGbDT7i+bGFCyfoV32ddKeeprj7mEemnbEA@mail.gmail.com>
In-Reply-To: <CAAeT=FxQ5qBMrYZpGbDT7i+bGFCyfoV32ddKeeprj7mEemnbEA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 20 Apr 2022 20:31:18 -0700
Message-ID: <CAOQ_QsjzfWH=UV0hemGt5jeSrYrpzzcVLVPdOBe7LV__RkDT+Q@mail.gmail.com>
Subject: Re: [PATCH v5 03/13] KVM: arm64: Track vCPU power state using MP
 state values
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

Sorry for the late reply.

On Wed, Apr 13, 2022 at 10:26 PM Reiji Watanabe <reijiw@google.com> wrote:

[...]

> > @@ -457,7 +459,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >
> >         switch (mp_state->mp_state) {
> >         case KVM_MP_STATE_RUNNABLE:
> > -               vcpu->arch.power_off = false;
> > +               vcpu->arch.mp_state = *mp_state;
>
> Nit: It might be a bit odd that KVM_MP_STATE_STOPPED case only copies
> the 'mp_state' field of kvm_mp_state from userspace (that's not a 'copy'
> operation though), while KVM_MP_STATE_RUNNABLE case copies entire
> kvm_mp_state from user space.
> ('mp_state' is the only field of kvm_mp_state though)

I tried my best to leave this all as-is. I hinted at it in another
thread, but I really do think a refactoring would be good to make ARM
actually use the mp_state value instead of relying on vCPU requests. I
completely agree with the nit, but think it might be better to
collapse all of the weirdness around mp_state in a separate
patch/series which will drag the vCPU run loop along.

> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Much appreciated :)

--
Best,
Oliver
