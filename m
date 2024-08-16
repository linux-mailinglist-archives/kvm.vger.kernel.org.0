Return-Path: <kvm+bounces-24396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4C1954C63
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 16:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A74821F2312E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 14:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619FE1BCA0C;
	Fri, 16 Aug 2024 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fv6Qmkgz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E159119D8BA
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723818792; cv=none; b=dcFBeSnUtiIgP++mGfbSDJKTzvpOA8k5JwH8Tt7ETtwkNVA0zakjS19jYMTkdfpkFJsOuxZmrSUGGGIGzy/ZtDYSCrKAw55EH6jyThX+E/DVZOOXk7FmPeJeDADnb5BcCFojzPoDQQJPrjLlrxALh4339slGAbC+9C1jTOEJHVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723818792; c=relaxed/simple;
	bh=sadaGM8x0iZBdQFbiv+WixEd0g4sLPwtOsoSIQDe20k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shA/L/xxsLoQfCAxnIibGqwYcLxBohjjCwk3Fd8pK+RquFcG6BvLoFxGTI+E0eKu89t/NB0kHY8eKYsIFcMIO16YOK/43fgPvwTRVw+B/bIMbyOKXKuKWs05fg2cMc/pQyep5Yc6l3qs+hv+DtOBqYo/1pP84lyZbiH/8tL6eK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fv6Qmkgz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723818789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pI+A4TxlCP26Io+FMl9dijsLZDh/SBaAeeqWjnr6+2U=;
	b=fv6QmkgzKYK25zZyxcHmXPLpEzako8nExynguof2qA9bFRShmUUDXls9UbaWa0q0WhaRH9
	pTW8/gomMPraZ5gQqx5tPcO3V1fAylKrSSWHrKifPtQft4kenDBQRoqhq/ZPEyQjFTOK+q
	Yqc2BTEnW+utOpwkatxV4A3QGYJquCo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-XEvAlO-MNs6HABMv6rG90A-1; Fri, 16 Aug 2024 10:33:08 -0400
X-MC-Unique: XEvAlO-MNs6HABMv6rG90A-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b7ad98c1f8so4228036d6.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 07:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723818788; x=1724423588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pI+A4TxlCP26Io+FMl9dijsLZDh/SBaAeeqWjnr6+2U=;
        b=dLxXkM9xptWYb2alyCJvyP/Rp7oy+uXql6Wq7J9CKh7oiB5CJq4O5SZm7FKHsIATlX
         Io8NbBcKUUiVZQU4EBz3OnPIqCZsbOrkMxLr/nhi1pDEsDg1Op1PjkbBTYwWFyodEs1V
         fFBqNganPhubFXLYtAzQNxcD/4ain5+o1YLyz2hDTe5iX1FO16SHoVAtHcGQPzOzOvB2
         +F8P1wcKD6Mjow0aX44tt5oNh4y8ZCd8D4k/JQ6tIszl2DLtmm1j4PhP79NAptTaHN67
         c4OZS9kcy8XpKg/ZAWpUjnzY3AzqXDTr9DyloennabIw4MV1fYLix7yvlB1rZ40/lZjh
         K7pw==
X-Forwarded-Encrypted: i=1; AJvYcCULbTESWiBqYfC1nJ2Gdj5DgDrZzYBDZPRnm/8f/k1BzEj8NH+LXawTaCyd7m9HYbu/bX4=@vger.kernel.org
X-Gm-Message-State: AOJu0YydKxWYPHrP/mMk5077prMTvjIEG9x+B5WyveQEz7xC2v00lRq9
	TQlR8Ap39uxzq59GMND/w4JG9ZNpuSbRatExkN7G9mhS216i70wO1FoCuR+YbCYKLbbli6jLaKV
	6ldpvhG/zUnf6KzZ5S/gKovdCw0etMo7EFKNZ33Zawu1CgxVOKg==
X-Received: by 2002:a05:6214:246c:b0:6bb:3f69:dd0c with SMTP id 6a1803df08f44-6bf7cf24591mr18243486d6.9.1723818787766;
        Fri, 16 Aug 2024 07:33:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAXotyBPW98wWBPOCwOllaVQ2bg66VXsApljb5NIRTUYVV9cPWLSGNiu0ld5IKhS5uOnqJhg==
X-Received: by 2002:a05:6214:246c:b0:6bb:3f69:dd0c with SMTP id 6a1803df08f44-6bf7cf24591mr18243216d6.9.1723818787295;
        Fri, 16 Aug 2024 07:33:07 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bf6ff06d71sm17954566d6.129.2024.08.16.07.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 07:33:06 -0700 (PDT)
Date: Fri, 16 Aug 2024 10:33:04 -0400
From: Peter Xu <peterx@redhat.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
Message-ID: <Zr9jIKp_vWyfCzQs@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240814123715.GB2032816@nvidia.com>
 <Zr5VA6QSBHO3rpS8@x1n>
 <1147332f-790e-487f-8816-1860b8744ab2@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1147332f-790e-487f-8816-1860b8744ab2@huawei.com>

