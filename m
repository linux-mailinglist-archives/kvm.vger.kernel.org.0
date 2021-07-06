Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D7C3BD86C
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhGFOlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:41:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232541AbhGFOkz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S4prdEFuZyq9R8yCrpoLHKizAEwKvefLKtTLoxWJEGs=;
        b=IqJIVp4YqbUAgOyDAcwtv4wT/QdJs0M6NxWTF1y5kiPcK7PiEGsBOZXOEbie06jkiqj8ID
        FqxbGXJJpJMxqZtkwAK/m8ouXfIMH5Nn9WTTsR1qrg3ZBYG1seLws3Tv2yv8yRYqmWaqjd
        B6YSPhpoLki3dEsbO4NLWQblLkjSEfs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-vhTAzNPFMc27M6ABbbyJIQ-1; Tue, 06 Jul 2021 09:48:01 -0400
X-MC-Unique: vhTAzNPFMc27M6ABbbyJIQ-1
Received: by mail-ej1-f70.google.com with SMTP id v5-20020a1709068585b02904eb913da73bso172661ejx.8
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S4prdEFuZyq9R8yCrpoLHKizAEwKvefLKtTLoxWJEGs=;
        b=V9es+FDdGlD9FCENCOofekK7vXjy9N1S3yUHXOnzhElJxxltodD28NiwDeZgRYRyiD
         Zz6r0oBKlxkW/xjnX9vNuDxuPqdsBfA8dQ25qDi6iam4g5ZIutU+B3ZfJ/1OvjDDwzB6
         hrZ5JgQyHLgcW2yqI5rh/5GLJ6Je9nIqrE029182F9R7oc+UhFqIwH+PZdwI7XKR7x9Z
         SVkWMMdaRySSYurRgof71RWR+RZW6l9t5gL+Z1D2POD7cwyYaaRNB56rZjmWtPdwz1EK
         rrRiU4n25rQjrTHUpb8C1BmfU/77UTuxtMtW4W8KTKxlYOVWvHEQwmu7nN0gxzNhWLuG
         Ncwg==
X-Gm-Message-State: AOAM532JbTn0cSqlpwxFvQ4MX2RtibjtSifjB2cXIq6/CH/upSoP/or8
        O0GpGFr+NLyUS3RN8eh+2uymhHR6foVYI7JujpJnEB2sj518M0PT61EdHxIoFcfWWyGleNgDMoV
        6/1S3+SDjgo4d
X-Received: by 2002:a17:907:3e0a:: with SMTP id hp10mr18814126ejc.110.1625579280451;
        Tue, 06 Jul 2021 06:48:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyCcAANulh80bjde2is9AHcILD0AricQw99masb50aCqaLXiKfRJ1LMQjQdFw97jRxZacAUA==
X-Received: by 2002:a17:907:3e0a:: with SMTP id hp10mr18814115ejc.110.1625579280266;
        Tue, 06 Jul 2021 06:48:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u20sm466086edr.50.2021.07.06.06.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:47:59 -0700 (PDT)
Subject: Re: [RFC PATCH v2 19/69] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle
 bugs that are fatal to the VM
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <0e8760a26151f47dc47052b25ca8b84fffe0641e.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ae5fb392-0025-14c7-45b9-2b307a06e4a6@redhat.com>
Date:   Tue, 6 Jul 2021 15:47:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0e8760a26151f47dc47052b25ca8b84fffe0641e.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/svm/svm.c |  2 +-
>   arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++---------
>   arch/x86/kvm/x86.c     |  4 ++++
>   3 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e088086f3de6..25c72925eb8a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1526,7 +1526,7 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>   		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
>   		break;
>   	default:
> -		WARN_ON_ONCE(1);
> +		KVM_BUG_ON(1, vcpu->kvm);
>   	}
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d73ba7a6ff8d..6c043a160b30 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2360,7 +2360,7 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>   		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
>   		break;
>   	default:
> -		WARN_ON_ONCE(1);
> +		KVM_BUG_ON(1, vcpu->kvm);
>   		break;
>   	}
>   }
> @@ -5062,6 +5062,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
>   			return kvm_complete_insn_gp(vcpu, err);
>   		case 3:
>   			WARN_ON_ONCE(enable_unrestricted_guest);
> +
>   			err = kvm_set_cr3(vcpu, val);
>   			return kvm_complete_insn_gp(vcpu, err);
>   		case 4:
> @@ -5087,14 +5088,13 @@ static int handle_cr(struct kvm_vcpu *vcpu)
>   		}
>   		break;
>   	case 2: /* clts */
> -		WARN_ONCE(1, "Guest should always own CR0.TS");
> -		vmx_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
> -		trace_kvm_cr_write(0, kvm_read_cr0(vcpu));
> -		return kvm_skip_emulated_instruction(vcpu);
> +		KVM_BUG(1, vcpu->kvm, "Guest always owns CR0.TS");
> +		return -EIO;
>   	case 1: /*mov from cr*/
>   		switch (cr) {
>   		case 3:
>   			WARN_ON_ONCE(enable_unrestricted_guest);
> +
>   			val = kvm_read_cr3(vcpu);
>   			kvm_register_write(vcpu, reg, val);
>   			trace_kvm_cr_read(cr, val);
> @@ -5404,7 +5404,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>   
>   static int handle_nmi_window(struct kvm_vcpu *vcpu)
>   {
> -	WARN_ON_ONCE(!enable_vnmi);
> +	if (KVM_BUG_ON(!enable_vnmi, vcpu->kvm))
> +		return -EIO;
> +
>   	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
>   	++vcpu->stat.nmi_window_exits;
>   	kvm_make_request(KVM_REQ_EVENT, vcpu);
> @@ -5960,7 +5962,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	 * below) should never happen as that means we incorrectly allowed a
>   	 * nested VM-Enter with an invalid vmcs12.
>   	 */
> -	WARN_ON_ONCE(vmx->nested.nested_run_pending);
> +	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
> +		return -EIO;
>   
>   	/* If guest state is invalid, start emulating */
>   	if (vmx->emulation_required)
> @@ -6338,7 +6341,9 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>   	int max_irr;
>   	bool max_irr_updated;
>   
> -	WARN_ON(!vcpu->arch.apicv_active);
> +	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
> +		return -EIO;
> +
>   	if (pi_test_on(&vmx->pi_desc)) {
>   		pi_clear_on(&vmx->pi_desc);
>   		/*
> @@ -6421,7 +6426,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>   	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
>   	gate_desc *desc = (gate_desc *)host_idt_base + vector;
>   
> -	if (WARN_ONCE(!is_external_intr(intr_info),
> +	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
>   	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>   		return;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cc45b2c47672..9244d1d560d5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9153,6 +9153,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	}
>   
>   	if (kvm_request_pending(vcpu)) {
> +		if (kvm_check_request(KVM_REQ_VM_BUGGED, vcpu)) {
> +			r = -EIO;
> +			goto out;
> +		}
>   		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
>   			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
>   				r = 0;
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

