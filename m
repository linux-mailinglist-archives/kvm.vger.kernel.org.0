Return-Path: <kvm+bounces-26165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F06AB972548
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:25:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A13661F24AA7
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB8C18CC10;
	Mon,  9 Sep 2024 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1eDi1aFN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8C41791EB;
	Mon,  9 Sep 2024 22:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920747; cv=none; b=kj+VwzKSqJ1+qrYcRn1cLN8EgSLX1iZQqpHq6f2CBCoup+57Rqhz07Rzn97HlTCW9jsFNOqdjyrVHOQK5IOEzHQdry9+f6VsyAXOIE+6ofzFnIzFbiKqwrMMR71lxwy2C/4DLMNq7WXZRpsaqRbAPZjeoOqpy1gsgqnGne096as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920747; c=relaxed/simple;
	bh=4DtzlsFCtPBbW6YIoPEm8DoQZTy56mCz90TYajj6fEU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZcF5TwR4qZhA+tjeFXx94kt3pLKN2mfJgneIUKAljJ/QDDc2wFuS3zJuebj+1LS/kAL5/XNkbaIFwTHAkcqt6npymnzI2bWLadYkBypT/QcZA1G0SVEq7cO+wHpXE36V3UK57I1UKboNIhKv+dXUFF41rn4qaiFq046Ewm4x+v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1eDi1aFN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6907C4CEC5;
	Mon,  9 Sep 2024 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725920747;
	bh=4DtzlsFCtPBbW6YIoPEm8DoQZTy56mCz90TYajj6fEU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1eDi1aFNs3Up7hg68+tzcLXlQmtYG+Rjn7OjkCaE09QrgYshaLno0Sr9g50pUA9za
	 8wKei6dV52DSkpwvoHrI6kRfW+qyoTV5lxxfddYuXlIHsjmkk3KwGb2nM9OHlPIDvT
	 v88QXWRdkWSyqDF1kZnmg001pde8cmzkhaPTXYWo=
Date: Mon, 9 Sep 2024 15:25:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Xu <peterx@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>, Catalin Marinas
 <catalin.marinas@arm.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson
 <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe
 <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand
 <david@redhat.com>, Will Deacon <will@kernel.org>, Kefeng Wang
 <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Message-Id: <20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>
In-Reply-To: <Ztd-WkEoFJGZ34xj@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
	<20240826204353.2228736-8-peterx@redhat.com>
	<ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
	<Ztd-WkEoFJGZ34xj@x1n>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 3 Sep 2024 17:23:38 -0400 Peter Xu <peterx@redhat.com> wrote:

> > > @@ -1686,8 +1706,11 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> > >  	 * TODO: once we support anonymous pages, use
> > >  	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
> > >  	 */
> > > -	pudp_set_wrprotect(src_mm, addr, src_pud);
> > > -	pud = pud_mkold(pud_wrprotect(pud));
> > > +	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
> > > +		pudp_set_wrprotect(src_mm, addr, src_pud);
> > > +		pud = pud_wrprotect(pud);
> > > +	}
> > Do we need the logic to clear dirty bit in the child as that in
> > __copy_present_ptes()?  (and also for the pmd's case).
> > 
> > e.g.
> > if (vma->vm_flags & VM_SHARED)
> > 	pud = pud_mkclean(pud);
> 
> Yeah, good question.  I remember I thought about that when initially
> working on these lines, but I forgot the details, or maybe I simply tried
> to stick with the current code base, as the dirty bit used to be kept even
> in the child here.
> 
> I'd expect there's only performance differences, but still sounds like I'd
> better leave that to whoever knows the best on the implications, then draft
> it as a separate patch but only when needed.

Sorry, but this vaguensss simply leaves me with nowhere to go.

I'll drop the series - let's revisit after -rc1 please.

