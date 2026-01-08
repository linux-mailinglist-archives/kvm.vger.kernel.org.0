Return-Path: <kvm+bounces-67465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 665B2D06094
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:25:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3CFB3036CBB
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CF832E757;
	Thu,  8 Jan 2026 20:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DyO/oISx"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DF3327783
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 20:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903868; cv=none; b=cA/JnAQnR1DheNBiUKUWqmjmqq7vh7ktN3/SnptV+i/9Z+HVMD4QWjgi4qFHSs3zh5csUeCT60c2rxr+w1qK/nZgRZBmsJNTIUXdDFrMhK1L2BFY8RqJnGOBNy+NFq1VgySTsduDvAYNhqbNXRKPEqBjKJWlVXO1+FAc3c2/K94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903868; c=relaxed/simple;
	bh=I5s1ZsZmaTjlpb1P7R7T+qDii9UPoBYkCa8iHOwYzZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITnT987DjVnEOfrdWQWPg62Qt57XWXEcX4yLSCZzWvTIY3+ES1CekqBg4nIAlUrm/slVyu+yt0GHKIpmBFZRovwRj7EPF73H4sAThbA9afjXyV4YGLxHfTH6+4m9kYXIwAQo+ehjF3Tr21a+vQUBbarkt8crqIt01MHBTwe8bU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DyO/oISx; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 8 Jan 2026 20:24:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767903855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9zTxzfr7fY9EwCt7bK8R02rLevG6g750c5e86uBEiYU=;
	b=DyO/oISx5B9ukqXz/1g2P9vAexKComopUmmQDbNTVuah1ARLtdaBOvpYX6kGvTieHfpp9N
	iur5e+pcLYMO131gG1oLDBMvAzStRW6es6PTvrAFxZDxAFDtn5rTUslZIqDwYCA972DtcO
	6QqR7YxSgL/xWx6X8E/oDnVRZl0izlc=
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
Message-ID: <3xrew6ag7pefka7wava4z7ht54e6xlpwbywcm2ivsgnkdbahe4@yqzsaxnhedj7>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-22-seanjc@google.com>
 <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
 <aV_cLAlz4v1VOkDt@google.com>
 <gzyjze3wszmrwxdwnudij6nfqdxzihm37uappfqxorfjy5vatf@hffzaobbm3g7>
 <aV_3-lhnZ-MoKnjv@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV_3-lhnZ-MoKnjv@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 08, 2026 at 10:31:22AM -0800, Sean Christopherson wrote:
> On Thu, Jan 08, 2026, Yosry Ahmed wrote:
> > On Thu, Jan 08, 2026 at 08:32:44AM -0800, Sean Christopherson wrote:
> > > On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> > > diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> > > index ab869a98bbdc..fab18e9be66c 100644
> > > --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> > > +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> > > @@ -390,6 +390,13 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
> > >  	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
> > >  }
> > >  
> > > +uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa)
> > 
> > nested_paddr is the name used by tdp_map(), maybe use that here as well
> > (and in the header)?
> 
> Oh hell no :-)  nested_paddr is a terrible name (I was *very* tempted to change
> it on the fly, but restrained myself).  "nested" is far too ambigous, e.g. without
> nested virtualization, "nested_paddr" arguably refers to _L1_ physical addresses
> (SVM called 'em Nested Page Tables after all).

That's fair, I generally like consistency to a fault :)

> 
> > > +	int level = PG_LEVEL_4K;
> > > +
> > > +	return __vm_get_page_table_entry(vm, &vm->stage2_mmu, l2_gpa, &level);
> > > +}
> > > +
> > >  uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
> > >  {
> > >  	int level = PG_LEVEL_4K;
> > [..]
> > > @@ -133,35 +220,50 @@ static void test_dirty_log(bool nested_tdp)
> > >  
> > >  	/* Add an extra memory slot for testing dirty logging */
> > >  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> > > -				    GUEST_TEST_MEM,
> > > +				    TEST_MEM_BASE,
> > >  				    TEST_MEM_SLOT_INDEX,
> > >  				    TEST_MEM_PAGES,
> > >  				    KVM_MEM_LOG_DIRTY_PAGES);
> > >  
> > >  	/*
> > > -	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
> > > +	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
> > >  	 * affects both L1 and L2.  However...
> > >  	 */
> > > -	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
> > > +	virt_map(vm, TEST_MEM_BASE, TEST_MEM_BASE, TEST_MEM_PAGES);
> > >  
> > >  	/*
> > > -	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
> > > -	 * 0xc0000000.
> > > +	 * ... pages in the L2 GPA ranges [0xc0001000, 0xc0002000) and
> > > +	 * [0xc0003000, 0xc0004000) will map to 0xc0000000 and 0xc0001000
> > > +	 * respectively.
> > 
> > Are these ranges correct? I thought L2 GPA range [0xc0002000,
> > 0xc0004000) will map to [0xc0000000, 0xc0002000).
> 
> Gah, no.  I looked at the comments after changing things around, but my eyes had
> glazed over by that point.
> 
> > Also, perhaps it's better to express those in terms of the macros?
> > 
> > L2 GPA range [TEST_MEM_ALIAS_BASE, TEST_MEM_ALIAS_BASE + 2*PAGE_SIZE)
> > will map to [TEST_MEM_BASE, TEST_MEM_BASE + 2*PAGE_SIZE)?
> 
> Hmm, no, at some point we need to concretely state the addresses, so that people
> debugging this know what to expect, i.e. don't have to manually compute the
> addresses from the macros in order to debug.

I was trying to avoid a situation where the comment gets out of sync
with the macros in a way that gets confusing. Maybe reference both if
it's not too verbose?

	/*
	 * ... pages in the L2 GPA range [0xc0002000, 0xc0004000) at
	 * TEST_MEM_ALIAS_BASE will map to [[0xc0000000, 0xc0002000) at
	 * TEST_MEM_BASE.
	 */

