Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33C971000C
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 23:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjEXVdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 17:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjEXVdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 17:33:00 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C8319D
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:32:55 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a950b982d4so52235ad.0
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684963975; x=1687555975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=borTZX0aRFrFNvcfsYFdIey5QEoR1S37jxXMV2gp3uc=;
        b=LuLuiIEHZd/GedTVjAdtxMkvqVLd/EyPaWvXghGqApnmkJzWlUZceJ0hqxMVwghgsS
         KRFUBfZg56xxn57X7EtlK1CTtrqy52VXU8IItMU25QFE/+0EIQ0XYIhSEJpmxQ/fxDdj
         BcEHyR/jO3GktSY1/QUg/mJaCkY60HKae8c5wOuZSZKXH7RJRbK76Dt1IdkMvbPQ+MVm
         Ma9qNSPk4BE8dquB1+lAoeSmLvtCVJHZJUjbeJZxQd7GUSGZPsFmjb3CoHwb/0wnQc1/
         cZyX13T8+eiLEz631aMj2/110MbWumMZvNqM1hcTtq4brNSWNs6QUMI62Qxi4jNqidKJ
         qxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684963975; x=1687555975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=borTZX0aRFrFNvcfsYFdIey5QEoR1S37jxXMV2gp3uc=;
        b=L5BNqHNr+PNt5mAdrfNjq9roB0NEwSoNi0CoPrpuriglJE1y8hHe3z5SbxnJcbueZg
         5whE5VIjVwPjgkfrGpYsXJep3Var1ZQ3+F89L3GAW9m2YW8So9yFUxhdRyWsB3PbvIsy
         CBTQu/6U4WPzRei/G1wbvcNOeOaKQAvhGW5+3vQSVOn+XlttORq/tMKQ5Sz7I72WyoKc
         au7OUrUeIa34rJdPg5ePg5Eh+0lPzcdtn+GPViWedt/l6RxtRTvAx6EbQb4r4Sj+i6Mk
         2UplM3YKBaNa2nEneM55BgVc9boyLn9hb0T5LzRRVYiKqyeTD3WHPeT1NJW2o9uGCBki
         cz8A==
X-Gm-Message-State: AC+VfDzt4P2zKZCX4y10mmbQaPAerW/FDDy5OkNvinUUXhVA42KLri2Q
        xjIoB2ucj4H1sqiVSbP4Zd5usJ2gINfoMaTgbIMTgA==
X-Google-Smtp-Source: ACHHUZ56rjqoJRHN/O2Wiv8yc5HA0r/Qko53lMwd+9CO4xlJ/nwois7pexgsBdvq4jmOsdBvvzGsw8FlVldOgJGw9/o=
X-Received: by 2002:a17:902:e801:b0:1af:90ce:5261 with SMTP id
 u1-20020a170902e80100b001af90ce5261mr68864plg.24.1684963975207; Wed, 24 May
 2023 14:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230310105346.12302-1-likexu@tencent.com> <20230310105346.12302-6-likexu@tencent.com>
 <ZC99f+AO1tZguu1I@google.com> <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
 <ZDAvDhV/bpPyt3oX@google.com> <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
 <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com> <ZG52cgmjgaqY8jvq@google.com>
 <CALMp9eR_xYapRm=zJ3OdAzBVFjpzeQWYv9nTs1ZstAsugEwWRQ@mail.gmail.com> <ZG6BrSXDnOdDvUZh@google.com>
In-Reply-To: <ZG6BrSXDnOdDvUZh@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 24 May 2023 14:32:44 -0700
Message-ID: <CALMp9eQrDX6=gJzybegjzDJ665NCuWmESt-sZrKHcncnuENdpA@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
To:     Sean Christopherson <seanjc@google.com>
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        "Tom Lendacky (AMD)" <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, May 24, 2023 at 2:29=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, May 24, 2023, Jim Mattson wrote:
> > On Wed, May 24, 2023 at 1:41=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Wed, Apr 26, 2023, Sandipan Das wrote:
> > > > Hi Sean, Like,
> > > >
> > > > On 4/19/2023 7:11 PM, Like Xu wrote:
> > > > >> Heh, it's very much explicable, it's just not desirable, and you=
 and I would argue
