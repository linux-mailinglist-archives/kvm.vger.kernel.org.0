Return-Path: <kvm+bounces-64837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBC9C8D226
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F3CE3AF16E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67F931ED65;
	Thu, 27 Nov 2025 07:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VURqwO22"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129502D948A
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764228968; cv=none; b=HM7NUaZKcbrf4vk3M0o4AJqGR1GZf+uzuJuQSeI6obFgfCAICIH3z5hkyr0Le0Y6t5dE5LVE1kZuPWJrq/bvOTaiaYaPINZthTD4+9btMc3AykO/m7kAQzTEydG2YEFToFaShuz0/TT9klMd6eSIcp28+juzGDSxb0qkl7PRrYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764228968; c=relaxed/simple;
	bh=M3w0bNtAIwlj3x4MgmwliTzrK4xVv0hZ0kZu7Q9lO5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SW2J8p1w5wONNgzqsB8CBcjcbCM6tuXM242+a6cU7b2v1rkGviGXc/Isw8eRLC7kCIa06OfOjXymloTJ6Zpr3oryRFzIKpVjg1i7sbWXrrA2a2TnZhRjKqJ4x/h+DznxTMPNbLaL5FjCGN15XZ3PQumvd+4yZWj2p4y27i6JIRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VURqwO22; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b762de65c07so78320666b.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764228963; x=1764833763; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Ry5Icad7K57cHxBgAf3HDM0tDnRTn+wmwX3MBtvtGHg=;
        b=VURqwO22Cm/XK65iLfaBDIdHoMa40QcmnGNEQziDVco6FDjFPB2RTr5rFGHZ2Vx54A
         A8GIxWM9mI+z7iYw7X02ddH5fEVnjQpTszBAwrXQz1Y1RE6tKucBUPSrszMBWHe8Tp/5
         Q094vTkIMLxMHda6mBix1AV2nhfuvqwsVOkich107UEZR9aiWYmlYu30+T8OaKCnrIOJ
         FXriag9D1lxa+tT1m73v4umMQvbS75PGJQ7qjU/PRDOgSqLPtzcDm+wXq+jU60NAbjFA
         2AmV58g7YcPDu12KMFUsC1/dYo36JOYBHhb1Xnkpzp0Yok+5A8eH0klFanegn3diasKk
         /M9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764228963; x=1764833763;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ry5Icad7K57cHxBgAf3HDM0tDnRTn+wmwX3MBtvtGHg=;
        b=HtIbvVtate6Ik/iRYDEHMMgtESR7IYgkNu//M+qv9g7JMFEziZD8yBIttMKTWU2jjk
         EAhqsxDZRV9QgbXTGZ6mf7SjYCXZm7ThGAfXm1yHg5Sok/vsf9beLlCz9y0Ldpw4kKz+
         wVeuWVYLKiGpw0OTdHo24DJlribjmo1vb8NvaMUxjQz7065i4h50GA1xrUg0pS5rgiUB
         FK853kBV2Mi0mq48oSbZahJAQxn3MrY2dBdblaE0vgi5QAFkndmsFEIRidXP18/vriry
         ULL4F7qtI/WfNpmHK2KoUF/V/xm0x0O7uWzXUEUSX4X9Vd3oymJJMwCY3A5UErowRG/6
         S79Q==
X-Forwarded-Encrypted: i=1; AJvYcCV4PYSV/P3NHY6JARctwy7Sxd/cNWaOznoF9VBPHFhx/hnOhW1BoSu4Cc9nYhs480yxRD4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXQqfWTwqLwlKvOoFR4M7QCEOVyNg3BUxV/474WF1IK/wSGqtG
	msClTnSzp7XwZ6LgY4fND5yjlK339aoly/tklqOwGslsWG0V55EC4D/0wY38+VU3EOg=
