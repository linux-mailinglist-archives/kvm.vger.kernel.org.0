Return-Path: <kvm+bounces-51659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FC0AFAD10
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 09:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DEE23AEEA1
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 07:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B4F28643A;
	Mon,  7 Jul 2025 07:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsUlOnEO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15682264C8
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 07:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751873277; cv=none; b=KvqjLRJ+Puj1f9YnuHb/8DDALikvKMvQ5l9nOTI8Vv81pl1p3boPv+QFIqSGPX7quG9okkDEoI2e7FTNiMNGyHk4ixVwIGrrmyr/UkTXPprrM19opQLCIsD+slgN0kNTC0XRCk0P9Gvt+11TLaWYTxorkk8lWV+FDU8f+lUTBXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751873277; c=relaxed/simple;
	bh=6ZRMdpT+McJqu/mEN/9KZP27oWN1kuSvVMzgxrAD0ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbWWhILWIRYaoFDKCZNN4FC3wa0fjI4VzM1+iqVl3vWoTWNmRKz6+6L10mbQIJ5UU/a2V1p5dQmOrr1iWa4PbjBBe7yzu2FZCr8srXlr9YQwH/0YwHnXWBw4D1l9i/i444n29WQIG9aOL+ZWsfn8gVMURcQWn2rSLm9SiaEFhrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsUlOnEO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751873274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HC7yKf+9w9opVa105dzrjvxrKrrw0BuNCFrxLSAoT7U=;
	b=LsUlOnEOu5u480m5hwqwv9QtcBzd7pndEONn69KMTm8wvycUPx0BTnwa/Xc+ag6Woyj5Vg
	RafpFkFBnC8z7eb8l8mbNCHf01MDDwpWI0KyQ2w1/3niLtck4QHhB9uEQk+rpd+Ur3K3tY
	F55kbUaEe31h8QTVT4zlSrpmP36k090=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-55-AmS9XN8WFHnjOz86vCg-1; Mon, 07 Jul 2025 03:27:52 -0400
X-MC-Unique: 55-AmS9XN8WFHnjOz86vCg-1
X-Mimecast-MFC-AGG-ID: 55-AmS9XN8WFHnjOz86vCg_1751873272
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a5780e8137so1960238f8f.1
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 00:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751873272; x=1752478072;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HC7yKf+9w9opVa105dzrjvxrKrrw0BuNCFrxLSAoT7U=;
        b=dCzQ8L+ciNh6IH8iZNvBgfImWXDSnX0jK+MPqX21qfIwCHgBSyiYxehS3aS0bXyUkg
         scSaHVsg5pR1y4IG7mbcLtfLi6OfDNxjI5KROtuWdBZCPCBNOoynyyW0DGByn7mJaEa1
         ZI26kE+HWS+lkuBSU0r0HbptIc4oPKw73wv3lGTlQ40VN+UHGKRAbkLIfTBbkmBQSsY/
         t7jYULjkjvCycwrGMyCMvpDGwszmfuNCHJdogkaoI3urOcB/ThY+Odz8r4tWzHSs2B3z
         0+sP5t7RsaxoqfHCpwI+NRbGMzE7rV2YEfO8Q8++9b550t86tXDZnFHCwAnJ3MGykjDm
         Bm4Q==
X-Gm-Message-State: AOJu0Yw5sFaE53jv+9+p5399RxbE7ppysqzwKqYtIZxKpGsItYgwkmZE
	IfolmHqZPSArnQC4APTY9qKVedzn+yTvriicIVOrf3PeweMqBqayGFh4hbRVcIPL3LZDysK2jsO
	CHbwKYvjrcHMFmwyvMCgMgU5Q+mo32pFvWpFcq51AWCRXKliJS8BqPQ==
X-Gm-Gg: ASbGncum9s4j0hd01WZHRiGzhGDiUKVNPJOCVjRWMH4aPxpgwT+syptMHIg9fQ5AD0T
	lzy2MQI9yMq/KD4OHMCBXWTQNuhq1SmbNaGQMmvQqAUe8wRE+SO5Afyy4wvo3sf6vxrDzgr9cvq
	h0+IPQQSLxoC00+KpTOBsH24tVA+Bgg453oe4EbzY6SG9qR24VIh4+EGetTr+SSPPXjLqYyWv3T
	C32MgKSMV9JJJHOgPbbwQ0V+RxtLIhVWFFY+TqYHIJike0JwSnByJc/3VvUarOxgTaP7uXG2PSk
	jzyDgfFiwuix3fY80T43TLZgvahn4Sne2824ydWVL5zwrVzaN7cfllr0u0t9Q67WuK/jRTbougU
	jcbhheM4FUo1FTTFxmNddWOZK+Gl1yTLzjOfhlhGiLwSv7Wa5Qg==
X-Received: by 2002:a05:6000:3108:b0:3a5:8991:64b7 with SMTP id ffacd0b85a97d-3b49559284fmr10684627f8f.26.1751873271638;
        Mon, 07 Jul 2025 00:27:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELafVMBSMdrh2Gu2ElEmXQqBxgX9Y+0teI+QOSPrL3jecJYWz1a5N7Wo6fScbLaQp7+HuJXw==
X-Received: by 2002:a05:6000:3108:b0:3a5:8991:64b7 with SMTP id ffacd0b85a97d-3b49559284fmr10684601f8f.26.1751873271155;
        Mon, 07 Jul 2025 00:27:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f38:1d00:657c:2aac:ecf5:5df8? (p200300d82f381d00657c2aacecf55df8.dip0.t-ipconnect.de. [2003:d8:2f38:1d00:657c:2aac:ecf5:5df8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b4708d0ae0sm9483726f8f.33.2025.07.07.00.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jul 2025 00:27:50 -0700 (PDT)
Message-ID: <9ee49c32-0cc5-4cb0-a7d5-979af9f8d5f1@redhat.com>
Date: Mon, 7 Jul 2025 09:27:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] mm: introduce num_pages_contiguous()
To: lizhe.67@bytedance.com, alex.williamson@redhat.com,
 akpm@linux-foundation.org, jgg@ziepe.ca, peterx@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250707064950.72048-1-lizhe.67@bytedance.com>
 <20250707064950.72048-2-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250707064950.72048-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.07.25 08:49, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Function num_pages_contiguous() determine the number of contiguous
> pages starting from the first page in the given array of page pointers.
> VFIO will utilize this interface to accelerate the VFIO DMA map process.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


