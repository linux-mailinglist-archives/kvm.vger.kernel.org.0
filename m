Return-Path: <kvm+bounces-67826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9EBD14C08
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 33043301AE21
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2A63815C1;
	Mon, 12 Jan 2026 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="X5yKzpec"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE85387370
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242304; cv=none; b=mn/YWPPJQQEK09reMODd+/yc8CaZFHAr49du4Dmzq6QoCC2W8KxRSCugzs5t6zW7fceTrq31KzShEcxq7THn0ysf6FgLc5jHpSglVm/G4Wd8DDyC7CyYCVhywQPOBpHmdfJtKCpqKPV6OuGA2A5sO5y+BMkEc/CsZZD6w4A2j1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242304; c=relaxed/simple;
	bh=zGOveUJBSydj6+f1Ng48sG1u8gGyaZbL+TtCvCFhQyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnG932qo68+ENBVgoEUppxL91tGkP029jI+lGrjL8amFpZNBv3tNp3iiJNPPIHEiY+tXBV3wYq2/VALYbK9lL/BBK9SamjW4VNtP5LeGzzZymZvz0QnrCbgRf2DcmT4V7+xKNA34Q8KBIShIrEJD3YS09B6ZE9b8BHVIt8OthOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=X5yKzpec; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88a379ca088so73962666d6.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 10:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768242301; x=1768847101; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jdD8MqriJAO2uyiGLSo7KkiIHx3VWLqLd6aNoF+yCm8=;
        b=X5yKzpec7drmkLwczvotHIEs/RFApJJlDqIJrFABBm597UK3AtaxvQmn7L2a0gqWKc
         I/NFZxdnyIaTbC1Vnp/3JAbp5EmAJ7M8n7mARHPlcAzRHyAVAOy0yiNrY8gYYVasf9Tj
         PlJTnC56YVduwV5Lp8XP+YXgJc0YwfBy7HiTFEK/9Tvdgckp/FVA/6LMe38MGRGVB5UR
         TGatHKQS0Uv303CYzW8psHNHBHcp6W5jklx+95Bxkjz0SIbj/9B1G9xvzGWSez2Vn69u
         KtqwdsV7eEcss5kCDA4kzPztcm4yrV3fCxxALKK7lXuPZJX3/dzMJhNYYhirMp19EJj4
         rMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242301; x=1768847101;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdD8MqriJAO2uyiGLSo7KkiIHx3VWLqLd6aNoF+yCm8=;
        b=iPhpBS6zb9wQ/uaX5X1/qezGr/6as7YK8QULprZ30Nnt0S7VabygKU/AEU7emhw67C
         ZFVdjaXDcWe76oMBbxWtJuhzUZhTwH3bujTJpvlf6kMQ++vw3GPmsqUNfTE/hZ+4MT0j
         br/WPnc/DoEDoasQbbPzRh16/tptEA3DTO6rAdwe4h9Ev8I7D1wDgMJMXNiSs88aoyl2
         yYqbth9fmlQhZN2wEuinDVFPedLDZvQUkGyROon4IoilchGl7vHZbZn++7JAGBHQ5sPO
         v51ANZyCqUsEJ8DEIVil8ozgv+7sXuJhZFvV2VDv6Vd+vYdT9UgBigW/ZEJliLIC3tI9
         YAJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGAgp6zuOueoH5CTWE7fuy0APlngMJp3N/Iz2jsqTzgl26OaH/kfr1Qo5mF7Yu0gyzx9g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJMLLphiEVQAgbrIq7n+sNWiFsFRq8Xm8vwCpqpbSY+WImROTJ
	jjRKxwNF5BWUq4ei0fI1688HUGl1P+jZJk6GT0TsNLyTg2QybbmV2c/D7V0Ek2jgy8w=
X-Gm-Gg: AY/fxX45aBLd+1fA0ErlFI41dKUNhM5YD1cYnSd4+r4oEeMleXh6aQuKX6W3QpuKscq
	EX6tBLE+S7qwLybqRyzjnYBU5bnol3PPVxL5D9CDZnIR0tru90oue+1JG514whddu0FF1dbxreH
	b5QKdBIKA/iFfSIJuZvX+sIBvhUryr/fsll0LKqhfZx1VPU7iRbpD2MigF4KGhLp/jdgZIiiHcT
	gJFKThcls2PxByvL5X53EMEj/SoLQmX8MLvfnSk08FwvoXPitxemJqhsofT980Wio6ex84O+XtA
	BfLwPzwX7HgrshXaaLg6ZjQ9Tr7xk9O8DYXmPFSyRhtI7TGP9WFHtxHRv4KVM7sPaBQ9WOz7TqP
	/8tH3tfkubZTehmHgI+CY8FTMzuTwiq2ZBrfBiauqxdE4Q+FEg3f1MXbxHnBY1fabgev1Tt4AY0
	szwn+kaoi5bJNm5D/DNS1IMFkaQOku5ygRkgYVjepQwK9aROV8ocOHGoeUu8olsaKy7Z0=
