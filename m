Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C4B526ACD
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383929AbiEMUEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346904AbiEMUEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:04:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9388C13D46
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652472271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KmdRIFdtBy3MI+hhfWLtmDXgW2B1LXYFkIjwZPtA7Lc=;
        b=PPG5LU6FUxZEh37GL4cS/az4xKTFx3V+JZCosZFHf9tAL70ATefiwcGHVu6ZqLhxr2tkHa
        YFCG5vPLpZqST+8LlkJEF2JB6J1aEs7FQg24xaI/TBflbOAuSS4ScZswX1y7TPrQzAexic
        hkFadSbKonD9yJxPI1XQsjJuPXwtuOo=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-8os0sDupNciTLo_VgGQ_iw-1; Fri, 13 May 2022 16:04:30 -0400
X-MC-Unique: 8os0sDupNciTLo_VgGQ_iw-1
Received: by mail-io1-f72.google.com with SMTP id c25-20020a5d9399000000b00652e2b23358so5381277iol.6
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KmdRIFdtBy3MI+hhfWLtmDXgW2B1LXYFkIjwZPtA7Lc=;
        b=SxpCE5+eLwJsBUTfUxgYwNg604nIdx73hHIWKN58Cumj/u6C3LjYJwFr1lfF96OS9D
         WeGS8Ke5diV79W1NYAS5Iad6xKUsqeJOR//kwWw62fQwn7gazebBzWfKqlgoLG53zpKt
         l+DQQNBIwpSWenFvnmXjjVegQKBfkO8jTC3soyoJXNEVmkx4rcLFvxNjU5JWg46HHXTb
         nmyjj/EsQQnlWN7B/yHIuLlpSD29hxuv9HHcJOw2aTU5qqy4W9ghmpTuuvu6HlctKeJd
         vpx+7ANF57l3xx2wMD7SPtQvaHlVG0bT23J1wfpKp9zjIoRlsvTLXY3OfxJWw1xTSOjs
         I/Lg==
X-Gm-Message-State: AOAM533InkOeuvymyxZlBAKdY022b3w+1gtAAqNcNHTln7hfUcTcaJ/F
        BvPdQ0uyQpS9jmTPvrFuIs4QSVzNI164JGMItheKv4pGz1oN+sAmxAUXlD6dUUuhSd4fna04oB4
        /Q0b2aIsCT9rS
X-Received: by 2002:a02:2124:0:b0:32d:beca:e5ab with SMTP id e36-20020a022124000000b0032dbecae5abmr3458383jaa.119.1652472269413;
        Fri, 13 May 2022 13:04:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAteW2lMcPDUgF04zQzjEA5jFdq4H3xiZkIfyc1FiG1FsqqXu1qd5EZKPEqP97SNU6Kd1c+A==
X-Received: by 2002:a02:2124:0:b0:32d:beca:e5ab with SMTP id e36-20020a022124000000b0032dbecae5abmr3458369jaa.119.1652472269097;
        Fri, 13 May 2022 13:04:29 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id b17-20020a923411000000b002cde6e352f8sm823295ila.66.2022.05.13.13.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 13:04:28 -0700 (PDT)
Date:   Fri, 13 May 2022 16:04:26 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/9] KVM: selftests: Replace x86_page_size with raw levels
Message-ID: <Yn65yvxPIJwgiuxj@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-2-dmatlack@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:27PM +0000, David Matlack wrote:
> x86_page_size is an enum used to communicate the desired page size with
> which to map a range of memory. Under the hood they just encode the
> desired level at which to map the page. This ends up being clunky in a
> few ways:
> 
>  - The name suggests it encodes the size of the page rather than the
>    level.
>  - In other places in x86_64/processor.c we just use a raw int to encode
>    the level.
> 
> Simplify this by just admitting that x86_page_size is just the level and
> using an int and some more obviously named macros (e.g. PG_LEVEL_1G).
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 14 +++++-----
>  .../selftests/kvm/lib/x86_64/processor.c      | 27 +++++++++----------
>  .../selftests/kvm/max_guest_memory_test.c     |  2 +-
>  .../selftests/kvm/x86_64/mmu_role_test.c      |  2 +-
>  4 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 37db341d4cc5..b512f9f508ae 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -465,13 +465,13 @@ void vcpu_set_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
>  struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
>  void vm_xsave_req_perm(int bit);
>  
> -enum x86_page_size {
> -	X86_PAGE_SIZE_4K = 0,
> -	X86_PAGE_SIZE_2M,
> -	X86_PAGE_SIZE_1G,
> -};
> -void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> -		   enum x86_page_size page_size);
> +#define PG_LEVEL_4K 0
> +#define PG_LEVEL_2M 1
> +#define PG_LEVEL_1G 2

A nitpick is: we could have named those as PG_LEVEL_[PTE|PMD|PUD|PGD..]
rather than 4K|2M|..., then...

> +
> +#define PG_LEVEL_SIZE(_level) (1ull << (((_level) * 9) + 12))
> +
> +void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
>  
>  /*
>   * Basic CPU control in CR0
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 9f000dfb5594..1a7de69e2495 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -199,15 +199,15 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
>  						    uint64_t pt_pfn,
>  						    uint64_t vaddr,
>  						    uint64_t paddr,
> -						    int level,
> -						    enum x86_page_size page_size)
> +						    int current_level,
> +						    int target_level)
>  {
> -	struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
> +	struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, current_level);
>  
>  	if (!pte->present) {
>  		pte->writable = true;
>  		pte->present = true;
> -		pte->page_size = (level == page_size);
> +		pte->page_size = (current_level == target_level);
>  		if (pte->page_size)
>  			pte->pfn = paddr >> vm->page_shift;
>  		else
> @@ -218,20 +218,19 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
>  		 * a hugepage at this level, and that there isn't a hugepage at
>  		 * this level.
>  		 */
> -		TEST_ASSERT(level != page_size,
> +		TEST_ASSERT(current_level != target_level,
>  			    "Cannot create hugepage at level: %u, vaddr: 0x%lx\n",
> -			    page_size, vaddr);
> +			    current_level, vaddr);
>  		TEST_ASSERT(!pte->page_size,
>  			    "Cannot create page table at level: %u, vaddr: 0x%lx\n",
> -			    level, vaddr);
> +			    current_level, vaddr);
>  	}
>  	return pte;
>  }
>  
> -void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> -		   enum x86_page_size page_size)
> +void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  {
> -	const uint64_t pg_size = 1ull << ((page_size * 9) + 12);
> +	const uint64_t pg_size = PG_LEVEL_SIZE(level);
>  	struct pageUpperEntry *pml4e, *pdpe, *pde;
>  	struct pageTableEntry *pte;
>  
> @@ -256,15 +255,15 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  	 * early if a hugepage was created.
>  	 */
>  	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift,
> -				      vaddr, paddr, 3, page_size);
> +				      vaddr, paddr, 3, level);
>  	if (pml4e->page_size)
>  		return;
>  
> -	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, page_size);
> +	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, level);
>  	if (pdpe->page_size)
>  		return;
>  
> -	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, page_size);
> +	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, level);

... here we could also potentially replace the 3/2/1s with the new macro
(or with existing naming number 3 will be missing a macro)?

>  	if (pde->page_size)
>  		return;

-- 
Peter Xu

