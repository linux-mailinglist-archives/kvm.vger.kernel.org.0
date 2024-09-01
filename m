Return-Path: <kvm+bounces-25635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5009674FC
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2024 06:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 655051F21E57
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2024 04:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B79C3611E;
	Sun,  1 Sep 2024 04:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="htsEiqXU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048EB17C
	for <kvm@vger.kernel.org>; Sun,  1 Sep 2024 04:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725165247; cv=none; b=Kf+XBGcqGvgEPyswtfvgHHM40IXpSAdCOnOu/j+LqsCvtqsu3l+xvXw8ufLXKCmXtgVyfuJWrqL38S4VnEY3xGC/G2TfqyakQXjKtTjMnFcduu4bx459hv7WeC6H/Dh4olo8VUhQn5xovKy7gz6AmaLqhNQiTCq7szHuuISvrE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725165247; c=relaxed/simple;
	bh=T4mtg8OVVcl9onqShCy9lLoPf9A4q5m5Q7eAMdYPrIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JfkSWKfPHf9cy0gyOeuX3AaKP9et1kl5mHhT5Fe6x2SGSL8zfSe9LNgzlCi1/O2TBfrP9RtfR9R8/A8aqXDTfFsWT0HYUyP7vij5krbU1QroC/fAtAan4HaLPKGmyRZLD1WlcPyJVDZXFJ9EW14nZPJvewAPj7B63nYoUVL61ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=htsEiqXU; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4fcf4ae95dbso1068188e0c.0
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 21:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725165245; x=1725770045; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8cavqX0K4T8epRFwBR/4Atu+lSqMRFYWZY4pFbhTlcs=;
        b=htsEiqXUPsSqQo8+N8mqCyFvzs7ItArHdEhFFAvh52V5TInHsr5QJvLeO6dCj2mqyl
         sktyDmFxarRTFH0WWJv88uSty1ZnRtk4EQ/rlraizwKHF9p5l3+YLGZ/gk7nZw2+x+38
         eqHnkJxdHtPTa+7o8redj6kcpRgTIJqa8WBKi4wOTOuQev8WdaeBrPZefm+DFXHOM1i6
         tF++EZiGdB7oje7UK/Z2VAv3hdzSKX3XBw2705kLJUROcEpG2Ah7LBZy4J1dpr5UcJCr
         9WtfLwl/nLfxqSJV7dujvqtGM/75MtGZsNkZSphhXbBDhW6tFa1NsBve4+6aIrBfuUsO
         llrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725165245; x=1725770045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8cavqX0K4T8epRFwBR/4Atu+lSqMRFYWZY4pFbhTlcs=;
        b=IgSWFaP08WNJnC1XQ7LGo74cLhV9oe6/swxa237N6qjxqBgO1bdAjaZK5U+2PnSB9n
         C9jslrEJLlqDDLxlTnDHsr1+c4l5NYgA1x/W1QhHme3KeoE40c+htKLM++yJVOTVj403
         /+TlBJWDs0CX9DlbQkP8A5FIWWJmjnjQOGfaFiegP6phE/rTClCUzn4Wo1wCtfhTQkDS
         pqdXVReYbO9SsXTKgYlOMQj06C7+4bbIGUzuo4LQU+VoT1Htp+VbvYuI9lwdfFkcxhk4
         pkxzaHwn/9Y/hvo2b7Xs2Y3VVvjMcx/lZhzrLZO7urJ67fS2uOed+dqEvNH9OxMptDvl
         EFHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzfeLJZhy8preWXiScHnkAg7l4w/7yTTwwYhBEgkHQoQ7Tu9LzHLtTJqyvCLs0bdFgGCI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjj4InvnEaobNU7VRuk/WoysNywceRQQwsk0APaj7GbztxFprT
	os7yeiDbAUV/e3LqL29i+Vb+UhBk4XDO+FojfT0SWusj1wuSyD9avcWHC2NTOzjhozuASzhOGjF
	dGI+slaSZVYn8kejtKL3NL8phRqKjAdyOxtAh
X-Google-Smtp-Source: AGHT+IF4Aez5JXCdT7JaIccNuJhWm549sM1XMAVK6lPzRG6vkbPDXkrMPlWuHjlgeXTaYoCx0OnohoWGF016XeAw5RM=
X-Received: by 2002:a05:6102:440c:b0:493:d41a:1185 with SMTP id
 ada2fe7eead31-49a778e35a1mr5368135137.17.1725165244518; Sat, 31 Aug 2024
 21:34:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826204353.2228736-1-peterx@redhat.com> <20240826204353.2228736-17-peterx@redhat.com>
