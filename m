Return-Path: <kvm+bounces-24807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C8C95AD89
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 08:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CE471C21C6E
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 06:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E82613A879;
	Thu, 22 Aug 2024 06:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RvmEtmEW"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F12249F9
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 06:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308289; cv=none; b=rMSYQ6tim6dvsqYdvmss0080bGuYndqn4oEY1JVmoGXLdV46KzmywgtJdIyRo5N2WXqUY7rVY9BKD/tejsU2EDHS7VxvUVw1gEHZF5C2EYSXneC8rTeH2AYFUcQUn8o98AcyCOdp8Kytjp/U+gg06cjw2tmo1uey/G4Vs9JSK48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308289; c=relaxed/simple;
	bh=jbC0DB5wuASWk06GDLKHtiUlHALW2rUUePq5AdShjM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6j1BCpRUHo69hTESEbOrobZ7o7bTEDVhUNnG03dIUvO7fNSydzfRva2d/hCexfFzmcK5WrySvqB67cTtdtTcmgETNnPLjLGeFMYaFQglrmV4R/6brFAzaGFbDfLuU2eMGTqnErQGoz7lvAA2JF5bkXBBlmdo2+Bqmm3ydwKNt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RvmEtmEW; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 22 Aug 2024 06:31:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724308285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v9L+ux6eqpfs8HzsN5Mc/twSCks2uxys4IF0TgSNQbs=;
	b=RvmEtmEWo3qrdEPjK0SFllLxQkoGLfOYCr3K1MEV0ZjxRzgIURV9s1vbQoXCQJzDJ1duMt
	sSnffekuUeXRsaafxh/3HzZC0+r2s17FUjz0UodRzfKAXUVtENu164VbYiWAHZC+1BK+aB
	gY/zvvLXMOInTeVNdfCWhKgDTpTgrOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 03/16] KVM: arm64: nv: Handle shadow stage 2 page
 faults
Message-ID: <ZsbbNNPEjUq1ndt5@linux.dev>
References: <20240614144552.2773592-1-maz@kernel.org>
 <20240614144552.2773592-4-maz@kernel.org>
 <9ba30187-6630-02e6-d755-7d1b39118a32@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ba30187-6630-02e6-d755-7d1b39118a32@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 22, 2024 at 03:11:16AM +0800, Zenghui Yu wrote:
> > +
> > +	if (nested) {
> > +		unsigned long max_map_size;
> > +
> > +		max_map_size = force_pte ? PAGE_SIZE : PUD_SIZE;
> > +
> > +		ipa = kvm_s2_trans_output(nested);
> > +
> > +		/*
> > +		 * If we're about to create a shadow stage 2 entry, then we
> > +		 * can only create a block mapping if the guest stage 2 page
> > +		 * table uses at least as big a mapping.
> > +		 */
> > +		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> > +
> > +		/*
> > +		 * Be careful that if the mapping size falls between
> > +		 * two host sizes, take the smallest of the two.
> > +		 */
> > +		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
> > +			max_map_size = PMD_SIZE;
> > +		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
> > +			max_map_size = PAGE_SIZE;
> > +
> > +		force_pte = (max_map_size == PAGE_SIZE);
> > +		vma_pagesize = min(vma_pagesize, (long)max_map_size);
> > +	}
> > +
> >  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
> >  		fault_ipa &= ~(vma_pagesize - 1);
> >  
> > -	gfn = fault_ipa >> PAGE_SHIFT;
> > +	gfn = ipa >> PAGE_SHIFT;
> 
> I had seen a non-nested guest boot failure (with vma_pagesize ==
> PUD_SIZE) and bisection led me here.
> 
> Is it intentional to ignore the fault_ipa adjustment when calculating
> gfn if the guest memory is backed by hugetlbfs? This looks broken for
> the non-nested case.
> 
> But since I haven't looked at user_mem_abort() for a long time, I'm not
> sure if I'd missed something...

Nope, you're spot on as usual.

Seems like we'd want to make sure both the canonical IPA and fault IPA
are hugepage-aligned to get the right PFN and map it at the right place.

I repro'ed the boot failure, the following diff gets me back in
business. I was _just_ about to send the second batch of fixes, but this
is a rather smelly one.

Unless someone screams, this is getting stuffed on top.

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..a509b63bd4dd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1540,8 +1540,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_pagesize = min(vma_pagesize, (long)max_map_size);
 	}
 
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
+	/*
+	 * Both the canonical IPA and fault IPA must be hugepage-aligned to
+	 * ensure we find the right PFN and lay down the mapping in the right
+	 * place.
+	 */
+	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
 		fault_ipa &= ~(vma_pagesize - 1);
+		ipa &= ~(vma_pagesize - 1);
+	}
 
 	gfn = ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);


-- 
Thanks,
Oliver

