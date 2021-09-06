Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6817C40195B
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 11:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbhIFKAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:00:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241713AbhIFKAj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630922374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ln+FhIjAOLIZcHHs/un/E8sHKq6ymUXIqYlk/ITlGRc=;
        b=QqDsdkVYcq4hJQIs1o5hHY5TZKnASKeXui0P1jTj8BrKOefwecfFMDcTLqHpQL2kj5WHem
        J7Z7JE96QDFDn5iZ5F57+h6ITVRn30Ymi7u+oqBbQU1XxgfvotYTxB3lGdGtVxhv+Ck9oh
        mN7ZNbxpSclGArDwIQioWbiC4akNIwY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-WwW9BdfyNgO0ffMckF_wbQ-1; Mon, 06 Sep 2021 05:59:33 -0400
X-MC-Unique: WwW9BdfyNgO0ffMckF_wbQ-1
Received: by mail-wm1-f69.google.com with SMTP id n16-20020a1c7210000000b002ea2ed60dc6so2014270wmc.0
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 02:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ln+FhIjAOLIZcHHs/un/E8sHKq6ymUXIqYlk/ITlGRc=;
        b=aoCz5R/LMZXprm9R+6IM6hlIM0Bs1UcVYjt3eiIEYVkNeJat73U15uMumH/OUFN7AV
         +ZQNeubjaexx6XkVicnWubiZMvyOjk3MLJCAZVJXmSBi3rBhM8Ms1znmUorPtdhvnr9H
         034y8ApMDwKraeJYPA84GgRvWzi19E/vhyIDOLU62KJJKVdFcHo/wHCmM1LTqVx14TAj
         na83AGoJsx3T2Uq60/IPmnK+g6FtGOmUNm7wtDi6UgYwPJ4PkQUAbSxlJMr8iRv7Lg7b
         JkY2zZ08jA3y/yHfaRoASuCyaMp65CFjNeGeoOFQeq1t8fib+ZZkyHLuwuGQoOCMi4E0
         vPmw==
X-Gm-Message-State: AOAM533oMOeVQS6tzjAIP7kCrRFGtxf+j8zX2x9T8rVcc2sUd+AWUDCJ
        Z3BtPW9hLUPIlelrLuruFBWBCxR8r9ZPvinsIRl5TGVxwrKCg9nAGfYRjNWMD0eldp9M+5qUCad
        VG774deYdg3sa
X-Received: by 2002:adf:910b:: with SMTP id j11mr12211457wrj.114.1630922372216;
        Mon, 06 Sep 2021 02:59:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiHIqaW9fHVOPDTeK3ozCBD7Ac3u998cfVAxT2DHj4q13ToXhlRK5OpfQFtpWeFDn+PILHXA==
X-Received: by 2002:adf:910b:: with SMTP id j11mr12211442wrj.114.1630922371995;
        Mon, 06 Sep 2021 02:59:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t7sm8226792wrq.90.2021.09.06.02.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 02:59:31 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Don't freak out if pml5_root is NULL on
 4-level host
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210824005824.205536-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <53b71fd5-a90d-ba61-0bbd-1fa3b2289fb8@redhat.com>
Date:   Mon, 6 Sep 2021 11:59:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824005824.205536-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/08/21 02:58, Sean Christopherson wrote:
> Include pml5_root in the set of special roots if and only if the host,
> and thus NPT, is using 5-level paging.  mmu_alloc_special_roots() expects
> special roots to be allocated as a bundle, i.e. they're either all valid
> or all NULL.  But for pml5_root, that expectation only holds true if the
> host uses 5-level paging, which causes KVM to WARN about pml5_root being
> NULL when the other special roots are valid.
> 
> The silver lining of 4-level vs. 5-level NPT being tied to the host
> kernel's paging level is that KVM's shadow root level is constant; unlike
> VMX's EPT, KVM can't choose 4-level NPT based on guest.MAXPHYADDR.  That
> means KVM can still expect pml5_root to be bundled with the other special
> roots, it just needs to be conditioned on the shadow root level.
> 
> Fixes: cb0f722aff6e ("KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host")
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4853c033e6ce..39c7b5a587df 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3548,6 +3548,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>   static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	bool need_pml5 = mmu->shadow_root_level > PT64_ROOT_4LEVEL;
>   	u64 *pml5_root = NULL;
>   	u64 *pml4_root = NULL;
>   	u64 *pae_root;
> @@ -3562,7 +3563,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>   	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
>   		return 0;
>   
> -	if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
> +	/*
> +	 * NPT, the only paging mode that uses this horror, uses a fixed number
> +	 * of levels for the shadow page tables, e.g. all MMUs are 4-level or
> +	 * all MMus are 5-level.  Thus, this can safely require that pml5_root
> +	 * is allocated if the other roots are valid and pml5 is needed, as any
> +	 * prior MMU would also have required pml5.
> +	 */
> +	if (mmu->pae_root && mmu->pml4_root && (!need_pml5 || mmu->pml5_root))
>   		return 0;
>   
>   	/*
> @@ -3570,7 +3578,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>   	 * bail if KVM ends up in a state where only one of the roots is valid.
>   	 */
>   	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root ||
> -			 mmu->pml5_root))
> +			 (need_pml5 && mmu->pml5_root)))
>   		return -EIO;
>   
>   	/*
> @@ -3586,7 +3594,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>   	if (!pml4_root)
>   		goto err_pml4;
>   
> -	if (mmu->shadow_root_level > PT64_ROOT_4LEVEL) {
> +	if (need_pml5) {
>   		pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>   		if (!pml5_root)
>   			goto err_pml5;
> 

Queued, thanks.

Paolo

