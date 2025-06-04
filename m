Return-Path: <kvm+bounces-48397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C13ACDE72
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8144E1897F08
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E36628F935;
	Wed,  4 Jun 2025 13:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Clq/9lYl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CC028EA55
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749042210; cv=none; b=RSggM5owGXBLEll/gjWKAKZ4/fU6LbYe/sK5UMMnaaiJnxUPdWGu4Y7DRUrYR//2Rd+SCAdazuzg9Ep0e8xcHdWS7nAaynkyD9vVy6VWv/u3i1pxU98Y8Q4CvNiL5nZ2ClfTLN1QdRPO/wz3rH4qHOGuUKU52GujZuSY2DwtJNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749042210; c=relaxed/simple;
	bh=jyLvapr0hV2SctsERDcqY80zrR4IU3ObDKc5L5NSjYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rOc4W9wjKRgfMIptt1nGnuHY3dFYLcUInJ03rudGalEwGUk/WbIMYKxqHS758yPii3zTiWG4PHI/CwLFTPjGGIa1t+w0OC2CSGcKaTg9sF7cTnwEfZkp4eZc/4++ZtENB0lQL93MD1QmtIaz65cC6rivJe8/eNemPovQVQcwMnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Clq/9lYl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749042208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1W70xJxVbnQWAt2S0XsNaY8S+LMWijC2aByv8x2rpkw=;
	b=Clq/9lYl3nL1OynwH3XOISXA2nazhSjmv3FYzJxwfjA8Fd+KlCymdqh/ApazXgYPj3Dp8t
	YPEmmCFuZ/k9xK9Vbx9uEkis5qjzSvZcpFTgamrZMv+s5N21ltf1Xva8VB9X0GfAUlX2Lb
	33B7/iXbBBhk2K06w0rs564kjYTEM1w=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-9hC70I7fOGWEGLUprAsg8g-1; Wed, 04 Jun 2025 09:03:27 -0400
X-MC-Unique: 9hC70I7fOGWEGLUprAsg8g-1
X-Mimecast-MFC-AGG-ID: 9hC70I7fOGWEGLUprAsg8g_1749042205
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-326d691ae78so34223901fa.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 06:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749042205; x=1749647005;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1W70xJxVbnQWAt2S0XsNaY8S+LMWijC2aByv8x2rpkw=;
        b=TAs4BJ5l96mMtQUNjmkkDGqUNXGA3iLIlpIRZooi9fR+Mx/mA4dmetrkQoyF3bhYSH
         ol4UZl4MSLoSc0mVTTmiotELtkkEnmIASfkTGWNIvX7jU5KXcTnazHrLKR6muneBe4lY
         dJu+UVfzlIZLk1uwmZRV+LQxttWKjuM/yy9AZP9I5vWIEuGW9wdJEgVW649XgNRHDmba
         wtXwHojZ3azM0ddAwGdRycXqmwLdyZsEpb3IR2oJ+BuBq6JRjMrBTGcEZZ6uGAPwB5R/
         Bs56fIqq7peJBDdsGlr/Jw5Wxd482VAwzwSELXClvVCOpo+TMN2OIRk7OeWQrTPBgaWV
         +YEg==
X-Gm-Message-State: AOJu0Yz7mkwXXJ47+y9laL5wWXUjVBGDxHFJpKDakMcXRU7ilVSwDNPe
	ghCLq3nGBBUE5fnpuz1Lvkij1tJwqNjC/3aOMqLHQiZRRBh+Omq5Jha3rATaQEBbs+rHByrEwVd
	lYWEHIEbsRj0aVEi+k3EXyvI7gTUBXVS29nnHqnWjq4cqEFWEsL/6bJ1Js8TR3JuF
X-Gm-Gg: ASbGncu0UGly0XcasP5nC9wiJ/S/psHqHlXCeqUGaBKEouhyTJgrVAajNwPPiK+aIT/
	8Ry/Ht2IR+cxULbCRD4quYZ5hN/UR8jN6l1PkYzQvnYtb/vMp7DiPKEtd9yUonYUoZsNbsqQbsH
	Rf5E2yEIT0J2HbSOTCSYIfZFTHXHfIKL1ELcOkPzC14cbS40zjlkCsfG4BX9JLjM4Uy6fAcHlCd
	NdrG2zSxNJ+gD5Ikf2GSmMeh9Ze9Usbb40ZfiE47b0d8IJv9us81S3HbyaosxdeiOeLXNZzduSP
	Rr6qlXqpeYeXaywauUL4LGmTY1YizN2gSGRFbBzN2aKQ72q6HOdHJ0TCj6bucUwY08A8kYilxB9
	2SsaOsaz9R7pb2zomiv/M56d2C+be/hyEqP5DNfY=
X-Received: by 2002:a05:6512:3e06:b0:553:2cfe:9f1f with SMTP id 2adb3069b0e04-55356ae0f68mr773728e87.6.1749042203502;
        Wed, 04 Jun 2025 06:03:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzmsqBq7oHf/7NA5WXbYa0JLoQ/4AyvuDodtvFK/3Rr1JPiuMMFb2vKM8OCBKgoi64wfEu1Q==
X-Received: by 2002:a05:6000:430c:b0:3a4:e5ea:1ac0 with SMTP id ffacd0b85a97d-3a51d8f6ee1mr2387438f8f.5.1749042173270;
        Wed, 04 Jun 2025 06:02:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1b:b800:6fdb:1af2:4fbd:1fdf? (p200300d82f1bb8006fdb1af24fbd1fdf.dip0.t-ipconnect.de. [2003:d8:2f1b:b800:6fdb:1af2:4fbd:1fdf])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe73eebsm21436129f8f.44.2025.06.04.06.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 06:02:52 -0700 (PDT)
Message-ID: <0835025c-a799-4ffc-9dea-52b64ffcb96a@redhat.com>
Date: Wed, 4 Jun 2025 15:02:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
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
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-9-tabba@google.com>
 <b497b0aa-a8bc-45b9-9059-71dbbe551ebb@redhat.com>
 <CA+EHjTztT_MhXpAZvmv53vDOO89fW4fq86gZqgip97T05YTE3w@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTztT_MhXpAZvmv53vDOO89fW4fq86gZqgip97T05YTE3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.06.25 14:32, Fuad Tabba wrote:
> Hi David,
> 
> On Wed, 4 Jun 2025 at 13:26, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 27.05.25 20:02, Fuad Tabba wrote:
>>> This patch enables support for shared memory in guest_memfd, including
>>> mapping that memory at the host userspace. This support is gated by the
>>> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
>>> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
>>> guest_memfd instance.
>>>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/x86/include/asm/kvm_host.h | 10 ++++
>>>    arch/x86/kvm/x86.c              |  3 +-
>>
>> Nit: I would split off the x86 bits. Meaning, this patch would only
>> introduce the infrastructure and a x86 KVM patch would enable it for
>> selected x86 VMs.
> 
> Will do.

And probably that patch should come after/with the x86 mmu bits.

-- 
Cheers,

David / dhildenb


