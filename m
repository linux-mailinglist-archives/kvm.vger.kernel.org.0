Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB553668D5
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 12:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237947AbhDUKH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 06:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhDUKH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 06:07:57 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46833C06174A;
        Wed, 21 Apr 2021 03:07:24 -0700 (PDT)
Received: from zn.tnic (p2e584d0d.dip0.t-ipconnect.de [46.88.77.13])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8F3561EC02FE;
        Wed, 21 Apr 2021 12:07:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618999642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nlWh21zVm9wXf6lmbj/qjCQYJOgoa0PKTSSc0HqTslI=;
        b=RqA3aml/cZyDqGPFABn1m49TskGG/uQch5cv2gIPodJ1q6Oe11Ya1UlEgcRfSN6PPxBMIv
        Lh7vqD8Nv1Ob86DJfprMlP+1lUV71AuK3nRak1ULGlKkLOiKWxgXXNLHPRejfP4kvnmtGf
        VsQX22r0FmYNFDWEmyswoa4q/MAE7Sc=
Date:   Wed, 21 Apr 2021 12:05:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v13 09/12] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210421100508.GA11234@zn.tnic>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 03:57:26PM +0000, Ashish Kalra wrote:
> +static inline void page_encryption_changed(unsigned long vaddr, int npages,
> +						bool enc)

When you see a function name "page_encryption_changed", what does that
tell you about what that function does?

Dunno but it doesn't tell me a whole lot.

Now look at the other function names in struct pv_mmu_ops.

See the difference?

> +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,

If I had to guess what that function does just by reading its name, it
sets a memory encryption/decryption hypercall.

Am I close?

> +					bool enc)
> +{
> +	unsigned long sz = npages << PAGE_SHIFT;
> +	unsigned long vaddr_end, vaddr_next;
> +
> +	vaddr_end = vaddr + sz;
> +
> +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> +		int psize, pmask, level;
> +		unsigned long pfn;
> +		pte_t *kpte;
> +
> +		kpte = lookup_address(vaddr, &level);
> +		if (!kpte || pte_none(*kpte))
> +			return;
> +
> +		switch (level) {
> +		case PG_LEVEL_4K:
> +			pfn = pte_pfn(*kpte);
> +			break;
> +		case PG_LEVEL_2M:
> +			pfn = pmd_pfn(*(pmd_t *)kpte);
> +			break;
> +		case PG_LEVEL_1G:
> +			pfn = pud_pfn(*(pud_t *)kpte);
> +			break;
> +		default:
> +			return;
> +		}

Pretty much that same thing is in __set_clr_pte_enc(). Make a helper
function pls.

> +
> +		psize = page_level_size(level);
> +		pmask = page_level_mask(level);
> +
> +		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
> +
> +		vaddr_next = (vaddr & pmask) + psize;
> +	}

As with other patches from Brijesh, that should be a while loop. :)

> +}
> +
>  static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  {
>  	pgprot_t old_prot, new_prot;
> @@ -286,12 +329,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  static int __init early_set_memory_enc_dec(unsigned long vaddr,
>  					   unsigned long size, bool enc)
>  {
> -	unsigned long vaddr_end, vaddr_next;
> +	unsigned long vaddr_end, vaddr_next, start;
>  	unsigned long psize, pmask;
>  	int split_page_size_mask;
>  	int level, ret;
>  	pte_t *kpte;
>  
> +	start = vaddr;
>  	vaddr_next = vaddr;
>  	vaddr_end = vaddr + size;
>  
> @@ -346,6 +390,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
>  
>  	ret = 0;
>  
> +	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
> +					enc);
>  out:
>  	__flush_tlb_all();
>  	return ret;
> @@ -481,6 +527,15 @@ void __init mem_encrypt_init(void)
>  	if (sev_active() && !sev_es_active())
>  		static_branch_enable(&sev_enable_key);
>  
> +#ifdef CONFIG_PARAVIRT
> +	/*
> +	 * With SEV, we need to make a hypercall when page encryption state is
> +	 * changed.
> +	 */
> +	if (sev_active())
> +		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
> +#endif

There's already a sev_active() check above it. Merge the two pls.

> +
>  	print_mem_encrypt_feature_info();
>  }
>  
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 16f878c26667..3576b583ac65 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -27,6 +27,7 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/paravirt.h>
>  
>  #include "../mm_internal.h"
>  
> @@ -2012,6 +2013,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>  	 */
>  	cpa_flush(&cpa, 0);
>  
> +	/* Notify hypervisor that a given memory range is mapped encrypted
> +	 * or decrypted. The hypervisor will use this information during the
> +	 * VM migration.
> +	 */

Kernel comments style is:

	/*
	 * A sentence ending with a full-stop.
	 * Another sentence. ...
	 * More sentences. ...
	 */

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
