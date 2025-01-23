Return-Path: <kvm+bounces-36335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DFC3A1A1D2
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 11:28:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4111916AFEB
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 10:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAA920DD6E;
	Thu, 23 Jan 2025 10:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ERoCf2Fg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C720D4F4
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 10:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737628092; cv=none; b=t50pYuLNwnDqiar7j3vS9E6an5VWDbmKyx4rk7/GhSsgP/UdMRLq7MGqHskoeQpURg1Kmroux8VSG2unT4JxESNY0MVizRKWeNf6GlKbdRu6hZ5ZXPPp1x1IusRjG/1fhzHBu4NCdkV5xBoEATrnVb/aCW9GSAYtUMN886MwNJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737628092; c=relaxed/simple;
	bh=9GfxjQzIXg1IUZS2rC+QBsVk689B3+j+4LdRhu0wb3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tfIP4sjeolUo9Y1hHfCHgJOYLNG7SG2vkraK2eOpacjMJ1Leqye2As+sko9W5OTHREbVD3MJeweGrfkOOU5Ms80EFADJ3/Ny2PShGYfFGEoTaJGz0X2064dff3JvWI+eG9xiP4GZfliwvvY4/AJ68zgJwY5zC8t6Y/rjJUtLD/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ERoCf2Fg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737628088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FicqxSIae8HOyLpVsGZXZRg0Aah4bpzbFXJtjgPh3WI=;
	b=ERoCf2FgiSIln/WqhoDuF8D+U6hC2hrtzj4NU7s+WgLezOleEw8RKvxXrRu0bSt1TCszwz
	puRUM3l1tWfB7MgKMn389QI+BcMlnelZHb4DgTdzlGrXCNOaZ+qxe1yRoTurhMXiF35BZA
	znHNhogAObXwI5fh1rLXLqQ2C2jyGJk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-_1Dbp3v3Mja7VcLPboJU5A-1; Thu, 23 Jan 2025 05:28:05 -0500
X-MC-Unique: _1Dbp3v3Mja7VcLPboJU5A-1
X-Mimecast-MFC-AGG-ID: _1Dbp3v3Mja7VcLPboJU5A
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-436219070b4so3423855e9.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 02:28:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737628084; x=1738232884;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FicqxSIae8HOyLpVsGZXZRg0Aah4bpzbFXJtjgPh3WI=;
        b=SZNhFPDCBz8YmBKHLVi7WxT529EOfKQYqeBP6M9uaHt+xu3p7gSHQP+kVNhFgMaxkO
         TXqHX1xkTdmu2hVeP9eAb24cNOPAbHyiLKTM1fD6E+Zn9ycGrJ6HavhKr/pqwq4erFcl
         oIMdJmMjeTqMUBOfXyGPiLe65EhAcj0DucrZNc5r3L6WqU3H04TyPblOaq6aiWmpi5up
         QGXDXeRND7gv1yvMkt41sku7HV+q+rZ04/hL23ixuUEFW6XPiTrNBk+wwLw8wUORuTqK
         ykbAEiMVw/HxWARk5A+Nrfuh4fSRDjhA55tBWQzCF68xKeb3qnIFx0xKCPN/njbvaX++
         ml6Q==
X-Gm-Message-State: AOJu0YxK6u7Ad908RLw4ambft+IQ/W1XbGWbgeGesnYo+rEqd4qAobEZ
	3npr9S+9hwhA5dtt5wZkvbOgA0jwjeQX4Ks9sE/LMLW6CcXZ5gavJSjvNTHkHEVSdIP64vu4td1
	xp2ojUuhsw19ZG6Pz48CAIHHv7ovjRxE+g/x/uP1cOoieebHvfg==
