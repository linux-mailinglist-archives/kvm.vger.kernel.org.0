Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF743A6845
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhFNNqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:46:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233390AbhFNNqx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 09:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623678290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lrIwXDeHLLQ2dpMrbw5IZ7PKfiFZNvx91zdI2k8RLy8=;
        b=FWhpvryItpyViVV4EXmWA/cKjMgWvUjJMwU2lLFcINW/NKkMne5Z8oRqnxjVoalwxfLtG7
        +BUG3H8Sxz45Y0C82lapSQqD8s0SXocBU6q297a7gFfIyLIytYfMlQpRJWkrHigarLqPAx
        UK05bId4uAplsi8NuhetPp5p3IVghF8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-i9qnpyu5OB-HhNavTxwnqA-1; Mon, 14 Jun 2021 09:44:49 -0400
X-MC-Unique: i9qnpyu5OB-HhNavTxwnqA-1
Received: by mail-wm1-f70.google.com with SMTP id a19-20020a1c98130000b02901960b3b5621so2724393wme.8
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 06:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lrIwXDeHLLQ2dpMrbw5IZ7PKfiFZNvx91zdI2k8RLy8=;
        b=IM9EJl5Zi4wS9aIz2ucuyCWvBJx/dsQdqlJWX81RiM0+qX31hxpD1Mp6oE4taz6d2E
         NQEZWIpTXA1Yasv2XjBr7Uzht+oxlP7Ds3YpnKRvpwl6PAENkBnbzc3/I7fGG9B3anmc
         wh4SfSAzf+oUw89lBm4EfJJnE/4GEKdal4+546o5bsXRmk/0X5itdgfbr2UK4+QPTER/
         Zbx0eC6SfSTd6o9ZSmASNvZa1URM6ynIjSib8+MyemdDHMDEdOEJAht4I6LVKCY1NGBV
         m7fg8VUivAXdy9SHQ/R4+sRN1Rne5A/tmifThuki0zxgkY5kWHJwhh5Oy035k8Y9AQc8
         rsXQ==
X-Gm-Message-State: AOAM5307lwz1uZlv1GppJpTNOC0K5nGDuogqZUEG8qpO70lqzMeleiR0
        VHaJZBRpIoIGrIG17gBruiRwdpBtbomY122a7IbIaD3E2reAwBKb131pVxqu05w7xP52oHvkaKo
        XyftsICSdlJhY
X-Received: by 2002:a1c:f206:: with SMTP id s6mr16351318wmc.102.1623678285247;
        Mon, 14 Jun 2021 06:44:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFXrW+YbfMtfgwKXb7OxONoQUWezJP1D2Ith4tIayhYHEhRZ9UZdTJKdX2jlwWnzIBZZCPAA==
X-Received: by 2002:a1c:f206:: with SMTP id s6mr16351304wmc.102.1623678285091;
        Mon, 14 Jun 2021 06:44:45 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c66ca.dip0.t-ipconnect.de. [91.12.102.202])
        by smtp.gmail.com with ESMTPSA id o7sm17627580wro.76.2021.06.14.06.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 06:44:44 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] KVM: s390: prepare for hugepage vmalloc
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-mm@kvack.org, Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20210614132357.10202-1-imbrenda@linux.ibm.com>
 <20210614132357.10202-3-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <fef95723-2966-fb5e-04b4-1f5023d4a0af@redhat.com>
Date:   Mon, 14 Jun 2021 15:44:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210614132357.10202-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.06.21 15:23, Claudio Imbrenda wrote:
> The Create Secure Configuration Ultravisor Call does not support using
> large pages for the virtual memory area. This is a hardware limitation.
> 
> This patch replaces the vzalloc call with an almost equivalent call to
> the newly introduced vmalloc_no_huge function, which guarantees that
> only small pages will be used for the backing.
> 
> The new call will not clear the allocated memory, but that has never
> been an actual requirement.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Acked-by: Nicholas Piggin <npiggin@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>   arch/s390/kvm/pv.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 813b6e93dc83..c8841f476e91 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -140,7 +140,12 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>   	/* Allocate variable storage */
>   	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
>   	vlen += uv_info.guest_virt_base_stor_len;
> -	kvm->arch.pv.stor_var = vzalloc(vlen);
> +	/*
> +	 * The Create Secure Configuration Ultravisor Call does not support
> +	 * using large pages for the virtual memory area.
> +	 * This is a hardware limitation.
> +	 */
> +	kvm->arch.pv.stor_var = vmalloc_no_huge(vlen);
>   	if (!kvm->arch.pv.stor_var)
>   		goto out_err;
>   	return 0;
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

