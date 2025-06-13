Return-Path: <kvm+bounces-49457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38503AD92C5
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E02D317AE53
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDAA920E30F;
	Fri, 13 Jun 2025 16:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MjhrZQsj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3AF20A5E1
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 16:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749831893; cv=none; b=MhpuDBGDMv//7Xi1LV0NkLjL7QPg71RCZewtC4HIBaC+XZwwUbG108EkUr+R5r6lmfdPO/r+j4ZtM1xcLiXodOfCwXxVhYpXIhuZ2arfEAXFOsUW4No8/PEamfG3S60VQ7rb4m8u1AldHKL2nYHg4iBPHDhfjKH9DCR3oYfVT9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749831893; c=relaxed/simple;
	bh=ezAPkeMmfcqGy1OO+aJ5oa0dXrm8ejKbGu1v5Dg5Cqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZid6kw5zXPBcwuaQzB7wGSjYMT19e29QVtNipGbzmVV9PQHhiX5UdB//+EU5Q1cnJCY1axz7s9JzVDkE3C7emaIfLh3yK6CtzAKZ8XhkWCNV6Mlp2fi2D/kjIeRLnM6WLiGvWXXoC4rmCZ7JpTiGePYMPS6dvelFxOSwXomd6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MjhrZQsj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749831890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M6UPs3wZZzH8Vr1Vmqrw6Xud3sdfgHi+vy7XvS9r/Jo=;
	b=MjhrZQsj/JkW5i8G8Or0WLQSxRLDCsZYmlOf9vVD0W81t4a5X5mXXvySGZkt+4kAXRvBAW
	RmfkoV0mD8OCcGhPGKqq27bgsWYxVaa55IUCE1tSafze30NV3m30GYs7pVgFph3KdZ/npU
	VRfXZx36vT6jGwGNiasBKCnOBIRBzv8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-PtPs90IUNj6ai3kQ7tQRvg-1; Fri, 13 Jun 2025 12:24:49 -0400
X-MC-Unique: PtPs90IUNj6ai3kQ7tQRvg-1
X-Mimecast-MFC-AGG-ID: PtPs90IUNj6ai3kQ7tQRvg_1749831888
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4a42c569a9aso54257791cf.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 09:24:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749831888; x=1750436688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6UPs3wZZzH8Vr1Vmqrw6Xud3sdfgHi+vy7XvS9r/Jo=;
        b=apuaEZLy3G127PT/Yn71PX18FTeJNAWd4QU6w+AVc7sSAN+tZZvOh+eTcjhHjvX4T7
         tMrNWoKBvjAueD7dm6b2OEYW3emdI7nMgvl3QBG+Ka1PRATsHb/3fVZH0gZ4ZMtZBYfI
         T8EYaIPfIZIqkX+vpFwk3zn3EQLc2maqcuEd6P7CHaYGV/UBnRXSn0hg1DAsbuYUQ/7x
         wlrgGjEa58u+eMa2xG5XGqHaFacr4fVL5QX3dfLDq7D2snv1cZa3bku+ArP6ilivcbpn
         PKdnJL2R0XofVQcu8whk+5D3QDMqlac/IpbBr9jE6Qf+tY+iGeUD/irW8lfNiYC2vY/6
         UwEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwxskoXX13FkfiypfVcLqkOK5o4alDv2Nj/ecjDIlHXul9oh2r8UeZM4vtK9+JNZsg7gg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxWFU8s6mpLcC9J5lEtLpOGIAzXIWNHLBoOoF0EkPX+QPjlttl
	6kglgF6NLxtt/yLe+4/JsZSgVWjE5X/1CRKFlHswiu2NQ4vMD1+l2n7KFQLX2/iRYPGG7T5U4Xw
	lCtGunOT3eUVkChH27jJxchocVI/IgyTKhDbapHImPp3p8vv84jX0XA==
X-Gm-Gg: ASbGnctFEVP1gAY2v3m/XdmYA9rDNfOeMK4+EpmjL7/wpQeaFpR6CCjSW3DOXz2WxP/
	lY0qLLJjp5GB0YAn+E7jf9haAAnlK+vnzftFQy64cZK2YrHxn+fVmOBsKOmI0R22PVUeNuV7P9r
	YQWaT69exlL68InGxO+/yVqGqoh+dyb6LGOaW+LOA9jc3xw1orqCXHH+nJxcFgtftx5/atvkaeQ
	DqRgjjwe9/CFJEHs968mBcUWdNwciJF/MO5kdJM8yG70hCWtiYKYlUlQFCsJMqgqUqMWG1ecRSX
	9myT/Vdu5nQZCQ==
X-Received: by 2002:a05:622a:44:b0:4a6:fa1f:46a5 with SMTP id d75a77b69052e-4a73b69e837mr6261691cf.2.1749831888562;
        Fri, 13 Jun 2025 09:24:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwE/aMkplM3bTE+98WG9z6ojodJYRohckJBl51t/zS9y9pPDUtOdEYutdKcOPE5vAqv+nUow==
