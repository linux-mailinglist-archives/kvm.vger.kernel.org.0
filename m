Return-Path: <kvm+bounces-52623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C687B07472
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3E533AA835
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4DDC2F2C6B;
	Wed, 16 Jul 2025 11:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MiRepuCC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8103F20110B
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664558; cv=none; b=JFaf7fZhNGyMHR52xM2s0Vwi/H+3END8jPLAt1pKy17NbWbXxgo++r3LSbhMcxTGR6Cif0s8Fv0mSY/DkqWebmyUOfHmSVKF3mJWYlRZvBDBQ7kRqx4tZt+s7tW/zQwbWWhKYatviymj89KalAomYDG/FUQTqHFCYnIcx2zruVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664558; c=relaxed/simple;
	bh=6d/nrR3DNEheg3fvSEnpWEnZ8JJRf+rmNS8evAbycYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FSQ+Gbe6caJOJYAmwn5xinZpLZ/EP7+1N/H6RjAvh/luA33kmzjcPSbT/b94eFLl/u4+eV6t6JxF1bXoWv0q/nwgrVU0Ow5PMTCJwzx/8ur2fnvomWBpu/qVopqhwxEWVIKeR504X1fysGXKA6tfNRZtkUb995fjn2IyjiWz0MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MiRepuCC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752664555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QnnkqItLsI0ARk49iyBDkOyecK6Jk4xqS5efHEoSN08=;
	b=MiRepuCCzopGvIp+54KQ+UrFyChbqr6IsVcdgWB02f/5V6zhBCfr4/ZPnGUe/IX2JjXbB0
	0dBkR9+Zz8AnRvzsT1S9nm9TSiaUvh0dB7wee6sMEsLeQ0i9RzDdBtEvb15bj82OwAT3zY
	sv5rY/AdMNQg8dVxiCEP0NeLQqFxBpw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-On5S8EpRPHaYOcvN9ECWmg-1; Wed, 16 Jul 2025 07:15:53 -0400
X-MC-Unique: On5S8EpRPHaYOcvN9ECWmg-1
X-Mimecast-MFC-AGG-ID: On5S8EpRPHaYOcvN9ECWmg_1752664552
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f65a705dso4222231f8f.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 04:15:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752664552; x=1753269352;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QnnkqItLsI0ARk49iyBDkOyecK6Jk4xqS5efHEoSN08=;
        b=Q2Id5zXMO46AIGafo5++z79S5kaWfK08QgG4Yq4e8MIcuRdUwDzUxwdv2h7ALzvimw
         2KIA5cqT1+oni33MpPQM6R85Be9NGJY1b/xXTp14J5dkHAXm5fcUIUzazImAwiwab1/D
         dyGjelvevp8/zrw1kpMKd9sNxhcH1vj5xHMyR+FLGVb4Q0NzCBAnVPEtDAMjD2krw8kz
         gV/YnRfUGbivRcu+oVfw0Rig+ZqHbI49lS1LomM3XUyCnHx02m3D1wEBU7O+KY+I+L27
         JsLx0TeQWX22Dkdj3OtHAR6MG04MbkzwEp/tzr+sFr8hbqe4MD9WmUIedn61KT3TU9a0
         y9lA==
X-Gm-Message-State: AOJu0Ywh1H1HsqnAOk4wmGPihh+NDH9dPcGQNUhZ5vGM3Tgwsj//ib7B
	f+q1WvwApImkxHyR3lyZP1U9jydH/6WN8JLyV2VOyNqQ7UtKZj/WS5nAoGCmlPRR/68qFqyfklO
	g0mpsh2MxJZ3Q6QpT23h47PiBtdKgkX06SyiaTVAaXh3GNZkmDqi1pA==
X-Gm-Gg: ASbGncu3Cgz3+1+zI9KKswipmVlw1BbZHJlLESgyvelM5MeCluVWqkBZ0LVIKhs6YeN
	sNYpkDWDr3OwJMNO9HA0CjhWfjQ7Hs+Aw6gEQyhtOfQCtEu7HYdiuwWo9iuwZLPM8L61wSAASXL
	iI93hQ9O2CH4x5lwb0EyT51GF3OLbt7W9LtJYHxuVicM1V0JN+UOpfH9ZDsDeHUVHY1COhO3CRG
	N/8FkegAWW4lMmY24mE9DKIXrjIgrLsBsoeGZqLx0Jf5jMNztmFlIHP+C1fBmDDw/Bh6xAsUOhy
	YdoKi53RzVAmc8rOVmAzGwa0O2+GV0YDDHxBvIWtU2nhoFT7VMdwqhauBtGJ+of0hNUPpPQ=
