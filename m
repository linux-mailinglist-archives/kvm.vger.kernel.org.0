Return-Path: <kvm+bounces-64315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE834C7EF0E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 05:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFA9D3A3751
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 04:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111FA2BDC33;
	Mon, 24 Nov 2025 04:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="HCdPZAWQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4D31B4257
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 04:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763958078; cv=none; b=ebyC1z957+VvK81bD8Em2TNXasIYfzdBOulPyFixHQ9M+xXj4uzs+eypCt3GLucejGyu5wrmTuczb5pfYq0dJachRM3FOAi6/KM5gsu7C0yN4qNcMUn6NUensq/5BmKfzXiAjo/cAOYL33l/2J4l0yOfGUu74ZeltKkByV5gibQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763958078; c=relaxed/simple;
	bh=YBmhgitqNCKje886ZnmiJaYbj7EpL8nuXIcZyum1GEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZkgyNINF1AGTD15aEgXug3z0DZ0upNrLDH/pCQOJwzl9XJFL6DOi4RPswweXWdMPYNR+1waXgxSWKbsZbmyCO2Z2BbPapBBsDZWSOLBWbmftepE4JIpUIPOg0kA+uDElxu43hTuSQ2J5qBkdZ9IFU3hVu/HCH57zb6BL0NX6kuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=HCdPZAWQ; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-4330d2ea04eso15110035ab.3
        for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 20:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1763958074; x=1764562874; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ajvwwGE2zvVYwh+XHby7X1EFH+T96LTHtHaWuqnOQ4=;
        b=HCdPZAWQQv/3RqDMZEFqBxIYkFQlgflD4iOV8jAIK0jW8P7vA7acDArFPukaIvaitW
         ZCx9dUbP75z/oznHqnADgr1LmXF4aOX8Kpbktn26p6JaySami/Ux9knyp6VsD05Vnxb0
         J2SAmqPiHQt7A0Z6xcznYQpUN4VQK+VafOZ1/ZWx/ahINP6qtr0eptLJcKZRnzGVdsum
         uFBIFDsBoznqybULlB6jENxxVvGGPQsOBujmAuufIGJVCvyr1rHUT3U4GQvIoymhCoz8
         2Yu2kyLbv56Ayn1KkYqo2zKfAoC88ZBIrw4yfwRrTDaCDzGkSFY3Y+YZQQ1UNBN7516L
         yF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763958074; x=1764562874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ajvwwGE2zvVYwh+XHby7X1EFH+T96LTHtHaWuqnOQ4=;
        b=iERbCAnqQaMbpOLIWGTYE1/g2wHRW0SW8I6CEkmYTJ/7Dh3AMtHBqDPiwHU8LHsl+b
         PlOHgU1JeRecPVpCTvIVeT4er0TsI74gHTpH4kGwnIiTkrzvyPPFacOmdKVTL5VrdqoE
         w2V4kaZQC2GLzBRYopbsnvN7pfZZhMtauRD1R0PKq+9lQ5O8HQETgxC3s5dtU2eqTGTo
         tb9u+NTP6YqLEffpbSR9vQF308jbcQTX+wrY5yUgFaeDU9Ow2ktflJ14SaijzPm1zLsF
         S075My/yyeOlLdkcxTYvOlMMQF5LNoPzdy9dNntp3Y0w6nzzucyIYn0R/T/PbKe7Sdti
         /0Gg==
X-Forwarded-Encrypted: i=1; AJvYcCUZf7faskdF11EFkechwFimO/fhNGlnXbZTTKtg09cH6HgNkENCHiVnVqh50NHQEG72ETo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpgWgzg1i0OFl5kd18to/TaKKxYkD/x7V3qr7v3JSNAGrdPo0P
	3GJ36kWokyXJGwNxBcMqDXVDRg0ZcLxtLpQmQwUeA/9cdkBEZUccj9O4uxauH6XkoOV51rYwUvZ
	/fAb6Xcsx67Fx54P7CzO5hJXF7ThHJtlPAMHybZKvAA==
X-Gm-Gg: ASbGnct0Qd2dg4erzP6kfIGVSHTNmUAl+bsfKGkwGojNwcIVwyGsrg+82AzH6sspSIX
	sCi+xeLl51AuZmSaGi2fYSKkiSDn5KkcDfkOUl4/LyMM4IXfh2Lapri8gig0t9kN9aTA/UjaV9w
	zIVIiApUZJ1sWh5JcOIFIi6kjrZsy8zYRl+TBsry0H1mDL353313gm3ozaucpYDj/1bn8oEdbO5
	e3d+V5+DT6HuIe0AXIMNxwjXgRHoPzx4AOjC2DJmGCSjhNc8FsjPMYy/SpMOYIiZTRZaqc=