In-Reply-To: <20240826204353.2228736-17-peterx@redhat.com>
From: Yu Zhao <yuzhao@google.com>
Date: Sat, 31 Aug 2024 22:33:25 -0600
Message-ID: <CAOUHufYfF3BmTZ1r8cdLSU7ddYO20B8M-gFRAn=Hkd=jtQbcng@mail.gmail.com>
Subject: Re: [PATCH v2 16/19] mm: Remove follow_pte()
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, 
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Hildenbrand <david@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2024 at 2:44=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> follow_pte() users have been converted to follow_pfnmap*().  Remove the
> API.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/mm.h |  2 --
>  mm/memory.c        | 73 ----------------------------------------------
>  2 files changed, 75 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 161d496bfd18..b31d4bdd65ad 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2368,8 +2368,6 @@ void free_pgd_range(struct mmu_gather *tlb, unsigne=
d long addr,
>                 unsigned long end, unsigned long floor, unsigned long cei=
ling);
>  int
>  copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *s=
rc_vma);
> -int follow_pte(struct vm_area_struct *vma, unsigned long address,
> -              pte_t **ptepp, spinlock_t **ptlp);
>  int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>                         void *buf, int len, int write);
>
> diff --git a/mm/memory.c b/mm/memory.c
> index b5d07f493d5d..288f81a8698e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6100,79 +6100,6 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, =
unsigned long address)
>  }
>  #endif /* __PAGETABLE_PMD_FOLDED */
>
> -/**
> - * follow_pte - look up PTE at a user virtual address
> - * @vma: the memory mapping
> - * @address: user virtual address
> - * @ptepp: location to store found PTE
> - * @ptlp: location to store the lock for the PTE
> - *
> - * On a successful return, the pointer to the PTE is stored in @ptepp;
> - * the corresponding lock is taken and its location is stored in @ptlp.
> - *
> - * The contents of the PTE are only stable until @ptlp is released using
> - * pte_unmap_unlock(). This function will fail if the PTE is non-present=
.
> - * Present PTEs may include PTEs that map refcounted pages, such as
> - * anonymous folios in COW mappings.
> - *
> - * Callers must be careful when relying on PTE content after
> - * pte_unmap_unlock(). Especially if the PTE maps a refcounted page,
> - * callers must protect against invalidation with MMU notifiers; otherwi=
se
> - * access to the PFN at a later point in time can trigger use-after-free=
.
> - *
> - * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphor=
e
> - * should be taken for read.
> - *
> - * This function must not be used to modify PTE content.
> - *
> - * Return: zero on success, -ve otherwise.
> - */
> -int follow_pte(struct vm_area_struct *vma, unsigned long address,
> -              pte_t **ptepp, spinlock_t **ptlp)
> -{
> -       struct mm_struct *mm =3D vma->vm_mm;
> -       pgd_t *pgd;
> -       p4d_t *p4d;
> -       pud_t *pud;
> -       pmd_t *pmd;
> -       pte_t *ptep;
> -
> -       mmap_assert_locked(mm);
> -       if (unlikely(address < vma->vm_start || address >=3D vma->vm_end)=
)
> -               goto out;
> -
> -       if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> -               goto out;
> -
> -       pgd =3D pgd_offset(mm, address);
> -       if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
> -               goto out;
> -
> -       p4d =3D p4d_offset(pgd, address);
> -       if (p4d_none(*p4d) || unlikely(p4d_bad(*p4d)))
> -               goto out;
> -
> -       pud =3D pud_offset(p4d, address);
> -       if (pud_none(*pud) || unlikely(pud_bad(*pud)))
> -               goto out;
> -
> -       pmd =3D pmd_offset(pud, address);
> -       VM_BUG_ON(pmd_trans_huge(*pmd));
> -
> -       ptep =3D pte_offset_map_lock(mm, pmd, address, ptlp);
> -       if (!ptep)
> -               goto out;
> -       if (!pte_present(ptep_get(ptep)))
> -               goto unlock;
> -       *ptepp =3D ptep;
> -       return 0;
> -unlock:
> -       pte_unmap_unlock(ptep, *ptlp);
> -out:
> -       return -EINVAL;
> -}
> -EXPORT_SYMBOL_GPL(follow_pte);

I ran into build errors with this -- removing exported symbols breaks
ABI, so I think we should make follow_pte() as a wrapper of its new
equivalent, if that's possible?

