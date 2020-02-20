Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644661668C3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgBTUol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:44:41 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34860 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgBTUok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:44:40 -0500
Received: by mail-lj1-f193.google.com with SMTP id q8so5673033ljb.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 12:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IWKv+CThwOSAcFDicDDkW6IxDXx0lTgPGsxbr+yUlKk=;
        b=TVQhrreHbf17hU30aWa/y+NBiuV9Q4d2JKpj0/fRjks4Rycw9ZM9syDOBQC+MZvyjA
         GasB9n67jaYQ3ymLvKx78uDjNdKsqdKks8gCJc5rsStSk4Tc1VqJyT56JCrcYMSkUwnC
         iQX+bBtvhysn0NRSvlgI4JTli8yYHDOizn0T/HTIs7sCCv0G0NQZn1Rm3bwNL9nZDyz+
         a38lYxDmYOjSy3RuKpEiyESSCw3NCJZ7Dsi2GNBHrSBk6L2mtmjw8oYsNufrs8PaYam2
         h2Z/HB9mljDnv2RM/IQdLQCSth1u6PEI5CcWGoWBgipkIP72A+Edrc2wSIAsScsw+O/u
         ogvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IWKv+CThwOSAcFDicDDkW6IxDXx0lTgPGsxbr+yUlKk=;
        b=Uttb/bCJAnvj7xbCvrF1fDShz3tm47PgZZub7fkF2bJumFyY2BD9mYDC4M/AglrRDz
         MawuCLDIDPI5qvu1cVj1wNVpmRqc8PaurOBj54RqNzMuIX0n6IGyPf+cqDFthvmC6eTT
         jWOGKuu22QbA1nSE6kx+9nN/3ni3HNI6geO7noYKUezGhCqhO+fv+F9M+h1n9hAwWaSz
         5djVtI3FYMt+wV1yUCEmXGEco2R1Lawr7w4iPNFFGqz0spcEIqE5M1+i/ws0e99pVNOE
         DCEwpOp1GOYDKkNPRZf5pCeJS211FhFb4c+Sc4fJSlCVJ9f/fvMSPIqPks9FACNA/lQM
         HX+g==
X-Gm-Message-State: APjAAAVi7k8b+1brcKUleQGEl139oPkHgT+VoEtK0xzZ56Z8DXK12Ed4
        KzpLtvJRDzE4iqzkYuEfYFAa7rp/KoygLpgkiJxDdA==
X-Google-Smtp-Source: APXvYqwooZIqlD5lJXNGmxCHDE66yRocSA5LDyvW8+AijnQERqL8v/ziSqz7UPiFAr1QEKFZ15WV464xfqknmXj3IPE=
X-Received: by 2002:a05:651c:448:: with SMTP id g8mr20233966ljg.35.1582231477601;
 Thu, 20 Feb 2020 12:44:37 -0800 (PST)
MIME-Version: 1.0
References: <CABayD+ch3XBvJgJc+uoF6JSP0qZGq2zKHN-hTc0Vode-pi80KA@mail.gmail.com>
 <52450536-AF7B-4206-8F05-CF387A216031@amacapital.net> <3de6e962-3277-ddbd-8c78-eaf754973928@amd.com>
In-Reply-To: <3de6e962-3277-ddbd-8c78-eaf754973928@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 20 Feb 2020 12:43:59 -0800
Message-ID: <CABayD+fBpP-W_jfVuy_+shh+Sj_id79+ECG+R5H=W9Jmcii8qg@mail.gmail.com>
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 7:55 AM Brijesh Singh <brijesh.singh@amd.com> wrote=
:
>
>
>
> On 2/19/20 8:12 PM, Andy Lutomirski wrote:
> >
> >
> >> On Feb 19, 2020, at 5:58 PM, Steve Rutherford <srutherford@google.com>=
 wrote:
