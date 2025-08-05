Return-Path: <kvm+bounces-54020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CCD6B1B66C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EAE23A23ED
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE295279333;
	Tue,  5 Aug 2025 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RLVpDRGw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588C3277C8C
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 14:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403987; cv=none; b=ucxkHjXZt140ZzRRkP99hklpStkFsyPfjhqZG7bgF5e3fBbeD9YH/XYXwHTEM6hsD4+gK5UWN78CjTQI6S2P2KVoGuV2NwI3/JRgCaOjQUZ0u0qCHvURVfFKV0fDMCpKxu+f+6mVmS4AukkA0AlH243qDXDKo2L0FoG97VgfCD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403987; c=relaxed/simple;
	bh=DNakTxwm/ZIEqnRELm2TZ1l73IuelsjBL8cBUHgbSKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2IWl/2EwXkHl70/hWybrfcpcM8ssxX6ZSPgY7GBoU5IJJRkX6GCQMkufZmMSc4l2XR/15IPgeeH53SdM8AxODWgHSHuLsfY4YTv6XiWH27oevv8rR4By3IWXpNEqU8Tr8DCwzcZw070HVWA4RSrM58D0bD80Y/WsV/uTeAxZIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RLVpDRGw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754403985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YNVzFJpcbrhk4hUy0vEGBU3NLilG2yT7mK7/nRU1YzU=;
	b=RLVpDRGwyS6Ztc8esWS8Ri95y0FdBPYe/7tB+1le1IaESY/UpgNbwcuXTJedOr84oFNGi8
	vPpzUAho921FRKd1KilaBtdYu5u40cdt4hGP9jaIEG2ZequmDwNI0jmiRTTICvirEASoz9
	B3ktd+OGYF4ijMPdEVGWdGwJvCPEEvA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-1hfwY8AfP82bNfFwMjODiQ-1; Tue, 05 Aug 2025 10:26:23 -0400
X-MC-Unique: 1hfwY8AfP82bNfFwMjODiQ-1
X-Mimecast-MFC-AGG-ID: 1hfwY8AfP82bNfFwMjODiQ_1754403983
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459de8f00cfso7206895e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 07:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754403982; x=1755008782;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YNVzFJpcbrhk4hUy0vEGBU3NLilG2yT7mK7/nRU1YzU=;
        b=RDgiV6/VNxOrmsJgnaieeWwYLPOFYBfLmdS25MyNIVrh3e60XTIwjEUSA1ah9qyKcH
         RE4B4+SeMvOAF5TQhjxb19vDl6gkiqb6pd+gd3gpbs0uPxJeIUXj2tkP8K9qpQ6uNkaI
         eX34cQH36Bhm6m4GfowLNLG98T7E5gW9whIa0padOMWW/9x6N1p6biKMVrfdnkNGXR2e
         5UzlA76ybzbVnwYaxbLO1CzmDUNFEIEy3XlfuhWChto0sUDqxZGOaZFIwghWVrHAx7mC
         ntfN3GE+kh7Y8nZr7eaGGDgm7wDf+xyLAwUDud74iF3IjHpedR1gCY9EmN3otW4518S1
         oMuw==
X-Forwarded-Encrypted: i=1; AJvYcCUkeHSwIEk6U8pglxxpX27La/Y/Pmtd5zO8BLrsYEBAqrg3N0nJ8OAjq+KFupvlJjvKKmM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgZMLaxB5PXrzHtW3Y542GWSosJZTwekxkdWzeLZV+MseuYQ7F
	tu9faYNIyHrI1yx7rcjVxaP+aV01mdSw89gZY3NVoT/mR+vJUPt8VciruC5/QiWGcz7kQphlVm4
	pDZO83oIqVKo08WSX0fMfX2xJguHuUzTzSFtVfVT0gh56XCWWSFKCmw==
X-Gm-Gg: ASbGncsa/ocPBgbckuTkk4jwDNiIaOhjiYdWV/XH7jQwamQmhG5vR1PsFHLZGWbHxtR
	9JhkEnRHJNVHwEPG+bcsca+GBHUlASdq74+ctriFr8siuchoaf1g8FY7UKDMggzHVorxk26ct0J
	eHQGwxiYzB7xlgREMGCrevTaXgG0dWgqh2E9p7i+yFp0m7GCMG1/48Rk7eeJZL5H3ObghtVrT6I
	XUzrD7tj8JVY+9G7fU9buI3zTow+035L8+1T+ad43qIb4BlqWiPYqkzqYC3kpGwWh1TazLcIfW3
	+002sx6Z7/3i+nWey9vbBEFdaFsVmTZwF81bTDkOuhcdNY81be7T6MxxOMzxXhg6WE0O+cZZoUn
	LKjPHEarDqpq1hIWbfnQzaAtWnHv8iVVKLDJXyF6jLMQictROOhGO6TW/0mQOJDcT8xM=
X-Received: by 2002:a05:600c:4fc6:b0:458:bfe1:4a8a with SMTP id 5b1f17b1804b1-458bfe14efcmr99389395e9.14.1754403982528;
        Tue, 05 Aug 2025 07:26:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2Hr6CGeh81Srj9SxtK04hLQabmwLkYUhwVWN1VqR5cEOE8PNNSumzWzf8CnDNfAG9EmCDyA==
X-Received: by 2002:a05:600c:4fc6:b0:458:bfe1:4a8a with SMTP id 5b1f17b1804b1-458bfe14efcmr99389085e9.14.1754403982082;
        Tue, 05 Aug 2025 07:26:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953cfd10sm267154515e9.21.2025.08.05.07.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 07:26:21 -0700 (PDT)
Message-ID: <57325473-42ba-4523-974f-3d7889c4acb5@redhat.com>
Date: Tue, 5 Aug 2025 16:26:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
References: <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <20250805132558.GA365447@nvidia.com>
 <00999740-d762-488a-a946-0c10589df146@redhat.com>
 <20250805135505.GL184255@nvidia.com>
 <44157147-c424-4cc0-9302-ccf42c648247@redhat.com>
 <20250805142028.GM184255@nvidia.com>
 <57582464-cfd5-47f5-877d-88918ffa2ec0@redhat.com>
 <20250805142446.GN184255@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805142446.GN184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 16:24, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 04:22:32PM +0200, David Hildenbrand wrote:
>> On 05.08.25 16:20, Jason Gunthorpe wrote:
>>> On Tue, Aug 05, 2025 at 04:10:45PM +0200, David Hildenbrand wrote:
>>>> There are some weird scenarios where you hotplug memory after boot memory,
>>>> and suddenly you can runtime-allocate a gigantic folio that spans both
>>>> ranges etc.
>>>
>>> I was thinking we'd forbid this directly, but yes it is a another new
>>> check.
>>>
>>>> So while related, the corner cases are all a bit nasty, and just forbidding
>>>> folios to span a memory section on these problematic configs (sparse
>>>> !vmemmap) sounds interesting.
>>>
>>> Indeed, this just sounds like forcing MAX_ORDER to be no larger than
>>> the section size for this old mode?
>>
>> MAX_ORDER is always limited to the section size already.
>>
>> MAX_ORDER is only about buddy allocations. What hugetlb and dax do is
>> independent of MAX_ORDER.
> 
> Oh I thought it limited folios too.
> 
> Still same idea is to have a MAX_FOLIO_ORDER for that case.

Yes. Usually unlimited, except we are in this weird config state.

-- 
Cheers,

David / dhildenb


