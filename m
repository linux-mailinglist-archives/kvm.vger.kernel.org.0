Return-Path: <kvm+bounces-62284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB29C3F9F3
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 12:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F14F64E1A08
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 11:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7BC31BC90;
	Fri,  7 Nov 2025 11:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="RRKF3SmG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7DF26ED51
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 11:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762513431; cv=none; b=W5MQQbMyTsgyK1+WNX3LLdiipdE9bQe6+JGIOnsV3vnctmPjF+7nUPA2LIQh9Vi8F5IyfyqUXlZm7Oy3SI5534EcjzUzz0Eg7peAcVcO72WDDSDkATaV+opQF6geWE78PEWC3kpPbx1YsY9RAHp1RFQfmniNumbtzGC6bqFLF7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762513431; c=relaxed/simple;
	bh=0fw1/YbRWy6gWq68BnCE8l2uBEBd3mCZS6gv/mQw5O8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ORIN0Ho4KVlOT+I9lii3v/VKwb8yLbxpv91IB4/0V/Nf6jkCBbrsc0kwViYat0AT1M7VCgRfGwCoB0aDoIm8agOfWn7xHbqS39wcEhihY4qSUAOOCOGQIPn7NsNmplbifVPg9jppwc1szunTIWVQ/PDK0KfgdaP1d5IT3zC9qhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=RRKF3SmG; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-9483e51d774so20676239f.1
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 03:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1762513429; x=1763118229; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHYVI+8cZwmcaMV+j3m2ndZp/CPeHOqPlXMZfLRT9g4=;
        b=RRKF3SmGutSbZEumZuJG2j+dFhuPXIefqmsWpx5TXKWla8xTSsxDtAVSd7JEEtpv3I
         nXGjbXCfaWeVlc7kTv24oFaC2kS1qk5ubhBReXJse3Yv2YF+LuZmXlblMYRM641L6mXT
         mYEL29UyaIwiVQRXx4sUlS9P8bynjR2/wp5dMrYojr5VHqahdp89wWxPvc/wObfVyc7l
         e2ezTY9zbieZdFHghh3O+yttleuBP/G4zp2XPxBlMrO3W4sojIMlYcpK73E15LxkXaQE
         u3hwvLKmfSiGD6DwKkGoJR9aLLddz2BtWF0Ww7Zz91kW2pUgXYqaV44AHMlH4KX/Y4Pg
         Jk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762513429; x=1763118229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wHYVI+8cZwmcaMV+j3m2ndZp/CPeHOqPlXMZfLRT9g4=;
        b=PxESyDjR09R1qprvnulK0Cha3f651oTfh05qE5Xys47s66eOIjTClflqMtkQd4NrNm
         RFn2itXuMQuzeq7rN3XJhjZwrxxDgehOSpzOvu/s42BETef9U1ZAFUnsGfDuVZIzPXv3
         yHq0UM1ugm0nxJjQIXHTeZL2UIkQrZbddBfIQaSNsaihSQoE+qaI+/X5ZBLXpJVssCLi
         aFMKOVd6Ht8W2bLXkHN3ngPTRmfrrxyrM+bmKNF0ZTFRVCGev5eH0RLNvf8OlZ8+sWfC
         z3ctlfNkE1fnkxKVyfEeFHhhZogGjXf01yqVvJsOUMEkVPit91hOfS6T/nR42nHysfD4
         E+sw==
X-Forwarded-Encrypted: i=1; AJvYcCUNIanT7CEY3wAZaiEJNwKbzXExGZwnp8o3y5kmcaGEt+TzjAfqVhyRxsfPhSIrjScxoDk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5Au8OScz/3R+hjju1OMfnWQrMw/o26aTJX7gHuYsp4VzeesKV
	yFgxNfhy/B5NcMcnK8kxe1VO3KQAY5NaefbdiQnUZMyCAonpu3sjadHpO1dza/RnyBLC6VjKukO
	1RhTiqhXmWqzf3PB/NUsdmlYpomZjJCKpEOTyClEQsw==
X-Gm-Gg: ASbGncunvHgaHVdH6kg2LUnp2IbEe6WBgeeAGB5JxVoIv/oGL4/vI4YEKJJ7GVeMZUr
	Q9kcBbhmOCabpR+iUNYzfwmUsgQyhCow/wQAWHPGAUterPiVRzhd2vmgad+Rj+dMZqoScfFX9uw
	mmjzaPTgnZMHhr3tVARt0aH6juoR2nMO/T+KUbqRzqLX8pokzoNlBbQTlBAKPhotQtrRU5DXysS
	rQzrZCDFYPcYfsUZnEAIww4iwV9CP4CoTp5X/9dhq2C/P9OCFT3sWDCtkY+B2fWgsONdoQj
