Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047185F6D09
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 19:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiJFRe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 13:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiJFRe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 13:34:26 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3210A4BA0
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 10:34:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so4960055pjq.3
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 10:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i5mTwz3tQoNE8/r9o4xGhti82WePEbOcLiD3ASowq1M=;
        b=RorfeGQp6ZFtTDw5vMZqFUuDO1QoPgtNmIPq1B/e7lFNg26RJntRjWRbG1pauQSc5x
         tpyC+En9VznOSszFKZwDEm3yEtNyUY14UG8FA5GaM7xjKJ8P35Tf5GJ/IyocjpzCcJvC
         sU5d4OMT31lC5X0BUcXOr+wdyQNzJ78ANSZRxk3nxHi8838FByXfcYLKoVyBLT462fmM
         /+GK211d2CneJEwkxrsh+BBOgsUwKcaKSkmjeGrxCicpgsBxEpfa+biLwI+3MVco8EFK
         wBwKcZYCTCFjGbQYdrkovW7NpD2ElIuHiBC9zsnCCnY2OCxhb0Em62srzzMdoS2sB7+G
         f+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5mTwz3tQoNE8/r9o4xGhti82WePEbOcLiD3ASowq1M=;
        b=J7+/1/v0/AjD/ORmuDtUY/yBWwwMfntnQh5ip5Wsm5RSYVKCiuDeWZ4QwbUhiIrXVN
         4ljJOp16pdkmM57LLnqNl8Fg2kVw5HJfMYS6wo4HxTd8VyfpkXVQWqBGSGfk68xk459d
         DmdQCffpojM/Njuh52Yezh+A9y7m2oV+kLYsiF8MyQcBqtj2Qt6Q2npkyOQLyJx0W7zD
         nqOjvogAG/we2sdLOD2b7dh6l+nYN+DblYqiHbthIDowxiWV6EYDwkuIpq6J6+NKENlt
         XV6EN5NJwP9SzCCmFo3b8rg67ZfDL4F5D/VuRLaVmT9qjrA1nOyFVZQYtLYcW5RFjzFc
         DyGA==
X-Gm-Message-State: ACrzQf17oG/NcIYl295/ZqfamhdKXRJeXRK521r1Sk4VXhYWNs0CvHph
        vAAWWGIM86k/lTebcnsd2hK6Tg==
X-Google-Smtp-Source: AMsMyM5gIa+THZTUBnYZkMYu7WkLZpR1MmDrPyXejBJ4ZhgEYcoojacaPmxg4NV/Q4ItP/aToWHtfw==
X-Received: by 2002:a17:90b:4c41:b0:202:78e9:472b with SMTP id np1-20020a17090b4c4100b0020278e9472bmr783726pjb.207.1665077665065;
        Thu, 06 Oct 2022 10:34:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n64-20020a622743000000b00562235244c0sm3621318pfn.6.2022.10.06.10.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 10:34:23 -0700 (PDT)
Date:   Thu, 6 Oct 2022 17:34:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Subject: Re: [V4 4/8] KVM: selftests: handle encryption bits in page tables
Message-ID: <Yz8Rm7zjXDHhdFw1@google.com>
References: <20220829171021.701198-1-pgonda@google.com>
 <20220829171021.701198-5-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829171021.701198-5-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022, Peter Gonda wrote:
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 53b9a509c1d5..de13be62d52d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1388,6 +1388,58 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  	}
>  }
>  
> +/*
> + * Mask off any special bits from raw GPA
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   gpa_raw - Raw VM physical address
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   GPA with special bits (e.g. shared/encrypted) masked off.
> + */
> +vm_paddr_t addr_raw2gpa(struct kvm_vm *vm, vm_paddr_t gpa_raw)
> +{
> +	if (!vm->memcrypt.has_enc_bit)
> +		return gpa_raw;
> +
> +	return gpa_raw & ~(1ULL << vm->memcrypt.enc_bit);

1. The notion of stealing GPA bits to tag the page should not be tied to memory
   encryption.

2. Assuming that the shared vs. private bit is active-high is wrong, e.g. TDX
   has active-low behavior.

3. "raw" is not super untuitive.

4. addr_gpa2raw() should not exist.  It assumes the "raw" address always wants
   the encryption bit set.

5. enc_by_default is an SEV-centric flag that should not exist outside of x86.

I think the easiest and most familiar solution for #1 will be to borrow the
kernel's tag/untag terminology for handling virtual addresses that can be tagged
for ASAN, e.g. ARM's top-byte-ignore  and x86's linear address masking (LAM).

So instead of addr_raw2gpa(), just do:

  static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_vaddr_t gpa)
  {
	return gpa & ~vm->gpa_tag_mask;
  }