X-Gm-Gg: ASbGncsUdhHH3oM6rG8xfnbNWjVuEgaDuL5RDk2heuy6UzMXkMaS2zVydWB5ySrpF4P
	nfwAM+EHrxbvW/qJeK1wBuAXscKhhL0Zr8JIpGoyZZXP671t2/0bUGotoaxQ/CCb0UZbRdveCXZ
	GKGkWTIt63sRpeCWGG1IKU9D6PLxPshndvBA1tnUnUfJ1oNjXXjgT4x102s16EczTawjt+/CfZm
	/Q3CXxqwxWJVHvSihgz0m9gefqYnpYPWN4m+AKkZJJ9Sgnb1KUrSSl/OCHAPUAaBYs585GXzbEa
	7s0xqKKhnt3CCIPUTr0WiwuG0Z4+fZlN95n6dwrjkTl4uDWR7Jsk4DZr6RMljo3jTHOUuFSVxKl
	xvwJFEPHvyDV7GVFOblA8pg==
X-Received: by 2002:a05:600c:4e89:b0:434:f739:7ce3 with SMTP id 5b1f17b1804b1-438913cb518mr229843205e9.8.1737628083932;
        Thu, 23 Jan 2025 02:28:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6vbH7yMy45to2djiY2Uojizp16OLhYfpBeVdmBjQkMYn6DUvSgIBC78DLFl1W/RdKbixRfw==
X-Received: by 2002:a05:600c:4e89:b0:434:f739:7ce3 with SMTP id 5b1f17b1804b1-438913cb518mr229842915e9.8.1737628083486;
        Thu, 23 Jan 2025 02:28:03 -0800 (PST)
Received: from ?IPV6:2003:cb:c70b:b400:e20a:6d03:7ac8:f97d? (p200300cbc70bb400e20a6d037ac8f97d.dip0.t-ipconnect.de. [2003:cb:c70b:b400:e20a:6d03:7ac8:f97d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b16ff48esm42826635e9.0.2025.01.23.02.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 02:28:01 -0800 (PST)
Message-ID: <dfb9d814-e728-441a-bd2f-172090db1e76@redhat.com>
Date: Thu, 23 Jan 2025 11:27:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/9] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
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
 <20250122152738.1173160-2-tabba@google.com>
 <647bbdac-df82-4cdb-a3e9-287d439b4ef7@redhat.com>
 <CA+EHjTyuVfveW7=seF0uvfpyQtLdZ1ywZ3Z1VmtGZ-z+kzhc7Q@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTyuVfveW7=seF0uvfpyQtLdZ1ywZ3Z1VmtGZ-z+kzhc7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>> +       bool
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index 47a9f68f7b24..9ee162bf6bde 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -307,7 +307,78 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>>>        return gfn - slot->base_gfn + slot->gmem.pgoff;
>>>    }
>>>
>>> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
>>> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
>>> +{
>>> +     struct inode *inode = file_inode(vmf->vma->vm_file);
>>> +     struct folio *folio;
>>> +     vm_fault_t ret = VM_FAULT_LOCKED;
>>> +
>>> +     filemap_invalidate_lock_shared(inode->i_mapping);
>>> +
>>> +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>>
>>
>> Would the idea be later that kvm_gmem_get_folio() would fail on private
>> memory, or do you envision other checks in this code here in the future?
> 
> There would be other checks in the future, the idea is that they would
> be the ones in:
> https://lore.kernel.org/all/20250117163001.2326672-8-tabba@google.com/
> 

Thanks, so I wonder if this patch should just add necessary callback(s) 
as well, to make this patch look like it adds most of the infrastructure 
on the mmap level.

kvm_gmem_is_shared() or sth like that, documenting that it must be 
called after kvm_gmem_get_folio() -- with a raised folio reference / 
folio lock.

Alternatively, provide a

	kvm_gmem_get_shared_folio()

that abstracts that operation.

We could also for now ensure that we really only get small folios back, 
and even get rid of the clearing loop.


The "WARN_ON_ONCE(folio_test_guestmem(folio)" would be added separately.

In the context of this series, the callback would be a nop and always 
say "yes".

-- 
Cheers,

David / dhildenb