> > > > >> that it's also incorrect.
> > > > >
> > > > > This is completely inaccurate from the end guest pmu user's persp=
ective.
> > > > >
> > > > > I have a toy that looks like virtio-pmu, through which guest user=
s can get hypervisor performance data.
> > > > > But the side effect of letting the guest see the VMRUN instructio=
n by default is unacceptable, isn't it ?
> > > > >
> > > > >>
> > > > >> AMD folks, are there plans to document this as an erratum?=C3=AF=
=C2=BF=C2=BD I agree with Like that
> > > > >> counting VMRUN as a taken branch in guest context is a CPU bug, =
even if the behavior
> > > > >> is known/expected.
> > > > >
> > > >
> > > > This behaviour is architectural and an erratum will not be issued. =
However, for clarity, a future
> > > > release of the APM will include additional details like the followi=
ng:
> > > >
> > > >   1) From the perspective of performance monitoring counters, VMRUN=
s are considered as far control
> > > >      transfers and VMEXITs as exceptions.
> > > >
> > > >   2) When the performance monitoring counters are set up to count e=
vents only in certain modes
> > > >      through the "OsUserMode" and "HostGuestOnly" bits, instruction=
s and events that change the
> > > >      mode are counted in the target mode. For example, a SYSCALL fr=
om CPL 3 to CPL 0 with a
> > > >      counter set to count retired instructions with USR=3D1 and OS=
=3D0 will not cause an increment of
> > > >      the counter. However, the SYSRET back from CPL 0 to CPL 3 will=
 cause an increment of the
> > > >      counter and the total count will end up correct. Similarly, wh=
en counting PMCx0C6 (retired
> > > >      far control transfers, including exceptions and interrupts) wi=
th Guest=3D1 and Host=3D0, a VMRUN
> > > >      instruction will cause an increment of the counter. However, t=
he subsequent VMEXIT that occurs,
> > > >      since the target is in the host, will not cause an increment o=
f the counter and so the total
> > > >      count will end up correct.
> > >
> > > The count from the guest's perspective does not "end up correct".  Un=
like SYSCALL,
> > > where _userspace_ deliberately and synchronously executes a branch in=
struction,
> > > VMEXIT and VMRUN are supposed to be transparent to the guest and can =
be completely
> > > asynchronous with respect to guest code execution, e.g. if the host i=
s spamming
> > > IRQs, the guest will see a potentially large number of bogus (from it=
's perspective)
> > > branches retired.
> >
> > The reverse problem occurs when a PMC is configured to count "CPUID
> > instructions retired." Since KVM intercepts CPUID and emulates it, the
> > PMC will always read 0, even if the guest executes a tight loop of
> > CPUID instructions.
> >
> > The PMU is not virtualizable on AMD CPUs without significant
> > hypervisor corrections. I have to wonder if it's really worth the
> > effort.
>
> Per our offlist chat, my understanding is that there are caveats with vPM=
Us that
> it's simply not feasible for a hypervisor to handle.  I.e. virtualizing a=
ny x86
> PMU with 100% accuracy isn't happening anytime soon.
>
> The way forward is likely to evaluate each caveat on a case-by-case basis=
 to
> determine whether or not the cost of the fixup in KVM is worth the benefi=
t to
> the guest.  E.g. emulating "CPUID instructions retired" seems like it wou=
ld be
> fairly straightforward.  AFAICT, fixing up the VMRUN stuff is quite diffi=
cult though.

Yeah. The problem with fixing up "CPUID instructions retired" is
tracking what the event encoding is for every F/M/S out there. It's
not worth it.