X-Google-Smtp-Source: AGHT+IFtcA147LKxgqVhXLwksm/C9cqoMFmxz+pjS9Ugqk04E6hCfo3BhIC9tYqTe4/PzGza7zQwdYHoqwV6apXMQ6Y=
X-Received: by 2002:a92:ce05:0:b0:433:2499:92f8 with SMTP id
 e9e14a558f8ab-433629909d2mr10843565ab.5.1762513429091; Fri, 07 Nov 2025
 03:03:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202509301520545960_jMIljfZY7bMHBkBbaHR@zte.com.cn>
In-Reply-To: <202509301520545960_jMIljfZY7bMHBkBbaHR@zte.com.cn>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 7 Nov 2025 16:33:38 +0530
X-Gm-Features: AWmQ_bmTbcoZymk1iItPjpuqlNXRDDtkY0L31utCtpv82eMgZLUJ2JB8cmAcIn4
Message-ID: <CAAhSdy1u0MkWqreL-fDYZq3KvpAVFPefK0osJ7tai1oXGSyw7w@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Transparent huge page support
To: liu.xuemei1@zte.com.cn
Cc: atish.patra@linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025 at 12:51=E2=80=AFPM <liu.xuemei1@zte.com.cn> wrote:
>
> From: Jessica Liu <liu.xuemei1@zte.com.cn>
>
> Use block mapping if backed by a THP, as implemented in architectures
> like ARM and x86_64.
>
> Signed-off-by: Jessica Liu <liu.xuemei1@zte.com.cn>
> ---
> Changes in v2:
> - Fixed the typo of writing PAGE_SHIFT as PAGE_SIZE.
>
>  arch/riscv/include/asm/kvm_gstage.h |   3 +
>  arch/riscv/kvm/gstage.c             | 100 ++++++++++++++++++++++++++++
>  arch/riscv/kvm/mmu.c                |  12 +++-
>  3 files changed, 114 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm=
/kvm_gstage.h
> index 595e2183173e..cc67fb2d2d42 100644
> --- a/arch/riscv/include/asm/kvm_gstage.h
> +++ b/arch/riscv/include/asm/kvm_gstage.h
> @@ -69,4 +69,7 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstag=
e, gpa_t start, gpa_t end
>
>  void kvm_riscv_gstage_mode_detect(void);
>
> +long kvm_riscv_gstage_thp_adjust(struct kvm *kvm, struct kvm_memory_slot=
 *memslot,
> +                                unsigned long hva, kvm_pfn_t *pfnp, gpa_=
t *gpa);
> +
>  #endif
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index 24c270d6d0e2..129dee62c570 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -77,6 +77,106 @@ static int gstage_level_to_page_size(u32 level, unsig=
ned long *out_pgsize)
>         return 0;
>  }
>
> +static int gstage_get_user_mapping_size(struct kvm *kvm, u64 addr)
> +{
> +       pte_t *ptepp;
> +       u32 ptep_level;
> +       unsigned long out_pgsize;
> +       struct kvm_gstage gstage =3D {
> +               .pgd =3D kvm->mm->pgd
> +       };
> +
> +       if (!kvm_riscv_gstage_get_leaf(&gstage, addr, &ptepp, &ptep_level=
))
> +               return -EFAULT;
> +
> +       if (gstage_level_to_page_size(ptep_level, &out_pgsize))
> +               return -EFAULT;
> +
> +       return out_pgsize;
> +}
> +
> +static bool gstage_supports_huge_mapping(struct kvm_memory_slot *memslot=
, unsigned long hva)
> +{
> +       gpa_t gpa_start;
> +       hva_t uaddr_start, uaddr_end;
> +       size_t size;
> +
> +       size =3D memslot->npages * PAGE_SIZE;
> +       uaddr_start =3D memslot->userspace_addr;
> +       uaddr_end =3D uaddr_start + size;
> +
> +       gpa_start =3D memslot->base_gfn << PAGE_SHIFT;
> +
> +       /*
> +        * Pages belonging to memslots that don't have the same alignment
> +        * within a PMD for userspace and GPA cannot be mapped with g-sta=
ge
> +        * PMD entries, because we'll end up mapping the wrong pages.
> +        *
> +        * Consider a layout like the following:
> +        *
> +        *    memslot->userspace_addr:
> +        *    +-----+--------------------+--------------------+---+
> +        *    |abcde|fgh  vs-stage block  |    vs-stage block tv|xyz|
> +        *    +-----+--------------------+--------------------+---+
> +        *
> +        *    memslot->base_gfn << PAGE_SHIFT:
> +        *      +---+--------------------+--------------------+-----+
> +        *      |abc|def  g-stage block  |    g-stage block   |tvxyz|
> +        *      +---+--------------------+--------------------+-----+
> +        *
> +        * If we create those g-stage blocks, we'll end up with this inco=
rrect
> +        * mapping:
> +        *   d -> f
> +        *   e -> g
> +        *   f -> h
> +        */
> +       if ((gpa_start & (PMD_SIZE - 1)) !=3D (uaddr_start & (PMD_SIZE - =
1)))
> +               return false;
> +
> +       /*
> +        * Next, let's make sure we're not trying to map anything not cov=
ered
> +        * by the memslot. This means we have to prohibit block size mapp=
ings
> +        * for the beginning and end of a non-block aligned and non-block=
 sized
> +        * memory slot (illustrated by the head and tail parts of the
> +        * userspace view above containing pages 'abcde' and 'xyz',
> +        * respectively).
> +        *
> +        * Note that it doesn't matter if we do the check using the
> +        * userspace_addr or the base_gfn, as both are equally aligned (p=
er
> +        * the check above) and equally sized.
> +        */
> +       return (hva >=3D ALIGN(uaddr_start, PMD_SIZE)) && (hva < ALIGN_DO=
WN(uaddr_end, PMD_SIZE));
> +}
> +
> +long kvm_riscv_gstage_thp_adjust(struct kvm *kvm, struct kvm_memory_slot=
 *memslot,
> +                                unsigned long hva, kvm_pfn_t *hfnp, gpa_=
t *gpa)
> +{
> +       kvm_pfn_t hfn =3D *hfnp;
> +
> +       /*
> +        * Make sure the adjustment is done only for THP pages. Also make
> +        * sure that the HVA and GPA are sufficiently aligned and that th=
e
> +        * block map is contained within the memslot.
> +        */
> +       if (gstage_supports_huge_mapping(memslot, hva)) {
> +               int sz =3D gstage_get_user_mapping_size(kvm, hva);
> +
> +               if (sz < 0)
> +                       return sz;
> +
> +               if (sz < PMD_SIZE)
> +                       return PAGE_SIZE;
> +
> +               *gpa &=3D PMD_MASK;
> +               hfn &=3D ~(PTRS_PER_PMD - 1);
> +               *hfnp =3D hfn;
> +
> +               return PMD_SIZE;
> +       }
> +
> +       return PAGE_SIZE;
> +}
> +

