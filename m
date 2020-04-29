Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D401BD75C
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 10:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgD2If6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 04:35:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726355AbgD2If6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 04:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588149356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qdJ9Tssfd21+vkaPztq8wUNJY05TZTVous+kbqb7BpY=;
        b=Q3FxWpoTSnIld4BjN9jytf5XtCtX+xwBN6uLscw7jbiXZvg4+YBGP5HNg3X5cQDzr/PMbZ
        5spnBwQ9Hl3rashvX6X4vTbVymSB9mOASav+dm011a7QLaDI3aoPYjoH1IFqOCQoCaNoEV
        2lVRMCshmS41YVudIbrUG8qTS7cCVaY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-D7zROtdzOu-eMqv5Xnw72g-1; Wed, 29 Apr 2020 04:35:54 -0400
X-MC-Unique: D7zROtdzOu-eMqv5Xnw72g-1
Received: by mail-wm1-f70.google.com with SMTP id n17so723877wmi.3
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 01:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qdJ9Tssfd21+vkaPztq8wUNJY05TZTVous+kbqb7BpY=;
        b=CiSGIU1gNIUxaWXMpW2+kJ/KZFypIvM63lwysGK05A6XYpeM+NB7mdQUerW6pEbRom
         K3B7aBsBXxhZnVrq6fAFWSa2NQvLn8amQ81GNVJcwf7Jc4myIBMCLoO78+C228WLDeTJ
         X3IWGFwB5PC2gAlMm4x80lcJiMCwofABnqhWhPQj94Gq+SBejt3yGctZaMIJQytS1Xle
         bujJ0CN6k2nNvFWD2g71cfl6Lz/g7uRrx+8JqXjnjv8aiSQcAAj9ul5zLK7soWkCtwBy
         k+pgsFYzThU+Fl5osFEm0FQo3m+tEBIA4fetPD7SvtYhb8JSZHfANGtLtfVVvkwKVSzu
         5kOA==
X-Gm-Message-State: AGi0PuZXePWl7hWxC0cYcT/O8TU1r1266qeByQu61NqjwsDpta5Prmqy
        vyo/Da2UnxHeExmX2Eqc0zNLAUzd/FJD/u1yvfvkn6fDu7Up63Y1AjdPCgjcVRDLgqT3dm4uOH4
        LkEI6NSDP6/hR
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr1912733wmd.95.1588149353528;
        Wed, 29 Apr 2020 01:35:53 -0700 (PDT)
X-Google-Smtp-Source: APiQypIBRr85ezZitL4y/lv7Xl5LCtDwiiwsjxzrPLzALJ4qDzhFmjEVYJ8D+cpir1X8GMvK6w0BZw==
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr1912713wmd.95.1588149353322;
        Wed, 29 Apr 2020 01:35:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a205sm7221889wmh.29.2020.04.29.01.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 01:35:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: Cleanup vcpu->arch.guest_xstate_size
In-Reply-To: <20200429154312.1411-1-xiaoyao.li@intel.com>
References: <20200429154312.1411-1-xiaoyao.li@intel.com>
Date:   Wed, 29 Apr 2020 10:35:43 +0200
Message-ID: <87368mit9c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> vcpu->arch.guest_xstate_size lost its only user since commit df1daba7d1cb
> ("KVM: x86: support XSAVES usage in the host"), so clean it up.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/cpuid.c            | 8 ++------
>  arch/x86/kvm/x86.c              | 2 --
>  3 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7cd68d1d0627..34a05ca3c904 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -654,7 +654,6 @@ struct kvm_vcpu_arch {
>  
>  	u64 xcr0;
>  	u64 guest_supported_xcr0;
> -	u32 guest_xstate_size;
>  
>  	struct kvm_pio_request pio;
>  	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6828be99b908..f3eb4f171d3d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -84,15 +84,11 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
> -	if (!best) {
> +	if (!best)
>  		vcpu->arch.guest_supported_xcr0 = 0;
> -		vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
> -	} else {
> +	else
>  		vcpu->arch.guest_supported_xcr0 =
>  			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
> -		vcpu->arch.guest_xstate_size = best->ebx =
> -			xstate_required_size(vcpu->arch.xcr0, false);
> -	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
>  	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 856b6fc2c2ba..7cd51a3acc43 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9358,8 +9358,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	}
>  	fx_init(vcpu);
>  
> -	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
> -
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>  
>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