> >>
> >> =EF=BB=BFOn Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@am=
d.com> wrote:
> >>>
> >>> From: Brijesh Singh <brijesh.singh@amd.com>
> >>>
> >>> Invoke a hypercall when a memory region is changed from encrypted ->
> >>> decrypted and vice versa. Hypervisor need to know the page encryption
> >>> status during the guest migration.
> >>
> >> One messy aspect, which I think is fine in practice, is that this
> >> presumes that pages are either treated as encrypted or decrypted. If
> >> also done on SEV, the in-place re-encryption supported by SME would
> >> break SEV migration. Linux doesn't do this now on SEV, and I don't
> >> have an intuition for why Linux might want this, but we will need to
> >> ensure it is never done in order to ensure that migration works down
> >> the line. I don't believe the AMD manual promises this will work
> >> anyway.
> >>
> >> Something feels a bit wasteful about having all future kernels
> >> universally announce c-bit status when SEV is enabled, even if KVM
> >> isn't listening, since it may be too old (or just not want to know).
> >> Might be worth eliding the hypercalls if you get ENOSYS back? There
> >> might be a better way of passing paravirt config metadata across than
> >> just trying and seeing if the hypercall succeeds, but I'm not super
> >> familiar with it.
> >
> > I actually think this should be a hard requirement to merge this. The h=
ost needs to tell the guest that it supports this particular migration stra=
tegy and the guest needs to tell the host that it is using it.  And the gue=
st needs a way to tell the host that it=E2=80=99s *not* using it right now =
due to kexec, for example.
> >
> > I=E2=80=99m still uneasy about a guest being migrated in the window whe=
re the hypercall tracking and the page encryption bit don=E2=80=99t match. =
 I guess maybe corruption in this window doesn=E2=80=99t matter?
> >
>
> I don't think there is a corruption issue here. Let's consider the below
> case:
>
> 1) A page is transmitted as C=3D1 (encrypted)
>
> 2) During the migration window, the page encryption bit is changed
>   to C=3D0 (decrypted)
>
> 3) #2 will cause a change in page table memory, thus dirty memory
>   the tracker will create retransmission of the page table memory.
>
> 4) The page itself will not be re-transmitted because there was
>   no change to the content of the page.
>
> On destination, the read from the page will get the ciphertext.
>
> The encryption bit change in the page table is used on the next access.
> The user of the page needs to ensure that data is written with the
> correct encryption bit before reading.
>
> thanks


I think the issue results from a slightly different perspective than
the one you are using. I think the situation Andy is interested in is
when a c-bit change and a write happen close in time. There are five
events, and the ordering matters:
1) Guest dirties the c-bit in the guest
2) Guest dirties the page
3) Host userspace observes the c-bit logs
4) Host userspace observes the page dirty logs
5) Host transmits the page

If these are reordered to:
3) Host userspace observes the c-bit logs
1) Guest dirties the c-bit in the guest
2) Guest dirties the page
4) Host userspace observes the page dirty logs
5) Host transmits the page (from the wrong c-bit perspective!)

Then the host will transmit a page with the wrong c-bit status and
clear the dirty bit for that page. If the guest page is not
retransmitted incidentally later, then this page will be corrupted.

If you treat pages with dirty c-bits as dirty pages, then you will
check the c-bit logs later and observe the dirty c-bit and retransmit.
There might be some cleverness around enforcing that you always fetch
the c-bit logs after fetching the dirty logs, but I haven't convinced
myself that this works yet. I think it might, since then the c-bits
are at least as fresh as the dirty bits.

The main uncertainty that comes to mind for that strategy is if, on
multi-vCPU VMs, the page dirtying event (from the new c-bit
perspective) and the c-bit status change hypercall can themselves
race. If a write from the new c-bit perspective can arrive before the
c-bit status change arrives in the c-bit logs, we will need to treat
pages with dirty c-bits as dirty pages.

Note that I do agree that if the c-bit status flips, and no one writes
to the page, it doesn't really matter if you retransmit that page. If
a guest wants to read nonsense, it can.
