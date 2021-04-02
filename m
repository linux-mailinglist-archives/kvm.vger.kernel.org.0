Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3379352E3E
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 19:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhDBR1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 13:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbhDBR1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 13:27:40 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC30C061788
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 10:27:39 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x126so3964178pfc.13
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 10:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0KRHAFf6XYp/bIiHPeRWhSXO2Fw44pBrmTOiP09/NiQ=;
        b=a18oCvVbYo2yphryIVjdJRy+DbRMfRN0xfjZwQvlwjPcIHY+MygsRh50jP3Xehco+8
         k5X3gk6Zo2fV+JBa1OCj9K5pYrTlbFIW/w6L0fDuT2TqrR2NZ8v/6WAZvm7Rsn5Qi7lf
         b0SA2uAmZ1Cjgn4GDNN7dcpsUHIPT8s+M79s6N6lwuT2cyd6Qu0m5CyFN8W93dWln+0p
         Df35hKz+/kVB2yc5yEXtZNUzmQ+9lE7y+ia7lAvd8iu16TwyefpeI9KYisb+58SOep7c
         sgMNQuAAHwuqele4MJ4vZy2eXVCBFYBUYTvA/TeyFVVqH3Zm5zhpMpW8m+V0qGBQ1mjX
         xjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0KRHAFf6XYp/bIiHPeRWhSXO2Fw44pBrmTOiP09/NiQ=;
        b=Dckx36sZ+jlpke11tlm9MknjRP06VL7RxQMgdkGp82WmcAW3dGBJe88MVkL3x2nMSL
         +gj3oMWDc9qlSR5RsukX12ZxLRzUnK+1mDD5B9ujYrSt/4n/7iR6W6W68grJUNGBODyw
         l8pH/eUSUz69e1P/qXCDxyAN2ldlFQ6N0yFYeokUO23nlBxkQuEfYsiEdpHPbIsyqV5I
         v3Eme6pOhTvncC0/uw+bRNYSnOYewHaRZux71Scd4qB84Qb9Dx9WeuuNfBazJNusJ+jv
         r/VejrdRmmFXGlLkxsMILjubUime1yzjDmfvpQNZ2s8UGL5kmgikJu7dT18vNXWyX655
         PKmA==
X-Gm-Message-State: AOAM530JZgEiUJ8lwkrrUDgzvAXGTfvTDJd7IymFWn/A8DfoXsWO2tHg
        m4XwAAZ7vktad64PlkKirCMr1w==
X-Google-Smtp-Source: ABdhPJzo+3KlTDJrjXzNNeTy6ALg+P20+MFZnlIQdhKLAx2tZEkAbrp1t5yZq6L3AGKpuwtvSbGthg==
X-Received: by 2002:a63:4460:: with SMTP id t32mr12530863pgk.139.1617384458489;
        Fri, 02 Apr 2021 10:27:38 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n5sm8859941pfq.44.2021.04.02.10.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 10:27:37 -0700 (PDT)
Date:   Fri, 2 Apr 2021 17:27:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/6] KVM: nVMX: delay loading of PDPTRs to
 KVM_REQ_GET_NESTED_STATE_PAGES
Message-ID: <YGdUBvliVWoF0tVl@google.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
 <20210401141814.1029036-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401141814.1029036-2-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Maxim Levitsky wrote:
> Similar to the rest of guest page accesses after migration,
> this should be delayed to KVM_REQ_GET_NESTED_STATE_PAGES
> request.

FWIW, I still object to this approach, and this patch has a plethora of issues.

I'm not against deferring various state loading to KVM_RUN, but wholesale moving
all of GUEST_CR3 processing without in-depth consideration of all the side
effects is a really bad idea.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fd334e4aa6db..b44f1f6b68db 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2564,11 +2564,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		return -EINVAL;
>  	}
>  
> -	/* Shadow page tables on either EPT or shadow page tables. */
> -	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
> -				entry_failure_code))
> -		return -EINVAL;
> -
>  	/*
>  	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
>  	 * on nested VM-Exit, which can occur without actually running L2 and
> @@ -3109,11 +3104,16 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +	enum vm_entry_failure_code entry_failure_code;
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct kvm_host_map *map;
>  	struct page *page;
>  	u64 hpa;
>  
> +	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
> +				&entry_failure_code))

This results in KVM_RUN returning 0 without filling vcpu->run->exit_reason.
Speaking from experience, debugging those types of issues is beyond painful.

It also means CR3 is double loaded in the from_vmentry case.

And it will cause KVM to incorrectly return NVMX_VMENTRY_KVM_INTERNAL_ERROR
if a consistency check fails when nested_get_vmcs12_pages() is called on
from_vmentry.  E.g. run unit tests with this and it will silently disappear.

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index bbb006a..b8ccc69 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8172,6 +8172,16 @@ static void test_guest_segment_base_addr_fields(void)
        vmcs_write(GUEST_AR_ES, ar_saved);
 }

+static void test_guest_cr3(void)
+{
+       u64 cr3_saved = vmcs_read(GUEST_CR3);
+
+       vmcs_write(GUEST_CR3, -1ull);
+       test_guest_state("Bad CR3 fails VM-Enter", true, -1ull, "GUEST_CR3");
+
+       vmcs_write(GUEST_DR7, cr3_saved);
+}
+
 /*
  * Check that the virtual CPU checks the VMX Guest State Area as
  * documented in the Intel SDM.
@@ -8181,6 +8191,8 @@ static void vmx_guest_state_area_test(void)
        vmx_set_test_stage(1);
        test_set_guest(guest_state_test_main);

+       test_guest_cr3();
+
        /*
         * The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field
         * must each contain a canonical address.


> +		return false;
> +
>  	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
>  		/*
>  		 * Translate L1 physical address to host physical
> @@ -3357,6 +3357,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	}
>  
>  	if (from_vmentry) {
> +		if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3,
> +		    nested_cpu_has_ept(vmcs12), &entry_failure_code))

This alignment is messed up; it looks like two separate function calls.

> +			goto vmentry_fail_vmexit_guest_mode;
> +
>  		failed_index = nested_vmx_load_msr(vcpu,
>  						   vmcs12->vm_entry_msr_load_addr,
>  						   vmcs12->vm_entry_msr_load_count);
> -- 
> 2.26.2
> 