That way zero-allocating the VM will Just Work.

> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 2e6e61bbe81b..b2df259ce706 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -118,7 +118,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  
>  	/* If needed, create page map l4 table. */
>  	if (!vm->pgd_created) {
> -		vm->pgd = vm_alloc_page_table(vm);
> +		vm->pgd = addr_gpa2raw(vm, vm_alloc_page_table(vm));

Rather than add "struct vm_memcrypt", I think it makes sense to introduce
"struct kvm_vm_arch" and then the x86 implementation can add pte_me_mask, similar
to what KVM does for SPTEs.  THen this code because

		vm->pgd = vm_alloc_page_table(vm) | vm->arch.pte_me_mask;

That will Just Work for TDX, because its pte_me_mask will be '0', even though it
effectively has an encryption bit (active-low).

>  		vm->pgd_created = true;
>  	}
>  }
> @@ -140,13 +140,15 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
>  				       int target_level)
>  {
>  	uint64_t *pte = virt_get_pte(vm, pt_pfn, vaddr, current_level);
> +	uint64_t paddr_raw = addr_gpa2raw(vm, paddr);
>  
>  	if (!(*pte & PTE_PRESENT_MASK)) {
>  		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
>  		if (current_level == target_level)
> -			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
> +			*pte |= PTE_LARGE_MASK | (paddr_raw & PHYSICAL_PAGE_MASK);
>  		else
> -			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
> +			*pte |= addr_gpa2raw(vm, vm_alloc_page_table(vm)) & PHYSICAL_PAGE_MASK;

Prefer to write this as:

			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
			*pte |= vm->arch.pte_me_mask;

so that selftests don't assume the encryption bit is stolen from the GPA.

> +
>  	} else {
>  		/*
>  		 * Entry already present.  Assert that the caller doesn't want
> @@ -184,6 +186,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  		    "Physical address beyond maximum supported,\n"
>  		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
>  		    paddr, vm->max_gfn, vm->page_size);
> +	TEST_ASSERT(addr_raw2gpa(vm, paddr) == paddr,
> +		    "Unexpected bits in paddr: %lx", paddr);
>  
>  	/*
>  	 * Allocate upper level page tables, if not already present.  Return
> @@ -206,7 +210,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  	pte = virt_get_pte(vm, PTE_GET_PFN(*pde), vaddr, PG_LEVEL_4K);
>  	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
>  		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
> -	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
> +	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK |
> +	       (addr_gpa2raw(vm, paddr) & PHYSICAL_PAGE_MASK);

And with the above suggestions, this can become something like:

	if (vm_is_gpa_encrypted(vm, paddr))
		*pte |= vm->arch.c_bit;
	else
		*pte |= vm->arch.s_bit;

where SEV sets c_bit and TDX sets s_bit.

>  void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
> @@ -515,7 +520,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	if (!(pte[index[0]] & PTE_PRESENT_MASK))
>  		goto unmapped_gva;
>  
> -	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
> +	return addr_raw2gpa(vm, PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);

Aha!  A use for my rework[*] of this mess!  I don't think you need to take a
dependency on that work, at a glance the conflicts should be minor, i.e. doesn't
matter that much which lands first.

[*] https://lore.kernel.org/all/20221006004512.666529-1-seanjc@google.com
