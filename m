Return-Path: <kvm+bounces-64012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AC08DC76B53
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 275434E5BEE
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA25548EE;
	Fri, 21 Nov 2025 00:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EBCFHZ5U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A236B22301
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763683651; cv=none; b=Wl9aZwoIY4UXi+zrcI3y1ruf+leduu5y0InyCXisvgSjReZhLU1SeO37qiEnmpmArJFQSnbqw/DbQK2vHsc9z8t5516ySyqn7iaZDDzGCeUvUu/fi7zXY1rzxPi8UODW4AP5SUToI6Kre2WlrBxrf405xbr04RJ8vdNszrpNYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763683651; c=relaxed/simple;
	bh=Bw6SOeKXJPP1Vabhn/eXHV9EZPngoa+E1reOZJ8nPtE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W7XMFFaOVJXBumE/HuXWOoXNeyPSZ2lyDS8GtsIzzcn1UEb94IoU6PDOJ1IYhzyJ/tjl1iPK80GVvWJEsRv8pb5amISoiUlriRGMjyc+0ngbMugQXW5K0r+/xS+teD8EGTEHWXLA6AWFfn7jGx0kpJXT6x8J89ON6fqEEQRm/Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EBCFHZ5U; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29848363458so38607365ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763683649; x=1764288449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zub/LgwmJGfUBNlL4QK39HVPlLUfpHL27+w5zNo3tME=;
        b=EBCFHZ5UkS5dHQet+RUf9/oHHwJBhsF5muNAH41Vr+rryurV/Bjoav88HQodZ2etE5
         tx3ma7UyBlnh7YFI9yUFar2qBZuYzuWKv6baGStqtev7hf+RoOrjkeiI650RnzpPXEje
         gfc/wAIXwNMLfze3cRMwdN3oc3AwcWXOMqvFu8YfzqDQAGNVLeR6ecLSkV4wq+WufTVn
         rXqMtod3PpzvCNOpTP7K/DJNWbUm7gxYuzpiCUiJwrSFkWFXUZ6ujHW59baENyGxf5dl
         Xh0a12ep+t3ytlAEFrkv+uWRdhrScjHvaF+kWCdn/Xt/Ncl6e62N7G3wc7LeTTfpflSB
         wzsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763683649; x=1764288449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zub/LgwmJGfUBNlL4QK39HVPlLUfpHL27+w5zNo3tME=;
        b=X5b4IpqUAEPm207GmHK2RPPBh6xX+Gzvi1EsNCGx/5C+UPxMrkSZjPjDHEBj988w2u
         7jLrZ9nexMisy1/zVV32+uUVQM3iLbN2yIBpcWjKqbbhNHO0M0jXyyQczQbmEDdo16N3
         G3qm0F08QXTkvCGwIj/QGM7migRNVgVRqq9Wi8k3yaGrGSDnnTNu0zi31FIs6xHoYgT0
         iWZUC39QDxcpQI2UujsckG5RBi3+AJwPV+7AaiIGeHDmrOYKbuVCTD82EgXabYgjuufW
         L1u1QzbATol79wyQAmNDpbg+vl/c7j09w+xDPuJt8b8GehfuaXKMU18D+R1IVnzf/uT/
         XSiA==
X-Forwarded-Encrypted: i=1; AJvYcCV9E8DGwjlu5W2J4FejQ+QjdUg1omjYMod3o3BS4oDllmEYTYgA9i5JsscAezj8xWZzVp4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0RsTK67fHc5KOS0EHBJs7sg6u4Ynd29UTGnl1+W+gCQNPwt7X
	WPUMxcAGnAq+dgCOKg2FVdrqydmzSm+dA3cfLWckt5aFQ/5r9dLOL//b0hPUOjymQWdOp4hPqrC
	wL4rQ/A==
X-Google-Smtp-Source: AGHT+IFfgH36wimkvqZwu0QikflAfumKyoxMAev3hGg0jE169dy6SX5bvpApnrsH4wgt1dHTBCBsl7QxCd4=
X-Received: from pldb6.prod.google.com ([2002:a17:902:ed06:b0:292:5d48:6269])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2985:b0:295:8c51:6505
 with SMTP id d9443c01a7336-29b6bf359dfmr5490895ad.33.1763683648938; Thu, 20
 Nov 2025 16:07:28 -0800 (PST)
