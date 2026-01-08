Return-Path: <kvm+bounces-67454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BF468D05914
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 66329306394D
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 18:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F96831AA91;
	Thu,  8 Jan 2026 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vM6gfqsW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61A730F7E8
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767897087; cv=none; b=RIeClIZMcsrJxYfZkF3GYZzPPEiffE81FuiZhIq4XZm+P0f9sml0tiOYo2QKZXtfK3+vyLu2UAxR44GjCHdSksfTdlYQ2eFE3disG85NVLNBWC+DVUor9jGj7cTuI9e+FPKkronA/pC1GpFXTaN6oYwJRJ6h/O5gBiRZAWySxKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767897087; c=relaxed/simple;
	bh=HiZzKC6IpEiXD+YG7Xq5JdCfDWfJLzGMhECalIcNpBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cfNUVm7dmRy0X5ldPd8eF/u1OUkoixcfC8Uppp6GoBQ2FIiIPE2TczJXoO0VOiybuPdasAq+jbDq4fndAyr8Lw8gXMgDeeThnxNzoMU+bvUZQr/sYvrIge2mEpHkizNmmwj/qOfy+Rr0IGk69mTRou8VMaffL/HEEX4zu+6WgJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vM6gfqsW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c704d5d15so5822630a91.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 10:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767897084; x=1768501884; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nY/l54WU76DsZYqDI43j/uSoqA/+4oD9QHehzkck2fM=;
        b=vM6gfqsWwI1u64FI4M91FEqxL5tVGhgDe3MSHI2wsgQWBqCFuGQS2ZzKKmCwEkwF8V
         iaZCKCpf8bnkObE5VlthNEtm9ufO/3YoisO2OEvQSKvCI7gh13n6yIt5R4cVD/GjUBwc
         d+Z4MalPRxDpUjvGoSSNdsn3ryzuXvG7VfGz3wsz80Cov3jLl14vqbQBdapOq7aJYQrc
         qHxwPwc8fdFwCTpAgBxOt/aqUFqgXKMUfXk6IDGXdpsEkwEwQbmyI+XlDSl71ojwMO4M
         MwQtlyDS+LuVazXVVLWaRiYF08kPJZtOwiAWsGJzDybEqMUP5Fm05X7IUdpOulkuQm9K
         d/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767897084; x=1768501884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nY/l54WU76DsZYqDI43j/uSoqA/+4oD9QHehzkck2fM=;
        b=qsXsCXwSTEX9TpYdfKdGBEP8pTFj7aCMO8wCjd0lroZ5oGquxqkpduy7ujqLr92Q7d
         B3EXkQYPQZ04TzqErbvhVUGySVCHoigWVHUN/yoeFZ0pBA64YZhqfuve7VT6+Exxwkfj
         tOpgEA0oYz/wQH+lETYt/QNMgnWR5+4Kk4sxK3Iyxl8eBnl5rer7L9lmdXxxy67E9wcm
         qyNy7o3ExtBPpE71xTt2AZFQzA740MQOBgAvtvgCB5WPaSYzjWTqBuykIq+/mi7ammuS
         m4rEruPChenqJVFgNHg5WfOl6EvUmpZCaWW136S4ZUuADk+KmAkvjgzi5JRV3HdowTMV
         Q/yg==
X-Forwarded-Encrypted: i=1; AJvYcCV0nGCbUe7eVFkuiQjZODWMzNKiNevBCaKdDzXqrvfKSEPpoqo3c40PLbSAcA42Gu2tAWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGU0TW1KrWBQDQD1D9OFkwJQ3/R6kZdjziZrOBwWqqvfIsHW1Y
	DSMSuqzgmf81a02kJq9poY+lbyZS6Yin1IoT1nLpx9lb1uLt18jOKvrh8Jf06xd4RKeTktPDbOr
	2W4U3Ig==
X-Google-Smtp-Source: AGHT+IHEOdI4r0O9pcHM188bqvdusRA2ROI4oJ6wpZajhgwchTGU2kxOjQW3XQ2z18n6bt3vYCQzcYAxHoc=
X-Received: from pjrx16.prod.google.com ([2002:a17:90a:bc90:b0:34c:6f7a:2ab8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c09:b0:349:2154:eef4
 with SMTP id 98e67ed59e1d1-34f68b83d71mr6555128a91.5.1767897083980; Thu, 08
 Jan 2026 10:31:23 -0800 (PST)
Date: Thu, 8 Jan 2026 10:31:22 -0800
In-Reply-To: <gzyjze3wszmrwxdwnudij6nfqdxzihm37uappfqxorfjy5vatf@hffzaobbm3g7>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com> <20251230230150.4150236-22-seanjc@google.com>
 <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
 <aV_cLAlz4v1VOkDt@google.com> <gzyjze3wszmrwxdwnudij6nfqdxzihm37uappfqxorfjy5vatf@hffzaobbm3g7>
Message-ID: <aV_3-lhnZ-MoKnjv@google.com>
Subject: Re: [PATCH v4 21/21] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 08, 2026, Yosry Ahmed wrote:
> On Thu, Jan 08, 2026 at 08:32:44AM -0800, Sean Christopherson wrote:
> > On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> > diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> > index ab869a98bbdc..fab18e9be66c 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> > @@ -390,6 +390,13 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
> >  	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
> >  }
> >  
> > +uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa)
> 
> nested_paddr is the name used by tdp_map(), maybe use that here as well
> (and in the header)?

