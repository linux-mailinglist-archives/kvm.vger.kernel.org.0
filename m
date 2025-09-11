Return-Path: <kvm+bounces-57356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B95B53C1D
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 21:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13ADE1BC1C4D
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 19:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82FF255240;
	Thu, 11 Sep 2025 19:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UASm7bhX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32A4DDC3
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 19:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757617670; cv=none; b=SbJi7zY8DOh/gSVF/aN3jFOESM4ewRifazVMV9LHLAltEPXpzCCg3gEQG9CgC3PqpXWHMLcMZftzVoJWn5OG/i1KefcKdXlgZNZu20MYnovlgjsekM1Jpsq5Oafg2LXWEwwL2B6RO9hsffYqzh8a/tYZsaWDGnD10NeUo7r10s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757617670; c=relaxed/simple;
	bh=GR+IHsE9oBmwigop+GH/3AYSODF6ijZ1nNphFEkAYkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fA+lckhBxvfikA+5TfUvn3UQO7qA18cbKpMEQOaJM0onftePs8DgRQsnQAM15rvkiDIXqvFe8SjFt6D6CM0zwkmOlKPZfhHxju1uNOaLJFloWzb2IwNJjm87BMjvEPdvP5d9zTgweCHIMiSnunfzZFuudwBUbfx4RSgU5UyVBvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UASm7bhX; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3e7512c8669so839803f8f.0
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 12:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757617667; x=1758222467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZRbKJycM2io7uxPT6KucD+qPlNXKj3c25lQCd0KEBU=;
        b=UASm7bhXHQFD1rDCfckuYCE1IVWkHbkzcpXevbCOrtR0OQGl4ZVuIpE8Nn5Do9+xiL
         7UkDbR3YJCRUc5kRfitxgJrFP/EH1U1UtZZcUiyWPJcyXqpiRZ3N09RbOrWU/JWmAAQ/
         Icm5t9sqr6YuMR1ikuQoUxf34WrXRFTRF/R893zPmw3qDLxmemMvCVSJ0nfiiCUpBA8C
         VEQHA1poUMDo9jzkvbtbo0fQic0a6gHoTzK2HieRlD7qk6B8oE4IHJ/jgjbTNgOKroc/
         SHtYWVIYXJX/Awl32ucllz7keHUvAYq7yKOeT6p7Y+2xtEgjBbqaUqjPAQcjFlCsNsuI
         Du4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757617667; x=1758222467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bZRbKJycM2io7uxPT6KucD+qPlNXKj3c25lQCd0KEBU=;
        b=iRld1+h4C/6dahePUcN41QvB6WaqAVNFrWKZ+BRPh1LA0y3ufDo4JPJuIXs0I50Aey
         O1jtHMGJEA7nnvEHFr0Kid+t6BVzwLqCKAxyMLj1CCR2Ul+M54QEcE3Meco8jCaaMRWR
         hSm6ci52m+9ozWnpm6XJzh8V2ye7saDfhm1ZPwPIe3MFiZJ9cscCtS+LMi8zmaLmnFvl
         BmnvA3LLcwzyAean0vgQuZnRFBC4xWB1bSlHnDi+BXDtNik19UR2h/9XRogTQf++iYTQ
         yFBS+5gyogtLfRjOLg34b7FWbsFncuW+a10kQKnc4uFnAPvtFh6oakgr7Ydb6AkFiyhQ
         3pqg==
X-Gm-Message-State: AOJu0YwMLoVbyAofVHAYAKKO0u5E0/TpWZU/GoU581p9iwLI2H1kZFla
	gXHgd/KHnFRNXQz48aW+SzXNjw2wE8f3Sfe14Orb0BIbdvSu/FCNMbRQ42fqZg+4eoqM10sJJrm
	JaCqVmk5DhMPzVQ3iJVjLphFyPhMbFyDeE0gzZZI6+I3/WcwWFd/bF+iE
X-Gm-Gg: ASbGncs9lk9Etb+1VyX6RSxzJ0B6cwPe1chFiNQSj0ZDbnn932fggABXMzlPWJGETUJ
	09uiHJ426AX6EFRLtxP43WXqbtUl0tOzkrPUABWka91yLDDasz5ESOIhy1L4rP/vsDk6o/gOGjx
	Wzs80er+1hh0DSc33A9efU0MSZwVTnlsMdyYym0QlPMlWjtZx1EYdeOtbYjGz/coboucEXjxUOY
	fv76TPQVS41slqru7OtPloKq3jCBqI1FLcksL8CSRK8m9BBJ+HEtIpZVLQ=
X-Google-Smtp-Source: AGHT+IH7BTmXvhH3ZTAo5vJFtFj4rVvX2wrwBrcxJlcwQbdbwbdsXI3pcc0FUbiYCLuOzAS7fIkLEYs+15CAu4NtiqM=
X-Received: by 2002:a05:6000:2203:b0:3e7:652e:a49d with SMTP id
 ffacd0b85a97d-3e765a26199mr396642f8f.46.1757617666798; Thu, 11 Sep 2025
 12:07:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820162951.3499017-1-chengkev@google.com>
