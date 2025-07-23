Return-Path: <kvm+bounces-53260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88955B0F5C1
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D73F1CC28A2
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0412ED170;
	Wed, 23 Jul 2025 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bVBMpzka"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1AE2E719B
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753281983; cv=none; b=UVi2c3N8isYzf6sijFH9PnGHj6i9LVwNL19784aPI2Ia3zIm4TuRGbYDZ47yoE0Z4E8FB0Embm3ayJLqwyfRZmxD/Ue9akE4whseGqQ/RPSvh/1VMrgDFKC1dnw4ft/8KLAGcZlejOIGAWg0BeUMuzEznABrlbeAvQ2UJRtCeHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753281983; c=relaxed/simple;
	bh=Xh6oIoE4xZXpon/PVkAq/RPJxCsDo5JS+ZCbrwPfgqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lLbjXKnCUKeh4wLCc50nGq4P6FXW7entxT3jXhx+oYkx6hltoQsisViz99NWRYAiFT2XH6zKAXXmHCR3TT8CX1HDbWoNVPOfaUxUYK9xcL/wV5eSy9XhYtjyXPUoZ6iSh+LqxXGBu61sFl3LvWn5CgbrCuJeggZZnO6JZ04IMIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bVBMpzka; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753281980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CQGgiEKZ9BLW6U6k5xk1iAQnETQ+XftQ9J9xgQIohlk=;
	b=bVBMpzkaf5f46A0p2xPCAfsf3/GqRWjs7Ym3FzsOApLo8DkD8e+GY9xst1VXTfL1b+Ra/6
	CyV/b6Kcdeu0J6J48glIO8jWgT7ANXFomFCAm2wfzEFCtnPOhB327eIX0beAiu3MjQJisM
	lhMjS5klYqvlVAflSC2bzu/V7mrzzts=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-Upu7vSvEND6IQoP4ynOyTg-1; Wed, 23 Jul 2025 10:46:19 -0400
X-MC-Unique: Upu7vSvEND6IQoP4ynOyTg-1
X-Mimecast-MFC-AGG-ID: Upu7vSvEND6IQoP4ynOyTg_1753281978
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso111295e9.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 07:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753281978; x=1753886778;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CQGgiEKZ9BLW6U6k5xk1iAQnETQ+XftQ9J9xgQIohlk=;
        b=jIDzhKq4q9YW/aWlqvEU3LWMkEaRh648biaWVycMwQNzhZ6ynDO0/eih6Tzfb25e3J
         r0Pa2Z1R7vGa2g2UDmPYR8Pztk2aPlLAF/4osY7MGYIyx8UlQFNbWO5FHqOr4D5FXKS/
         d/7jZ252XjrRotjwulPhsJJQH8keOr2jOzXkNcm18RCpSyk/1+5qvZdPFhT+yq/ZLYQ0
         8d4pEq8hJSA+RWdtPFLsgDgqEeIQ/P/214g6WUHRfbM21bROHOhHN74WX41rgeKqwnlb
         Q3R2sPjrTqy2g1a4PqyD7Cc3+htooe85BbuASNnK/QmxGe7QiLkwkoLWfxFH8cjIURc9
         +IgA==
X-Forwarded-Encrypted: i=1; AJvYcCV06DNPnv5U1XUYCxai6bPRsqaN3Vn9n2RRe+4PsFIxtVqC1yTidlx0OQ1V7khP6HEMYu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YycxUdUJ583yvlYCP2Thv7P0MxD6i7qbNjcTiMrYTM6aqWUQq0m
	Q0/ex4oN2GJJhAI8y/xTQyS3oAMGrvWET7rAm3vMQGYbWEApKoCmYJRQLyRXHxNmq/Ainz4yeVa
	W40BI//L1r943EWXxzO+6KThp+chkLgfPclm18kLbU+OMLkulrG2W+rfISdXN66U7
X-Gm-Gg: ASbGncvJxRrLN+iTwooVqVGd/8W+pOZuNQJIIt5DNwKdg8xE9EbiPykcF3HdxMvQCeR
	iH9F5giRRyWzHJFxkf/NjmgnU+Y9sONTXFwtJyid6LSNF8EsEk3tjxC5pwc0CBc74fj1/FsTSzB
	bOtL/fZPcat0ssjRcr2/06+W4kMvhRJro5G4DToVkiXLOIcfM+3UJq3x3zijPmFDfaLzCgxUe11
	s8tF2wPMm5AVEyAoxXiyaqHv3nHvY6MUTfrHbY3C5b545zKE+6YLaTrjRqvjx572DlYBsbrJpVJ
	QxYCJT27WcFKC7cYU2VFkojQr7OWi3Hll8NTR7sYajyizHaX2QyBQaVyGwBnMrF/ItvIrQdfNmb
	7Eq91YUTZlnywJJH9W0rojByJuqtbXEZ8IxX1TXA0KCAEnHzyCvoJP5JI4SVCudGP99o=
X-Received: by 2002:a05:600c:8b71:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-45868b44016mr26972655e9.12.1753281977784;
        Wed, 23 Jul 2025 07:46:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1KNSe2SVxUroDZ225ZV5Nc1b5biPHfGPJZG9qryQi+RFiYP2ispLZdQ4B+jpEa22Ey3+fGQ==
X-Received: by 2002:a05:600c:8b71:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-45868b44016mr26972145e9.12.1753281977097;
        Wed, 23 Jul 2025 07:46:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458691b0f59sm25842795e9.29.2025.07.23.07.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 07:46:16 -0700 (PDT)
Message-ID: <3d310152-34dd-4e44-92e8-a4e94c6480ad@redhat.com>
Date: Wed, 23 Jul 2025 16:46:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, ackerleytng@google.com,
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
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com>
 <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com>
 <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com>
 <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
 <aH-hxiD2DwovFpqg@google.com>
 <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
 <aID1JoOGRZ8HIkc9@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aID1JoOGRZ8HIkc9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.07.25 16:43, Sean Christopherson wrote:
> On Wed, Jul 23, 2025, Vishal Annapurve wrote:
>> 2) Userspace brings a mappable guest_memfd to back guest private
>> memory (passed as guest_memfd field in the
>> KVM_USERSPACE_MEMORY_REGION2): KVM will always fault in all guest
>> faults via guest_memfd so if userspace brings in VMAs that point to
>> different physical memory then there would be a discrepancy between
>> what guest and userspace/KVM (going through HVAs) sees for shared
>> memory ranges. I am not sure if KVM needs to enforce anything here,
> 
> We agreed (I think in a guest_memfd call?) that KVM won't enforce anything,
Right. We'll document it but not sanity check it at KVM slot creation 
time. If the VMM does something stupid, not our problem.

-- 
Cheers,

David / dhildenb


