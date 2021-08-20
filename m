Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31B43F3241
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 19:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhHTRat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 13:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhHTRaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 13:30:46 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789B8C061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 10:30:08 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id z2so1337383qvl.10
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 10:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lhqHGeqO8vbW9F1VGczc9A8aAU9F6GFC2ih1Dhslpuc=;
        b=RWyE6qYBGPWvbHnagwYBRnEtixS0+ZtxtJX+f8N75wdu8hKwtjp6+EYKPxRxfoH/Dd
         Yex30opY+Jxlw14S9M0XqsfrU9WjGRRrrivO/VEHl8DWkdQgD6W/LHaQAXMm0UWE7kAC
         h1e/iiMOuNvo9djJprcQYeejllj95SYXmHyPAzTrfqN1r06Xpx4pxlpJzjkZo0M/6JSv
         7eEdCxdYOPXVmqYDdWHLEqOHaegS30wEueO/adZQqYNY/YqUPEkMrmSmTwGbvZJ3puXR
         Nu/PbuBbexzqPXOqbV8SUJRMXl6U8KPGCraMusbQ24Tubf1W8J3JQFDqfMDd5X1bVCqg
         Le/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lhqHGeqO8vbW9F1VGczc9A8aAU9F6GFC2ih1Dhslpuc=;
        b=t8gNiG+kvrtOL1vbAOnbjWnrH9rsYCuV0EEfLLnM+Dp1WsOjYOLqBn/A5EiUGjmY1I
         BPWoOarQicFsSs7o8jzu15aJ9jO34ftwj0XqNqJKkG2/jdBmdzTELDlh5sZF53zLUv1b
         Lgi4wAzvlidd5oZbkQn4hq2/eLMZeiHFhZxivAe990ZfB/kttZRDvrjICAxvgb/v/WEK
         OqiAyxHdgaduvt53NnognD+yBJhS4LYYOCbVnDdHs15Xdkh6iNmUwsJHS5nKUkr6b5kr
         03gMFFU5p0K3EzJbrw768p18x68rF74nwM7xh/C4v3Tb1KJltTzJIsdgnRWist0JKHEM
         G4fQ==
X-Gm-Message-State: AOAM532HLqrJIDGfPJMHfDN5ADUKhU1fDvSKJBRx34n2BsEr9eFkxMje
        ysXuGARoLERy/Gu8nOJocvk7X4tFOTgZMR5QIaHVtQ==
X-Google-Smtp-Source: ABdhPJzUkAce2tECzqPR1PLBeZIyDd6zJCmKeLf7itXePbRcDF2QqikxmWW9rVLB30I9t4hFe4zPVxDEvB+3nUJz9hc=
X-Received: by 2002:a05:6214:2465:: with SMTP id im5mr21364635qvb.46.1629480607186;
 Fri, 20 Aug 2021 10:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210702114820.16712-1-varad.gautam@suse.com> <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
 <YRuURERGp8CQ1jAX@suse.de> <CAA03e5FTrkLpZ3yr3nBphOW3D+8HF-Wmo4um4MTXum3BR6BMQw@mail.gmail.com>
 <71db10eb-997f-aac1-5d41-3bcbc34c114d@suse.com> <CAA03e5H6mM0z5r4knbjHDLS4svLP6WQuhC_5BnSgCyXpRZgqAQ@mail.gmail.com>
 <ffae117c-4961-c0de-1f17-7092b7bc3d65@suse.com>
In-Reply-To: <ffae117c-4961-c0de-1f17-7092b7bc3d65@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 20 Aug 2021 10:29:55 -0700
Message-ID: <CAA03e5FJH03AbWvxMB6VbgCa1owbb1fpAmikr+MnrKQ8WRiy9w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     Joerg Roedel <jroedel@suse.de>, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Zixuan Wang <zixuanwang@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 4:36 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> On 8/19/21 3:32 AM, Marc Orr wrote:
> > On Wed, Aug 18, 2021 at 1:38 AM Varad Gautam <varad.gautam@suse.com> wr=
ote:
> >>
> >> Hi Marc, Zixuan,
> >>
> >> On 8/18/21 3:52 AM, Marc Orr wrote:
> >>> On Tue, Aug 17, 2021 at 3:49 AM Joerg Roedel <jroedel@suse.de> wrote:
> >>>>
> >>>> Hi Marc,
> >>>>
> >>>> On Fri, Aug 13, 2021 at 11:44:39AM -0700, Marc Orr wrote:
> >>>>> To date, we have _most_ x86 test cases (39/44) working under UEFI a=
nd
> >>>>> we've also got some of the test cases to boot under SEV-ES, using t=
he
> >>>>> UEFI #VC handler.
> >>>>
> >>>> While the EFI APP approach simplifies the implementation a lot, I do=
n't
> >>>> think it is the best path to SEV and TDX testing for a couple of
> >>>> reasons:
> >>>>
> >>>>         1) It leaves the details of #VC/#VE handling and the SEV-ES
> >>>>            specific communication channels (GHCB) under control of t=
he
> >>>>            firmware. So we can't reliably test those interfaces from=
 an
