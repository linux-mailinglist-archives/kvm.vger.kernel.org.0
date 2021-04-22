Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C65F368008
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 14:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbhDVMGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 08:06:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236025AbhDVMGb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 08:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619093156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+A0xZ5eON9gs40KcP02cAVAi5lehO7xjvA952SuU50=;
        b=I2vmTVIy/WxfhF5sCJfS622sT9PpDf2xWXUPKN8QHpEo78X1QeHWkrcwmRp/SLAqPw/tnV
        t+Wm5YccaiJNsfZ25V4pCkyoiJ6jv6zU4kYhCZ62d/y6cVKnDu1PLfjYziTnbbFbw/WLmG
        r4QEEE5NzFCIbSH/YOrLxCgR1O65tPU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-0hT5drewPJ-dWN75EXhIJA-1; Thu, 22 Apr 2021 08:05:50 -0400
X-MC-Unique: 0hT5drewPJ-dWN75EXhIJA-1
Received: by mail-ej1-f71.google.com with SMTP id k5-20020a1709061c05b029037cb8a99e03so7074036ejg.16
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 05:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+A0xZ5eON9gs40KcP02cAVAi5lehO7xjvA952SuU50=;
        b=GIvEvEZ/QvVn8ah3Xnoay7Ez2kj2n/avmeu2ikGmFUmgfEK8n0kzQJXsKzbTrGNNX+
         DuWY5UTkq3ApuWUbmukZQcsvnMLzgk8S1h+ZeeCp3doTklrPRu4TrMbbiuChgui6EoGB
         NCT2sMNYXkovOUAs5KHX7iOVJvj6zzP2HKBBrRXs848Zn+5VNvTjrsLSzmqjGvQYjYC4
         Dy9Autovp2kJ6TFwohV23xV0j3K9P4g91uKOOYy5gizdZ0BJoo7Ce4AVwfGvshfoIzRY
         HwOKMTuK2TbU7qrjmC7W4TjrYSIfSGxJ6o0xyyk+e+T285lxLD9/3qk2r0votIxl+0PV
         dC0A==
X-Gm-Message-State: AOAM533KEieL46xRM1w8veafwVjaGrogBkCyLbMtAHvzZmJ5FEtTc/G4
        kdoj1UbwgrjNoYtIIdZ5UEmQk6PMKbW+D8GrKFbnZTUIG0oqELEi6vrbHcDa3x2I1XpAhdfoEaf
        XdvEKAW7AH6tE
X-Received: by 2002:a05:6402:518f:: with SMTP id q15mr3555979edd.150.1619093148986;
        Thu, 22 Apr 2021 05:05:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHYTK5pAXzuEAOvEmisI4JPTFwduN7yH62H3LcAZVLil7SqA/MJQaMi1/DFq2E4jZoH7QKhw==
X-Received: by 2002:a05:6402:518f:: with SMTP id q15mr3555957edd.150.1619093148838;
        Thu, 22 Apr 2021 05:05:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm1745261ejx.27.2021.04.22.05.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 05:05:47 -0700 (PDT)
Subject: Re: [PATCH v5 06/15] x86/sev: Drop redundant and potentially
 misleading 'sev_enabled'
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210422021125.3417167-1-seanjc@google.com>
 <20210422021125.3417167-7-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f1fa7e0-b940-6d1d-1a74-11014901fc0d@redhat.com>
Date:   Thu, 22 Apr 2021 14:05:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422021125.3417167-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 04:11, Sean Christopherson wrote:
> Drop the sev_enabled flag and switch its one user over to sev_active().
> sev_enabled was made redundant with the introduction of sev_status in
> commit b57de6cd1639 ("x86/sev-es: Add SEV-ES Feature Detection").
> sev_enabled and sev_active() are guaranteed to be equivalent, as each is
> true iff 'sev_status & MSR_AMD64_SEV_ENABLED' is true, and are only ever
> written in tandem (ignoring compressed boot's version of sev_status).
> 
> Removing sev_enabled avoids confusion over whether it refers to the guest
> or the host, and will also allow KVM to usurp "sev_enabled" for its own
> purposes.
> 
> No functional change intended.
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Boris or another x86 maintainer, can you ack this small patch?  We would 
like to use sev_enabled as a static variable in KVM.

Paolo

> ---
>   arch/x86/include/asm/mem_encrypt.h |  1 -
>   arch/x86/mm/mem_encrypt.c          | 12 +++++-------
>   arch/x86/mm/mem_encrypt_identity.c |  1 -
>   3 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 31c4df123aa0..9c80c68d75b5 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -20,7 +20,6 @@
>   
>   extern u64 sme_me_mask;
>   extern u64 sev_status;
> -extern bool sev_enabled;
>   
>   void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
>   			 unsigned long decrypted_kernel_vaddr,
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 4b01f7dbaf30..be384d8d0543 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -44,8 +44,6 @@ EXPORT_SYMBOL(sme_me_mask);
>   DEFINE_STATIC_KEY_FALSE(sev_enable_key);
>   EXPORT_SYMBOL_GPL(sev_enable_key);
>   
> -bool sev_enabled __section(".data");
> -
>   /* Buffer used for early in-place encryption by BSP, no locking needed */
>   static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>   
> @@ -373,15 +371,15 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
>    * up under SME the trampoline area cannot be encrypted, whereas under SEV
>    * the trampoline area must be encrypted.
>    */
> -bool sme_active(void)
> -{
> -	return sme_me_mask && !sev_enabled;
> -}
> -
>   bool sev_active(void)
>   {
>   	return sev_status & MSR_AMD64_SEV_ENABLED;
>   }
> +
> +bool sme_active(void)
> +{
> +	return sme_me_mask && !sev_active();
> +}
>   EXPORT_SYMBOL_GPL(sev_active);
>   
>   /* Needs to be called from non-instrumentable code */
> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
> index 6c5eb6f3f14f..0c2759b7f03a 100644
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -545,7 +545,6 @@ void __init sme_enable(struct boot_params *bp)
>   
>   		/* SEV state cannot be controlled by a command line option */
>   		sme_me_mask = me_mask;
> -		sev_enabled = true;
>   		physical_mask &= ~sme_me_mask;
>   		return;
>   	}
> 

