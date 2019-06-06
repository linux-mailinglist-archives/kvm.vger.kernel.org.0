Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C4B379DC
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfFFQjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:39:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44281 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFFQjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:39:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id b17so2037321wrq.11
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 09:39:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2KVnh/F9ys07AcLVHGe0uO9gu9eidcx1JDM+dAsCncs=;
        b=o9Furu3JJGUr3zGGaII1DMjmXnsxKjUOVWQ7x5kx+N7yNmFQWuWA3zIgCVvlzUEDoJ
         Tduagmqfb9eVUxYd4cdJroQCICIbJ3PeCAd6drFrajvxfpsUAk/ygD3LKMKONI2bf/Ec
         N0obrt1E/ITGYnNJ1DtXH1SgyS8RoKI8lwu+ca50AnU0m/qwseNDBm+tqPChD50dn7Zl
         0E0LBIKBD6WDkJ7HryBcBO7ojSZssoQnHW8S8GyFiNReEYW/wMdqyWXh1vfgVPNFJorU
         ELLhy1uOQCXu2l3fRpFkliqXfMUUaI0W35NXoo66I7ldggdD99mnnN89EBl7TPs/3oE4
         fWiw==
X-Gm-Message-State: APjAAAWuBu/Kxi9OthAzTNBmiaLAOqzIVzrwrPHHDCpY3/mSZHLXqvoX
        0Pgy9n5B7PjCl9R7PEp3NMvmhg==
X-Google-Smtp-Source: APXvYqxTRdEEDg2Ijj0Qlfb8YcKyHCS9zodCtAQDq+j+0ENHFlMvMq+15YeBodqS3MHzvixeNMlVpw==
X-Received: by 2002:adf:dc09:: with SMTP id t9mr30778147wri.69.1559839177474;
        Thu, 06 Jun 2019 09:39:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id b2sm2946447wrp.72.2019.06.06.09.39.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:39:36 -0700 (PDT)
Subject: Re: [PATCH 13/15] KVM: nVMX: Update vmcs02 GUEST_IA32_DEBUGCTL only
 when vmcs12 is dirty
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-14-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4158730d-9f47-5c08-e097-287518a1f841@redhat.com>
Date:   Thu, 6 Jun 2019 18:39:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507160640.4812-14-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 18:06, Sean Christopherson wrote:
> VMWRITEs to GUEST_IA32_DEBUGCTL from L1 are always intercepted, and
> unlike GUEST_DR7 there is no funky logic for determining the value.
> 
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2e9f8169d40a..58717dfe82c9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2194,6 +2194,11 @@ static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  			vmcs_write64(GUEST_PDPTR2, vmcs12->guest_pdptr2);
>  			vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
>  		}
> +
> +		if (vmx->nested.nested_run_pending &&
> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> +			vmcs_write64(GUEST_IA32_DEBUGCTL,
> +					vmcs12->guest_ia32_debugctl);
>  	}
>  
>  	if (nested_cpu_has_xsaves(vmcs12))
> @@ -2270,7 +2275,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	if (vmx->nested.nested_run_pending &&
>  	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
>  		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
>  	} else {
>  		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
>  		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.vmcs01_debugctl);
> 

I'm passing on this one.  It really gets more complicated and I'm not
sure the savings are worth it.

Paolo
