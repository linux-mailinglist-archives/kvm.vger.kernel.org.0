Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9BE6B5183
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 21:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjCJUM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 15:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjCJUMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 15:12:49 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826E312B95F
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 12:12:48 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id t11-20020a170902e84b00b0019e399b2efaso3384459plg.11
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 12:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678479168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YRnz4Sg+G65MFb46p+8OMyQr8tQeIQ0btbrTuxLx320=;
        b=eAWdv4TBjGk6uuaSoapD3D0eZM5LOAvPe+wLJVHdep6ue7Oxbwfwxmyvv3MKDY48jq
         12eCtyS1WbbYLL12eYsgKfdBmvbOfW7F2jf++kadg693NrYQYYK4efhdDYMZYzMvvR5v
         NguN+iRc1HJktkOGTqlTCmxc2zYQXUNnCMd+sm+Ed2nsneQ0h8itwEc1pGjYNzbrCBBg
         3OTJWG3lPQ++fK7IG8640cuBtpJRIxEkO7ItJvx2wxvqrJxvsjGFINJDvtUBNnldI55e
         TfLlUWEOmGPeKc+AcHEAdViS/7digDYAAdxzTHbDoz/lY3CoObzhtcfpmcbS8a7ngZcl
         ZSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678479168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YRnz4Sg+G65MFb46p+8OMyQr8tQeIQ0btbrTuxLx320=;
        b=XdrBPZJqoFSAVNT4L4zoYyqzIIZ+Wz4TWTnp3qsYDlLzHHtmwOyehHpqyRRSJGsLJG
         4P/CSJQH75y8Qzvqgu+m5S5qwU478R930bfY4hzKS/JQUOsS+BAjGR2vcGW8PmdPOsFb
         8nb1CH6X2hpNw75h65O41/L//BiHuWq3qn1znrtmIQGwg1PcrXCAxe9D/4S8xXU3guYo
         fWqocEy6dja6ASGqCSdRLtMlWzveoy29cwhlDqfA8k/k76i5kiEWOHfwU+IqFTI6HaDq
         qX1whhklaZiRgwQGIZPWPL7Gk52d3cW9XYrbzHiWLKKeB6ikOaggrnIxWaeFVij3ZKK8
         dP2g==
X-Gm-Message-State: AO0yUKUivxMSYCvc+OOMYzSVDHd2kOWLyXPdkTykQtW/xq+y0cD9R0Q2
        AXyGv9a2URRYn/bTfP0hGvU/hmCQgaA=
X-Google-Smtp-Source: AK7set+Rk46AbTSRa1WsaISpnMWQG4qTeqJDk0ECr0zQLcDqrNtKiWu5vc4QoeIg9M9vxvKFef5gqze/Crs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:291e:0:b0:503:77ce:a1ab with SMTP id
 bt30-20020a63291e000000b0050377cea1abmr9377554pgb.9.1678479168029; Fri, 10
 Mar 2023 12:12:48 -0800 (PST)
Date:   Fri, 10 Mar 2023 12:12:46 -0800
In-Reply-To: <20230227084547.404871-4-robert.hu@linux.intel.com>
Mime-Version: 1.0
References: <20230227084547.404871-1-robert.hu@linux.intel.com> <20230227084547.404871-4-robert.hu@linux.intel.com>
Message-ID: <ZAuPPv8PUDX2RBQa@google.com>
Subject: Re: [PATCH v5 3/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, chao.gao@intel.com, binbin.wu@linux.intel.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023, Robert Hoo wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 835426254e76..3efec7f8d8c6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3699,7 +3699,14 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	int quadrant, i, r;
>  	hpa_t root;
>  
> -	root_pgd = mmu->get_guest_pgd(vcpu);
> +	/*
> +	 * Omit guest_cpuid_has(X86_FEATURE_LAM) check but can unconditionally
> +	 * strip CR3 LAM bits because they resides in high reserved bits,
> +	 * with LAM or not, those high bits should be striped anyway when
> +	 * interpreted to pgd.
> +	 */

This misses the most important part: why it's safe to ignore LAM bits when reusing
a root.

> +	root_pgd = mmu->get_guest_pgd(vcpu) &
> +		   ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);

