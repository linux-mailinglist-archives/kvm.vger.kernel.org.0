Return-Path: <kvm+bounces-47234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35790ABED32
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A8207A5FC2
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 07:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C856E235362;
	Wed, 21 May 2025 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="McBVlrBW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48945235052
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747813018; cv=none; b=XOGli8tACXU5q2YMwqggGBf+urZza2sOtiTx6Zfddl5rpJJoAauQ5hIU+f3nCrTy1TGs+muCUB3TvPZ0vrjqIzn3dbWufkxVF/6Gdqp1eV+Civ8+eYhh7/VrTwolDNBUNiyHQcLI04Psph2d2RWGEcVKGFiSr6BgFcBIW1bdKWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747813018; c=relaxed/simple;
	bh=RaVXbM8NbWfKXl5vs3Umim5AOyZ7sf4lnMQuYtG1rJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ml1+L3q+eEZI1UgzAKFA1VIzBcytXAszuk1p0ysv/+XkW3FTbaKY6HuG/5RAte0FxZAQ09L5R+IYFRoa0kE8w29G6yQjImlkUZif1fpdH0r7/U7rLPPs8rmi+GYyZssP2QPudc0aLe+sJjSQ7+bsu13cRsjo421kbPDEdFWb1LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=McBVlrBW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747813015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NTCPx01WLo/l17Mv9QVXXkZ0t4tJkI9Qr3I/ZeEvz0A=;
	b=McBVlrBW6rJ8givF0DT3+V2GYYfoXU/36B2K7Gc/CJuZUB4pgKfycHSrqEzefpExXguSnR
	7HHKSPoErXKJyHlztIn6L9hlArANk6Aq/3/FgvzkzFFP7ZUkM9JaepQegiRKO2LE0qUZ3q
	+AL1kBjiWJCDK2MBDXJ9HhT4IoB+8wg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-lE-KRZaMOLCL6xxcx3gSgg-1; Wed, 21 May 2025 03:36:52 -0400
X-MC-Unique: lE-KRZaMOLCL6xxcx3gSgg-1
X-Mimecast-MFC-AGG-ID: lE-KRZaMOLCL6xxcx3gSgg_1747813011
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43efa869b19so51632615e9.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 00:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747813011; x=1748417811;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NTCPx01WLo/l17Mv9QVXXkZ0t4tJkI9Qr3I/ZeEvz0A=;
        b=RS9TCCbEt5OwL90yk3ilQT/jf6+DPOrg6Y5Cl/oIGRFYNoEMRsXRSzVyNKJ50wqnjs
         ng6s04x3vp1dZMPOdJt06+nDemLyAGgkEHtwZQxhMCamgzZlA0SW5hr2ZAv0dm6veJ7Z
         jPhpnUBneB7DA+3+WyoJLJqnVTYnVNtuhTH/Xp6ewmNfykD0xIa/PhOUaMww0pIFV2LH
         X+D6X9mLjFpy8a+Jkz+JWlXl/S0uFThdJNPSHCugiZEjD7aeiheGJB1Pp6O/ad7gUCJG
         XeUEVR3BvSBbQ6bTGF7WJyXjk2IzlQLBzb3GBcjkDrKzJOO5B9awXf8pEWFtXRj6MATr
         Wp5A==
X-Forwarded-Encrypted: i=1; AJvYcCVljY1q4djHzIi+Fasm1APjHt8hgs1pcImc6UgguAjSo3xqGtMVg6LQH342OvHHbVTO4dM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCtKO23QbNkK64I/I5PxlDVnmQkdcWI0otlXwAo8kS77MDiwAI
	foJAxH0/wrPwR4OuI3BVC9F7rFSD2IG+QZWAUqzWYGDHZch5KnS369bmSLfZ3aA7Qtmz2yxGxtG
	82Ppyxs/yV9XUSflNU1nvrHOQ8j6l/LY/vqf/o/nPBFOQDmfqPn4tQA==
X-Gm-Gg: ASbGncvof9HhnDgt/2BRGLv0x5vdNGIqJsgwDeW5nBAcn2K6GLVAiP8w5jDPQtt5J4e
	y+MT+3w092PucX7G2WktAroswOLzQrrACDwTEXczI5Ky/Y0xYX/EHXtp3MRHRhp/Kitva2TW50/
	dZwpqKRr+Los2uwpsSiJL9BnvCE0Oid/EHxU44z6EFre3TkEPpSCpU6S6NA9wE87jG7e0g2uGJC
	k8UM586XXJzFObNrnVZWYwlKqBkBL/MrwZNPJXq1IoJff0YT5NhcJo6inySAaZGUuA5mRo6qHBg
	CaUwmGl7b2Eu4LWfu9PgsCd67reL1YjtzK/4d5PGUcgiMNy9eSvh7RE5wPMPjRxvGyNUNJHxgqF
	84TaHtllj8DKzGrGtI6AF27B0DaO0wH8zLBGIzHY=
