Return-Path: <kvm+bounces-67851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA1FD15E22
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 317EC30031A2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 23:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087DC2D592D;
	Mon, 12 Jan 2026 23:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="KtPItGSB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2008285CA9
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 23:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768261990; cv=none; b=bPvIM0bgKX8cP5XvV/9u7hLqdaRX3vcyQDRw1sSpvR28xsh9w/7UzvbMVGBMWhnrKKCvytTV0NMuMGI3RFxWNEIrH7cLDidSiSSAMHyAaFHtQtr5IGIxegNmYlLLqg93TbrTETd7NzIxqfBar3L57o0z/C6xgPCpFcb2sFWaP7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768261990; c=relaxed/simple;
	bh=OsumxHHod6cIwX4b7rdpDcd79fga9ieWIlr7hu71obk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNYhIzvJcmpgCd0cvGn0+NglWHoj1olovMDSHADkIDDAh7JWX0377Enege1prq7MAiaMgMeP1RHbdPjYeIXn0vIwcrk0K7JM4cs4g9mSsshdOy+eZy2+LyY0euxWFp4yHcUO08EjDygA2K9buxo1xcCoWRCOESKY98ZLXIO2XgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=KtPItGSB; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b2d56eaaceso796120685a.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 15:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768261987; x=1768866787; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MFAPVPPrTQcXGzmX4uMQny5ONRwVZsvoYJMZG32QBJM=;
        b=KtPItGSBQvLvHb6BqDZRMhIZcvxl8SAHN+P7ok/p1aKuAQMtWJhhXrcREM04DDEH/v
         xpOJYL4tPEFlpIJ6XvEwhuUsWgkVv1Pv0jJAq8pmcmuUSI2SmuZldT+/vPwufztTxt52
         3P1FICBcMfFbtc64HIW+1ramux3MLbaDIVX/SnLL8rX4ZnTGWekTayWntFXxxLU9UTi8
         aOCgpbDmI4+N+THurVfFu8XBmuqY+yDiQUlMQ8hhLgqCRWd/RgUbcVnoA0q8aTqyplJd
         Ahtq7MGMGIAeCpiswjEJOgbIQnm3Xkub+Tak4us3eYoDIAA78DjRTgUHNibTKf2m6vwD
         oWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768261987; x=1768866787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFAPVPPrTQcXGzmX4uMQny5ONRwVZsvoYJMZG32QBJM=;
        b=EHiX63Ys9498AdLk6MUwPHXDR2amsmfDX9P06rccr28vQGd7EH1J1hJ3t927lHHL4R
         76zh83RPV6/kIS2SFH/3QDxOCLk/rIcFYPvnbX/GOPO1K/QsMz5qGVf5kB0dvcX9qYua
         aj34c5EsJ8JwblwNttur7TMWjER00wijxeUgyL94r0VYNuA8Jf5URpdH0AXmtPm47Olk
         /4HP3/v9UcChc5GasSRSV8LaixKIk2KvmU/V8bOLffd4sgQmmwUSG0NTvdUR2hYDCnDK
         SRsQbICLk/N2b+bhAmE3jr1fZhFt0jUXyZgi2yqJCXrZTl30aqAqeQsmLdvbdfJfyo4n
         Y6LA==
X-Forwarded-Encrypted: i=1; AJvYcCWD2oVwQhnQhntSbCGw6d/iXMntWHmniu+T74BWJ03nz3XhfvA0d2EZwubaaa0M/J4ZvkI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9ZkIJcdoGP2kqGsLOmQ9wgNfUB0U3hsqqk530C1Q1Lyo7x8X8
	FAvaccdeEtJRVjuifzq5mfIFmWaFAuzEeyeSzYZ+hwYGgKRAFyQJsWMvNMsSesAj9dk=
