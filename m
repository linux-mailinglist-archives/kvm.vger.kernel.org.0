Return-Path: <kvm+bounces-67524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A486D0782D
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 08:09:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 549D93026AAE
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 07:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBA92E22AA;
	Fri,  9 Jan 2026 07:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="LObsfW+E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C1E1C3C08
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 07:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767942565; cv=none; b=in1So4ba5FcSSiV78iWpR4P/QLDEz1XHhsC55/5F5XJAJOPsgENt/SV/iwtTDIIor/RT31RldQyltO3M/486KnWjt5xUT7Gu1tZVnuSLi1+ygvt3cyIaWvtUdBMIfZeq54o1GqVhQvOWyJ05haxAxfYMfXT6BdKxaZqEq0QlnHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767942565; c=relaxed/simple;
	bh=YFgIynCVXZRSOkrlPL8O4gOweZpRLXGu6CCOXkXoBeA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tW8YkbRBFN/zFRRgyULEsaFWwBN/6dYLjMEN5w5Hwfh7WKl6RgTBsvLHa0Xdin6x3Y34m2c9ZzCnAK1o4mbcNZxnO0pvFTFpNazlmKhQ0a6HNrnza1t+CDPxWLwn7yvi4uIkt66MYTDxX5LJYn+b4MrFxJBpawUMJOQwzV6Zmk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=LObsfW+E; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-65f59501dacso1443733eaf.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 23:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767942562; x=1768547362; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3hq+fSQfjHo9xTaflofyEl1PRO7ppJLW7nFwrGAnmk=;
        b=LObsfW+E9kFnGEgGfz6QrlB9uf/+T7PaPw9o2yt40UU6mVCXhessB4jFv+mmCaEYLr
         arjtfzWG0Kr3SuZ15gc8RkGK8/nqsVdTpVsm9SHXLoGSzTv5O3PEE4GnU8ugzLC2e8Vm
         SF0MFgG506iogn7z/y0ubXn5Ce6pMXaHVDab58Qs5jiFOfFXYAHPogvT8UIIAIhU/mWT
         ilHBHb4ZBkiPGX7rZ1jwilp1AmC5caS8vSKCNkGCm6k2zdvhOhAnPlB+XdaNV0cmpe9R
         BDv0wQB/hxzgpTS7KdMB+jVBT7mrT0f2YS/Pu31UFUTZCaeFxxGUkTU6LR6I9AmpzA35
         ummQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767942562; x=1768547362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L3hq+fSQfjHo9xTaflofyEl1PRO7ppJLW7nFwrGAnmk=;
        b=kzfKAKHZeM62KAamiZOVKEEwVFbjj1UbcfTwAg7vfvgqJzWmmqE9gBQwsiguozrQwe
         5/oGzHf40gj8E8kiI2GQEXO3kh1j04edwwrfKpjUJPDbM+AB8ImnGHOs8DPMDDsBSQ9z
         eUfZJLpROc7xyqscEXdvTPf84LRCc1CmXZPOSZffh+J8o0BoCuTEscPlSkIZDAz6TdDZ
         307FVJfbTCUx3Z3fOrGc6RXQwHWbs0ef0it4erw5zZvsnKy9KVoTJ78Sos7fFAqCknIw
         ef9rcGFdTZ99BNOsPLH61T1LnPDP8CJzQT0RUu5RPYFieayk2l3PZqdeb37p3eHXv2r/
         wHcA==
X-Forwarded-Encrypted: i=1; AJvYcCUWrC2FlWBbVGJ6c7q3zACOYpmrS8HJkyZq6jw94ll2ijW5kMJifOh7Hed4dwifLvoQLls=@vger.kernel.org
X-Gm-Message-State: AOJu0YydHvp39uAVYjPIfYeo0KwD64XxFoM6Nv3VfKFJHks2Gn2RtiKo
	WXiPgdCT0Rp5egeXZ6NTQYuwSciPeHhg+xoMljHHOfjP83i6k68t1RRJK4XyQ843XqsJLc4nvSU
	KXlc9Bw/tu7n2nnh8ONVHJdkV1XIJEPvWK9RjY/i2dw==
