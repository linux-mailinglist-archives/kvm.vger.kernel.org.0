Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D479455E6A
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhKROqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:46:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhKROqd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637246613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U2HTpEJGA8kCZGKGmh2ShVUAanB3gLtGDWTV2flej/k=;
        b=gZDmteR2boLBkw01WWzstxNXaFLf5ezVzE31BtXv4Tok7Wyb3/rfJHYD0wXHud4UXKlUyA
        5oiD3654frsrMUYGFfai/T8eIAfLCDZW+YJsia+IUU7nCRFs75c9oBYOw6Ltub6uFBreri
        qxAaQgByL5MKToaDukU6A0b7BodeWzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-nRDX9vYTPQm1Z88OKetB9Q-1; Thu, 18 Nov 2021 09:43:30 -0500
X-MC-Unique: nRDX9vYTPQm1Z88OKetB9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85D73100D0DB;
        Thu, 18 Nov 2021 14:43:28 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EE985C1D5;
        Thu, 18 Nov 2021 14:43:26 +0000 (UTC)
Message-ID: <350b8c9b-c672-d6e2-a7a9-bf7c01699a8e@redhat.com>
Date:   Thu, 18 Nov 2021 15:43:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln
 register
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211118130320.95997-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211118130320.95997-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 14:03, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> If we run the following perf command in an AMD Milan guest:
> 
>    perf stat \
>    -e cpu/event=0x1d0/ \
>    -e cpu/event=0x1c7/ \
>    -e cpu/umask=0x1f,event=0x18e/ \
>    -e cpu/umask=0x7,event=0x18e/ \
>    -e cpu/umask=0x18,event=0x18e/ \
>    ./workload
> 
> dmesg will report a #GP warning from an unchecked MSR access
> error on MSR_F15H_PERF_CTLx.
> 
> This is because according to APM (Revision: 4.03) Figure 13-7,
> the bits [35:32] of AMD PerfEvtSeln register is a part of the
> event select encoding, which extends the EVENT_SELECT field
> from 8 bits to 12 bits.
> 
> Opportunistically update pmu->reserved_bits for reserved bit 19.
> 
> Reported-by: Jim Mattson <jmattson@google.com>
> Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/svm/pmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 871c426ec389..b4095dfeeee6 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -281,7 +281,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>   		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
>   
>   	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
> -	pmu->reserved_bits = 0xffffffff00200000ull;
> +	pmu->reserved_bits = 0xfffffff000280000ull;
>   	pmu->version = 1;
>   	/* not applicable to AMD; but clean them to prevent any fall out */
>   	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
> 

Queued, thanks.

