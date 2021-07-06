Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED10C3BD94A
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhGFPBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 11:01:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231460AbhGFPBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 11:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625583543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HtdLqklHsoLBXRELRriccQVwitUFMwKVNw1+U6rtTks=;
        b=bzcXlcghSjCwaIRaRMjiXVMMtgnt7/Wpixb39SIg2F2MV7/htXny0HhqFwG7Ek24MpSECn
        PlvpYLQroD9VC0IwhsxhsD9Iave47+acy//VYG70zx3LhfDQC9R+vnFjQm3o8xBAxqFwJd
        gcuLIYd/zTT1YZqGllzBTJXhoH5THxw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-5XaQh-H9M_aY25wQvm3Oxw-1; Tue, 06 Jul 2021 10:59:02 -0400
X-MC-Unique: 5XaQh-H9M_aY25wQvm3Oxw-1
Received: by mail-wm1-f69.google.com with SMTP id i3-20020a05600c3543b02902075ed92710so1215312wmq.0
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HtdLqklHsoLBXRELRriccQVwitUFMwKVNw1+U6rtTks=;
        b=rS1eYFK9qdTNf5tjArtKtPXwzWdQmkdL1vXfWqyP98BrNcMJErs6aTtKEO3j0FSneF
         6CWZvZLa9dOFmd8fpKH8AeTbP5wxkmA/VKULMNzBIFpNu/+HXsO2Ys3GSEW/bNziVJbL
         cm6Ksgb7zWUtoljg2VVgtBgLe+XU9FGYZHIzOGa6TsjsYS8d3X/9lQgicDfoWmYgmnz2
         nWU59muONse9pDft/lLThEpo8mZNZT8+Brgbqfwqa8RhHZwbvd9oNYG/1GqVveqRb+ke
         f0OKlLEVkOgPYEZgJy+sC9OtMYXRWly+ztPRi8mg197hSc15zw1R26WWWNa9d/yMnvNv
         x19w==
X-Gm-Message-State: AOAM530VyvY3fx6YjenBNktQ/lSQHgARDD8PPicJTxbBfE/JPFAJ02bz
        LHuhOC97KfS4yMr3jUBLu6Ox1F6BzvDxGo/l/GUB7XyLugdg2TLAP9vek4qPfElv7+f5nAfYSQe
        7kIEj+ddmb23s
X-Received: by 2002:adf:e8cc:: with SMTP id k12mr22195880wrn.163.1625583541110;
        Tue, 06 Jul 2021 07:59:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEgoAjZmw/OcN/il/ceXOHFRuiFIP5zNfrrYHLBV6lvPen8OjKMeb00T6xLWwvujfJJ6fI3Q==
X-Received: by 2002:adf:e8cc:: with SMTP id k12mr22195862wrn.163.1625583540944;
        Tue, 06 Jul 2021 07:59:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k14sm16117848wmr.29.2021.07.06.07.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:59:00 -0700 (PDT)
Subject: Re: [RFC PATCH v2 51/69] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <e2521b4c48c582260454764e84a057a2da99ac3c.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <89d1ff17-dc48-0f39-257a-4cf11a98f435@redhat.com>
Date:   Tue, 6 Jul 2021 16:58:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e2521b4c48c582260454764e84a057a2da99ac3c.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TODO: This is tentative patch.  Support large page and delete this patch.
> 
> Allow TDX to effectively disable large pages, as SEPT will initially
> support only 4k pages.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/mmu/mmu.c          | 4 +++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9631b985ebdc..a47e17892258 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -989,6 +989,7 @@ struct kvm_arch {
>   	unsigned long n_requested_mmu_pages;
>   	unsigned long n_max_mmu_pages;
>   	unsigned int indirect_shadow_pages;
> +	int tdp_max_page_level;
>   	u8 mmu_valid_gen;
>   	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>   	struct list_head active_mmu_pages;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 82db62753acb..4ee6d7803f18 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4084,7 +4084,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>   	kvm_pfn_t pfn;
>   	int max_level;
>   
> -	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
> +	for (max_level = vcpu->kvm->arch.tdp_max_page_level;
>   	     max_level > PG_LEVEL_4K;
>   	     max_level--) {
>   		int page_num = KVM_PAGES_PER_HPAGE(max_level);
> @@ -5802,6 +5802,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>   	node->track_write = kvm_mmu_pte_write;
>   	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>   	kvm_page_track_register_notifier(kvm, node);
> +
> +	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
>   }
>   
>   void kvm_mmu_uninit_vm(struct kvm *kvm)
> 

Seems good enough for now.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

