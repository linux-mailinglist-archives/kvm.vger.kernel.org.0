Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999AE42AE1D
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 22:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhJLUqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 16:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbhJLUqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 16:46:53 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5311EC061745
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 13:44:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id l6so326868plh.9
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 13:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8ViV5/pFsBw3tEZCSEbQNY/kwVRna/LjOJ8u3cbMomY=;
        b=IfAyv/ESGEJl3OXMAEkUu+1eEAYJA1DTprmw/n6iHXk1vORtYBH6NWmjsICnrglySW
         u7p6FjmJtFivP7gXm0vB/abB4I9+1WFQe5HLQ7V6ApO4BHTChuG7TZwTup3PbhpP8ORf
         s7pIkXdxhoHubE0p2y27bbwtAdXnhW7ucmiFnOoUJVSXDtwTQssYCtr0rcS6WZ0ZELOv
         nzEycl41/WtD5NbUjilm5cJSac15mm8pJixeptm3CRTrdN+dtG/LP7GPimIBGI0IfkHa
         y8ld4AZNzIcxoppNzAgiSpotsMxXw8q20/UigY5MJ624DjAJsU+N/ypOQ4SWeJaHz8u0
         pl/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8ViV5/pFsBw3tEZCSEbQNY/kwVRna/LjOJ8u3cbMomY=;
        b=5Dbb184UWD7rKhvXH9WlhCDaXQhzlncxfhgZZD7N66ncUKlBbuXCHMTySLN67Hpjcd
         azibVY5OVWiaVz30SG7xGX+BUo+cESU8i79g7isZZAKBz7zDOQOs5WOyK4879uiGOYjH
         nxj7fEf8OYqd8iEx/r8KlwViWtoJZnXhb6Vn3KaEKuLSB77Vhvdq2JLQ3hlAIKQNXT+E
         twqN/cj0zziTNo5nrmKlhRhskSw3tiYLDon4eHyayWG5zVGNUUAFBgWp7OF5DXAU6SO6
         MNEJWyIjhmT687fe0DNCIcZGQVrC/7SKePKwT05AVuoUB+6AuFcdg6q+d72+VhRARmbF
         IF1A==
X-Gm-Message-State: AOAM532HHIj8RuVOrx/227YJ/P6xfQ5O54Wyu13J5AsJ7uLBatrX8Ldv
        J5YQhYbF+cRamQ1ET5rA7/P5mg==
X-Google-Smtp-Source: ABdhPJxwGw5yVkX9qLympbpNPYa4ihCOPDnJEFbWRsVu8t6dvIwYQRRToQPlei3MyDTRcSYspl6LPA==
X-Received: by 2002:a17:903:2303:b0:13f:e63:e27d with SMTP id d3-20020a170903230300b0013f0e63e27dmr28278411plh.84.1634071490561;
        Tue, 12 Oct 2021 13:44:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w17sm10177165pff.191.2021.10.12.13.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 13:44:49 -0700 (PDT)
Date:   Tue, 12 Oct 2021 20:44:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <YWXzvhuE9/iCcqxZ@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-22-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-22-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021, Brijesh Singh wrote:
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.

...

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

IMO, this should be guarded by a module param or X86_BUG_* to make it clear that
this is a bug and not working as intended.

And doesn't the APIC page need these shenanigans iff AVIC is enabled? (the module
param, not necessarily in the VM)

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
