Return-Path: <kvm+bounces-24164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CFE951F7D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C40E61C20F71
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7221B8E92;
	Wed, 14 Aug 2024 16:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8/JJHwS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237BD1B86C1
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 16:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723651736; cv=none; b=DuXMwsguXl1GyekMcNncXx9gnzycsuD2fEesTCnwJM0UvFwU5jeHUmYJQYx5roBSIMO2yoTZOGvr8PMICopp/2hG7Ezal+51/epJrb/Tv7paSaCrhf2TSXFhNuDPPA6hBMOgxo5F8TEdGV4NwiEBOS8MBXAVyvMlyS1iG/fdsHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723651736; c=relaxed/simple;
	bh=Mho0lXS2S8x36emR7a9jraWTYMgHBOISBpfsZCmj1G8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLqDnPAcPualvjVGqxiA2EcveVL7yWbFcV3fr4tYS9hlDZ/Jg3OeD5c3o579gpnlwiph0I0unvB6IlzV8Uehjw4xvpAXyiJ38OrveNhSvEvKR+ngyFKzD5iK9DJ9Ne511dxAFa1qDDsBQwCbfQ4UcHg3i93j6B3Vi71ObeA2ih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N8/JJHwS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723651734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCQFSIeDwOTQt5HDmaLH+zjBp75O10MjJ4dyFVJRUrI=;
	b=N8/JJHwS+wIB2sL+Vq6joQNbSA601ypswluwFS6jNKTtRX13GmQiYDAdiH05NW2SwxSEZU
	psvyrYj5rtsVipiGRQAfMaO3r53ZDLyGUyNwjE6k5lQW854ovwrWdz5MTshu7TyXch6m/R
	uPrLsRNBOrbjcAZFGaQg6GupU7kgltk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-dvbZdBJmMfGl3zR6eE4jyg-1; Wed, 14 Aug 2024 12:08:52 -0400
X-MC-Unique: dvbZdBJmMfGl3zR6eE4jyg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-81f99189f5fso8337239f.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 09:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723651732; x=1724256532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eCQFSIeDwOTQt5HDmaLH+zjBp75O10MjJ4dyFVJRUrI=;
        b=rozFTt8tZo97CBA7y6siGsDVUTFWMU4xhRSLvGcgGTgeolGWtILwNfJCj+3V0rHLwP
         2Xt0m5Xv3qEcSKYiyaeixGYJr9Vp9UHCQZmy6PCR2Bla2eBNIOPlX/N1hiRU3YWYOrl8
         2ayYFUdfl+l705MZNKoyhb4Da8y8FZ3BO4zhfkHRaTSc3SrgVDtxa1PeRsONEV1uFiD5
         DlbEiv40ezBJPvpbB3IqJWwuz2hbOfOnjF8pa/+rBcBF0JPAO3FhHOzZsCWKjvH1eA4E
         U5YXpadmpeMaRiDECzTixKGwaCCqTdEtwN/gNVcsAZ1+jpUMSLc43tmHWsbwXb06AG1d
         SIoQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6BV7rUasa+P6qZ/shZDx8LaYC/DjqB6vx6cMvn+a6eZ3a4Rz4UtIxcYBLXRmHBekJsTca3mLJeJ/f9wUSbwUtyx6C
X-Gm-Message-State: AOJu0YyErdVXzWp0RZoJrqwsv1M4keGo8bxbWRtXJVgGa/lP25+98BU0
	wHn09svUA4LNShMKut7ZKNIJZ7xUsIBgcBzaK6g6ry5ROY32ry/Cz02kG1NoqGPLZ/ELaDqYseE
	CESrNR7YjHkGJj5nIvYmZC377BbweRSlDKv8bKXqgdvSbLUYv/A==
X-Received: by 2002:a05:6602:6d19:b0:81f:9215:80da with SMTP id ca18e2360f4ac-824dacdaf5amr442805739f.4.1723651732009;
        Wed, 14 Aug 2024 09:08:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyNuZ7oXWmfRZ0F1HaRl5CrVwWgXo73deaQcT2xIvtNUe5RT9qbnqyv76Wse5AYqDjEvk6VA==
X-Received: by 2002:a05:6602:6d19:b0:81f:9215:80da with SMTP id ca18e2360f4ac-824dacdaf5amr442801939f.4.1723651731455;
        Wed, 14 Aug 2024 09:08:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ca769102a4sm3320413173.18.2024.08.14.09.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 09:08:50 -0700 (PDT)
Date: Wed, 14 Aug 2024 10:08:49 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, Will Deacon <will@kernel.org>, Gavin Shan
 <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zi Yan
 <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, Alistair
 Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David
 Hildenbrand <david@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Yan Zhao
 <yan.y.zhao@intel.com>
Subject: Re: [PATCH 19/19] vfio/pci: Implement huge_fault support
Message-ID: <20240814100849.601c14da.alex.williamson@redhat.com>
In-Reply-To: <20240814132508.GM2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
	<20240809160909.1023470-20-peterx@redhat.com>
	<20240814132508.GM2032816@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Aug 2024 10:25:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Aug 09, 2024 at 12:09:09PM -0400, Peter Xu wrote:
> > @@ -1672,30 +1679,49 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
> >  		goto out_unlock;
> >  
> > -	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
> > -	if (ret & VM_FAULT_ERROR)
> > -		goto out_unlock;
> > -
> > -	/*
> > -	 * Pre-fault the remainder of the vma, abort further insertions and
> > -	 * supress error if fault is encountered during pre-fault.
> > -	 */
> > -	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
> > -		if (addr == vmf->address)
> > -			continue;
> > -
> > -		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
> > -			break;
> > +	switch (order) {
> > +	case 0:
> > +		ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
> > +		break;
> > +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> > +	case PMD_ORDER:
> > +		ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn + pgoff,
> > +							     PFN_DEV), false);
> > +		break;
> > +#endif
> > +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> > +	case PUD_ORDER:
> > +		ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn + pgoff,
> > +							     PFN_DEV), false);
> > +		break;
> > +#endif  
> 
> I feel like this switch should be in some general function? 
> 
> vmf_insert_pfn_order(vmf, order, __pfn_to_pfn_t(pfn + pgoff, PFN_DEV), false);
> 
> No reason to expose every driver to this when you've already got a
> nice contract to have the driver work on the passed in order.
> 
> What happens if the driver can't get a PFN that matches the requested
> order?

There was some alignment and size checking chopped from the previous
reply that triggered a fallback, but in general PCI BARs are a power of
two and naturally aligned, so there should always be an order aligned
pfn.  Thanks,

Alex


