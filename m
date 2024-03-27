Return-Path: <kvm+bounces-12744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2115C88D473
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 03:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 527771C245AD
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 02:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5BC20DD0;
	Wed, 27 Mar 2024 02:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JxRsfOQn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36124219E1
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 02:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505484; cv=none; b=Noy38GOVc2r4e2xbh2YFKRjfskUvAXmEyFIBeQsAqdR4m7uf8YTUMAaQUHquYBXRAxu406BjsHcxq1vHqXEiBDeJKVmZrkTArRIb8kqb2tUwIoxzGtkX6Db1CeRX/bkpcrnJ4QbZZUu3EPTgRgChK6R7jtuFAvR8Yiap/vJfcss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505484; c=relaxed/simple;
	bh=y2aifghtI/Ja4XD7u2NtI6N6MTi5BLIEicHNNSMA6SA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LMDXzpoT6m5fQAMY+DWUK1AO7Er+aA/7bNDqWqbMVmBZ+0L9bWgTDcQSQJDQ1zxgSJWMQH9R9zPVI8o5SVVmi96D51ppNMhIu77MfvH3THvZH8L1qR74d8z6eqvcZpVFvxyQ2NqfMOFlVdz/QQJiGcYTGRnwIlTJ/5ojs6GrGug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JxRsfOQn; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-29f8403166aso1058052a91.1
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 19:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711505480; x=1712110280; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VKgEZz3gqT/qrPZJxtA6ePPIz6oGvyMPjM3uA1fFlqE=;
        b=JxRsfOQn8gPSjir6TbrBjWXbK/PJp4ZBSwKtWzwl58PgosmH2htE9+JnrFwfbnzQ2G
         /qa55/418mac0pI1hfo5vRwTNvgu60YzGuXXTWbPdw4xSCbU9P28mRYteMbrcz9qhLMx
         fFGwlRPa9ESvMcE90yEh8E3G8fD3dm/8iyo6Cnmor6/SsdhSPMMVI0G/c080B2KXbSsJ
         95pGqI7L+x9Fw3E6nJNoAc7GSEbX+N1sOw/7QDH9RCfJYh387NdNn+ocZ9vI757IaxX+
         3OQeXlXkwK+CZSWR1+VNrrJC4rkxeNAlNhGjmxE6yE4ylVRFrSEZiQfYLqdseXO/8ud7
         F5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711505480; x=1712110280;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VKgEZz3gqT/qrPZJxtA6ePPIz6oGvyMPjM3uA1fFlqE=;
        b=idQDMeo3kv4wlApPjmVKbl3SC4sZEwo8ksbPCtYJANHejIRnlxCAz3wwTxxGcSgmB/
         o/AX5eUHXiy1ob/BK/hFS/iS92UUTM3ErpjczZaRVkSxJo/NPcgPJYD8DlNGK7Z6zSoL
         PYlcI9EaQUWs25swlFCObJ0O2qJ4Cb4rmELMv5y8yQ/ivSjyQV2ggu10szcjwXT1ScER
         2hIz7+HyLVNL/K1/BhTeTod8mB3ELBKloKxwUut/6rXqJxbRiVyqiLPZtRdoG0cD4ahd
         6OGcf7OwPIwBvR+8V0kn1q36Wij4oOO6r+IQ9GkuuNP33803ib7lF32vRVfZb9I0k9j3
         u3fg==
X-Forwarded-Encrypted: i=1; AJvYcCURNmB/33q0+F5zg7e7fJr7ixVg1TAV3+/Lfn5Jqi8VqUwKvk0SZkKAIOlLGu84Q4yv45o5ivkwLyoFAjEEnUO/CjZl
X-Gm-Message-State: AOJu0YwcX5sRyRueB077g3Sq7EWGcZYAqbS2rA6gZhGkzYpKM+5z/Eyx
	Z0Aey/QmCg28doyUuH1gBihSF/8VhpBE67Y5TIwAHsZx3hidxGGOQI6xqmRYOio=
X-Google-Smtp-Source: AGHT+IHOxzsYzXYb2U6hVOGVogL6FmVfZp9EHnweMdH3lzP+3KV1JbtDB3TMm+JsCmDJCYsexHcneA==
X-Received: by 2002:a17:90a:9f8b:b0:29b:fab2:8a24 with SMTP id o11-20020a17090a9f8b00b0029bfab28a24mr10290068pjp.3.1711505480542;
        Tue, 26 Mar 2024 19:11:20 -0700 (PDT)
Received: from [10.254.105.249] ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id q5-20020a17090ac10500b0029becfcb97esm335753pjt.22.2024.03.26.19.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 19:11:20 -0700 (PDT)
Message-ID: <7258d29d-0d4b-4463-8685-e3f21d426d2d@bytedance.com>
Date: Wed, 27 Mar 2024 10:11:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] s390: supplement for ptdesc conversion
Content-Language: en-US
To: Vishal Moola <vishal.moola@gmail.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@redhat.com,
 rppt@kernel.org, willy@infradead.org, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <cover.1709541697.git.zhengqi.arch@bytedance.com>
 <04beaf3255056ffe131a5ea595736066c1e84756.1709541697.git.zhengqi.arch@bytedance.com>
 <ZgMmec2paNA0GFwY@fedora>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ZgMmec2paNA0GFwY@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/3/27 03:48, Vishal Moola wrote:
> On Mon, Mar 04, 2024 at 07:07:20PM +0800, Qi Zheng wrote:
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -206,9 +206,11 @@ static void gmap_free(struct gmap *gmap)
>>   
>>   	/* Free additional data for a shadow gmap */
>>   	if (gmap_is_shadow(gmap)) {
>> +		struct ptdesc *ptdesc;
>> +
>>   		/* Free all page tables. */
>> -		list_for_each_entry_safe(page, next, &gmap->pt_list, lru)
>> -			page_table_free_pgste(page);
>> +		list_for_each_entry_safe(ptdesc, next, &gmap->pt_list, pt_list)
>> +			page_table_free_pgste(ptdesc);
> 
> An important note: ptdesc allocation/freeing is different than the
> standard alloc_pages()/free_pages() routines architectures are used to.
> Are we sure we don't have memory leaks here?
> 
> We always allocate and free ptdescs as compound pages; for page table
> struct pages, most archictectures do not. s390 has CRST_ALLOC_ORDER
> pagetables, meaning if we free anything using the ptdesc api, we better
> be sure it was allocated using the ptdesc api as well.

According to the code inspection, all ptdescs added to the pmap->pt_list
are allocated via page_table_alloc_pgste().

> 
> Like you, I don't have a s390 to test on, so hopefully some s390 expert
> can chime in to let us know if we need a fix for this.

Yes, hope so!



