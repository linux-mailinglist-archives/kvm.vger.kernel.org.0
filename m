Return-Path: <kvm+bounces-24791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E47995A4D3
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 20:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45E00284816
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 18:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77B71B5303;
	Wed, 21 Aug 2024 18:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KhnrU+u1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9311D131A
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 18:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724265736; cv=none; b=SZf3cwJG/P+xwGaK+eeBZ0cEZta2InwKdVbmluOSUL38214YT+rJVmfDgRLP9cnFRzp9MHDa54bdSVwmJJlSdK+tFd+I3JSwHB0Ppjx3qQOnl0SlAcaNJHNGLLtUDBUbuNhEo6QZhLtlpfs5ukst3VEd78EmaOwPlQtCmQg8kqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724265736; c=relaxed/simple;
	bh=bFgyN/kXvo7b/UScYydAHDHbvcJhOi0knnbOTkA5tTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sA3NhJX+qvrhqPPse8C16i2mb2tLSAR2Y0n6xXv6Zw3F2LffHBjkAci3P8Q+3CHlUNzJ12EV5RYXS7oCOa+DJN83OoBDdGJ+A/BzgLzjHVGbW/heBn+wj4XlORVIegmSGr2Usx3xX0yGy6qDrFiSAyi5DSmoYpZvm+qHYeuz0vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KhnrU+u1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724265734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bxtRUWPBJDHjggPAMnTH/KRZh2Re9tIX9Caj2lJIIn8=;
	b=KhnrU+u1SBPArje1RW1IRIyP/5NCy6pkkTejvIRDyTNLrUu5DBpi7dGX2v+PHUQg/HOc1M
	q14dLm+cpuqBVQEZxJCGs1e+1PfZUvH5f8LR0mpYPebtHqeJaaHWK7yK8Fhr9HSo4fnHmW
	ExsHArgxdgf6Qp+/R7+neSQW+hF7uBM=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-1k0ADI38MKW2M01jae9WIA-1; Wed, 21 Aug 2024 14:42:12 -0400
X-MC-Unique: 1k0ADI38MKW2M01jae9WIA-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4f52183a0f8so7667e0c.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 11:42:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724265732; x=1724870532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxtRUWPBJDHjggPAMnTH/KRZh2Re9tIX9Caj2lJIIn8=;
        b=lSQ6YprE3u+c4zmQ/KcqwY85Lx7VP/YDiaO2+Grz2SlCw/xjUtbc7Dr+Wf0+8PKiy3
         Jlnv/PncZtmPzP4q1LhZvh20eNnwqKQEiH1IYcPWjLvgPneHeVHPK6swf4g7n2x4769M
         WLbTDwGwN4TAHgufR5XsCoxQQFyBgyb2hSpY4rPCsWAllRBEE9QHK21yKVU9Ks8+lMVA
         H1JAT0DAw8ziIP+raId518WBId6gdMO3vzRk4zoo9CDge2xxzignatKDj1uKm+V0YjC3
         0Di4GCC+QAJmjGVZlotHL/AvOBSKEQIi/UwoSZJ+Jeub2ufLtWg+h13oZ11S8UP/H90O
         Bd9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLMe5eXbBVAMNZ2bmFjeFw/jru3dXNQDT92E0HDXWJK2OGoUEdqhtenSbZdCVx0WHlBxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ6C0f62Fg7Ehg/4rvbp/hj2wdSoKoR3efjKBpfg1ldtj45jFZ
	fTtug9M+hTOrXTNV1Z1wh6iUwhL7eFUJO5fioOBz/QHMvE5AcWMIL56qTWy47HRmmcjCn49UOEf
	VxjhsfR0zJz+fakrXRkCpYU7jD87eqG03xM6OfWrIX7Iz2MI5lQ==
X-Received: by 2002:a05:6122:31aa:b0:4f5:2276:1366 with SMTP id 71dfb90a1353d-4fcf359b050mr3850784e0c.3.1724265732177;
        Wed, 21 Aug 2024 11:42:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2LW4+n8nTAfSzrfkkM6791Kkp4/ULsaTSZO+hvp6iv7hAwAb2/BkSllzEF9UW3wJdZt4VMA==
