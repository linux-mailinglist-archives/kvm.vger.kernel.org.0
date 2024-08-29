Return-Path: <kvm+bounces-25393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4DBA964E24
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 20:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E93021C2444D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5239D1B86CA;
	Thu, 29 Aug 2024 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlYJD/IB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E602414C59C
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 18:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724957125; cv=none; b=oNzFj5SYEXHkJx9q9fKjf/SOaNgiu/LK+u3u7ryZK2JC4XAhnbrkQpfAoRh/Z4q/4U1R6R0m3kHOZZgiVy697E+8/KetOHO48h/pmCZJHMT3eIQtEHAFJjAiRiioGEiOws0+m3YKtsNEU1MFlCbzKUGnzAyvNu3ZNvE6KFCRf18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724957125; c=relaxed/simple;
	bh=hsPlgUCeHK3mdXewDVil9aM02ONl8d3NiaSvuNuNE4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9vQ8RfhcZJ7vdCKOnsa009NWTpYOOVAHDT4JWiKHSMItab9RWDvFEV78cYGiCqwAhCP2e//9w+FHYaUQn1iRaQfCQaEx/iX9GcoUXYu9UX8mNWgCMIsjFsk7JkN4LCc4gjNzFniLJyUEzRaqo3a0rK2w1/MTzO1tYYgxXzlfzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlYJD/IB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724957122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SNxKnt1pOeKeNbmB5uGX+KLSDH8VwXu6pBqcboAJCGg=;
	b=WlYJD/IBCFfuI2L4ON1TkXF/ETWwhjlMXM+jKgRVi3rwdieP6NAzXgS+MhOFUN61qeh4qE
	TCf77tY4MUmd6CipbRclmX2oYWuAZH7zvqN/glfrYFe+NRtLCrmQQJZVlKhLBkH7ar++jk
	Vugr3q/utYPPZdGmEb/FlYxdHo+CHwY=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-AnzrOhiYPbSxJHYbvJ6_ZQ-1; Thu, 29 Aug 2024 14:45:21 -0400
X-MC-Unique: AnzrOhiYPbSxJHYbvJ6_ZQ-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-70932abea64so932257a34.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 11:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724957120; x=1725561920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNxKnt1pOeKeNbmB5uGX+KLSDH8VwXu6pBqcboAJCGg=;
        b=g2ZVbJGFhf5+3b6EbkqhZICnmD1UFGC/LEeT2En9VJe0vHlgr3L6z/AyYfs2FtbOl3
         qKSz1qu7ztHicw69hFNGRH19/jT2IBFeg2tWtUSBW5a+r490ejkR0UE8Y4dnjbUPFn/B
         5zr/boa5G9Ov5KL/xHeUvva84k/anvaigpS84U7lzpOb+8RIosaehbc80xUaZrbPCnpY
         unRTyKBhu6JnLQIXOmIkS51HTKZlzPPcw4maVchJ8CVJOL8B88815c74XlaxLFlFGVfz
         VjZqp3JznV6hOhPhmEYDMrJGnYEDVr/hQzKILkMA59ovfc+O/bQ/jFGbpbNxSkgjJiE6
         qnKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvuEggL/NQ03rgp0xWqqu8lqeI84W+rNkuUtWzIm0DQiERf6m79NDXbzAKXkKxaUF5ecE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH9R93qC8WIINjzAAJsZjbOqaql1I6cYxblveuEirtXxcpO0E/
	Y3lkn9f9gfYXU+ol2OX9SR6xBCF153kz1H4KN/OMcftkDAgHfPkH7/X+L4D/2H9KP75WZHNmSsV
	mi31fXI7wa2tLx5sUJTQdWKPvOajuUY4iTwVdleuWr07M5e9vrw==
X-Received: by 2002:a05:6830:4393:b0:70d:f23d:97fe with SMTP id 46e09a7af769-70f5c4b40admr3551779a34.33.1724957120530;
        Thu, 29 Aug 2024 11:45:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzQ8QvrwiOwTqzCT7fw2y797mlGiwpfpRY2dlwgwi44n8PyvYSGtPb7e0yosXO2yQoNYYadA==
X-Received: by 2002:a05:6830:4393:b0:70d:f23d:97fe with SMTP id 46e09a7af769-70f5c4b40admr3551752a34.33.1724957120217;
        Thu, 29 Aug 2024 11:45:20 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c340bfa6d0sm7797286d6.1.2024.08.29.11.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 11:45:19 -0700 (PDT)
Date: Thu, 29 Aug 2024 14:45:16 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 06/19] mm/pagewalk: Check pfnmap for folio_walk_start()
Message-ID: <ZtDBvAbcT-QI65Vt@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-7-peterx@redhat.com>
 <9f9d7e96-b135-4830-b528-37418ae7bbfd@redhat.com>
 <Zs8zBT1aDh1v9Eje@x1n>
 <c1d8220c-e292-48af-bbab-21f4bb9c7dc5@redhat.com>
 <Zs9-beA-eTuXTfN6@x1n>
 <20240828234652.GD3773488@nvidia.com>
 <2123f339-2487-4b1c-abb1-313e9a012242@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2123f339-2487-4b1c-abb1-313e9a012242@redhat.com>

On Thu, Aug 29, 2024 at 08:35:49AM +0200, David Hildenbrand wrote:
> Fortunately, we did an excellent job at documenting vm_normal_page():
> 
>  * There are 2 broad cases. Firstly, an architecture may define a pte_special()
>  * pte bit, in which case this function is trivial. Secondly, an architecture
>  * may not have a spare pte bit, which requires a more complicated scheme,
>  * described below.
>  *
>  * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
>  * special mapping (even if there are underlying and valid "struct pages").
>  * COWed pages of a VM_PFNMAP are always normal.
>  *
>  * The way we recognize COWed pages within VM_PFNMAP mappings is through the
>  * rules set up by "remap_pfn_range()": the vma will have the VM_PFNMAP bit
>  * set, and the vm_pgoff will point to the first PFN mapped: thus every special
>  * mapping will always honor the rule
>  *
>  *	pfn_of_page == vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT)
>  *
>  * And for normal mappings this is false.
>  *
> 
> remap_pfn_range_notrack() will currently handle that for us:
> 
> if (is_cow_mapping(vma->vm_flags)) {
> 	if (addr != vma->vm_start || end != vma->vm_end)
> 		return -EINVAL;
> }
> 
> Even if [1] would succeed, the is_cow_mapping() check will return NULL and it will
> all work as expected, even without pte_special().

IMHO referencing vm_pgoff is ambiguous, and could be wrong, if without a
clear contract.

For example, consider when the driver setup a MAP_PRIVATE + VM_PFNMAP vma,
vm_pgoff to be not the "base PFN" but some random value, then for a COWed
page it's possible the calculation accidentally satisfies "pfn ==
vma->vm_pgoff + off".  Then it could wrongly return NULL rather than the
COWed anonymous page here.  This is extremely unlikely, but just to show
why it's wrong to reference it at all.

> 
> Because VM_PFNMAP is easy: in a !COW mapping, everything is special.

Yes it's safe for vfio-pci, as vfio-pci doesn't have private mappings.  But
still, I don't think it's clear enough now on how VM_PFNMAP should be
mapped.

-- 
Peter Xu


