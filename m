Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A2B38DDAA
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 01:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhEWXFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 19:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhEWXFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 19:05:47 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCC1C061574
        for <kvm@vger.kernel.org>; Sun, 23 May 2021 16:04:20 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m190so18735854pga.2
        for <kvm@vger.kernel.org>; Sun, 23 May 2021 16:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=taHsl89uHxiOEQf2rPDtNJ/+Mn5yxhgIAL5Q1aLTII0=;
        b=soHJxP46ycLj4iK/Y25UpjGSoaKN4lEqId1y1MWihWXLiiuqd7GvDvNJMC5+cl59aP
         lttsFVhe6KGjwJHeylvxoMsiXFgkTgW9I8IeOJASjeCnBIpcCnRvXXpbFTiJ7SGuNifh
         +7UzXiABj40GUCWl4AB0TNV2XnnIOhU08kTHpX5uuOeYIJp6Tg2gy3gIVo/qHr4eG6xR
         B5fx6YmJH/ZvkKiefUEz7X7q9LUqreaCkJOSXxkHyXsrEbW1pJF9rG5lAL1W/tc1U9XE
         IRWN7+VwslIrFNwvgwDLJzeS0cJjetx98JWSyi8bKlYQQySYc4Pi5QQflPkb2FVqDTM1
         4V4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=taHsl89uHxiOEQf2rPDtNJ/+Mn5yxhgIAL5Q1aLTII0=;
        b=RrqxxJUEJcoaYZoXuhHFIfHaMEWmHfdEQBLr943q9DbVKA7MN0loFoqmvCVdNEfT9Y
         cI8x+vwJJnYmeEEKyG8cLXn3o7DsnYR1kbl5jyQx8KfET8MKXRoycfvmGAlHdnZ2CPCY
         h5Gku14g4jFHCEPq9Z6kmUqWQ9bI0mL9nJ1UOlUoYaTRPenBRB1UMdu91cvF2XUJYbjo
         9kJJL2gauv2MrvNZbLYVLwjRK30jq6wujluNZQ2p17ymumBfmGy+t2vVnJNvDyZdEhlf
         smekbX3QZA2hhTQ80ZU0STcpcnp0IWBGdzTSfLkLRv8fCYtMOs6pZWG6DX+X1v6l/CI9
         Di5Q==
X-Gm-Message-State: AOAM530vyOtxcQn8deOJoDMkRcyFDWp+F9fpx1M/49xStLtlSdhad7sm
        YF+k2WLZDA9HhNzFFWkwDDbOPoszP3ag4zdKjxSm4g==
X-Google-Smtp-Source: ABdhPJwBKgqSdb6/4KY9SxdeUdhk0iD/XR4npedvl94iHjhuk0rcY++RqoKbHkRGpJiVdW3YZdIiv++VHTT0ljyfFVw=
X-Received: by 2002:aa7:8a85:0:b029:2db:484c:de1a with SMTP id
 a5-20020aa78a850000b02902db484cde1amr21265286pfc.2.1621811059711; Sun, 23 May
 2021 16:04:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-30-seanjc@google.com>
 <CAAeT=FzpUBXpzuCT3eD=3sRnV14OYLA+28Eo7YFioC+vc=xVsA@mail.gmail.com> <YKVt5XVIQMUCUIHd@google.com>
