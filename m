Return-Path: <kvm+bounces-49915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C90ADF987
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 00:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7ED7E1BC1461
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 22:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCA227FD59;
	Wed, 18 Jun 2025 22:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EpbLDF+7"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB0221B8F5
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750286615; cv=none; b=qUvWzcY8U1OMSRNHjqQmTAVfNh2dqbjIx2NQSH7gAXh3ZG79QPt09pVO3j+GANf0Nq0U45WZfaEKyLJxrG9wo49u501XB2yav1O3xVO8c/5hKGTJDrLKBiYGuVcWAYjgYgielaxajlrxN4/F+1NVlPhiCWmSS4v15cn1v97PYnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750286615; c=relaxed/simple;
	bh=Iy+Ox/bH+mj99voHVuFYFLezAqT1Ea3TUU/gpHbZh4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVgdOrD+kbLLxsDuy4jBazKPgnVbZ9+GkFWhYun0yhgoqqCbdrFGubEHZ7xQG5GZf+GkwwHFM9i9uENtOkAU61Ok8DRYRuXDW3zQhL0YBVmBNB+iMFNZH4MrqTPulh6O24/anQy3yyjoAk+cb3XYAK/cziQvI2e/huiNkmt3fm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EpbLDF+7; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Jun 2025 15:43:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750286611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iabUtXH2S5hgnNxipXhGWLLQltCqncktdrGikSQJGv8=;
	b=EpbLDF+7NjqZog0McGJwo+5HvohOHNAQ8BaL7lZ03J7iJoDBrg8lFG2S6I9VFIMY3Gd8yJ
	kTLle8vGIij2bB5f/LXeRE9tYV0K5nhLvNCmRGtvD2HcKQJ6cqzHDwB2+zkiC1Sgge9yZn
	6Pp85WKy351lqpG6lvz+IzpntWkiNOc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 04/15] KVM: Add common infrastructure for KVM
 Userfaults
Message-ID: <aFNBCaLEdABfybmd@linux.dev>
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-5-jthoughton@google.com>
 <aFMWQ5_zMXGTCE98@linux.dev>
 <aFMh51vXbTNCf9mv@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFMh51vXbTNCf9mv@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 18, 2025 at 01:33:17PM -0700, Sean Christopherson wrote:
> On Wed, Jun 18, 2025, Oliver Upton wrote:
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> No need for my SoB.
> 
> > > +#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
> > > +bool kvm_do_userfault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > 
> > The polarity of the return here feels weird. If we want a value of 0 to
> > indicate success then int is a better return type.
> 
> The boolean is my fault/suggestion.  My thinking is that it would make the callers
> more intuitive, e.g. so that this reads "if do userfault, then exit to userspace
> with -EFAULT".
> 
> 	if (kvm_do_userfault(vcpu, fault))
> 		return -EFAULT;

Agreed, this reads correctly. My only issue is that when I read the
function signature, "bool" is usually wired the other way around.

> > > +{
> > > +	struct kvm_memory_slot *slot = fault->slot;
> > > +	unsigned long __user *user_chunk;
> > > +	unsigned long chunk;
> > > +	gfn_t offset;
> > > +
> > > +	if (!kvm_is_userfault_memslot(slot))
> > > +		return false;
> > > +
> > > +	offset = fault->gfn - slot->base_gfn;
> > > +	user_chunk = slot->userfault_bitmap + (offset / BITS_PER_LONG);
> > > +
> > > +	if (__get_user(chunk, user_chunk))
> > > +		return true;
> 
> And this path is other motiviation for returning a boolean.  To me, return "success"
> when a uaccess fails looks all kinds of wrong:
> 
> 	if (__get_user(chunk, user_chunk))
> 		return 0;

Yeah, that's gross. Although I would imagine we want to express
"failure" here, game over, out to userspace for resolution. So maybe:

	if (__get_user(chunk, user_chunk))
		return -EFAULT;

> That said, I don't have a super strong preference; normally I'm fanatical about
> not returning booleans.  :-D

+1, it isn't _that_ big of a deal, just noticed it as part of review.

Thanks,
Oliver

