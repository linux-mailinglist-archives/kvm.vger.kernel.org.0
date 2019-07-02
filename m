Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897F05D477
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGBQlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:41:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36800 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBQlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:41:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id u8so1766914wmm.1
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:41:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JE+uLFVWCKiesYwjmkKsET/a+w48V7kqeFovQpBuhso=;
        b=U+nCOm8RF2ToxMSzgQA2axo/eaJ1wVGzpKGAEMKUjTsLgb5k99zUdoeVYuYx4VNsPq
         y+HyNJkTqT3Bh568w62rtN4cVQ923HoMNcrcxLPG5NaLTb2hdr8Q7dPI56/SXND/lKNN
         heFFVXi/IiXWAA2o7L6YfZWrLduYF3NoMj7n/GUFfcyoPz1uyYuTBo69ybOh2lfXajpO
         WoB9k6uATaLY9N5pVuijbercxk2VJebHMQ002iiku+fxDW5GpOKN+buonL0QgF6aEH6N
         M4peIvFblV11fG8aak1Hf5NLrsSi1WmnKVSqKwtKIS1jPazjX9vY6VE0LZrqsX+QfGzn
         D8SQ==
X-Gm-Message-State: APjAAAXTf2b2KYx+EETMkd5K/rQDLjetGf32F6Kz9IgB4r7SaKqEUVm2
        QZuaVXDUVnfYRUtLPs5dfF579w==
X-Google-Smtp-Source: APXvYqxUT7b0Or5hD2TTAWc+GcxDxa7eVp3YRK1x26Azarse6kZgWJz0VF/W1deTsECJ4ZEc+VLY6A==
X-Received: by 2002:a1c:cf0b:: with SMTP id f11mr4191318wmg.138.1562085668485;
        Tue, 02 Jul 2019 09:41:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id h11sm1795884wro.73.2019.07.02.09.41.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:41:07 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Change KVM_STATE_NESTED_EVMCS to signal vmcs12
 is copied from eVMCS
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Maran Wilson <maran.wilson@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190626130927.121459-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fd90e2dd-cc79-a801-f161-274fc442bc7a@redhat.com>
Date:   Tue, 2 Jul 2019 18:41:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190626130927.121459-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/19 15:09, Liran Alon wrote:
> Currently KVM_STATE_NESTED_EVMCS is used to signal that eVMCS
> capability is enabled on vCPU.
> As indicated by vmx->nested.enlightened_vmcs_enabled.
> 
> This is quite bizarre as userspace VMM should make sure to expose
> same vCPU with same CPUID values in both source and destination.
> In case vCPU is exposed with eVMCS support on CPUID, it is also
> expected to enable KVM_CAP_HYPERV_ENLIGHTENED_VMCS capability.
> Therefore, KVM_STATE_NESTED_EVMCS is redundant.
> 
> KVM_STATE_NESTED_EVMCS is currently used on restore path
> (vmx_set_nested_state()) only to enable eVMCS capability in KVM
> and to signal need_vmcs12_sync such that on next VMEntry to guest
> nested_sync_from_vmcs12() will be called to sync vmcs12 content
> into eVMCS in guest memory.
> However, because restore nested-state is rare enough, we could
> have just modified vmx_set_nested_state() to always signal
> need_vmcs12_sync.
> 
> From all the above, it seems that we could have just removed
> the usage of KVM_STATE_NESTED_EVMCS. However, in order to preserve
> backwards migration compatibility, we cannot do that.
> (vmx_get_nested_state() needs to signal flag when migrating from
> new kernel to old kernel).
> 
> Returning KVM_STATE_NESTED_EVMCS when just vCPU have eVMCS enabled
> have a bad side-effect of userspace VMM having to send nested-state
> from source to destination as part of migration stream. Even if
> guest have never used eVMCS as it doesn't even run a nested
> hypervisor workload. This requires destination userspace VMM and
> KVM to support setting nested-state. Which make it more difficult
> to migrate from new host to older host.
> To avoid this, change KVM_STATE_NESTED_EVMCS to signal eVMCS is
> not only enabled but also active. i.e. Guest have made some
> eVMCS active via an enlightened VMEntry. i.e. vmcs12 is copied
> from eVMCS and therefore should be restored into eVMCS resident
> in memory (by copy_vmcs12_to_enlightened()).
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Maran Wilson <maran.wilson@oracle.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>

This patch has the same conflict so I will also queue it later.

Paolo

> ---
>  arch/x86/kvm/vmx/nested.c                     | 25 ++++++++++++-------
>  .../testing/selftests/kvm/x86_64/evmcs_test.c |  1 +
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b66001fb0232..18efb338ed8a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5240,9 +5240,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  	vmx = to_vmx(vcpu);
>  	vmcs12 = get_vmcs12(vcpu);
>  
> -	if (nested_vmx_allowed(vcpu) && vmx->nested.enlightened_vmcs_enabled)
> -		kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
> -
>  	if (nested_vmx_allowed(vcpu) &&
>  	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
>  		kvm_state.hdr.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
> @@ -5251,6 +5248,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  		if (vmx_has_valid_vmcs12(vcpu)) {
>  			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
>  
> +			if (vmx->nested.hv_evmcs)
> +				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
> +
>  			if (is_guest_mode(vcpu) &&
>  			    nested_cpu_has_shadow_vmcs(vmcs12) &&
>  			    vmcs12->vmcs_link_pointer != -1ull)
> @@ -5350,6 +5350,15 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		if (kvm_state->hdr.vmx.vmcs12_pa != -1ull)
>  			return -EINVAL;
>  
> +		/*
> +		 * KVM_STATE_NESTED_EVMCS used to signal that KVM should
> +		 * enable eVMCS capability on vCPU. However, since then
> +		 * code was changed such that flag signals vmcs12 should
> +		 * be copied into eVMCS in guest memory.
> +		 *
> +		 * To preserve backwards compatability, allow user
> +		 * to set this flag even when there is no VMXON region.
> +		 */
>  		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
>  			return -EINVAL;
>  	} else {
> @@ -5358,7 +5367,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
>  			return -EINVAL;
> -    	}
> +	}
>  
>  	if ((kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
>  	    (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
> @@ -5383,13 +5392,11 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	    !(kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON))
>  		return -EINVAL;
>  
> -	vmx_leave_nested(vcpu);
> -	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
> -		if (!nested_vmx_allowed(vcpu))
> +	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
> +		(!nested_vmx_allowed(vcpu) || !vmx->nested.enlightened_vmcs_enabled))
>  			return -EINVAL;
>  
> -		nested_enable_evmcs(vcpu, NULL);
> -	}
> +	vmx_leave_nested(vcpu);
>  
>  	if (kvm_state->hdr.vmx.vmxon_pa == -1ull)
>  		return 0;
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index b38260e29775..241919ef1eac 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -146,6 +146,7 @@ int main(int argc, char *argv[])
>  		kvm_vm_restart(vm, O_RDWR);
>  		vm_vcpu_add(vm, VCPU_ID, 0, 0);
>  		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +		vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
>  		vcpu_load_state(vm, VCPU_ID, state);
>  		run = vcpu_state(vm, VCPU_ID);
>  		free(state);
> 

