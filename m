Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E7F454B49
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 17:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbhKQQtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 11:49:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238922AbhKQQtF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 11:49:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637167566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fhLSkq7C8N1ez43dYmKR5gusfkLEVqMLGom5ncEvLCA=;
        b=T2BJKNGzQxkXTHOQBx8L3qHNFvcqiiGe+aaapQm/xUui5/F/e4s20bpulP1S2kYrJRqRyQ
        7NDNVj9teaWE3MbZayVJ0eT9si+8wBgIt8vywoyM/YfBSxz3R1F1LwREGVzAnPt5CRhtbe
        teHfF0MVqOix5TIe8cfxzBOqAHKEycQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-FYk1g7h7M023ldpfNuw1uQ-1; Wed, 17 Nov 2021 11:46:01 -0500
X-MC-Unique: FYk1g7h7M023ldpfNuw1uQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D63B180DDEB;
        Wed, 17 Nov 2021 16:45:58 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD74F5D9DE;
        Wed, 17 Nov 2021 16:45:55 +0000 (UTC)
Message-ID: <d95f29e5-efef-4a58-420c-a446c3a684e9@redhat.com>
Date:   Wed, 17 Nov 2021 17:45:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Skip tlb flush if it has been done in
 zap_gfn_range()
Content-Language: en-US
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 10:20, Hou Wenlong wrote:
> If the parameter flush is set, zap_gfn_range() would flush remote tlb
> when yield, then tlb flush is not needed outside. So use the return
> value of zap_gfn_range() directly instead of OR on it in
> kvm_unmap_gfn_range() and kvm_tdp_mmu_unmap_gfn_range().
> 
> Fixes: 3039bcc744980 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---
>   arch/x86/kvm/mmu/mmu.c     | 2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4..d57319e596a9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1582,7 +1582,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
>   
>   	if (is_tdp_mmu_enabled(kvm))
> -		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
>   
>   	return flush;
>   }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c5dd83e52de..9d03f5b127dc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1034,8 +1034,8 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>   	struct kvm_mmu_page *root;
>   
>   	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
> -		flush |= zap_gfn_range(kvm, root, range->start, range->end,
> -				       range->may_block, flush, false);
> +		flush = zap_gfn_range(kvm, root, range->start, range->end,
> +				      range->may_block, flush, false);
>   
>   	return flush;
>   }
> 

Queued both, thanks.

Paolo