X-Gm-Gg: AY/fxX7ztIUGK4f7KlaDgWr5SPkjEyhKDYQOnOcAl26GyTnunW9qU96mpffJ81CzmKa
	TNyCdjO6qg+Jtv1va4r8YKyW54r9BlcitKR6x/ygLA4KeuvISHaIUMNc2CltvP6hnK6ew/fcADA
	nENvMyVmyO1SCBaTJNQAmWJ4chfmQkxJD4Q1jDcgbCiOK2zHfNWkLxi3Zkz9iGB1BHsvEU1OpPl
	A9MTp6CYmU4IlFzqMJf7Q5SUxMu8GeMpmXC1+sxvEZd92whw21hpDybSS7aNFdXm7frPbpjslC4
	AOZloHUyEUja+SFtYCXTjzwbk/jOPfzSXXLZD/bE3SGYA47B9gK8iKlOVlmk/uQoppze2R5+uwD
	Av+ld/HiIkiRpuyKZIOg4++8Z5mUbKqRP2EBKRjRuVaG7mKZjmQRmyQ8rASfRnuRIreFVtdjfUT
	0kI4GIchpQ444/eYjqV5v3ya8OXhdAkl+3JwRGWGCxZO0Kj3E5P7lChhMi7vwy+q9wgpKKGsYTx
	BWSxw==
X-Google-Smtp-Source: AGHT+IECCLtz04Q1g6y58MlK+cu2G+IQ+shlJTLlvJFkV+wtTDGmcQVfka7R8tosUNuc3dGp+UEbDg==
X-Received: by 2002:a05:620a:4804:b0:8b2:7536:bd2c with SMTP id af79cd13be357-8c3894188a8mr2759937485a.78.1768261987580;
        Mon, 12 Jan 2026 15:53:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f530907sm1597443885a.39.2026.01.12.15.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:53:07 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfRic-00000003fUQ-2VnR;
	Mon, 12 Jan 2026 19:53:06 -0400
Date: Mon, 12 Jan 2026 19:53:06 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Balbir Singh <balbirs@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alistair Popple <apopple@nvidia.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free
 callback
Message-ID: <20260112235306.GN745888@ziepe.ca>
References: <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <218D42B0-3E08-4ABC-9FB4-1203BB31E547@nvidia.com>
 <20260112165001.GG745888@ziepe.ca>
 <86D91C8B-C3EA-4836-8DC2-829499477618@nvidia.com>
 <20260112182500.GI745888@ziepe.ca>
 <6AFCEB51-8EE1-4AC9-8F39-FCA561BE8CB5@nvidia.com>
 <20260112192816.GL745888@ziepe.ca>
 <8DB7DC41-FDBD-4739-AABC-D363A1572ADD@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8DB7DC41-FDBD-4739-AABC-D363A1572ADD@nvidia.com>

On Mon, Jan 12, 2026 at 06:34:06PM -0500, Zi Yan wrote:
> page[1].flags.f &= ~PAGE_FLAGS_SECOND. It clears folio->order.
> 
> free_tail_page_prepare() clears ->mapping, which is TAIL_MAPPING, and
> compound_head at the end.
> 
> page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP. It clears PG_head for compound
> pages.
> 
> These three parts undo prep_compound_page().

Well, mm doesn't clear all things on alloc..

> In current nouveau code, ->free_folios is used holding the freed folio.
> In nouveau_dmem_page_alloc_locked(), the freed folio is passed to
> zone_device_folio_init(). If the allocated folio order is different
> from the freed folio order, I do not know how you are going to keep
> track of the rest of the freed folio. Of course you can implement a
> buddy allocator there.

nouveau doesn't support high order folios.

A simple linked list is not really a suitable data structure to ever
support high order folios with.. If it were to use such a thing, and
did want to take a high order folio off the list, and reduce its
order, then it would have to put the remainder back on the list with a
revised order value. That's all, nothing hard.

Again if the driver needs to store information in the struct page to
manage its free list mechanism (ie linked pointers, order, whatever)
then it should be doing that directly.

When it takes the memory range off the free list it should call
zone_device_page_init() to make it ready to be used again. I think it
is a poor argument to say that zone_device_page_init() should rely on
values already in the struct page to work properly :\

The usable space within the struct page, and what values must be fixed
for correct system function, should exactly mirror what frozen pages
require. After free it is effectively now a frozen page owned by the
device driver.

I haven't seen any documentation on that, but I suspect Matthew and
David have some ideas..

If there is a reason for order, flags and mapping to be something
particular then it should flow from the definition of frozen pages,
and be documented, IMHO.

Jason

