Return-Path: <kvm+bounces-40251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E116A54FD3
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 526843AF33F
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 15:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79B2211479;
	Thu,  6 Mar 2025 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HML/HfIA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B39B158851
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741276660; cv=none; b=W4O8XYmDdN8eFmyn2M3dSBY2oDEgaUkQYssPMyUoYfcXjLsg70rR1jqIC7kGBGHh+MdVzTNU5AQKTEj8Kn0mnDRzoC8cnZjQ5LgxAgIkNbQD6DGPiEGcDFi9eQFOAQ27wlL8ySYzTCQPC9AMQ6AeT7D93nFhd/4FSdRHk5M27xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741276660; c=relaxed/simple;
	bh=wvOHETWMPdKEfoDOdXSPvHnlneS2UbU/D3vXOEYoqKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZI+qyBy7n1XQAVvEo3RgrZ2nWLTnAWMvIaqUHGx47+COYAKk1An4hh8tOmdicBz/0rs3mHmQD6xJYWt4SLJOnJs2Mx+QJmCrjVDHFCtGtJnBg/s6H+dzkvfB5yFvap0enHCUIrSSy/xPJ5Ia9PT2wDT3fvhJa+LcX1uzCnvi4oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HML/HfIA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741276657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pU4e6aGqfGk+oxCHFhv19BCq5QsWaXwATXP1v2rRkGM=;
	b=HML/HfIAqTTAfaaSpq5bs+Z2svMElEUKBvgUcNJEc0j2cXcNaA1PTBYDo5QHRjLPsZUMUx
	h5Xqi7WXWD/p0fBmoGRBSEKEDdovjB01aVsT/d77LJ/ipTIztD6lLEq47kh3SlUdvv0Cx8
	rFqxS4l6OL6X7paxSiOvp6sdDcjiAM0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-zCb6MjGOMZ6RP5RTt3zW7g-1; Thu, 06 Mar 2025 10:57:34 -0500
X-MC-Unique: zCb6MjGOMZ6RP5RTt3zW7g-1
X-Mimecast-MFC-AGG-ID: zCb6MjGOMZ6RP5RTt3zW7g_1741276653
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39131f2bbe5so9735f8f.3
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 07:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741276653; x=1741881453;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pU4e6aGqfGk+oxCHFhv19BCq5QsWaXwATXP1v2rRkGM=;
        b=fn2sXMcLpyWxZXb3KoJvC+fy21IfSamRKqDpSNZ6f1Ysq7bgC8zmVuZT0WQ2dv6KzX
         cEfkUadzoiU9XMGQVqfLyA4P9vO7p9btGIhZ/dz3ouQMD9qtXtyspYLBpwFBo9/DapE7
         89kAzR2ZGlsFc0DhkD618uUkmDOo5TwjC+Q5wrZrnddiYU/TApqqUTnWxnfng3NBXTrH
         G1xB3KH1MLiX3xM/6icSc7d6o4jIuIVA5H5q1oriU5HnxzdFx8C0+SKQSYlvAuZc/jq8
         /Zhwhrs+bxIvU0hR4uBQDRzFf4xaQy5rFD9eZJT2ijKUbAUe1zClD3K+mpxTfnbKXlbx
         EcKw==
X-Forwarded-Encrypted: i=1; AJvYcCWISa58FqZiYFTy3PYxC9s8YS5rlQeYmIcRXmEuXMFkycZwYeJv3DwkBCn1Qp2tTk2A6a0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqM2wy4rPmuZPimtUiAvHMdwNyIwn5v9eXLvoDT64Y9ge/m2Re
	RYC6CC4Mfb0vvRYdK+W1Wh819+SB86g3EQGh9sQFoqjeDbeh45R6/O8SB6CD/rEyN/bztoVh9hU
	b+IncLeIfit+T2TGnSqfe+LPEqGDbrWk2BrPcA4/H+E5rxJedAQ==
X-Gm-Gg: ASbGnctqt7N0TuyYIiIqMs6S8WKJ+Ww4dSFqaMV+gIl21rHV0p+0Zul6Hu6ocMhMReG
	K1HmOzetsw0S3MsN37w0TKvU0VhX7JlNdigkc6erDm3/2t638wFMiNpcCu/XCfarDZoliu5fEUQ
	7qO4orzkQYEImTFBH60fcrAHI+iLWC83Ln/S6TXlCPoCMkm9RmJM219yeGFwwNvTpyCQAF7OCcF
	9qIXJSLNKRWV/f7sbVqM8uStJ1lUnUSEa0N3Bg/fNwgr3aHcEf36CD28QKPMQbr7h5ozw47fdUG
	fViJj9l+Ygzr3fCIIIr/E3Ho030wEj5UwfICr/3Bv1pu99/fHSmJ716Qh+Ws7kKvCgKaC+XQtbC
	pbPi3g0VEhwBtarE9e/nVn5hjCKhkFV3KbpXaJSjgqIs=
