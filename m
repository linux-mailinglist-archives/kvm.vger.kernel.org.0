Return-Path: <kvm+bounces-24457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8369553AF
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 01:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44C9F1C21835
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C1E146A89;
	Fri, 16 Aug 2024 23:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQ4h+8Y/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF9112C46D
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 23:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723849948; cv=none; b=d2DEXFDP89zVFszJCgwB5hFW5fYyHs1i+AlkwNx/UiYF9WvjkSFgw1cRLzTgXJs2TuPRNBo1jasip5BB/Z7+4PRpYtqZ7gNM/sOhjbwjghIdp69DQ6NMDUiWkh5XEU87T1E5HXNn0d84tvVl21TFDKe7yVrhHUsXwdV/vgAiNmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723849948; c=relaxed/simple;
	bh=G8wjemwnRyO6NVNw5iZHSxhOkap+UBaEfPkGUxlHwkA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gK5PgLRlF2N8lLU82LwTF+WRtreheXwoAhRm2M23PuHWmzTW3vVSWAVyriPOQzqNlIhQyQfAI2RBkQhylKg9qpOGu0szSVnJ1dlDmyK91kaIj5AlZoVfZv2dRyXaLYWOiJ9h/sjvUe7k0aL8+7gDhpcsS63Uxc75A4k/yNSGG2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQ4h+8Y/; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e035f7b5976so5005901276.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 16:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723849946; x=1724454746; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MP4Py9aMfR/AKmNoXvgLR+GIypWGYmbThjpuUqgYpZo=;
        b=aQ4h+8Y/3aPyn+vJo8boG2XqX2mcjBD+10NWe+TCKVJsfXjNvUuT0loFHt5EA6YC3E
         dGNmxteP3SrkrB+rleEbjFC0kYGFBKUHUmsN6LCEQAs/rV7lfj9WR2bM4TJYOLdEXEqa
         swm1b51YCs8M136Me3SicRWKLgFvJPi8SG3wvoqwZUEiC4Sk973J2t55DoFEKJ2TG1Nt
         j4txrVA7D0paJASALAP00RcRu4jS+vAVAAE60FoqWZjtApaBL3yb6N9iAZxsbqq5P0NF
         lBID4OD24KLz+jPVaGr2n/zJsy8fJCCswyAmM3R2oAH10Hs7S8W+knngY293Z9AeBbmq
         lixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723849946; x=1724454746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MP4Py9aMfR/AKmNoXvgLR+GIypWGYmbThjpuUqgYpZo=;
        b=h1x/R+CBJ3uKQyqStl/vTWj2VkXDTMvggXCE9gjKuqLgAcuyNxfMIxga/obLALXD1E
         THv35dO6PwnCAwZMA+8tWo3wA9j4msQ/aPAkPrVKB+7FPu4oQr+vTmuhYijaFGN+mjZD
         tVy0nR6byefS2LHVciLKQaXbm2r5ONVlcYwWnJlO5/Hj1BS+MRJYMnqfCN4H1FXJAXDy
         zhSQ4xW2HYjLdUODbC+DTzoRLKt8UiPc3iWJvq8eLdEfCRmnh664oSd6B5UvXjCUrjKF
         tQA7UHPSPeeiSJTITg2jSaPW7Dd71sCR1XTgrQzo7yG69SlrlGt2qj6VWQjwsoyKOEzo
         fW7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVOF00vnXr9M4FQXkm4Ia/BeuKopNNpEk/4rtYA1LSSyuuqF63eECKo3oVip4rcGtxWFKLnG22BuORN3Yx/igzOrOZQ
X-Gm-Message-State: AOJu0YwNfDXkCj9FUqxlJyHNaj7TW+344hD3NNLHp7Gsha5lF0RvQf/q
	hIGoPNicOz3OyGut2NyEgLv88jBkq1sQSbn1DYxV019fUnHe0QWfDkKUJGkt0bfOusfy5e4TV0t
	oug==
