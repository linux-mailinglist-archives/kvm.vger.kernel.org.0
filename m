Return-Path: <kvm+bounces-32581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3922E9DACEA
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 19:16:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF5BE16464A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 18:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDAC71FC7ED;
	Wed, 27 Nov 2024 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iiHWVUeF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7923813D503
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732731367; cv=none; b=RLfvOhrdPrGUqM1rNQtfLpwCLkMnb8822fCjRlH3Lc7YKouD9va8BHXmvsB9JJmMJ6Gwb4SBiLT1ZOCp+BpRLJouUmC+KBJHTynpr/GQg2cE9cKgKHg55l0Qz1u3U7Wv0v6lot6RsXUW3z3eZvrREjdZlDdWa/i6KGWxpPS+W2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732731367; c=relaxed/simple;
	bh=0LFR4u+l4syEWgEIki5giJ+Inx0CHWLWcC8ShzBG7V4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJjJ9T72iUnw7Rlg0e0tHUiJ9yfdBKYW/634hvRaJ9KP89mURI9z0XQhEkEajnOhbc15PQpeP6ISsnKZukK8q537qRItomIr2mJbXlTMDa9KKH86k8cU9vgi8xUYYPm/JdiITxNjCg5iPm/zL5rKSTZ1eBgir50+BqG6nQtck4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iiHWVUeF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732731364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zO1IXqN3Qo3x31XCdEArCw4yZfWyzY7K8jwcLaA/L8E=;
	b=iiHWVUeFIcUjxRxfQ8lSX54RERL7zmKstM9WBIJWWj8gVJHCTBJWbr2k9x7Vm8g/QhGyXS
	jNNNHqP/XR9An9eHqAfbz22Cg5+GN/Ujk8X7ulc+VZg+4NWGddiDugArkQJf5Dqq0CDq1o
	1vroSgYKNxj/2cz2nWiArwMoGo86MwI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-bKVgKg6lNMm7slSL7JM43w-1; Wed, 27 Nov 2024 13:16:03 -0500
X-MC-Unique: bKVgKg6lNMm7slSL7JM43w-1
X-Mimecast-MFC-AGG-ID: bKVgKg6lNMm7slSL7JM43w
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4349e97bfc4so36137255e9.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 10:16:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732731362; x=1733336162;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zO1IXqN3Qo3x31XCdEArCw4yZfWyzY7K8jwcLaA/L8E=;
        b=WtIZq1QlDPnQ6gyRfcbLrr19Y8Vgopth+Nbn/mkctEby1lOIMe43nQWlgpX8OpZGBE
         3MuQtAz8JUa0B0M7qDu97f69bAaPT2tzTC29ksoYg3U1c6mujcIL7yAn9Yc7nu5xVbGt
         SHBtpYiDz2UichnM7jrv4jMN4xm1KHyy5UMRApH2g7kxIoYQZwyD3uewUR+qCnkpfX+e
         IYv5xdBSbdg7QYbGoS5KnWq0pLF+CX752x+MDQDDgyc59qReG5a+ApUXqbeuWs4Ro3+9
         VMJFcDklMt/jAuY4eG3LjLN5uycMP8bNg6YtYEB8b6wg+W+e1amNdJNW5nGFcT5tflc6
         ddEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhUBbBJFyoGyWXVqRbGkCKeDhs8ODEW0xM0Va9L3AyaK9Il0kRSbOC7jo1qr1YiweQPAk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8GUOdLmSGCg1pghsZyp0lls8wQ8QLbTMRQ8T+AFn2dsayfyrT
	doHbzvnqlFNPSpQQncDPMA3UuYfKo45k5trmfltBA7gcWt5+Tf7vxI0p+m1gpqC9p5qKSpVrWR+
	om0kkUF7jJ/toZpt3T865TITLmN/rHDKknwcgpkdLiCu8zn5WXg==