Date: Thu, 20 Nov 2025 16:07:27 -0800
In-Reply-To: <20251021074736.1324328-13-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev> <20251021074736.1324328-13-yosry.ahmed@linux.dev>
Message-ID: <aR-tP8YBftwZA3DD@google.com>
Subject: Re: [PATCH v2 12/23] KVM: selftests: Parameterize the PTE bitmasks
 for virt mapping functions
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> @@ -1367,8 +1357,6 @@ static inline bool kvm_is_ignore_msrs(void)
>  	return get_kvm_param_bool("ignore_msrs");
>  }
>  
> -uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
> -				    int *level);
>  uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
>  
>  uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
> @@ -1451,7 +1439,20 @@ enum pg_level {
>  #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
>  #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
>  
> -void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
> +struct pte_masks {
> +	uint64_t present;
> +	uint64_t writeable;
> +	uint64_t user;
> +	uint64_t accessed;
> +	uint64_t dirty;
> +	uint64_t large;

Ugh, "large".  I vote for "huge" or "hugepage", as that's for more ubiquitous in
the kernel.

> +	uint64_t nx;

The values themselves should be const, e.g. to communicate that they are fixed
values.

> +};
> +
> +extern const struct pte_masks x86_pte_masks;

> -void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
> +void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> +		   int level, const struct pte_masks *masks)
>  {
>  	const uint64_t pg_size = PG_LEVEL_SIZE(level);
>  	uint64_t *pte = &vm->pgd;
> @@ -246,16 +259,16 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  	 * early if a hugepage was created.
>  	 */
>  	for (current_level = vm->pgtable_levels; current_level > PG_LEVEL_4K; current_level--) {
> -		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level);
> -		if (*pte & PTE_LARGE_MASK)
> +		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level, masks);
> +		if (*pte & masks->large)
>  			return;
>  	}
>  
>  	/* Fill in page table entry. */
> -	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
> -	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
> +	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K, masks);
> +	TEST_ASSERT(!(*pte & masks->present),

I think accessors would help for the "read" cases?  E.g.

	TEST_ASSERT(!is_present_pte(mmu, *pte)

or maybe go with a slightly atypical ordering of:

	TEST_ASSERT(!is_present_pte(*pte, mmu),

The second one seems more readable.

>  		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
> -	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
> +	*pte = masks->present | masks->writeable | (paddr & PHYSICAL_PAGE_MASK);

Hrm.  I don't love the masks->lowercase style, but I don't hate it either.  One
idea would be to add macros to grab the correct bit, e.g.

	*pte = PTE_PRESENT(mmu) | PTE_WRITABLE(mmu) | (paddr & PHYSICAL_PAGE_MASK);

Alternatively, assuming we add "struct kvm_mmu", we could grab the "pte_masks"
structure locally as "m" and do this?  Note sure the super-shorthand is a net
positive though.

	*pte = PTE_PRESENT(m) | PTE_WRITABLE(m) | (paddr & PHYSICAL_PAGE_MASK);

Or we could YELL REALLY LOUDLY in the fields themselves, e.g.

	*pte = m->PRESENT | m->WRITABLE | (paddr & PHYSICAL_PAGE_MASK);

but that looks kinda weird to me.

I don't have a super strong preference, though I'm leaning towards accessor
functions with macros for retrieving the bits.

>  	/*
>  	 * Neither SEV nor TDX supports shared page tables, so only the final

Hiding just out of sight is this code:

	/*
	 * Neither SEV nor TDX supports shared page tables, so only the final
	 * leaf PTE needs manually set the C/S-bit.
	 */
	if (vm_is_gpa_protected(vm, paddr))
		*pte |= vm->arch.c_bit;
	else
		*pte |= vm->arch.s_bit;

The C-bit (enCrypted) and S-bit (Shared) values need to be moved into the masks/mmu
context as well.  In practice, they'll both be zero when creating nested mappings
since KVM doesn't support nested VMs with encrypted memory, but it's still wrong,
e.g. the Shared bit doesn't exist in EPT.

