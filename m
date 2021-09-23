Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CDD416549
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 20:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242768AbhIWSk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 14:40:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242738AbhIWSk4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 14:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632422364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gl3rmZvVThFaeFfRLTdG0cOEV5CZHPaggzd6TpSp/rE=;
        b=HzCdjSePjVWXi95rElbAKKdw75cBDvBY70EQ4lHdhv4y5z/ZZmZfQdc7Ehb6Ua9QnCZXl/
        pjWTqtghPfuOGJvaa1Sw9aHWOaIlZAfHnxP5m3QNodcZ9Ld1Kwtd6lN65kENVu2+F9W9jN
        a+Z52j05swjxzms9dD1jOEqJk9N/yaY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-1pDHnykNNWG-JwZnvhqfHw-1; Thu, 23 Sep 2021 14:39:22 -0400
X-MC-Unique: 1pDHnykNNWG-JwZnvhqfHw-1
Received: by mail-wr1-f70.google.com with SMTP id r15-20020adfce8f000000b0015df1098ccbso5933291wrn.4
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 11:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=gl3rmZvVThFaeFfRLTdG0cOEV5CZHPaggzd6TpSp/rE=;
        b=6punBQwNRxcygZu8qr4HZgfK9693Pnz/0HVmAeC9jXS8YUXaCER0rqlfesDSRZCV4Z
         hrk9mA/ZUYa6eDTEuutaEdBqYdDupY3sR3m8m1TsDEmtxYN4QNXTI5NORthhITCGZTie
         SnrjLoR6Pqjb7ugHyk6dYd8rGj6yKOk5RG2d4a7oGC0N8vMheOOWsZZ16AWd7nLDFkyX
         6XfW8ypugl+dYc+3IptsrKW8aS3yQbBitywVz8pzn6fU7NLhYtO3DQcEqdgFx09VCsxx
         1jGLeVyvXku7Otsv9ZHA6+wyWVyKe8p8gRfm7paPy+3150J3VRhCLRXWHvcKDEzAVbvH
         K8zw==
X-Gm-Message-State: AOAM530bDxZFnEXT/1dKN+Ccx/VoY2BBdPrhPRr79GftC6WPrJR+TpCJ
        ZbSwIx2BwA+rD01rwwRrjCz5FjMTySBLnAwendir+elwSK0rXNYnuTAJ7NFsKybm3/+omFXiCnB
        42aXPVbhK5uZt
X-Received: by 2002:a1c:9851:: with SMTP id a78mr17376996wme.107.1632422361373;
        Thu, 23 Sep 2021 11:39:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIFESmjQrx6emyOVymLS1YeXQOOTBEsXjK57+Zczby+mJ8smnriGz36fqHD+SNd+0fKZevBw==
X-Received: by 2002:a1c:9851:: with SMTP id a78mr17376966wme.107.1632422361061;
        Thu, 23 Sep 2021 11:39:21 -0700 (PDT)
Received: from work-vm (cpc109011-salf6-2-0-cust1562.10-2.cable.virginm.net. [82.29.118.27])
        by smtp.gmail.com with ESMTPSA id x21sm9982202wmc.14.2021.09.23.11.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 11:39:20 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:39:17 +0100
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
Message-ID: <YUzJ1VHbSIrKYy0c@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-22-brijesh.singh@amd.com>
 <YUt8KOiwTwwa6xZK@work-vm>
 <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> 
> On 9/22/21 1:55 PM, Dr. David Alan Gilbert wrote:
> > * Brijesh Singh (brijesh.singh@amd.com) wrote:
> >> Implement a workaround for an SNP erratum where the CPU will incorrectly
> >> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> >> RMP entry of a VMCB, VMSA or AVIC backing page.
> >>
> >> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> >> backing   pages as "in-use" in the RMP after a successful VMRUN.  This is
> >> done for _all_ VMs, not just SNP-Active VMs.
> > Can you explain what 'globally enabled' means?
> 
> This means that SNP is enabled in  host SYSCFG_MSR.Snp=1. Once its
> enabled then RMP checks are enforced.
> 
> 
> > Or more specifically, can we trip this bug on public hardware that has
> > the SNP enabled in the bios, but no SNP init in the host OS?
> 
> Enabling the SNP support on host is 3 step process:
> 
> step1 (bios): reserve memory for the RMP table.
> 
> step2 (host): initialize the RMP table memory, set the SYSCFG msr to
> enable the SNP feature
> 
> step3 (host): call the SNP_INIT to initialize the SNP firmware (this is
> needed only if you ever plan to launch SNP guest from this host).
> 
> The "SNP globally enabled" means the step 1 to 2. The RMP checks are
> enforced as soon as step 2 is completed.

So I think that means we don't need to backport this to older kernels
that don't know about SNP but might run on SNP enabled hardware (1), since
those kernels won't do step2.

Dave