X-Received: by 2002:a05:6000:200e:b0:3a1:fcd6:1e6b with SMTP id ffacd0b85a97d-3b60e541208mr1948930f8f.57.1752664551997;
        Wed, 16 Jul 2025 04:15:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfBjAbx9P8Bar8PsKPqzUpQU/lrsluFZuBY7lqugO5P66Q0CRJf1PBvMJnWIt0zO2geFf+dA==
X-Received: by 2002:a05:6000:200e:b0:3a1:fcd6:1e6b with SMTP id ffacd0b85a97d-3b60e541208mr1948841f8f.57.1752664551376;
        Wed, 16 Jul 2025 04:15:51 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0f26d.dip0.t-ipconnect.de. [79.224.242.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e0dc3esm17428114f8f.47.2025.07.16.04.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 04:15:50 -0700 (PDT)
Message-ID: <47395660-79ad-4d22-87b0-c5bf891f708c@redhat.com>
Date: Wed, 16 Jul 2025 13:15:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Fuad Tabba <tabba@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
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
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com>
 <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
 <418ddbbd-c25e-4047-9317-c05735e02807@intel.com>
 <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
 <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com>
 <CA+EHjTz7C4WgS2-Dw0gywHy+zguSNXKToukPiRfsdiY8+Eq6KA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CA+EHjTz7C4WgS2-Dw0gywHy+zguSNXKToukPiRfsdiY8+Eq6KA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.07.25 13:05, Fuad Tabba wrote:
> On Wed, 16 Jul 2025 at 12:02, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> On 7/16/2025 6:25 PM, David Hildenbrand wrote:
>>> On 16.07.25 10:31, Xiaoyao Li wrote:
>>>> On 7/16/2025 4:11 PM, Fuad Tabba wrote:
>>>>> On Wed, 16 Jul 2025 at 05:09, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
>>>>>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>>>>>>> The original name was vague regarding its functionality. This Kconfig
>>>>>>> option specifically enables and gates the kvm_gmem_populate()
>>>>>>> function,
>>>>>>> which is responsible for populating a GPA range with guest data.
>>>>>> Well, I disagree.
>>>>>>
>>>>>> The config KVM_GENERIC_PRIVATE_MEM was introduced by commit
>>>>>> 89ea60c2c7b5
>>>>>> ("KVM: x86: Add support for "protected VMs" that can utilize private
>>>>>> memory"), which is a convenient config for vm types that requires
>>>>>> private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.
>>>>>>
>>>>>> It was commit e4ee54479273 ("KVM: guest_memfd: let kvm_gmem_populate()
>>>>>> operate only on private gfns") that started to use
>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate() function. But
>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.
>>>>>>
>>>>>> If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate kvm_gmem_populate() is
>>>>>> vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE to gate
>>>>>> kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under
>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM.
>>>>>>
>>>>>> Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with
>>>>>> KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.
>>>>> I'll quote David's reply to an earlier version of this patch [*]:
>>>>
>>>> It's not related to my concern.
>>>>
>>>> My point is that CONFIG_KVM_GENERIC_PRIVATE_MEM is used for selecting
>>>> the private memory support. Rename it to KVM_GENERIC_GMEM_POPULATE is
>>>> not correct.
>>>
>>> It protects a function that is called kvm_gmem_populate().
>>>
>>> Can we stop the nitpicking?
>>
>> I don't think it's nitpicking.
>>
>> Could you loot into why it was named as KVM_GENERIC_PRIVATE_MEM in the
>> first place, and why it was picked to protect kvm_gmem_populate()?
> 
> That is, in part, the point of this patch. This flag protects
> kvm_gmem_populate(), and the name didn't reflect that. Now it does. It
> is the only thing it protects.

I'll note that the kconfig makes it clear that it depends on 
KVM_GENERIC_MEMORY_ATTRIBUTES -- having support for private memory.

In any case, CONFIG_KVM_GENERIC_PRIVATE_MEM is a bad name: what on earth 
is generic private memory.

If CONFIG_KVM_GENERIC_GMEM_POPULATE is for some reason I don't 
understand yet not the right name, can we have something that better 
expresses that is is about KVM .. GMEM ... and POPULATE?

-- 
Cheers,

David / dhildenb


