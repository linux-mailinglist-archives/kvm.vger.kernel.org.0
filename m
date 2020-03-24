Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A52190C50
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgCXLUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:20:37 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:24810 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727213AbgCXLUh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 07:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585048835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXT0D7cY7bPYe0yb02QZeAQZaimZpE2z4zLSjjcJk1w=;
        b=Mf0jugLqwrHFvXCFXVb4xDV79dDOat92x2vGuIqy+SLUiLb1VD+Qm+GUiZ45DA9Y1bbOZ3
        rimfwinMLYaI17OsMm98JRV2oMjL/9Ez46yxCg/wESyhAAFq5NJRBlU4+CIsMERaNBL8ho
        BwAHXTuQ11Jo7rXYgdeCvl4cjB0gfvw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-8b94l8QmMnCAP5qs51hhAQ-1; Tue, 24 Mar 2020 07:20:34 -0400
X-MC-Unique: 8b94l8QmMnCAP5qs51hhAQ-1
Received: by mail-wm1-f70.google.com with SMTP id n188so1145498wmf.0
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rXT0D7cY7bPYe0yb02QZeAQZaimZpE2z4zLSjjcJk1w=;
        b=PR816POsjgaEgZUyc15Fc+ZH1zOVgvspZd/BkPA3xsljgqmfbu7xmX6cCAsbhS0DUa
         M1/BIvVvWrcokAE6apJYRB0uS2Xy+lTUw6/4R8/Lgc+ZGmPykq3eInIavbrG6GMArY5K
         fY7eX8MiPFa1EISmEIYnA26hRJJv+bA0WAHyMDr9MsevAATu775UEiiVYrnHtL66M1KD
         ewBvqrI8p0+Iff9GQbRq2Z8reLFqtVUMp4EQXjyD+TVxaeiM9cRr+pBKUvAqkHlip2Ix
         4PB17XesZtlUVVx7Mxb30jvb82OaIIIcyGcQZr9soPJTShvZWX3SFPDEKNPqrFQRx8K9
         r02Q==
X-Gm-Message-State: ANhLgQ3R5uv/32hi9zV1gwZU9YKGZtYJpZNmJlTLNd5U6WSiRPtR+0Gq
        bqD2NwqGI9eTFga9PHVX+ql1LqK/CPhof1M8gW1WxQnx4RWtSc6S+ZbGudOnbN1gVjxdVpn9hrm
        BAxk2mQ/RYij3
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr35434220wrh.311.1585048833267;
        Tue, 24 Mar 2020 04:20:33 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvfgvyMCNqRfS0Utl+oeBTEBfq98PbTEUj8aI5mL7xEtyh9/y9Q/2QJMVUHhBUl52/Oz1qc8Q==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr35434187wrh.311.1585048833009;
        Tue, 24 Mar 2020 04:20:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id u5sm21556158wrp.81.2020.03.24.04.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 04:20:32 -0700 (PDT)
Subject: Re: [PATCH v3 34/37] KVM: nVMX: Don't flush TLB on nested VMX
 transition
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-35-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4e2b2b82-278e-72d9-4db3-5047b678049c@redhat.com>
Date:   Tue, 24 Mar 2020 12:20:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200320212833.3507-35-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 22:28, Sean Christopherson wrote:
> Unconditionally skip the TLB flush triggered when reusing a root for a
> nested transition as nested_vmx_transition_tlb_flush() ensures the TLB
> is flushed when needed, regardless of whether the MMU can reuse a cached
> root (or the last root).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

So much for my WARN_ON. :)

Paolo

> ---
>  arch/x86/kvm/mmu/mmu.c    | 2 +-
>  arch/x86/kvm/vmx/nested.c | 6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 84e1e748c2b3..7b0fb7f2c24d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5038,7 +5038,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
>  						   execonly, level);
>  
> -	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false, true);
> +	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, true, true);
>  
>  	if (new_role.as_u64 == context->mmu_role.as_u64)
>  		return;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index db3ce8f297c2..92aab4166498 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1161,10 +1161,12 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
>  	}
>  
>  	/*
> -	 * See nested_vmx_transition_mmu_sync for details on skipping the MMU sync.
> +	 * Unconditionally skip the TLB flush on fast CR3 switch, all TLB
> +	 * flushes are handled by nested_vmx_transition_tlb_flush().  See
> +	 * nested_vmx_transition_mmu_sync for details on skipping the MMU sync.
>  	 */
>  	if (!nested_ept)
> -		kvm_mmu_new_cr3(vcpu, cr3, false,
> +		kvm_mmu_new_cr3(vcpu, cr3, true,
>  				!nested_vmx_transition_mmu_sync(vcpu));
>  
>  	vcpu->arch.cr3 = cr3;
> 

