Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE4E351E93
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhDASnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:43:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237274AbhDASdH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2iOhHbxMedJSywyx5Vlr9ArD7zHkmFtWfLJYsTiO5+g=;
        b=JJCiS6pCwKG44eEWke5fu96QURAsgIjMmT1+Hc+tfNfSGMKbOoxmMIBGRq18PsiTkOrWEc
        D3ZqAoZfPSs/WkK0BBGP1wdHMnjwY28a1E9bl1vycyBFxaWo5FtFzCUV2yFOpxOrn6CUC0
        4fWvL8p1FIH+S9DXssLbVeZjVxBUjPU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-O3KItEHKOUOAg26hhP31-A-1; Thu, 01 Apr 2021 10:31:32 -0400
X-MC-Unique: O3KItEHKOUOAg26hhP31-A-1
Received: by mail-ej1-f71.google.com with SMTP id t21so2291654ejf.14
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 07:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2iOhHbxMedJSywyx5Vlr9ArD7zHkmFtWfLJYsTiO5+g=;
        b=DI26aOo3U3B1Rgi5PeqGcJgNVkM6fRxlGJH6Rqd2CWcN2/4qi5GUs10pAezyIqFhBF
         2GPCf5xCLbdcEflSQKbbwbB+/yUSckZo25mE3Nxt4JOQvx4YgaTpBeCT1bv/MAqyFz9d
         J4GBPvFGTOiTlcYGLqG+yTx3hQQyrQipTKDnsNEAuL8mqv3Z67hvxMyu3Q2lf433c0ex
         K8mQo5Bki8tcNQNz1biQkbLEBp1EPuJG53sXNBMXF2nm1DpE69EBD5FgKJfRIoVJoktO
         vOgVhH2Kv6h8VlFlRghzEfNplHhzMwTA35soLTIS/wxEygvRlbu1rOrT4mvwvZ9rAc22
         jiSw==
X-Gm-Message-State: AOAM532oVug/S1sw+rQFVWnZwm0dQtDq1HcIe0UPfz92rXPxqrWD2HHx
        JmjfKZsoTxpL7Es+iFzjvlc6yRobUsluS/uz/Ct2mmCzs0Bo/ctwzjzd1n1Yos9CPvEOPEYBZwN
        0zykKpSoev+c5
X-Received: by 2002:aa7:dc49:: with SMTP id g9mr9943099edu.60.1617287491698;
        Thu, 01 Apr 2021 07:31:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTSGFYcIRvJwIl/MvgfmmaGM8Lf2WtHk0Dyw4IsR6yYnaPrTVvaOCbY4n+m60DH7XOCm25QA==
X-Received: by 2002:aa7:dc49:: with SMTP id g9mr9943078edu.60.1617287491495;
        Thu, 01 Apr 2021 07:31:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z17sm2949165eju.27.2021.04.01.07.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 07:31:30 -0700 (PDT)
Subject: Re: [PATCH 1/6] KVM: nVMX: delay loading of PDPTRs to
 KVM_REQ_GET_NESTED_STATE_PAGES
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
 <20210401141814.1029036-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0e9b0edc-ea1b-af10-830c-296b328593c3@redhat.com>
Date:   Thu, 1 Apr 2021 16:31:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401141814.1029036-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 16:18, Maxim Levitsky wrote:
> Similar to the rest of guest page accesses after migration,
> this should be delayed to KVM_REQ_GET_NESTED_STATE_PAGES
> request.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fd334e4aa6db..b44f1f6b68db 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2564,11 +2564,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>   		return -EINVAL;
>   	}
>   
> -	/* Shadow page tables on either EPT or shadow page tables. */
> -	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
> -				entry_failure_code))
> -		return -EINVAL;
> -
>   	/*
>   	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
>   	 * on nested VM-Exit, which can occur without actually running L2 and
> @@ -3109,11 +3104,16 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>   static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>   {
>   	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +	enum vm_entry_failure_code entry_failure_code;
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	struct kvm_host_map *map;
>   	struct page *page;
>   	u64 hpa;
>   
> +	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
> +				&entry_failure_code))
> +		return false;
> +
>   	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
>   		/*
>   		 * Translate L1 physical address to host physical
> @@ -3357,6 +3357,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>   	}
>   
>   	if (from_vmentry) {
> +		if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3,
> +		    nested_cpu_has_ept(vmcs12), &entry_failure_code))
> +			goto vmentry_fail_vmexit_guest_mode;
> +
>   		failed_index = nested_vmx_load_msr(vcpu,
>   						   vmcs12->vm_entry_msr_load_addr,
>   						   vmcs12->vm_entry_msr_load_count);
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

