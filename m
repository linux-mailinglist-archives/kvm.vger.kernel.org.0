Return-Path: <kvm+bounces-25261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC511962A86
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 829DF282BA3
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126EB19D08C;
	Wed, 28 Aug 2024 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EuO89/Cj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55E518786F
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724856110; cv=none; b=sh44kDX8iQr4xYMfgw9hKFVY+2zkF6XyF8vOI/xnkldFJZBt3OXnLjX0LKw1iXPydfRsA9/AiJqrcLSmj766vmFAub7iMOy+vms2/4q4a8gELe3n3AH3J57da0bg1zIPAnmmeNvA91KExa6hNj9qA/X9+TOzGZj5Ac3A8ICAYU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724856110; c=relaxed/simple;
	bh=2Sa6VJTnur7Cw+smbydwnb5Z2i+ckW6Fa9xkK58ZwDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7EIFZ+KVoVpprRYe10DDSp8EOlEPXCVM/aRa5hC7RD4Zj+e04Se3Rohh1E6ZH62Ljs4SyQhqT79MP7tQ90P3nEWWryOA416ykgySO5he/a65xZ5bdv85jz/0WBp+C6782c3o9GDYlRHLVDLcJVIthEAQXZKbUbPUNsp6R1+L/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EuO89/Cj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724856107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hvZdgP0NUcxYPpTm2+LyySi+WaC5CrwfGRx24HOtBqA=;
	b=EuO89/CjJ8OnyP0IZA62cCx4TTZ7I06pPTQTifEvsutCncY4xJJ8NAumg1aPNl9xchY/E2
	4hlnmnyKdbCfdRaPNMewL5kXKVFbJNocvGOE1WOm4EGe/hiTQKX98Cscn8w44EO+x4nRvI
	JrWeoBUzessd3IivdLgse4057vQ899c=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-j_f03bx3Ow2H8-EHTjy0hA-1; Wed, 28 Aug 2024 10:41:46 -0400
X-MC-Unique: j_f03bx3Ow2H8-EHTjy0hA-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-2701a253946so10570942fac.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 07:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724856105; x=1725460905;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hvZdgP0NUcxYPpTm2+LyySi+WaC5CrwfGRx24HOtBqA=;
        b=sgLr9hxoq0gG0rrDvBjaDXg2wDcq0LlNXlH4epktG9J9utzpYy7gJEorlSgxfeQB/m
         weZQoEaJWePWRHK5MKLyb6TdPETd0zy/erboiMLfkVy//eD2hPF0sIRxhGkgJfTlkA77
         5nSHmUAKlcEkouiwxYj3IHUX5M9S7YttxDyIWd54B47n3PxCry1+FyVBKVlycNf30rMe
         7XiAlKDhZkeQz5L8uj6FvoCblgqTFpc+RTMFu9d6HYORBKxNqUVxM6l1C33wn6R9KXeB
         uJOyhN2Y24gNNKrkS1/5ws2vh5d+EPJPCxBqVLBfya/oNGX0rxS4P3JAq/y0ZkQfGUzx
         nQSw==
X-Forwarded-Encrypted: i=1; AJvYcCUBZ0E3sUuDNkCdOEue12++ar4u5VRHBpXWuxRy3OOE8QBMFc4i2iywIMpcBVLuqnqpigc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3dThibQxZYRbz1lOpDJSuWqOpJPDaI8eNOULwotrvQ+kXMmOn
	akwrjmEeaimcUvhBphVjqM1dq3hWXEiUIzTqcPlPjO3HTn8yMy/+1a3HkPBNE+139Fu3DoX/X51
	QSkT3EsniT1hepXSERAeyfnxE9Iw1CVGCiQSba3GSAQtw28D3KA==
X-Received: by 2002:a05:6870:b1c9:b0:261:10b7:8c48 with SMTP id 586e51a60fabf-273e64e6a65mr18733936fac.27.1724856105117;
        Wed, 28 Aug 2024 07:41:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1e8zs2rKVQDk+rUuWOOwvpT4TAWto4m4s1MPtOxpMbOLBvZ55G4kPBLJOts7QICf1VZvizA==
