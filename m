Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4583B1F46
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 19:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFWRQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 13:16:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhFWRQL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 13:16:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624468433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z78ec/g98BXKe06htANr2c/DYa/h7G3+QwLaaBhgeMg=;
        b=PrKmYdHch7zWnHA+bJhXIV/YsDsofwQ+2aZ3WapwjriIn6t5hfnzV8+wboslhNqSbfQAhk
        CQNtgwnPClvZr4Vt+LiFIAg1jxYEJfRgO4l5UJClY48kq2mQLdWF3wXsXC1FSMnNAsrvNt
        lsm2FJB3O1CF8ifTeuL//3xun2kt6pw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-jTS0vM9sPheODdfXqMrGeQ-1; Wed, 23 Jun 2021 13:13:52 -0400
X-MC-Unique: jTS0vM9sPheODdfXqMrGeQ-1
Received: by mail-ej1-f70.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso1243516ejp.3
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 10:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z78ec/g98BXKe06htANr2c/DYa/h7G3+QwLaaBhgeMg=;
        b=o8VVaUUMbTDP5vKiqdmU//X5aLjgTD1n/U0u95MaDwYMetPztNpRnc92v9k8QjqXJI
         R1NhfM01bljI3qqiTjsmFVCwZt+z78pabJ2A84Bh0xYTA2REuUewkJ81JWqGIqzs8/Rr
         hkhKf5NGuHEBdnikLvrrNDxWwhwT8dhQQ3c9mK2xUzoV7S2v7Om9NkyVFH30zECFLwwY
         ZKCyMz7/OppmWy8p+tEhfeOpiVFMunRl7flI4C3G+9WWMgrFVFiD4cF55CP4LkW/rcn0
         o9IHscXptCxqcCQKkGxh/SApGhM7uwLxgNU7Tjhfa8Si5pF29UGq9Xv4/7seFkcyqzow
         v4/g==
X-Gm-Message-State: AOAM531ted1OQ+mwE7KZZyqxYZSisNh+f4Klv2lnqHhHkT73wv2e7X6A
        7kTBbbZk6M334EpTQoQCCl9JSOqaDzI5Gi0A5aPD9fau7O/gdqr+DkTdm3XR7TjGW2kbchWdAfr
        sFextz/5Vjm8v
X-Received: by 2002:a17:906:c1d2:: with SMTP id bw18mr1097577ejb.123.1624468430923;
        Wed, 23 Jun 2021 10:13:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym0Tg6QclCCulk6ViohSKxfCSp3imk6kCnCvxSC4rXbibsXjj4upZA3C1TvWC6WGmOfQIbFQ==
X-Received: by 2002:a17:906:c1d2:: with SMTP id bw18mr1097550ejb.123.1624468430728;
        Wed, 23 Jun 2021 10:13:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s4sm360957edu.49.2021.06.23.10.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 10:13:50 -0700 (PDT)
Subject: Re: [PATCH 18/54] KVM: x86/mmu: Move nested NPT reserved bit
 calculation into MMU proper
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-19-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <61d6fa84-6bfa-ec40-cc8c-5d968ca39b1b@redhat.com>
Date:   Wed, 23 Jun 2021 19:13:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-19-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:57, Sean Christopherson wrote:
> Move nested NPT's invocation of reset_shadow_zero_bits_mask() into the
> MMU proper and unexport said function.  Aside from dropping an export,
> this is a baby step toward eliminating the call entirely by fixing the
> shadow_root_level confusion.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Extra points for adding a comment about why the heck it's there.

Paolo

> ---
>   arch/x86/kvm/mmu.h        |  3 ---
>   arch/x86/kvm/mmu/mmu.c    | 11 ++++++++---
>   arch/x86/kvm/svm/nested.c |  1 -
>   3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 4e926f4935b0..62844bacd13f 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -68,9 +68,6 @@ static __always_inline u64 rsvd_bits(int s, int e)
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>   
> -void
> -reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
> -
>   void kvm_init_mmu(struct kvm_vcpu *vcpu);
>   void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>   			     unsigned long cr4, u64 efer, gpa_t nested_cr3);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 02c54426e7a2..5a46a87b23b0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4212,8 +4212,8 @@ static inline u64 reserved_hpa_bits(void)
>    * table in guest or amd nested guest, its mmu features completely
>    * follow the features in guest.
>    */
> -void
> -reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
> +static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
> +					struct kvm_mmu *context)
>   {
>   	/*
>   	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
> @@ -4247,7 +4247,6 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
>   	}
>   
>   }
> -EXPORT_SYMBOL_GPL(reset_shadow_zero_bits_mask);
>   
>   static inline bool boot_cpu_is_amd(void)
>   {
> @@ -4714,6 +4713,12 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>   		 */
>   		context->shadow_root_level = new_role.base.level;
>   	}
> +
> +	/*
> +	 * Redo the shadow bits, the reset done by shadow_mmu_init_context()
> +	 * (above) may use the wrong shadow_root_level.
> +	 */
> +	reset_shadow_zero_bits_mask(vcpu, context);
>   }
>   EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
>   
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 33b2f9337e26..927e545591c3 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -110,7 +110,6 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
>   	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
>   	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
>   	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
> -	reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
>   	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
>   }
>   
> 

