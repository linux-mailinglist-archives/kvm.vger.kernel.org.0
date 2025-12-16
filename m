Return-Path: <kvm+bounces-66079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8CECC417C
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 17:01:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CC5CC3032FCA
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 16:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775E921D5AA;
	Tue, 16 Dec 2025 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E8CYQtc0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FBbjbNbA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987C9BE5E
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765900876; cv=none; b=H3tP77GBYrSNLxbnoll1HFPWT/afmFZSSX1CfbNBuHOHHdoT44rmRK68uRsXrM+I70qzOropFDiIeAju+khe1QLkaYNcEMMUCS62bpcwChMh6ngwFHQm3qXB7ZRL4KhYrOtYTUzWD4HUI43OeHd6SpX1RhILBnzi9VVzQShk0v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765900876; c=relaxed/simple;
	bh=m88QLC+oVnYPsufMnNon6VNqltsXTCx4ykwu3hUkxX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=so+lsvG3DAgHEJ6ovzUIMIsW2WTUApliS2MaHUTRJQDv5P9LE1ges+jFcyyvIzZcEGxlfjtqhbWMVEReXVR22HKUL6BUiRXKMh6G2tdkEdksOTHFyhisXIcU8RPmoxQ4yj7wNfT1KwbdT7P3BuSP/mwiglVCikl0+RWIdlysuOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E8CYQtc0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FBbjbNbA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765900873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7n/t6p/jvZYpUfKx4Fl0OmmPDhqaugBP8Gk8GNKqtjk=;
	b=E8CYQtc0/MIWjW71TzVODfL0UxCSzlbUiOCMMW59Fx+2tg2IOmzBXp+JAckRb7tv+CQCmQ
	/UrkZAU4p9BpyLsPAqTbdzrWpiNw1MrFS0kpOUi4VvRLtgJwEMO4n2e1dy0ctHGZF8ZTqa
	YygrsAUBgJxVz90qK6ukDzoUv/J7xXE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-FH1YebelP3KbndQDFWQ41g-1; Tue, 16 Dec 2025 11:01:12 -0500
X-MC-Unique: FH1YebelP3KbndQDFWQ41g-1
X-Mimecast-MFC-AGG-ID: FH1YebelP3KbndQDFWQ41g_1765900871
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7ba92341f38so5501716b3a.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 08:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765900871; x=1766505671; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7n/t6p/jvZYpUfKx4Fl0OmmPDhqaugBP8Gk8GNKqtjk=;
        b=FBbjbNbAdBkdmPeUHsvImi5NyKQfrour3Tk5JvZ6wq1D71mY50xMzCg6nXRXMaZ4we
         mEkhtnsDQlRXU+bljA1hq3LUtHBC5TqrJxdtvtZzB7IvhYfJJQRVaU/LWmTaKbDInBdd
         lSRF0WJ5j3dkcmEPwslNAT5zsoix84iBGtbGdG0i7GxMvaNO9x+XquOhiu+sLkFxXDm1
         9S+RvYiMpoc6GtohkLgBwM1unlsQvSCPm4fmIO3Wg6FCoInCMoNJnTUBV7InMGzNL1rM
         7GHukrt/LIDNeCVQjDnYIcUPUocFAQYpUGx5wkT9xMgwu1cNrnwvPNPK8mmWwkpR6KwZ
         jHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765900871; x=1766505671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7n/t6p/jvZYpUfKx4Fl0OmmPDhqaugBP8Gk8GNKqtjk=;
        b=N8LNjHqVJy/4ELKykv30UZQVuHpFjYnfmf8ysiTfR8sl+E6bDRZI5FCnlvMvQBzew/
         rJ1/9LHo6nItMLGwUlPhV5VOSWtgXtS3JtsZZQtioa/qm7JsFC5EhISS31F7vyMHhgQC
         RKOqB/WFvnZRMkGisUvKMYRedPOnDwfiwqBAAVjs4opS8bpFIKWswm/63DRzlhJckHxe
         pvBuXeYFIi9ughAucLIhlTRXrkG18KB6ZNkOWmDMSXn2JUIS3DRGl2NF6ogCyiV/Nmps
         WLCSpqYElqncaRn4uexpD9GbTYGd9r5L5zQRwfQjA6D6ecwXIHKTKhA5ByHmfyLM4dMp
         g3CA==
X-Gm-Message-State: AOJu0Yxnpv3b1mkdWlVUMTkMXwi6grS2vH45q8TgfUtM6k1pon4hlgjG
	LsRc/0px/6O9Qa6zmwwoGXzEVQjdjlt3eSdw/DR8SqKf34KLbC1cE5n/c+5amCQT3/dI+usYIVn
	i4ETLOrO7FKS28h+SrcDln3Zqqm9Do2Mf5jV5POybHeTbEUYgcJXloA==
X-Gm-Gg: AY/fxX54h+W380VZCC8n8I0/yOfRKeC0iwT7baM6a7khAJwQXd27AEE4rkemxoV+67L
	zRL5NFXXRgFpH4cWHsRQnhE42QaJz9hkE2q5/gBrQIBWYVxMR1jrnaODi/Cc+bkgT8ZryhVqfTn
	d0UVqZo7jWwJsBt8/y1pMiD9cg0nBgCvhTW3YiiwEZaRpizgRRNwtZbdcgvM4pPfy8gqZlvVceG
	/LpePBOrbLYtM8JofWq0qNSd82TU39VvVtXFoMvhQa1chThmI7cbg56afcOOkbpSufDUms+AEKK
	uH/ashaZR5gZ2GG30WQMyyrC6+Q58EcOi25IiCWDjReu4xtxfBxsi2v8cAAEftEplmYIqYakyVk
	ji14=