X-Gm-Gg: ASbGncv7RcBsEc/Mer3WVdhbXAen2gmJTs4XwmKhVYDljBQ9ag3i+cmHmO61v2p6MFR
	Z0TThbpn7ktNnrs04rrad3rpyBRjXqLNyZAqp3iXnGfLcdBOLNS03AFjkaRn5Dkw4KwQeJGBqwK
	ICLLY/Gi3VsdCHq4D94baK3q1avxHdZZAhl1ux5DkOKomcIueQtOlZ7aMMmRA6A8AxYn0cFPfbb
	jku1OYbbyu4kZwwPA/HKk5wQX/J7wq25jDjSuoCYM/aYu4p7o26DgRGAZiBN7LA1LDU9v7ZJXEk
	HSWyetxwurmD/icFdTZJwksWOgHgIRMuiZA+Iy1b2zbUHj89hq4KeRyjpB6KxKTuj8M21eT1s4n
	G6KVANevJjq58xqerMK+uJTjoJXFhiWzLrr2SHO3BKCYGJRm2WS9mDB77ZhieMFlDkR9frsJ0nU
	axzY9fs4I0GzYx2urNfLaXNaAbhs0Nhm0fOcQ5
X-Google-Smtp-Source: AGHT+IHp0jLzCQvHPIiwFS2ld5NvIqb51lIrHzbEzK1vWd7M0358Smsxo4Tuy9moUFCwEdKgCWpmpg==
X-Received: by 2002:a17:907:1b12:b0:b76:7e0e:4246 with SMTP id a640c23a62f3a-b76c546da56mr1052544166b.12.1764228963207;
        Wed, 26 Nov 2025 23:36:03 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f4d533f2sm94542266b.0.2025.11.26.23.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 23:36:02 -0800 (PST)
Message-ID: <69a2dee2-f6a5-4c1b-9daa-8c32ff7c3956@suse.com>
Date: Thu, 27 Nov 2025 09:36:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
 <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
Cc: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
 <b3b465e6-cfa0-44d0-bdef-6d37bb26e6e0@suse.com>
 <7dd848e5735105ac3bf01b2f2db8b595045f47ad.camel@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <7dd848e5735105ac3bf01b2f2db8b595045f47ad.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 26.11.25 г. 22:47 ч., Edgecombe, Rick P wrote:
> Kiryl, curious if you have any comments on the below...
> 
> On Wed, 2025-11-26 at 16:45 +0200, Nikolay Borisov wrote:
>>> +static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void
>>> *data)
>>> +{
>>> +	struct page *page;
>>> +	pte_t entry;
>>> +
>>> +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>>> +	if (!page)
>>>     		return -ENOMEM;
>>>     
>>> +	entry = mk_pte(page, PAGE_KERNEL);
>>> +
>>> +	spin_lock(&init_mm.page_table_lock);
>>> +	/*
>>> +	 * PAMT refcount populations can overlap due to rounding of the
>>> +	 * start/end pfn. Make sure the PAMT range is only populated once.
>>> +	 */
>>> +	if (pte_none(ptep_get(pte)))
>>> +		set_pte_at(&init_mm, addr, pte, entry);
>>> +	else
>>> +		__free_page(page);
>>> +	spin_unlock(&init_mm.page_table_lock);
>>
>> nit: Wouldn't it be better to perform the pte_none() check before doing
>> the allocation thus avoiding needless allocations? I.e do the
>> alloc/mk_pte only after we are 100% sure we are going to use this entry.
> 
> Yes, but I'm also wondering why it needs init_mm.page_table_lock at all. Here is
> my reasoning for why it doesn't:
> 
> apply_to_page_range() takes init_mm.page_table_lock internally when it modified
> page tables in the address range (vmalloc). It needs to do this to avoid races
> with other allocations that share the upper level page tables, which could be on
> the ends of area that TDX reserves.
 > > But pamt_refcount_populate() is only operating on the PTE's for the 
address
> range that TDX code already controls. Vmalloc should not free the PMD underneath
> the PTE operation because there is an allocation in any page tables it covers.
> So we can skip the lock and also do the pte_none() check before the page
> allocation as Nikolay suggests.

I agree with your analysis but this needs to be described not only in 
the commit message but also as a code comment because you intentionally 
omit locking since that particular pte (at that point) can only have a 
single user so no race conditions are possible.

> 
> Same for the depopulate path.