X-Received: by 2002:a05:600c:1f87:b0:43c:ea36:9840 with SMTP id 5b1f17b1804b1-442ff031805mr118790105e9.22.1747813011365;
        Wed, 21 May 2025 00:36:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjVSBzQbNDu0NELwCsu411OIs7trlkkbUtDTGwSOcqlG49hV5j0AUHykrVcDpciZJSEB6S1A==
X-Received: by 2002:a05:600c:1f87:b0:43c:ea36:9840 with SMTP id 5b1f17b1804b1-442ff031805mr118789565e9.22.1747813010941;
        Wed, 21 May 2025 00:36:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1ef035csm58086085e9.11.2025.05.21.00.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 00:36:50 -0700 (PDT)
Message-ID: <3f5574d5-a011-4a14-825f-74b3ddd04573@redhat.com>
Date: Wed, 21 May 2025 09:36:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>, James Houghton <jthoughton@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
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
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, peterx@redhat.com,
 pankaj.gupta@amd.com, ira.weiny@intel.com
References: <20250513163438.3942405-8-tabba@google.com>
 <diqzsel8pdab.fsf@ackerleytng-ctop.c.googlers.com>
 <CADrL8HX4WfmHk8cLKxL2xrA9a_mLpOmwiojxeFRMdYfvMH0vOQ@mail.gmail.com>
 <CA+EHjTz7JzgceGF4ZBTEuj_CidKe=pVcanuFfPMrXhubV7c2ug@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTz7JzgceGF4ZBTEuj_CidKe=pVcanuFfPMrXhubV7c2ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.05.25 17:17, Fuad Tabba wrote:
> Hi James,
> 
> On Fri, 16 May 2025 at 21:22, James Houghton <jthoughton@google.com> wrote:
>>
>> On Tue, May 13, 2025 at 11:37 AM Ackerley Tng <ackerleytng@google.com> wrote:
>>>
>>> Fuad Tabba <tabba@google.com> writes:
>>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>>> index 6db515833f61..8e6d1866b55e 100644
>>>> --- a/virt/kvm/guest_memfd.c
>>>> +++ b/virt/kvm/guest_memfd.c
>>>> @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>>>>        return gfn - slot->base_gfn + slot->gmem.pgoff;
>>>>   }
>>>>
>>>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>>> +
>>>> +static bool kvm_gmem_supports_shared(struct inode *inode)
>>>> +{
>>>> +     uint64_t flags = (uint64_t)inode->i_private;
>>>> +
>>>> +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>>>> +}
>>>> +
>>>> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>>>> +{
>>>> +     struct inode *inode = file_inode(vmf->vma->vm_file);
>>>> +     struct folio *folio;
>>>> +     vm_fault_t ret = VM_FAULT_LOCKED;
>>>> +
>>>> +     filemap_invalidate_lock_shared(inode->i_mapping);
>>>> +
>>>> +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>>>> +     if (IS_ERR(folio)) {
>>>> +             int err = PTR_ERR(folio);
>>>> +
>>>> +             if (err == -EAGAIN)
>>>> +                     ret = VM_FAULT_RETRY;
>>>> +             else
>>>> +                     ret = vmf_error(err);
>>>> +
>>>> +             goto out_filemap;
>>>> +     }
>>>> +
>>>> +     if (folio_test_hwpoison(folio)) {
>>>> +             ret = VM_FAULT_HWPOISON;
>>>> +             goto out_folio;
>>>> +     }
>>
>> nit: shmem_fault() does not include an equivalent of the above
>> HWPOISON check, and __do_fault() already handles HWPOISON.
>>
>> It's very unlikely for `folio` to be hwpoison and not up-to-date, and
>> even then, writing over poison (to zero the folio) is not usually
>> fatal.
> 
> No strong preference, but the fact the it's still possible (even if
> unlikely) makes me lean towards keeping it.

__do_fault() indeed seems to handle it, so probably best to drop that 
for now.

>>>> +
>>>> +     if (WARN_ON_ONCE(folio_test_large(folio))) {
>>>> +             ret = VM_FAULT_SIGBUS;
>>>> +             goto out_folio;
>>>> +     }
>>
>> nit: I would prefer we remove this SIGBUS bit and change the below
>> clearing logic to handle large folios. Up to you I suppose.
> 
> No strong preference here either. This is meant as a way to point out
> the lack of hugepage support, based on suggestions from a previous
> spin of this series.

Yeah. With in-place conversion, we should never see large folios on this 
path. With shared-only VMs it will be different.

So for now, we can just leave it in and whoever stumbles over it can 
properly reason why it is OK for their use case to remove it.

-- 
Cheers,

David / dhildenb


