Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A9D367ABD
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhDVHPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhDVHPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 03:15:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619075673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IogrsY3cJq5WADFY6TutrJbboIoUZaCtFj92TrOe82w=;
        b=J3jzp5wdoQHxRlndZwT2GDzwZ479QpimAQzyJyB1otEUKe0mgzKJzkbyNoNnb1pcw2pga+
        EQ9lnrg8MW2ByQPLsILXa9Znh2/DdFe/tWljV8Z1crp66DXU+Ox0apNmBbcTy50AiiE8EM
        C4xd3Dkxpgj3vKhPyXaT6RvxhyQSMzc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-hBgKJWKkPtKycDfry6eFyg-1; Thu, 22 Apr 2021 03:14:31 -0400
X-MC-Unique: hBgKJWKkPtKycDfry6eFyg-1
Received: by mail-ej1-f72.google.com with SMTP id lf6-20020a1709071746b029037cee5e31c4so6852000ejc.13
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 00:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IogrsY3cJq5WADFY6TutrJbboIoUZaCtFj92TrOe82w=;
        b=eDzxFTtI5IyirmDWOU0PhABbPELDZHKFryfSJGW6CoftmR2oPtolYRIclv+Ua59rGb
         c1qSnwT2L6Wkzr44qY+O7vY4+f4hKjs0k49sPn60/hizBG8HqWGGBT3c/evRKcr+X/4u
         pfrRwUCcUpJUX/oUsBZSppdu4/3EK7mF5QKfHMfePcyKwAVkegAQ+UxNCTw10YQE7O52
         +e27kpbi6QqEditkX2TyNMqKBH++XOy5sdiyWZ3ZqT+NaWeFN2GRqB9i59EQeIwxIGjU
         7GuEajhxyqZXn5Fbuwq890tcLxXWLXepGmdYqxLJL3AX32k+FBgJWRG7hmkwIboyX5N6
         6uAA==
X-Gm-Message-State: AOAM530rba4tBT0KCkdOBn3QnHj3zz9xQ9xPjF2X27bsyP4dnG2mo3Cu
        x6UCo3mAJZRBnQvyrguNy+TxOpaLSkj2BI7UGNR7ofDSowSeehQOZcI//nvuSNeglB17gHxRBra
        jt0Yy1SK6xRhL
X-Received: by 2002:a17:906:cc48:: with SMTP id mm8mr1958961ejb.58.1619075668623;
        Thu, 22 Apr 2021 00:14:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwip4qdfn29LT5Urrukkg+Xlat6rXN10GBboYd0g+NCnt5pXUXcX3xQ7cHMVL1uQIIrAYE2ng==
X-Received: by 2002:a17:906:cc48:: with SMTP id mm8mr1958936ejb.58.1619075668395;
        Thu, 22 Apr 2021 00:14:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q12sm1236568ejy.91.2021.04.22.00.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 00:14:27 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wei Huang <wei.huang2@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210422021125.3417167-1-seanjc@google.com>
 <20210422021125.3417167-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 03/15] KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
Message-ID: <5e8a2d7d-67de-eef4-ab19-33294920f50c@redhat.com>
Date:   Thu, 22 Apr 2021 09:14:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422021125.3417167-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 04:11, Sean Christopherson wrote:
> Disable SEV and SEV-ES if NPT is disabled.  While the APM doesn't clearly
> state that NPT is mandatory, it's alluded to by:
> 
>    The guest page tables, managed by the guest, may mark data memory pages
>    as either private or shared, thus allowing selected pages to be shared
>    outside the guest.
> 
> And practically speaking, shadow paging can't work since KVM can't read
> the guest's page tables.
> 
> Fixes: e9df09428996 ("KVM: SVM: Add sev module_param")
> Cc: Brijesh Singh <brijesh.singh@amd.com
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 30 +++++++++++++++---------------
>   1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fed153314aef..0e8489908216 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -970,7 +970,21 @@ static __init int svm_hardware_setup(void)
>   		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>   	}
>   
> -	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
> +	/*
> +	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
> +	 * NPT isn't supported if the host is using 2-level paging since host
> +	 * CR4 is unchanged on VMRUN.
> +	 */
> +	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
> +		npt_enabled = false;

Unrelated, but since you're moving this code: should we be pre-scient 
and tackle host 5-level paging as well?

Support for 5-level page tables on NPT is not hard to fix and could be 
tested by patching QEMU.  However, the !NPT case would also have to be 
fixed by extending the PDP and PML4 stacking trick to a PML5.

However, without real hardware to test on I'd be a bit wary to do it. 
Looking at 5-level EPT there might be other issues (e.g. what's the 
guest MAXPHYADDR) and I would prefer to see what AMD comes up with 
exactly in the APM.  So I would just block loading KVM on hypothetical 
AMD hosts with CR4.LA57=1.

Paolo

> +	if (!boot_cpu_has(X86_FEATURE_NPT))
> +		npt_enabled = false;
> +
> +	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
> +	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
> +
> +	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev && npt_enabled) {
>   		sev_hardware_setup();
>   	} else {
>   		sev = false;
> @@ -985,20 +999,6 @@ static __init int svm_hardware_setup(void)
>   			goto err;
>   	}
>   
> -	/*
> -	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
> -	 * NPT isn't supported if the host is using 2-level paging since host
> -	 * CR4 is unchanged on VMRUN.
> -	 */
> -	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
> -		npt_enabled = false;
> -
> -	if (!boot_cpu_has(X86_FEATURE_NPT))
> -		npt_enabled = false;
> -
> -	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
> -	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
> -
>   	if (nrips) {
>   		if (!boot_cpu_has(X86_FEATURE_NRIPS))
>   			nrips = false;
> 

