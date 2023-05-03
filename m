Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1207F6F6219
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjECXg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjECXg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:36:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1415B8A7F
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 16:36:27 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1aad9af33c1so50738345ad.0
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 16:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683156986; x=1685748986;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q9mEWPWA1iI/rYL0y1HPlTVhIhm95z6cjH/y0hoTaqg=;
        b=wUb7IbssoYndItbXp8gpboW9GFI801NWVENDT8j51Ih3hriK9JhOHfGutpq6JmnOAu
         D+zBIEk+aHFfyVzYtCajgvKXJVXLRvigPszrwQxbgt5YFzjMY5gRfZmgP2e/d4aN8KBH
         z8jVnGdFco1eRz5jPXKnIFd/FkL//vx49gdaH6/KJYSskqD0hRgnhfD0AIN+Y6GQui7l
         0I2Pu26E7d+SkdaOVmz/9DxhTKv/GNLEMr0OoDEWXc5KkcJVeKu46X1bf4+MmDwRm+PC
         agtVQCjtMbbljjZ5Qho5AwNloO3qQRvh2S9T7rj6YFVbvBTJ2mG81toonnji8B1+eHIt
         rMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683156986; x=1685748986;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q9mEWPWA1iI/rYL0y1HPlTVhIhm95z6cjH/y0hoTaqg=;
        b=lgKTW1y/bFc0IjyyKH5Y7FhRK7NjqRyUl3qPvyqjOiko028zkyJQpQkkCett4o96ZX
         n0NVOVnx8gPCxkZwqhPpnBVkbgK6pjMluaYMIdXVfnDx+NG75Cj7/wJ8Eb3ra6KFViHy
         tQOizd47YhtrMWxZYAG2Knq1LlMCP8b3nJVfCARE+33N9y4MmwmZJ8hEUzCPKR/uInar
         lBbzbYKyx7klYhuJBYD565pAKaXAPwM0e+CBRwqfySVr1du4MVjNdpQDeUOTPzvAlk+i
         oxXjWar2cPRoJBlcyz9bnY/VyOy/JkM6C+9gFd6rovWiiF9y24ymXu4A7V4EXmwmraqO
         s6Ew==
X-Gm-Message-State: AC+VfDwLAXB+WDmpY8HBiYSGkzo7HwtZEUpdWZHU4brbQqLLSfZF7avA
        nWfZZ43082ZeDsIQyVvuc8YVGY0l48g=
X-Google-Smtp-Source: ACHHUZ6bpFgqKP8DmusRGoqQ/JY1CdVnYinKoKMaVy661K58PrbU+h9rzfrKBHrVs4+zHpdNCvCm+rjjnVs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bc8b:b0:1a5:819:61f0 with SMTP id
 bb11-20020a170902bc8b00b001a5081961f0mr517798plb.3.1683156986655; Wed, 03 May
 2023 16:36:26 -0700 (PDT)
Date:   Wed, 3 May 2023 23:36:25 +0000
In-Reply-To: <b57efeeb80319183e93d5a10bc8a812ff891bd53.camel@intel.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com> <20230503182852.3431281-4-seanjc@google.com>
 <b57efeeb80319183e93d5a10bc8a812ff891bd53.camel@intel.com>
Message-ID: <ZFLvytrl+Lj+mC4L@google.com>
Subject: Re: [PATCH 3/5] KVM: x86: Use MTRR macros to define possible MTRR MSR ranges
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023, Huang, Kai wrote:
> On Wed, 2023-05-03 at 11:28 -0700, Sean Christopherson wrote:
> > Use the MTRR macros to identify the ranges of possible MTRR MSRs instea=
d
> > of bounding the ranges with a mismash of open coded values and unrelate=
d
> > MSR indices.  Carving out the gap for the machine check MSRs in particu=
lar
> > is confusing, as it's easy to incorrectly think the case statement hand=
les
> > MCE MSRs instead of skipping them.
> >=20
> > Drop the range-based funneling of MSRs between the end of the MCE MSRs
> > and MTRR_DEF_TYPE, i.e. 0x2A0-0x2FF, and instead handle MTTR_DEF_TYPE a=
s
> > the one-off case that it is.
> >=20
> > Extract PAT (0x277) as well in anticipation of dropping PAT "handling"
> > from the MTRR code.
> >=20
> > Keep the range-based handling for the variable+fixed MTRRs even though
> > capturing unknown MSRs 0x214-0x24F is arguably "wrong".  There is a gap=
 in
> > the fixed MTRRs, 0x260-0x267, i.e. the MTRR code needs to filter out
> > unknown MSRs anyways,=EF=BF=BD
> >=20
>=20
> Looks a little bit half measure, but ...

Yeah, I don't love it, but I couldn't convince myself that precisely identi=
fying
known MTRRs was worth the extra effort.

> > and using a single range generates marginally better
> > code for the big switch statement.
>=20
> could you educate why because I am ignorant of compiler behaviour? :)

Capturing the entire range instead of filtering out the gaps allows the com=
piler
to handle multiple MSRs with fewer CMP+Jcc checks.

E.g. think of it like this (I actually missed a gap)

	if (msr >=3D 0x200 && msr <=3D 0x26f)

versus

	if ((msr >=3D 0x200 && msr <=3D 0x213) || (msr =3D=3D 0x250) || (msr =3D=
=3D 0x258) ||
	    (msr =3D=3D 0x259) || (msr >=3D 0x268 && msr <=3D 0x26f))

Nothing enormous, and it's not like non-fastpath WRMSR is performance criti=
cal,
but add in the extra code for precisely capturing the MTRRs in both x86.c _=
and_
mtrr.c, and IMO it's worth being imprecise.
