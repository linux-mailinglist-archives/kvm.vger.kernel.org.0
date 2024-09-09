Return-Path: <kvm+bounces-26168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B48D9725A6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D1101C2375E
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD8018DF86;
	Mon,  9 Sep 2024 23:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xpK8zwiy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B8413BC39;
	Mon,  9 Sep 2024 23:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725923742; cv=none; b=ZmZLqdbhwj+m7tDQFYse59Y+G5zLrF0IRa349cngK5ePnf76hnHhGcmAH97pfLp3FU/AuoXGXyQtHRLs7AoTRO/BtpDnNv1L3PDpnopoVFd3NFaoD6bCEy3yvAcoBTdKYbXBa/Q59SUXjLi2/51MajVZaHemf6rMq++SVVYKOTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725923742; c=relaxed/simple;
	bh=luzSVNn4nvUpJ3QTHAb9p3Ik4ksmlSH5EahYohflukY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=KDxbwKa4tMuKhg219+MtrzGpIGtB2iEFKoiQa4GUsrEUFD+s2OXXm+qrbMvfqkVFnX5zQzblKLzGE9DgMq9YJC72JtbZHofXZrCQYQA4WlGaJqZDbGjZgCSoq+Iwl9kXECv7LB8wHG0Wk5DvaCgSwXZujxeTHyYpC+GXF0cBf6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xpK8zwiy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F378EC4CEC5;
	Mon,  9 Sep 2024 23:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725923740;
	bh=luzSVNn4nvUpJ3QTHAb9p3Ik4ksmlSH5EahYohflukY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xpK8zwiynZ0m10l28wwaoK+1o2zr4ZpU5iOoMkokRROxfrxRyELqVTZEUovGd/OEJ
	 BgcTq+oRgsNSSWq7xyNkhCkJZ1n41LiFfwEJ40POx6cYmw5lXT7uh73qEtwdf4jqpC
	 RuUgUXEA7PrIpIpQl8f40lD53HvGFdEUMWh3JpcI=
Date: Mon, 9 Sep 2024 16:15:39 -0700
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
Message-Id: <20240909161539.aa685e3eb44cdc786b8c05d2@linux-foundation.org>
In-Reply-To: <Zt96CoGoMsq7icy7@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
	<20240826204353.2228736-8-peterx@redhat.com>
	<ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
	<Ztd-WkEoFJGZ34xj@x1n>
	<20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>
	<Zt96CoGoMsq7icy7@x1n>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 9 Sep 2024 18:43:22 -0400 Peter Xu <peterx@redhat.com> wrote:

> > > > Do we need the logic to clear dirty bit in the child as that in
> > > > __copy_present_ptes()?  (and also for the pmd's case).
> > > > 
> > > > e.g.
> > > > if (vma->vm_flags & VM_SHARED)
> > > > 	pud = pud_mkclean(pud);
> > > 
> > > Yeah, good question.  I remember I thought about that when initially
> > > working on these lines, but I forgot the details, or maybe I simply tried
> > > to stick with the current code base, as the dirty bit used to be kept even
> > > in the child here.
> > > 
> > > I'd expect there's only performance differences, but still sounds like I'd
> > > better leave that to whoever knows the best on the implications, then draft
> > > it as a separate patch but only when needed.
> > 
> > Sorry, but this vaguensss simply leaves me with nowhere to go.
> > 
> > I'll drop the series - let's revisit after -rc1 please.
> 
> Andrew, would you please explain why it needs to be dropped?
> 
> I meant in the reply that I think we should leave that as is, and I think
> so far nobody in real life should care much on this bit, so I think it's
> fine to leave the dirty bit as-is.
> 
> I still think whoever has a better use of the dirty bit and would like to
> change the behavior should find the use case and work on top, but only if
> necessary.

Well.  "I'd expect there's only performance differences" means to me
"there might be correctness issues, I don't know".  Is it or is it not
merely a performance thing?

