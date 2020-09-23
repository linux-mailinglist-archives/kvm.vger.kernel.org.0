Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F30B275CB0
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgIWQDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:03:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726156AbgIWQDR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 12:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600876996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4k05A7gj+uoHnM+KMGYBlW8EKoINucj1vNX3PIFnaE=;
        b=ZcivSLoDFhUo5UZiUrFgriqkuOTpyWC2sF2QVsjoP6sykXZ3pEK4WG/8gj05JaQozJlJZN
        ZEp/qz+/kpIx4PWifsP4Drug9TGG/EzXlWz7kIMUKQkKVrSE6Lm82/xdofbv3J+iX7tEAj
        UtGqlQ47FFRg7b3LYJO7YuHEV7lbnuk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-1w5NshmZNEWj-P2aEkEZaQ-1; Wed, 23 Sep 2020 12:03:14 -0400
X-MC-Unique: 1w5NshmZNEWj-P2aEkEZaQ-1
Received: by mail-wr1-f69.google.com with SMTP id a2so13715wrp.8
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 09:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B4k05A7gj+uoHnM+KMGYBlW8EKoINucj1vNX3PIFnaE=;
        b=cS4ulghmgtU+XsrNLIzdK++OZLeW5E+ai26B7DM7/GW0/ucFM7e18rpPMqZZJW2+uP
         NuB+QIjRHWDQYHB2NOXgSLjyiVhxG23aEMqGF+APTjrtpKxd7Vz4dBCqNDrS8JsaJOXk
         ppzLskZTR94CveqpzhxejcqMzOKA5wrs/SAn+NhcIHVlcIwTbjImFrdl/V57HJVDf7hu
         VY4B8jHNGfgD4dkWV2rCNPGBsus93A3rzXKDPKJfzS3pSdYMCNJMolIqFpCAXFI/gcNq
         PC9GaDJeHd4C4SoeUSIm2G5ZkMziY3m7daJakZR8VMuTLNaepdRvKrSUzEoC1lIwSy64
         5jkw==
X-Gm-Message-State: AOAM532WsDbtZcITqOaHiU+oIs2gffJQbRQcxVzadHXrgP47w1hDKrDM
        mDRhjkYl8TKy/lDenNbawLewsgjSAp1YyyiC4KdmONSDZM2cOAUkKN1qs6MjwlqFSni+/gD8V44
        wBQ4lXKALpZ8i
X-Received: by 2002:a7b:c090:: with SMTP id r16mr305306wmh.56.1600876993314;
        Wed, 23 Sep 2020 09:03:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx53k+H6RDWGsRDS/9X0hVju1Y6R9gCy5OLglPnvsnHXFnkTIjh1Gycp0Yoxiy5ddFylG97Cw==
X-Received: by 2002:a7b:c090:: with SMTP id r16mr305280wmh.56.1600876993088;
        Wed, 23 Sep 2020 09:03:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id t15sm265051wrp.20.2020.09.23.09.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 09:03:12 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Add VM-Enter failed tracepoints for super
 early checks
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200812180615.22372-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5fc9972c-a4d4-81da-3605-90d8c7c8a029@redhat.com>
Date:   Wed, 23 Sep 2020 18:03:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200812180615.22372-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/20 20:06, Sean Christopherson wrote:
> Add tracepoints for the early consistency checks in nested_vmx_run().
> The "VMLAUNCH vs. VMRESUME" check in particular is useful to trace, as
> there is no architectural way to check VMCS.LAUNCH_STATE, and subtle
> bugs such as VMCLEAR on the wrong HPA can lead to confusing errors in
> the L1 VMM.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 23b58c28a1c92..fb37f0972e78a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3468,11 +3468,11 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (evmptrld_status == EVMPTRLD_ERROR) {
>  		kvm_queue_exception(vcpu, UD_VECTOR);
>  		return 1;
> -	} else if (evmptrld_status == EVMPTRLD_VMFAIL) {
> +	} else if (CC(evmptrld_status == EVMPTRLD_VMFAIL)) {
>  		return nested_vmx_failInvalid(vcpu);
>  	}
>  
> -	if (!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull)
> +	if (CC(!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull))
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	vmcs12 = get_vmcs12(vcpu);
> @@ -3483,7 +3483,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	 * rather than RFLAGS.ZF, and no error number is stored to the
>  	 * VM-instruction error field.
>  	 */
> -	if (vmcs12->hdr.shadow_vmcs)
> +	if (CC(vmcs12->hdr.shadow_vmcs))
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	if (vmx->nested.hv_evmcs) {
> @@ -3504,10 +3504,10 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	 * for misconfigurations which will anyway be caught by the processor
>  	 * when using the merged vmcs02.
>  	 */
> -	if (interrupt_shadow & KVM_X86_SHADOW_INT_MOV_SS)
> +	if (CC(interrupt_shadow & KVM_X86_SHADOW_INT_MOV_SS))
>  		return nested_vmx_fail(vcpu, VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS);
>  
> -	if (vmcs12->launch_state == launch)
> +	if (CC(vmcs12->launch_state == launch))
>  		return nested_vmx_fail(vcpu,
>  			launch ? VMXERR_VMLAUNCH_NONCLEAR_VMCS
>  			       : VMXERR_VMRESUME_NONLAUNCHED_VMCS);
> 

Queued, thanks.

Paolo

