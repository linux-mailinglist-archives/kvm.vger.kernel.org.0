Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E783ABA4B
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 19:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhFQRMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 13:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230028AbhFQRMu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Jun 2021 13:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623949842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gkrtd4zlmynN9eouBHUbPWTXmyAYZ9OeNLaj/f5dRaA=;
        b=UHKEh5857kiWmSTk3xmlWswZroyU5uiL78GZmdEdZUZUufAI4GLc/0oko4mtb93NVfLhGo
        F6jCzdJpWSbQ7A+UmT//xa2mVCpRW6/CCHgh6Br/ROOoVuFr2Y4a5vreSdZorrQVIc1YtY
        GoyZOyxkEIQ4wc2tqv+cU7Eu3dNqSRw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-Wq647H83OoWKKoIUZy_jCA-1; Thu, 17 Jun 2021 13:10:41 -0400
X-MC-Unique: Wq647H83OoWKKoIUZy_jCA-1
Received: by mail-ej1-f70.google.com with SMTP id p5-20020a17090653c5b02903db1cfa514dso2554516ejo.13
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 10:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gkrtd4zlmynN9eouBHUbPWTXmyAYZ9OeNLaj/f5dRaA=;
        b=UwQyMg7CBLZ3W1OnUM1cNs5lx3Nlmw9MHtRNc8vnOoKXndC3ZRNxVVYkE2ah29fLt3
         HBYsnKB5/B9Z+AhvM9OiPExH5zGCXt1Uh4ejv5/O5Ehs1DfJmQGNx6JmUSK1EUM4xrGp
         ceKVohjc3uoridI/spIZtc78yekMl7umktRpqc/C3tT/88h8CbNcHR6eufaMXknsonnj
         qBlmIjYGjmGMXirmIwz4nfQyfzgFsB40s+rJQ8jbjWDVV8zGUTgLcvRbNNCOS8LKQxpz
         jebGac+RMVULx2M9jyY4+m18MSLbyV1S+CbMo3tazpQ0yhhsGBVaso/xwZAhnN4KfYgl
         ZXlA==
X-Gm-Message-State: AOAM533WsNWL3pyh0QPo0LDQtaHTlwWkIMxRUNBd+1YWu4cF/+Rld/9y
        gTYd+jzAz6qg32DjkyxP/gvvil3Kyn1NNDHy8v2kaNuITOeH18YjHQ/WPq0muKIB8TCwESrwKVW
        ytA7nsDzzQ/ah
X-Received: by 2002:a50:ce0b:: with SMTP id y11mr8287087edi.356.1623949840097;
        Thu, 17 Jun 2021 10:10:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxgrjNFCkVJDmMzw18MmfhTo25hKFgmRgXcrXL1uqSbTO766v4CAqIwKN4rNXnV4svQSLmNQ==
X-Received: by 2002:a50:ce0b:: with SMTP id y11mr8287058edi.356.1623949839922;
        Thu, 17 Jun 2021 10:10:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v8sm4753484edc.59.2021.06.17.10.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 10:10:39 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Grab nx_lpage_splits as an unsigned long
 before division
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210615162905.2132937-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <53476904-08ce-63ec-3842-9443a92550db@redhat.com>
Date:   Thu, 17 Jun 2021 19:10:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210615162905.2132937-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/21 18:29, Sean Christopherson wrote:
> Snapshot kvm->stats.nx_lpage_splits into a local unsigned long to avoid
> 64-bit division on 32-bit kernels.  Casting to an unsigned long is safe
> because the maximum number of shadow pages, n_max_mmu_pages, is also an
> unsigned long, i.e. KVM will start recycling shadow pages before the
> number of splits can exceed a 32-bit value.
> 
>    ERROR: modpost: "__udivdi3" [arch/x86/kvm/kvm.ko] undefined!
> 
> Fixes: 7ee093d4f3f5 ("KVM: switch per-VM stats to u64")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 720ceb0a1f5c..7d3e57678d34 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6043,6 +6043,7 @@ static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel
>   
>   static void kvm_recover_nx_lpages(struct kvm *kvm)
>   {
> +	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
>   	int rcu_idx;
>   	struct kvm_mmu_page *sp;
>   	unsigned int ratio;
> @@ -6054,7 +6055,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>   	write_lock(&kvm->mmu_lock);
>   
>   	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> -	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
> +	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
>   	for ( ; to_zap; --to_zap) {
>   		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
>   			break;
> 

Queued, thanks.

Paolo