On Fri, Aug 16, 2024 at 11:05:33AM +0800, Kefeng Wang wrote:
> 
> 
> On 2024/8/16 3:20, Peter Xu wrote:
> > On Wed, Aug 14, 2024 at 09:37:15AM -0300, Jason Gunthorpe wrote:
> > > > Currently, only x86_64 (1G+2M) and arm64 (2M) are supported.
> > > 
> > > There is definitely interest here in extending ARM to support the 1G
> > > size too, what is missing?
> > 
> > Currently PUD pfnmap relies on THP_PUD config option:
> > 
> > config ARCH_SUPPORTS_PUD_PFNMAP
> > 	def_bool y
> > 	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> > 
> > Arm64 unfortunately doesn't yet support dax 1G, so not applicable yet.
> > 
> > Ideally, pfnmap is too simple comparing to real THPs and it shouldn't
> > require to depend on THP at all, but we'll need things like below to land
> > first:
> > 
> > https://lore.kernel.org/r/20240717220219.3743374-1-peterx@redhat.com
> > 
> > I sent that first a while ago, but I didn't collect enough inputs, and I
> > decided to unblock this series from that, so x86_64 shouldn't be affected,
> > and arm64 will at least start to have 2M.
> > 
> > > 
> > > > The other trick is how to allow gup-fast working for such huge mappings
> > > > even if there's no direct sign of knowing whether it's a normal page or
> > > > MMIO mapping.  This series chose to keep the pte_special solution, so that
> > > > it reuses similar idea on setting a special bit to pfnmap PMDs/PUDs so that
> > > > gup-fast will be able to identify them and fail properly.
> > > 
> > > Make sense
> > > 
> > > > More architectures / More page sizes
> > > > ------------------------------------
> > > > 
> > > > Currently only x86_64 (2M+1G) and arm64 (2M) are supported.
> > > > 
> > > > For example, if arm64 can start to support THP_PUD one day, the huge pfnmap
> > > > on 1G will be automatically enabled.
> 
> A draft patch to enable THP_PUD on arm64, only passed with DEBUG_VM_PGTABLE,
> we may test pud pfnmaps on arm64.

Thanks, Kefeng.  It'll be great if this works already, as simple.

Might be interesting to know whether it works already if you have some
few-GBs GPU around on the systems.

Logically as long as you have HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD selected
below, 1g pfnmap will be automatically enabled when you rebuild the kernel.
You can double check that by looking for this:

  CONFIG_ARCH_SUPPORTS_PUD_PFNMAP=y

And you can try to observe the mappings by enabling dynamic debug for
vfio_pci_mmap_huge_fault(), then map the bar with vfio-pci and read
something from it.

> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index a2f8ff354ca6..ff0d27c72020 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -184,6 +184,7 @@ config ARM64
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> +	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if PGTABLE_LEVELS > 2
>  	select HAVE_ARCH_VMAP_STACK
>  	select HAVE_ARM_SMCCC
>  	select HAVE_ASM_MODVERSIONS
> diff --git a/arch/arm64/include/asm/pgtable.h
> b/arch/arm64/include/asm/pgtable.h
> index 7a4f5604be3f..e013fe458476 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -763,6 +763,25 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
>  #define pud_valid(pud)		pte_valid(pud_pte(pud))
>  #define pud_user(pud)		pte_user(pud_pte(pud))
>  #define pud_user_exec(pud)	pte_user_exec(pud_pte(pud))
> +#define pud_dirty(pud)		pte_dirty(pud_pte(pud))
> +#define pud_devmap(pud)		pte_devmap(pud_pte(pud))
> +#define pud_wrprotect(pud)	pte_pud(pte_wrprotect(pud_pte(pud)))
> +#define pud_mkold(pud)		pte_pud(pte_mkold(pud_pte(pud)))
> +#define pud_mkwrite(pud)	pte_pud(pte_mkwrite_novma(pud_pte(pud)))
> +#define pud_mkclean(pud)	pte_pud(pte_mkclean(pud_pte(pud)))
> +#define pud_mkdirty(pud)	pte_pud(pte_mkdirty(pud_pte(pud)))
> +
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +static inline int pud_trans_huge(pud_t pud)
> +{
> +	return pud_val(pud) && pud_present(pud) && !(pud_val(pud) &
> PUD_TABLE_BIT);
> +}
> +
> +static inline pud_t pud_mkdevmap(pud_t pud)
> +{
> +	return pte_pud(set_pte_bit(pud_pte(pud), __pgprot(PTE_DEVMAP)));
> +}
> +#endif
> 
>  static inline bool pgtable_l4_enabled(void);
> 
> @@ -1137,10 +1156,20 @@ static inline int pmdp_set_access_flags(struct
> vm_area_struct *vma,
>  							pmd_pte(entry), dirty);
>  }
> 
> +static inline int pudp_set_access_flags(struct vm_area_struct *vma,
> +					unsigned long address, pud_t *pudp,
> +					pud_t entry, int dirty)
> +{
> +	return __ptep_set_access_flags(vma, address, (pte_t *)pudp,
> +							pud_pte(entry), dirty);
> +}
> +
> +#ifndef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>  static inline int pud_devmap(pud_t pud)
>  {
>  	return 0;
>  }
> +#endif
> 
>  static inline int pgd_devmap(pgd_t pgd)
>  {
> @@ -1213,6 +1242,13 @@ static inline int pmdp_test_and_clear_young(struct
> vm_area_struct *vma,
>  {
>  	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
>  }
> +
> +static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
> +					    unsigned long address,
> +					    pud_t *pudp)
> +{
> +	return __ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
> +}
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> 
>  static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
> @@ -1433,6 +1469,7 @@ static inline void update_mmu_cache_range(struct
> vm_fault *vmf,
>  #define update_mmu_cache(vma, addr, ptep) \
>  	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
>  #define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
> +#define update_mmu_cache_pud(vma, address, pud) do { } while (0)
> 
>  #ifdef CONFIG_ARM64_PA_BITS_52
>  #define phys_to_ttbr(addr)	(((addr) | ((addr) >> 46)) & TTBR_BADDR_MASK_52)
> -- 
> 2.27.0

-- 
Peter Xu


