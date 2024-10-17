Return-Path: <kvm+bounces-29115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A20959A2DD3
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 21:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29D571F26D0F
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C990227BA8;
	Thu, 17 Oct 2024 19:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hXVtHepq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE8227B82
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 19:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729193409; cv=none; b=C4x3cAZRoEXHEwffB7J82Lr9mcm0N65ue/4EmqRo7Pl4rac9kJApIMWGviy7BGCLmqQXTksanWNdmdQb52vNYC5D91NNevbMZFGsvPKEHvf5+Jw0Kbp9M/L16DiNR7ur9ktv6jcnka5gOtoD+FM/M0oV9FoXZjhpWsADa+0rJrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729193409; c=relaxed/simple;
	bh=4zJUTh6iCQ9WpJ4dNui+w2BrCh4MsEUdI5c2UQF1dyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fwhnqE9E82cz1rq/2wiY9huj3sDXcxYBIGpzIxNrRHcvO69Sik4aqqd1m/LZhsiXgry6glGUt7WTRtKYKGVZ1EwBfz2a3ah0mQ72B1NnnAhHs8wsZU/XVyPBm40p5GwQFqSh9vJj1Vi79y7Ir/zvezKq0lS15R9YoOsvYwijuYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hXVtHepq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729193406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mBVo9xAZHBe8/QcNUoHHfD74lZqrXoKlDTOiziMttfs=;
	b=hXVtHepqNdiCtftnn7bms7q5F+6A3BeM8o0tXlOsFG3ehzs894vH5xuWzHDFJpfoiu4OPF
	EwsMGblzbg4q9ee5gjRxxG3O872NahtBM3IHg2hxBdHFTx0vP0q44h2ha0sFhAnMU9qPEY
	I02Eal70sX3uMUGsYA3Fq1P51951M2Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-qTBygfEaOKasK4wNCFqwYw-1; Thu, 17 Oct 2024 15:30:05 -0400
X-MC-Unique: qTBygfEaOKasK4wNCFqwYw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d609ef9f7so621584f8f.3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 12:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729193402; x=1729798202;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mBVo9xAZHBe8/QcNUoHHfD74lZqrXoKlDTOiziMttfs=;
        b=QBMAqeoLp3AKJjy5//i3AAZxwUJgugxsgDUEG8Q+4ynEhAqVVT99yWqzB8Uxire7JE
         SEUieznSyfESeWEnicNh1TK8Klhf/EHgMSBl292mfi2iQtwXpn9RTIIaeYzLLbXfRYI1
         rO0LxaQflsqVjQ2c30IuvNf8ruInfPtpk0Dc0642jSE4wdA8RjIAmOWhl5LdWBYulvlv
         rRQuGSRSu6p/TfCuebKqXYkufhMh76D1WlJ1H+xdDhT349osuXc+BEwujDn2ltXL/rdJ
         PsVD/O1AzuIG3YurcD4sII6ySwt6wDn9ORqD7HTbbWFY4pOO8+cyNh9m2QKEO/OPjAAK
         pmkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVV0YAB+yVluJnahGk2nE34eMXGwBID4dYpYXnbbaqOVgUhPWJqJRgyVUVRR/dyEhOY9Hw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8JZHh4KBXXsU/gQGuqpgsC+Rc2gKhrwmjEg3cQrC3aM/vKr5f
	856ZYw3i7118SHbBJJxJt5wvHrqcmr5w9ZHaAojKLRxr1qG2M212Ldrdd8QJ8DkEpXfVuJEv5NX
	2Uajd57RobOnp7fATjf+34ETuXN4muJBSE1LXNfGJ/QwJ34W6pw==
X-Received: by 2002:adf:e988:0:b0:37c:cc67:8b1f with SMTP id ffacd0b85a97d-37eab710526mr25682f8f.48.1729193402214;
        Thu, 17 Oct 2024 12:30:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKqU/S9jlgJjuxhtV5N2d7rJti6eXC2LD0aFphGo10hmj1XRmV/IjPPKcEWjWXUKh1qjYj/w==
X-Received: by 2002:adf:e988:0:b0:37c:cc67:8b1f with SMTP id ffacd0b85a97d-37eab710526mr25653f8f.48.1729193401696;
        Thu, 17 Oct 2024 12:30:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:7600:62cc:24c1:9dbe:a2f5? (p200300cbc705760062cc24c19dbea2f5.dip0.t-ipconnect.de. [2003:cb:c705:7600:62cc:24c1:9dbe:a2f5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fc12dbcsm8351867f8f.96.2024.10.17.12.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 12:30:00 -0700 (PDT)
Message-ID: <a21aa503-39ed-4f6d-ad2e-a6a4b9a636b2@redhat.com>
Date: Thu, 17 Oct 2024 21:29:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
To: Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, tabba@google.com,
 quic_eberman@quicinc.com, roypat@amazon.co.uk, rientjes@google.com,
 fvdl@google.com, jthoughton@google.com, seanjc@google.com,
 pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
 jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
 erdemaktas@google.com, vannapurve@google.com, qperret@google.com,
 jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org,
 brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev,
 pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com,
 anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com,
 vkuznets@redhat.com, maciej.wieczor-retman@intel.com, pgonda@google.com,
 oliver.upton@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <1d243dde-2ddf-4875-890d-e6bb47931e40@redhat.com>
 <ZxAfET87vwVwuUfJ@x1n> <20241016225157.GQ3559746@nvidia.com>
 <ZxBRC-v9w7xS0xgk@x1n> <20241016235424.GU3559746@nvidia.com>
 <ZxEmFY1FcrRtylJW@x1n> <20241017164713.GF3559746@nvidia.com>
 <ZxFD3kYfKY0b-qFz@x1n> <20241017171010.GK3559746@nvidia.com>
 <ZxFhTtEs2Mz7Dj-O@x1n> <20241017191829.GA3559746@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241017191829.GA3559746@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.10.24 21:18, Jason Gunthorpe wrote:
> On Thu, Oct 17, 2024 at 03:11:10PM -0400, Peter Xu wrote:
>> On Thu, Oct 17, 2024 at 02:10:10PM -0300, Jason Gunthorpe wrote:
>>>> If so, maybe that's a non-issue for non-CoCo, where the VM object /
>>>> gmemfd object (when created) can have a flag marking that it's
>>>> always shared and can never be converted to private for any page
>>>> within.
>>>
>>> What is non-CoCo? Does it include the private/shared concept?
>>
>> I used that to represent the possible gmemfd use cases outside confidential
>> computing.
>>
>> So the private/shared things should still be around as fundamental property
>> of gmemfd, but it should be always shared and no convertion needed for the
>> whole lifecycle of the gmemfd when marked !CoCo.
> 
> But what does private mean in this context?
> 
> Is it just like a bit of additional hypervisor security that the page
> is not mapped anyplace except the KVM stage 2 and the hypervisor can
> cause it to become mapped/shared at any time? But the guest has no
> idea about this?

I think what Peter is trying to say is that it would all be shared. 
Private conversion is never triggered by the host or the guest.

No special security, nothing. Just like using hugetlb, but without the 
hugetlb.

-- 
Cheers,

David / dhildenb


