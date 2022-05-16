Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C81529233
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348943AbiEPU53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 16:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347856AbiEPU5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 16:57:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 008E9112A
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652733135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uvvRXbSYTu5xOHgdAEKlWa/nTvBRnaJwA08LC/n1spU=;
        b=S+vTbe9KlbTXcZs2NuLITDoLt21N1YhtFPE690XmcJmDlICxtfGwn4LPNtEq9+aWRBxg2x
        GYZ+FAFAV4lK3TvkpzRfXe17Ki0TwoXNgJgfS6ZJWmf0AR1y8WzAzzyw2LRjqF7yDcWJEm
        5v2LCmGzbU3+7VSOM5D5GQhLzqlQfIE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-mXUdryXjNxO5-3mkTBMxjQ-1; Mon, 16 May 2022 16:32:14 -0400
X-MC-Unique: mXUdryXjNxO5-3mkTBMxjQ-1
Received: by mail-il1-f198.google.com with SMTP id g11-20020a056e021a2b00b002cf48b48824so8292777ile.21
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:32:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uvvRXbSYTu5xOHgdAEKlWa/nTvBRnaJwA08LC/n1spU=;
        b=rGCnW/h7AuTqscc7i5bykuPcgbBzmBV0WdE7SU97fA0Ss3/3uon8v7JzO1z7gP2N6J
         Obv1vquFllSc7k4RHgB6GNZQPLsDZlu1Y48d8HYU9m0rTviBFtw4jw1yX483gCImpGCi
         XHWnPYNVVFaRtwDBQBJ+ooc9BUzItpqrRc8cRXKDwd7UYcPgL9U8iXS3MsLAONB0rcis
         q996qDXdHnezNRqSrQ54ijMKGaEcuOw1GCEdhsIhU3tqkDdykzYklm0tTZ6ceukV5XIt
         HmOsrpvzSiH8zipIHXXbyD9L+osFeavYspWQQRH2tHlPGHRIna3X5zNFeKPLJcer+3I6
         F4pQ==
X-Gm-Message-State: AOAM530v49SpaC/yf6e9NNGqj+B2b91jJIQc48I4CMol42PxaH6NTala
        jo98rOrMdOPex5YpJH+UcyZR7PT426SGyUjppSRxG/TJhglMvFUfsp0ToFjlYTT5H1AjuGI41s3
        /EC9AaMTmpiAc
X-Received: by 2002:a05:6602:1501:b0:65a:c412:2eeb with SMTP id g1-20020a056602150100b0065ac4122eebmr8476309iow.29.1652733133051;
        Mon, 16 May 2022 13:32:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCSKO5RNVRac0u7E68dQWhYK6bXC+rNUb7l6B7l+JZr5Uy7KT7kK7rTSjXP4J8hkCCkmWesQ==
X-Received: by 2002:a05:6602:1501:b0:65a:c412:2eeb with SMTP id g1-20020a056602150100b0065ac4122eebmr8476301iow.29.1652733132775;
        Mon, 16 May 2022 13:32:12 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id p130-20020a022988000000b0032b3a781747sm3079329jap.11.2022.05.16.13.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:32:12 -0700 (PDT)
Date:   Mon, 16 May 2022 16:32:10 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/9] KVM: selftests: Add option to create 2M and 1G EPT
 mappings
