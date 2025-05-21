Return-Path: <kvm+bounces-47228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E32ABECD8
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7FED1BA53B3
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 07:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDA0235341;
	Wed, 21 May 2025 07:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQGl0UCJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F41122D783
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747811705; cv=none; b=GVGfrKh2xUIQQJqFNw7JWHJLDTwDZP+addYekXnQ1y30qzXOYYExuCJdpPznUJqUXsGmg5ZyW/ANMKXax5QfUsEoNzQ1+aIARFxKSp27y4Rk2menyFREF76xN9UEI2u4DxQtadQF2M70D8c99gOQ19y84AsJc7RBj9hesQRAKI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747811705; c=relaxed/simple;
	bh=27N//sgpUvINXwzlWBTx/oTGY+oOdmZxMUtIWjJ1tyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hr+gVdDBLfCJH7VVw7PQnHqJh0LfGz9vSuL38a7F2/KlXsKqjCBaj6wVzlVbwxteNM+8zue9UACUgLBwHM2XV8b1V6LNjjJXvYx/vnRMgVavxbNQ9cIqgoiWsd7oCMXx1vhYbIL0WHymnJNY2fk4IOJFoXAjajlzfGYdXIpx1cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WQGl0UCJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747811700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mMLgAYcXkQ7ab1MRKxScrwK5iXyGw0HpuxGnY+yOMMk=;
	b=WQGl0UCJbCx7Aws7Ni4T/2ePSWWGfru67HrESqEEjATKZcvPzJulTEulZjDVp38y6HTDOy
	hj12H55BRQuOTPyQRiql5c08doV+Y5FnJFca6Efa8lMi3HyjXDWxrpoAn/2ql14OFl73Jq
	YsH0j2gMiyFwXFOZU0GnN7HL7SO67KM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-4b6E2UD2OteYPhNf44qo7w-1; Wed, 21 May 2025 03:14:58 -0400
X-MC-Unique: 4b6E2UD2OteYPhNf44qo7w-1
X-Mimecast-MFC-AGG-ID: 4b6E2UD2OteYPhNf44qo7w_1747811697
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-30ebfc28a1eso5330410a91.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 00:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747811697; x=1748416497;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mMLgAYcXkQ7ab1MRKxScrwK5iXyGw0HpuxGnY+yOMMk=;
        b=bMoCCF2FImZm7opxG+GHQJQL5TOpHRrzVYi7nSQ/Wdc0qJaMCxAxE4AVRyc2RseSNh
         aIWQ1DB5z6hxqRgE+K0qdpKNTv5sBsunFDP/kcBY7cSv1FAm/igAZfdmT5XN5mYqfLqV
         /6xK5qxByI+9r+uzitIu7LlH8hi0/kNjGPFc6vpgMtz0fF1uiBvMFqiv9HSMIU4LOGP/
         L+1q/CNE67byvtxulq7akFqR29T8ScbLygK9ZpsPicTPQ9f0W0PGQbunFcjabWx8L3gp
         CH8kReMhmoBkW118n3Z4kJnmuJ79D5yZOR5b7DM/LlLtsIHkLdrn3GGCuvcoSdyf41M4
         LvoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbnc95RsQZQrraqhykOHt9JF2nK61RizVy3ZHhXXqO/0exhGqKa2zyGkniOp4+1O9EBY0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf3K6V+Hw7X1sm/6tFKKSyExFu/TNCvFMvXadI5bh5RzfG/Aj6
	QF17RciuTVOEZ3JopwovWIAtHj8AbN4NGLYZZ4Hd1fhuKYe/SA0R/nsaqMaGfIEqUN0iwgcrNHp
	Jz/jS+gRej0xUnO75Vhae8iRQLh8YZj0Hk/1efWgZbIzul6npytH9pg==
X-Gm-Gg: ASbGncvG+sRTL/v8UtcI1RqIdjgxfNyntU5b3PEu9vonj1rSZTaxUu+7V4W1W4Rf6kL
	evt33Fg61QnGlSzH/YWA6HNzu0eUKp0PTDv3eLuRYds5sEn5MKeVvBBb7PhAnnLA8zvAoEPvAm9
	DmF6xkPFhJ/rl43RiAqcfZx4tkxrUzESJA/oHpkKToDOAHT9BXrLUFmKxngwDPwQhp186OfU4qJ
	my5ge+7nScHXWWNU0ZZdT/mMg/ocMVmDEaqPyBiV9umuVh42HuqpnxTKMHustYJu3+N6zGIPFMY
	XMEvn5zw1C4O
X-Received: by 2002:a17:90b:2d47:b0:2ee:9e06:7db0 with SMTP id 98e67ed59e1d1-30e830fbe8fmr27072728a91.11.1747811697042;
        Wed, 21 May 2025 00:14:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0wnoGGQNK4jnpp++iVbLeuYLd164Ahc4bw0fjZBhvg2JpazbH+4EPDc8cfRErjMHlyGXurg==
X-Received: by 2002:a17:90b:2d47:b0:2ee:9e06:7db0 with SMTP id 98e67ed59e1d1-30e830fbe8fmr27072701a91.11.1747811696660;
        Wed, 21 May 2025 00:14:56 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365d45e2sm2946400a91.27.2025.05.21.00.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 00:14:56 -0700 (PDT)
Message-ID: <793c5439-8656-408e-866a-3ef3c1643df9@redhat.com>
Date: Wed, 21 May 2025 17:14:34 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/17] KVM: Rename CONFIG_KVM_PRIVATE_MEM to
 CONFIG_KVM_GMEM
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
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-2-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250513163438.3942405-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 2:34 AM, Fuad Tabba wrote:
> The option KVM_PRIVATE_MEM enables guest_memfd in general. Subsequent
> patches add shared memory support to guest_memfd. Therefore, rename it
> to KVM_GMEM to make its purpose clearer.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   include/linux/kvm_host.h        | 10 +++++-----
>   virt/kvm/Kconfig                |  8 ++++----
>   virt/kvm/Makefile.kvm           |  2 +-
>   virt/kvm/kvm_main.c             |  4 ++--
>   virt/kvm/kvm_mm.h               |  4 ++--
>   6 files changed, 15 insertions(+), 15 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


