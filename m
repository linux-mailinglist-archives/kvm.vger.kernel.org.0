Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90204313A37
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 17:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhBHQ4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 11:56:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234534AbhBHQzb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 11:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612803243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mpKQMznskIi3xd4XqVYyI2LFxEbTfjM/cP6CMM6SQOg=;
        b=d2w+CDNfJVROZ/SHNtcK5NhCnZigOanEBeE+PVU023MkYIQ0KTX7sHlIga+dtuMv5Jy8y0
        Bnr+JGnapvx4607v9rGxgdT3ij5KSM8D1Dt9JES3npNBX9t73IxPZTsBIu+fZe4wQjkOZQ
        rn/RKuWV3OT3flByl8l3GQ3Je/aMBy4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-1IUEiPrAPtOSWMtd3wjCog-1; Mon, 08 Feb 2021 11:54:00 -0500
X-MC-Unique: 1IUEiPrAPtOSWMtd3wjCog-1
Received: by mail-wr1-f71.google.com with SMTP id l10so13627601wry.16
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 08:54:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mpKQMznskIi3xd4XqVYyI2LFxEbTfjM/cP6CMM6SQOg=;
        b=EJASfGGajVeg9Oz6cu1/F7Yyzp0O3gkV78fwzDHe6N7OVCljcU25kWMRv9eHvLssSs
         kWib2XidxXFMApVXs9W3yCIt7sFUYsNeU0QCAkWXq4+KZxETXYNfS+hiKQkRMxoB5ROS
         /O4xNB/qFjIBWNKF0A0DePXIITce5hXFnfRuOBwoDbPtzlf7w1heDn7MV0WrC468T4nq
         m84GDlmbLS+FwwXRIOcQdq9MvHJb6ZbAaBPnFoQT4yRbSkM0Am7N2O14wF0x2bX/zc/c
         +fCkRLS124hiNuqbRg1zlwaAXKfBhM8U2HdQzDgu6vnD0omUtCh8M2iJcGHJHyDBHkB7
         dl0Q==
X-Gm-Message-State: AOAM530BohBk8ZdS8INkO9kXv63xw+PbbTZGGF04DbQPOuNS3t4ZjEX3
        UqrkRoT4dpZYYjL8h53hjy2cxb6uhieXHMBLuVXOj4CkIgsTda5UDgq1eR/kjd7aN3G19rGqHhN
        ajr5eEp0qZb2R
X-Received: by 2002:adf:f18a:: with SMTP id h10mr20539785wro.299.1612803238731;
        Mon, 08 Feb 2021 08:53:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyC7yZtx0zmzU25QtL4DFvRA5vG2h2e+LjUBP2VpEPAtzjMnRkJwQ9BCEXF4w5AEFDn4Bds7g==
X-Received: by 2002:adf:f18a:: with SMTP id h10mr20539768wro.299.1612803238553;
        Mon, 08 Feb 2021 08:53:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z15sm28050792wrs.25.2021.02.08.08.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 08:53:57 -0800 (PST)
Subject: Re: [PATCH for 4.19] Fix unsynchronized access to sev members through
 svm_register_enc_region
To:     Peter Gonda <pgonda@google.com>, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210208164840.769333-1-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2654c1ab-0178-e980-8573-3893e0bbcd60@redhat.com>
Date:   Mon, 8 Feb 2021 17:53:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208164840.769333-1-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 17:48, Peter Gonda wrote:
> commit 19a23da53932bc8011220bd8c410cb76012de004 upstream.
> 
> Grab kvm->lock before pinning memory when registering an encrypted
> region; sev_pin_memory() relies on kvm->lock being held to ensure
> correctness when checking and updating the number of pinned pages.
> 
> Add a lockdep assertion to help prevent future regressions.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> V2
>   - Fix up patch description
>   - Correct file paths svm.c -> sev.c
>   - Add unlock of kvm->lock on sev_pin_memory error
> 
> V1
>   - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/
> 
> Message-Id: <20210127161524.2832400-1-pgonda@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 2b506904be02..93c89f1ffc5d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1830,6 +1830,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   	struct page **pages;
>   	unsigned long first, last;
>   
> +	lockdep_assert_held(&kvm->lock);
> +
>   	if (ulen == 0 || uaddr + ulen < uaddr)
>   		return NULL;
>   
> @@ -7086,12 +7088,21 @@ static int svm_register_enc_region(struct kvm *kvm,
>   	if (!region)
>   		return -ENOMEM;
>   
> +	mutex_lock(&kvm->lock);
>   	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>   	if (!region->pages) {
>   		ret = -ENOMEM;
> +		mutex_unlock(&kvm->lock);
>   		goto e_free;
>   	}
>   
> +	region->uaddr = range->addr;
> +	region->size = range->size;
> +
> +	mutex_lock(&kvm->lock);
> +	list_add_tail(&region->list, &sev->regions_list);
> +	mutex_unlock(&kvm->lock);
> +
>   	/*
>   	 * The guest may change the memory encryption attribute from C=0 -> C=1
>   	 * or vice versa for this memory range. Lets make sure caches are
> @@ -7100,13 +7111,6 @@ static int svm_register_enc_region(struct kvm *kvm,
>   	 */
>   	sev_clflush_pages(region->pages, region->npages);
>   
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
>   	return ret;
>   
>   e_free:
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

