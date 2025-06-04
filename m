Return-Path: <kvm+bounces-48371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE62ACD7BC
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 08:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F335D170241
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 06:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E42262FF8;
	Wed,  4 Jun 2025 06:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWlEeDv7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D37023817A
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 06:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749017154; cv=none; b=WhJ81j6zcgwt5Yv6Gm80VI2f20iSDyYJmmSqszHw6t9SJnkm8qQqFdcZEiSwSo54vCuMcqaTS1jT3W7+qr88UgHjeqyVVv1m4pfmRhcbnn1sH0tLM3+Dr0HhFkOzzcUZ6fnQMuWhdXjjI6fks1RMkCzNUjq2Gbx7faBA+LO8N9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749017154; c=relaxed/simple;
	bh=+DmDA8gTVDEKW+xZT5XGMWbGqnwbVuk5pqFDvuYEQ68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K3SHfxHmxj7CnME/0uPCeJ7Ttfx9RLxLWxPzxkZdPRYN7IAN5nOnXGxPMNiDp/r7HRcHDKbQRE7npAGGEKQdliJt40eC8Y/saREv7+CBkKnEtDQ8btTl9IDn/Iawsl2dMpJVGmv7CJitM9pm7QUTRyUsHCyOOWTn23ptqt098Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWlEeDv7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749017151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ltLi5ra24Jsb0STBHkenR2Lb1EgkF/r4FbLJPR1eTI=;
	b=eWlEeDv76/X/+FjRwZdVg1vLj+o9J7Tkaf1bZVjy1XBVzCYCTwhVkvmrb3ecUXYTgTnCIX
	wUTOI82AxM/4yDH9HxoM/aYgvOYn4KN/TdHR+Yb20et9fpIEAnaBnSMg9o4ZPaJAgVslri
	MMks1mh4AILJMPOBk3vvbQUv+DNVPTM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-h5g9L8HKO_qa87fE3cteWQ-1; Wed, 04 Jun 2025 02:05:49 -0400
X-MC-Unique: h5g9L8HKO_qa87fE3cteWQ-1
X-Mimecast-MFC-AGG-ID: h5g9L8HKO_qa87fE3cteWQ_1749017149
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7480c9bcfdbso419883b3a.0
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 23:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749017148; x=1749621948;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ltLi5ra24Jsb0STBHkenR2Lb1EgkF/r4FbLJPR1eTI=;
        b=Rudl8+feKLANu9gAYL318Uh41eKt1d9QuJqp8ia/+3Vw2wWcftGmdeEw2v/t8crm0j
         OBUoVl7bHRovVq/SeiuNB28N9QsrxJhknIrZjt0/Kdgx1sYhS/Tz7EFtlIDKCPnIkpor
         vPYjTHC3mhYAEXQLf5bfD9YzNOp2SVl7YK0GKV3U6hxDIfEJA/4uCEyHbZQSW2HphWUc
         YvvT/hwAFYe4zJeIOcGJa52PkRTdlfBMD43WMOy0ciKYa9d+c6riPBwWHs54jh4D4a07
         Gy+MbnbWqH5418beySm9+p+VCWA5/tNRdguV2P72RsdS8MpUOFZtFA37HrWfcgVQUhea
         LUkg==
X-Forwarded-Encrypted: i=1; AJvYcCX5CtJG9m7mRF9kx3m7W90+qqbc8/1FwBdkRJyvytt6N8t9mmzDX/BUSMHWr3OFLVomy4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGPA/M2JY49iQ5/iWj4ZpTqTfefNliKV9KefFeUd/CFzYOMaL2
	9jEMMcj4i8vwzw9VJr1YAVDR/cA3IHSj73/QS0+pUZiWAqIcsEqaccKkTZe3DZ9tYrQt8SWpRWO
	A7N5jtq1j8K5xONL2Qlmqyc9d6c3FKq1Vsy7cT7G4Mqe5RKGhAezs0A==
X-Gm-Gg: ASbGnctvXA1CSUomdR7+uOEpsB0ip12TnYzmvKiye/g/tP4/4ZaktpP3T9dNAv4lH/Q
	p8uIhDIuYnxpaQ1+PO654snLNu+KPUjE0VKiNvSof+Rg5iGtme5DzOYAJvnxDjm0B5OOQ86m0Wz
	YP0/P26DG4iDrMnSTzuTwJKpEVOKEaHcwA5Rgm/ZSgValhGC/djW9QS/nYh4wGuaJDfhuOJYe8H
	NETxcPJy8ZvwdOm0Wxmx+e/f+QnRMMA1uKM/DTTL6qy5xejDQ04bHNFssW3OeljjJ1EUNW0lBJs
	Vx2kRQL6tPpwYjd6eKe0JCpDBNQv1Y/zPkF0FOUnw7aEZdQiWNB6NxWAt7o/Kw==
X-Received: by 2002:a05:6a00:1488:b0:742:a91d:b2f6 with SMTP id d2e1a72fcca58-7480b41ed78mr2603727b3a.13.1749017148471;
        Tue, 03 Jun 2025 23:05:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBsfgsaAmGId0zrYF9y6DFo02h+riK2t8uOhUFLQymVW6YzwyhCaemYYcLF8v0T3nQ6io34Q==
X-Received: by 2002:a05:6a00:1488:b0:742:a91d:b2f6 with SMTP id d2e1a72fcca58-7480b41ed78mr2603694b3a.13.1749017148117;
        Tue, 03 Jun 2025 23:05:48 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2eceb0a005sm6938285a12.7.2025.06.03.23.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 23:05:47 -0700 (PDT)
Message-ID: <19aa8bb5-7133-4005-a808-8cdc8a7acfc7@redhat.com>
Date: Wed, 4 Jun 2025 16:05:27 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 12/16] KVM: arm64: Refactor user_mem_abort()
 calculation of force_pte
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
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-13-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250527180245.1413463-13-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/25 4:02 AM, Fuad Tabba wrote:
> To simplify the code and to make the assumptions clearer,
> refactor user_mem_abort() by immediately setting force_pte to
> true if the conditions are met. Also, remove the comment about
> logging_active being guaranteed to never be true for VM_PFNMAP
> memslots, since it's not actually correct.
> 
> No functional change intended.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