X-Received: by 2002:a05:6870:b1c9:b0:261:10b7:8c48 with SMTP id 586e51a60fabf-273e64e6a65mr18733899fac.27.1724856104728;
        Wed, 28 Aug 2024 07:41:44 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-273ce9e38c9sm3780542fac.19.2024.08.28.07.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 07:41:44 -0700 (PDT)
Date: Wed, 28 Aug 2024 10:41:40 -0400
From: Peter Xu <peterx@redhat.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Message-ID: <Zs83JJhFY9S-Gxqc@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n>
 <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>

On Tue, Aug 27, 2024 at 05:42:21PM -0700, Jiaqi Yan wrote:
> On Tue, Aug 27, 2024 at 3:57 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Tue, Aug 27, 2024 at 03:36:07PM -0700, Jiaqi Yan wrote:
> > > Hi Peter,
> >
> > Hi, Jiaqi,
> >
> > > I am curious if there is any work needed for unmap_mapping_range? If a
> > > driver hugely remap_pfn_range()ed at 1G granularity, can the driver
> > > unmap at PAGE_SIZE granularity? For example, when handling a PFN is
> >
> > Yes it can, but it'll invoke the split_huge_pud() which default routes to
> > removal of the whole pud right now (currently only covers either DAX
> > mappings or huge pfnmaps; it won't for anonymous if it comes, for example).
> >
> > In that case it'll rely on the driver providing proper fault() /
> > huge_fault() to refault things back with smaller sizes later when accessed
> > again.
> 
> I see, so the driver needs to drive the recovery process, and code
> needs to be in the driver.
> 
> But it seems to me the recovery process will be more or less the same
> to different drivers? In that case does it make sense that
> memory_failure do the common things for all drivers?
> 
> Instead of removing the whole pud, can driver or memory_failure do
> something similar to non-struct-page-version of split_huge_page? So
> driver doesn't need to re-fault good pages back?

I think we can, it's just that we don't yet have a valid use case.

DAX is definitely fault-able.

While for the new huge pfnmap, currently vfio is the only user, and vfio
only requires to either zap all or map all.  In that case there's no real
need to ask for what you described yet.  Meanwhile it's also faultable, so
if / when needed it should hopefully still do the work properly.

I believe it's not usual requirement too for most of the rest drivers, as
most of them don't even support fault() afaiu. remap_pfn_range() can start
to use huge mappings, however I'd expect they're mostly not ready for
random tearing down of any MMIO mappings.

It sounds doable to me though when there's a need of what you're
describing, but I don't think I know well on the use case yet.

> 
> 
> >
> > > poisoned in the 1G mapping, it would be great if the mapping can be
> > > splitted to 2M mappings + 4k mappings, so only the single poisoned PFN
> > > is lost. (Pretty much like the past proposal* to use HGM** to improve
> > > hugetlb's memory failure handling).
> >
> > Note that we're only talking about MMIO mappings here, in which case the
> > PFN doesn't even have a struct page, so the whole poison idea shouldn't
> > apply, afaiu.
> 
> Yes, there won't be any struct page. Ankit proposed this patchset* for
> handling poisoning. I wonder if someday the vfio-nvgrace-gpu-pci
> driver adopts your change via new remap_pfn_range (install PMD/PUD
> instead of PTE), and memory_failure_pfn still
> unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT, PAGE_SIZE,
> 0), can it somehow just work and no re-fault needed?
> 
> * https://lore.kernel.org/lkml/20231123003513.24292-2-ankita@nvidia.com/#t

I see now, interesting.. Thanks for the link.  

In that case of nvgpu usage, one way is to do as what you said; we can
enhance the pmd/pud split for pfnmap, but maybe that's an overkill.

I saw that the nvgpu will need a fault() anyway so as to detect poisoned
PFNs, then it's also feasible that in the new nvgrace_gpu_vfio_pci_fault()
when it supports huge pfnmaps it'll need to try to detect whether the whole
faulting range contains any poisoned PFNs, then provide FALLBACK if so
(rather than VM_FAULT_HWPOISON).

E.g., when 4K of 2M is poisoned, we'll erase the 2M completely.  When
access happens, as long as the accessed 4K is not on top of the poisoned
4k, huge_fault() should still detect that there's 4k range poisoned, then
it'll not inject pmd but return FALLBACK, then in the fault() it'll see
the accessed 4k range is not poisoned, then install a pte.

Thanks,

-- 
Peter Xu