X-Gm-Gg: AY/fxX6xKhlFzXY6dCzWqRvun/RrtZBJch46U5OMS4SE5TqcdhO5SMDnn/FJyrhJgQt
	veOFrUhLDCyflox/YPNIDTis8Y4Q8FCqdcwJwa8JLbNKp/lUETtxXAnP5WVbB6/Hk7juViADowE
	Fut4IwxW9iCXs1gg9uO/CdJRX6yOabbzFl9XlkHZlFquX1wHQHc0tsYQXe4oWpMnhWfw3giHXxj
	d9yrjeNSvK7NLpslUF/yFgY/MyGUZLkHlzX9sFpkbQxagtsPDd0Q0aaYjhOBiL21KpKSCpgEqLR
	0Hyvs8kWdOhVY4HuewI+6krs7TC/Gt4kJ8gqZ3BnDFBvBVaa3dMUuPakI8ovzAAfZuWO
X-Google-Smtp-Source: AGHT+IHupo8VL1q6/fyEDLMw2ffzv5hWRR+8Fks6xECR+bokgZNh1nRbXbrJmRMRMvS/oTFqcbl9t9pnEs1zluFfkec=
X-Received: by 2002:a4a:cb94:0:b0:65f:565a:219d with SMTP id
 006d021491bc7-65f565a3826mr3060334eaf.84.1767942562507; Thu, 08 Jan 2026
 23:09:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251127165137780QbUOVPKPAfWSGAFl5qtRy@zte.com.cn>
In-Reply-To: <20251127165137780QbUOVPKPAfWSGAFl5qtRy@zte.com.cn>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 9 Jan 2026 12:39:10 +0530
X-Gm-Features: AQt7F2qbRS_M-_2pxgYkPVk2hwt92w_Y59xXj3ghAfqt5f49LTkCXhPWOY5KUN8
Message-ID: <CAAhSdy3ANMmRL6KAm5J9Amd8-1GFYpNKG_cC1gZ7Za45XsOrPA@mail.gmail.com>
Subject: Re: [PATCH v4] RISC-V: KVM: Transparent huge page support
To: liu.xuemei1@zte.com.cn
Cc: atish.patra@linux.dev, alex@ghiti.fr, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	inux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 2:22=E2=80=AFPM <liu.xuemei1@zte.com.cn> wrote:
>
> From: Jessica Liu <liu.xuemei1@zte.com.cn>
>
> Use block mapping if backed by a THP, as implemented in architectures
> like ARM and x86_64.
>
> Signed-off-by: Jessica Liu <liu.xuemei1@zte.com.cn>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.20

Thanks,
Anup