> >>>>            EFI APP.
> >>>>
> >>>>         2) Same for the memory validation/acceptance interface neede=
d
> >>>>            for SEV-SNP and TDX. Using an EFI APP leaves those under
> >>>>            firmware control and we are not able to reliably test the=
m.
> >>>>
> >>>>         3) The IDT also stays under control of the firmware in an EF=
I
> >>>>            APP, otherwise the firmware couldn't provide a #VC handle=
r.
> >>>>            This makes it unreliable to test anything IDT or IRQ rela=
ted.
> >>>>
> >>>>         4) Relying on the firmware #VC hanlder limits the tests to i=
ts
> >>>>            abilities. Implementing a separate #VC handler routine fo=
r
> >>>>            kvm-unit-tests is more work, but it makes test developmen=
t
> >>>>            much more flexible.
> >>>>
> >>>> So it comes down to the fact that and EFI APP leaves control over
> >>>> SEV/TDX specific hypervisor interfaces in the firmware, making it ha=
rd
> >>>> and unreliable to test these interfaces from kvm-unit-tests. The stu=
b
> >>>> approach on the other side gives the tests full control over the VM,
> >>>> allowing to test all aspects of the guest-host interface.
> >>>
> >>> I think we might be using terminology differently. (Maybe I mis-used
> >>> the term =E2=80=9CEFI app=E2=80=9D?) With our approach, it is true th=
at all
> >>> pre-existing x86_64 test cases work out of the box with the UEFI #VC
> >>> handler. However, because kvm-unit-tests calls `ExitBootServices` to
> >>> take full control of the system it executes as a =E2=80=9CUEFI-stubbe=
d
> >>> kernel=E2=80=9D. Thus, it should be trivial for test cases to update =
the IDT
> >>> to set up a custom #VC handler for the duration of a test. (Some of
> >>> the x86_64 test cases already do something similar where they install
> >>> a temporary exception handler and then restore the =E2=80=9Cdefault=
=E2=80=9D
> >>> kvm-unit-tests exception handler.)
> >>>
> >>> In general, our approach is to set up the test cases to run with the
> >>> kvm-unit-tests configuration (e.g., IDT, GDT). The one exception is
> >>> the #VC handler. However, all of this state can be overridden within =
a
> >>> test as needed.
> >>>
> >>> Zixuan just posted the patches. So hopefully they make things more cl=
ear.
> >>>
> >>
> >> Nomenclature aside, I believe Zixuan's patchset [1] takes the same app=
roach
> >> as I posted here. In the end, we need to:
> >> - build the testcases as ELF shared objs and link them to look like a =
PE
> >> - switch away from UEFI GDT/IDT/pagetable states on early boot to what
> >>   kvm-unit-tests needs
> >> - modify the testcases that contain non-PIC asm stubs to allow buildin=
g
> >>   them as shared objs
> >>
> >> I went with avoiding to bring in gnu-efi objects into kvm-unit-tests
> >> for EFI helpers, and disabling the non-PIC testcases for the RFC's sak=
e.
> >>
> >> I'll try out "x86 UEFI: Convert x86 test cases to PIC" [2] from Zixuan=
's
> >> patchset with my series and see what breaks. I think we can combine
> >> the two patchsets.
> >>
> >> [1] https://lore.kernel.org/r/20210818000905.1111226-1-zixuanwang@goog=
le.com/
> >> [2] https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@goo=
gle.com/
> >
> > This sounds great to us. We will also experiment with combining the
> > two patchsets and report back when we have some experience with this.
> > Though, please do also report back if you have an update on this
> > before we do.
> >
>
> I sent out a v2 [1] with Zixuan's "x86 UEFI: Convert x86 test cases to PI=
C" [2]
> pulled in, PTAL.
>
> [1] https://lore.kernel.org/r/20210819113400.26516-1-varad.gautam@suse.co=
m/
> [2] https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@google=
.com/

Thanks. This is a good step. However, after reviewing this new patch
set I think we should go a step further and completely combine the two
patch sets. This way, we get the benefit of Varad=E2=80=99s patches, which =
is
that we don=E2=80=99t need to link the gnu-efi library. And we get the
benefits of Zixuan=E2=80=99s patches which are twofold: (1) the vast majori=
ty
of the x86_64 test cases work under UEFI (optionally with SEV-ES) and
(2) much of the assembly code is refactored into C, making it more
readable/maintainable.

We=E2=80=99ve started experimenting with using Varad=E2=80=99s patch set as=
 the
foundation for Zixuan's patch set. Initial testing on this
Frankenstein patch set is encouraging. I=E2=80=99d like to see Zixuan finis=
h
this effort. Please give us a few days to further test and organize
the combined patch set. We=E2=80=99ll post it as soon as we can. Likely ear=
ly
next week.

Thanks,
Marc
