Return-Path: <kvm+bounces-10787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E4686FE18
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 10:55:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CD56282025
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF222233A;
	Mon,  4 Mar 2024 09:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FFVw1ir9"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEB2208A2
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709546148; cv=none; b=OA5WWEQ2Z5ZudOwbHrNA+rt9ht5XO93ckLI/nKfmHkIup2ZRD/qWaL0Cn0UYUPhyrZhe7pofh6Sb6r4/sYbuP9Gg1N7d9Kw9CqNMEGFuF2EYuUEEttbK7vx8orKthipkVGi0Kp1DoPFRsUFKfKKS6Xuno04i1WdVcX8SZISLTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709546148; c=relaxed/simple;
	bh=1Mm9dRTQgjPzBkaNQnPnHrEGMtEfjaDgfmzP9NWshn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjhhXgh11FN0u9M9KPxjVvqtlc7VwLVOzj7lY5nOoHbIoQpeD868muZPzcJcXfR3m8o2Pbkj3G8YA4eo90Z/GstdLB0oaYbyH871WV1NVmzIowgumwuNuwjx0/3hI+JSciS6fG+iKbMWGOl/ddgunG0Q0cvGayb68oExOTpC8yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FFVw1ir9; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 4 Mar 2024 10:55:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709546144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GGup8Lw+aSd2ugIO2sejSm6SajL8kCyGLyvMIExqoyg=;
	b=FFVw1ir9bp4wHBTi0TBibjQS8aTlEAkNfY32ye2+nR76lwXqFaaFGcT+tcnib31hWKpmEg
	7KCo4pArS0O/NdaYIt5z0w6KhhY7qL9o6mQK7RUVtJSS7Li00joqg2N14Ectis3pWiSF3H
	AGnomtVeCCDjo1CrnO4EfJZRjD9oVYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, shahuang@redhat.com, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 13/18] arm64: Simplify efi_mem_init
Message-ID: <20240304-9cc10a0c64d1723d3c203cf2@orel>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-33-andrew.jones@linux.dev>
 <3d0cb559-87dc-423f-9461-574e810fbdb2@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d0cb559-87dc-423f-9461-574e810fbdb2@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 04, 2024 at 08:10:40AM +0000, Nikos Nikoleris wrote:
> On 27/02/2024 19:21, Andrew Jones wrote:
> > Reduce the EFI mem_map loop to only setting flags and finding the
> > largest free memory region. Then, apply memregions_split() for
> > the code/data region split and do the rest of the things that
> > used to be done in the EFI mem_map loop in a separate mem_region
> > loop.
> > 
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks. While skimming this patch now to remind myself about it for v3,
I see the etext = ALIGN() below which I forgot to consider. We certainly
need the end of the text section to be on a page boundary, but that
doesn't seem to be the case right now. I think we need to add this
change

diff --git a/arm/efi/elf_aarch64_efi.lds b/arm/efi/elf_aarch64_efi.lds
index 836d98255d88..7a4192b77900 100644
--- a/arm/efi/elf_aarch64_efi.lds
+++ b/arm/efi/elf_aarch64_efi.lds
@@ -13,6 +13,7 @@ SECTIONS
     *(.rodata*)
     . = ALIGN(16);
   }
+  . = ALIGN(4096);
   _etext = .;
   _text_size = . - _text;
   .dynamic  : { *(.dynamic) }

Thanks,
drew

> 
> Thanks,
> 
> Nikos
> 
> > ---
> >   lib/arm/setup.c | 45 ++++++++++++++++++++-------------------------
> >   1 file changed, 20 insertions(+), 25 deletions(-)
> > 
> > diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> > index d0be4c437708..631597b343f1 100644
> > --- a/lib/arm/setup.c
> > +++ b/lib/arm/setup.c
> > @@ -301,9 +301,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> >   	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
> >   	efi_memory_desc_t *buffer = *map->map;
> >   	efi_memory_desc_t *d = NULL;
> > -	struct mem_region r;
> > -	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
> > -	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
> > +	struct mem_region r, *code, *data;
> >   	const void *fdt = efi_bootinfo->fdt;
> >   	/*
> > @@ -337,21 +335,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> >   			r.flags = MR_F_IO;
> >   			break;
> >   		case EFI_LOADER_CODE:
> > -			if (r.start <= text && r.end > text) {
> > -				/* This is the unit test region. Flag the code separately. */
> > -				phys_addr_t tmp = r.end;
> > -
> > -				assert(etext <= data);
> > -				assert(edata <= r.end);
> > -				r.flags = MR_F_CODE;
> > -				r.end = data;
> > -				memregions_add(&r);
> > -				r.start = data;
> > -				r.end = tmp;
> > -				r.flags = 0;
> > -			} else {
> > -				r.flags = MR_F_RESERVED;
> > -			}
> > +			r.flags = MR_F_CODE;
> >   			break;
> >   		case EFI_CONVENTIONAL_MEMORY:
> >   			if (free_mem_pages < d->num_pages) {
> > @@ -361,15 +345,27 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> >   			break;
> >   		}
> > -		if (!(r.flags & MR_F_IO)) {
> > -			if (r.start < __phys_offset)
> > -				__phys_offset = r.start;
> > -			if (r.end > __phys_end)
> > -				__phys_end = r.end;
> > -		}
> >   		memregions_add(&r);
> >   	}
> > +	memregions_split((unsigned long)&_etext, &code, &data);
> > +	assert(code && (code->flags & MR_F_CODE));
> > +	if (data)
> > +		data->flags &= ~MR_F_CODE;
> > +
> > +	for (struct mem_region *m = mem_regions; m->end; ++m) {
> > +		if (m != code && (m->flags & MR_F_CODE))
> > +			m->flags = MR_F_RESERVED;
> > +
> > +		if (!(m->flags & MR_F_IO)) {
> > +			if (m->start < __phys_offset)
> > +				__phys_offset = m->start;
> > +			if (m->end > __phys_end)
> > +				__phys_end = m->end;
> > +		}
> > +	}
> > +	__phys_end &= PHYS_MASK;
> > +
> >   	if (efi_bootinfo->fdt_valid) {
> >   		unsigned long old_start = free_mem_start;
> >   		void *freemem = (void *)free_mem_start;
> > @@ -380,7 +376,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> >   		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
> >   	}
> > -	__phys_end &= PHYS_MASK;
> >   	asm_mmu_disable();
> >   	if (free_mem_pages == 0)