> ---
> Changes in v4:
> - Substituted kvm_riscv_gstage_get_mapping_size with get_hva_mapping_size
>
>  arch/riscv/kvm/mmu.c    | 140 ++++++++++++++++++++++++++++++++++++++++
>  arch/riscv/mm/pgtable.c |   2 +
>  2 files changed, 142 insertions(+)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 58f5f3536ffd..38816c5895fe 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -302,6 +302,142 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_g=
fn_range *range)
>         return pte_young(ptep_get(ptep));
>  }
>
> +static bool fault_supports_gstage_huge_mapping(struct kvm_memory_slot *m=
emslot,
> +                                              unsigned long hva)
> +{
> +       hva_t uaddr_start, uaddr_end;
> +       gpa_t gpa_start;
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
> +static int get_hva_mapping_size(struct kvm *kvm,
> +                               unsigned long hva)
> +{
> +       int size =3D PAGE_SIZE;
> +       unsigned long flags;
> +       pgd_t pgd;
> +       p4d_t p4d;
> +       pud_t pud;
> +       pmd_t pmd;
> +
> +       /*
> +        * Disable IRQs to prevent concurrent tear down of host page tabl=
es,
> +        * e.g. if the primary MMU promotes a P*D to a huge page and then=
 frees
> +        * the original page table.
> +        */
> +       local_irq_save(flags);
> +
> +       /*
> +        * Read each entry once.  As above, a non-leaf entry can be promo=
ted to
> +        * a huge page _during_ this walk.  Re-reading the entry could se=
nd the
> +        * walk into the weeks, e.g. p*d_leaf() returns false (sees the o=
ld
> +        * value) and then p*d_offset() walks into the target huge page i=
nstead
> +        * of the old page table (sees the new value).
> +        */
> +       pgd =3D pgdp_get(pgd_offset(kvm->mm, hva));
> +       if (pgd_none(pgd))
> +               goto out;
> +
> +       p4d =3D p4dp_get(p4d_offset(&pgd, hva));
> +       if (p4d_none(p4d) || !p4d_present(p4d))
> +               goto out;
> +
> +       pud =3D pudp_get(pud_offset(&p4d, hva));
> +       if (pud_none(pud) || !pud_present(pud))
> +               goto out;
> +
> +       if (pud_leaf(pud)) {
> +               size =3D PUD_SIZE;
> +               goto out;
> +       }
> +
> +       pmd =3D pmdp_get(pmd_offset(&pud, hva));
> +       if (pmd_none(pmd) || !pmd_present(pmd))
> +               goto out;
> +
> +       if (pmd_leaf(pmd))
> +               size =3D PMD_SIZE;
> +
> +out:
> +       local_irq_restore(flags);
> +       return size;
> +}
> +
> +static unsigned long transparent_hugepage_adjust(struct kvm *kvm,
> +                                                struct kvm_memory_slot *=
memslot,
> +                                                unsigned long hva,
> +                                                kvm_pfn_t *hfnp, gpa_t *=
gpa)
> +{
> +       kvm_pfn_t hfn =3D *hfnp;
> +
> +       /*
> +        * Make sure the adjustment is done only for THP pages. Also make
> +        * sure that the HVA and GPA are sufficiently aligned and that th=
e
> +        * block map is contained within the memslot.
> +        */
> +       if (fault_supports_gstage_huge_mapping(memslot, hva)) {
> +               int sz;
> +
> +               sz =3D get_hva_mapping_size(kvm, hva);
> +               if (sz < PMD_SIZE)
> +                       return sz;
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
>  int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *mem=
slot,
>                       gpa_t gpa, unsigned long hva, bool is_write,
>                       struct kvm_gstage_mapping *out_map)
> @@ -395,6 +531,10 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct =
kvm_memory_slot *memslot,
>         if (mmu_invalidate_retry(kvm, mmu_seq))
>                 goto out_unlock;
>
> +       /* check if we are backed by a THP and thus use block mapping if =
possible */
> +       if (vma_pagesize =3D=3D PAGE_SIZE)
> +               vma_pagesize =3D transparent_hugepage_adjust(kvm, memslot=
, hva, &hfn, &gpa);
> +
>         if (writable) {
>                 mark_page_dirty_in_slot(kvm, memslot, gfn);
>                 ret =3D kvm_riscv_gstage_map_page(&gstage, pcache, gpa, h=
fn << PAGE_SHIFT,
> diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
> index 8b6c0a112a8d..fe776f03cc12 100644
> --- a/arch/riscv/mm/pgtable.c
> +++ b/arch/riscv/mm/pgtable.c
> @@ -49,6 +49,7 @@ pud_t *pud_offset(p4d_t *p4d, unsigned long address)
>
>         return (pud_t *)p4d;
>  }
> +EXPORT_SYMBOL_GPL(pud_offset);
>
>  p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
>  {
> @@ -57,6 +58,7 @@ p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
>
>         return (p4d_t *)pgd;
>  }
> +EXPORT_SYMBOL_GPL(p4d_offset);
>  #endif
>
>  #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
> --
> 2.27.0

