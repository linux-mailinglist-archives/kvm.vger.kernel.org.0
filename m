Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B07508C61
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380185AbiDTPuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354734AbiDTPuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:50:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAC820F7D
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 08:47:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c12so2132229plr.6
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 08:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cqlJftLH7LHu8dCSErsdrnwCHb1OWQ+El5mNGRz6CTM=;
        b=W0Qzt+Ms8vroIUw71xYpAS+6OEn3MUJEOz6v8iktT067NsTQXfff+TDX3hwl8sNUK4
         FI9Kelf5oNKVRcSKP2KGDfWGWB33AvEB4xyp54L2ziPXzTTzH7O38P93IaNpjyYISC2x
         lrspa+IGFFjOTu+lHwI0rk0F1StDPmwlQfg0OfJE7FEzsy9yJAqj/yUBOeyqeZnGxswX
         x6sVEKpuMpHpAY7INbq/1vP//9SKrhAKI1vBqpO9kic469zTJoR274FDLKiGilFJh6CS
         B603k99CmO2bi+2w1GeTnKhln9msdGJKA1qRW6YWzJyVDiRdQ3Zv7ybEkOyoq/6nU5KK
         Ej+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cqlJftLH7LHu8dCSErsdrnwCHb1OWQ+El5mNGRz6CTM=;
        b=f5tiItYEEcRe3A//IQYwrfSwqrd0Y6cc10lpKOrLcvWWYn34o6+SSBt9ho2yC15ttB
         AiTYC0YguWRl51dKmYxBNPh9nl0yttCpi5hk9tRcgviuAkgoBax7o3h6qbZPxGt8LzeS
         rrXTNJW077kM9bbTfjj7ouuajtr101rH2Dibp2MSr66XJ38m2rlwSuzFY5ftmtyqrpYe
         Jf5DInNbeTPihrJsLT/ZeNHjGldjCN9qVWC6ljHIC15VbVzLHDLGs/BZq1yZSLUtYl67
         QjGSg+aM2vjnZe1Ps6wTT96Bj9rejmAP0RnF4eF0VjrpgSIdNQ0NWqtwSUSimgWcr1Bu
         0Osw==
X-Gm-Message-State: AOAM532xABmXnOStSjzrUOUY/hANffLtwGHlcUJ8CU7O/mhnMOAshgaG
        zvQOYSXrCJvp/3a5ftseOfRvQes3IN+uLQ==
X-Google-Smtp-Source: ABdhPJwo8kbb/lVSaTjgR1gKI8cyICpyngATTNb6AxQoNPCrkFq2Ln7Mjzv4TKJZsooHBeCBIYiGCg==
X-Received: by 2002:a17:90a:ee81:b0:1cb:ade8:6c61 with SMTP id i1-20020a17090aee8100b001cbade86c61mr5179240pjz.167.1650469648947;
        Wed, 20 Apr 2022 08:47:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y21-20020a631815000000b0039fcedd7bedsm21104065pgl.41.2022.04.20.08.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:47:28 -0700 (PDT)
Date:   Wed, 20 Apr 2022 15:47:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH] kvm: selftests: do not use bitfields larger than 32-bits
 for PTEs
Message-ID: <YmArDFQXF1lA3z8K@google.com>
References: <20220420103624.1143824-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420103624.1143824-1-pbonzini@redhat.com>
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

On Wed, Apr 20, 2022, Paolo Bonzini wrote:
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 202 ++++++++----------
>  1 file changed, 89 insertions(+), 113 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 9f000dfb5594..90c3d34ce80b 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -20,36 +20,18 @@
>  vm_vaddr_t exception_handlers;
>  
>  /* Virtual translation table structure declarations */

Stale comment.

