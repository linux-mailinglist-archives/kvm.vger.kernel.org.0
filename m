Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633CF41503C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 20:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbhIVS5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 14:57:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237022AbhIVS5M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 14:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632336942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5cjz37tnSj3P18g8I99+DqVwuBzNML5WhZ/C6tpw5rE=;
        b=fpT0XLePJx8SCMMtf3To7WZ0du9JvyHcl2J5e09ZYKvcukQTXATikmKzH7RpABA45AATOx
        JVhMQg0Ww/pOHcbLJ/e0JPzuf/hNn8apL/Xq+wrdNj1BVUWjvkbAwvkFcHlYyk3lVAvJUb
        Gsk3Q8MXTPPUI+Lr5024uU2LgxCtwK4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-JsaSM8ISMvuj3ckezsluZQ-1; Wed, 22 Sep 2021 14:55:41 -0400
X-MC-Unique: JsaSM8ISMvuj3ckezsluZQ-1
Received: by mail-wr1-f70.google.com with SMTP id l9-20020adfc789000000b00160111fd4e8so3005319wrg.17
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 11:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5cjz37tnSj3P18g8I99+DqVwuBzNML5WhZ/C6tpw5rE=;
        b=JPzzpAwI/0VURbdLmIay74W6Lb+56xrR24czXUWSTUTW0hVU5JHu/AdLOItxUpetjp
         b/1Ff+wDvaBbSKYWvzI+AbCf1TFBh1tworif5wav+8WTo4ee1caUc25fsbobofZj1f40
         uf6c9LvSIGaiecaI3MKmyKslHNIxW//uCweou7rc/umpHMfFQyA7p45EKH6GiAfSRB6F
         emY+//h5V+j4vRfq1oXsCdews6OhbhyDjPk7dOcR5B5Oik2+Yu5VOt1hMmBgSkIJcGuN
         i4pixpEnDCpSuJPRCjjNm9hf350EjeQMIjOqCJ3J1wsPYl72Gltjt+NWP/FGIAPh7BA9
         BVSQ==
X-Gm-Message-State: AOAM533HulpIeQLEB7FSLsDmw23xIkMrB1qM2L84i87Larp7meCZBNX7
        a/K0xDwjcwpQqOeA4QZrmCelFhPIOVAPU4eP/Zfv/ZTfCTujlz8ZQxYWAXAaQ6avqAsDYFap8Vg
        wPCKBa2gJskqx
X-Received: by 2002:a05:600c:2109:: with SMTP id u9mr638734wml.6.1632336939853;
        Wed, 22 Sep 2021 11:55:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzx++mJlJo8Ud6dJxeU6+JTLQqLX2UZep4XZkQy1hlkTcc2qcI/o0h1c08tRRLAfmQXFgwqFA==
X-Received: by 2002:a05:600c:2109:: with SMTP id u9mr638703wml.6.1632336939658;
        Wed, 22 Sep 2021 11:55:39 -0700 (PDT)
Received: from work-vm (cpc109011-salf6-2-0-cust1562.10-2.cable.virginm.net. [82.29.118.27])
        by smtp.gmail.com with ESMTPSA id y6sm3004554wrp.46.2021.09.22.11.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 11:55:39 -0700 (PDT)
Date:   Wed, 22 Sep 2021 19:55:36 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and
 VMCB memory allocation SNP safe
Message-ID: <YUt8KOiwTwwa6xZK@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-22-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-22-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.
> 
> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> backing   pages as "in-use" in the RMP after a successful VMRUN.  This is
> done for _all_ VMs, not just SNP-Active VMs.

Can you explain what 'globally enabled' means?

Or more specifically, can we trip this bug on public hardware that has
the SNP enabled in the bios, but no SNP init in the host OS?

Dave

> If the hypervisor accesses an in-use page through a writable translation,
> the CPU will throw an RMP violation #PF.  On early SNP hardware, if an
> in-use page is 2mb aligned and software accesses any part of the associated
> 2mb region with a hupage, the CPU will incorrectly treat the entire 2mb
> region as in-use and signal a spurious RMP violation #PF.
> 
> The recommended is to not use the hugepage for the VMCB, VMSA or
> AVIC backing page. Add a generic allocator that will ensure that the page
> returns is not hugepage (2mb or 1gb) and is safe to be used when SEV-SNP
> is enabled.
> 
> Co-developed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/lapic.c               |  5 ++++-
>  arch/x86/kvm/svm/sev.c             | 35 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c             | 16 ++++++++++++--
>  arch/x86/kvm/svm/svm.h             |  1 +
>  6 files changed, 56 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index a12a4987154e..36a9c23a4b27 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -122,6 +122,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
>  KVM_X86_OP_NULL(migrate_timers)
>  KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP_NULL(complete_emulated_msr)
> +KVM_X86_OP(alloc_apic_backing_page)
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_NULL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..5ad6255ff5d5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1453,6 +1453,7 @@ struct kvm_x86_ops {
>  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>  
>  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> +	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ba5a27879f1d..05b45747b20b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2457,7 +2457,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
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
> index 1644da5fc93f..8771b878193f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2703,3 +2703,38 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
> +		pfn++;
> +		__free_page(p);
> +	} else {
> +		__free_page(pfn_to_page(pfn + 1));
> +	}
> +
> +	return pfn_to_page(pfn);
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 25773bf72158..058eea8353c9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1368,7 +1368,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	svm = to_svm(vcpu);
>  
>  	err = -ENOMEM;
> -	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	vmcb01_page = snp_safe_alloc_page(vcpu);
>  	if (!vmcb01_page)
>  		goto out;
>  
> @@ -1377,7 +1377,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  		 * SEV-ES guests require a separate VMSA page used to contain
>  		 * the encrypted register state of the guest.
>  		 */
> -		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +		vmsa_page = snp_safe_alloc_page(vcpu);
>  		if (!vmsa_page)
>  			goto error_free_vmcb_page;
>  
> @@ -4539,6 +4539,16 @@ static int svm_vm_init(struct kvm *kvm)
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
>  	.hardware_unsetup = svm_hardware_teardown,
>  	.hardware_enable = svm_hardware_enable,
> @@ -4667,6 +4677,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.complete_emulated_msr = svm_complete_emulated_msr,
>  
>  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> +
> +	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
>  };
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d1f1512a4b47..e40800e9c998 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -575,6 +575,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>  
>  /* vmenter.S */
>  
> -- 
> 2.17.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

