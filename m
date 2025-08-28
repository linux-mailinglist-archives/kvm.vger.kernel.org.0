Return-Path: <kvm+bounces-56075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25304B39989
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 383F71899CDA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A717530BB80;
	Thu, 28 Aug 2025 10:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="icFu/Zru"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C67273D6F
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 10:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756376538; cv=none; b=NwGWFqa9hEb/9OJpeMNrhuku5V9DUQ0/eHqS8793aZlPGJNRscR4sNgPViAriHBy+d04lpHO1AsLy6mI5md/NpIFsUOb2Je8Wj/wQX9lkys7DeQh9xOYvHLSSCXsd+2VXlSJ8+WCjyRKWtGodC9Nq8eh6cSfuwW8PWeyzyEDdfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756376538; c=relaxed/simple;
	bh=FtKlDX1cC88prd0nVVZDQ8wnFvM762DE57wJ6XlZHQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fJvdg8ZSwuGH0IHXA9uLMzpNTVBqzMyWjdvI9u78vQ9Ev9jjdmEM+Bv2kUxFwd6xOWefY2j1dvSatf55Fey8v/SsBPLDwAvAQAWXnPDGdArIYHasNIx7IMZsJQNcToettEOB5igLj/2meE568rK/E3lutkZ1E5jjKB3h69g3wO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=icFu/Zru; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b2f497c230so305631cf.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 03:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756376535; x=1756981335; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zAt+br+G9Lon3yOcD2uCT+F1HP2hGvD0BFIJ9EDkS/w=;
        b=icFu/Zrupc4MpC4ulYgyL+DJ+DLSDkt9iV+NrrvKH5jwz2IE145sj347VL1MlW5t96
         9Y29JiwUSY2U7gQDytet+gViF4GTzqF+B7ZYxeM7LmnOiwG+5/h971Ha0nxpv4yA7vgG
         CDCKU6umlc0eJACUDRUEUaSrslttXioulIYp1fJcPUJ2OcR1HvrwtDBnNvHM/Fr8cTjc
         P1lvae5yzBnM0FV6YfH+q5w7Zbx8b7Eu3oKeSORHr3nSIbsidQYDhmEr1TSz0oqx/Pss
         P+GURGPmX0kvsFV71ssql3LZCiHF3L03pO7sOzsrGkg5v17CXXAXl75nZqzZT6C32sbq
         +y/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756376535; x=1756981335;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAt+br+G9Lon3yOcD2uCT+F1HP2hGvD0BFIJ9EDkS/w=;
        b=mKxFO7ew5r+cWIJyUTvjIlX1ptNiWbmEyC2FvRmLdmdngBRpa7VUv1U8Ll20swEwA4
         OSLty4YUNd4ssRjKJdvfx02yREodp7aJzHpbniEb+aJBw9Ae1qt19UAEsqwtWZcTS5RZ
         VIS1nM+5MIk3BOgbd+3OtoMMIw2fpjcy8qHca8fCJXyPRVBRqtK5BGMUvjtiCdkNga3p
         oiCDpUS+OOo9B+ibP7ykHrlJEVfFm+sY8dscxeVYC5qNFFykhZUJ/Kd3bLgHQ9C9e+fE
         eh3BoZtz0N7tzpPvH/LHzgVzDzKrWG17vr5jKu3kRgYoGGjMcA3rZgELkOIQQ1/jjrzn
         JMhA==
X-Forwarded-Encrypted: i=1; AJvYcCVn5gcoREKsCA07owVslcgxTTJw1lq4s1NyFLkjxqIQ3Or9aCF5lTppu1Dr0LDn9BFCoZs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBx2Hc5zr0nNmPFVQEAzmHyR+VPmTLYQ/WGKAfOGqGMro1b/QO
	VD6RjrFv0u6d+dL5hTYsH+nTgaH4hki05h+h8WHAsxDhTBU2fPkge59dIFjRO2/W0JRxxjDR38L
	GqTDUHkyFUdLGqeAoqeeeDVELG9xRaZcL2ed3mWqN
X-Gm-Gg: ASbGncs9am4uNv9c2KCvvov58Cd8K1xD9VhH60grMKRuPtXnml+2FXLRNc56BPgDbWY
	oSIioaYfyrUdgFFrmy6zHYNzNQHn4Ayar9uQ1gkoYGLiYyQemfIGgZ5LJvPErvtRlK3GfyaQMF+
	9gFGV3pft4ABo08hDGbUHbOPQQh1LUnq5n9mqxRmG6SQGVFVxRTWONyk4VkTc1ACGepaZDpLuNq
	ZMmH0Gyl3jX9jyuSOYouj256A==
X-Google-Smtp-Source: AGHT+IENYaxKywEJVnhRd53PlyB2PEFU36G7mSwHHBh3QnGvBJswRyDjryZtJh3goBAjur1DAoDs201z525n5fnLFR0=
X-Received: by 2002:a05:622a:5143:b0:4b2:9b79:e700 with SMTP id
 d75a77b69052e-4b2ea8688bdmr14440241cf.4.1756376534543; Thu, 28 Aug 2025
 03:22:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250828093902.2719-1-roypat@amazon.co.uk> <20250828093902.2719-4-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-4-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 28 Aug 2025 11:21:38 +0100