In-Reply-To: <YKVt5XVIQMUCUIHd@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 23 May 2021 16:04:03 -0700
Message-ID: <CAAeT=FwjdQ768k5fJ2pCHbUwsYMdMdOPH3hXA9qKA+f+2CEQEg@mail.gmail.com>
Subject: Re: [PATCH 29/43] KVM: SVM: Tweak order of cr0/cr4/efer writes at RESET/INIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > AMD's APM Vol2 (Table 14-1 in Revision 3.37) says CR0 After INIT will b=
e:
> >
> >    CD and NW are unchanged
> >    Bit 4 (reserved) =3D 1
> >    All others =3D 0
> >
> > (CR0 will be 0x60000010 after RESET)
> >
> > So, it looks the CR0 value that init_vmcb() sets could be
> > different from what is indicated in the APM for INIT.
> >
> > BTW, Intel's SDM (April 2021 version) says CR0 for Power up/Reset/INIT
> > will be 0x60000010 with the following note.
> > -------------------------------------------------
> > The CD and NW flags are unchanged,
> > bit 4 is set to 1, all other bits are cleared.
> > -------------------------------------------------
> > The note is attached as '2' to all Power up/Reset/INIT cases
> > looking at the SDM.  I would guess it is erroneous that
> > the note is attached to Power up/Reset though.
>
> Agreed.  I'll double check that CD and NW are preserved by hardware on IN=
IT,
> and will also ping Intel folks to fix the POWER-UP and RESET footnote.
>
> Hah!  Reading through that section yet again, there's another SDM bug.  I=
t
> contradicts itself with respect to the TLBs after INIT.
>
>   9.1 INITIALIZATION OVERVIEW:
>     The major difference is that during an INIT, the internal caches, MSR=
s,
>     MTRRs, and x87 FPU state are left unchanged (although, the TLBs and B=
TB
>     are invalidated as with a hardware reset)
>
> while Table 9-1 says:
>
>   Register                    Power up    Reset      INIT
>   Data and Code Cache, TLBs:  Invalid[6]  Invalid[6] Unchanged
>
> I'm pretty sure that Intel CPUs are supposed to flush the TLB, i.e. Tabel=
 9-1 is
> wrong.  Back in my Intel validation days, I remember being involved in a =
Core2
> bug that manifested as a triple fault after INIT due to global TLB entrie=
s not
> being flushed.  Looks like that wasn't fixed:
>
> https://www.intel.com/content/dam/support/us/en/documents/processors/mobi=
le/celeron/sb/320121.pdf
>
>   AZ28. INIT Does Not Clear Global Entries in the TLB
>   Problem: INIT may not flush a TLB entry when:
>     =E2=80=A2 The processor is in protected mode with paging enabled and =
the page global enable
>       flag is set (PGE bit of CR4 register)
>     =E2=80=A2 G bit for the page table entry is set
>     =E2=80=A2 TLB entry is present in TLB when INIT occurs
>     =E2=80=A2 Software may encounter unexpected page fault or incorrect a=
ddress translation due
>       to a TLB entry erroneously left in TLB after INIT.
>
>   Workaround: Write to CR3, CR4 (setting bits PSE, PGE or PAE) or CR0 (se=
tting
>               bits PG or PE) registers before writing to memory early in =
BIOS
>               code to clear all the global entries from TLB.
>
>   Status: For the steppings affected, see the Summary Tables of Changes.
>
> AMD's APM also appears to contradict itself, though that depends on one's
> interpretation of "external intialization".  Like the SDM, its table stat=
es that
> the TLBs are not flushed on INIT:
>
>   Table 14-1. Initial Processor State
>
>   Processor Resource         Value after RESET      Value after INIT
>   Instruction and Data TLBs  Invalidated            Unchanged
>
> but a blurb later on says:
>
>   5.5.3 TLB Management
>
>   Implicit Invalidations. The following operations cause the entire TLB t=
o be
>   invalidated, including global pages:
>
>     =E2=80=A2 External initialization of the processor.

"Table 8-9. Simultaneous Interrupt Priorities" of AMD's APM has
the words "External Processor Initialization (INIT)", which make
me guess "the External initialization of the processor" in 5.5.3
TLB Management means INIT.


> All in all, that means KVM also has a bug in the form of a missing guest =
TLB
> flush on INIT, at least for VMX and probably for SVM.  I'll add a patch t=
o flush
> the guest TLBs on INIT irrespective of vendor.  Even if AMD CPUs don't fl=
ush the
> TLB, I see no reason to bank on all guests being paranoid enough to flush=
 the
> TLB immediately after INIT.

Yes, I agree that would be better.
Thank you so much for all the helpful information !

Regards,
Reiji
