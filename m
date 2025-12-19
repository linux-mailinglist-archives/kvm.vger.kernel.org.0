Return-Path: <kvm+bounces-66426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B8CCD22AB
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 00:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6AD32301CDBD
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BE425F7A9;
	Fri, 19 Dec 2025 23:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OZIyLotZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BED3A1E60
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 23:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185335; cv=none; b=Wjx/rGvIS77oAAMa2cJvAR3NL4RkSCl7442eRxTL2Lws8/2P4v9d6uGkoaf39mVmgReh9yzytil6jd/ZbAeTJlb3h+7jDNvEqsGakoY0eFN7UdLHA+lKOpLc46j3POGCkOdWeN3aJt4rkYrVDsIps8nZR6CHg80TOhbC41pOpjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185335; c=relaxed/simple;
	bh=nsQA/ycRS9XzbdCu+SZf9Qz/v+PMVcOwrlX6N1/jPg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hft7gBX3+z0bRbwYYZlkbFvqd2f/6pLKtZAlJlV370WmQQG2jyrJh00Q9fUwMf3jvB8B29y8lUqYeQ43NxNyHRVj4Xq0lljaeOXlERMYfLWOZBUNd4gJaRSb1tde89ry2PlhH229HHGNZHVLvq8Dhl9GFXcMMiH7K4uDROfVXfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OZIyLotZ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477632d9326so13852275e9.1
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185330; x=1766790130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UyKHAk1r1LuDAgT6QbvZzfY9Y4PlIhYbLpyvbOnwNJI=;
        b=OZIyLotZy/WNC7L0h6PmAoNLet+u+63gQ3CVeIZxoqonJEfU7Avk6wLyc0+8i4g8yJ
         RVqt+NBW9qhkIO0q2NF4tqZBqPIMjfq1O8sd0Ii7s1ovX3+9q2oIQFXCzZecwPliK+Lf
         H4pU7Hq79wzzgemVLBPggvJKDavOuVuZHRilyc4rOdVD+McFPB0gD9R91IhSkIH8qO7c
         0C7wBc2/LXBR/BBRBLFVXoIYhAK7rnJS2ooGKWU1ejXkPwvvBqVCBE5sx6BP0HtV+N63
         yuPh3yBvMYu9Mb85Nzppfq0fRMwTVMqfHKWPeHSwuURBGog/oFtr3ezw5DB+zacHVAg4
         +AwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185330; x=1766790130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UyKHAk1r1LuDAgT6QbvZzfY9Y4PlIhYbLpyvbOnwNJI=;
        b=VyiVYhhUBWYXjklLC+3nqUm9w6SRp+fc2dh5conQX8vEXdYpJN0J3HZfkSbpC0H9nw
         7TNlvEv8DxSUGqDvWD0NAZ8jTOigCxFmr7D3M/TAIqo8tQFRY90AxGAH1h7YYQRqRuQq
         lAJtynnXd6+rMbQFZeMWyKVT+DITJZYOtnSRoDGTduKm5XxwCUVRIdDO3by2PntpqpgX
         9bu3szzzMt4UZnb6CpYwyocKPxENZqJynLcf4tOEtcpT4pRbYvBs03TzCr1bKpqwIaEm
         +nFgGCYcwSC6rWuYYdDvPhCbMjgVdPzyRprUUUlRNAv8bYXRRxXgg8TchI2tpIna8Wm+
         EPtg==
X-Gm-Message-State: AOJu0YwrN9wg7vp7mHxfAnSyLgc2fBJARLZIpgU0eps5hZhf5D4Panup
	NTOwWSSAIegUF9NXRC1s5XaxgdzNSn9iwBj/tPsG7S8gU4qCXsHoNphyXgNs8QQldC5wpPSh9/i
	bRr239ZoKI2dBgdd2FyI1OYhHQQ57kyRmclIRzogVW6NbOk5g8+3G/5IlSFM=
X-Gm-Gg: AY/fxX5seZSV1Npt1443MMdJdw0+C64N6vEZ0QLbsGrevWT74xpbTSEUhM+v3C943kJ
	dyxZB2oehReGVrYfMtOy+pMH0q8Hh2EBAAdPfJ9/prvSPKEJ4pD0gLomsUrVzMZY1J28PR3T247
	JrBSqIpTqAY1x2OjvtLnsPbYziW7Fzm8fickPlR+brQJUmy/t3TFkTKHQonwIEU0BUSBXgA//YW
	CITzp4L7ZUUWS6TIqIAreeCKVgYDRO6b8apjRpxtnd+sFx+MIAgXJUl9ta6DMqyDDp9MspGH0gY
	hhLipGoyStIRCRha01dSgrE6Ens/cUVLry1J8kI=
X-Google-Smtp-Source: AGHT+IHtYG8RpGaLwTsBAgzraMps3C2lVJJTjkINs7WtdR6ezXVePzMN+2C/2Xg/4g+ZXvioB7MXuf/VKmXbC3CITi4=
X-Received: by 2002:a5d:4e46:0:b0:430:fe22:5f1c with SMTP id
 ffacd0b85a97d-4324e703af5mr3563577f8f.59.1766185330000; Fri, 19 Dec 2025
 15:02:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820162951.3499017-1-chengkev@google.com>
In-Reply-To: <20250820162951.3499017-1-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Fri, 19 Dec 2025 18:01:58 -0500
X-Gm-Features: AQt7F2otoYGdVAPRqg_rHSzJY915qBaobCjNIQuaFL9t1uB2w2aQu6U17LhQXE0
Message-ID: <CAE6NW_amv3AKHAw3NySCKN59V55WOLFkKmUo0hht2MzFFM2KxA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nSVM: Add test for EPT A/D bits
To: kvm@vger.kernel.org
Cc: jmattson@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch has been superseded by a new series:
https://lore.kernel.org/all/20251219225908.334766-1-chengkev@google.com/

Please disregard this standalone version.

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