X-Google-Smtp-Source: AGHT+IHvHjVtBQY+zbMWrJxzjHHTXmglsrnC6Fth3pX59tNCoit03ZRDoiW69Fbx+itX1xJqSOk6yOFrynI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa53:0:b0:e11:5da7:33d with SMTP id
 3f1490d57ef6-e11829fb2b5mr165390276.2.1723849945979; Fri, 16 Aug 2024
 16:12:25 -0700 (PDT)
Date: Fri, 16 Aug 2024 16:12:24 -0700
In-Reply-To: <20240809160909.1023470-10-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240809160909.1023470-10-peterx@redhat.com>
Message-ID: <Zr_c2C06eusc_b1l@google.com>
Subject: Re: [PATCH 09/19] mm: New follow_pfnmap API
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, 
	David Hildenbrand <david@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 09, 2024, Peter Xu wrote:
> Introduce a pair of APIs to follow pfn mappings to get entry information.
> It's very similar to what follow_pte() does before, but different in that
> it recognizes huge pfn mappings.

...

> +int follow_pfnmap_start(struct follow_pfnmap_args *args);
> +void follow_pfnmap_end(struct follow_pfnmap_args *args);

I find the start+end() terminology to be unintuitive.  E.g. I had to look at the
implementation to understand why KVM invoke fixup_user_fault() if follow_pfnmap_start()
failed.

What about follow_pfnmap_and_lock()?  And then maybe follow_pfnmap_unlock()?
Though that second one reads a little weird.

> + * Return: zero on success, -ve otherwise.

ve?

> +int follow_pfnmap_start(struct follow_pfnmap_args *args)
> +{
> +	struct vm_area_struct *vma = args->vma;
> +	unsigned long address = args->address;
> +	struct mm_struct *mm = vma->vm_mm;
> +	spinlock_t *lock;
> +	pgd_t *pgdp;
> +	p4d_t *p4dp, p4d;
> +	pud_t *pudp, pud;
> +	pmd_t *pmdp, pmd;
> +	pte_t *ptep, pte;
> +
> +	pfnmap_lockdep_assert(vma);
> +
> +	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
> +		goto out;
> +
> +	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> +		goto out;

Why use goto intead of simply?

		return -EINVAL;

That's relevant because I think the cases where no PxE is found should return
-ENOENT, not -EINVAL.  E.g. if the caller doesn't precheck, then it can bail
immediately on EINVAL, but know that it's worth trying to fault-in the pfn on
ENOENT. 

> +retry:
> +	pgdp = pgd_offset(mm, address);
> +	if (pgd_none(*pgdp) || unlikely(pgd_bad(*pgdp)))
> +		goto out;
> +
> +	p4dp = p4d_offset(pgdp, address);
> +	p4d = READ_ONCE(*p4dp);
> +	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
> +		goto out;
> +
> +	pudp = pud_offset(p4dp, address);
> +	pud = READ_ONCE(*pudp);
> +	if (pud_none(pud))
> +		goto out;
> +	if (pud_leaf(pud)) {
> +		lock = pud_lock(mm, pudp);
> +		if (!unlikely(pud_leaf(pud))) {
> +			spin_unlock(lock);
> +			goto retry;
> +		}
> +		pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
> +				  pud_pfn(pud), PUD_MASK, pud_write(pud),
> +				  pud_special(pud));
> +		return 0;
> +	}
> +
> +	pmdp = pmd_offset(pudp, address);
> +	pmd = pmdp_get_lockless(pmdp);
> +	if (pmd_leaf(pmd)) {
> +		lock = pmd_lock(mm, pmdp);
> +		if (!unlikely(pmd_leaf(pmd))) {
> +			spin_unlock(lock);
> +			goto retry;
> +		}
> +		pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
> +				  pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
> +				  pmd_special(pmd));
> +		return 0;
> +	}
> +
> +	ptep = pte_offset_map_lock(mm, pmdp, address, &lock);
> +	if (!ptep)
> +		goto out;
> +	pte = ptep_get(ptep);
> +	if (!pte_present(pte))
> +		goto unlock;
> +	pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
> +			  pte_pfn(pte), PAGE_MASK, pte_write(pte),
> +			  pte_special(pte));
> +	return 0;
> +unlock:
> +	pte_unmap_unlock(ptep, lock);
> +out:
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(follow_pfnmap_start);

