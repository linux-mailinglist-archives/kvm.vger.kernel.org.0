Return-Path: <kvm+bounces-67678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0196D10142
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 23:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC96A30612BC
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 22:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFF32D5946;
	Sun, 11 Jan 2026 22:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DgDVv7+N"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33562580D1;
	Sun, 11 Jan 2026 22:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768170963; cv=none; b=EN6rqSR+flVyNl+cK5oGP06tNB+3xpY03NLHM01dJnrgrYEdRyANHQLnDz2pI80lXPXpIrW5azCrkyUXiE2UnnTLAU2bKO+gxBix09rr/iQjCR0zp318syeFkWPl1VmWz0EImcMUrVRS8eRFZdx1xBNyTAuCjBiOJ9bWDOX9n7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768170963; c=relaxed/simple;
	bh=wzV5J+TJP48w5CBH9Ir6sq09xVeldJh2zsaah2xeb/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5ytNpgEzpFOiXUl+wCkArdADEvzvjnmjSBnyOmzmvLBb5dc5kbsfUHHgDXbwLBW3eSz8S8UfeM4OIBOahctIq5o/LLm7lvm8yvfvCkbZujcPNlNuonPf5UxToRQfFrwbzY7Tavjpq899c9V59L2yUm4/Z3pjtPZlWzLHQHTYA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DgDVv7+N; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=85a7PrT0zgtz96jS4pRWuysfpQ780Eq5/9sjyOwO120=; b=DgDVv7+Nsz6PtaysJzaqZ6PHpD
	7eUBRGwOGYg9vHMBVIIPRyiBnuK76spGj3oXGGj4wyZX6r9oSGMmnZMYwWnWBiZ1rsCyNHXnn/f2D
	pG9odPnA+wDKBP7AaT6hVx/Qw9COSWSROCEpkSZ7f9xAUG3jNo3/Q8MyXGSwhueXWLlKS1h4mINFP
	tkajdWvGC1JmwhHglaEtAwZA+VRaFUNjOp0M1oggFAASNkZRm0WT5lB4Uyn7kVavnYAkCwaCqq7YL
	sz0+a7OdQLxR4KwcjKCIJTe2EekXRoEuSZH9JJPqycDT5s/znS4lx8ndXQg4tuCRgX8duH0UlsxPa
	j2NF+t2w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vf41z-00000002OPX-35go;
	Sun, 11 Jan 2026 22:35:31 +0000
Date: Sun, 11 Jan 2026 22:35:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
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
Message-ID: <aWQlsyIVVGpCvB3y@casper.infradead.org>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260111205820.830410-2-francois.dugast@intel.com>

On Sun, Jan 11, 2026 at 09:55:40PM +0100, Francois Dugast wrote:
> The core MM splits the folio before calling folio_free, restoring the
> zone pages associated with the folio to an initialized state (e.g.,
> non-compound, pgmap valid, etc...). The order argument represents the
> folio’s order prior to the split which can be used driver side to know
> how many pages are being freed.

This really feels like the wrong way to fix this problem.

I think someone from the graphics side really needs to take the lead on
understanding what the MM is doing (both currently and in the future).
I'm happy to work with you, but it feels like there's a lot of churn right
now because there's a lot of people working on this without understanding
the MM side of things (and conversely, I don't think (m)any people on the
MM side really understand what graphics cards are trying to accomplish).

Who is that going to be?  I'm happy to get on the phone with someone.

