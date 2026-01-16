Return-Path: <kvm+bounces-68410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29DA4D3894F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 23:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02CA9305654D
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D324313E34;
	Fri, 16 Jan 2026 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NLUgKdV5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DED62F0C7A;
	Fri, 16 Jan 2026 22:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768602874; cv=none; b=XOuR7UOb7Avh+90FbnxjfMnTdZ7s6qq1dA8x/a6jdcJqbs6cyVDmQ79CEmxwLj8ohgpAGiD9NnAHyijsiDy3n1HPDyu2/bq/8JR4VR6jxd4qGVj7Y4AaQwNH5QD9HQb364WLfByRcNYuKI5DOo61yZkRTIWbMpLxx6RTLr+dYbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768602874; c=relaxed/simple;
	bh=kVpnh95TVOJW8VAQPIPSr+AtflaSPXQdvwC6ha92XDY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=XLcm4XtUkKNhKRT+OdzIb1Ys88Mx1zkExJUo9eZXM3nbq/fbFTKjuaumSGnl+mvkRkKkD1GIDBbjMq1DGlVQ2s345nrrXYDMONfjcZr/CtFdiLBR5jEefRY6FmxZnSNveP8aHxqlK+FXV4IvQFmwZ9sMiCGLicCc7gw4UnmKT4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NLUgKdV5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C71AC116C6;
	Fri, 16 Jan 2026 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768602874;
	bh=kVpnh95TVOJW8VAQPIPSr+AtflaSPXQdvwC6ha92XDY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NLUgKdV5rMmMraQ4VO7tdHdrJG5WmEsW2juttELKBYBSDejVV0hR/IQgTFpr6tYdn
	 f5JOdy9G2qNC3TIB3r9ZkeZQVi40l9CLIQGFYANM/qzbhKj84KDPLBY+TLopNEs9gP
	 AXuzcWaHlQVHSDIiihDEiNj6+9fQ5Vr/JnmhU0fs=
Date: Fri, 16 Jan 2026 14:34:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Matthew
 Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>, Alistair Popple
 <apopple@nvidia.com>, adhavan Srinivasan <maddy@linux.ibm.com>, Nicholas
 Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Felix Kuehling
 <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Balbir Singh
 <balbirs@nvidia.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-Id: <20260116143432.50b98d6dc965b94f3b915333@linux-foundation.org>
In-Reply-To: <20260116111325.1736137-2-francois.dugast@intel.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
	<20260116111325.1736137-2-francois.dugast@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 16 Jan 2026 12:10:16 +0100 Francois Dugast <francois.dugast@intel.com> wrote:

> Reinitialize metadata for large zone device private folios in
> zone_device_page_init prior to creating a higher-order zone device
> private folio. This step is necessary when the folio’s order changes
> dynamically between zone_device_page_init calls to avoid building a
> corrupt folio. As part of the metadata reinitialization, the dev_pagemap
> must be passed in from the caller because the pgmap stored in the folio
> page may have been overwritten with a compound head.
> 
> Without this fix, individual pages could have invalid pgmap fields and
> flags (with PG_locked being notably problematic) due to prior different
> order allocations, which can, and will, result in kernel crashes.

Is it OK to leave 6.18.x without this fixed?

