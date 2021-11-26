Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D836945F25D
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 17:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhKZQud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 11:50:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354878AbhKZQsb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 11:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637945118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fWhj8Ei8VNBGMV1RUlYTd0W4q8HWoUTqSuYcyOuxPvQ=;
        b=ewQfN/GuG/ZAasj5jXzlIuf2BXx2YuTZP6m9rgV1KPNjOxgwroMbwCPQ9Dn5zoHpqFL4o+
        enTteBw0JiKmrCD0g3yhjQZR+wQhAcuB3z0msO1ndTt9bkjlsKDHSjv/U2RCqv39Z4Stxi
        mKlqfEQkWilH1+jyak3uMuwMb2ZsNS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-4a39x2c-P3OcLNLz6bI1sA-1; Fri, 26 Nov 2021 11:45:17 -0500
X-MC-Unique: 4a39x2c-P3OcLNLz6bI1sA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E960A1808321;
        Fri, 26 Nov 2021 16:45:15 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0492F67840;
        Fri, 26 Nov 2021 16:45:11 +0000 (UTC)
Message-ID: <1f9722a5-9f8f-415f-88c7-29cee05831d0@redhat.com>
Date:   Fri, 26 Nov 2021 17:45:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU
 notifier unmapping
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211120015008.3780032-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211120015008.3780032-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 02:50, Sean Christopherson wrote:
> Use the yield-safe variant of the TDP MMU iterator when handling an
> unmapping event from the MMU notifier, as most occurences of the event
> allow yielding.
> 
> Fixes: e1eed5847b09 ("KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 377a96718a2e..a29ebff1cfa0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1031,7 +1031,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>   {
>   	struct kvm_mmu_page *root;
>   
> -	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
>   		flush |= zap_gfn_range(kvm, root, range->start, range->end,
>   				       range->may_block, flush, false);
>   
> 

Queued, thanks.

Paolo

