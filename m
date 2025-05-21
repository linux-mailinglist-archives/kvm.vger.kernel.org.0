Return-Path: <kvm+bounces-47239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E7AABED7F
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5663B16F72C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EE02367BC;
	Wed, 21 May 2025 08:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3VB0gHn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007402367A6
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747814679; cv=none; b=OJqutNcXHd+axnlwVJuCEn8KoJzTNsO2tjNLDGEs4nbvWGgpL8/zxiaIiDHSzWVywXIgLnd3lQMQFxQwRS4xZkeu4USUNuPAMtC6oE/PWH6t8x0rfpuC5T7wo5lowIKyzLgpklvkU8rJVEq+Pb85UQMZulp2WI4vqIih4F6IuFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747814679; c=relaxed/simple;
	bh=zNKXfchCg+Fj0Yv+AW+0em9S5bOI8DdqTGzO1DyDBeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WxzBqnQvwBTn88h9Bqbub20dkFHgqj+dOTzu01fSJl0En9L2mGfzEfQ1Y+bSzKSKcQam5EJuhaFqs3Df8faeyOqvj2Oo2VUMBechOZvT3+bN9oS6br8JaitMAA3NNkBMa0BPljCWlNcwsaqizM4T7wDqqJBd5qhmu32dvnXnrw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g3VB0gHn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747814676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5MQkatbSq59Hq1aAxd8Kb1/0Y7cTgKXSUnnjVnQplpA=;
	b=g3VB0gHn/CeYDPeP3Xnkeb6C48SA1362iIDvFhTI/ggV4iNwP8OIV1O1WAKop5w91z+wdJ
	Hn3Y7+YGrSopnSbiOXH8iHbjg7vcMzUhVIns1TcpIqfgXG9ycmiSqDQcPQKYA3eVcK1XSs
	zkYMFm5x5wxi6pIMjlJeyMchespKlZ8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-tFDBVch4PjiGATYouhtxZA-1; Wed, 21 May 2025 04:04:35 -0400
X-MC-Unique: tFDBVch4PjiGATYouhtxZA-1
X-Mimecast-MFC-AGG-ID: tFDBVch4PjiGATYouhtxZA_1747814674
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a379218f6cso839348f8f.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 01:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747814674; x=1748419474;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5MQkatbSq59Hq1aAxd8Kb1/0Y7cTgKXSUnnjVnQplpA=;
        b=EXhKRFQooeHVGUBFVQKeeBPvNMbIl7umQZGWeBPJafZaa4CprN9xnNFVv+FeC9uT8K
         wT7emeyjrHbUg8/uttX/v3P+cp74/FlEbIcXa3y9JeMEnyzr0pA6UdG/5tIsdWdt6g1p
         r4dfryo6KENXiFPj4V4h2PHT6firkg6w656g2cO5VNkqanz2RWwqh7wkcAgoYb07JPR9
         idPBmSX3gtnRSM2mJvjGD/B/7CnFLeIrZM5tql1rm5y4sRpLWG8ol7TOqnqTKb88gm+O
         nxKHem/YyAvdBEd2t7e586JrLE6oTMpM2gWOeHJxwlFINEXNxjpQXFCxcTpO15q0ypRl
         VR2g==
X-Forwarded-Encrypted: i=1; AJvYcCWvx6tG10XFOWXx4Urftkg6ky4LzWH17FerF9N744QDrdi2zLk5avFDSCWMbmaRyPCZLgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvd5DMVw8VHFRo9KzDNp49AlFaBHMNBvSC3kfwjEGjYXku2ikc
	PYmsodoK2NFuaOQviEtvS5QECjCuiMtJB1Gk5HblGhlsLS0sdGDztOuSOViGK8+ELkgPlZCnR2Q
	kFujnSzBNF7WCpPCsxRc9M/RHRWEx8sQS8JrfPmiHxqvv8PjuWQjx9Q==
X-Gm-Gg: ASbGnctU+p8a3No91HX7rRTrOoGHNMQiddMU22W8rTJuONE/NwagLWq8DS1fWFVFSDn
	yAb3ZHmkCi5XeGDIqCVPbdtM8qH7eUAVlCjmCaQM3Mr8/oB+xQLqb5uoGa9SaNiuIg4E1xQ/Ye0
	GMTh54TAfb2s52YTROC4RjZz7+tZVTc+dqU9mIeB8DVqAqDfwKM8vwojKYyH90c0V4336HDWXqG
	sZlVRjTFLCybJl6xeagp1HIEb74SlNfLV5ykf3+4b0ORGRtPSQX/kA7EtWtH2tHrxDuuZYsyCAP
	VWwi4J2IxVKj4EYxkRdSS/N4qLkTc2LvkjOx72Y1eOCsLtgDm1kaHmyhPmM+PFZ9t2ah81tyL5Z
	ClkHMNVd66SX3U60Wsmn87gxZyUhBjf6IOp449Ok=
X-Received: by 2002:a05:6000:2306:b0:3a3:6a3f:bc5d with SMTP id ffacd0b85a97d-3a36a3fbdfcmr11584024f8f.1.1747814674327;
        Wed, 21 May 2025 01:04:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmnsxYTTDMbLHWYNst4ekZ+8J/GNbwLNU27qz+miwFXAcz4L5MCR40kU1t8uwMKwC84cZwjw==
X-Received: by 2002:a05:6000:2306:b0:3a3:6a3f:bc5d with SMTP id ffacd0b85a97d-3a36a3fbdfcmr11583944f8f.1.1747814673785;
        Wed, 21 May 2025 01:04:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f3dd94f1sm62076685e9.35.2025.05.21.01.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 01:04:33 -0700 (PDT)
Message-ID: <8d6eb79a-a68d-4116-bb42-ed18b0a0d37d@redhat.com>
Date: Wed, 21 May 2025 10:04:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/17] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
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
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-14-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250513163438.3942405-14-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.05.25 18:34, Fuad Tabba wrote:
> Add arm64 support for handling guest page faults on guest_memfd
> backed memslots.
> 
> For now, the fault granule is restricted to PAGE_SIZE.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

[...]

> +	if (!is_gmem) {

Should we add a comment somewhere, stating that we don't support VMs 
with private memory, so if we have a gmem, all faults are routed through 
that?

> +		mmap_read_lock(current->mm);
> +		vma = vma_lookup(current->mm, hva);
> +		if (unlikely(!vma)) {
> +			kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> +			mmap_read_unlock(current->mm);
> +			return -EFAULT;
> +		}
> +
> +		vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> +		mte_allowed = kvm_vma_mte_allowed(vma);

-- 
Cheers,

David / dhildenb


