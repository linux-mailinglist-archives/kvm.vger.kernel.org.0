Return-Path: <kvm+bounces-36300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DDF9A19AAC
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 23:10:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE1F37A4279
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 22:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC4B1C878A;
	Wed, 22 Jan 2025 22:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYJeucON"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488FC1C5F1A
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 22:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737583826; cv=none; b=pm4smhm+1/k9+H2k5J1Y4BQ91TlguS7fuPuk5Vk3TRSR5BC693eOcDz0vKqzhNlG6uskh1Tpjopu6E6BzF/qRuL9XrLbLQGfBgh+q6OhY2WF89ba4rMWOPIeL82ElgTdYvIhORh4Ejy9T0JylqaJqzcSwfw/Yk6AuVrvF2AwdBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737583826; c=relaxed/simple;
	bh=pCrncV0z5bkWLtHo91ql86oh7+GOsbNvbED6dbZ0qT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CQl02ivfwfzoCtm8gjPIIIffTqSZh2gYN2N+3UiUgnkiCFh+p9tccLD5zwyFBAxquac4khlbrpruxs7dfiMP/C2v0r9zHbla3JDAclmZM5xlsfJcRR0iVJvXdn4yBurElNhT5Bbu4OhReuR52KebptsSMA5wPbSWNDsB/n3kfvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYJeucON; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737583824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OFgHbojN+iBhRB/FpH03KxB9BFBasWsgYiGNqZj9t+M=;
	b=CYJeucONti+VQgDGqJxzVpPRXoyu8ew5MOZ33T2neKM0boC00s6vvnimDx6zQOnPLN/pv0
	hk1sstwV5LF9l9nEeITSw4en7aL+W0Fz7OIosjHHNRXa0xD4Fp9Jxs3CwMEu14xG/W0Q0W
	nZufjgiRfuuWNJq8hTq7FfjbgXXC5Cc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-e5NEuV8HNxqACnRaIz-wjw-1; Wed, 22 Jan 2025 17:10:22 -0500
X-MC-Unique: e5NEuV8HNxqACnRaIz-wjw-1
X-Mimecast-MFC-AGG-ID: e5NEuV8HNxqACnRaIz-wjw
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38c24ac3706so56504f8f.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 14:10:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737583822; x=1738188622;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OFgHbojN+iBhRB/FpH03KxB9BFBasWsgYiGNqZj9t+M=;
        b=XsLWV6+fLOVJzPHKeJGmqK8vsaaf8Myi1kF9E9btQzdHob9WY7J9I6eUXjQhYIMu0S
         jI/64kVQYorqHZ092UKFH1lk7JDxl9eKtKR4iAMsrQtsZSQMBHvm1RTW3mHGuoL/HdX/
         2+NxhFjAbcVZSd0F1Q1KK6nde3hRgDRsn406snTTSa8JRb9dkpFY80t5/nLtppZb1l60
         /gAqptUQ4BFdZkKU6FQYWXhtxeC2+C0DeK3vh5lcf4lKWC47W+ZCu7EYx029tK7jCLPi
         KbDnhxF4bRFrx3C1gYuX6VGWzugCZAYB6CPCepeCuyL22IIKEfglLfDi6almxpK+X6mZ
         x7jw==
X-Forwarded-Encrypted: i=1; AJvYcCXBto4TGo0caIfayogIQuWBx4LDJB5Ih/60VwlZr4HfWs42QtOkZYcWhxkB3mVD6IrFfcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL1dB4gX3baWWqGkdsFlmeCbYid5Uhbb84NfUffvwwrHZTaWpa
	KEkIuBgQhV3ojyWtlVrwOszWPbZimgEeNUCC7kbB5tcIm9Mu1aQRbLekjGOXQimiXTTiEQzcMjq
	EAMEqUscb7MjF3/fmQw2jvhYmtjOFSOIv9YkCHBEWigLdTPkVFw==
X-Gm-Gg: ASbGncvCkL5dVPBo85MaOCOKwKPxmbVMCheLlSKNbWoBfJr/gbwHN1q4XWhLHEIZQad
	vz3uQ5tdleQZ7KR4JdhYF2CL/0KHqKb36LNsEi1vk6/2paOjkWt1ufGPSQs7WIPlnlary+DR2bx
	A8Hpjm1XgEy6vNfRaLdLjSGEu3PAf5ySz5E16U7XVstYncauWgaTZsKSuau7PBJQ5tSb/tBY5Hr
	Dhmgtwtl32HAem6qtfDwXJZVZrUjWXmIUO/ly1xV024dzFu3FO9sJ63vdQcDfttBqkmY+dPBfUi
	64pcRfdJbvb6TF/5fyTgcXS2X6qfeV2288ZOO49tTtV41Pchk61/zQtbP1zHzR3VWrAAVaju8OH
	gxyBlRYkD6pJ+gXb2JZ44Zw==
X-Received: by 2002:a05:6000:1567:b0:385:fd07:8616 with SMTP id ffacd0b85a97d-38bf55c4d1emr21359206f8f.0.1737583821755;
        Wed, 22 Jan 2025 14:10:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0SzkOqe0MEBf1yIZKwX1Ve2Umkvx3WadB6+1kbC5y3OJDV+pXvJnmfBdgWWZOsbPChsLT7g==
X-Received: by 2002:a05:6000:1567:b0:385:fd07:8616 with SMTP id ffacd0b85a97d-38bf55c4d1emr21359196f8f.0.1737583821423;
        Wed, 22 Jan 2025 14:10:21 -0800 (PST)
Received: from ?IPV6:2003:cb:c70b:db00:724d:8b0c:110e:3713? (p200300cbc70bdb00724d8b0c110e3713.dip0.t-ipconnect.de. [2003:cb:c70b:db00:724d:8b0c:110e:3713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf32151e6sm17120330f8f.20.2025.01.22.14.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 14:10:20 -0800 (PST)
Message-ID: <e6ea48d2-959f-4fbb-a170-0beaaf37f867@redhat.com>
Date: Wed, 22 Jan 2025 23:10:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to
 kvm_(read|/write)_guest_page()
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <20250122152738.1173160-1-tabba@google.com>
 <20250122152738.1173160-3-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250122152738.1173160-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.01.25 16:27, Fuad Tabba wrote:
> Make kvm_(read|/write)_guest_page() capable of accessing guest
> memory for slots that don't have a userspace address, but only if
> the memory is mappable, which also indicates that it is
> accessible by the host.

Interesting. So far my assumption was that, for shared memory, user 
space would simply mmap() guest_memdd and pass it as userspace address 
to the same memslot that has this guest_memfd for private memory.

Wouldn't that be easier in the first shot? (IOW, not require this patch 
with the cost of faulting the shared page into the page table on access)

-- 
Cheers,

David / dhildenb


