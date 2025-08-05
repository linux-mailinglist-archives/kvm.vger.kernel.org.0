Return-Path: <kvm+bounces-53980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29BB9B1B30B
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:08:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C108A18A1C21
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1470626E6E4;
	Tue,  5 Aug 2025 12:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSguZGx2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8357B248F42
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 12:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754395679; cv=none; b=RSMS//bREee3JwF3zkLrUxeUGxqEAgcswgwvuxt27yqWmMFosCAuw2S+drkxj7oOLZ5O0fz85IUGwaAOZQaLq3navEwF5GRi7b7EotbB5WFjVTNW1MnhxmebkhKeQzkTc+Jb67/7QW1Xsknpj1/HEeD6YQUMDhENMFdPjmFVskc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754395679; c=relaxed/simple;
	bh=IppRhA9f5LX9Nb32MXQBE5CFGdG98rfIOP9iCkcxLn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jpdGtIK3j+0zec7O711IqFiQmUxZGilLBBO14XvFRtSMMq344rxl3Wnc/dKndwX3J3tV9hTFoTNeRGcaHHPw5djnAlUBqeIlYmfVu924MpuKblwKQ4XaVV3sIPlrO6LggGJhUC/6oBfhcAVqsYgrNX6X4bqWOv7o65mAmR3i+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jSguZGx2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754395676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7g5TY6RCcpzFCYXDHvD8PiehF1IggpjyaG88FCPGaI8=;
	b=jSguZGx2iajHpAVHc/wSSM54tZtzqKJeHeWeOK61zVb9bN77AN4992wgemzEJLzxhwS/Bn
	MILAGzi6UMwbG3ic0wyJ79/8pyyayfnVETw63kVMMbQeV4kzrXoQzU0haWrNj9Q5Io4zED
	rUv3rmv9gWSqWAyykl1475R+1z5AYIE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-rD02UgZyN32fQj6eviubxA-1; Tue, 05 Aug 2025 08:07:53 -0400
X-MC-Unique: rD02UgZyN32fQj6eviubxA-1
X-Mimecast-MFC-AGG-ID: rD02UgZyN32fQj6eviubxA_1754395672
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459dde02e38so8603875e9.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 05:07:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754395672; x=1755000472;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7g5TY6RCcpzFCYXDHvD8PiehF1IggpjyaG88FCPGaI8=;
        b=bmOCunT/hcAHxl0uuXIMyfg4hq7nUvUn3zl11iufgK1S/p87Gn730ny9QfaOzc4/mL
         u0veE1vqn0POqtkhmJngJRGXO16M/Otw0RgYs2LAkszkMeiey+w/OKLTDbbDmelmZDEw
         iOBphvTNhILYqkYoEHW/j1wX+OgjroMQoxWER5X8mS9dYfXWp0128qMgGxqstDBCSBMG
         3c6hOLUMynKuTbd75ymi4GrZZxCiVCY8mdA8uJA/n4mKViYj9qfz0tWFaJW+VF3/tn8a
         Vjx+9xh+SBogjdx8lhajA3OQIDUpktq1CSDua6PcKD/8bIZkyB8s+wxKLvttu3XVjzsD
         HTAw==
X-Forwarded-Encrypted: i=1; AJvYcCXLkKrW4wl9n6kbhTnSSQBS/g48mhmqghEOgETurWFhHHt+eNXBTsKJApLsRO7PsFWNa1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBGg1o/iE0QhzmMrVVXdyH2yPx4beZL/1yJ7OyH6fFsuV1pvRM
	T/sm4YzyK/i+3D30PnJNoLChgieel/D3uyI5KRuxfBeEZOefNfm1ziHpWFehSNf2zMjBVmBtGQG
	aluB8K7n7k8G6ZKQeGdi5HOVEINpobbZ/R0E2rNj3cF0NzujNhUTeFQ==