Unconditionally clearing LAM bits is unsafe.  At some point the EPTP may define
bits in the same area that must NOT be omitted from the root cache, e.g. the PWL
bits in the EPTP _need_ to be incorporated into is_root_usable().

For simplicity, I'm very, very tempted to say we should just leave the LAM bits
in root.pgd, i.e. force a new root for a CR3+LAM combination.  First and foremost,
that only matters for shadow paging.  Second, unless a guest kernel allows per-thread
LAM settings, KVM the extra checks will be benign.  And AIUI, the proposed kernel
implementation is to apply LAM on a per-MM basis.

And I would much prefer to solve the GFN calculation generically.  E.g. it really
should be something like this

	root_pgd = mmu->get_guest_pgd(vcpu);
	root_gfn = mmu->gpte_to_gfn(root_pgd);

but having to set gpte_to_gfn() in the MMU is quite unfortunate, and gpte_to_gfn()
is technically insufficient for PAE since it relies on previous checks to prevent
consuming a 64-bit CR3.

I was going to suggest extracting the maximal base addr mask and use that, e.g.

	#define __PT_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))

Maybe this?

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8ebe542c565..8b2d2a6081b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3732,7 +3732,12 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
        hpa_t root;
 
        root_pgd = mmu->get_guest_pgd(vcpu);
-       root_gfn = root_pgd >> PAGE_SHIFT;
+
+       /*
+        * The guest PGD has already been checked for validity, unconditionally
+        * strip non-address bits when computing the GFN.
+        */
+       root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
        if (mmu_check_root(vcpu, root_gfn))
                return 1;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index cc58631e2336..c0479cbc2ca3 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -21,6 +21,7 @@ extern bool dbg;
 #endif
 
 /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
+#define __PT_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #define __PT_LEVEL_SHIFT(level, bits_per_level)        \
        (PAGE_SHIFT + ((level) - 1) * (bits_per_level))
 #define __PT_INDEX(address, level, bits_per_level) \
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 57f0b75c80f9..0583bfce3b52 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -62,7 +62,7 @@
 #endif
 
 /* Common logic, but per-type values.  These also need to be undefined. */
-#define PT_BASE_ADDR_MASK      ((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
+#define PT_BASE_ADDR_MASK      ((pt_element_t)__PT_BASE_ADDR_MASK)
 #define PT_LVL_ADDR_MASK(lvl)  __PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_LVL_OFFSET_MASK(lvl)        __PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_INDEX(addr, lvl)    __PT_INDEX(addr, lvl, PT_LEVEL_BITS)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1279db2eab44..777f7d443e3b 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -36,7 +36,7 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
 #define SPTE_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
 #else
-#define SPTE_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#define SPTE_BASE_ADDR_MASK __PT_BASE_ADDR_MASK
 #endif
 
 #define SPTE_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \

>  	root_gfn = root_pgd >> PAGE_SHIFT;
>  
>  	if (mmu_check_root(vcpu, root_gfn))
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0f6455072055..57f39c7492ed 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -324,7 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	trace_kvm_mmu_pagetable_walk(addr, access);
>  retry_walk:
>  	walker->level = mmu->cpu_role.base.level;
> -	pte           = mmu->get_guest_pgd(vcpu);
> +	pte           = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);

This should be unnecessary, gpte_to_gfn() is supposed to strip non-address bits.

>  	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>  
>  #ifdef CONFIG_X86_64
>  	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>  
> @@ -1254,14 +1265,26 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
>  	 * the current vCPU mode is accurate.
>  	 */
> -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
> +	if (!kvm_vcpu_is_valid_cr3(vcpu, cr3))
>  		return 1;
>  
>  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>  		return 1;
>  
> -	if (cr3 != kvm_read_cr3(vcpu))
> -		kvm_mmu_new_pgd(vcpu, cr3);
> +	old_cr3 = kvm_read_cr3(vcpu);
> +	if (cr3 != old_cr3) {
> +		if ((cr3 ^ old_cr3) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57)) {
> +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
> +					X86_CR3_LAM_U57));

As above, no change is needed here if LAM is tracked in the PGD.
