Return-Path: <kvm+bounces-67451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C108D05818
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 76C6930957BF
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 18:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15302BE62E;
	Thu,  8 Jan 2026 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NNiC6X1e"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11802EACF2
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895326; cv=none; b=acZilQj46ncQtIA5qJ7uTeN8y6h3APBuX3Z5xOtVlkjjBW4anLfY1JeN14gQBtbgKuVXFUeX7iPb9EVVkrxayXugFETIEeg/Bo9lCwICzabMfAObXwaPPEcsYXRErhvVw57tQ5JeeA5K2G0MoSrmygniihiWqN/Icnp9IVJlq20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895326; c=relaxed/simple;
	bh=+X4D3dX40snXIUW9Lx/z1TSdmppP3O0OeXyo4vNvl1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0ZaQcHi3iVb96wZpiojAZpA2Jpm/ua8StZ+XY551138n3B/E/xrzp5wDE2MPjoAIM9r9qc7gJl9D+8XKzM+TPFXorpUG6Ax8JycbEIjP2JHRq4k0wJX3hauEpjq1i4a5t90DV7HMEo+fdpdWDQj5immucLdo1Ly/jwEfn3nxBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NNiC6X1e; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 8 Jan 2026 18:01:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767895312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mHJvd2lOsd2wbBTE/hRKRyHsP8VtLimAvA5l0WDsuuI=;
	b=NNiC6X1eiOY1vt6ur7HKIpfzt3j34lWx44WxF9qrMQ5c0WFv9a2bOfOsrRs6zKXmr/lF6h
	vtAYr4ZuDCheAMhLpUV9ZRWeQ7lEFkUNKHB27ih+ISXEEIjcAi84GXchAP8LsvKNkNsN3y
	ANpKS595tEqqGM/bSu9MKaO2JENVkck=
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
Message-ID: <gzyjze3wszmrwxdwnudij6nfqdxzihm37uappfqxorfjy5vatf@hffzaobbm3g7>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-22-seanjc@google.com>
 <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
 <aV_cLAlz4v1VOkDt@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV_cLAlz4v1VOkDt@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 08, 2026 at 08:32:44AM -0800, Sean Christopherson wrote:
