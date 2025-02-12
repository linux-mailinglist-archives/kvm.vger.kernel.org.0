Return-Path: <kvm+bounces-37961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB00AA3236F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 11:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D5BB1888677
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 10:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443CA20897C;
	Wed, 12 Feb 2025 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6uwTcB6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771311E500C
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 10:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739355829; cv=none; b=qErDFPlcNc3QN732LLh9r7MSjDOmw5/GiL7qMSmskNynYMn2tpjr+FgIXivKToWe7AEfuJZ5IiZwvfoZfIDY9S527/iZspSfT+TM/+OSs58raPZJB1SzvuJvObJ6ps6ghLA8F4/EhCePsgmitz+hctOz2vmd+m5iXzKUeyQcgEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739355829; c=relaxed/simple;
	bh=BZBEVuaiMiQpifiiunyV3GoEyCbfAhZHtiKdSJfCe5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PJklH2mFfQ1vE3vLPIvxKi+Z6ksVFd0hO/ZbCgd8PuujHbAmjRiQFlo8g6VgY5shC15m9rUbk0HfcPWVXAuvklikSiCowyWFw4/JXODrURqgN/tktYc0ImlCrI4ZWJxkoc27JdDXtqZ/BygYOdgxyiucqDvAW2uMvC6RJtVBkq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6uwTcB6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739355825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L8X4DcZFs2elKxOWwa0k/NR+c76D4y+brE6Aap7ycNU=;
	b=U6uwTcB6eM/mhAvMZkCu0gZokW4O/edU8XqINz3Yw22vG59YffkOGfO0EDOotGEESAF6hJ
	bw8qQjJkF8zweaRYRhdEULpFBTG4GJ20Rt0/QGh+GzelS43s9epwbMPFflnkGb9RfKCzA0
	I77BLMR/m6kuqQaiYk1KW+kH5kiwQI4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-xPBBCUgmPGKLfsbwNFKBBw-1; Wed, 12 Feb 2025 05:23:44 -0500
X-MC-Unique: xPBBCUgmPGKLfsbwNFKBBw-1
X-Mimecast-MFC-AGG-ID: xPBBCUgmPGKLfsbwNFKBBw_1739355823
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dc56ef418so2617771f8f.1
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 02:23:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739355823; x=1739960623;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L8X4DcZFs2elKxOWwa0k/NR+c76D4y+brE6Aap7ycNU=;
        b=g3Sn2fbBBajpRGEcMr7u7Z0hWrYKEpo6wPEnGYiQoKKz0oJ7nhb9tR0ktIes3qiOty
         OVkSyARqKqpjgbEmDmrC9Jr4gGavXGipJIninrwCAjISWzigvpNwUVY4MUy5fqPZ8c3D
         Fj3j+B8rlzZSloEO2xqEAKvCOWH7zIDBlnKvssqUPJ+KzB6nLmH7qh9NivSUZHOBGg7m
         yugPilE+ICxonTJB9999Vo1EXk7/w93ERx1NsSTSDX/aE+AtYzT0FYEanoHs3KzWJdhD
         X41P5KKf6NtUgfE72eK/Vqixke25FpcJj19Eiz8V17c0GOPWAGsYgi6l8UFOfVdszosi
         wl1A==
X-Forwarded-Encrypted: i=1; AJvYcCXjqvQ228GjpIt76tPGIgMHMAb5vhHWt4GH/gvrCy0WPgcjZBuXhsaW6i5mmYqtmSBgN/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZKtuLgDoaexDuPm8ZtEKsALieANihpf40OdoYjzFMGtjIjnOR
	U2E1HQUMSQvyWK60UyVtI9Shd5mRdT8l8mMUK1MF8LhLHzvFpTo5sGq8fIhjVJW5tI4m4uSuYM8
	xmRls0lslGwfmJ38PwEp45wiBOLjbbpwOZdhK6lGtPtrT96J8Ng==
X-Gm-Gg: ASbGnct892u45WoZhz89/OPSX2odjtPORogFNfQ0WcvUQnEkPaac218302ThRpAiAAS
	VfGTRLxDMZNHa6OqQvpFV/DO/YpvpRp9o7UiwsM2XEexru3mXhEPuHTcBfrYS71tDX9aY/9Nn1y
	IkF0h82unw2FJO1+1CPe6lWM+ukToOQrdNUxLETPSFEsUtnCTt+5T4bKmQGLpI6Uk9Kp6YtcHr7
	dxB+SIvgj9D0K0x2BHsrssC0LjAEi59YCiv5cFI8lTrAMqyKK1fwFdXiG1KtAdySaGY+3YJSGAj
	DxBfTO9dh52D/u5Mgd8/SzR8Z9tOrjlI7NuJ9r+UF9do+s+QeVqkH7l9hSPZW9+KCReCaCoNpiR
	EKUmmW0s7LhxJa3DRNuYDokuXN+KN2w==
X-Received: by 2002:a5d:648d:0:b0:38d:e6f4:5a87 with SMTP id ffacd0b85a97d-38dea2516e5mr2148770f8f.10.1739355822866;
        Wed, 12 Feb 2025 02:23:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7zr5n5F5+dcD+mXARYuAo/50Zt+QCUnGeNukOUn+08qLpr3cu4noNKpaotZqF4NpfaApiaw==
X-Received: by 2002:a5d:648d:0:b0:38d:e6f4:5a87 with SMTP id ffacd0b85a97d-38dea2516e5mr2148727f8f.10.1739355822457;
        Wed, 12 Feb 2025 02:23:42 -0800 (PST)
Received: from ?IPV6:2003:cb:c70c:a600:1e3e:c75:d269:867a? (p200300cbc70ca6001e3e0c75d269867a.dip0.t-ipconnect.de. [2003:cb:c70c:a600:1e3e:c75:d269:867a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dc5a8a9e4sm15765546f8f.10.2025.02.12.02.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 02:23:41 -0800 (PST)
Message-ID: <9392618e-32de-4a86-9e1e-bcfeefe39181@redhat.com>
Date: Wed, 12 Feb 2025 11:23:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 2/3] mm/mempolicy: export memory policy symbols
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org,
 willy@infradead.org, pbonzini@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, chao.gao@intel.com, seanjc@google.com,
 ackerleytng@google.com, vbabka@suse.cz, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20250210063227.41125-1-shivankg@amd.com>
 <20250210063227.41125-3-shivankg@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250210063227.41125-3-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.02.25 07:32, Shivank Garg wrote:
> Export memory policy related symbols needed by the KVM guest-memfd to
> implement NUMA policy support.
> 
> These symbols are required to implement per-memory region NUMA policies
> for guest memory, allowing VMMs to control guest memory placement across
> NUMA nodes.

Probably worth mentioning something like

"guest_memfd wants to implement support for NUMA policies just like 
shmem already does using the shared policy infrastructure. As 
guest_memfd currently resides in KVM module code, we have to export the 
relevant symbols.

In the future, guest_memfd might be moved to core-mm, at which point the 
symbols no longer would have to be exported. When/if that happens is 
still unclear."

Acked-by: David Hildenbrand <david@redhat.com>


-- 
Cheers,

David / dhildenb