X-Google-Smtp-Source: AGHT+IGn2SBiEVfPnYP4nrga1XlmOOc9x/h3J7lqU+usVoOUoaNofJJs2v26tTONjDwmwZ1AsmIeFg==
X-Received: by 2002:a05:6214:428e:b0:88e:9f73:2c08 with SMTP id 6a1803df08f44-89084179da3mr258471116d6.5.1768242300986;
        Mon, 12 Jan 2026 10:25:00 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770ce985sm138366276d6.11.2026.01.12.10.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 10:25:00 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfMb6-00000003SfZ-05E0;
	Mon, 12 Jan 2026 14:25:00 -0400
Date: Mon, 12 Jan 2026 14:25:00 -0400
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
Message-ID: <20260112182500.GI745888@ziepe.ca>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <218D42B0-3E08-4ABC-9FB4-1203BB31E547@nvidia.com>
 <20260112165001.GG745888@ziepe.ca>
 <86D91C8B-C3EA-4836-8DC2-829499477618@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86D91C8B-C3EA-4836-8DC2-829499477618@nvidia.com>

On Mon, Jan 12, 2026 at 12:46:57PM -0500, Zi Yan wrote:
> On 12 Jan 2026, at 11:50, Jason Gunthorpe wrote:
> 
> > On Mon, Jan 12, 2026 at 11:31:04AM -0500, Zi Yan wrote:
> >>> folio_free()
> >>>
> >>> 1) Allocator finds free memory
> >>> 2) zone_device_page_init() allocates the memory and makes refcount=1
> >>> 3) __folio_put() knows the recount 0.
> >>> 4) free_zone_device_folio() calls folio_free(), but it doesn't
> >>>    actually need to undo prep_compound_page() because *NOTHING* can
> >>>    use the page pointer at this point.
> >>> 5) Driver puts the memory back into the allocator and now #1 can
> >>>    happen. It knows how much memory to put back because folio->order
> >>>    is valid from #2
> >>> 6) #1 happens again, then #2 happens again and the folio is in the
> >>>    right state for use. The successor #2 fully undoes the work of the
> >>>    predecessor #2.
> >>
> >> But how can a successor #2 undo the work if the second #1 only allocates
> >> half of the original folio? For example, an order-9 at PFN 0 is
> >> allocated and freed, then an order-8 at PFN 0 is allocated and another
> >> order-8 at PFN 256 is allocated. How can two #2s undo the same order-9
> >> without corrupting each other’s data?
> >
> > What do you mean? The fundamental rule is you can't read the folio or
> > the order outside folio_free once it's refcount reaches 0.
> 
> There is no such a rule. In core MM, folio_split(), which splits a high
> order folio to low order ones, freezes the folio (turning refcount to 0)
> and manipulates the folio order and all tail pages compound_head to
> restructure the folio.

That's different, I am talking about reaching 0 because it has been
freed, meaning there are no external pointers to it.

Further, when a page is frozen page_ref_freeze() takes in the number
of references the caller has ownership over and it doesn't succeed if
there are stray references elsewhere.

This is very important because the entire operating model of split
only works if it has exclusive locks over all the valid pointers into
that page.

Spurious refcount failures concurrent with split cannot be allowed.

I don't see how pointing at __folio_freeze_and_split_unmapped() can
justify this series.

> Your fundamental rule breaks this.  Allowing compound information
> to stay after a folio is freed means you cannot tell whether a folio
> is under split or freed.

You can't refcount a folio out of nothing. It has to come from a
memory location that already is holding a refcount, and then you can
incr it.

For example lockless GUP fast will read the PTE, adjust to the head
page, attempt to incr it, then recheck the PTE.

If there are races then sure maybe the PTE will point to a stray tail
page that refers to an already allocated head page, but the re-check
of the PTE wille exclude this. The refcount system already has to
tolerate spurious refcount incrs because of GUP fast.

Nothing should be looking at order and refcount to try to guess if
concurrent split is happening!!

Jason