In-Reply-To: <20250820162951.3499017-1-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Thu, 11 Sep 2025 15:07:35 -0400
X-Gm-Features: AS18NWDlMma3W2waVgcQCHfqTo9p8Qu6FXlXKypPi_1l7HlH6tr3Dxpb_x90ofM
Message-ID: <CAE6NW_Y2U_vgcagQeopLCdAno5Yf+nmjsauczv5gL8DB5ejMmA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nSVM: Add test for EPT A/D bits
To: kvm@vger.kernel.org
Cc: jmattson@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 12:29=E2=80=AFPM Kevin Cheng <chengkev@google.com> =
wrote:
>
> The nVMX tests already have coverage for TDP A/D bits. Add a
> similar test for nSVM to improve test parity between nSVM and nVMX.
>
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  x86/svm.c     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  x86/svm.h     |  5 +++
>  x86/svm_npt.c | 46 +++++++++++++++++++++++++
>  3 files changed, 144 insertions(+)
>
> diff --git a/x86/svm.c b/x86/svm.c
> index e715e270..53b78d16 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -14,6 +14,8 @@
>  #include "isr.h"
>  #include "apic.h"
>
> +#include <asm/page.h>
> +
>  /* for the nested page table*/
>  u64 *pml4e;
>
> @@ -43,6 +45,97 @@ u64 *npt_get_pml4e(void)
>         return pml4e;
>  }
>
> +void clear_npt_ad(unsigned long *pml4e, u64 guest_cr3,
> +                 unsigned long guest_addr)
> +{
> +       int l;
> +       unsigned long *pt =3D (unsigned long *)guest_cr3, gpa;
> +       u64 *npt_pte, pte, offset_in_page;
> +       unsigned offset;
> +
> +       for (l =3D PAGE_LEVEL; ; --l) {
> +               offset =3D PGDIR_OFFSET(guest_addr, l);
> +               npt_pte =3D npt_get_pte((u64) &pt[offset]);
> +
> +               if(!npt_pte) {
> +                       printf("NPT - guest level %d page table is not ma=
pped.\n", l);
> +                       return;
> +               }
> +
> +               *npt_pte &=3D ~(PT_AD_MASK);
> +
> +               pte =3D pt[offset];
> +               if (l =3D=3D 1 || (l < 4 && (pte & PT_PAGE_SIZE_MASK)))
> +                       break;
> +               if (!(pte & PT_PRESENT_MASK))
> +                       return;
> +               pt =3D (unsigned long *)(pte & PT_ADDR_MASK);
> +       }
> +
> +       offset =3D PGDIR_OFFSET(guest_addr, l);
> +       offset_in_page =3D guest_addr &  ((1 << PGDIR_BITS(l)) - 1);
> +       gpa =3D (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_pag=
e);
> +       npt_pte =3D npt_get_pte(gpa);
> +       *npt_pte &=3D ~(PT_AD_MASK);
> +}
> +
> +void check_npt_ad(unsigned long *pml4e, u64 guest_cr3,
> +       unsigned long guest_addr, int expected_gpa_ad,
> +       int expected_pt_ad)
> +{
> +       int l;
> +       unsigned long *pt =3D (unsigned long *)guest_cr3, gpa;
> +       u64 *npt_pte, pte, offset_in_page;
> +       unsigned offset;
> +       bool bad_pt_ad =3D false;
> +
> +       for (l =3D PAGE_LEVEL; ; --l) {
> +               offset =3D PGDIR_OFFSET(guest_addr, l);
> +               npt_pte =3D npt_get_pte((u64) &pt[offset]);
> +
> +               if(!npt_pte) {
> +                       printf("NPT - guest level %d page table is not ma=
pped.\n", l);
> +                       return;
> +               }
> +
> +               if (!bad_pt_ad) {
> +                       bad_pt_ad |=3D (*npt_pte & PT_AD_MASK) !=3D expec=
ted_pt_ad;
> +                       if(bad_pt_ad)
> +                               report_fail("NPT - received guest level %=
d page table A=3D%d/D=3D%d",
> +                                           l,
> +                                           !!(expected_pt_ad & PT_ACCESS=
ED_MASK),
> +                                           !!(expected_pt_ad & PT_DIRTY_=
MASK));
> +               }
> +
> +               pte =3D pt[offset];
> +               if (l =3D=3D 1 || (l < 4 && (pte & PT_PAGE_SIZE_MASK)))
> +                       break;
> +               if (!(pte & PT_PRESENT_MASK))
> +                       return;
> +               pt =3D (unsigned long *)(pte & PT_ADDR_MASK);
> +       }
> +
> +       if (!bad_pt_ad)
> +               report_pass("NPT - guest page table structures A=3D%d/D=
=3D%d",
> +                           !!(expected_pt_ad & PT_ACCESSED_MASK),
> +                           !!(expected_pt_ad & PT_DIRTY_MASK));
> +
> +       offset =3D PGDIR_OFFSET(guest_addr, l);
> +       offset_in_page =3D guest_addr &  ((1 << PGDIR_BITS(l)) - 1);
> +       gpa =3D (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_pag=
e);
> +
> +       npt_pte =3D npt_get_pte(gpa);
> +
> +       if (!npt_pte) {
> +               report_fail("NPT - guest physical address is not mapped")=
;
> +               return;
> +       }
> +       report((*npt_pte & PT_AD_MASK) =3D=3D expected_gpa_ad,
> +              "NPT - guest physical address A=3D%d/D=3D%d",
> +              !!(expected_gpa_ad & PT_ACCESSED_MASK),
> +              !!(expected_gpa_ad & PT_DIRTY_MASK));
> +}
> +
>  bool smp_supported(void)
>  {
>         return cpu_count() > 1;
> diff --git a/x86/svm.h b/x86/svm.h
> index c1dd84af..1a83d778 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -415,6 +415,11 @@ u64 *npt_get_pte(u64 address);
>  u64 *npt_get_pde(u64 address);
>  u64 *npt_get_pdpe(u64 address);
>  u64 *npt_get_pml4e(void);
> +void clear_npt_ad(unsigned long *pml4e, u64 guest_cr3,
> +                 unsigned long guest_addr);
> +void check_npt_ad(unsigned long *pml4e, u64 guest_cr3,
> +                 unsigned long guest_addr, int expected_gpa_ad,
> +                 int expected_pt_ad);
>  bool smp_supported(void);
>  bool default_supported(void);
>  bool vgif_supported(void);
> diff --git a/x86/svm_npt.c b/x86/svm_npt.c
> index bd5e8f35..abf44eb0 100644
> --- a/x86/svm_npt.c
> +++ b/x86/svm_npt.c
> @@ -380,6 +380,51 @@ skip_pte_test:
>         vmcb->save.cr4 =3D sg_cr4;
>  }
>
> +static void npt_ad_read_guest(struct svm_test *test)
> +{
> +       u64 *data =3D (void *)(0x80000);
> +       (void)*(volatile u64 *)data;
> +}
> +
> +static void npt_ad_write_guest(struct svm_test *test)
> +{
> +       u64 *data =3D (void *)(0x80000);
> +       *data =3D 0;
> +}
> +
> +static void npt_ad_test(void)
> +{
> +       u64 *data =3D (void *)(0x80000);
> +       u64 guest_cr3 =3D vmcb->save.cr3;
> +
> +       if (!npt_supported()) {
> +               report_skip("NPT not supported");
> +               return;
> +       }
> +
> +       clear_npt_ad(npt_get_pml4e(), guest_cr3, (unsigned long)data);
> +
> +       check_npt_ad(npt_get_pml4e(), guest_cr3, (unsigned long)data, 0, =
0);
> +
> +       test_set_guest(npt_ad_read_guest);
> +       svm_vmrun();
> +
> +       check_npt_ad(npt_get_pml4e(), guest_cr3,
> +                    (unsigned long)data,
> +                    PT_ACCESSED_MASK,
> +                    PT_AD_MASK);
> +
> +       test_set_guest(npt_ad_write_guest);
> +       svm_vmrun();
> +
> +       check_npt_ad(npt_get_pml4e(), guest_cr3,
> +                    (unsigned long)data,
> +                    PT_AD_MASK,
> +                    PT_AD_MASK);
> +
> +       clear_npt_ad(npt_get_pml4e(), guest_cr3, (unsigned long)data);
> +}
> +
>  #define NPT_V1_TEST(name, prepare, guest_code, check)                   =
       \
>         { #name, npt_supported, prepare, default_prepare_gif_clear, guest=
_code, \
>           default_finished, check }
> @@ -395,6 +440,7 @@ static struct svm_test npt_tests[] =3D {
>         NPT_V1_TEST(npt_l1mmio, npt_l1mmio_prepare, npt_l1mmio_test, npt_=
l1mmio_check),
>         NPT_V1_TEST(npt_rw_l1mmio, npt_rw_l1mmio_prepare, npt_rw_l1mmio_t=
est, npt_rw_l1mmio_check),
>         NPT_V2_TEST(svm_npt_rsvd_bits_test),
> +       NPT_V2_TEST(npt_ad_test),
>         { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
>
> --
> 2.51.0.261.g7ce5a0a67e-goog
>

Just checking in as it's been a couple weeks :) If there is anyone
else who would be better suited to take a look at these please let me
know and I can cc them as well!

