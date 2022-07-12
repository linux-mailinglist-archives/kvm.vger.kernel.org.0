Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA10B572148
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 18:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiGLQpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 12:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiGLQpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 12:45:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418201177;
        Tue, 12 Jul 2022 09:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E461EB81A8F;
        Tue, 12 Jul 2022 16:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB16C3411C;
        Tue, 12 Jul 2022 16:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657644297;
        bh=A9wVtPl9xSGq+0nbgHMGXdDdz52JColikvRDP/5TqlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XXX4SivkRl90RB6ZxgtEMS08z8/6YjIM5XA75D7z1E9vNByWl7rCmFp5eVcgVf4Nx
         UKBnlg6BV1w9O29ltCPFR/NAby6C/mX8oHYedjNesUTLy6VPIHNXon8JXxKtK5f4K6
         fMF9e6tqTy+L0n8cEbTXok+izu3bdKO1Om51m2mqyyW9SmenkxbH9hAqZlVKUp+apk
         0WrCii8LqESl3x32sCaiT5f46qfz9/do8S2tCCNH8u8rXj/hsvwZeQXEXkHgoFEFJD
         oJj3JRasbFoXgwJM+qQwvqtkD9a9AsjwNSdKwLrkjz1eTSBQZ/PqUs3GHDgpGo+j9T
         rah9KjVLyKZaQ==
Date:   Tue, 12 Jul 2022 19:44:54 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 29/49] KVM: X86: Keep the NPT and RMP page level
 in sync
Message-ID: <Ys2lBp03iuvuvTmG@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <ae4475bc740eb0b9d031a76412b0117339794139.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae4475bc740eb0b9d031a76412b0117339794139.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/X86/x86/

On Mon, Jun 20, 2022 at 11:08:57PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When running an SEV-SNP VM, the sPA used to index the RMP entry is
> obtained through the NPT translation (gva->gpa->spa). The NPT page
> level is checked against the page level programmed in the RMP entry.
> If the page level does not match, then it will cause a nested page
> fault with the RMP bit set to indicate the RMP violation.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/mmu/mmu.c             |  5 ++++
>  arch/x86/kvm/svm/sev.c             | 46 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c             |  1 +
>  arch/x86/kvm/svm/svm.h             |  1 +
>  6 files changed, 55 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index a66292dae698..e0068e702692 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -129,6 +129,7 @@ KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP(alloc_apic_backing_page)
> +KVM_X86_OP_OPTIONAL(rmp_page_level_adjust)
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0205e2944067..2748c69609e3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1514,6 +1514,7 @@ struct kvm_x86_ops {
>  	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>  
>  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
> +	void (*rmp_page_level_adjust)(struct kvm *kvm, kvm_pfn_t pfn, int *level);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c623019929a7..997318ecebd1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -43,6 +43,7 @@
>  #include <linux/hash.h>
>  #include <linux/kern_levels.h>
>  #include <linux/kthread.h>
> +#include <linux/sev.h>
>  
>  #include <asm/page.h>
>  #include <asm/memtype.h>
> @@ -2824,6 +2825,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (unlikely(!pte))
>  		return PG_LEVEL_4K;
>  
> +	/* Adjust the page level based on the SEV-SNP RMP page level. */
> +	if (kvm_x86_ops.rmp_page_level_adjust)
> +		static_call(kvm_x86_rmp_page_level_adjust)(kvm, pfn, &level);
> +
>  	return level;
>  }
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a5b90469683f..91d3d24e60d2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3597,3 +3597,49 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
>  
>  	return pfn_to_page(pfn);
>  }
> +
> +static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	int level;
> +
> +	while (end > start) {
> +		if (snp_lookup_rmpentry(start, &level) != 0)
> +			return false;
> +		start++;
> +	}
> +
> +	return true;
> +}
> +
> +void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level)

Would not do harm to document this, given that it is not a static
fuction.

> +{
> +	int rmp_level, assigned;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return;
> +
> +	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
> +	if (unlikely(assigned < 0))
> +		return;
> +
> +	if (!assigned) {
> +		/*
> +		 * If all the pages are shared then no need to keep the RMP
> +		 * and NPT in sync.
> +		 */
> +		pfn = pfn & ~(PTRS_PER_PMD - 1);
> +		if (is_pfn_range_shared(pfn, pfn + PTRS_PER_PMD))
> +			return;
> +	}
> +
> +	/*
> +	 * The hardware installs 2MB TLB entries to access to 1GB pages,
> +	 * therefore allow NPT to use 1GB pages when pfn was added as 2MB
> +	 * in the RMP table.
> +	 */
> +	if (rmp_level == PG_LEVEL_2M && (*level == PG_LEVEL_1G))
> +		return;
> +
> +	/* Adjust the level to keep the NPT and RMP in sync */
> +	*level = min_t(size_t, *level, rmp_level);
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b4bd64f94d3a..18e2cd4d9559 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4734,6 +4734,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>  
>  	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
> +	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
>  };
>  
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 71c011af098e..7782312a1cda 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -673,6 +673,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>  struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
> +void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level);
>  
>  /* vmenter.S */
>  
> -- 
> 2.25.1
> 


BR, Jarkko
