Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F7370FFFF
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 23:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjEXV3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 17:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjEXV3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 17:29:20 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08B1FC
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:29:18 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2533b914d33so701547a91.3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684963758; x=1687555758;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NmXoxiVgRE7SmAinCpL+lNfwn7nPu1XoUg7jzLhb6pk=;
        b=VX+Tx2GTB8aJk7yC/5Q+jNM8QcPoGjvnErCdx5/U1zJTWZOwTFm3QJW4oXcwryuqZ+
         LpzHk/BLzcrtfBl5bs1y9IhZAuppC8LzdHIHVFWjZN2ghDD54bDHM+ZjnSgP0l2nIv+w
         zAJ6aFWJM2TR9cBhuCeMFzk1OgTFswNBnk64UKDxlSZQU545TeG++wgQOqOR391zpFUo
         q5S0NmBWN9ThOh/DIOe1m354+0ia7L6jkxucjgaWX340kLQrOSNwvj+n6jfsQDpzk5rD
         MA+7Zk20yw6aZrVGdEGKFzKL3qkMpt/PNc82S2DxMa1t94K3rGMfc+sUdV7qQs8u6GfT
         wDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684963758; x=1687555758;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NmXoxiVgRE7SmAinCpL+lNfwn7nPu1XoUg7jzLhb6pk=;
        b=f5aC/gtzvMQOCBV/AW3Ur52i+htE1NIvfVttKnHYmIE6yZWFehHS8hoqoVNRuTnvUd
         RL3WAdPhfoqySZ8iPC5bEjMWrZNgzpCBiFe5j0jm1UBsRdV8HOQGX83+ivCoYYnhOoQ4
         5Ja/HB/ZR8/7DxV2AzKmxBLpnIdzUNnisMpWXgLa3g+SA+Y1BqsEcN3xWyhT9PD/uH2R
         NT3nazUbKuVJIRyZua7jIm1f1U6wAl8B6dSYckZnlIxLX88M4BR4RVfAA3kwcETs3Fx7
         6Tvf+vcT0UG5vr8iOM3iMMwU4moANR5ir0TuR272FCTEMR0wh6rAZnS6z4xTa8RTjrZX
         dSxg==
X-Gm-Message-State: AC+VfDyQhMYmP+Zn1qhYoXSXvG17Agj7rlNjFMUc+/nWe5ouIKtxHhKJ
        QSkhOTGxpC5ffS+32iDmp4uam+RN+kA=
X-Google-Smtp-Source: ACHHUZ7DbFecq83fvKDHU9wMBCuDxDf5o6gqzF6LAr/mfcJhV/RSo8MI46phyac1Or5gPRP5WZVXPnGPuKU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1083:b0:24d:f3d9:48b5 with SMTP id
 gj3-20020a17090b108300b0024df3d948b5mr4488024pjb.3.1684963758357; Wed, 24 May
 2023 14:29:18 -0700 (PDT)
Date:   Wed, 24 May 2023 14:29:17 -0700
In-Reply-To: <CALMp9eR_xYapRm=zJ3OdAzBVFjpzeQWYv9nTs1ZstAsugEwWRQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230310105346.12302-1-likexu@tencent.com> <20230310105346.12302-6-likexu@tencent.com>
 <ZC99f+AO1tZguu1I@google.com> <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
 <ZDAvDhV/bpPyt3oX@google.com> <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
 <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com> <ZG52cgmjgaqY8jvq@google.com> <CALMp9eR_xYapRm=zJ3OdAzBVFjpzeQWYv9nTs1ZstAsugEwWRQ@mail.gmail.com>
Message-ID: <ZG6BrSXDnOdDvUZh@google.com>
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        "Tom Lendacky (AMD)" <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023, Jim Mattson wrote:
> On Wed, May 24, 2023 at 1:41=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Apr 26, 2023, Sandipan Das wrote:
> > > Hi Sean, Like,
> > >
> > > On 4/19/2023 7:11 PM, Like Xu wrote:
> > > >> Heh, it's very much explicable, it's just not desirable, and you a=
nd I would argue
> > > >> that it's also incorrect.
> > > >
> > > > This is completely inaccurate from the end guest pmu user's perspec=
tive.
> > > >
> > > > I have a toy that looks like virtio-pmu, through which guest users =
can get hypervisor performance data.
> > > > But the side effect of letting the guest see the VMRUN instruction =
by default is unacceptable, isn't it ?
> > > >
> > > >>
> > > >> AMD folks, are there plans to document this as an erratum?=C3=AF=
=C2=BF=C2=BD I agree with Like that
> > > >> counting VMRUN as a taken branch in guest context is a CPU bug, ev=
en if the behavior
> > > >> is known/expected.
> > > >
> > >
> > > This behaviour is architectural and an erratum will not be issued. Ho=
wever, for clarity, a future
> > > release of the APM will include additional details like the following=
:
> > >
> > >   1) From the perspective of performance monitoring counters, VMRUNs =
are considered as far control
> > >      transfers and VMEXITs as exceptions.
> > >
> > >   2) When the performance monitoring counters are set up to count eve=
nts only in certain modes
> > >      through the "OsUserMode" and "HostGuestOnly" bits, instructions =
and events that change the
> > >      mode are counted in the target mode. For example, a SYSCALL from=
 CPL 3 to CPL 0 with a
> > >      counter set to count retired instructions with USR=3D1 and OS=3D=
0 will not cause an increment of
> > >      the counter. However, the SYSRET back from CPL 0 to CPL 3 will c=
ause an increment of the
> > >      counter and the total count will end up correct. Similarly, when=
 counting PMCx0C6 (retired
> > >      far control transfers, including exceptions and interrupts) with=
 Guest=3D1 and Host=3D0, a VMRUN
> > >      instruction will cause an increment of the counter. However, the=
 subsequent VMEXIT that occurs,
> > >      since the target is in the host, will not cause an increment of =
the counter and so the total
> > >      count will end up correct.
> >
> > The count from the guest's perspective does not "end up correct".  Unli=
ke SYSCALL,
> > where _userspace_ deliberately and synchronously executes a branch inst=
ruction,
> > VMEXIT and VMRUN are supposed to be transparent to the guest and can be=
 completely
> > asynchronous with respect to guest code execution, e.g. if the host is =
spamming
> > IRQs, the guest will see a potentially large number of bogus (from it's=
 perspective)
> > branches retired.
>=20
> The reverse problem occurs when a PMC is configured to count "CPUID
> instructions retired." Since KVM intercepts CPUID and emulates it, the
> PMC will always read 0, even if the guest executes a tight loop of
> CPUID instructions.
>
> The PMU is not virtualizable on AMD CPUs without significant
> hypervisor corrections. I have to wonder if it's really worth the
> effort.

Per our offlist chat, my understanding is that there are caveats with vPMUs=
 that
it's simply not feasible for a hypervisor to handle.  I.e. virtualizing any=
 x86
PMU with 100% accuracy isn't happening anytime soon.

The way forward is likely to evaluate each caveat on a case-by-case basis t=
o
determine whether or not the cost of the fixup in KVM is worth the benefit =
to
the guest.  E.g. emulating "CPUID instructions retired" seems like it would=
 be
fairly straightforward.  AFAICT, fixing up the VMRUN stuff is quite difficu=
lt though.