The gstage.c is for common page table management which will be
shared by nested virtualization and pKVM. whereas mmu.c is for
host/hypervisor mappings.

All above functions except gstage_get_user_mapping_size() must
be moved to mmu.c.

Also, change prototype of gstage_get_user_mapping_size() to
int kvm_riscv_gstage_get_mapping_size(struct kvm_gstage *gstage, gpa_t addr=
);

>  bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
>                                pte_t **ptepp, u32 *ptep_level)
>  {
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 525fb5a330c0..f70cf721ebb8 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -337,7 +337,8 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct k=
vm_memory_slot *memslot,
>         struct kvm_mmu_memory_cache *pcache =3D &vcpu->arch.mmu_page_cach=
e;
>         bool logging =3D (memslot->dirty_bitmap &&
>                         !(memslot->flags & KVM_MEM_READONLY)) ? true : fa=
lse;
> -       unsigned long vma_pagesize, mmu_seq;
> +       unsigned long mmu_seq;
> +       long vma_pagesize;
>         struct kvm_gstage gstage;
>         struct page *page;
>
> @@ -416,6 +417,15 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct =
kvm_memory_slot *memslot,
>         if (mmu_invalidate_retry(kvm, mmu_seq))
>                 goto out_unlock;
>
> +       /* check if we are backed by a THP and thus use block mapping if =
possible */
> +       if (vma_pagesize =3D=3D PAGE_SIZE) {
> +               vma_pagesize =3D kvm_riscv_gstage_thp_adjust(kvm, memslot=
, hva, &hfn, &gpa);
> +               if (vma_pagesize < 0) {
> +                       ret =3D vma_pagesize;
> +                       goto out_unlock;
> +               }
> +       }
> +
>         if (writable) {
>                 mark_page_dirty_in_slot(kvm, memslot, gfn);
>                 ret =3D kvm_riscv_gstage_map_page(&gstage, pcache, gpa, h=
fn << PAGE_SHIFT,
> --
> 2.27.0
>

Regards,
Anup

