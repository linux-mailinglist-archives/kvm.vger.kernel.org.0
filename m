Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A533376155
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 09:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbhEGHnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 03:43:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233978AbhEGHnv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 03:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620373371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vsa8eoRAU/op3poaE3LMiG1JCafOvgbDI+OB1GR9vsw=;
        b=SpNUf/P3VvlfEwkxirfYSL1UM4kdac8Jr9n/i9oezfvKJpsrHjKXCX7ebUwyHjyu57wYN4
        7TpyscWE02tyFpGdvOtltrOI86UOIgET9hxoKttqeE4vS94iYl36lgTQwyoYpjXj6EA+Ma
        Sxg7bSzmsg6tk14tHbyg5+keu4Tr+/Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-X_V5dXdROUGdwayGupIeWg-1; Fri, 07 May 2021 03:42:49 -0400
X-MC-Unique: X_V5dXdROUGdwayGupIeWg-1
Received: by mail-ed1-f69.google.com with SMTP id i19-20020a05640242d3b0290388cea34ed3so3994980edc.15
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 00:42:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vsa8eoRAU/op3poaE3LMiG1JCafOvgbDI+OB1GR9vsw=;
        b=ekGwyefF40LbveuJ78GzVjScSjE15WVUpvM2AnOrWVbwfD+wUb9/ru8Q+P1BLFQxxH
         knry2AArJRufGOMWQ9imNwfZABng+Ba2PHqIewRCWv66wnoQnDglXsyqDHOVGKU/Z/nd
         AO/E8suMBY7RDXSb9nEoaJRjvCWIJedypW6dSJgSIk0aartYoMq8lnonG6/lBwe6N+3R
         KyLHHHMO4HsnIAIs4TxpijZD3Bp3fKRjCnVTM8FtVqH8FBtY7r6oWPjB3ldTclsrMDjx
         qiXhUS/kztpHMVZ8mXeilsvgjMHcyaTzEgfJ5+2zr2ziPJUU+yi2Qnfz6kkrfjK3gYtl
         LhyQ==
X-Gm-Message-State: AOAM532iRWhZvYyWzq5Rz/HKgmE6CLe1PLhJ8XOYh9w3IkRizxDwJZiT
        LlpchanZWCS3oM0OLX1vknC211/R3Ci0csYroH+RvNP7P52NihDc2TPrv/RlOM2Fg8XbR0nC2WW
        PpaxE75oD70Bk
X-Received: by 2002:aa7:ccc4:: with SMTP id y4mr9565497edt.171.1620373368582;
        Fri, 07 May 2021 00:42:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4lQAaBrROI5moPobb0YQwseMCoxa7a0OaL+tWl07rMAc+ZBwZGj8pu8eJHfR3ilJxTw0IZQ==
X-Received: by 2002:aa7:ccc4:: with SMTP id y4mr9565484edt.171.1620373368429;
        Fri, 07 May 2021 00:42:48 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c63c0.dip0.t-ipconnect.de. [91.12.99.192])
        by smtp.gmail.com with ESMTPSA id r16sm3555325edq.87.2021.05.07.00.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:42:48 -0700 (PDT)
Subject: Re: [PATCH v3 1/8] KVM: x86/mmu: Deduplicate rmap freeing
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-2-bgardon@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <97d6a7da-2777-293a-4dab-668fe16dc2e9@redhat.com>
Date:   Fri, 7 May 2021 09:42:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506184241.618958-2-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.05.21 20:42, Ben Gardon wrote:
> Small code deduplication. No functional change expected.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/x86.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf3b67679cf0..5bcf07465c47 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10818,17 +10818,23 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_hv_destroy_vm(kvm);
>   }
>   
> -void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> +static void free_memslot_rmap(struct kvm_memory_slot *slot)
>   {
>   	int i;
>   
>   	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
>   		kvfree(slot->arch.rmap[i]);
>   		slot->arch.rmap[i] = NULL;
> +	}
> +}
>   
> -		if (i == 0)
> -			continue;
> +void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> +{
> +	int i;
> +
> +	free_memslot_rmap(slot);
>   
> +	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
>   		kvfree(slot->arch.lpage_info[i - 1]);
>   		slot->arch.lpage_info[i - 1] = NULL;
>   	}
> @@ -10894,12 +10900,9 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>   	return 0;
>   
>   out_free:
> -	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> -		kvfree(slot->arch.rmap[i]);
> -		slot->arch.rmap[i] = NULL;
> -		if (i == 0)
> -			continue;
> +	free_memslot_rmap(slot);
>   
> +	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
>   		kvfree(slot->arch.lpage_info[i - 1]);
>   		slot->arch.lpage_info[i - 1] = NULL;
>   	}
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

