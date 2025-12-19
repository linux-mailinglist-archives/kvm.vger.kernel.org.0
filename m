Return-Path: <kvm+bounces-66427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 827BECD22AE
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 00:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 80CD5301C66B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C487125F7A9;
	Fri, 19 Dec 2025 23:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TUhBEl5F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1213A1E60
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 23:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185393; cv=none; b=Gib4LmwWoLl2CnV30mGux6cNJhtRHPoLrcym5CkU31bKq/5rkxgbNxlVGDQYQeMrInTzTpJOrB80cPm8MKzBxbqbqnm+TYl8AIxqIGzUuu0zoY92b4nXI3ierB3vvp6UvrpWMxWLZSQDUWV0hYnOz6eM5UqiYwfYFB9w9pHgmj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185393; c=relaxed/simple;
	bh=aViIJDt1cDTzeSd1zKpKhFB+Cf4yQ+NsbwwJjv4OPPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VJQfQCOkPvuEEquoVoZdYaV39Lsv2B8jgtN8doF1Eq1Ni6NMgZEJASSFo+/ILFfQbkkk6ckwsoAH2jPb2rIdnc2hCGY+Wx4WjSpq9S/DCS8k1FrxLB8PvHqa535QmC4uYLqC0FG9ynvOjeTJTOC+/VJDxY7O1qj9Hz5KlqUGPFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TUhBEl5F; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42e2ba54a6fso1007408f8f.3
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185388; x=1766790188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=do06nfdGtGHk8vM4bgLyRQUkOFUNdgHLnsFJT7exvEs=;
        b=TUhBEl5F9wUwJa5KthI5dDBirNZDgEqxdqHn5krUvYnW+I9UA6wMlqob0TNJXZou7w
         1KRXCO2+lhYRD4bUHRE8DYE5VRSgemQmu0UquZU59kuTkrOve8xHtSqFfS6JWLny0nPA
         NLBy+yDvexxXOlF/SkHXwXK3gO4zJfaOIMS0w0oqPfqRjFMCxmPHOptEhgf90gf1nMRi
         Q9JmKp1hWarsUNUARIaFzto52Z8N1qqM/Pe//2nuZwdRJCRVLEEnM7HiytGHJJs9ovkn
         rHlWaDqSL2sbw/guA84z3KPu9LtL2C6rvMN6jGtICEF/ny6kpFpgm5bizfWOnVb7BsyV
         85PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185388; x=1766790188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=do06nfdGtGHk8vM4bgLyRQUkOFUNdgHLnsFJT7exvEs=;
        b=h1Vz6yR/8LdnHSjudbzB5I6FOiSiyj3tqBrGGl3aByBek9St3woCwySiaP3qNOHV9b
         8VwAi4J9+Q5b+OBUV4HEnUD7uDwtfBCjwuhKYDR7OtI21fwcRzBzLpQwep5WEHCi3Pa1
         BQ/3ZXDBfQ1ZGjCbnv0WK/GlQxBiSHrNFh//Uo5pNMwUQA2nDJhC83aj1h1n5+wZ2Yah
         sbwNUmgWWcfjGBJeDcUUp8YlWbW4eMW7IntkLps/ot8ehIM8Mg969J214kY4CF1MV6Lo
         0rKSFFkpLt81LLfy/1/stAXT2QF6c4qqdObuieGNWQ+juywQeVrt1EUL3JV/+/nUxCAH
         2x+g==
X-Gm-Message-State: AOJu0YwwjoqWWz26UQCcANVmu8c1OlF5mRjE/S6vSfyv9dKCImZMPJrt
	h4Xbs7fPFAlPXnR9US5b9cH7ls2aUpGmkfNZqfImgsntl11avx0YmT1lxT2sBRstHT2OARiydVD
	Rx8BhyVy7H9OlLXm1TxvOwhxgGHpjDTbvidKvAKUh
X-Gm-Gg: AY/fxX7lbyWdyVrqIXFBKc4293fgZWPxUB7buw1aZ5xNgOpI5qn0jZ4mz6ZEp0raiKi
	TRe4BUhfP03uDaOK2OPhy+S/y2b8WucSVMvUARca+20dcge7uYNOeufD4a82FvYb615TwlJvwQG
	X/gMy+jqQduB/0k/a/1puMEBAeR3of66CNjtOZLZY07IR3hQ402BZ/OcXkcF3F/ziEKVXTryzl0
	Kdm0oQKPAKyPCEemWnkJJ3coERpdSTvNhY47FX9CmBpDqrGMgB3qP+0VcnpxbvulGCaxc4RsB7i
	wsy+QtIo0iFYk+7IYvDLZdvyxU8W