> 
> > >  	 *
> > >  	 * When TDP is disabled, the L2 guest code will still access the same L1
> > >  	 * GPAs as the TDP enabled case.
> > > +	 *
> > > +	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
> > > +	 * writable SPTEs when handling read faults (if the Dirty bit isn't
> > > +	 * set, KVM must intercept the next write to emulate the Dirty bit
> > > +	 * update).
> > >  	 */
> > >  	if (nested_tdp) {
> > > +		vm_vaddr_t gva0 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 0);
> > > +		vm_vaddr_t gva1 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 1);
> > 
> > Why are these gvas? Should these be L2 GPAs?
> 
> Pure oversight.
> 
> > Maybe 'uint64_t l2_gpa0' or 'uint64_t nested_paddr0'?
> 
> For better of worse, vm_paddr_t is the typedef in selftests.  Hmm, if/when we go
> with David M's proposal to switch to u64 (from e.g. uint64_t), it'd probably be
> a good time to switch to KVM's gva_t and gpa_t as well.

vm_paddr_t is fine too, I am just against using vm_vaddr_t. tdp_map()
takes in uint64_t for the GPAs, which is why I suggested uint64_t here.

> 
> > Also maybe add TEST_ALIAS_GPA() macro to keep things consistent?
> 
> Ya, then the line lengths are short enough to omit the local variables.  How's
> this look?

Looks good, thanks!

> 
> 	/*
> 	 * ... pages in the L2 GPA address range [0xc0002000, 0xc0004000) will
> 	 * map to [0xc0000000, 0xc0002000) when TDP is enabled (for L2).
> 	 *
> 	 * When TDP is disabled, the L2 guest code will still access the same L1
> 	 * GPAs as the TDP enabled case.
> 	 *
> 	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
> 	 * writable SPTEs when handling read faults (if the Dirty bit isn't
> 	 * set, KVM must intercept the next write to emulate the Dirty bit
> 	 * update).
> 	 */
> 	if (nested_tdp) {
> 		tdp_identity_map_default_memslots(vm);
> 		tdp_map(vm, TEST_ALIAS_GPA(0), TEST_GPA(0), PAGE_SIZE);
> 		tdp_map(vm, TEST_ALIAS_GPA(1), TEST_GPA(1), PAGE_SIZE);
> 
> 		*tdp_get_pte(vm, TEST_ALIAS_GPA(0)) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
> 		*tdp_get_pte(vm, TEST_ALIAS_GPA(1)) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
> 	} else {
> 		*vm_get_pte(vm, TEST_GVA(0)) |= PTE_DIRTY_MASK(&vm->mmu);
> 		*vm_get_pte(vm, TEST_GVA(1)) |= PTE_DIRTY_MASK(&vm->mmu);
> 	}

