Return-Path: <kvm+bounces-24193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9D8952208
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 357B31C227FC
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF951BD519;
	Wed, 14 Aug 2024 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KejV07ZF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC5E1BD4EE
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 18:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723659895; cv=none; b=ngimas37BxwUfZxILR8x7K6jAhnz3+WUApFJNJyxabuVEjb7IQxbhyfuNE6wxS4EFn9kQ01exXYyIYZqv0BLkundYlkPIv1nUYFtyN5Rfi9kEkwVg++itEfLZBzqh5fVAmuBgev/O05dLsRanKOVFukISJwCURIcKaPRlj+xgys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723659895; c=relaxed/simple;
	bh=GDx0TupvxH6iITDdovx402980INbk2w6qoEyvtwX5sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+WiOcat9vwIQKYJE0hCe/GSXn57KObvaWUWn6yRxvyGlIe0Vi5p9bA4yVMwveLsyET9iVMqfPy4FNrbwsAwumJc37fnOGqF9GvisAnYT06GSRnyJ4xoHrtUD2eObmDwyPLgLmzpz0rcuGfd/MSNhnz26oqxtT4r7Kur8pRanVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KejV07ZF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723659892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J2cPNLPL+St3jqqHF4HLffkaByfXjHy/Gso61Lw3y7s=;
	b=KejV07ZFbPYS5oAIWm91YRcXlk4IFh+aOBxsWQgOy1memIH14D3ffOjXJLQKlQSZpqOshy
	x5fekxYVO8TvI9OknlIBcgFoDXrsT4e2BddbsOilcacvmt7fFzGr4oWWy1zKJ9NdlKO6Jn
	ssIHHy0D06Ko1rLt3edZyJqeiPACxFQ=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689--eN7co7iNH2jEUHCJuvdWw-1; Wed, 14 Aug 2024 14:24:51 -0400
X-MC-Unique: -eN7co7iNH2jEUHCJuvdWw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3dc2abc0ae0so6947b6e.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 11:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723659890; x=1724264690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J2cPNLPL+St3jqqHF4HLffkaByfXjHy/Gso61Lw3y7s=;
        b=f7I1hnR8KJ9P3Ivkm0s5QpLEIbwlwVWnhNWknJRKWAE34cHf0+yAouOn0B8xERQiYY
         hhntxrlnwJA9UTLMZHFiO7UCMibkrOsiO5kVZpYkWjvqVTE0bZ9GtcNKbc3BQVfOG1XY
         jyfZ7dTzpl0GZV1YK45FFWT1khVMtXD29yhR2gkiZd3cmjc/oFTV8GwauIlOxSspcpfM
         cD+ed4Druve0X9q4aHbK2z93Y/BwyIC7KUTb3b7tJo/hv82cr5rhAvmTJ3kGDwS5bcU/
         lCxFQpEQgYsmCEgHb7Sm0Idfwrj/7S7tuGkI89626pRsjg2hx4uk3hhyPVAld/KhrJ0K
         QNFw==
X-Forwarded-Encrypted: i=1; AJvYcCWmXVLT8Jyn3IV8aUipqd0ymvWpTH0MbjtFF8YdevaJxS0ypVo9SQFB2Szhj4Zoy03I1QQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFEbgiZLJH/dAUprU9ciRTtDZyWzpa5ojxO9yos6scppxvza+E
	p3LEArsDN7H05240B7eJHJiEKLiWvDpcg4NTdJVJoqqTg7VUE0cMOkJ8MPtTxb4nadkrcymm4pP
	GoBUp2qbhgnVSDh7xshg2if7K9Zvmg9WDo3kxUCuKOKpnI4Xy/g==
X-Received: by 2002:a05:6358:c028:b0:1b1:a6bd:7d1b with SMTP id e5c5f4694b2df-1b38581118fmr19890255d.0.1723659890278;
        Wed, 14 Aug 2024 11:24:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEgt7WDSWzC1mFW4VC3ihVIhbo4veIl/vdn/5xf3Z6L6GSvPP96mM0aI9XRX2zeVv7mjRtyQ==
X-Received: by 2002:a05:6358:c028:b0:1b1:a6bd:7d1b with SMTP id e5c5f4694b2df-1b38581118fmr19888655d.0.1723659889910;
        Wed, 14 Aug 2024 11:24:49 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4f0e00c31sm89382785a.88.2024.08.14.11.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 11:24:49 -0700 (PDT)
Date: Wed, 14 Aug 2024 14:24:47 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH 09/19] mm: New follow_pfnmap API
Message-ID: <Zrz2b82-Z31h4Suy@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-10-peterx@redhat.com>
 <20240814131954.GK2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240814131954.GK2032816@nvidia.com>

On Wed, Aug 14, 2024 at 10:19:54AM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 09, 2024 at 12:08:59PM -0400, Peter Xu wrote:
> 
> > +/**
> > + * follow_pfnmap_start() - Look up a pfn mapping at a user virtual address
> > + * @args: Pointer to struct @follow_pfnmap_args
> > + *
> > + * The caller needs to setup args->vma and args->address to point to the
> > + * virtual address as the target of such lookup.  On a successful return,
> > + * the results will be put into other output fields.
> > + *
> > + * After the caller finished using the fields, the caller must invoke
> > + * another follow_pfnmap_end() to proper releases the locks and resources
> > + * of such look up request.
> > + *
> > + * During the start() and end() calls, the results in @args will be valid
> > + * as proper locks will be held.  After the end() is called, all the fields
> > + * in @follow_pfnmap_args will be invalid to be further accessed.
> > + *
> > + * If the PTE maps a refcounted page, callers are responsible to protect
> > + * against invalidation with MMU notifiers; otherwise access to the PFN at
> > + * a later point in time can trigger use-after-free.
> > + *
> > + * Only IO mappings and raw PFN mappings are allowed.  
> 
> What does this mean? The paragraph before said this can return a
> refcounted page?

This came from the old follow_pte(), I kept that as I suppose we should
allow VM_IO | VM_PFNMAP just like before, even if in this case I suppose
only the pfnmap matters where huge mappings can start to appear.

> 
> > + * The mmap semaphore
> > + * should be taken for read, and the mmap semaphore cannot be released
> > + * before the end() is invoked.
> 
> This function is not safe for IO mappings and PFNs either, VFIO has a
> known security issue to call it. That should be emphasised in the
> comment.

Any elaboration on this?  I could have missed that..

> 
> The caller must be protected by mmu notifiers or other locking that
> guarentees the PTE cannot be removed while the caller is using it. In
> all cases. 
> 
> Since this hold the PTL until end is it always safe to use the
> returned address before calling end?

I suppose so?  As the pgtable is stable, I thought it means it's safe, but
I'm not sure now when you mentioned there's a VFIO known issue, so I could
have overlooked something.  There's no address returned, but pfn, pgprot,
write, etc.

The user needs to do proper mapping if they need an usable address,
e.g. generic_access_phys() does ioremap_prot() and recheck the pfn didn't
change.

Thanks,

-- 
Peter Xu