X-Google-Smtp-Source: AGHT+IEgU8UoLxyUUIVJO2hu4uscMgRRfdx2nEw055fbiJxpUtC5gAaOv+PFeK9Y6dBstwyGduMenfJccdM2HYGGMxY=
X-Received: by 2002:a05:6000:2305:b0:431:307:2200 with SMTP id
 ffacd0b85a97d-4324e4c15eemr5298196f8f.9.1766185388105; Fri, 19 Dec 2025
 15:03:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820162951.3499017-1-chengkev@google.com> <aRz_UkBPM7FcfmpP@google.com>
In-Reply-To: <aRz_UkBPM7FcfmpP@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Fri, 19 Dec 2025 18:02:57 -0500
X-Gm-Features: AQt7F2oELsrIf-dAg-Ies8a9V5yy7V-DOHesyRMlvP5Rw4X5eSTrjT0QiE0YK3c
Message-ID: <CAE6NW_YGi_FPcN1hDWMB3PfcN1GFwwVsbKKC=Pka_G5CQaubCA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nSVM: Add test for EPT A/D bits
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, jmattson@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 6:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Aug 20, 2025, Kevin Cheng wrote:
> > The nVMX tests already have coverage for TDP A/D bits. Add a
> > similar test for nSVM to improve test parity between nSVM and nVMX.
>
> Please write a more verbose changelog that explains _exactly_ what you in=
tend to
> test.  Partly because I don't entirely trust the EPT A/D tests, but mostl=
y
> because I think it will help you fully understand the double walks that n=
eed to
> be done.  E.g. explain what all NPT entries will be touched if the guest =
writes
> using a virtual address.
>
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
> > ---
> >  x86/svm.c     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  x86/svm.h     |  5 +++
> >  x86/svm_npt.c | 46 +++++++++++++++++++++++++
>
> The {check,clear}_npt_ad() helpers belong in svm_npt.c, not svm.c
>
> >  3 files changed, 144 insertions(+)
> >
> > diff --git a/x86/svm.c b/x86/svm.c
> > index e715e270..53b78d16 100644
> > --- a/x86/svm.c
> > +++ b/x86/svm.c
> > @@ -14,6 +14,8 @@
> >  #include "isr.h"
> >  #include "apic.h"
> >
> > +#include <asm/page.h>
> > +
> >  /* for the nested page table*/
> >  u64 *pml4e;
> >
> > @@ -43,6 +45,97 @@ u64 *npt_get_pml4e(void)
> >       return pml4e;
> >  }
> >
> > +void clear_npt_ad(unsigned long *pml4e, u64 guest_cr3,
> > +               unsigned long guest_addr)
>
> GPAs are of type phys_addr_t, not "unsigned long".  The tests pass becaus=
e they're
> 64-bit only, but that's ugly and shouldn't be relied upon.
>
> And pml4e, a.k.a. npt_get_pml4e(), is a u64 *.  Actually, pml4e isn't eve=
n used,
> which makes me question whether or not this test does what it intended to=
 do.
