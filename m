Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9F4112770
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 10:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfLDJbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 04:31:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44380 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725922AbfLDJbg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 04:31:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575451893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=INj3PN/5oMRGw7Meo+Adt8vbfL+wJwY7eJiMvVAtLRs=;
        b=H0RsnvklNGW/b1PKHmQz5PYQRTvpRYR7DJsoDy6bWAPidu995zOyolCMJiFzOYLM1V6b7w
        h7mUbbAoOl7qoia7WzPCrVReuhhgRVuEsTk1eW+0B8oADBPCy01eQN0kksw9pYOqTZC0YE
        jPpq0SDXI/ca+tjUucB+AbNrSIxFI1Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-IKrj05dsPCSeJyDPwym6IQ-1; Wed, 04 Dec 2019 04:31:30 -0500
Received: by mail-wm1-f69.google.com with SMTP id f191so1896266wme.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 01:31:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=INj3PN/5oMRGw7Meo+Adt8vbfL+wJwY7eJiMvVAtLRs=;
        b=U4h9cZceryzw3u3Kxn43HjBG3wiVYnISbSdjXcmRyzzS8Itk+v8ncNHnybODHTN+BZ
         O/I6aoGm87OPAcmMlzsY9N81Jqvi8Z4/7z5x05wx7v2E2NvTcSTv9HFQ8nPl+z1iLy6k
         zg3ipaiFRFdWHFQ/lMGYUh0kMdwZhMyJxuNpmwUhX/Kn2XmU8cYMJwiRjXhNeRxR/6u1
         Oc7ozZkrrXmZdn0GF0kFCr5a1XA5BA+20eyVFkqn8PFjSvs0gwXj7cr0uStarQDddIam
         VW9ldT5wfBV+4vcHaomk1VQ9SjrvwfWoajzwasvcUWEZrmFp2UITBmeulhbKLfcxPPwc
         fotg==
X-Gm-Message-State: APjAAAXkAulFonrvaNi3UfZZOOW50Jfmr1yNoC3T7PzKDwWxIfSbdOUq
        CbkmSXfa7Xr5Fos3IDG2eU7/irCOJzxqOmJ1xIeC9XaKR43KOFxpeI4XXcpIyKo9K9SsP1teAOv
        DDfewfg7/xrW8
X-Received: by 2002:adf:f606:: with SMTP id t6mr2757691wrp.85.1575451889283;
        Wed, 04 Dec 2019 01:31:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqxs2+cakJeDszT/l9DD04y+cAx+4s100LqnXqoF02opPhV0s+KqrA4F5Zu0Mjwj8avQOHZN+w==
X-Received: by 2002:adf:f606:: with SMTP id t6mr2757667wrp.85.1575451889021;
        Wed, 04 Dec 2019 01:31:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id y20sm5857914wmi.25.2019.12.04.01.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 01:31:28 -0800 (PST)
Subject: Re: [PATCH v2] kvm: vmx: Stop wasting a page for guest_msrs
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Liran Alon <liran.alon@oracle.com>
References: <20191204002442.186018-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <06b78b0c-56f8-ca63-c0f6-2623799c8a80@redhat.com>
Date:   Wed, 4 Dec 2019 10:31:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191204002442.186018-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: IKrj05dsPCSeJyDPwym6IQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 01:24, Jim Mattson wrote:
> We will never need more guest_msrs than there are indices in
> vmx_msr_index. Thus, at present, the guest_msrs array will not exceed
> 168 bytes.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> ---
> v1 -> v2:
>   Changed NR_GUEST_MSRS to NR_SHARED_MSRS.
>   Added BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != NR_SHARED_MSRS).
> 
>  arch/x86/kvm/vmx/vmx.c | 12 ++----------
>  arch/x86/kvm/vmx/vmx.h |  8 +++++++-
>  2 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1b9ab4166397d..e3394c839dea6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6666,7 +6666,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
>  	free_vpid(vmx->vpid);
>  	nested_vmx_free_vcpu(vcpu);
>  	free_loaded_vmcs(vmx->loaded_vmcs);
> -	kfree(vmx->guest_msrs);
>  	kvm_vcpu_uninit(vcpu);
>  	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
>  	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
> @@ -6723,12 +6722,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  			goto uninit_vcpu;
>  	}
>  
> -	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
> -	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) * sizeof(vmx->guest_msrs[0])
> -		     > PAGE_SIZE);
> -
> -	if (!vmx->guest_msrs)
> -		goto free_pml;
> +	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != NR_SHARED_MSRS);
>  
>  	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
>  		u32 index = vmx_msr_index[i];
> @@ -6760,7 +6754,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  
>  	err = alloc_loaded_vmcs(&vmx->vmcs01);
>  	if (err < 0)
> -		goto free_msrs;
> +		goto free_pml;
>  
>  	msr_bitmap = vmx->vmcs01.msr_bitmap;
>  	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
> @@ -6822,8 +6816,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  
>  free_vmcs:
>  	free_loaded_vmcs(vmx->loaded_vmcs);
> -free_msrs:
> -	kfree(vmx->guest_msrs);
>  free_pml:
>  	vmx_destroy_pml_buffer(vmx);
>  uninit_vcpu:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7c1b978b2df44..a4f7f737c5d44 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -22,6 +22,12 @@ extern u32 get_umwait_control_msr(void);
>  
>  #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
>  
> +#ifdef CONFIG_X86_64
> +#define NR_SHARED_MSRS	7
> +#else
> +#define NR_SHARED_MSRS	4
> +#endif
> +
>  #define NR_LOADSTORE_MSRS 8
>  
>  struct vmx_msrs {
> @@ -206,7 +212,7 @@ struct vcpu_vmx {
>  	u32                   idt_vectoring_info;
>  	ulong                 rflags;
>  
> -	struct shared_msr_entry *guest_msrs;
> +	struct shared_msr_entry guest_msrs[NR_SHARED_MSRS];
>  	int                   nmsrs;
>  	int                   save_nmsrs;
>  	bool                  guest_msrs_ready;
> 

Queued, thanks.

Paolo

