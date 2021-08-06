Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944603E241C
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242357AbhHFHam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:30:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243735AbhHFHaY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 03:30:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628235008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/BY4t2yJmbfSKPEbLTSJy0hz6AF9n9YxHRdnbcJfERs=;
        b=PG6de9EhBxK1AE2sc8KHRitI60fKGswiN93ednOY+b97Kdb9wD9d4MEfStaJL+82g0N4Tz
        HCz0Ohm8GWSu5tlAWDa/3koMAecMsEf05gBF4NX2wUYAQ4ozxlz+lT+T6CeCh+g4glDq7P
        3GnmdAuP5DXSKSsqp7zZrWiWk2OoEFA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-R2qV_SvnO9ON450s0n1MFQ-1; Fri, 06 Aug 2021 03:30:06 -0400
X-MC-Unique: R2qV_SvnO9ON450s0n1MFQ-1
Received: by mail-wr1-f69.google.com with SMTP id o10-20020a5d684a0000b0290154758805bcso2836410wrw.3
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 00:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/BY4t2yJmbfSKPEbLTSJy0hz6AF9n9YxHRdnbcJfERs=;
        b=UpnDvZNXq15xAbjlvyTLMZb3wW3e3wEBCUPUtSUomXMVjbu7rhv/EKVZOj4qUAOgqD
         /t5+Iwheygg2jCcmNEpIYebcfO515lACQLzTyj9RfqH+0yd/z/Ei2x/InDEmKSBHbLcd
         UWPZZY0tRhPN8bMwD3za9bJnJi7yNapkxs0ikmGWAHNovxt1hWzY2gWIZV0I4aEK3fRG
         nMKtU6R8ii7mbuxJhGMnZ0ABPkQIM5EhzQSw/akpz2qY+F4voPzJTDM9hAjzgEmNVGb4
         pXcQJzbLhDliY7tqGKeU4cG8BRk776BbhiOfxp0/XU9AqPV2C6DcZJYlOv293+mKyYIo
         P22g==
X-Gm-Message-State: AOAM530W049Sb4u6HnPRZJnyZaHK/LlXz/HDtvfaDn71Cu5vXZcH4oXI
        EyYfEauPkNV18MF8GKkDsbMi3ds2yF3FvXndZztrXs6juHZcM68nzAI7tg83tvoXL9W30XN3Yh0
        UtRln7Ut9P5eQ
X-Received: by 2002:a05:600c:3b94:: with SMTP id n20mr1781097wms.54.1628235005748;
        Fri, 06 Aug 2021 00:30:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVZHZyH4+bvjg65UxBPJGLejAZAJ2Ik8iYydKdbU4cBd0fD679iDO5ATxjE2sOFL4jRsl9dA==
X-Received: by 2002:a05:600c:3b94:: with SMTP id n20mr1781075wms.54.1628235005511;
        Fri, 06 Aug 2021 00:30:05 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6104.dip0.t-ipconnect.de. [91.12.97.4])
        by smtp.gmail.com with ESMTPSA id b6sm10178492wrn.9.2021.08.06.00.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 00:30:05 -0700 (PDT)
Subject: Re: [PATCH v3 02/14] KVM: s390: pv: avoid stall notifications for
 some UVCs
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
 <20210804154046.88552-3-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <7ef282bb-d90f-9cbb-678b-4293790fb8c6@redhat.com>
Date:   Fri, 6 Aug 2021 09:30:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804154046.88552-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.08.21 17:40, Claudio Imbrenda wrote:
> Improve make_secure_pte to avoid stalls when the system is heavily
> overcommitted. This was especially problematic in kvm_s390_pv_unpack,
> because of the loop over all pages that needed unpacking.
> 
> Also fix kvm_s390_pv_init_vm to avoid stalls when the system is heavily
> overcommitted.

I suggest splitting this change into a separate patch and adding a bit 
more meat to the description why using the other variant is possible in 
the called context. I was kind of surprise to find that change buried in 
this patch.

Then, you can give both patches a more descriptive patch subject.

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
> ---
>   arch/s390/kernel/uv.c | 29 +++++++++++++++++++++++------
>   arch/s390/kvm/pv.c    |  2 +-
>   2 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index aeb0a15bcbb7..68a8fbafcb9c 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -180,7 +180,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>   {
>   	pte_t entry = READ_ONCE(*ptep);
>   	struct page *page;
> -	int expected, rc = 0;
> +	int expected, cc = 0;
>   
>   	if (!pte_present(entry))
>   		return -ENXIO;
> @@ -196,12 +196,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>   	if (!page_ref_freeze(page, expected))
>   		return -EBUSY;
>   	set_bit(PG_arch_1, &page->flags);
> -	rc = uv_call(0, (u64)uvcb);
> +	/*
> +	 * If the UVC does not succeed or fail immediately, we don't want to
> +	 * loop for long, or we might get stall notifications.
> +	 * On the other hand, this is a complex scenario and we are holding a lot of
> +	 * locks, so we can't easily sleep and reschedule. We try only once,
> +	 * and if the UVC returned busy or partial completion, we return
> +	 * -EAGAIN and we let the callers deal with it.
> +	 */
> +	cc = __uv_call(0, (u64)uvcb);
>   	page_ref_unfreeze(page, expected);
> -	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
> -	if (rc)
> -		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> -	return rc;
> +	/*
> +	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
> +	 * If busy or partially completed, return -EAGAIN.
> +	 */
> +	if (cc == UVC_CC_OK)
> +		return 0;
> +	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
> +		return -EAGAIN;
> +	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
>   }

That looks conceptually like the right thing to me.

-- 
Thanks,

David / dhildenb