X-Received: by 2002:a5d:6d82:0:b0:391:78a:33de with SMTP id ffacd0b85a97d-3911f73f4f3mr5480668f8f.12.1741276653425;
        Thu, 06 Mar 2025 07:57:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGe1dDhk85Ui6W9jfnqHxuqheaAG61TVd4v1P3dxoV6zNMEnX1cNioZuF1QGH5jaoQUJHjddA==
X-Received: by 2002:a5d:6d82:0:b0:391:78a:33de with SMTP id ffacd0b85a97d-3911f73f4f3mr5480648f8f.12.1741276653002;
        Thu, 06 Mar 2025 07:57:33 -0800 (PST)
Received: from ?IPV6:2003:cb:c74d:4400:2f98:9b35:6822:ce54? (p200300cbc74d44002f989b356822ce54.dip0.t-ipconnect.de. [2003:cb:c74d:4400:2f98:9b35:6822:ce54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c019557sm2525150f8f.50.2025.03.06.07.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 07:57:32 -0800 (PST)
Message-ID: <0165c960-e272-4a52-880f-25094c13d129@redhat.com>
Date: Thu, 6 Mar 2025 16:57:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/10] KVM: guest_memfd: Add KVM capability to check if
 guest_memfd is shared
To: Ackerley Tng <ackerleytng@google.com>
Cc: tabba@google.com, peterx@redhat.com, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
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
References: <diqzo6yetb28.fsf@ackerleytng-ctop.c.googlers.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqzo6yetb28.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06.03.25 16:48, Ackerley Tng wrote:
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 28.02.25 18:22, Fuad Tabba wrote:
>>> Hi Peter,
>>>
>>> On Fri, 28 Feb 2025 at 08:24, Peter Xu <peterx@redhat.com> wrote:
>>>>
>>>> On Tue, Feb 18, 2025 at 05:24:54PM +0000, Fuad Tabba wrote:
>>>>> Add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which indicates
>>>>> that the VM supports shared memory in guest_memfd, or that the
>>>>> host can create VMs that support shared memory. Supporting shared
>>>>> memory implies that memory can be mapped when shared with the
>>>>> host.
>>>>>
>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>>> ---
>>>>>    include/uapi/linux/kvm.h | 1 +
>>>>>    virt/kvm/kvm_main.c      | 4 ++++
>>>>>    2 files changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>>> index 45e6d8fca9b9..117937a895da 100644
>>>>> --- a/include/uapi/linux/kvm.h
>>>>> +++ b/include/uapi/linux/kvm.h
>>>>> @@ -929,6 +929,7 @@ struct kvm_enable_cap {
>>>>>    #define KVM_CAP_PRE_FAULT_MEMORY 236
>>>>>    #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>>>>>    #define KVM_CAP_X86_GUEST_MODE 238
>>>>> +#define KVM_CAP_GMEM_SHARED_MEM 239
>>>>
>>>> I think SHARED_MEM is ok.  Said that, to me the use case in this series is
>>>> more about "in-place" rather than "shared".
>>>>
>>>> In comparison, what I'm recently looking at is a "more" shared mode of
>>>> guest-memfd where it works almost like memfd.  So all pages will be shared
>>>> there.
>>>>
>>>> That helps me e.g. for the N:1 kvm binding issue I mentioned in another
>>>> email (in one of my relies in previous version), in which case I want to
>>>> enable gmemfd folios to be mapped more than once in a process.
>>>>
>>>> That'll work there as long as it's fully shared, because all things can be
>>>> registered in the old VA way, then there's no need to have N:1 restriction.
>>>> IOW, gmemfd will still rely on mmu notifier for tearing downs, and the
>>>> gmem->bindings will always be empty.
>>>>
>>>> So if this one would be called "in-place", then I'll have my use case as
>>>> "shared".
>>>
>>> I understand what you mean. The naming here is to be consistent with
>>> the rest of the series. I don't really have a strong opinion. It means
>>> SHARED_IN_PLACE, but then that would be a mouthful. :)
>>
>> I'll note that Patrick is also driving it in "all shared" mode for his
>> direct-map removal series IIRC.
>>
>> So we would have
>>
>> a) All private
>> b) Mixing of private and shared (incl conversion)
>> c) All shared
>>
>> "IN_PLACE" might be the wrong angle to look at it.
> 
> How about something like "supports_mmap" or "mmap_capable"?
> 
> So like
> 
> + KVM_CAP_GMEM_MMAP
> + CONFIG_KVM_GMEM_MMAP_CAPABLE
> + kvm_arch_gmem_mmap_capable()
> 
> I'm just trying to avoid the use of shared, which could already mean
> 
> + shared between processes
> + shared between guest and host

The reason I tried to avoid "MMAP" is that once we support read/write of 
non-private memory, the "mmap" is a bit too specific. Similarly 
"faultable". Hmmm

-- 
Cheers,

David / dhildenb