X-Received: by 2002:a05:6122:31aa:b0:4f5:2276:1366 with SMTP id 71dfb90a1353d-4fcf359b050mr3850745e0c.3.1724265731697;
        Wed, 21 Aug 2024 11:42:11 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bf6ff0fbb8sm63382556d6.144.2024.08.21.11.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 11:42:11 -0700 (PDT)
Date: Wed, 21 Aug 2024 14:42:08 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
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
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 06/19] mm/pagewalk: Check pfnmap early for
 folio_walk_start()
Message-ID: <ZsY1ABO25MelPQDF@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-7-peterx@redhat.com>
 <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com>
 <ZrZJqd8FBLU_GqFH@x1n>
 <d9d1b682-cf3c-4808-ba50-56c75a406dae@redhat.com>
 <20240814130525.GH2032816@nvidia.com>
 <81080764-7c94-463f-80d3-e3b2968ddf5f@redhat.com>
 <Zr9gXek8ScalQs33@x1n>
 <20240816173836.GD2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240816173836.GD2032816@nvidia.com>

On Fri, Aug 16, 2024 at 02:38:36PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 16, 2024 at 10:21:17AM -0400, Peter Xu wrote:
> > On Fri, Aug 16, 2024 at 11:30:31AM +0200, David Hildenbrand wrote:
> > > On 14.08.24 15:05, Jason Gunthorpe wrote:
> > > > On Fri, Aug 09, 2024 at 07:25:36PM +0200, David Hildenbrand wrote:
> > > > 
> > > > > > > That is in general not what we want, and we still have some places that
> > > > > > > wrongly hard-code that behavior.
> > > > > > > 
> > > > > > > In a MAP_PRIVATE mapping you might have anon pages that we can happily walk.
> > > > > > > 
> > > > > > > vm_normal_page() / vm_normal_page_pmd() [and as commented as a TODO,
> > > > > > > vm_normal_page_pud()] should be able to identify PFN maps and reject them,
> > > > > > > no?
> > > > > > 
> > > > > > Yep, I think we can also rely on special bit.
> > > > 
> > > > It is more than just relying on the special bit..
> > > > 
> > > > VM_PFNMAP/VM_MIXEDMAP should really only be used inside
> > > > vm_normal_page() because thay are, effectively, support for a limited
> > > > emulation of the special bit on arches that don't have them. There are
> > > > a bunch of weird rules that are used to try and make that work
> > > > properly that have to be followed.
> > > > 
> > > > On arches with the sepcial bit they should possibly never be checked
> > > > since the special bit does everything you need.
> > > > 
> > > > Arguably any place reading those flags out side of vm_normal_page/etc
> > > > is suspect.
> > > 
> > > IIUC, your opinion matches mine: VM_PFNMAP/VM_MIXEDMAP and pte_special()/...
> > > usage should be limited to vm_normal_page/vm_normal_page_pmd/ ... of course,
> > > GUP-fast is special (one of the reason for "pte_special()" and friends after
> > > all).
> > 
> > The issue is at least GUP currently doesn't work with pfnmaps, while
> > there're potentially users who wants to be able to work on both page +
> > !page use cases.  Besides access_process_vm(), KVM also uses similar thing,
> > and maybe more; these all seem to be valid use case of reference the vma
> > flags for PFNMAP and such, so they can identify "it's pfnmap" or more
> > generic issues like "permission check error on pgtable".
> 
> Why are those valid compared with calling vm_normal_page() per-page
> instead?
> 
> What reason is there to not do something based only on the PFNMAP
> flag?

My comment was for answering "why VM_PFNMAP flags is needed outside
vm_normal_page()", because GUP lacks supports of it.

Are you suggesting we should support VM_PFNMAP in GUP, perhaps?

Thanks,

-- 
Peter Xu


