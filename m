Return-Path: <kvm+bounces-24328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6CB3953A5D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 20:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8FF31C230F3
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EEF679E5;
	Thu, 15 Aug 2024 18:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K80YGl4I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F6538382
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 18:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723747984; cv=none; b=Ixt+467YKPLdYWXRSJdbijrhNFSeW/TsyAMinHEHEu3VmQfq1srgFb++HhQRxW0L4DaLXBeQAKMvr4bQm/uix932K/yJGpvx0n82FKCRDwxH9MhqWPqSMyQuNxxRoooFCGYOoGmDr3J1ISjVTZ8/Kyx1/dHSmALGFx3kBmeXHWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723747984; c=relaxed/simple;
	bh=ZSNQwCwNatoyo2l0AzrYpXBqkxgsmHz1umBeGb87XZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VtyThV2beg637bvtMH+Ad1sENoBmE0/MxwHQM0Aw7ppCI7ra/it3ze7ScYtsSrRSv/ZxAFnBoPmilTOUbGwu5a8KJONXDYczrW3EWqKglef1CUlwgXdUNuP97hA19GfUKT34kzcxLYQuTf4loNLyJSy2l/1UM5cxe01lZ9Iuz7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K80YGl4I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723747981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IhERV/jL6UlsHTgwO0rZfirsXuvPDZ9y+GMqTvo5SLU=;
	b=K80YGl4IGjW0cw1lj47lV/mkgA3OCduiNbUhw5VC/HUsG0jRaE2Q2HifVTntY0+v//72bX
	JJgqcJc7yh5lQjarXQmwLAG6dI3h0/wEZp1GnF4bF3/g4meHiIumfZ1GdIMYpkmbPkpp92
	aRTD//TeYhCtatd0J4aRBg4JJZSetsY=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-4KZs5YL_MiSCQz1l0LYmSQ-1; Thu, 15 Aug 2024 14:53:00 -0400
X-MC-Unique: 4KZs5YL_MiSCQz1l0LYmSQ-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-4929ba5f7f4so30381137.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 11:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723747980; x=1724352780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IhERV/jL6UlsHTgwO0rZfirsXuvPDZ9y+GMqTvo5SLU=;
        b=pf1Fr2e8lIh2H18qn483LdyE9CPGU6eOde21Lx6C9sAxB6wv71WF7MHGrYZWBXbe7e
         S5hL3P4dQsNJZujfvOprKsEq4x6JEdkmgNk5cqy+IZ1IX5G42JS1gvcgR81xwbgcLEBb
         t6GhNppnRO3jo6JBAlIdq3j539sLddJypIwq8WjRMR0bItjT7hDgzI9SHDie5iiJDGB6
         9AJVzVOXRhq6SA0jpX5ybk15Tok3j7jGKZBZLdHoHxqNl7rM+IwOqkwHC5AwG6qYL4WD
         TCIhWjZSP5Kl3/8o/slOtfFRmwEp8/5nf3Am5UJq0pskGHG5i1c7oN0ACorOy77beO6B
         qzmg==
X-Forwarded-Encrypted: i=1; AJvYcCWUhGOC/UwI83XQcfnfrGgO4YyJ1vyswgEg1+JVbw32QdJQpQPS5cUvgLU9pJJulCAIiLY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9aVmqe6Prgt8eTUXaAXmDh4vOgpblAjpl8bYMIh/26W+DMUGg
	3s+/jCTT1Whl9GuCAHEq5ISjbeJJ19jDV9dXwrTJRgNSl6nFuWJ5mfK8zmsALvGaQp1zSE89pXj
	tnFt8qOn0G4rrf4QWP+5qyQo3IwJT8JiUU80myhAwwp7ZEFE+Aw==
X-Received: by 2002:a05:6102:cc7:b0:48d:aced:abff with SMTP id ada2fe7eead31-497798dde56mr529540137.1.1723747980116;
        Thu, 15 Aug 2024 11:53:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5mqFNb1PXl4pf/EBUVsWqezNxIo7H5nHPjHSbbxlg0TjpV2kIgUEe/oeqxt6K3fJhgIgYNg==
X-Received: by 2002:a05:6102:cc7:b0:48d:aced:abff with SMTP id ada2fe7eead31-497798dde56mr529525137.1.1723747979713;
        Thu, 15 Aug 2024 11:52:59 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff105fe3sm88156085a.109.2024.08.15.11.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 11:52:59 -0700 (PDT)
