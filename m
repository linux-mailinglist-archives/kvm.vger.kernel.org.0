Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCE44F2147
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 06:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiDEClu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 22:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiDECln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 22:41:43 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF87C9B7C
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 18:46:52 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n18so9651234plg.5
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 18:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5/ENKPwEE0XsowuVbAwYwEQbZbBA4Wrsv1B56cUOhLw=;
        b=nsiMnTnbPhcHABw79aFqyBZ52gouWySQb6b1zd/6RuyHX6qu73aXxT51uGKKKoUFCq
         j0Ntp5j3lq7wl3WQLkxUzU4TP7IL1XWp62PZglt+kE30WJI06gMGKc3zXkHK4pUvQhX5
         FeNlAj47ZRvz7WWAzc21LhNTm/3Of2xMjtdLDhYJ0a7+Kg4y3UAZuxhLbCioOhPCCIDk
         ve6CW64McuhYSy5w9e1MKsGtIntlS2YUZmSSgvEjW5lrERmRgcXps9QhsQqCUzNp2TBB
         X2O+F7cDoZ4QCAf9UpkfOXMlxzobrkpcdzd2kwwZdkCGR57Ob40eopdLwj65gtU4QehD
         SNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5/ENKPwEE0XsowuVbAwYwEQbZbBA4Wrsv1B56cUOhLw=;
        b=iegfdDmUG7HzkNQwbB5X1cNxLBkEyR67h5ZXUkHkRQ/acUFeZA9zt4Cj5YM3cuLCJ7
         vH/NJ4ph1FtQGxRg8JSgHxup1b06jJDJAlaJQ2/31gwn7hhRtil+olZbYHRq8y/EjlxA
         id/x5OmG06fc1gxGXlQ/od3Gd3dZ2f+OVqlQa1CRGbctjY9wbV6HdoLU8wPJcWlABMCO
         BwITGqXgouvlDA2GQ6Oeh2QFQVtPZzXl2zDaJBNb7moBjMgx4TI2Nj3YZShfYLrzArcJ
         2U4EzbyLZl26Qh4nQr5i2LivXvHyjYYRuWrngur5QFY4JCZF6eAmX9/cdc1MEG7LGeGc
         UfAg==
X-Gm-Message-State: AOAM5309ljbQm7ytMpsXe4AE2Q1XMK/ke9dM/lEshByLyCeoeK8fm3g1
        9ChvYFijwk0YLFcj8faR0swe6RqzghmwHPlqNf3cdQ==
X-Google-Smtp-Source: ABdhPJwZdAVxNvvwelmoX0UfJB9QP/f71rA9aZ2+c9FFogDIIiR3+0GsySURpnJyc8i+/2rzWVAUXFRGTR5VQN4zqG8=
X-Received: by 2002:a17:90a:b903:b0:1ca:be37:1d41 with SMTP id
 p3-20020a17090ab90300b001cabe371d41mr1258623pjr.9.1649123211375; Mon, 04 Apr
 2022 18:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com> <20220401010832.3425787-3-oupton@google.com>
 <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
 <YkqCAcPCnqYofspa@google.com> <Ykt8/Q5LLpZdgLu5@google.com>
In-Reply-To: <Ykt8/Q5LLpZdgLu5@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 4 Apr 2022 18:46:35 -0700
Message-ID: <CAAeT=Fx=aFF6h-iYeW3NLiba_uStO72jL6eQYNjyx8B6a2OLOQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the
 AArch64 sysreg handler
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

Hi Oliver,

On Mon, Apr 4, 2022 at 4:19 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, Apr 04, 2022 at 05:28:33AM +0000, Oliver Upton wrote:
> > Hi Reiji,
> >
> > On Sun, Apr 03, 2022 at 08:57:47PM -0700, Reiji Watanabe wrote:
> > > > +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > > > +       u32 esr = kvm_vcpu_get_esr(vcpu);
> > > > +       struct sys_reg_params params;
> > > > +       int ret;
> > > > +
> > > > +       /* UNDEF on any unhandled register or an attempted write */
> > > > +       if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
> > > > +               kvm_inject_undefined(vcpu);
> > >
> > > Nit: For debugging, it might be more useful to use unhandled_cp_access()
> > > (, which needs to be changed to support ESR_ELx_EC_CP10_ID though)
> > > rather than directly calling kvm_inject_undefined().
> >
> > A very worthy nit, you spotted my laziness in shunting straight to
> > kvm_inject_undefined() :)
> >
> > Thinking about this a bit more deeply, this code should be dead. The
> > only time either of these conditions would happen is on a broken
> > implementation. Probably should still handle it gracefully in case the
> > CP10 handling in KVM becomes (or is in my own patch!) busted.
>
> Actually, on second thought: any objections to leaving this as-is?
> kvm_esr_cp10_id_to_sys64() spits out sys_reg_params that point at the
> MRS alias for the VMRS register. Even if that call succeeds, the params
> that get printed out by unhandled_cp_access() do not match the actual
> register the guest was accessing. And if the call fails, ->Op2 is
> uninitialized.

I understand a few additional changes are needed for this.
Or simply use WARN_ON_ONCE ? (since this cannot be created by
the guest but by a KVM or CPU problem)

I'm fine with the current code as-is though:)

Thanks,
Reiji
