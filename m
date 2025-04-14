Return-Path: <kvm+bounces-43217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8295CA87CB6
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 12:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49B7A3B2FC6
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 10:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34196264FB2;
	Mon, 14 Apr 2025 10:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3UAQtyw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FF32673A6
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 10:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744624894; cv=none; b=PtKj13SzAqAyWPYRU5zmCd2ogJlC047FxGf7/XbzJQ3HJ8sfLaF1FyQ/Jmq2R9ucJ6gV8+cxZ5Mp+AZh2xQJBRkcqLdTtQOysLFpPfpug/rHfpmIQD/4nZPSqNVCH5aMOkwVlHrRM0JgdJalv658TquXiKKnvKgmRVPuTbrmxOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744624894; c=relaxed/simple;
	bh=wRFao9Jxip8CWFWYPpBVYqFnQoxHYc6AjZdAz1qUM1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HIoVAT8Yz52EuGOxSRqmg6wkadNjxtWeFU0cHW76Uvx0/o4G1WIxQi8cycjT1ybOUdw2GqL6z8kboVZVj03CUccHAEBNFuqpwsjd2agqAgKBRCFl5E/gm6USz2oySoMObux/BZ7s4OmXlk50UjqY6e0XTqIew8Kivw6dSvw9VJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3UAQtyw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744624891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CQpHZGD3dD9RZvh09AEsXjx+o20A24mVtSCXWwzsMuw=;
	b=P3UAQtywk/9Y4PFEBA0Kjt9BppHJAApTkfJCX6dddNkNmP0l/P5lbHOFS3+X7Xpp24JZLg
	k/rgEMFqWmWQNvPG0qbT6cFXwrEQxKU8qDFNavZKkRWzeF3XHebA+eNMcVnZtQVQmQjjTw
	Va6OamB7ScyUlOP7yDNP9jSNrSYba2M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-JJ9A03KUOO25lWNIrEmogQ-1; Mon, 14 Apr 2025 06:01:30 -0400
X-MC-Unique: JJ9A03KUOO25lWNIrEmogQ-1
X-Mimecast-MFC-AGG-ID: JJ9A03KUOO25lWNIrEmogQ_1744624889
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3913b2d355fso1488179f8f.1
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 03:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744624889; x=1745229689;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CQpHZGD3dD9RZvh09AEsXjx+o20A24mVtSCXWwzsMuw=;
        b=dLc9RnirIPiqV8NDtv8joVayuU7AYbTT1FQYOCetr3ZK/wZVHfaigPN21VXyGbnmSg
         GYC3+2SKzqBmg4b8+TthSSM4ap/qxkjjLz220lY6aGvX5x3aIs22ib2SCysWisUekwvp
         rF8DhDv0vip4/Bm2LLsnPnUlwIBNZyDsx9T3x6FxG0HOL0+E2qiOzZTO9NTbqA0P5Up8
         Kd5rox500o5KNgeoFNvwLScCQqn4mRWhxcKQxgRDQVSAdt+1tPplyhuvNEac9fv+YmVg
         iWQDnjjPZIo4QafxaMyZ4dXUor1b13cPP0ci//nDKkn0QFwzqvaipkXS5oKUqzwKLd+G
         g9wQ==
X-Forwarded-Encrypted: i=1; AJvYcCXj0Am3lxp4EBBWNRz6dDu1SFopdmGEsXc7qMe5V4xJ+Lp5jHI8qHQ+8KOcnDgKJdayqsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPKJcy0Xh1IhmcT3uF/mu+dyKPDNTjuV7fBEYbBLRGFyACa4/O
	DepVXo9mmP4vi/pmNZDxDxE6+HUKob++7zqFHtvwYZlXiWuEd0/eev+1vDQ6crN7bRO7NhihHGB
	jzLLO0J/SygeAI2CvhOsEzOM1JM2N1IJonLcoIqmfLRHWoTDclQ==
X-Gm-Gg: ASbGncvDpp/LIpj25QbKnYMAucGtNWxDSoYKEvH14Jc5U6p7dRrgYwu5m8phEYbG+8j
	SCRJ48+mR+feZfAb7/pPats6lgBRH9He0/tG2A+6bO3pD2j7SFFgDdOBuit+H2NLxL5IMsCKIvP
	q12/rkxlde4KD5pxY8OOX0EgzfEsWOMxkZZ/6Ine5YNCvqzywsMDrJy+jThFldNwL7IKgmCkPSo
	+r7dgRll7jp0BRLpsBZk7v7bnLA1GP7jV+OvFZBPWGCoLTiZubS5MwtzF1qKOugNAIH11wPnrk2
	7EJtk6clXdQBGHqrg9WplV4ru2SzTPVbRi+/IZ9gBb5lrTjs02Ossk05e+ALlmuGkS9K2qGpq8F
	hTZHei5hY9TArqzFm6zYFWlfgosNzEW9J47wiYg==
X-Received: by 2002:a05:6000:381:b0:391:2f71:bbb3 with SMTP id ffacd0b85a97d-39eaaebe931mr8390592f8f.46.1744624888679;
        Mon, 14 Apr 2025 03:01:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXXXn6nBgguub3tboPkqAn7gF9G5oTdwRCb77CcKCe43y6I7udhFTVKhqGZRDa1trcIe7nmA==
X-Received: by 2002:a05:6000:381:b0:391:2f71:bbb3 with SMTP id ffacd0b85a97d-39eaaebe931mr8390518f8f.46.1744624888185;
        Mon, 14 Apr 2025 03:01:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f02:2900:f54f:bad7:c5f4:9404? (p200300d82f022900f54fbad7c5f49404.dip0.t-ipconnect.de. [2003:d8:2f02:2900:f54f:bad7:c5f4:9404])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eae978023sm10531763f8f.47.2025.04.14.03.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Apr 2025 03:01:27 -0700 (PDT)
Message-ID: <dc681818-1a6a-4e19-bff4-af4e232d79a8@redhat.com>
Date: Mon, 14 Apr 2025 12:01:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/9] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-3-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250318161823.4005529-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.03.25 17:18, Fuad Tabba wrote:
> Before transitioning a guest_memfd folio to unshared, thereby
> disallowing access by the host and allowing the hypervisor to
> transition its view of the guest page as private, we need to be
> sure that the host doesn't have any references to the folio.
> 
> This patch introduces a new type for guest_memfd folios, which
> isn't activated in this series but is here as a placeholder and
> to facilitate the code in the subsequent patch series. This will
> be used in the future to register a callback that informs the
> guest_memfd subsystem when the last reference is dropped,
> therefore knowing that the host doesn't have any remaining
> references.
> 
> This patch also introduces the configuration option,
> KVM_GMEM_SHARED_MEM, which toggles support for mapping
> guest_memfd shared memory at the host.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---

Same with this patch for now.

-- 
Cheers,

David / dhildenb


