Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8096EDDB7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfKDL3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 06:29:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbfKDL3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 06:29:52 -0500
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8289F368CF
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 11:29:52 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id v26so6003531wmh.2
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 03:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sliMAq689AXP1CSa4D8rZKhWJpwJH/rqk3D+xYMxetc=;
        b=CoXDE9TnxuowbZLR8LOWL7jL0Ppd/Kb8iHgtr9H1awn6wV93YC4CSDI4gHJ9iK8tyO
         vGNqFCf7G6ZfLnbFo2enPcVeEKVpGtYChqozB4LCxG5VBUKIuMbfAqqSiuo3/PI34BGA
         3HfKTcs2OBo4xINvMT2D0oxxR6TV+kHPogDrngjbsZWTeB6cVA4eMAROBllLW/mQV9UB
         GB0wB1SFuTuXQ5QZLCiiVlntVjiLIj+yNUvzUGujRZD35suUis8XF+NPXzwtHZZ0EmqF
         /94WsKpiOVa7nPjKLm80eNhgdEwwLVddPK1skYL7Ka11d5DIzEhMuYDuLBpepPd4W4iT
         gQOg==
X-Gm-Message-State: APjAAAXkV43bLZO9bqwUncgq6Stsa2o15xX3i5VC3FFbMTcvn50iJIux
        wJgNWrdNloaRR5+iuupmyAZct0KUc4xcNjUm8ZV4o/JDteE6VZSfWhDBa/1M6xGJ92KV3zDTBDS
        UzB3pCkVrv7f1
X-Received: by 2002:adf:f010:: with SMTP id j16mr23256815wro.317.1572866990935;
        Mon, 04 Nov 2019 03:29:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZQ6JMvSiXiZGalH5INdSXWYWRHGN5o69FJ1DgJGdWMXpeNYFi91gfgetyFrzWpGzZL77zHA==
X-Received: by 2002:adf:f010:: with SMTP id j16mr23256787wro.317.1572866990642;
        Mon, 04 Nov 2019 03:29:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id l5sm14871500wmj.44.2019.11.04.03.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 03:29:49 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
To:     Andrew Jones <drjones@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        thuth@redhat.com
References: <20191104102916.10554-1-frankja@linux.ibm.com>
 <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
 <20191104105417.xt2z5gcuk5xqf4bi@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a91a1828-017a-b0c6-442f-5b31263f3568@redhat.com>
Date:   Mon, 4 Nov 2019 12:29:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104105417.xt2z5gcuk5xqf4bi@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 11:54, Andrew Jones wrote:
> 
> diff --git a/lib/alloc.c b/lib/alloc.c
> index ecdbbc44dbf9..ed8f5f94c9b0 100644
> --- a/lib/alloc.c
> +++ b/lib/alloc.c
> @@ -46,15 +46,17 @@ void *memalign(size_t alignment, size_t size)
>  	uintptr_t blkalign;
>  	uintptr_t mem;
>  
> +	if (!size)
> +		return NULL;
> +
> +	assert(alignment >= sizeof(void *) && is_power_of_2(alignment));
>  	assert(alloc_ops && alloc_ops->memalign);
> -	if (alignment <= sizeof(uintptr_t))
> -		alignment = sizeof(uintptr_t);
> -	else
> -		size += alignment - 1;
>  
> +	size += alignment - 1;
>  	blkalign = MAX(alignment, alloc_ops->align_min);
>  	size = ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
>  	p = alloc_ops->memalign(blkalign, size);
> +	assert(p);
>  
>  	/* Leave room for metadata before aligning the result.  */
>  	mem = (uintptr_t)p + METADATA_EXTRA;

Looks good, this is what I am queuing.

Paolo
