Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E6030D68B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 10:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhBCJpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 04:45:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233135AbhBCJow (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 04:44:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612345406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8JlE3EMtIPG4yCYd+JdmIn+AhVOjwW2E0U1D9Qnw6LQ=;
        b=fi8SRjoTf88esqi5Iog2hXOBp8sF8wzuibrvOntX1BhugDiliFGlcA5RMwqYyPdsMZ/LN1
        OonDCQpBmfP0QifWlzbxWU0ScW3g4o6HI19DxzCUwYPEIY3IK5qcZmlbGHgOw04LVamIGg
        oVEixwP6pbbkC93/Iyu3pJwUQZMbBMk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-N1YhMLQLPVuaYo-rBBZfxw-1; Wed, 03 Feb 2021 04:43:22 -0500
X-MC-Unique: N1YhMLQLPVuaYo-rBBZfxw-1
Received: by mail-ed1-f69.google.com with SMTP id f21so11162781edx.23
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 01:43:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8JlE3EMtIPG4yCYd+JdmIn+AhVOjwW2E0U1D9Qnw6LQ=;
        b=Kil8LAE7dD3Ym8I3uqq+I8ePLv4F4d81YErDMzgoqWKekK03Z8NIFUByb+YY6lNS/v
         pmF0vQ2N9je8atNvUrBpoDDBHUjMx+S7t/xq7Xpuw5IO3G+EfkGFNZ+hp4Seapc7PbR7
         0SA7VTYrXJiRFh6WV62fSRqo9SKQngcXv+525LLrkayVbQCXyn2YQyeCz7wywI1ygc91
         smbAMcepM7TZKq5O3Rq4vk9SofoePzB7yfzCOEZbSd79qHNHE/qzW20hIfzCcmujRjAe
         DN4zOUNu10rPlzN2eJS6kqslT9SOc9WTcstcCmKAsuorJ61KO2s4aSmaXGVIcJlcXoXl
         1dlA==
X-Gm-Message-State: AOAM532WmNGa/sHNsBhsVZJvNn3p0DPIUrP6hHKVTJyZp5DEZI7DkBRg
        uZNWthw39JZSFCtTzKKl6IzFC4y6CMQGLspoJdKQJvwQ/2vE9UZC3m0NmyZz6/8rmCfCJS87rqH
        RHaA/F0udOGXI
X-Received: by 2002:a17:907:f81:: with SMTP id kb1mr2297885ejc.466.1612345401122;
        Wed, 03 Feb 2021 01:43:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyE4w0SXKWGuwkGTges5EuIVt6D0Y/P3+luaD05sg14cWZ/nhDE7xP9Qy9/NVNV/hAIky3YOg==
X-Received: by 2002:a17:907:f81:: with SMTP id kb1mr2297878ejc.466.1612345400921;
        Wed, 03 Feb 2021 01:43:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j23sm599190edv.45.2021.02.03.01.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 01:43:20 -0800 (PST)
Subject: Re: [PATCH v2 10/28] KVM: x86/mmu: Fix TDP MMU zap collapsible SPTEs
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-11-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dbb72860-3f3a-e1e7-361f-2961a5a526c1@redhat.com>
Date:   Wed, 3 Feb 2021 10:43:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202185734.1680553-11-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:57, Ben Gardon wrote:
> There is a bug in the TDP MMU function to zap SPTEs which could be
> replaced with a larger mapping which prevents the function from doing
> anything. Fix this by correctly zapping the last level SPTEs.
> 
> Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c3075fb568eb..e3066d08c1dc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1098,8 +1098,8 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
>   }
>   
>   /*
> - * Clear non-leaf entries (and free associated page tables) which could
> - * be replaced by large mappings, for GFNs within the slot.
> + * Clear leaf entries which could be replaced by large mappings, for
> + * GFNs within the slot.
>    */
>   static void zap_collapsible_spte_range(struct kvm *kvm,
>   				       struct kvm_mmu_page *root,
> @@ -1111,7 +1111,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>   
>   	tdp_root_for_each_pte(iter, root, start, end) {
>   		if (!is_shadow_present_pte(iter.old_spte) ||
> -		    is_last_spte(iter.old_spte, iter.level))
> +		    !is_last_spte(iter.old_spte, iter.level))
>   			continue;
>   
>   		pfn = spte_to_pfn(iter.old_spte);
> 

Queued for 5.11-rc, thanks.

Paolo