X-Gm-Gg: ASbGncuF3P75ru7McLKIXPi2FpO6skCixaANVCwu81gzFHhR4Kod3zaAdl6p3UJm+yk
	CCcx/ecsECSQbUSGwzQXfdojcQfCbKrizYINdBxwvdpEoRvZsQfHa685d8ix8HQFXjXkVzdCPsR
	sYr3beaCPOatKQPH52U/dU9iaCNJgy+vYCneCf+HVY6U48AdD+OX6Edo9g1GmkEhOhPZhCS2WAX
	FTDLTGc/iPICoBi5IXfM974P6PL9ylqzHiI0SBW3fbaf/sYNNNfwDRB7i+qhyjdzDdDK0Blq1XD
	rNSlaoM26n8BeDAZvfjQDdChOnhUcxaZf6uRTQEyHTFReuWeLdQTPOw5m0m5+qKY7CTtyvqhizX
	x/6R0+yiYJgTP1KK4mhEVq9t0TKXkNa4KpGK2801HwZAf1REced9bmEp48hRLGZf2XH0=
X-Received: by 2002:a05:600c:a43:b0:456:173c:8a53 with SMTP id 5b1f17b1804b1-458b69c8300mr110640365e9.2.1754395671744;
        Tue, 05 Aug 2025 05:07:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+IhNRqRL6jSPu1sN+HeHznfpj9c1/PPhayfhWO2xWYBfi+odz5/vWfgQK82w4OMctODG6Xg==
X-Received: by 2002:a05:600c:a43:b0:456:173c:8a53 with SMTP id 5b1f17b1804b1-458b69c8300mr110640065e9.2.1754395671242;
        Tue, 05 Aug 2025 05:07:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459de0d4cf1sm59347605e9.13.2025.08.05.05.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:07:50 -0700 (PDT)
Message-ID: <9b447a66-7dcb-442b-9d45-f0b14688aa8c@redhat.com>
Date: Tue, 5 Aug 2025 14:07:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <20250805114908.GE184255@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805114908.GE184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 13:49, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 09:47:18AM +0200, David Hildenbrand wrote:
>>> There was discussion here[1] where David Hildenbrand and Jason
>>> Gunthorpe suggested this should be in common code and I believe there
>>> was some intent that this would get reused.  I took this as
>>> endorsement from mm folks.  This can certainly be pulled back into
>>> subsystem code.
>>
>> Yeah, we ended up here after trying to go the folio-way first, but then
>> realizing that code that called GUP shouldn't have to worry about
>> folios, just to detect consecutive pages+PFNs.
>>
>> I think this helper will can come in handy even in folio context.
>> I recall pointing Joanne at it in different fuse context.
> 
> The scatterlist code should use it also, it is doing the same logic.
> 
>> The concern is rather false positives, meaning, you want consecutive
>> PFNs (just like within a folio), but -- because the stars aligned --
>> you get consecutive "struct page" that do not translate to consecutive PFNs.
> 
> I wonder if we can address that from the other side and prevent the
> memory code from creating a bogus contiguous struct page in the first
> place so that struct page contiguity directly reflects physical
> contiguity?

Well, if we could make CONFIG_SPARSEMEM_VMEMMAP the only sparsemem 
option ... :) But I recall it's not that easy (e.g., 32bit).

I don't see an easy way to guarantee that. E.g., populate_section_memmap 
really just does a kvmalloc_node() and 
__populate_section_memmap()->memmap_alloc() a memblock_alloc().

So if the starts align, the "struct page" of the memory of two memory 
sections are contiguous, although the memory sections are not contiguous.

Just imagine memory holes.

Also, I am not sure if that is really a problem worth solving right now. 
If a helper on !CONFIG_SPARSEMEM_VMEMMAP is a little slower on some 
operations, like nth_page(), I really don't particularly care.

Eventually, !CONFIG_SPARSEMEM_VMEMMAP will go away in some distant 
future and we will all be happy.

-- 
Cheers,

David / dhildenb


