Return-Path: <kvm+bounces-19335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FE0903FFA
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE2E71F24838
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849DF28399;
	Tue, 11 Jun 2024 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SF/dJXus"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47217219E7
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718119785; cv=none; b=lwaPHKMcLhDGneRNXO2kQ9yLefBglfdn3WZAJlTO6Smb37OjGZ9k0sGPA9r+22Y8obIhu78K1kFLz6R7rEuBnjVj17f2vNluSBmLkSk4BYW8F+jT720Opr+TWALL2G9kL+T2JcalKkONGW/moKV4Gaf73j2Ot1xFoFq0zQRL29E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718119785; c=relaxed/simple;
	bh=T+Cs38GodB7c/ewzzK5qBPSKX7B+tGe1OV5rLrfag9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4KCQTDTvC446FoNIj3hIBbD/q+zayLdXfYx8cMzw4ROkoF/lZBRQKruQBaQmLqHj6oDgyT0WKul3lyo65P1omBQLYI662CXGcIfQe58+wzqNdrgq3lUngaH7il/j12Z8ttDGQG3GAdZOEhxFxnu+sbAXAMZXtmNw6R++ng3S4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SF/dJXus; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-6e7b121be30so2420089a12.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 08:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718119783; x=1718724583; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zs1Y+P/OCeIwDzwRVFXM1DFGmf1RZvZNOI/6sndKdQ0=;
        b=SF/dJXusiXf2d2ynZLFbtgrghrv5CVvGanzel/eR1yzPMH0tWdXRAdjO7Y/k0ODUbx
         6jHAeLTAFkPVjoWJn+Hb5GevtxQwbIs1MrIRjQ9lVcSMDxzyBDgQ8kJZ/jI47ykp+X+5
         LX74OEdWkGkLL+NGUFADIiEWwpIrkVKxcFsLqNUb0Ttm5uPNfW0pZdsnLfgzn9lTCPP1
         BCZbzhlavJt2/G+1bCZOQXzh3/mzOiUFgsNlhEXXxHwwv5EbNm88d3fDdBXg15YTNW8X
         MgDKvuwt7ejfD9iFi1hfSTfq4W9euL19PTQoXvPLXzKP74gipO7zvdWWGPneQ5hmtmGc
         014Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718119783; x=1718724583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zs1Y+P/OCeIwDzwRVFXM1DFGmf1RZvZNOI/6sndKdQ0=;
        b=rofPiblczGnQj5hIH2CK4xGevDkPvADgjhGxHI98yDEceLVcdm+/N+p9BO7hnV7vHp
         lCe16rqWF8uk3BYqjlzO8C7ClPe9iquygt6C99lnDBAPJmVBl7KGu6fEysh1Zs1BfI3+
         bAuzx7nL97PbvEx3YmqVa1yIutwfBHb/mYnrbImNHTLWr2CtEMbHMSKrg0NK18A/19So
         Y+c5Jrt2uPR8VhLLyxAHcaIfuszg51DLkHc9vULgsAzcMJAFclMij8M/vUnpE48HmQOx
         GJBT9YjQgzgltyUGzfcspGWixK2Uo6/PaTR92r798NfsH9emk6rsYVZLgHsF4ghoPS7X
         K0mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtRPXgma0kgzXW2+cpcZ/2mCBn7lGlmvXYAcIX6eVRv4oXqlu8bnnGHbBgtcOTdEK4KIz39d/hUZ6GRlxjUQixd0G4
X-Gm-Message-State: AOJu0YyPrw7ZlCs5B68qvjxsh80OuJz4DncoHJtxqkKH5AGgMqwYaFzn
	ZRWLlNAmkSW95JWz91NiH9Ock9Y3cbjs9gJHRmJQE81Hui5XhDN2+5We04gWHLgcNlJrRls1uuA
	MRQ==
X-Google-Smtp-Source: AGHT+IGa90YRqiUPiiVTbR/fQ1GxPq+RWr0B9LHZwLQ/J9DWsFNnnm8VT/DVi6NUGggqsMaoIEkGNQ==
X-Received: by 2002:a05:6a20:d80f:b0:1b5:ecc:a964 with SMTP id adf61e73a8af0-1b50eccab24mr9895034637.31.1718119783200;
        Tue, 11 Jun 2024 08:29:43 -0700 (PDT)
Received: from google.com (210.145.16.34.bc.googleusercontent.com. [34.16.145.210])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6de27605dcasm7928820a12.79.2024.06.11.08.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 08:29:42 -0700 (PDT)
Date: Tue, 11 Jun 2024 08:29:38 -0700
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	Bibo Mao <maobibo@loongson.cn>
Subject: Re: [PATCH v3] KVM: x86/mmu: Always drop mmu_lock to allocate TDP
 MMU SPs for eager splitting