X-Gm-Features: Ac12FXxQhIbmHWE_IVdh_SbAhoCZMe-hp6nPpbqQbsT5jXtNkVhWc6QqYibQkV8
Message-ID: <CA+EHjTxOmDJkwjSvAUr2O4yqEkyqeQ=_p3E5Uj5yQrPW7Qz_HA@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "david@redhat.com" <david@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"

Hi Patrick,

On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present . Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
>
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
>
> This drops a optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.
>
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  include/linux/pagemap.h   | 16 ++++++++++++++++
>  include/linux/secretmem.h | 18 ------------------
>  lib/buildid.c             |  4 ++--
>  mm/gup.c                  | 14 +++-----------
>  mm/mlock.c                |  2 +-
>  mm/secretmem.c            |  6 +-----
>  6 files changed, 23 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 12a12dae727d..b52b28ae4636 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -211,6 +211,7 @@ enum mapping_flags {
>                                    folio contents */
>         AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
>         /* Bits 16-25 are used for FOLIO_ORDER */
>         AS_FOLIO_ORDER_BITS = 5,
>         AS_FOLIO_ORDER_MIN = 16,
> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>
> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> +{
> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> +{
> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> +{
> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> +}
> +

Any reason vma is const whereas mapping in the function that it calls
(defined above it) isn't?

Cheers,
/fuad

>  static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
>  {
>         return mapping->gfp_mask;
> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
> index e918f96881f5..0ae1fb057b3d 100644
> --- a/include/linux/secretmem.h
> +++ b/include/linux/secretmem.h
> @@ -4,28 +4,10 @@
>
>  #ifdef CONFIG_SECRETMEM
>
> -extern const struct address_space_operations secretmem_aops;
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -       return mapping->a_ops == &secretmem_aops;
> -}
> -
> -bool vma_is_secretmem(struct vm_area_struct *vma);
>  bool secretmem_active(void);
>
>  #else
>
> -static inline bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -       return false;
> -}
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -       return false;
> -}
> -
>  static inline bool secretmem_active(void)
>  {
>         return false;
> diff --git a/lib/buildid.c b/lib/buildid.c
> index c4b0f376fb34..33f173a607ad 100644
> --- a/lib/buildid.c
> +++ b/lib/buildid.c
> @@ -65,8 +65,8 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
>
>         freader_put_folio(r);
>
> -       /* reject secretmem folios created with memfd_secret() */
> -       if (secretmem_mapping(r->file->f_mapping))
> +       /* reject secretmem folios created with memfd_secret() or guest_memfd() */
> +       if (mapping_no_direct_map(r->file->f_mapping))
>                 return -EFAULT;
>
>         r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
> diff --git a/mm/gup.c b/mm/gup.c
> index adffe663594d..8c988e076e5d 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1234,7 +1234,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>         if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>                 return -EOPNOTSUPP;
>
> -       if (vma_is_secretmem(vma))
> +       if (vma_is_no_direct_map(vma))
>                 return -EFAULT;
>
>         if (write) {
> @@ -2751,7 +2751,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  {
>         bool reject_file_backed = false;
>         struct address_space *mapping;
> -       bool check_secretmem = false;
>         unsigned long mapping_flags;
>
>         /*
> @@ -2763,14 +2762,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>                 reject_file_backed = true;
>
>         /* We hold a folio reference, so we can safely access folio fields. */
> -
> -       /* secretmem folios are always order-0 folios. */
> -       if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
> -               check_secretmem = true;
> -
> -       if (!reject_file_backed && !check_secretmem)
> -               return true;
> -
>         if (WARN_ON_ONCE(folio_test_slab(folio)))
>                 return false;
>
> @@ -2812,8 +2803,9 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>          * At this point, we know the mapping is non-null and points to an
>          * address_space object.
>          */
> -       if (check_secretmem && secretmem_mapping(mapping))
> +       if (mapping_no_direct_map(mapping))
>                 return false;
> +
>         /* The only remaining allowed file system is shmem. */
>         return !reject_file_backed || shmem_mapping(mapping);
>  }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index a1d93ad33c6d..0def453fe881 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>
>         if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
>             is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -           vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +           vma_is_dax(vma) || vma_is_no_direct_map(vma) || (oldflags & VM_DROPPABLE))
>                 /* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>                 goto out;
>
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 422dcaa32506..a2daee0e63a5 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -134,11 +134,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc *desc)
>         return 0;
>  }
>
> -bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -       return vma->vm_ops == &secretmem_vm_ops;
> -}
> -
>  static const struct file_operations secretmem_fops = {
>         .release        = secretmem_release,
>         .mmap_prepare   = secretmem_mmap_prepare,
> @@ -206,6 +201,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>
>         mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>         mapping_set_unevictable(inode->i_mapping);
> +       mapping_set_no_direct_map(inode->i_mapping);
>
>         inode->i_op = &secretmem_iops;
>         inode->i_mapping->a_ops = &secretmem_aops;
> --
> 2.50.1
>

