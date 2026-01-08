Return-Path: <kvm+bounces-67471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D886D061C6
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:33:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9833A30116EF
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8485632FA24;
	Thu,  8 Jan 2026 20:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GvqDx8b6"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF807286D70
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 20:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904404; cv=none; b=bp0EmWFlTmxJZN1VKsu21ltEAxQW/HzdEMUKdBJcQfZ/+JyAHokoFxlszAKzuFjhoCq3bKAeVQKrnuBQYZbersiVHr/l7EJU4C9Vkv22VHQY4OwBHqsfeuTLSdi8GuQkEmqPiftMYnTKolo2rfXFTqoehx/RBwE2N68lFsDDKus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904404; c=relaxed/simple;
	bh=iATZpNcktO46+cDNnAgxodjZQtQ3YNqdoni2XqoB0S0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFY9Q7LBAxjEqJNfGwfaxfs44kWEwcGol2lyQEsRWKXfBFqtj6gOMBX2zNPCtAaJxaVuuudZAS9+OJx4oPjmA6+jya4jQ2vw/6EFpuScBHH2sHR+4uONf8SE944o30ieWTnmBS8r3EvYJnXNJp6U+ROBMBoF78AAfQiSeLYx9bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GvqDx8b6; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 8 Jan 2026 20:33:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767904400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lqob6m0vV00E9z3vAvV17AnmV6r8/G5JFmQWsGjfzkA=;
	b=GvqDx8b6D94Zu6W4aoe3fj7eBDt43YEIRHeVXWEDmqy3M3ZbHQ8fO0XbIiq835vHQYDrxZ
	wrABcteH8d9vVTOnXbd3ossltQFBNjWJqxC03UmTyzAO4PXkQMKCPGuCASZqRT+HP6WVTv
	TbJqonNWrKWTeTTIaEw3Qz2uOrCnpUI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 21/21] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
Message-ID: <542ogwlbwiajdw2txep4ra7patrsnporvruqicuffazlai6drv@ybperj2axkl3>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-22-seanjc@google.com>
 <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
 <aV_cLAlz4v1VOkDt@google.com>
 <gzyjze3wszmrwxdwnudij6nfqdxzihm37uappfqxorfjy5vatf@hffzaobbm3g7>
 <aV_3-lhnZ-MoKnjv@google.com>
 <3xrew6ag7pefka7wava4z7ht54e6xlpwbywcm2ivsgnkdbahe4@yqzsaxnhedj7>
 <aWATlfisv8ZVZi0c@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWATlfisv8ZVZi0c@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 08, 2026 at 12:29:09PM -0800, Sean Christopherson wrote:
> On Thu, Jan 08, 2026, Yosry Ahmed wrote:
> > On Thu, Jan 08, 2026 at 10:31:22AM -0800, Sean Christopherson wrote:
> > > On Thu, Jan 08, 2026, Yosry Ahmed wrote:
> > > > >  	/*
> > > > > -	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
> > > > > +	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
> > > > >  	 * affects both L1 and L2.  However...
> > > > >  	 */
> > > > > -	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
> > > > > +	virt_map(vm, TEST_MEM_BASE, TEST_MEM_BASE, TEST_MEM_PAGES);
> > > > >  
> > > > >  	/*
> > > > > -	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
> > > > > -	 * 0xc0000000.
> > > > > +	 * ... pages in the L2 GPA ranges [0xc0001000, 0xc0002000) and
> > > > > +	 * [0xc0003000, 0xc0004000) will map to 0xc0000000 and 0xc0001000
> > > > > +	 * respectively.
> > > > 
> > > > Are these ranges correct? I thought L2 GPA range [0xc0002000,
> > > > 0xc0004000) will map to [0xc0000000, 0xc0002000).
> > > 
> > > Gah, no.  I looked at the comments after changing things around, but my eyes had
> > > glazed over by that point.
> > > 
> > > > Also, perhaps it's better to express those in terms of the macros?
> > > > 
> > > > L2 GPA range [TEST_MEM_ALIAS_BASE, TEST_MEM_ALIAS_BASE + 2*PAGE_SIZE)
> > > > will map to [TEST_MEM_BASE, TEST_MEM_BASE + 2*PAGE_SIZE)?
> > > 
> > > Hmm, no, at some point we need to concretely state the addresses, so that people
> > > debugging this know what to expect, i.e. don't have to manually compute the
> > > addresses from the macros in order to debug.
> > 
> > I was trying to avoid a situation where the comment gets out of sync
> > with the macros in a way that gets confusing. Maybe reference both if
> > it's not too verbose?
> > 
> > 	/*
> > 	 * ... pages in the L2 GPA range [0xc0002000, 0xc0004000) at
> > 	 * TEST_MEM_ALIAS_BASE will map to [[0xc0000000, 0xc0002000) at
> > 	 * TEST_MEM_BASE.
> > 	 */
> 
> Heh, your solution to a mitigate a comment getting out of sync is to add more
> things to the comment that can get out of sync :-D
> 
> Unless you feel very strongly about having the names of the macros in the comments,
> I'd prefer to keep just the raw addresses.

I don't feel strongly :)