X-Received: by 2002:a05:622a:44:b0:4a6:fa1f:46a5 with SMTP id d75a77b69052e-4a73b69e837mr6261261cf.2.1749831888182;
        Fri, 13 Jun 2025 09:24:48 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a72a4cf7desm18773181cf.53.2025.06.13.09.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 09:24:47 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:24:43 -0400
From: Peter Xu <peterx@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/hugetlb: Remove prepare_hugepage_range()
Message-ID: <aExQy6xMDc9Igm5v@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-3-peterx@redhat.com>
 <050B65EF-6A1E-44A8-87D5-152FA9A60641@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <050B65EF-6A1E-44A8-87D5-152FA9A60641@nvidia.com>

On Fri, Jun 13, 2025 at 11:13:50AM -0400, Zi Yan wrote:
> On 13 Jun 2025, at 9:41, Peter Xu wrote:
> 
> > Only mips and loongarch implemented this API, however what it does was
> > checking against stack overflow for either len or addr.  That's already
> > done in arch's arch_get_unmapped_area*() functions, hence not needed.
> >
> > It means the whole API is pretty much obsolete at least now, remove it
> > completely.
> >
> > Cc: Huacai Chen <chenhuacai@kernel.org>
> > Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > Cc: Muchun Song <muchun.song@linux.dev>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: loongarch@lists.linux.dev
> > Cc: linux-mips@vger.kernel.org
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/loongarch/include/asm/hugetlb.h | 14 --------------
> >  arch/mips/include/asm/hugetlb.h      | 14 --------------
> >  fs/hugetlbfs/inode.c                 |  8 ++------
> >  include/asm-generic/hugetlb.h        |  8 --------
> >  include/linux/hugetlb.h              |  6 ------
> >  5 files changed, 2 insertions(+), 48 deletions(-)
> >
> > diff --git a/arch/loongarch/include/asm/hugetlb.h b/arch/loongarch/include/asm/hugetlb.h
> > index 4dc4b3e04225..ab68b594f889 100644
> > --- a/arch/loongarch/include/asm/hugetlb.h
> > +++ b/arch/loongarch/include/asm/hugetlb.h
> > @@ -10,20 +10,6 @@
> >
> >  uint64_t pmd_to_entrylo(unsigned long pmd_val);
> >
> > -#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
> > -static inline int prepare_hugepage_range(struct file *file,
> > -					 unsigned long addr,
> > -					 unsigned long len)
> > -{
> > -	unsigned long task_size = STACK_TOP;
> > -
> > -	if (len > task_size)
> > -		return -ENOMEM;
> > -	if (task_size - len < addr)
> > -		return -EINVAL;
> > -	return 0;
> > -}
> > -
> >  #define __HAVE_ARCH_HUGE_PTE_CLEAR
> >  static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
> >  				  pte_t *ptep, unsigned long sz)
> > diff --git a/arch/mips/include/asm/hugetlb.h b/arch/mips/include/asm/hugetlb.h
> > index fbc71ddcf0f6..8c460ce01ffe 100644
> > --- a/arch/mips/include/asm/hugetlb.h
> > +++ b/arch/mips/include/asm/hugetlb.h
> > @@ -11,20 +11,6 @@
> >
> >  #include <asm/page.h>
> >
> > -#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
> > -static inline int prepare_hugepage_range(struct file *file,
> > -					 unsigned long addr,
> > -					 unsigned long len)
> > -{
> > -	unsigned long task_size = STACK_TOP;
> > -
> > -	if (len > task_size)
> > -		return -ENOMEM;
> 
> arch_get_unmapped_area_topdown() has this check.
> 
> > -	if (task_size - len < addr)
> > -		return -EINVAL;
> 
> For this one, arch_get_unmapped_area_topdown() instead will try to
> provide a different addr if the check fails.
> 
> So this patch changes the original code behavior, right?

It almost shouldn't change.  Note that prepare_hugepage_range() is only
used for MAP_FIXED before this patch:

hugetlb_get_unmapped_area():
        if (flags & MAP_FIXED) {
                if (addr & ~huge_page_mask(h))
                        return -EINVAL;
                if (prepare_hugepage_range(file, addr, len))
                        return -EINVAL;
        }

Then for MAP_FIXED, on MIPS:

arch_get_unmapped_area_common():
        ...
	if (flags & MAP_FIXED) {
		/* Even MAP_FIXED mappings must reside within TASK_SIZE */
		if (TASK_SIZE - len < addr)
			return -EINVAL;
                ...
        }

But if we want to be super accurate, it's indeed different, in that the old
hugetlb code was checking stack top with STACK_TOP, which is
mips_stack_top() for MIPS: it's a value that might be slightly less than
TASK_SIZE..

So strictly speaking, there's indeed a trivial difference on the oddity of
defining stack top, but my guess is nothing will be affected.  I can add
some explanation into the commit message in that case.

Thanks,

-- 
Peter Xu


