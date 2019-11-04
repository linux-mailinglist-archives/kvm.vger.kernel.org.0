Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 103C8EDC18
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfKDKHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:07:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbfKDKHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 05:07:13 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB206C0568FA
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 10:07:12 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id c6so10223304wrp.3
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 02:07:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r1Q5+m83R8H0rZ1vKDsC4OW6950yz/tdIpCOKBzw7ZE=;
        b=jR1REScuvPU7M6UJuB8mAyHCWz4jgObGobCNxJTL4U0sg5A3R4uiVeSqia+G6SvqHl
         ah1JKgpVtbXh5zR2G5/2h9Jxnhz7npM1k1A7rl10oJXcZb358hXvSX4CvawA0bb9JdG1
         3jxW7wAm/QhT9n+Hxb+IXyC6E9zcpmz15OjLEFopqvy9jKqk8pqvcnWvxNxGAWYxSvZO
         C4T2QHj8EFc1F+djr9YhjNVNyfaU//AD3RhtO0TgZklgTPX8GBloQRDnptd3tycimZZO
         esmSBsCRZJr7MBkfoXsOwnBrJu4pWHFD5wEAj5ZLCQz0KpdQDvSW6aeXwYMsUXEtgOtz
         eQrg==
X-Gm-Message-State: APjAAAWsPMGGRVzUAUcyB17A+LFmMF0etiEDJ/PqHzXoe42Dox9POZgn
        OGSkYjXTLYoTku0lHgCtQdI0W2KN0pjVM7FTZrEx70AT4NHZRwo8Xbq6ZlQdRvRUXLGLXY7EUBA
        U51/dz5e55Vkc
X-Received: by 2002:adf:aa92:: with SMTP id h18mr23558113wrc.150.1572862031534;
        Mon, 04 Nov 2019 02:07:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqyJb9X/dTzarYF/30xpOoI87xgTeAWv4+0CjgTgjEyxkyBwnnpeEmjCM/C8qkdiXnJTA/OCcA==
X-Received: by 2002:adf:aa92:: with SMTP id h18mr23558079wrc.150.1572862031250;
        Mon, 04 Nov 2019 02:07:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id z14sm5356620wrl.60.2019.11.04.02.07.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 02:07:10 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] alloc: Add more memalign asserts
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com
References: <20191104092055.5679-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6f7795ac-5700-c132-e3b1-708e9451956f@redhat.com>
Date:   Mon, 4 Nov 2019 11:07:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104092055.5679-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 10:20, Janosch Frank wrote:
> Let's test for size and alignment in memalign to catch invalid input
> data. Also we need to test for NULL after calling the memalign
> function of the registered alloc operations.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> Tested only under s390, tests under other architectures are highly
> appreciated.
> 
> ---
>  lib/alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/alloc.c b/lib/alloc.c
> index ecdbbc4..eba9dd6 100644
> --- a/lib/alloc.c
> +++ b/lib/alloc.c
> @@ -46,6 +46,7 @@ void *memalign(size_t alignment, size_t size)
>  	uintptr_t blkalign;
>  	uintptr_t mem;
>  
> +	assert(size && alignment);

Do we want to return NULL instead on !size?  This is how malloc(3) is
documented.

Paolo

>  	assert(alloc_ops && alloc_ops->memalign);
>  	if (alignment <= sizeof(uintptr_t))
>  		alignment = sizeof(uintptr_t);
> @@ -56,6 +57,8 @@ void *memalign(size_t alignment, size_t size)
>  	size = ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
>  	p = alloc_ops->memalign(blkalign, size);
>  
> +	assert(p != NULL);
> +
>  	/* Leave room for metadata before aligning the result.  */
>  	mem = (uintptr_t)p + METADATA_EXTRA;
>  	mem = ALIGN(mem, alignment);
> 

