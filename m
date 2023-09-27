Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7107B0508
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 15:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjI0NPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 09:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjI0NPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 09:15:07 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC63126
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 06:15:01 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2bff936e10fso143559891fa.1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 06:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philjordan-eu.20230601.gappssmtp.com; s=20230601; t=1695820499; x=1696425299; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfHtIia8TvUSRs9fX/JN3HAzhknYINPmi4s/e9AkBss=;
        b=3Wg16tlunSDxcYwgydDm6Q+ntJfOp0FT4iDpID0hEhU/Xc23f+25qo1cdhG0Dc0l0e
         yS5iqrPRXsvchPrJ9jctn1rDjHCF+CbqGUZkXbNHxrED6RKulCBOt6ivx+J52UwKBmtn
         /ZytLtzBe3aB8nJFGs6VrJ2/bo6XEJDvgw2grXxI7GbRToF4mTJ0B+yiBktSA4EUE/zP
         w2mxLzImqXBwsewx7yFe6aEcn2QaC8P1zdhAdtDV4gaTDMq2nLkRBb6mN/cAdbR3Fhqd
         ByQ5zRFJPflCOdc9HqFAvdwi/UkuOtRfBZ8+iTXzkPl4XAkWxSfDc2bSoW3/n9HjUBDy
         Yegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695820499; x=1696425299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfHtIia8TvUSRs9fX/JN3HAzhknYINPmi4s/e9AkBss=;
        b=E4TGcvSwKkY4/kccwCii2R8voCv0Ym4j4YymqRfWZTcchCBTMAEhvLa1xudqay9dit
         JSVjnIPkt+Ivf+rSirL3oIUJBy4E/48tnYDz9WOpVsPdL79DF1F6gocyMgt0+fyAT9na
         8LyuuS8E0f+AKBGyDF+q0HxNKKAqwPBQueq1v29DVdxZs59ZZYSqJfNa8xvgQyfCSpvL
         04ff6d3fy9wxpkBcvCcGQrQ+3/vgAzdRbaK84eEJCe8MoV979XEqedyzYt8fjGa9DlPu
         bWh3dvmk2iEdIPgJtXokkS4MiFIZfW/tMwjhBtMG76+AUYiFU2RxfsNsESRnn9U3iuA5
         s7zA==
X-Gm-Message-State: AOJu0YwvQ9CMnshA8xblCcxasIFkERUMTO8xyCQc+opSbJyLJPYXBnbx
        oynfu2MUDxrQ8y7fKSFr2lSuTssMQre2KYNWMLBiyA==
X-Google-Smtp-Source: AGHT+IE0bE7QOCCSF1WSvFO+r5wC/hxIlJA/w7j6+Q97GyHp/Sxp7xrx65KfssDktcn7U4hDLWFTvd79xzAHi7L3uYw=
X-Received: by 2002:a05:651c:3cc:b0:2c1:5607:d5ac with SMTP id
 f12-20020a05651c03cc00b002c15607d5acmr2292057ljp.20.1695820499328; Wed, 27
 Sep 2023 06:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230923102019.29444-1-phil@philjordan.eu> <ZRGkqY+2QQgt2cVq@google.com>
 <CAGCz3vve7RJ+HE8sHOvq1p5-Wc4RpgZwqp0DiCXiSWq0vUpEVw@mail.gmail.com> <ZRMB9HUIBcWWHtwK@google.com>
In-Reply-To: <ZRMB9HUIBcWWHtwK@google.com>
From:   Phil Dennis-Jordan <lists@philjordan.eu>
Date:   Wed, 27 Sep 2023 15:14:48 +0200
Message-ID: <CAGCz3vuieUoD0UombFzxKYygm8uS4Gr=qkUAKR7oR0Tg+mEnYQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Gates test_pv_ipi on KVM cpuid,
 not test device
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 6:08=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> Please keep the mailing list Cc'd so that other can participate in the co=
nversation,
> and so that the mails are archived.

Sorry! I've now enabled reply-to-all by default so I can't forget again.

> > 2. Bring a copy of the necessary KVM uapi header file(s) into the
> > repo, slightly hacked up to cut down on transitive dependencies. It
> > looks like lib/linux/*.h might already be similar instances for other
> > Linux bits. Qemu also does this.
>
> This has my vote, though I'd strongly prefer not to strip out anything un=
less it's
> absolutely necessary to get KUT to compile.  Grabbing entire files should=
 make it
> easier to maintain the copy+pasted code as future updates to re-sync will=
 hopefully
> add just the new features.

Yup, makes sense.

> The attached half-baked patch adds everything except the base "is this KV=
M?"
> check and has only been compile tested on x86, feel free to use it as a s=
tarting
> point (I wanted to get the basic gist compiling to make sure I wasn't lea=
ding you
> completely astray)

The attachment doesn't seem to have made it, would you mind trying
again? Then I'll put together a v2 of the patch based on that.

Thanks,
Phil
