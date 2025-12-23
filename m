Return-Path: <kvm+bounces-66637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF7ECDADAD
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:48:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FC7C304D576
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C972F7444;
	Tue, 23 Dec 2025 23:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wEJVQEwe"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C612110E
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766533665; cv=none; b=PxghrktXDayUIIomo1B+xYvuFBt6A5df8N3gpjP7IuDtEqlFI+Eh1a4585Bd6Td8qmLizpPRp1e5tSRcjH/c8AJ5tviNSBN9vgc4H7XEgO6ghKblJZVua1m7jh1vsAUETqFvM9ldJo/u8a6zBZ82hvH/lN/dArHJW7Ka+jQMAcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766533665; c=relaxed/simple;
	bh=4kdfOHgvHO/hFc/+/sfbWKNvs1wPuuy5HirJv/k8GJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=naWWf9tju2u9uSugBaEhJnaW8JX/0Eg9PphMA25V/LnpA6aaIp5c6zD4/H2hphKDEEc+9s1BsVS3h6oUIpGIlx90t4OqcvQyLtSyEZNi4SiqyEqnIrJhBAg3GGtNMf6f1/toaXdtJXXAHlQm9Zzfd0XV9/0JMS5rKQ9rfX91EZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wEJVQEwe; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 23 Dec 2025 23:47:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766533661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cxwjMbW5MXnln5af81Jrm0OP8rTLKvSAcvbCi5VzBdE=;
	b=wEJVQEweEmtsMLeZuPpez/jg8vqpNM0dWhtX0lQowsw5Hf92nu/wLTcG2WbGC6gu2HGjdR
	7IKyXQdGz4pfi29zc/oBfUNgisTIHIxg2c04b+gNO2I7YEfn+CR7Twhh9BcQ5Dz7JUh5PK
	po1o1VzeMh4D+EvdANBifGWCvkAabIs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/16] KVM: selftests: Reuse virt mapping functions
 for nested EPTs
Message-ID: <6udca7kfrwy6gzads46r2eczyaapiav6h37y5e4oqxsdpl6j7h@oj5x5qr6d5jw>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-11-yosry.ahmed@linux.dev>
 <aUsiVDjIrj6szEWt@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUsiVDjIrj6szEWt@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 23, 2025 at 03:14:28PM -0800, Sean Christopherson wrote:
> On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > +	/*
> > +	 * EPTs do not have 'present' or 'user' bits, instead bit 0 is the
> > +	 * 'readable' bit. In some cases, EPTs can be execute-only and an entry
> > +	 * is present but not readable. However, for the purposes of testing we
> > +	 * assume 'present' == 'user' == 'readable' for simplicity.
> > +	 */
> > +	pte_masks = (struct pte_masks){
> > +		.present	=	BIT_ULL(0),
> > +		.user		=	BIT_ULL(0),
> > +		.writable	=	BIT_ULL(1),
> > +		.x		=	BIT_ULL(2),
> > +		.accessed	=	BIT_ULL(5),
> > +		.dirty		=	BIT_ULL(6),
> 
> Almost forgot, the Accessed and Dirty bits are wrong.  They are bits 8 and 9
> respectively, not 5 and 6.  Amusingly (well, it's amusing *now*, it wasn't so
> amusing at the time), I found that out when I couldn't get KVM to create a writable
> SPTE on a read fault in the nested dirty log test :-)

Instead of being a reasonable person and own up to my mistake, I will
blame Intel for putting the bits there to begin with :P

(But seriously, sorry for such a dumb mistake)