Message-ID: <YoK0yptPVNqOSlD6@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-3-dmatlack@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:28PM +0000, David Matlack wrote:
> The current EPT mapping code in the selftests only supports mapping 4K
> pages. This commit extends that support with an option to map at 2M or
> 1G. This will be used in a future commit to create large page mappings
> to test eager page splitting.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c | 105 ++++++++++---------
>  1 file changed, 57 insertions(+), 48 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index d089d8b850b5..1fa2d1059ade 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -392,27 +392,60 @@ void nested_vmx_check_supported(void)
>  	}
>  }
>  
> -void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> -		   uint64_t nested_paddr, uint64_t paddr)
> +static void nested_create_upper_pte(struct kvm_vm *vm,
> +				    struct eptPageTableEntry *pte,
> +				    uint64_t nested_paddr,
> +				    uint64_t paddr,
> +				    int current_level,
> +				    int target_level)
> +{
> +	if (!pte->readable) {
> +		pte->writable = true;
> +		pte->readable = true;
> +		pte->executable = true;
> +		pte->page_size = (current_level == target_level);
> +		if (pte->page_size)
> +			pte->address = paddr >> vm->page_shift;
> +		else
> +			pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
> +	} else {
> +		/*
> +		 * Entry already present.  Assert that the caller doesn't want
> +		 * a hugepage at this level, and that there isn't a hugepage at
> +		 * this level.
> +		 */
> +		TEST_ASSERT(current_level != target_level,
> +			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx\n",
> +			    current_level, nested_paddr);
> +		TEST_ASSERT(!pte->page_size,
> +			    "Cannot create page table at level: %u, nested_paddr: 0x%lx\n",
> +			    current_level, nested_paddr);
> +	}
> +}
> +
> +
> +void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> +		     uint64_t nested_paddr, uint64_t paddr, int target_level)
>  {
> +	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
> +	struct eptPageTableEntry *pt;
>  	uint16_t index[4];
> -	struct eptPageTableEntry *pml4e;
>  
>  	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
>  		    "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
>  
> -	TEST_ASSERT((nested_paddr % vm->page_size) == 0,
> +	TEST_ASSERT((nested_paddr % page_size) == 0,
>  		    "Nested physical address not on page boundary,\n"
> -		    "  nested_paddr: 0x%lx vm->page_size: 0x%x",
> -		    nested_paddr, vm->page_size);
> +		    "  nested_paddr: 0x%lx page_size: 0x%lx",
> +		    nested_paddr, page_size);
>  	TEST_ASSERT((nested_paddr >> vm->page_shift) <= vm->max_gfn,
>  		    "Physical address beyond beyond maximum supported,\n"
>  		    "  nested_paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
>  		    paddr, vm->max_gfn, vm->page_size);
> -	TEST_ASSERT((paddr % vm->page_size) == 0,
> +	TEST_ASSERT((paddr % page_size) == 0,
>  		    "Physical address not on page boundary,\n"
> -		    "  paddr: 0x%lx vm->page_size: 0x%x",
> -		    paddr, vm->page_size);
> +		    "  paddr: 0x%lx page_size: 0x%lx",
> +		    paddr, page_size);
>  	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
>  		    "Physical address beyond beyond maximum supported,\n"
>  		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
> @@ -423,49 +456,25 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
>  	index[2] = (nested_paddr >> 30) & 0x1ffu;
>  	index[3] = (nested_paddr >> 39) & 0x1ffu;
>  
> -	/* Allocate page directory pointer table if not present. */
> -	pml4e = vmx->eptp_hva;
> -	if (!pml4e[index[3]].readable) {
> -		pml4e[index[3]].address = vm_alloc_page_table(vm) >> vm->page_shift;
> -		pml4e[index[3]].writable = true;
> -		pml4e[index[3]].readable = true;
> -		pml4e[index[3]].executable = true;
> -	}
> +	pt = vmx->eptp_hva;
>  
> -	/* Allocate page directory table if not present. */
> -	struct eptPageTableEntry *pdpe;
> -	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
> -	if (!pdpe[index[2]].readable) {
> -		pdpe[index[2]].address = vm_alloc_page_table(vm) >> vm->page_shift;
> -		pdpe[index[2]].writable = true;
> -		pdpe[index[2]].readable = true;
> -		pdpe[index[2]].executable = true;
> -	}
> +	for (int current_level = 3; current_level >= 0; current_level--) {
> +		struct eptPageTableEntry *pte = &pt[index[current_level]];
>  
> -	/* Allocate page table if not present. */
> -	struct eptPageTableEntry *pde;
> -	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
> -	if (!pde[index[1]].readable) {
> -		pde[index[1]].address = vm_alloc_page_table(vm) >> vm->page_shift;
> -		pde[index[1]].writable = true;
> -		pde[index[1]].readable = true;
> -		pde[index[1]].executable = true;
> -	}
> +		nested_create_upper_pte(vm, pte, nested_paddr, paddr,
> +					current_level, target_level);

This is going to run for the last level pte too, so maybe remove the
"upper" prefix in the helper?

>  
> -	/* Fill in page table entry. */
> -	struct eptPageTableEntry *pte;
> -	pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
> -	pte[index[0]].address = paddr >> vm->page_shift;
> -	pte[index[0]].writable = true;
> -	pte[index[0]].readable = true;
> -	pte[index[0]].executable = true;
> +		if (pte->page_size)
> +			break;
>  
> -	/*
> -	 * For now mark these as accessed and dirty because the only
> -	 * testcase we have needs that.  Can be reconsidered later.
> -	 */
> -	pte[index[0]].accessed = true;
> -	pte[index[0]].dirty = true;

Is it intended to to drop the access/dirty bits here?

> +		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
> +	}
> +}
> +
> +void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> +		   uint64_t nested_paddr, uint64_t paddr)
> +{
> +	__nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
>  }
>  
>  /*
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 

-- 
Peter Xu