Oh hell no :-)  nested_paddr is a terrible name (I was *very* tempted to change
it on the fly, but restrained myself).  "nested" is far too ambigous, e.g. without
nested virtualization, "nested_paddr" arguably refers to _L1_ physical addresses
(SVM called 'em Nested Page Tables after all).

> > +	int level = PG_LEVEL_4K;
> > +
> > +	return __vm_get_page_table_entry(vm, &vm->stage2_mmu, l2_gpa, &level);
> > +}
> > +
> >  uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
> >  {
> >  	int level = PG_LEVEL_4K;
> [..]
> > @@ -133,35 +220,50 @@ static void test_dirty_log(bool nested_tdp)
> >  
> >  	/* Add an extra memory slot for testing dirty logging */
> >  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> > -				    GUEST_TEST_MEM,
> > +				    TEST_MEM_BASE,
> >  				    TEST_MEM_SLOT_INDEX,
> >  				    TEST_MEM_PAGES,
> >  				    KVM_MEM_LOG_DIRTY_PAGES);
> >  
> >  	/*
> > -	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
> > +	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
> >  	 * affects both L1 and L2.  However...
> >  	 */
> > -	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
> > +	virt_map(vm, TEST_MEM_BASE, TEST_MEM_BASE, TEST_MEM_PAGES);
> >  
> >  	/*
> > -	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
> > -	 * 0xc0000000.
> > +	 * ... pages in the L2 GPA ranges [0xc0001000, 0xc0002000) and
> > +	 * [0xc0003000, 0xc0004000) will map to 0xc0000000 and 0xc0001000
> > +	 * respectively.
> 
> Are these ranges correct? I thought L2 GPA range [0xc0002000,
> 0xc0004000) will map to [0xc0000000, 0xc0002000).

Gah, no.  I looked at the comments after changing things around, but my eyes had
glazed over by that point.

> Also, perhaps it's better to express those in terms of the macros?
> 
> L2 GPA range [TEST_MEM_ALIAS_BASE, TEST_MEM_ALIAS_BASE + 2*PAGE_SIZE)
> will map to [TEST_MEM_BASE, TEST_MEM_BASE + 2*PAGE_SIZE)?

Hmm, no, at some point we need to concretely state the addresses, so that people
debugging this know what to expect, i.e. don't have to manually compute the
addresses from the macros in order to debug.

> >  	 *
> >  	 * When TDP is disabled, the L2 guest code will still access the same L1
> >  	 * GPAs as the TDP enabled case.
> > +	 *
> > +	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
> > +	 * writable SPTEs when handling read faults (if the Dirty bit isn't
> > +	 * set, KVM must intercept the next write to emulate the Dirty bit
> > +	 * update).
> >  	 */
> >  	if (nested_tdp) {
> > +		vm_vaddr_t gva0 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 0);
> > +		vm_vaddr_t gva1 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 1);
> 
> Why are these gvas? Should these be L2 GPAs?

Pure oversight.

> Maybe 'uint64_t l2_gpa0' or 'uint64_t nested_paddr0'?

For better of worse, vm_paddr_t is the typedef in selftests.  Hmm, if/when we go
with David M's proposal to switch to u64 (from e.g. uint64_t), it'd probably be
a good time to switch to KVM's gva_t and gpa_t as well.

> Also maybe add TEST_ALIAS_GPA() macro to keep things consistent?

Ya, then the line lengths are short enough to omit the local variables.  How's
this look?

	/*
	 * ... pages in the L2 GPA address range [0xc0002000, 0xc0004000) will
	 * map to [0xc0000000, 0xc0002000) when TDP is enabled (for L2).
	 *
	 * When TDP is disabled, the L2 guest code will still access the same L1
	 * GPAs as the TDP enabled case.
	 *
	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
	 * writable SPTEs when handling read faults (if the Dirty bit isn't
	 * set, KVM must intercept the next write to emulate the Dirty bit
	 * update).
	 */
	if (nested_tdp) {
		tdp_identity_map_default_memslots(vm);
		tdp_map(vm, TEST_ALIAS_GPA(0), TEST_GPA(0), PAGE_SIZE);
		tdp_map(vm, TEST_ALIAS_GPA(1), TEST_GPA(1), PAGE_SIZE);

		*tdp_get_pte(vm, TEST_ALIAS_GPA(0)) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
		*tdp_get_pte(vm, TEST_ALIAS_GPA(1)) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
	} else {
		*vm_get_pte(vm, TEST_GVA(0)) |= PTE_DIRTY_MASK(&vm->mmu);
		*vm_get_pte(vm, TEST_GVA(1)) |= PTE_DIRTY_MASK(&vm->mmu);
	}