X-Google-Smtp-Source: AGHT+IF5/WD1sQlH015KGuoD1Y5beY+io1GXFiQidkneBixXQImfbSlNNYZ+E5TXZdKjnD+6JSMk+vW9dvra0j/bLqk=
X-Received: by 2002:a05:6e02:1688:b0:434:96ea:ff5f with SMTP id
 e9e14a558f8ab-435b8ebbbf6mr88081495ab.40.1763958074117; Sun, 23 Nov 2025
 20:21:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111124932618qn9qbBbeaZrOZ3UDg7jed@zte.com.cn>
In-Reply-To: <20251111124932618qn9qbBbeaZrOZ3UDg7jed@zte.com.cn>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 24 Nov 2025 09:51:02 +0530
X-Gm-Features: AWmQ_bl9_aCb5Og2sU6WbXSjU72tEAt1Y1gu7hHWpl1ixFlMveFk9a_1cKqQKKY
Message-ID: <CAAhSdy1bL75K5B_bgVA=EpT6cw_9TOk+=PMNHr+K=sAjTNmhXA@mail.gmail.com>
Subject: Re: [PATCH v3] RISC-V: KVM: Transparent huge page support
To: liu.xuemei1@zte.com.cn
Cc: atish.patra@linux.dev, alex@ghiti.fr, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	inux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 10:19=E2=80=AFAM <liu.xuemei1@zte.com.cn> wrote:
>
> From: Jessica Liu <liu.xuemei1@zte.com.cn>
>
> Use block mapping if backed by a THP, as implemented in architectures
> like ARM and x86_64.
>
> Signed-off-by: Jessica Liu <liu.xuemei1@zte.com.cn>
> ---
> Changes in v3:
> - Changed prototype of gstage_get_user_mapping_size to
>   kvm_riscv_gstage_get_mapping_size.
> - Relocated the remaining functions from gstage.c in v2 to mmu.c and
>   renamed them.
>
>  arch/riscv/include/asm/kvm_gstage.h |  2 +
>  arch/riscv/kvm/gstage.c             | 15 +++++
>  arch/riscv/kvm/mmu.c                | 97 ++++++++++++++++++++++++++++-
>  3 files changed, 113 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm=
/kvm_gstage.h
> index 595e2183173e..006bbdb90df8 100644
> --- a/arch/riscv/include/asm/kvm_gstage.h
> +++ b/arch/riscv/include/asm/kvm_gstage.h
> @@ -69,4 +69,6 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstag=
e, gpa_t start, gpa_t end
>
>  void kvm_riscv_gstage_mode_detect(void);
>
> +int kvm_riscv_gstage_get_mapping_size(struct kvm_gstage *gstage, gpa_t a=
ddr);
> +
>  #endif
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index b67d60d722c2..a63089206869 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -357,3 +357,18 @@ void __init kvm_riscv_gstage_mode_detect(void)
>         csr_write(CSR_HGATP, 0);
>         kvm_riscv_local_hfence_gvma_all();
>  }
> +
> +int kvm_riscv_gstage_get_mapping_size(struct kvm_gstage *gstage, gpa_t a=
ddr)
> +{
> +       pte_t *ptepp;
> +       u32 ptep_level;
> +       unsigned long out_pgsize;
> +
> +       if (!kvm_riscv_gstage_get_leaf(gstage, addr, &ptepp, &ptep_level)=
)
> +               return -EFAULT;
> +
> +       if (gstage_level_to_page_size(ptep_level, &out_pgsize))
> +               return -EFAULT;
> +
> +       return out_pgsize;
> +}
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 525fb5a330c0..1457bc958505 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -323,6 +323,91 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gf=
n_range *range)
>         return pte_young(ptep_get(ptep));
>  }
>
> +static bool fault_supports_gstage_huge_mapping(struct kvm_memory_slot *m=
emslot, unsigned long hva)
> +{
> +       gpa_t gpa_start;
> +       hva_t uaddr_start, uaddr_end;
> +       size_t size;

Declare local variables in inverted pyramid fashion when possible.

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
> +static long transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memo=
ry_slot *memslot,
> +                                       unsigned long hva, kvm_pfn_t *hfn=
p, gpa_t *gpa)
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
> +               struct kvm_gstage gstage;

Declare sz here.

> +
> +               gstage.pgd =3D kvm->mm->pgd;
> +               int sz =3D kvm_riscv_gstage_get_mapping_size(&gstage, hva=
);

This is broken because you are passing hva as gpa to
kvm_riscv_gstage_get_mapping_size().

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
>  int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *mem=
slot,
>                       gpa_t gpa, unsigned long hva, bool is_write,
>                       struct kvm_gstage_mapping *out_map)
> @@ -337,7 +422,8 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct k=
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
> @@ -416,6 +502,15 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct =
kvm_memory_slot *memslot,
>         if (mmu_invalidate_retry(kvm, mmu_seq))
>                 goto out_unlock;
>
> +       /* check if we are backed by a THP and thus use block mapping if =
possible */
> +       if (vma_pagesize =3D=3D PAGE_SIZE) {
> +               vma_pagesize =3D transparent_hugepage_adjust(kvm, memslot=
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

Regards,
Anup

