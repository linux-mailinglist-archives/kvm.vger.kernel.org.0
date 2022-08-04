Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B3C589B17
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 13:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbiHDLca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 07:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiHDLc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 07:32:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F6133E22;
        Thu,  4 Aug 2022 04:32:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DF28120F76;
        Thu,  4 Aug 2022 11:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659612745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HCl/OjddVeNtZUVMWyBB9z3YoC/s9vWuMMjCgHDOT+4=;
        b=oZV8hjCSBWL4mpbrjQhzchhr/BtE6mgR7djPTS2OVBZ3iELB+6291X3SQjSPhCcnOYsgit
        C9nFloX33EHU5KVCxbYxZqdYUotwowNM5AhLkOqwqSRZe+c8iHpqwZD26gFFUdD+hasPyv
        +6dj1UqpiNEvMltlw+98T7FVa/Bwa0s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659612745;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HCl/OjddVeNtZUVMWyBB9z3YoC/s9vWuMMjCgHDOT+4=;
        b=wjXBWwQ3EPt/K5efSJFcWPg+8unFrMpTy/qJoflswDS31lNt8et/zTPGorAFRn1ls+bLD6
        1F3EVqIPC/yeJKAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 48AA413434;
        Thu,  4 Aug 2022 11:32:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LYvFEEmu62LGKQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 04 Aug 2022 11:32:25 +0000
Message-ID: <ee123648-3ac4-6e0c-419c-281fb09edaa6@suse.cz>
Date:   Thu, 4 Aug 2022 13:32:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH Part2 v6 21/49] KVM: SVM: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Content-Language: en-US
To:     Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <4896f0fd85947a139dce0ad514044c76048eaed2.1655761627.git.ashish.kalra@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <4896f0fd85947a139dce0ad514044c76048eaed2.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/22 01:06, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.
> 
> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> backing   pages as "in-use" in the RMP after a successful VMRUN.  This
> is done for _all_ VMs, not just SNP-Active VMs.
> 
> If the hypervisor accesses an in-use page through a writable
> translation, the CPU will throw an RMP violation #PF. On early SNP
> hardware, if an in-use page is 2mb aligned and software accesses any
> part of the associated 2mb region with a hupage, the CPU will
> incorrectly treat the entire 2mb region as in-use and signal a spurious
> RMP violation #PF.
> 
> The recommended is to not use the hugepage for the VMCB, VMSA or
> AVIC backing page. Add a generic allocator that will ensure that the
> page returns is not hugepage (2mb or 1gb) and is safe to be used when
> SEV-SNP is enabled.
> 
> Co-developed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  2 ++
>  arch/x86/kvm/lapic.c               |  5 ++++-
>  arch/x86/kvm/svm/sev.c             | 35 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c             | 16 ++++++++++++--
>  arch/x86/kvm/svm/svm.h             |  1 +
>  6 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index da47f60a4650..a66292dae698 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -128,6 +128,7 @@ KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> +KVM_X86_OP(alloc_apic_backing_page)
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c24a72ddc93b..0205e2944067 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1512,6 +1512,8 @@ struct kvm_x86_ops {
>  	 * Returns vCPU specific APICv inhibit reasons
>  	 */
>  	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
> +
> +	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 66b0eb0bda94..7c7fc6c4a7f9 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2506,7 +2506,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  
>  	vcpu->arch.apic = apic;
>  
> -	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> +	if (kvm_x86_ops.alloc_apic_backing_page)
> +		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
> +	else
> +		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  	if (!apic->regs) {
>  		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
>  		       vcpu->vcpu_id);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b49c370d5ae9..93365996bd59 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3030,3 +3030,38 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  		break;
>  	}
>  }
> +
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long pfn;
> +	struct page *p;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +
> +	/*
> +	 * Allocate an SNP safe page to workaround the SNP erratum where
> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
> +	 * or AVIC backing page. The recommeded workaround is to not use the
> +	 * hugepage.
> +	 *
> +	 * Allocate one extra page, use a page which is not 2mb aligned
> +	 * and free the other.
> +	 */
> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> +	if (!p)
> +		return NULL;
> +
> +	split_page(p, 1);
> +
> +	pfn = page_to_pfn(p);
> +	if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {

I think you could simply IS_ALIGNED(pfn, PTRS_PER_PMD), no need to expand to
full phys.

> +		pfn++;
> +		__free_page(p);

To avoid pfn_to_page(), drop 'pfn++' and

__free_page(p++);

> +	} else {
> +		__free_page(pfn_to_page(pfn + 1));

__free_page(p+1);

> +	}
> +
> +	return pfn_to_page(pfn);

return p;

> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index efc7623d0f90..b4bd64f94d3a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1260,7 +1260,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  	svm = to_svm(vcpu);
>  
>  	err = -ENOMEM;
> -	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	vmcb01_page = snp_safe_alloc_page(vcpu);
>  	if (!vmcb01_page)
>  		goto out;
>  
> @@ -1269,7 +1269,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  		 * SEV-ES guests require a separate VMSA page used to contain
>  		 * the encrypted register state of the guest.
>  		 */
> -		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +		vmsa_page = snp_safe_alloc_page(vcpu);
>  		if (!vmsa_page)
>  			goto error_free_vmcb_page;
>  
> @@ -4598,6 +4598,16 @@ static int svm_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
> +{
> +	struct page *page = snp_safe_alloc_page(vcpu);
> +
> +	if (!page)
> +		return NULL;
> +
> +	return page_address(page);
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.name = "kvm_amd",
>  
> @@ -4722,6 +4732,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  
>  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>  	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
> +
> +	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
>  };
>  
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 1f4a8bd09c9e..9672e25a338d 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -659,6 +659,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>  
>  /* vmenter.S */
>  