X-Received: by 2002:a05:6a00:2993:b0:781:4f0b:9c58 with SMTP id d2e1a72fcca58-7f667935e19mr15661160b3a.15.1765900870463;
        Tue, 16 Dec 2025 08:01:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFETgvpZCauQRnRvkaRDXoTYEkmrTUKb8yH8PJYSGK8XQagrI3k5h20qj2x7yaO23LdoS5X+w==
X-Received: by 2002:a05:6a00:2993:b0:781:4f0b:9c58 with SMTP id d2e1a72fcca58-7f667935e19mr15661042b3a.15.1765900869272;
        Tue, 16 Dec 2025 08:01:09 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c53834a7sm15772514b3a.55.2025.12.16.08.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 08:01:08 -0800 (PST)
Date: Tue, 16 Dec 2025 11:01:00 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aUGCPN2ngvWMG2Ta@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
 <aTnbf_dtwOo_gaVM@x1.local>
 <20251216144224.GE6079@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251216144224.GE6079@nvidia.com>

On Tue, Dec 16, 2025 at 10:42:24AM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 10, 2025 at 03:43:43PM -0500, Peter Xu wrote:
> > > This seems a bit weird, the vma length is already known, it is len,
> > > why do we go to all this trouble to recalculate len in terms of phys?
> > > 
> > > If the length is wrong the mmap will fail, so there is no issue with
> > > returning a larger order here.
> > > 
> > > I feel this should just return the order based on pci_resource_len()?
> > 
> > IIUC there's a trivial difference when partial of a huge bar is mapped.
> > 
> > Example: 1G bar, map range (pgoff=2M, size=1G-2M).
> > 
> > If we return bar size order, we'd say 1G, however then it means we'll do
> > the alignment with 1G. __thp_get_unmapped_area() will think it's not
> > proper, because:
> > 
> > 	loff_t off_end = off + len;
> > 	loff_t off_align = round_up(off, size);
> > 
> > 	if (off_end <= off_align || (off_end - off_align) < size)
> > 		return 0;
> > 
> > Here what we really want is to map (2M, 1G-2M) with 2M huge, not 1G, nor
> > 4K.
> 
> This was the point of my prior email, the alignment calculation can't
> just be 'align to a size'. The core code needs to choose a VA such
> that:

IMHO these are two different things we're discussing here.  I've replied in
the other email about pgoff alignments, I think it's properly done, let's
keep the discussion there.  I'll reply to the other issue raised.

> 
>    VA % (1 << order) == pg_off % (1 << order)
> 
> So if VFIO returns 1G then the VA should be aligned to 2M within a 1G
> region. This allows opportunities to increase the alignment as the
> mapping continues, eg if the arch supports a 32M 16x2M contiguous page
> then we'd get 32M mappings with your example.
> 
> The core code should adjust the target order from the driver by:
>    lowest of order or size rounded down to a power of two
>  then
>    highest arch supported leaf size below the above

Yes, maybe this would be better.

E.g. I would expect if a driver has 32M returned (order=13), then on x86_64
it should be adjusted to 2M (order=9), but on a 4K pgsize arm64 it should
be kept as 32M (order=13) as it matches contpmds.

Do we have any function that we can fetch the best mapping lower than a
specific order?

> 
> None of this logic should be in drivers.

I still think it's the driver's decision to have its own macro controlling
the huge pfnmap behavior.  I agree with you core mm can have it, I don't
see it blocks the driver not returning huge order if huge pfnmap is turned
off.  VFIO-PCI currently indeed only depends directly on global THP
configs, but I don't see why it's strictly needed.  So I think it's fine if
a driver (even if global THP enabled for pmd/pud) deselect huge pfnmap for
other reasons, then here the order returned can still always be PSIZE for
the driver.  It's really not a huge deal to me.

> 
> The way to think about this is that the driver is returning an order
> which indicates the maximum case where:
> 
>    VA % (1 << order) == pg_off % (1 << order)
> 
> Could be true. Eg a PCI BAR returns an order that is the size of the
> BAR because it is always true. Something that stores at most 1G pages
> would return 1G pages, etc.
> 
> > Note that here checking CONFIG_ARCH_SUPPORTS_P*D_PFNMAP is a vfio behavior,
> > pairing with the huge_fault() of vfio-pci driver.  It implies if vfio-pci's
> > huge pfnmap is enabled or not.  If it's not enabled, we don't need to
> > report larger orders here.
> 
> Honestly, I'd ignore this, and I'm not sure VFIO should be testing
> those in the huge_fault either. Again the core code should deal with
> it.
> 
> > Shall I keep it simple to leave it to drivers, until we have something more
> > solid (I think we need HAVE_ARCH_HUGE_P*D_LEAVES here)?
> 
> Logic like this should not be in drivers.
> 
> > Even with that config ready, drivers should always still do proper check on
> > its own (drivers need to support huge pfnmaps here first before reporting
> > high orders).  
> 
> Drivers shouldn't implement this alignment function without also
> implementing huge fault, it is pointless. Don't see a reason to add
> extra complexity.

It's not implementing the order hint without huge fault.  It's when both
are turned off in a kernel config.. then the order hint (even from driver
POV) shouldn't need to be reported.

I don't know why you have so strong feeling on having a config check in
vfio-pci drivers is bad.  I still think it's good to have it pairing with
the same macro in huge_fault(), because it's essentially part of the whole
pfnmap feature so it's fair they're guarded by the same kernel config, but
I'm ok either way in case of current case of vfio-pci where it 100% depends
on global THP setups.

-- 
Peter Xu