> -struct pageUpperEntry {
> -	uint64_t present:1;
> -	uint64_t writable:1;
> -	uint64_t user:1;
> -	uint64_t write_through:1;
> -	uint64_t cache_disable:1;
> -	uint64_t accessed:1;
> -	uint64_t ignored_06:1;
> -	uint64_t page_size:1;
> -	uint64_t ignored_11_08:4;
> -	uint64_t pfn:40;
> -	uint64_t ignored_62_52:11;
> -	uint64_t execute_disable:1;
> -};
> -
> -struct pageTableEntry {
> -	uint64_t present:1;
> -	uint64_t writable:1;
> -	uint64_t user:1;
> -	uint64_t write_through:1;
> -	uint64_t cache_disable:1;
> -	uint64_t accessed:1;
> -	uint64_t dirty:1;
> -	uint64_t reserved_07:1;
> -	uint64_t global:1;
> -	uint64_t ignored_11_09:3;
> -	uint64_t pfn:40;
> -	uint64_t ignored_62_52:11;
> -	uint64_t execute_disable:1;
> -};
> +#define PTE_PRESENT_MASK  (1ULL << 0)
> +#define PTE_WRITABLE_MASK (1ULL << 1)
> +#define PTE_USER_MASK     (1ULL << 2)
> +#define PTE_ACCESSED_MASK (1ULL << 5)
> +#define PTE_DIRTY_MASK    (1ULL << 6)
> +#define PTE_LARGE_MASK    (1ULL << 7)
> +#define PTE_GLOBAL_MASK   (1ULL << 8)
> +#define PTE_NX_MASK       (1ULL << 63)

Any objection to using BIT_ULL()?  And tab(s) after the MASK so that there's some
breathing room in the unlikely scenario we need a new, longer flag?

> +#define PTE_PFN_MASK      0xFFFFFFFFFF000ULL

GENMASK_ULL(52, 12), or maybe use the PAGE_SHIFT in the generation, though I find
that more difficult to read for whatever reason.

> +#define PTE_PFN_SHIFT     12

Can we use the kernel's nomenclature?  That way if selftests ever find a way to
pull in arch/x86/include/asm/page_types.h, we don't need to do a bunch of renames.
And IMO it will make it easier to context switch between KVM and selftests.


#define PTE_PRESENT_MASK	BIT_ULL(0)
#define PTE_WRITABLE_MASK	BIT_ULL(1)
#define PTE_USER_MASK		BIT_ULL(2)
#define PTE_ACCESSED_MASK	BIT_ULL(5)
#define PTE_DIRTY_MASK		BIT_ULL(6)
#define PTE_LARGE_MASK		BIT_ULL(7)
#define PTE_GLOBAL_MASK		BIT_ULL(8)
#define PTE_NX_MASK		BIT_ULL(63)

#define PAGE_SHIFT		12
#define PAGE_SIZE		(1ULL << PAGE_SHIFT)
#define PHYSICAL_PAGE_MASK	GENMASK_ULL(51, 12)

#define PTE_GET_PFN(pte) (((pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)


I'd also vote to move these (in a different patch) to processor.h so that selftests
can use PAGE_SIZE in particular.

  tools/testing/selftests/kvm/x86_64 $ git grep -E "define\s+PAGE_SIZE" | wc -l
  6

And _vm_get_page_table_entry() has several gross open-coded masks/shifts that can
be opportunistically converted now

@@ -269,8 +270,7 @@ static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
        struct kvm_cpuid_entry2 *entry;
        struct kvm_sregs sregs;
        int max_phy_addr;
-       /* Set the bottom 52 bits. */
-       uint64_t rsvd_mask = 0x000fffffffffffff;
+       uint64_t rsvd_mask = PHYSICAL_PAGE_MASK;
 
        entry = kvm_get_supported_cpuid_index(0x80000008, 0);
        max_phy_addr = entry->eax & 0x000000ff;
@@ -284,9 +284,8 @@ static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
         * the XD flag (bit 63) is reserved.
         */
        vcpu_sregs_get(vm, vcpuid, &sregs);
-       if ((sregs.efer & EFER_NX) == 0) {
-               rsvd_mask |= (1ull << 63);
-       }
+       if (!(sregs.efer & EFER_NX))
+               rsvd_mask |= PTE_NX_MASK;
 


and even more that can/should be cleaned up in the future, e.g. this pile, though
that can be left for a different day.

	/*
	 * Based on the mode check above there are 48 bits in the vaddr, so
	 * shift 16 to sign extend the last bit (bit-47),
	 */
	TEST_ASSERT(vaddr == (((int64_t)vaddr << 16) >> 16),
		"Canonical check failed.  The virtual address is invalid.");

	index[0] = (vaddr >> 12) & 0x1ffu;
	index[1] = (vaddr >> 21) & 0x1ffu;
	index[2] = (vaddr >> 30) & 0x1ffu;
	index[3] = (vaddr >> 39) & 0x1ffu;
  
> -	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> +	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & 0xfffu);

Yeesh, and yet more cleanup.  Probably worth adding

#define PAGE_MASK		(~(PAGE_SIZE-1))

and using ~PAGE_MASK here?  Or defining PAGE_OFFSET?  Though that would conflict
with the kernel's use of PAGE_OFFSET.
