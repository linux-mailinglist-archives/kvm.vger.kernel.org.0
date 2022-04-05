Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5604F2184
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 06:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiDECrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 22:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiDECr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 22:47:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C682ED7B
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 18:53:30 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id kw18so4202249pjb.5
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 18:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s1jP08lvjc+iEpUnhqHS81takUv7ectwk3mZXZaMX7A=;
        b=hKqK2Pm2eE7pi3Ug4MDSplWp6AxG/hOn5Qku1eSKQhG9yDshjLSjZBsk1GryTF+1Ye
         LMX8CJHD2NmLxUjWfI432ZBJm3E8MZAz1B82TFwrvg6H6JZ5SXBqwZyupGGPYmVOm8d7
         orqCrKIGjiH5ewtJlE2rGiQwCxTSLtIXPnF1kNbyl7/gVPSVvPQFAlG6oJHzsi2iXQmr
         iNg/aNvho1x1E9wnQ4GTOxGYdXlWWVbthRX0NHng5F+dYV4m7GFYpWFkeE12KcI+LMy7
         YCITxwMBqEAXS7JbfWHZcHEEyT+/LLTHlCXzri/ju5TTcYmDleiEmRL+QGKc5Kk3NH52
         cHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s1jP08lvjc+iEpUnhqHS81takUv7ectwk3mZXZaMX7A=;
        b=j88R5xcfX0J8MR42ZfaVgfJYFB0MsruJsvG216zNK+p+xqAZXPbqDn/kcQnR+RNuD/
         HSPRkv+47VaxB90CqQ2kN2bHBzq4TZYk7IKCdQeumVPW580afb9YMO0y3HtGsnz+6Di6
         aNP5yMskaE8QlWCCRK5GysrOXzrkPY+DsZsaYHbjK6l9J4l7jx7IB6IRNy4hjOYaUhA8
         ZuFlYw/MTcvQaGs60UpTBsUei5ROp/ZObosIX6fW/E5QQawrNnXBwsppS0rpEBE+2wjX
         WONyIJNFpLGF3BGrMijzxUOxh8pczXt71dYI/9rZBZVU7dytFUPAlJut3hN5wzfuXZmG
         9pFw==
X-Gm-Message-State: AOAM531OwG+LM91YGb7UBl2FrZjanPgO8zXoCbdWwxhqhkpPu6eNE+mM
        0bC4/BiRVieujrAEJaIidNpvsLW58oM9K1QE0lPyPA==
X-Google-Smtp-Source: ABdhPJy3M4KOifOVTacqoNTW1CPwfWP6Y9YsIhhYUubrpWrjIexOpeAwjfsgkWyb/C+hfOn/XAg/ItUHqA6cerQoWLA=
X-Received: by 2002:a17:902:c1ca:b0:156:a187:b7ee with SMTP id
 c10-20020a170902c1ca00b00156a187b7eemr1035059plc.122.1649123610270; Mon, 04
 Apr 2022 18:53:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com> <20220401010832.3425787-4-oupton@google.com>
 <CAAeT=Fz4cB_SoZCMkOp9cEuMbY+M+ieQ6PTBcvCOQRwGkGv9pA@mail.gmail.com> <YkqGP/OaKK7LpKF2@google.com>
In-Reply-To: <YkqGP/OaKK7LpKF2@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 4 Apr 2022 18:53:14 -0700
Message-ID: <CAAeT=FzeV=zL68EjeX0hWfQ5LLBBqoxFdqZXP=VRW5jZ15rc7Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Start trapping ID registers for 32 bit guests
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

On Sun, Apr 3, 2022 at 10:46 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Sun, Apr 03, 2022 at 09:45:15PM -0700, Reiji Watanabe wrote:
> > On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > To date KVM has not trapped ID register accesses from AArch32, meaning
> > > that guests get an unconstrained view of what hardware supports. This
> > > can be a serious problem because we try to base the guest's feature
> > > registers on values that are safe system-wide. Furthermore, KVM does not
> > > implement the latest ISA in the PMU and Debug architecture, so we
> > > constrain these fields to supported values.
> > >
> > > Since KVM now correctly handles CP15 and CP10 register traps, we no
> > > longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
> > > emulate reads with their safe values.
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> >
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> >
> > BTW, due to this, on a system that supports PMUv3, ID_DFR0_E1 value will
> > become 0 for the aarch32 guest without PMUv3. This is the correct behavior,
> > but it affects migration.  I'm not sure how much we should care about
> > migration of the aarch32 guest though (and it will be resolved once ID
> > registers become configurable anyway).
>
> I believe userspace has been accessing the sanitised values of these
> feature registers the entire time, so we should be OK on the UAPI side.

You are right:)
I totally forgot this was just about trapping. Sorry for the noise.

Thanks,
Reiji
