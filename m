Return-Path: <kvm+bounces-49766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC77ADDD9D
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5E6418934A8
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 21:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6FEE2EA16C;
	Tue, 17 Jun 2025 21:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DM2Ipfhr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC182EF9D8
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750194463; cv=none; b=pJQubPyTrfKDhvXpNX8hEiN3CuYldvUDe4WYLaKlS/lndvXU6+fQwdIZBkDRVMHuiSxUGOBvscdRC/mvLX3UFFLtINvNb0e0c1pafPM8tmV3mMFRdD1zoD22nF7gjSBPkAgOjvDQyGZy4PHQuAhyUmzo6D8L67d+3S7rWBKwD/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750194463; c=relaxed/simple;
	bh=/YMbad19V6TpsG3MEiZ2mbTgkuu9Y0VSL2UolHVg1UE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVz6DkcYpIh8LVDSx776zWt+uF+TgwgL7CZDehI3in2EQi/tFtTbUF3wws7AMsZt4E86bF7UMcj15ZR/G0pDwgxTpsXE0KPtC0Qi0le2LVXkaQ5RnaSTrYkW2S5O/xRG8amF3BypcBrBmcjaUSG4MyRXFygCJWcGH93E2IjmPYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DM2Ipfhr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750194461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9waNqRMmOjunuN18CikjvGF9bugNIg2AINTl6Y0HXgo=;
	b=DM2IpfhrYAAjE6RwxOqGQG4oNI/ezdi2G8Dfc08o7Wj328zmGrcd5Su+gRyZPcBeyLr9cs
	0H2R3snZEgUxUIjL/fEa4QN6BlBh3woKP/pv29ij7eKNM7IiSyu2nHas6fC4P+6VGjR8zr
	0YBZ/qLQbbU/0NHIWkJAlH3ctd9bQIk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-JOYA_vBeN7Sjd0dkrbIFWQ-1; Tue, 17 Jun 2025 17:07:34 -0400
X-MC-Unique: JOYA_vBeN7Sjd0dkrbIFWQ-1
X-Mimecast-MFC-AGG-ID: JOYA_vBeN7Sjd0dkrbIFWQ_1750194454
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c5750ca8b2so925256485a.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 14:07:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750194454; x=1750799254;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9waNqRMmOjunuN18CikjvGF9bugNIg2AINTl6Y0HXgo=;
        b=PP5UYsDLtlnrOev32PjGPJIvINztT/wkG8btmrDOjFvfMqfQeKqIBM4uDT0q7dGd5v
         dDfcl/nS5qq21mLjvWODdFsbdh2G2ZnjZoxnromMvXHKnoYDgXpae7GdwwhtDTcPJZm9
         5yL09pSbLVqsv4zIeNkU4CnZVX84DlvMfulUrELbX7Mt5BD7m2JBCp/D5bbCqedvhs6x
         NqqYNWLvu+lXUrA/YwMmXfh0EekKktKKMmSHhxaTgfhylIADFjRVP8S3T9RUEPTE6kB+
         K34sbfNd8le1ZfVWh0Ab4r7+YyQSl5HjgA+SVZW3Wz9+oNCoZppVEcp4M87IdVOyjyVy
         dDtA==
X-Forwarded-Encrypted: i=1; AJvYcCU8S8qU98eQVDHDehlFhUJJZkJ0muWb9iFx+nuoG5U1etIQZv1WDsouONwIkYS/BEf3MWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdP9O8v4/dPzEhkP4oeWHYA5MriHm87Mer1mozQt6RodITWfFR
	ZHlJfW9/ZNqmjraAIbr9m4YtQA/0ORvzFg3c6YyUvUoG3oJzCkZkBt9LjVAnMxA1g+HYapd3vny
	YpWpXWdMSeewcQwRWd6ypz87plVJg3JGyK/IT+stGPiUIOrl5CpEadQ==
X-Gm-Gg: ASbGnculDqNvPU2LUriDa0HnJ5N9vnZcOpHBRx0QtTtg4ABbsBN0xDGpSmfMXoht40/
	AS/K0MRtDjCXXgxoG5TGM3o6XyI1xT4yF0uekWdxr/Qp5LkOr5UjX2ujcZS0B9kiuZvB2TG1hx1
	SPzyPBgG8Jkv+86spOklur97NQJKhp8fUgHXtKs8Aw2nVYApciKDIZWlEJav+mSehZXIUSOtl+A
	vTCQi+EVUvd1SnMnlr56eFb1RC4RSdmvR5Vo2OgJPg7ijgNtoqF+B64TyX8pwJcIzQ/AVpeEod4
	EwmBGb2ab6jCtA==
X-Received: by 2002:a05:620a:40c3:b0:7d2:2698:aab1 with SMTP id af79cd13be357-7d3c6c18fc1mr2412799285a.19.1750194454393;
        Tue, 17 Jun 2025 14:07:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjDInY101hnNdJuIa1SM4o6S/CNrzg2R+QnI69RAx4dIk51ymk26jNQS+KJeGfyRDLUZEXbQ==