Date: Thu, 15 Aug 2024 14:52:56 -0400
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
Message-ID: <Zr5OiOqvkv2Fr8dp@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-10-peterx@redhat.com>
 <20240814131954.GK2032816@nvidia.com>
 <Zrz2b82-Z31h4Suy@x1n>
 <20240814221441.GB2032816@nvidia.com>
 <Zr4hs8AGbPRlieY4@x1n>
 <20240815161603.GH2032816@nvidia.com>
 <Zr44_VE_Z0qbH0yT@x1n>
 <20240815172445.GK2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240815172445.GK2032816@nvidia.com>

On Thu, Aug 15, 2024 at 02:24:45PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 15, 2024 at 01:21:01PM -0400, Peter Xu wrote:
> > > Why? Either the function only returns PFN map no-struct page things or
> > > it returns struct page stuff too, in which case why bother to check
> > > the VMA flags if the caller already has to be correct for struct page
> > > backed results?
> > > 
> > > This function is only safe to use under the proper locking, and under
> > > those rules it doesn't matter at all what the result is..
> > 
> > Do you mean we should drop the PFNMAP|IO check?
> 
> Yeah
> 
> >  I didn't see all the
> > callers to say that they won't rely on proper failing of !PFNMAP&&!IO vmas
> > to work alright.  So I assume we should definitely keep them around.
> 
> But as before, if we care about this we should be using vm_normal_page
> as that is sort of abusing the PFNMAP flags.

I can't say it's abusing..  Taking access_remote_vm() as example again, it
can go back as far as 2008 with Rik's commit here:

    commit 28b2ee20c7cba812b6f2ccf6d722cf86d00a84dc
    Author: Rik van Riel <riel@redhat.com>
    Date:   Wed Jul 23 21:27:05 2008 -0700

    access_process_vm device memory infrastructure

So it starts with having GUP failing pfnmaps first for remote vm access, as
what we also do right now with check_vma_flags(), then this whole walker is
a remedy for that.

It isn't used at all for normal VMAs, unless it's a private pfnmap mapping
which should be extremely rare, or if it's IO+!PFNMAP, which is a world I
am not familiar with..

In all cases, I hope we can still leave this alone in the huge pfnmap
effort, as they do not yet to be closely relevant.  From that POV, this
patch as simple as "teach follow_pte() to know huge mappings", while it's
just that we can't modify on top when the old interface won't work when
stick with pte_t.  Most of the rest was inherited from follow_pte();
there're still some trivial changes elsewhere, but here on the vma flag
check we stick the same with old.

> 
> > >   Any physical address obtained through this API is only valid while
> > >   the @follow_pfnmap_args. Continuing to use the address after end(),
> > >   without some other means to synchronize with page table updates
> > >   will create a security bug.
> > 
> > Some misuse on wordings here (e.g. we don't return PA but PFN), and some
> > sentence doesn't seem to be complete.. but I think I get the "scary" part
> > of it.  How about this, appending the scary part to the end?
> > 
> >  * During the start() and end() calls, the results in @args will be valid
> >  * as proper locks will be held.  After the end() is called, all the fields
> >  * in @follow_pfnmap_args will be invalid to be further accessed.  Further
> >  * use of such information after end() may require proper synchronizations
> >  * by the caller with page table updates, otherwise it can create a
> >  * security bug.
> 
> I would specifically emphasis that the pfn may not be used after
> end. That is the primary mistake people have made.
> 
> They think it is a PFN so it is safe.

I understand your concern. It's just that it seems still legal to me to use
it as long as proper action is taken.

I hope "require proper synchronizations" would be the best way to phrase
this matter, but maybe you have even better suggestion to put this, which
I'm definitely open to that too.

> 
> > It sounds like we need some mmu notifiers when mapping the IOMMU pgtables,
> > as long as there's MMIO-region / P2P involved.  It'll make sure when
> > tearing down the BAR mappings, the devices will at least see the same view
> > as the processors.
> 
> I think the mmu notifiers can trigger too often for this to be
> practical for DMA :(

I guess the DMAs are fine as normally the notifier will be no-op, as long
as the BAR enable/disable happens rare.  But yeah, I see you point, and
that is probably a concern if those notifier needs to be kicked off and
walk a bunch of MMIO regions, even if 99% of the cases it'll do nothing.

Thanks,

-- 
Peter Xu