> thanks
> 
> >
> > Dave
> >
> >> If the hypervisor accesses an in-use page through a writable translation,
> >> the CPU will throw an RMP violation #PF.  On early SNP hardware, if an
> >> in-use page is 2mb aligned and software accesses any part of the associated
> >> 2mb region with a hupage, the CPU will incorrectly treat the entire 2mb
> >> region as in-use and signal a spurious RMP violation #PF.
> >>
> >> The recommended is to not use the hugepage for the VMCB, VMSA or
> >> AVIC backing page. Add a generic allocator that will ensure that the page
> >> returns is not hugepage (2mb or 1gb) and is safe to be used when SEV-SNP
> >> is enabled.
> >>
> >> Co-developed-by: Marc Orr <marcorr@google.com>
> >> Signed-off-by: Marc Orr <marcorr@google.com>
> >> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> >> ---
> >>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >>  arch/x86/include/asm/kvm_host.h    |  1 +
> >>  arch/x86/kvm/lapic.c               |  5 ++++-
> >>  arch/x86/kvm/svm/sev.c             | 35 ++++++++++++++++++++++++++++++
> >>  arch/x86/kvm/svm/svm.c             | 16 ++++++++++++--
> >>  arch/x86/kvm/svm/svm.h             |  1 +
> >>  6 files changed, 56 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> >> index a12a4987154e..36a9c23a4b27 100644
> >> --- a/arch/x86/include/asm/kvm-x86-ops.h
> >> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> >> @@ -122,6 +122,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
> >>  KVM_X86_OP_NULL(migrate_timers)
> >>  KVM_X86_OP(msr_filter_changed)
> >>  KVM_X86_OP_NULL(complete_emulated_msr)
> >> +KVM_X86_OP(alloc_apic_backing_page)
> >>  
> >>  #undef KVM_X86_OP
> >>  #undef KVM_X86_OP_NULL
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index 974cbfb1eefe..5ad6255ff5d5 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -1453,6 +1453,7 @@ struct kvm_x86_ops {
> >>  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> >>  
> >>  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> >> +	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
> >>  };
> >>  
> >>  struct kvm_x86_nested_ops {
> >> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> >> index ba5a27879f1d..05b45747b20b 100644
> >> --- a/arch/x86/kvm/lapic.c
> >> +++ b/arch/x86/kvm/lapic.c
> >> @@ -2457,7 +2457,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
> >>  
> >>  	vcpu->arch.apic = apic;
> >>  
> >> -	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> >> +	if (kvm_x86_ops.alloc_apic_backing_page)
> >> +		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
> >> +	else
> >> +		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> >>  	if (!apic->regs) {
> >>  		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
> >>  		       vcpu->vcpu_id);
> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >> index 1644da5fc93f..8771b878193f 100644
> >> --- a/arch/x86/kvm/svm/sev.c
> >> +++ b/arch/x86/kvm/svm/sev.c
> >> @@ -2703,3 +2703,38 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> >>  		break;
> >>  	}
> >>  }
> >> +
> >> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> >> +{
> >> +	unsigned long pfn;
> >> +	struct page *p;
> >> +
> >> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> >> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >> +
> >> +	/*
> >> +	 * Allocate an SNP safe page to workaround the SNP erratum where
> >> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
> >> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
> >> +	 * or AVIC backing page. The recommeded workaround is to not use the
> >> +	 * hugepage.
> >> +	 *
> >> +	 * Allocate one extra page, use a page which is not 2mb aligned
> >> +	 * and free the other.
> >> +	 */
> >> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> >> +	if (!p)
> >> +		return NULL;
> >> +
> >> +	split_page(p, 1);
> >> +
> >> +	pfn = page_to_pfn(p);
> >> +	if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {
> >> +		pfn++;
> >> +		__free_page(p);
> >> +	} else {
> >> +		__free_page(pfn_to_page(pfn + 1));
> >> +	}
> >> +
> >> +	return pfn_to_page(pfn);
> >> +}
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index 25773bf72158..058eea8353c9 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -1368,7 +1368,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >>  	svm = to_svm(vcpu);
> >>  
> >>  	err = -ENOMEM;
> >> -	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >> +	vmcb01_page = snp_safe_alloc_page(vcpu);
> >>  	if (!vmcb01_page)
> >>  		goto out;
> >>  
> >> @@ -1377,7 +1377,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >>  		 * SEV-ES guests require a separate VMSA page used to contain
> >>  		 * the encrypted register state of the guest.
> >>  		 */
> >> -		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >> +		vmsa_page = snp_safe_alloc_page(vcpu);
> >>  		if (!vmsa_page)
> >>  			goto error_free_vmcb_page;
> >>  
> >> @@ -4539,6 +4539,16 @@ static int svm_vm_init(struct kvm *kvm)
> >>  	return 0;
> >>  }
> >>  
> >> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct page *page = snp_safe_alloc_page(vcpu);
> >> +
> >> +	if (!page)
> >> +		return NULL;
> >> +
> >> +	return page_address(page);
> >> +}
> >> +
> >>  static struct kvm_x86_ops svm_x86_ops __initdata = {
> >>  	.hardware_unsetup = svm_hardware_teardown,
> >>  	.hardware_enable = svm_hardware_enable,
> >> @@ -4667,6 +4677,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >>  	.complete_emulated_msr = svm_complete_emulated_msr,
> >>  
> >>  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> >> +
> >> +	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
> >>  };
> >>  
> >>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> >> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> >> index d1f1512a4b47..e40800e9c998 100644
> >> --- a/arch/x86/kvm/svm/svm.h
> >> +++ b/arch/x86/kvm/svm/svm.h
> >> @@ -575,6 +575,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
> >>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> >>  void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
> >>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> >> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
> >>  
> >>  /* vmenter.S */
> >>  
> >> -- 
> >> 2.17.1
> >>
> >>
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