>
> Ah, guest_addr is actually a _virtual_ address.  Please name it "gva" to =
remove
> ambiguity (and to help clarify that guest_cr3 really is CR3, not nCR3).
>
> > +{
> > +     int l;
> > +     unsigned long *pt =3D (unsigned long *)guest_cr3, gpa;
> > +     u64 *npt_pte, pte, offset_in_page;
> > +     unsigned offset;
>
> Please don't use bare "unsigned", and use reverse fir-tree.  "offset" can=
 simply
> be an "int" because we're 100% relying on it not to be greater than 511. =
 I.e.
>
>         unsigned long *pt =3D (unsigned long *)guest_cr3, gpa;
>         u64 *npt_pte, pte, offset_in_page;
>         int l, offset;
>
> > +
> > +     for (l =3D PAGE_LEVEL; ; --l) {
> > +             offset =3D PGDIR_OFFSET(guest_addr, l);
> > +             npt_pte =3D npt_get_pte((u64) &pt[offset]);
>
> This is retrieving a PTE from a non-NPT page table (pt =3D=3D guest_cr3).
>
> > +             if(!npt_pte) {
> > +                     printf("NPT - guest level %d page table is not ma=
pped.\n", l);
>
> Why printf instead of report_fail()?
>
> > +                     return;
> > +             }
> > +
> > +             *npt_pte &=3D ~(PT_AD_MASK);
>
> And so here you're clearing bits in the non-nested page tables.  The test=
 passes
> because check_npt_ad() also checks the non-nested page tables, but the te=
st isn't
> doing what it purports to do.
>
> > +
> > +             pte =3D pt[offset];
> > +             if (l =3D=3D 1 || (l < 4 && (pte & PT_PAGE_SIZE_MASK)))
> > +                     break;
> > +             if (!(pte & PT_PRESENT_MASK))
> > +                     return;
> > +             pt =3D (unsigned long *)(pte & PT_ADDR_MASK);
> > +     }
> > +
> > +     offset =3D PGDIR_OFFSET(guest_addr, l);
> > +     offset_in_page =3D guest_addr &  ((1 << PGDIR_BITS(l)) - 1);
> > +     gpa =3D (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_pag=
e);
> > +     npt_pte =3D npt_get_pte(gpa);
>
> Ah, the nested NPT tables are checked, but only for the leaf PTE of the f=
inal GPA.
> This fails to validate address.  This fails to validate Accessed bits on =
non-leaf
> NPT entries, and fails to validate A/D bits on NPT entries used to transl=
ate GPAs
> accessed while walking the guest GVA=3D>GPA page tables.
>
> > +     *npt_pte &=3D ~(PT_AD_MASK);
> > +}
> > +
> > +void check_npt_ad(unsigned long *pml4e, u64 guest_cr3,
> > +     unsigned long guest_addr, int expected_gpa_ad,
> > +     int expected_pt_ad)
>
> Align indentation.
>
> > +{
> > +     int l;
> > +     unsigned long *pt =3D (unsigned long *)guest_cr3, gpa;
> > +     u64 *npt_pte, pte, offset_in_page;
> > +     unsigned offset;
> > +     bool bad_pt_ad =3D false;
> > +
> > +     for (l =3D PAGE_LEVEL; ; --l) {
> > +             offset =3D PGDIR_OFFSET(guest_addr, l);
> > +             npt_pte =3D npt_get_pte((u64) &pt[offset]);
> > +
> > +             if(!npt_pte) {
> > +                     printf("NPT - guest level %d page table is not ma=
pped.\n", l);
>
> Why printf instead of report_fail()?
>
> > +                     return;
> > +             }
> > +
> > +             if (!bad_pt_ad) {
> > +                     bad_pt_ad |=3D (*npt_pte & PT_AD_MASK) !=3D expec=
ted_pt_ad;
> > +                     if(bad_pt_ad)
>
> Unnecessary nesting.  E.g. ignoring the below feedback, this could be:
>
>                 if (!bad_pt_ad && (*npt_pte & PT_AD_MASK) !=3D expected_p=
t_ad) {
>                         bad_pt_ad =3D true
>                         report_fail(...)
>                 }
>
> > +                             report_fail("NPT - received guest level %=
d page table A=3D%d/D=3D%d",
> > +                                         l,
> > +                                         !!(expected_pt_ad & PT_ACCESS=
ED_MASK),
> > +                                         !!(expected_pt_ad & PT_DIRTY_=
MASK));
>
> Print both expected and actual, otherwise debugging is no fun.  Actually,=
 looking
> at the caller, passing in @expected_pt_ad is quite silly.  The only time =
A/D bits
> are expected to be '0' are for the initial check, immediately after A/D b=
its are
> zeroed.  That's honestly uninteresting, it's basically verifying KVM hasn=
't
> randomly corrupted memory.  If someone _really_ wants to verify that A/D =
bits are
> cleared, just read back immediately after writing.
>
> Dropping @expected_pt_ad will make it easier to expand coverage, e.g. for=
 reads
> vs. writes, and of intermediate GPAs.
>
> E.g.
>
> > +             }
> > +
> > +             pte =3D pt[offset];
> > +             if (l =3D=3D 1 || (l < 4 && (pte & PT_PAGE_SIZE_MASK)))
> > +                     break;
> > +             if (!(pte & PT_PRESENT_MASK))
> > +                     return;
> > +             pt =3D (unsigned long *)(pte & PT_ADDR_MASK);
> > +     }
> > +
> > +     if (!bad_pt_ad)
> > +             report_pass("NPT - guest page table structures A=3D%d/D=
=3D%d",
> > +                         !!(expected_pt_ad & PT_ACCESSED_MASK),
> > +                         !!(expected_pt_ad & PT_DIRTY_MASK));
> > +
> > +     offset =3D PGDIR_OFFSET(guest_addr, l);
> > +     offset_in_page =3D guest_addr &  ((1 << PGDIR_BITS(l)) - 1);
> > +     gpa =3D (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_pag=
e);
> > +
> > +     npt_pte =3D npt_get_pte(gpa);
> > +
> > +     if (!npt_pte) {
> > +             report_fail("NPT - guest physical address is not mapped")=
;
> > +             return;
> > +     }
> > +     report((*npt_pte & PT_AD_MASK) =3D=3D expected_gpa_ad,
> > +            "NPT - guest physical address A=3D%d/D=3D%d",
> > +            !!(expected_gpa_ad & PT_ACCESSED_MASK),
> > +            !!(expected_gpa_ad & PT_DIRTY_MASK));
> > +}

Changes have been included in
https://lore.kernel.org/all/20251219225908.334766-3-chengkev@google.com/.
Thanks Sean!