> On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> > On Tue, Dec 30, 2025 at 03:01:50PM -0800, Sean Christopherson wrote:
> > >  	WRITE_ONCE(*b, 1);
> > > -	GUEST_SYNC(true);
> > > +	GUEST_SYNC(2 | TEST_SYNC_WRITE_FAULT);
> > >  	WRITE_ONCE(*b, 1);
> > > -	GUEST_SYNC(true);
> > > -	GUEST_SYNC(false);
> > > +	GUEST_SYNC(2 | TEST_SYNC_WRITE_FAULT);
> > > +	READ_ONCE(*b);
> > > +	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
> > > +	GUEST_SYNC(2 | TEST_SYNC_NO_FAULT);
> > 
> > Instead of hardcoding 0 and 2 here, which IIUC correspond to the
> > physical addresses 0xc0000000 and 0xc0002000, as well as indices in
> > host_test_mem, can we make the overall definitions a bit more intuitive?
> > 
> > For example:
> > 
> > #define GUEST_GPA_START		0xc0000000
> > #define GUEST_PAGE1_IDX		0
> > #define GUEST_PAGE2_IDX		1
> > #define GUEST_GPA_PAGE1		(GUEST_GPA_START + GUEST_PAGE1_IDX * PAGE_SIZE)
> > #define GUEST_GPA_PAGE2		(GUEST_GPA_START + GUEST_PAGE2_IDX * PAGE_SIZE)
> > 
> > /* Mapped to GUEST_GPA_PAGE1 and GUEST_GPA_PAGE2 */
> > #define GUEST_GVA_PAGE1		0xd0000000
> > #define GUEST_GVA_PAGE2		0xd0002000
> > 
> > /* Mapped to GUEST_GPA_PAGE1 and GUEST_GPA_PAGE2 using TDP in L1 */
> > #define GUEST_GVA_NESTED_PAGE1  0xd0001000
> > #define GUEST_GVA_NESTED_PAGE2	0xd0003000
> > 
> > Then in L2 code, we can explicitly take in the GVA of page1 and page2
> > and use the definitions above in the GUEST_SYNC() calls, for example:
> > 
> > static void l2_guest_code(u64 *page1_gva, u64 *page2_gva)
> > {
> >         READ_ONCE(*page1_gva);
> >         GUEST_SYNC(GUEST_PAGE1_IDX | TEST_SYNC_READ_FAULT);
> >         WRITE_ONCE(*page1_gva, 1);
> >         GUEST_SYNC(GUEST_PAGE1_IDX | TEST_SYNC_WRITE_FAULT);
> > 	...
> > }
> > 
> > and we can explicitly read page1 and page2 from the host (instead of
> > using host_test_mem).
> > 
> > Alternatively, we can pass in the guest GVA directly into GUEST_SYNC(),
> > and use the lower bits for TEST_SYNC_READ_FAULT, TEST_SYNC_WRITE_FAULT,
> > and TEST_SYNC_NO_FAULT.
> >
> > WDYT?
> 
> I fiddled with this a bunch and came up with the below.  It's more or less what
> you're suggesting, but instead of interleaving the aliases, it simply puts them
> at a higher base.  That makes pulling the page frame number out of the GVA much
> cleaner, as it's simply arithmetic instead of weird masking and shifting magic.
> 
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 7 Jan 2026 14:38:32 -0800
> Subject: [PATCH] KVM: selftests: Test READ=>WRITE dirty logging behavior for
>  shadow MMU
> 
> Update the nested dirty log test to validate KVM's handling of READ faults
> when dirty logging is enabled.  Specifically, set the Dirty bit in the
> guest PTEs used to map L2 GPAs, so that KVM will create writable SPTEs
> when handling L2 read faults.  When handling read faults in the shadow MMU,
> KVM opportunistically creates a writable SPTE if the mapping can be
> writable *and* the gPTE is dirty (or doesn't support the Dirty bit), i.e.
> if KVM doesn't need to intercept writes in order to emulate Dirty-bit
> updates.
> 
> To actually test the L2 READ=>WRITE sequence, e.g. without masking a false
> pass by other test activity, route the READ=>WRITE and WRITE=>WRITE
> sequences to separate L1 pages, and differentiate between "marked dirty
> due to a WRITE access/fault" and "marked dirty due to creating a writable
> SPTE for a READ access/fault".  The updated sequence exposes the bug fixed
> by KVM commit 1f4e5fc83a42 ("KVM: x86: fix nested guest live migration
> with PML") when the guest performs a READ=>WRITE sequence with dirty guest
> PTEs.
> 
> Opportunistically tweak and rename the address macros, and add comments,
> to make it more obvious what the test is doing.  E.g. NESTED_TEST_MEM1
> vs. GUEST_TEST_MEM doesn't make it all that obvious that the test is
> creating aliases in both the L2 GPA and GVA address spaces, but only when
> L1 is using TDP to run L2.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/x86/processor.h     |   1 +
>  .../testing/selftests/kvm/lib/x86/processor.c |   7 +
>  .../selftests/kvm/x86/nested_dirty_log_test.c | 188 +++++++++++++-----
>  3 files changed, 145 insertions(+), 51 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
> index ab29b1c7ed2d..8945c9eea704 100644
> --- a/tools/testing/selftests/kvm/include/x86/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> @@ -1483,6 +1483,7 @@ bool kvm_cpu_has_tdp(void);
>  void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
>  void tdp_identity_map_default_memslots(struct kvm_vm *vm);
>  void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
> +uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa);
>  
>  /*
>   * Basic CPU control in CR0
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index ab869a98bbdc..fab18e9be66c 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -390,6 +390,13 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
>  	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
>  }
>  
> +uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa)

nested_paddr is the name used by tdp_map(), maybe use that here as well
(and in the header)?

> +{
> +	int level = PG_LEVEL_4K;
> +
> +	return __vm_get_page_table_entry(vm, &vm->stage2_mmu, l2_gpa, &level);
> +}
> +
>  uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
>  {
>  	int level = PG_LEVEL_4K;
[..]
> @@ -133,35 +220,50 @@ static void test_dirty_log(bool nested_tdp)
>  
>  	/* Add an extra memory slot for testing dirty logging */
>  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> -				    GUEST_TEST_MEM,
> +				    TEST_MEM_BASE,
>  				    TEST_MEM_SLOT_INDEX,
>  				    TEST_MEM_PAGES,
>  				    KVM_MEM_LOG_DIRTY_PAGES);
>  
>  	/*
> -	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
> +	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
>  	 * affects both L1 and L2.  However...
>  	 */
> -	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
> +	virt_map(vm, TEST_MEM_BASE, TEST_MEM_BASE, TEST_MEM_PAGES);
>  
>  	/*
> -	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
> -	 * 0xc0000000.
> +	 * ... pages in the L2 GPA ranges [0xc0001000, 0xc0002000) and
> +	 * [0xc0003000, 0xc0004000) will map to 0xc0000000 and 0xc0001000
> +	 * respectively.

Are these ranges correct? I thought L2 GPA range [0xc0002000,
0xc0004000) will map to [0xc0000000, 0xc0002000).

Also, perhaps it's better to express those in terms of the macros?

L2 GPA range [TEST_MEM_ALIAS_BASE, TEST_MEM_ALIAS_BASE + 2*PAGE_SIZE)
will map to [TEST_MEM_BASE, TEST_MEM_BASE + 2*PAGE_SIZE)?

>  	 *
>  	 * When TDP is disabled, the L2 guest code will still access the same L1
>  	 * GPAs as the TDP enabled case.
> +	 *
> +	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
> +	 * writable SPTEs when handling read faults (if the Dirty bit isn't
> +	 * set, KVM must intercept the next write to emulate the Dirty bit
> +	 * update).
>  	 */
>  	if (nested_tdp) {
> +		vm_vaddr_t gva0 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 0);
> +		vm_vaddr_t gva1 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 1);

Why are these gvas? Should these be L2 GPAs?

Maybe 'uint64_t l2_gpa0' or 'uint64_t nested_paddr0'?

Also maybe add TEST_ALIAS_GPA() macro to keep things consistent?

> +
>  		tdp_identity_map_default_memslots(vm);
> -		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
> -		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
> +		tdp_map(vm, gva0, TEST_GPA(0), PAGE_SIZE);
> +		tdp_map(vm, gva1, TEST_GPA(1), PAGE_SIZE);
> +
> +		*tdp_get_pte(vm, gva0) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
> +		*tdp_get_pte(vm, gva1) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
> +	} else {
> +		*vm_get_pte(vm, TEST_GVA(0)) |= PTE_DIRTY_MASK(&vm->mmu);
> +		*vm_get_pte(vm, TEST_GVA(1)) |= PTE_DIRTY_MASK(&vm->mmu);
>  	}
>  
>  	bmap = bitmap_zalloc(TEST_MEM_PAGES);
> -	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM);
>  
>  	while (!done) {
> -		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * PAGE_SIZE);
> +		memset(TEST_HVA(vm, 0), 0xaa, TEST_MEM_PAGES * PAGE_SIZE);
> +
>  		vcpu_run(vcpu);
>  		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
>  
[..]

