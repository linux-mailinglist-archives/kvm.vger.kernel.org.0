Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF4A4AC77C
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358120AbiBGR3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 12:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiBGRVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:21:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BCAFC0401D5
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 09:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644254498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FjISCgulZMU3dCQjJhgNpS+u4jeIYV008iSjX8GeTv8=;
        b=LCu2ChuWN4ZTeABlTTrUb2EJKYqMCwnKSEJzoVNIohgymPQcPRRs28Fxe1BxutQoXjJeTy
        FtdZFApHKJFzNIRf+Uc6ehX3IS2H+5yfvjAD6kkWto05bEqmGgQ/gZ2/ooHL/LM/NEcPYK
        FhZcEsoVXxgsWdsvnlHqjmf6XR4DZyE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-4NImdxXxOGKZeYUYOX-Qqg-1; Mon, 07 Feb 2022 12:21:37 -0500
X-MC-Unique: 4NImdxXxOGKZeYUYOX-Qqg-1
Received: by mail-ej1-f70.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so4556302ejw.9
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 09:21:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FjISCgulZMU3dCQjJhgNpS+u4jeIYV008iSjX8GeTv8=;
        b=Uh7Cg8wbanRN5sHAGPAdOEppuXDfTKDpKIWc4GY/78FDM9hAsB+5qCFu0sG6Qr8WWa
         LcBWUQf/mJmRY6jMfMU1k46pc9Q+X+bCXKL9EkZqa47o1LBnx1hkm/heTgh1oChdn8Ri
         8HHGO9jekx2jyCxp8SFyF0QEwUZZQ/6yCJjkKd0iCK2OfJZGpks0g1xvqNZXrszgxECv
         GPp6hohE11oSdshJFJhicWfKVb6BMxlyxUtvlfES9OBu3ksoIrnzjvas/WZulZxdSlQa
         GP4lNG9R9p5J9kT3K+ris2Bzk0KWiafvhmqgPWX9lSeKLXcFoxmD4ytyjzhmqK0LnOwv
         RMhQ==
X-Gm-Message-State: AOAM533qICD9J5VoSQqajwzlucTXbQqAKGYTqCle4dwzktXivfm9N2E/
        nHH03s8UWfm3WHH58PYt4SHFCkVLmgWUl1u48i+vAqByyBIXyer7giywqo4csV2RbY9A8raSpmp
        45B1OJQSogBb3
X-Received: by 2002:a17:907:7fa3:: with SMTP id qk35mr600306ejc.300.1644254495342;
        Mon, 07 Feb 2022 09:21:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0JzsqM91oAznS/gdIt/k3wuDO2lou84SLFzWHcMkztsQLVnQzd6ZBhzIGOpZT+QjZApaGLA==
X-Received: by 2002:a17:907:7fa3:: with SMTP id qk35mr600292ejc.300.1644254495041;
        Mon, 07 Feb 2022 09:21:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r6sm3360895ejd.100.2022.02.07.09.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 09:21:34 -0800 (PST)
Message-ID: <ce6e9ae4-2e5b-7078-5322-05b7a61079b4@redhat.com>
Date:   Mon, 7 Feb 2022 18:21:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-2-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220204204705.3538240-2-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 21:46, Oliver Upton wrote:
> Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
> when guest MPX disabled"), KVM has taken ownership of the "load
> IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls. The ABI
> is that these bits must be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
> MSRs if the guest's CPUID supports MPX, and clear otherwise.
> 
> However, KVM will only do so if userspace sets the CPUID before writing
> to the corresponding MSRs. Of course, there are no ordering requirements
> between these ioctls. Uphold the ABI regardless of ordering by
> reapplying KVMs tweaks to the VMX control MSRs after userspace has
> written to them.

I don't understand this patch.  If you first write the CPUID and then 
the MSR, the consistency is upheld by these checks:

         if (!is_bitwise_subset(data, supported, GENMASK_ULL(31, 0)))
                 return -EINVAL;

         if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
                 return -EINVAL;

If you're fixing a case where userspace first writes the MSR and then 
sets CPUID, then I would expect that KVM_SET_CPUID2 redoes those checks 
and, if they fail, it adjusts the MSRs.

The selftests confirm that I'm a bit confused, but in general 
vmx_restore_control_msr is not the place where I was expecting the change.

Paolo

> Fixes: 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 9 +++++++++
>   arch/x86/kvm/vmx/vmx.c    | 2 +-
>   arch/x86/kvm/vmx/vmx.h    | 2 ++
>   3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ba34e94049c7..59164394569f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1291,6 +1291,15 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>   
>   	*lowp = data;
>   	*highp = data >> 32;
> +
> +	/*
> +	 * Ensure KVM fiddling with these MSRs is preserved after userspace
> +	 * write.
> +	 */
> +	if (msr_index == MSR_IA32_VMX_TRUE_ENTRY_CTLS ||
> +	    msr_index == MSR_IA32_VMX_TRUE_EXIT_CTLS)
> +		nested_vmx_entry_exit_ctls_update(&vmx->vcpu);
> +
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index aca3ae2a02f3..d63d6dfbadbf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7227,7 +7227,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>   #undef cr4_fixed1_update
>   }
>   
> -static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
> +void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7f2c82e7f38f..e134e2763502 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -423,6 +423,8 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>   
>   void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>   
> +void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
> +
>   /*
>    * Note, early Intel manuals have the write-low and read-high bitmap offsets
>    * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and

