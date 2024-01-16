Return-Path: <kvm+bounces-6361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B028A82FC03
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 23:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ED0228D84F
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 22:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC87921343;
	Tue, 16 Jan 2024 20:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g35/ZDRb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D4120B39;
	Tue, 16 Jan 2024 20:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435971; cv=none; b=JHPF4fFYwjeMPke0gO6OSjmWpJeOwUzpzUX7beDJnZ0nFpdS3anVIwbMtFhtdTTCgYjVS7EzH7Tz67EdvRv7/uIUr0P1ZjUjUJiEESGZfSiJ8BrGH29/YuLw6XPbjhVqr6F2ByHZnFUDwXm8OFXRNUEPRTBzRZw5zJKddnQjvjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435971; c=relaxed/simple;
	bh=y0T78Tl2mFhQO+6nHXZZETLGCgce+xJ3SNVPKoXOkiM=;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To; b=oAqF22CcUYlY8ZdKDPLyJq1OIcRVu41JFqLUVsmB6gweJ5qqX7KOfMeJLrXWUcv8ZCZPPYUdS6Rg8ycd7A3BtYtu9q2whKa3MSysX/RLybgsX554V2fidAxilmdoCL+4FV9RMYY/nOs5HdB9sutcLaMc7mHwMWthJvtNE7TQm+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g35/ZDRb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7507AC433F1;
	Tue, 16 Jan 2024 20:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705435970;
	bh=y0T78Tl2mFhQO+6nHXZZETLGCgce+xJ3SNVPKoXOkiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g35/ZDRbmhRP3jTDRk5MRBm2xYPl+xOqFh++wudTJkam68oIzerSZfdIKelA61oBA
	 VPg2gf/l+ozlu7tVCawWHkD0O2X8QOPDE7/BxxDCsVuzmAzIE+eaxFTuTf+DkHM9wb
	 qr1ci7u4eCil2SzlyFNdrGq6FrmNblCC4WYR4xNvBFjrswNVzIedOc9P9j9gYk7uQV
	 nG4pksADfOsXYN07UohjU83xAUuyc67oTG0yw5jFAkWSI8psyWbbraE1FaTV0Cmq2/
	 qdjDqbtj/Zjw9Zgc43LIWlT9YIgRltjL/9Py0P9ZbzspGAJUZuzKq/FoC5vf83ZSKy
	 12pF9eFoLRt0A==
Date: Tue, 16 Jan 2024 22:12:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michael Roth <michael.roth@amd.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com,
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
	pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <ZabjKpCqx9np0SEI@kernel.org>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <63297d29-bb24-ac5e-0b47-35e22bb1a2f8@amd.com>
 <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
 <20240116161909.msbdwiyux7wsxw2i@amd.com>
 <20240116165025.g4iouboabyxkn5nd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240116165025.g4iouboabyxkn5nd@amd.com>

On Tue, Jan 16, 2024 at 10:50:25AM -0600, Michael Roth wrote:
> On Tue, Jan 16, 2024 at 10:19:09AM -0600, Michael Roth wrote:
> > 
> > The downside of course is potential impact for non-SNP workloads
> > resulting from splitting the directmap. Mike Rapoport's numbers make
> > me feel a little better about it, but I don't think they apply directly
> > to the notion of splitting the entire directmap. It's Even he LWN article
> > summarizes:

When I ran the tests, I had the entire direct map forced to 4k or 2M pages.
There is indeed some impact and some tests suffer more than others but
there were also runs that benefit from smaller page size in the direct map,
at least if I remember correctly the results Intel folks posted a while
ago.
 
> >   "The conclusion from all of this, Rapoport continued, was that
> >   direct-map fragmentation just does not matter — for data access, at
> >   least. Using huge-page mappings does still appear to make a difference
> >   for memory containing the kernel code, so allocator changes should
> >   focus on code allocations — improving the layout of allocations for
> >   loadable modules, for example, or allowing vmalloc() to allocate huge
> >   pages for code. But, for kernel-data allocations, direct-map
> >   fragmentation simply appears to not be worth worrying about."
> > 
> > So at the very least, if we went down this path, we would be worth
> > investigating the following areas in addition to general perf testing:
> > 
> >   1) Only splitting directmap regions corresponding to kernel-allocatable
> >      *data* (hopefully that's even feasible...)

Forcing the direct map to 4k pages does not affect the kernel text
mappings, they are created separately and they are not the part of the
kernel mapping of the physical memory.
Well, except the modules, but they are mapped with 4k pages anyway.

> -Mike

-- 
Sincerely yours,
Mike.

