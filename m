Return-Path: <kvm+bounces-23736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF3194D542
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B13A282485
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBBA46542;
	Fri,  9 Aug 2024 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RRVjJ/M1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F37747F
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723223729; cv=none; b=gpv5kl0m8Ko5Nb1lHcNHIBVdOP4M4HpTzOxOQDPc1WsG5Ck7WMUbPVqujtZrTIGkuJ+Nt06SFI3OQA9nvjuLP0AQgV9s8SUgGcD7jshuQv6FEXAStI1W4xrRLZEZoXWEUStwKsjwt893Xizug72vU+M2FDYTyeNAQvscXyxNAts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723223729; c=relaxed/simple;
	bh=BwpEztdg48zmsEANvHGayRgeJ5ktdIC0d0lY+MyHVg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQ6RIHtaPzmqWTtvdnBGwV4r6HVQCyWJdsMwNhlI49MXaW4SsUlDbowHyRIl6DRaL+BfLMrHulqIXn80bdmv1Z/18+TvEmvAGTZsfzAqrQe2Cs9I2kLkooC49NPP/y1uOgBspEOSVmF6fsqe+TwazQfQou7ewY/aEMDyFhYjLa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RRVjJ/M1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723223726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k1RM34U80cBuoBEaB3XScsq2LvIzrQPbOvXLfubi1Yw=;
	b=RRVjJ/M1kgaXmhwLD4LYy/xtGpbmLx5BiDJUVKIWegvvhjOleUmh/HFf+JNL8/usdJaBb9
	evNSur12f8yASjLuxQW5hVsCcYP0vFj2/MtOGfQ8b/4XwnK1BizF0+CEXNXMoHclS03ZgC
	5D8cncLboIIIKJTEmz6H16JeFqFj90w=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-D1hRpUY_NNmUHVqvCjiQyg-1; Fri, 09 Aug 2024 13:15:25 -0400
X-MC-Unique: D1hRpUY_NNmUHVqvCjiQyg-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3db15ea38baso624037b6e.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 10:15:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723223725; x=1723828525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1RM34U80cBuoBEaB3XScsq2LvIzrQPbOvXLfubi1Yw=;
        b=Fj5ufwqM4reTCFRrOzadtx36eDm8lkCSQ1zk57JjnSWisznY+C9Ykr8e7nfNc+LPEG
         oawRuS8eb3jU0VNOm5N26KJP1N5pAa6gjn7tjUvmwvxt2hpwVIoMaozHuLjSt27JEhzH
         wYp7jt9RiEqujCjJc9VFa0aWYFktFyZGusM4Kj6Gbe1vyQJR5mIIlWKVZojQ3LL/nQqg
         o7yheyeMn877JEq9Xb6ccDa0DEqDCLXTcJv/j1u6SznrkSKS5fQbqWVLPLlcbqIZEZGj
         XsP4WL/W3DUdDE44J7f7tQeuV5zJIuuQutTvp5xGQkciWWfoRxyEq+gpTlr9HH+2lx1O
         rUPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNXF3RNsKn+jsM9d5+yXw8lGS5RyWqtbvq0Kh9/bIhD5P3OSQ/8yiazN8rCcUO1ebnJyRPY9hTFckzldp+P+UIEV5/
X-Gm-Message-State: AOJu0YyKTMVxrJTwyqw1uwwN+OkKhpASP78ZilyBKmdTaAboLUkH59rc
	q46AZ24j6nR2I6eiuQTQHo/YeYNEe7AOAsmJ+LMjvrPnfzZ1oFAG8425hgCIZRnB6PmWiBB/87O
	ljztp02nmEGU43g2SsTKp2iYYtTLAhp0TvKOVmaXXhUofdHatQQ==
X-Received: by 2002:a05:6830:4113:b0:70b:2a0f:d2d8 with SMTP id 46e09a7af769-70b7c47ca90mr1694650a34.4.1723223724969;
        Fri, 09 Aug 2024 10:15:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDZ8AG8hkigQJRUf5X9BYk1irDNCGK0SoMgTlS1KNGbXDLrarAMaXAoHbkQ/XXZWQbMY2eQg==
X-Received: by 2002:a05:6830:4113:b0:70b:2a0f:d2d8 with SMTP id 46e09a7af769-70b7c47ca90mr1694631a34.4.1723223724644;
        Fri, 09 Aug 2024 10:15:24 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3785e67easm276234285a.52.2024.08.09.10.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 10:15:24 -0700 (PDT)
Date: Fri, 9 Aug 2024 13:15:21 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <ZrZOqbS3bcj52JZP@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-8-peterx@redhat.com>
 <d7fcec73-16f6-4d54-b334-6450a29e0a1d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d7fcec73-16f6-4d54-b334-6450a29e0a1d@redhat.com>

On Fri, Aug 09, 2024 at 06:32:44PM +0200, David Hildenbrand wrote:
> On 09.08.24 18:08, Peter Xu wrote:
> > Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
> > much easier, the write bit needs to be persisted though for writable and
> > shared pud mappings like PFNMAP ones, otherwise a follow up write in either
> > parent or child process will trigger a write fault.
> > 
> > Do the same for pmd level.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   mm/huge_memory.c | 27 ++++++++++++++++++++++++---
> >   1 file changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 6568586b21ab..015c9468eed5 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1375,6 +1375,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> >   	pgtable_t pgtable = NULL;
> >   	int ret = -ENOMEM;
> > +	pmd = pmdp_get_lockless(src_pmd);
> > +	if (unlikely(pmd_special(pmd))) {
> > +		dst_ptl = pmd_lock(dst_mm, dst_pmd);
> > +		src_ptl = pmd_lockptr(src_mm, src_pmd);
> > +		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> > +		/*
> > +		 * No need to recheck the pmd, it can't change with write
> > +		 * mmap lock held here.
> > +		 */
> > +		if (is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd)) {
> > +			pmdp_set_wrprotect(src_mm, addr, src_pmd);
> > +			pmd = pmd_wrprotect(pmd);
> > +		}
> > +		goto set_pmd;
> > +	}
> > +
> 
> I strongly assume we should be using using vm_normal_page_pmd() instead of
> pmd_page() further below. pmd_special() should be mostly limited to GUP-fast
> and vm_normal_page_pmd().

One thing to mention that it has this:

	if (!vma_is_anonymous(dst_vma))
		return 0;

So it's only about anonymous below that.  In that case I feel like the
pmd_page() is benign, and actually good.

Though what you're saying here made me notice my above check doesn't seem
to be necessary, I mean, "(is_cow_mapping(src_vma->vm_flags) &&
pmd_write(pmd))" can't be true when special bit is set, aka, pfnmaps.. and
if it's writable for CoW it means it's already an anon.

I think I can probably drop that line there, perhaps with a
VM_WARN_ON_ONCE() making sure it won't happen.

> 
> Again, we should be doing this similar to how we handle PTEs.
> 
> I'm a bit confused about the "unlikely(!pmd_trans_huge(pmd)" check, below:
> what else should we have here if it's not a migration entry but a present
> entry?

I had a feeling that it was just a safety belt since the 1st day of thp
when Andrea worked that out, so that it'll work with e.g. file truncation
races.

But with current code it looks like it's only anonymous indeed, so looks
not possible at least from that pov.

Thanks,

> 
> Likely this function needs a bit of rework.
> 
> -- 
> Cheers,
> 
> David / dhildenb
> 

-- 
Peter Xu


