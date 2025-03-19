Return-Path: <kvm+bounces-41526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF206A69C4D
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0A7B983045
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 22:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38AC214815;
	Wed, 19 Mar 2025 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtV0RUua"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0284A1E0DF5;
	Wed, 19 Mar 2025 22:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742424803; cv=none; b=Q7HZz15MJ6QAy9mrRrWSetnbx+vunP88fa/rCAsc7sDEeJdjwwfhd3cFE7ov/24YL+cT+7Rvqb03IbTvbrrJpxDHbQR3I1ZdIT3gyg5PFW+Urvw2AYdGvtVEmInsHlh4HjdplYUbMJu3KIMIjAN9DWE99gYbK9wWraryN+uxrY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742424803; c=relaxed/simple;
	bh=d+VUlRbK15AHSFijWQvk3uMYQmbTQJLLjN8PURft8ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npCpqhbHrnfVmPKZggzabTHD8/xwytL5T+frS2iKT8rH3fC8av7MiBNoQ/kP04ZXGYDmBPLe9VHXZif4NaXkLAM6BnBWjOrGmYe6zi50xQsulZUJy6ofvltOx99IhDHhyo5j1Ug7Y4nre+acY8RisuWHrIze6xYFL+ULhHEdfRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YtV0RUua; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFFBC4CEE4;
	Wed, 19 Mar 2025 22:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742424802;
	bh=d+VUlRbK15AHSFijWQvk3uMYQmbTQJLLjN8PURft8ho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YtV0RUuaJkhmaEiHB2PZgmeMLgwQjqAjWPMrJzalJ5tRkWiU3WCYb2rYplF0qvr+K
	 i5ozLcRQ1OlREyfH48tOvBsxYt8jTyaIMyXgbEAca6fi8fi+p/9Gq/MRJ7Bh2uVqUN
	 wmI7HM4E3ma4o8IXmYOyYnICbjxoBcT+m6es1oj9vlLDldHht8CNIBmVWR8cx510b7
	 ym5o/hft4iG4Zk4jNqPqe4RAJ+xS9ngXXJGD/HvBrZ+PTkLGRhMe20E2P4MDYweGDw
	 NYT0xOhlkQnL39VU5LlqSOCljukD8PlM396DMxP1/UdyMhQC+yHuzUuE2FaB6fsGtc
	 Lsip1fIhVxvwA==
Date: Wed, 19 Mar 2025 16:53:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: Peter Xu <peterx@redhat.com>
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
Subject: Re: [PATCH v2 18/19] mm/arm64: Support large pfn mappings
Message-ID: <Z9tK3gEchs9X0k7h@kbusch-mbp.dhcp.thefacebook.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-19-peterx@redhat.com>
 <Z9tDjOk-JdV_fCY4@kbusch-mbp.dhcp.thefacebook.com>
 <Z9tJMsJ4PzZk2ZQS@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9tJMsJ4PzZk2ZQS@x1.local>

On Wed, Mar 19, 2025 at 06:46:35PM -0400, Peter Xu wrote:
> On Wed, Mar 19, 2025 at 04:22:04PM -0600, Keith Busch wrote:
> > On Mon, Aug 26, 2024 at 04:43:52PM -0400, Peter Xu wrote:
> > > +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> > > +#define pud_special(pte)	pte_special(pud_pte(pud))
> > > +#define pud_mkspecial(pte)	pte_pud(pte_mkspecial(pud_pte(pud)))
> > > +#endif
> > 
> > Sorry for such a late reply, but this looked a bit weird as I'm doing
> > some backporting. Not that I'm actually interested in this arch, so I
> > can't readily test this, but I believe the intention was to name the
> > macro argument "pud", not "pte".
> 
> Probably no way to test it from anyone yet, as I don't see aarch64 selects
> HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD, which means IIUC this two lines (before
> PUD being enabled on aarch64) won't be compiled.. which also matches with
> the test results in the cover letter, that we only tried pmd on arm.
> 
> The patch will still be needed though for pmd to work.
> 
> I can draft a patch to change this, but considering arm's PUD support isn't
> there anyway.. maybe I should instead draft a change to remove these as
> they're dead code so far, and see if anyone would like to collect it.
> 
> Thanks for reporting this.  I'll prepare something soon and keep you
> posted.

Thanks, good to know it wasn't reachable.

The reason I was conerned is because the only caller, insert_pfn_pud(),
just so happens to have a variable named "pud" in scope, but it's not
the pud passed into the macro. So if this macro was used, it would just
so happen to compile by that coincidence, but its using the wrong pud.