Message-ID: <ZmhtYqtAou031wjV@google.com>
References: <20240509181133.837001-1-dmatlack@google.com>
 <Zl4H0xVkkq5p507k@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl4H0xVkkq5p507k@google.com>

On 2024-06-03 11:13 AM, Sean Christopherson wrote:
> On Thu, May 09, 2024, David Matlack wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index aaa2369a9479..2089d696e3c6 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1385,11 +1385,11 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
> >  	return spte_set;
> >  }
> >  
> > -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> > +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(void)
> >  {
> > +	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
> >  	struct kvm_mmu_page *sp;
> >  
> > -	gfp |= __GFP_ZERO;
> >  
> >  	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
> 
> This can more simply and cleary be:
> 
> 	sp = kmem_cache_zalloc(mmu_page_header_cache, GFP_KERNEL_ACCOUNT);

Will do. And I assume you'd prefer get_zeroed_page(GFP_KERNEL_ACCOUNT)
as well below?

> 
> >  	if (!sp)
> > @@ -1412,19 +1412,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >  
> >  	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> >  
> > -	/*
> > -	 * Since we are allocating while under the MMU lock we have to be
> > -	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
> > -	 * reclaim and to avoid making any filesystem callbacks (which can end
> > -	 * up invoking KVM MMU notifiers, resulting in a deadlock).
> > -	 *
> > -	 * If this allocation fails we drop the lock and retry with reclaim
> > -	 * allowed.
> > -	 */
> > -	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> > -	if (sp)
> > -		return sp;
> > -
> >  	rcu_read_unlock();
> >  
> >  	if (shared)
> > @@ -1433,7 +1420,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >  		write_unlock(&kvm->mmu_lock);
> >  
> >  	iter->yielded = true;
> 
> Now that yielding is unconditional, this really should be in the loop itself.
> The bare continue looks weird, and it's unnecessarily hard to see that "yielded"
> is being set.
> 
> And there's definitely no reason to have two helpers.
> 
> Not sure how many patches it'll take, but I think we should end up with:
> 
> static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
> {
> 	struct kvm_mmu_page *sp;
> 
> 	sp = kmem_cache_zalloc(mmu_page_header_cache, GFP_KERNEL_ACCOUNT);
> 	if (!sp)
> 		return NULL;
> 
> 	sp->spt = (void *)__get_free_page(gfp);
> 	if (!sp->spt) {
> 		kmem_cache_free(mmu_page_header_cache, sp);
> 		return NULL;
> 	}
> 
> 	return sp;
> }
> 
> static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> 					 struct kvm_mmu_page *root,
> 					 gfn_t start, gfn_t end,
> 					 int target_level, bool shared)
> {
> 	struct kvm_mmu_page *sp = NULL;
> 	struct tdp_iter iter;
> 
> 	rcu_read_lock();
> 
> 	/*
> 	 * Traverse the page table splitting all huge pages above the target
> 	 * level into one lower level. For example, if we encounter a 1GB page
> 	 * we split it into 512 2MB pages.
> 	 *
> 	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
> 	 * to visit an SPTE before ever visiting its children, which means we
> 	 * will correctly recursively split huge pages that are more than one
> 	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
> 	 * and then splitting each of those to 512 4KB pages).
> 	 */
> 	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
> retry:
> 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
> 			continue;
> 
> 		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
> 			continue;
> 
> 		if (!sp) {
> 			rcu_read_unlock();
> 
> 			if (shared)
> 				read_unlock(&kvm->mmu_lock);
> 			else
> 				write_unlock(&kvm->mmu_lock);
> 
> 			sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, shared);
> 
> 			if (shared)
> 				read_lock(&kvm->mmu_lock);
> 			else
> 				write_lock(&kvm->mmu_lock);
> 
> 			if (!sp) {
> 				trace_kvm_mmu_split_huge_page(iter.gfn,
> 							      iter.old_spte,
> 							      iter.level, -ENOMEM);
> 				return -ENOMEM;
> 			}
> 
> 			rcu_read_lock();
> 
> 			iter->yielded = true;
> 			continue;
> 		}
> 
> 		tdp_mmu_init_child_sp(sp, &iter);
> 
> 		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
> 			goto retry;
> 
> 		sp = NULL;
> 	}
> 
> 	rcu_read_unlock();
> 
> 	/*
> 	 * It's possible to exit the loop having never used the last sp if, for
> 	 * example, a vCPU doing HugePage NX splitting wins the race and
> 	 * installs its own sp in place of the last sp we tried to split.
> 	 */
> 	if (sp)
> 		tdp_mmu_free_sp(sp);
> 
> 	return 0;
> }

Ack, will do.

