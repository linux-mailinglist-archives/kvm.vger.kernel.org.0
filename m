Return-Path: <kvm+bounces-11971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5136B87E19D
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 02:27:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B57D22822C2
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 01:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1011DA58;
	Mon, 18 Mar 2024 01:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SIGz/bxS"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DBD18E1D;
	Mon, 18 Mar 2024 01:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710725210; cv=none; b=Hr/1Cy2i+7STe4HpB2B6Bi3fTWO5SxeOsohdLnX0priWkB6KSvcyBf3/+nhMmwzq7V8m5OE76mDX9eek5d/lD936/n+dFL7Eq8aUltuV7MqM7f2CMWurIsmyX96wlANVT1XfJjFJDcnBIOBx1/sob6nghLebHv7hRssDh+qJJws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710725210; c=relaxed/simple;
	bh=ftsEb9yXw9uzcEt530OlE8K0MzCs2GPsLpuZS+alOiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMODDrcQJndYyawJFKOjIn3wVjrwGvw4pQgaAgviPJKXlRTKFG3nQc2myVFhm5Vz2cDm8COOJOnYsYlqXT65AEPVF275IeTqM/jo0sgyvve9dWQoB9oF66pEBxfdZgAMCXziLDHhVNpTm5RJGX4XnnDU1T21BNph2AD94QhfR6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SIGz/bxS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=S56ZGNytYd3VhDY57h4xgye0OIXsSZDMpFlintu/yL4=; b=SIGz/bxSjrLiXEBNRwH7HY2z9N
	ze2G+vMckoZFXpELmcxty/8/rRu6ercUJM+AKkzsvPsc+AeEUa4B+9kS9TUucwrUWbH60pUnCk4Mo
	HnVHxteb47hRWwvyrJoQXwTkhaNCgqTIhykAZglB60rDw7uEEAgogEuDssvDS9Ih4HuBrAg9t5tlO
	FIek4XTcu958qiFl7n98VYbFgOwmSoGfZkKC9NwnB0NWx+C+0uRtov5BCKGIIpPw18XYba61FE+m7
	hvQFDcf92qnwzqwor7OtC4tXY3ktOWU8D57VdoIvvhhO/S95vswBbWqV0qBCS1eovzom2kZENxwPW
	STOnZ7/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rm1lz-00000006uvt-2Snu;
	Mon, 18 Mar 2024 01:26:43 +0000
Date: Sun, 17 Mar 2024 18:26:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: David Stevens <stevensd@chromium.org>,
	Sean Christopherson <seanjc@google.com>,
	Christoph Hellwig <hch@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Message-ID: <ZfeYU6hqlVF7y9YO@infradead.org>
References: <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com>
 <ZfG801lYHRxlhZGT@google.com>
 <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
 <ZfHKoxVMcBAMqcSC@google.com>
 <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com>
 <ZfHhqzKVZeOxXMnx@google.com>
 <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com>
 <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com>
 <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
 <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 14, 2024 at 12:51:40PM +0100, Christian König wrote:
> > Does Christoph's objection come from my poorly worded cover letter and
> > commit messages, then?
> 
> Yes, that could certainly be.

That's definitively a big part of it, but I think not the only one.

> > Fundamentally, what this series is doing is
> > allowing pfns returned by follow_pte to be mapped into KVM's shadow
> > MMU without inadvertently translating them into struct pages.
> 
> As far as I can tell that is really the right thing to do. Yes.

IFF your callers don't need pages and you just want to track the
mapping in the shadow mmu and never take a refcount that is a good
thing.

But unless I completely misunderstood the series that doesn't seem
to be the case - it builds a new kvm_follow_pfn API which is another
of these weird multiplexers like get_user_pages that can to tons of
different things depending on the flags.  And some of that still
grabs the refcount, right?

> Completely agree. In my thinking when you go a step further and offload
> grabbing the page reference to get_user_pages() then you are always on the
> save side.

Agreed.

> Because then it is no longer the responsibility of the KVM code to get all
> the rules around that right, instead you are relying on a core functionality
> which should (at least in theory) do the correct thing.

Exactly.