X-Gm-Gg: ASbGncu8RcMJlJeKZy6e97mrRmKPjkZ3Gf6wM9SdPIp9c1TKZF7bFqdUNe6wtoDUfcG
	lQLDG3j0Ag+wJRkHnA2dxAFMlD/vpVeh2vcyhYNb+32cEbUTXvm9GhMZ45F5FUClepwZbsWc2PT
	X41WUctquu04q2xOjNmucM4QAKodspSt2/4U9qvWZ56K01GCQD9/n2BIkixJxWztvO+wdVKa6c/
	ezyC5T+4wEpT5F0prMNP0wximqbmGDp6Gnf+JPCuzfYx4Q9/gCcIw==
X-Received: by 2002:a05:600c:1c93:b0:434:a852:ba77 with SMTP id 5b1f17b1804b1-434a9dcec68mr46330845e9.15.1732731361991;
        Wed, 27 Nov 2024 10:16:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlSOETqY5xWikoXdGyx+ENqCPhG3pAdQ1oFPlJH7WCPfJ43PWFxdmZZG2nmMbq+n4dBvEiQg==
X-Received: by 2002:a05:600c:1c93:b0:434:a852:ba77 with SMTP id 5b1f17b1804b1-434a9dcec68mr46330345e9.15.1732731361607;
        Wed, 27 Nov 2024 10:16:01 -0800 (PST)
Received: from [192.168.10.3] ([151.49.236.146])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-434aa7fa1dasm28287285e9.42.2024.11.27.10.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 10:16:01 -0800 (PST)
Message-ID: <0835f21a-c0b1-429c-a107-d7d0a2838194@redhat.com>
Date: Wed, 27 Nov 2024 19:15:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID
 management
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "yuan.yao@intel.com" <yuan.yao@intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
 <20241115202028.1585487-2-rick.p.edgecombe@intel.com>
 <30d0cef5-82d5-4325-b149-0e99833b8785@intel.com>
 <Z0EZ4gt2J8hVJz4x@google.com>
 <6903d890-c591-4986-8c88-a4b069309033@intel.com>
 <92547c5fea8d47cc351afa241cf8b5e5999dbe28.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <92547c5fea8d47cc351afa241cf8b5e5999dbe28.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/23/24 03:06, Edgecombe, Rick P wrote:
> On Fri, 2024-11-22 at 16:08 -0800, Dave Hansen wrote:
>> On 11/22/24 15:55, Sean Christopherson wrote:
>>> On Fri, Nov 22, 2024, Dave Hansen wrote:
>>> I don't know the full context, but working with "struct page" is a pain when every
>>> user just wants the physical address.  KVM SVM had a few cases where pointers were
>>> tracked as "struct page", and it was generally unpleasant to read and work with.
>>
>> I'm not super convinced. page_to_phys(foo) is all it takes
>>
>>> I also don't like conflating the kernel's "struct page" with the architecture's
>>> definition of a 4KiB page.
>>
>> That's fair, although it's pervasively conflated across our entire
>> codebase. But 'struct page' is substantially better than a hpa_t,
>> phys_addr_t or u64 that can store a full 64-bits of address. Those
>> conflate a physical address with a physical page, which is *FAR* worse.
> 
> In the case of tdh_mem_page_aug(), etc the caller only has a kvm_pfn_t passed
> from a TDP MMU callback, for the page to be mapped in the guest TD. It is
> probably not nice to assume that this kvm_pfn_t will have a struct page. So we
> shouldn't always use struct pages for the SEAMCALL wrappers in any case.
> 
> What if we just move these members from hpa_t to pfn_t? It keeps us off struct
> page, but addresses some of Dave's concerns about hpa_t looking like a specific
> address.

For tdr I agree with Dave that you probably want a struct which stores 
the struct page*. Currently the code is using __get_free_page(), but 
it's a small change to have it use alloc_page() instead, and 
__free_page() instead of free_page().

The only difference on the arch/x86/virt/ side is a bunch of added 
page_to_phys().

Anyhow, whatever you post I'll take care of adjusting in the KVM patches.

Paolo


