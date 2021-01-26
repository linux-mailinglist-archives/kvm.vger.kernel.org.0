Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22C5303FF7
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392714AbhAZOQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 09:16:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405631AbhAZOP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 09:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611670473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VDatwy9yr1egcmeaxWIyYl6nPc9FqgpaSNtd+mv8gY0=;
        b=cf7EpmXHP9qm3hsGYhriF4k+Oe0ZY2m4z20hp8Dxdz5x8vqFKsQhuqh6FqGHXzOEYoYWBD
        m+yy3wMmqrTKu2BC+sk2Sbe/QSnZ6Jhi3/NvJPcU2hG3AIn4kK2ky4DeTWkA9lYaYbh5gb
        G7Nda6trUO1R1+/INzkB5m0sXGOXKMk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-trTEjUT8MEuyB_gRYfLrgw-1; Tue, 26 Jan 2021 09:14:30 -0500
X-MC-Unique: trTEjUT8MEuyB_gRYfLrgw-1
Received: by mail-ed1-f72.google.com with SMTP id v19so1399768edx.22
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 06:14:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VDatwy9yr1egcmeaxWIyYl6nPc9FqgpaSNtd+mv8gY0=;
        b=UD3ecN31+QwQDpQHoFCcbSOrNc8lD30iKEumh7441uxJMlEIasdXuZEaLsrslIgBhP
         yWwe5Tze5f716YCDaxCaL2sbjJm5PnRkWeIVvYO8/osJ5CH+P+cBU7ckJ6fpponbhvSb
         9l29WYzz7LFqzU9jmA+9KCRf3tovFD+S5oNT6pGwmBCRmADrmaBQl2ZDOcRLoeha1wtp
         TAGemVEQ7YRW8k8koaVT1fdYDmNjFeHdJAHHty1H6PU9mHC6glnJRp+iPlUinrUxmKi/
         E/x8bwD7QDzrLJXzzhM6B+wiq3MVmkSUQXmwkjgotFrff4pYRvYVuDbO311L3UNsuuov
         Fxhw==
X-Gm-Message-State: AOAM530PpWngLL29tWvBjO0UFPIqjwkMYCrVrwLicDoFYynqYKPAuPLt
        s1h1asXDuYfyjQxOs8BsLQSATnhlt69m8ugtoXfhKVLLZ/bEDA7Ds0WnHlkNgN/HrpEqOqAK3x7
        zQc2076SutIDK
X-Received: by 2002:a17:906:af41:: with SMTP id ly1mr3418969ejb.491.1611670469049;
        Tue, 26 Jan 2021 06:14:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLZHvvd991wi5LSYomm6Tr/MOTO7vpWabw8m6oShLXFqGN22xFOyRlIE7vZuC2Ph16eIU8NQ==
X-Received: by 2002:a17:906:af41:: with SMTP id ly1mr3418953ejb.491.1611670468904;
        Tue, 26 Jan 2021 06:14:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p16sm12367785edw.44.2021.01.26.06.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 06:14:28 -0800 (PST)
Subject: Re: [PATCH 09/24] kvm: x86/mmu: Don't redundantly clear TDP MMU pt
 memory
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
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-10-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <48cafbae-3e73-d5ca-ddbc-13e1bbfafb2f@redhat.com>
Date:   Tue, 26 Jan 2021 15:14:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112181041.356734-10-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 19:10, Ben Gardon wrote:
> The KVM MMU caches already guarantee that shadow page table memory will
> be zeroed, so there is no reason to re-zero the page in the TDP MMU page
> fault handler.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Feiner <pfeiner@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 411938e97a00..55df596696c7 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -665,7 +665,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>   			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
>   			list_add(&sp->link, &vcpu->kvm->arch.tdp_mmu_pages);
>   			child_pt = sp->spt;
> -			clear_page(child_pt);
>   			new_spte = make_nonleaf_spte(child_pt,
>   						     !shadow_accessed_mask);
>   
> 

Queued, thanks.

Paolo