X-Received: by 2002:a05:620a:40c3:b0:7d2:2698:aab1 with SMTP id af79cd13be357-7d3c6c18fc1mr2412795385a.19.1750194454011;
        Tue, 17 Jun 2025 14:07:34 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8e2173csm690984185a.52.2025.06.17.14.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 14:07:33 -0700 (PDT)
Date: Tue, 17 Jun 2025 17:07:30 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/hugetlb: Remove prepare_hugepage_range()
Message-ID: <aFHZEtepArJdkLB0@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-3-peterx@redhat.com>
 <4rypovqoa4j6f4fyfqzrm5xeiv3dng5hc5dlfhmnehkydk6gcd@z6f3k3joaoli>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4rypovqoa4j6f4fyfqzrm5xeiv3dng5hc5dlfhmnehkydk6gcd@z6f3k3joaoli>

On Sat, Jun 14, 2025 at 12:11:22AM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [691231 23:00]:
> > Only mips and loongarch implemented this API, however what it does was
> > checking against stack overflow for either len or addr.  That's already
> > done in arch's arch_get_unmapped_area*() functions, hence not needed.
> 
> I'm not as confident..
> 
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
> 
> arch/mips/include/asm/processor.h:#define STACK_TOP             mips_stack_top()
> 
> 
> unsigned long mips_stack_top(void)                                                                                                                                                                                                             
> {       
>         unsigned long top = TASK_SIZE & PAGE_MASK;                                                                                                                                                                                             
>         
>         if (IS_ENABLED(CONFIG_MIPS_FP_SUPPORT)) {
>                 /* One page for branch delay slot "emulation" */                                                                                                                                                                               
>                 top -= PAGE_SIZE;                                                                                                                                                                                                              
>         }                                                                                                                                                                                                                                      
>         
>         /* Space for the VDSO, data page & GIC user page */                                                                                                                                                                                    
>         top -= PAGE_ALIGN(current->thread.abi->vdso->size);                                                                                                                                                                                    
>         top -= PAGE_SIZE;
>         top -= mips_gic_present() ? PAGE_SIZE : 0;                                                                                                                                                                                             
>         
>         /* Space for cache colour alignment */                                                                                                                                                                                                 
>         if (cpu_has_dc_aliases)
>                 top -= shm_align_mask + 1;                                                                                                                                                                                                     
>         
>         /* Space to randomize the VDSO base */                                                                                                                                                                                                 
>         if (current->flags & PF_RANDOMIZE)
>                 top -= VDSO_RANDOMIZE_SIZE;                                                                                                                                                                                                    
>         
>         return top;                                                                                                                                                                                                                            
> }
> 
> This seems different than TASK_SIZE.
> 
> Code is from:
> commit ea7e0480a4b695d0aa6b3fa99bd658a003122113
> Author: Paul Burton <paulburton@kernel.org>
> Date:   Tue Sep 25 15:51:26 2018 -0700
> 
> 
> > -	if (len > task_size)
> > -		return -ENOMEM;
> > -	if (task_size - len < addr)
> > -		return -EINVAL;
> > -	return 0;
> > -}
> > -
> 
> Unfortunately, the commit message for the addition of this code are not
> helpful.
> 
> commit 50a41ff292fafe1e937102be23464b54fed8b78c
> Author: David Daney <ddaney@caviumnetworks.com>
> Date:   Wed May 27 17:47:42 2009 -0700
> 
> ... But the dates are helpful.  This code used to use:
> #define STACK_TOP      ((TASK_SIZE & PAGE_MASK) - PAGE_SIZE)
> 
> It's not exactly task size either.
> 
> I don't think this is an issue to remove this check because the overflow
> should be caught later (or trigger the opposite search).  But it's not
> clear why STACK_TOP was done in the first place.. Maybe just because we
> know the overflow here would be an issue later, but then we'd avoid the
> opposite search - and maybe that's the point?
> 
> Either way, your comment about the same check existing doesn't seem
> correct.

I will fix up the commit message to mention both archs:

  Only mips and loongarch implemented this API, however what it does was
  checking against stack overflow for either len or addr.  That's already
  done in arch's arch_get_unmapped_area*() functions, even though it may not
  be 100% identical checks.

  For example, for both of the architectures, there will be a trivial
  difference on how stack top was defined.  The old code uses STACK_TOP which
  may be slightly smaller than TASK_SIZE on either of them, but the hope is
  that shouldn't be a problem.

  It means the whole API is pretty much obsolete at least now, remove it
  completely.

> 
> I haven't checked loong arch, but I'd be willing to wager this was just
> cloned mips code... because this happens so much.

They define STACK_TOP differently, but AFAIU there're some duplications in
pattern of the two archs.

Please let me know if the fixed commit message works for you above, thanks.

-- 
Peter Xu


