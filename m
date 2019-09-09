Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCCAAD541
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 11:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfIIJHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 05:07:06 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45983 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfIIJHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 05:07:05 -0400
Received: by mail-ed1-f66.google.com with SMTP id f19so12195648eds.12
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 02:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4SKyZYA96ZSRssF5bkYvn8/ZaoQgr/75nnF3v6r+aa4=;
        b=v8w3omLdQptz1DFzG6nBTgRTann5rTwOgCIpzFAUG6tuIXQysQUnfXsX6/y/3pY3P9
         uuS7yln7izn8sa95u0TM8CxgbGe80u+X7t+BlonTv/Ols4bkZ2vzfkF1DV9YLxLMbFWT
         xMTJREdPJWH3jVZBD9E+ZKhbm9fxBa7VvxrMdRD31hii4MCogV1JmJclv2q1d2hOR8mU
         ZmP3pZ6SwqNXdDC1we1lskq5l3t193Mkb/3/NHR7WEDq49Askf9VlLY7UIB/Uu8JTBTS
         Nb6KVgXuECh0+jAIrDzxGYdOgJP/buaC0u2KcFllDTZyMTRwGgl/GCSf7CPvpXRD1ygX
         8PnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4SKyZYA96ZSRssF5bkYvn8/ZaoQgr/75nnF3v6r+aa4=;
        b=Vftj5OOdcHbZzqpmdWtO0sdD92ICEVKD89zM2dcu+AAicAGA23sgObrZSCIKOwTKIG
         l202uGWY9BQcaQex16Oxz5VyRVwyJXG0iI7+ABaecTwlUCi0TAEHmWNCcSr1NlOrHGaY
         kj00SNUeiJEyEsQob0vbBiPAx9SjrD3C2SQr+JCtAtRK/vbeMaGIyDb1tUZ+YTt3CPR8
         vrdtmdr2dphFzE/KRK3OvQ4yoheXcy6a6CKpbvUrQK7jzdPTywhWzRcymQJt/cmbRu3Z
         tmIdmSg2OAwXHh2HxQyMVS8kdGYOnQ/tGwNXRb9p4bu1yA9iaYVY4W/vsqGHktXYjtUm
         SQCw==
X-Gm-Message-State: APjAAAWpH/J/rhavkCj0F2oabCAMe/mpUVA18wX+Ci91Mk8aokDZcyLB
        ZKBBgUbz8OuxNDnHYv8tNhzoDQ==
X-Google-Smtp-Source: APXvYqyy8JsEYXIXPZAEHqSPlkNj11nYxwtRGAlvmsF3QvGEid/LtADgJQP/uhTJkNkMTa1lQpdZXQ==
X-Received: by 2002:a17:906:af98:: with SMTP id mj24mr18377781ejb.199.1568020023846;
        Mon, 09 Sep 2019 02:07:03 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t21sm1658127ejs.37.2019.09.09.02.07.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 02:07:03 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 94FB410022D; Mon,  9 Sep 2019 12:07:01 +0300 (+03)
Date:   Mon, 9 Sep 2019 12:07:01 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH v9 1/8] mm: Add per-cpu logic to page shuffling
Message-ID: <20190909090701.7ebz4foxyu3rxzvc@box>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172512.10910.74435.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907172512.10910.74435.stgit@localhost.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 07, 2019 at 10:25:12AM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Change the logic used to generate randomness in the suffle path so that we

Typo.

> can avoid cache line bouncing. The previous logic was sharing the offset
> and entropy word between all CPUs. As such this can result in cache line
> bouncing and will ultimately hurt performance when enabled.
> 
> To resolve this I have moved to a per-cpu logic for maintaining a unsigned
> long containing some amount of bits, and an offset value for which bit we
> can use for entropy with each call.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  mm/shuffle.c |   33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/shuffle.c b/mm/shuffle.c
> index 3ce12481b1dc..9ba542ecf335 100644
> --- a/mm/shuffle.c
> +++ b/mm/shuffle.c
> @@ -183,25 +183,38 @@ void __meminit __shuffle_free_memory(pg_data_t *pgdat)
>  		shuffle_zone(z);
>  }
>  
> +struct batched_bit_entropy {
> +	unsigned long entropy_bool;
> +	int position;
> +};
> +
> +static DEFINE_PER_CPU(struct batched_bit_entropy, batched_entropy_bool);
> +
>  void add_to_free_area_random(struct page *page, struct free_area *area,
>  		int migratetype)
>  {
> -	static u64 rand;
> -	static u8 rand_bits;
> +	struct batched_bit_entropy *batch;
> +	unsigned long entropy;
> +	int position;
>  
>  	/*
> -	 * The lack of locking is deliberate. If 2 threads race to
> -	 * update the rand state it just adds to the entropy.
> +	 * We shouldn't need to disable IRQs as the only caller is
> +	 * __free_one_page and it should only be called with the zone lock
> +	 * held and either from IRQ context or with local IRQs disabled.
>  	 */
> -	if (rand_bits == 0) {
> -		rand_bits = 64;
> -		rand = get_random_u64();
> +	batch = raw_cpu_ptr(&batched_entropy_bool);
> +	position = batch->position;
> +
> +	if (--position < 0) {
> +		batch->entropy_bool = get_random_long();
> +		position = BITS_PER_LONG - 1;
>  	}
>  
> -	if (rand & 1)
> +	batch->position = position;
> +	entropy = batch->entropy_bool;
> +
> +	if (1ul & (entropy >> position))

Maybe something like this would be more readble:

	if (entropy & BIT(position))

>  		add_to_free_area(page, area, migratetype);
>  	else
>  		add_to_free_area_tail(page, area, migratetype);
> -	rand_bits--;
> -	rand >>= 1;
>  }
> 
> 

-- 
 Kirill A. Shutemov
