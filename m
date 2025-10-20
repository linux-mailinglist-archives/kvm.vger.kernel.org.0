Return-Path: <kvm+bounces-60561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF41BF29D0
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 19:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDB513BDCFA
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 17:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B082E330320;
	Mon, 20 Oct 2025 17:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UwkgW0U2"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6539F32B9A8
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 17:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760980260; cv=none; b=ZlAqeFzrNA82MRAWViBemq5Qq6+Z9Gbls2WkflMX5dHTZ3JZT+t1Pufcs3hl0zYt57hqBJt5UvG+AerFQlTtGneDY5s/0rMozF5aDrmoDR5jrhkQ5tqJlI/6UhL00I5Jc111O0RXkyGNvWfFiCqg2J1U6EoKK7TMH3NCUDfOcB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760980260; c=relaxed/simple;
	bh=AxIWE6iyO7Ox6m/9nhJ9NldPxg6UR5QmtIrf8wdrwwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BzATwQvIlAvcyiuAF5gGkiJekzpP3zYtJZtGH2zSz6lxJEPnVY7vvbO1fT8HnS1Dtq/kOT8BfbusIBfVaCf/fiiYJ7x4mAl1zd9Jdb961aMwJ0TvZMPQrq7xe+yVvHRsF589oG2aUoXkHcy6XWFMNnBeBeHCmTd54hGnC0PCH6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UwkgW0U2; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 20 Oct 2025 17:10:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760980256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aSf8ZuG7Eh6WV3v9wcYX32BSw6mgJdJhb5+lBU8QmAY=;
	b=UwkgW0U2aqd2eVZG5BGxiBBExVol2fh5Kz30LAnbxEyJcJ5KEnj7Ff7Cn0SGvLeMYibadi
	kaVV4pHYJ+VdkAWg/bsEXO8bD9AZm824XXzokeWNRDfBhGJ7OZ3NGxgN/s89b6dYadc5uK
	N78AmE1Ya0s9fiphyhUtDkFX2dp3E2s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Kai Huang <kai.huang@intel.com>, Eric Auger <eric.auger@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: selftests: Use a loop to create guest page
 tables
Message-ID: <bbppzosz2alycri5o75fibahsqeb2y4bq5n6b3b23amrgtlrro@ppp5vwu2uoat>
References: <20250917215031.2567566-1-jmattson@google.com>
 <20250917215031.2567566-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917215031.2567566-2-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 17, 2025 at 02:48:37PM -0700, Jim Mattson wrote:
> Walk the guest page tables via a loop when creating new mappings,
> instead of using unique variables for each level of the page tables.
> 
> This simplifies the code and makes it easier to support 5-level paging
> in the future.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  .../testing/selftests/kvm/lib/x86/processor.c | 22 +++++++------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index d4c19ac885a9..0238e674709d 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -184,8 +184,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
>  void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  {
>  	const uint64_t pg_size = PG_LEVEL_SIZE(level);
> -	uint64_t *pml4e, *pdpe, *pde;
> -	uint64_t *pte;
> +	uint64_t *pte = &vm->pgd;
> +	int current_level;
>  
>  	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
>  		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
> @@ -209,20 +209,14 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  	 * Allocate upper level page tables, if not already present.  Return
>  	 * early if a hugepage was created.
>  	 */
> -	pml4e = virt_create_upper_pte(vm, &vm->pgd, vaddr, paddr, PG_LEVEL_512G, level);
> -	if (*pml4e & PTE_LARGE_MASK)
> -		return;
> -
> -	pdpe = virt_create_upper_pte(vm, pml4e, vaddr, paddr, PG_LEVEL_1G, level);
> -	if (*pdpe & PTE_LARGE_MASK)
> -		return;
> -
> -	pde = virt_create_upper_pte(vm, pdpe, vaddr, paddr, PG_LEVEL_2M, level);
> -	if (*pde & PTE_LARGE_MASK)
> -		return;
> +	for (current_level = vm->pgtable_levels; current_level > 0; current_level--) {

I think the condition here should be: "current_level > PG_LEVEL_4K" or
"current_level >= PG_LEVEL_2M". PG_LEVEL_4K is 1, so right now we will
call virt_create_upper_pte() for PG_LEVEL_4K and skip the logic after
the logic after the loop.

I think it still accidentally works for most cases, but we shouldn't
rely on that.

> +		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level);
> +		if (*pte & PTE_LARGE_MASK)
> +			return;
> +	}
>  
>  	/* Fill in page table entry. */
> -	pte = virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
> +	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
>  	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
>  		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
>  	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
> -- 
> 2.51.0.470.ga7dc726c21-goog
> 

