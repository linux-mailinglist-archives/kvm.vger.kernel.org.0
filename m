Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAF63AD4CD
	for <lists+kvm@lfdr.de>; Sat, 19 Jun 2021 00:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhFRWI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 18:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbhFRWI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 18:08:26 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA31C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 15:06:15 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id x196so12150930oif.10
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 15:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/fKEdBg4JpIL5jxoBAyG88wcJ11ZEsJfbSxHT7zAQ7s=;
        b=lCYhs2mhNXUfvKNs5wyh9lINlBHK80QIiuzFWpJgF/AIfHRd0FBwB98VoEN3tejeTH
         BvgCtQByRtQnLXpI/f8NZjGViSaZfSvNX7Km+uOuJ4wWkouMx5BQFi0ZNNJki/IY8MLz
         WYe2kGqqjmKElJf6FTBm63lgv8MguUnaX3jlk4X3OY98ybnXkStiwMVvZJMjXCzaHCbE
         4rhwm+6QLRqD0iNn0a9XxBTGOvv4Xpogm5+jJYKXl9xZBxh7YT66ZazSW9m74Re458Ng
         xPjp+GPP5P9O/tQIPq3rG/Uvh4Vx5O7LRBCGMYs+/sLoGhNFSLVXP9Pj7v3iCjOMG8C4
         5K7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/fKEdBg4JpIL5jxoBAyG88wcJ11ZEsJfbSxHT7zAQ7s=;
        b=gcmJzAgmMKUAf/fOj8tgRiWToDAt0CRFdHKfK82pSNaFBuDoPBiNZRZu1Px7o18ceO
         NiG+IDAW0Ca6RcjdcMujZ2aH5YEHIG6Rb2zrQUhRmjHOVtkrPAOrDqU3wme9buUJftbl
         orovyIRljwZtzM1qn9yxl0R+SwrsimR7vq/H8mHvFBFO8iy/D0ETu9eaAMp0MZaXBlu8
         GlyUPpq1PuV87NigScxCRnUIvBeCmHYq//8wb0ef0pLcx5BEviu8ETbQyhuSvyREgUqy
         QD4cp1wGY8JQLC4rldLutaq34gZZG9eGZfFwx/nlIyzNPCDN9gEjgxyrzaAsNjI4TMS7
         650w==
X-Gm-Message-State: AOAM531V+SWezSbByvfk8xCetZMrV7PbPr9XV5i7PgWpnQdAsZ8+zki5
        5sNPZ5ZJRbi4QV+sKEzjE21I1V9zet0UczlLZi+owQ==
X-Google-Smtp-Source: ABdhPJxUY+rS+ss6Mt3CQSqNZhSiRBO7x/C0pHu2xqOcVXTxHytEvy8+L7+vwRl2cIbSpKPmqaKkGS/5u1nxI3gzJ0w=
X-Received: by 2002:aca:adc9:: with SMTP id w192mr10097358oie.6.1624053974854;
 Fri, 18 Jun 2021 15:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com> <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com> <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com> <ca311331-c862-eed6-22ff-a82f0806797f@yandex.ru>
In-Reply-To: <ca311331-c862-eed6-22ff-a82f0806797f@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 18 Jun 2021 15:06:03 -0700
Message-ID: <CALMp9eQxys64U-r5xdF_wdunqn8ynBoOBPRDSjTDMh-gF3EEpg@mail.gmail.com>
Subject: Re: guest/host mem out of sync on core2duo?
To:     stsp <stsp2@yandex.ru>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 2:55 PM stsp <stsp2@yandex.ru> wrote:
>
> 19.06.2021 00:07, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Fri, Jun 18, 2021 at 9:02 AM stsp <stsp2@yandex.ru> wrote:
> >
> >> Here it goes.
> >> But I studied it quite thoroughly
> >> and can't see anything obviously
> >> wrong.
> >>
> >>
> >> [7011807.029737] *** Guest State ***
> >> [7011807.029742] CR0: actual=3D0x0000000080000031,
> >> shadow=3D0x00000000e0000031, gh_mask=3Dfffffffffffffff7
> >> [7011807.029743] CR4: actual=3D0x0000000000002041,
> >> shadow=3D0x0000000000000001, gh_mask=3Dffffffffffffe871
> >> [7011807.029744] CR3 =3D 0x000000000a709000
> >> [7011807.029745] RSP =3D 0x000000000000eff0  RIP =3D 0x000000000000017=
c
> >> [7011807.029746] RFLAGS=3D0x00080202         DR7 =3D 0x000000000000040=
0
> >> [7011807.029747] Sysenter RSP=3D0000000000000000 CS:RIP=3D0000:0000000=
000000000
> >> [7011807.029749] CS:   sel=3D0x0097, attr=3D0x040fb, limit=3D0x000001a=
0,
> >> base=3D0x0000000002110000
> >> [7011807.029751] DS:   sel=3D0x00f7, attr=3D0x0c0f2, limit=3D0xfffffff=
f,
> >> base=3D0x0000000000000000
> > I believe DS is illegal. Per the SDM, Checks on Guest Segment Registers=
:
> >
> > * If the guest will not be virtual-8086, the different sub-fields are
> > considered separately:
> >    - Bits 3:0 (Type).
> >      * DS, ES, FS, GS. The following checks apply if the register is us=
able:
> >        - Bit 0 of the Type must be 1 (accessed).
>
> That seems to be it, thank you!
> At least for the minimal reproducer
> I've done.
>
> So only with unrestricted guest its
> possible to ignore that field?

The VM-entry constraints are the same with unrestricted guest.

Note that *without* unrestricted guest, kvm will generally have to
emulate the early guest protected mode code--until the last vestiges
of real-address mode are purged from the descriptor cache. Maybe it
fails to set the accessed bits in the LDT on emulated segment register
loads?

> > [7011807.029764] FS:   sel=3D0x0000, attr=3D0x10000, limit=3D0x00000000=
,
> > base=3D0x0000000000000000
> > [7011807.029765] GS:   sel=3D0x0000, attr=3D0x10000, limit=3D0x00000000=
,
> > base=3D0x0000000000000000
> > [7011807.029767] GDTR:                           limit=3D0x00000017,
> > base=3D0x000000000a708100
> > [7011807.029768] LDTR: sel=3D0x0010, attr=3D0x00082, limit=3D0x0000ffff=
,
> > base=3D0x000000000ab0a000
> > [7011807.029769] IDTR:                           limit=3D0x000007ff,
> > base=3D0x000000000a708200
> > [7011807.029770] TR:   sel=3D0x0010, attr=3D0x0008b, limit=3D0x00002088=
,
> > base=3D0x000000000a706000
> > It seems a bit odd that TR and LDTR are both 0x10,  but that's perfectl=
y legal.
>
> This selector is fake.
> Our guest doesn't do LLDT or LTR,
> so we didn't care to even reserve
> the GDT entries for those.
>
