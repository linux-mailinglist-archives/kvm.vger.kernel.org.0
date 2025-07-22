Return-Path: <kvm+bounces-53155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D45AB0E0E4
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54A6F1C25034
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97F8279DC3;
	Tue, 22 Jul 2025 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MK3x2N9z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BAB156228
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 15:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753199451; cv=none; b=mSiRzCtlzbA1tiZ36K1nNif93o+UT9X68ojCmIKegpsJbkbkJbWKH4BvXGnpJejG6Y19beCEZd7PklNgohVIpbOiQnP9ywrDh28zLRIPyinzcCUUAZLVlwzZsW4jwrrx4q3236tQ1jwQw5GtbDLmVe3PqUV5wABdlk9rPqUhrD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753199451; c=relaxed/simple;
	bh=nCWGwF+dZTYHZWsZ5yUGhCF6+4z1EWHqmqJTiWnr9D0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ShcqzVHPEZ1dl2UokKV/Zzm6pZa7vOb0GaZ8nBjY1Insl+viuKdrm9dLXwG5n1Zs9APF91R6YRuykSmnfVx7cjCXM2cw1eqsqk6ugBHztopcX4hPyY6QOl5tYC0SxMJPbe0B+GnwYRsmhraRjzpsWowB3/f6v03YMMUaeF1DeZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MK3x2N9z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753199448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1d39bdqnItomRQBDSV5BhuZCnSF482IcxM6Ke6+QbMc=;
	b=MK3x2N9z7qnin1prKfT5errMU636qUNCFVLViP+ien7349Kg9DXFEij18iHaD+X0ZvJ4dU
	D8hd48C3ds4D5V1h11wj/nqW1ZOYiP2vg6QxT8DkhLSzxeb3YOkE9M73ly1Egvrx07TSLz
	KRr0Ojh6y4Ii5nWFw10GlOTaQkF/pVk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-V-6CVFI2MR-7UV5iZk9_Uw-1; Tue, 22 Jul 2025 11:50:46 -0400
X-MC-Unique: V-6CVFI2MR-7UV5iZk9_Uw-1
X-Mimecast-MFC-AGG-ID: V-6CVFI2MR-7UV5iZk9_Uw_1753199446
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a5281ba3a4so2183009f8f.0
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 08:50:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753199446; x=1753804246;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1d39bdqnItomRQBDSV5BhuZCnSF482IcxM6Ke6+QbMc=;
        b=V3RL8dyzLq0jvz+KS2oXNmJrC6Crbr8QsMaMXtQhfB2JvRaxx/L5z98u7FVoqLTdT+
         rzQVRZUYmc+OekX4YYHXFMIarQ4Vl9IkBKGLrJPBC25iFD1y7Tc4as26FiKs6UaFHwjp
         kIuFFzENu/NbmeKgUxCiKRlrJcj65xC6WGVmylG825wFRVC06AVc7g80VoxnJBAk9/Dd
         ykGduybpD0SK5RRxY2xQmsHIC6i+MvT0WDkRH8cowT3HahulCSuw3Rm443k2cDFFi/8H
         8qtB/yGVGLWTx/BOwuBDstVilsoobolBjGzQE9huxL56sb7aKQ2wdmX2viPAUtp7s+Nw
         08hA==
X-Forwarded-Encrypted: i=1; AJvYcCURxYm8Qn0iQbZuaiQyX0LdJ6XBhc6BNXhSJ5IjPYZahlaCyYmx2LqjPFl6MJmA0u3fc2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOq07UFwrnOnJkenVg3Bc+rDEBQNN/Y+FKSSObWzxssPeUlYXD
	W0lpwMps04lWAWKO+ER1r/wTQiX405vnzC0sFYgtRJf75Lp5X9ncmCSi/H2gEFgLRLFHgUc0AH9
	lzq/lURq75nSkmCM6rW2pIy6wv1FjWi6gzDRKK1J6REvmuDeANmnDPw==
X-Gm-Gg: ASbGncvkyO3przf1T9lbzQ50U+j8uQQsaf3Bf9qVblgCYdV/jjX6VBQMaytdRJL8xmJ
	kO9blMKW5AuLvFqmJmCLUy8VD5zIOecrV7g14Ukvg+CikGVgcG0kbP3LzdSanegfGjjWPXkVCXg
	0g/aTBUmVRC/v6KcxlLjk+iWigWMplDz+SjnnaNoG5Xw1DlioLJmhY7FJSJEmtsnkQlMTqdb14I
	bW4FDGKs8q+EDSBN5V7Svxa047LfkBMUXEqKzeOHQIT+aZBPJDDoUCTKVJTAGAXN42FyKItg9je
	pRmUt1Gea8LJWGHYBBJwyNYuE+K79yp+IgRB3bMH7VWS2F4x4jrIUVV9drNM3LW45YUBR8/LpC8
	PRyqaZAKyQWlR/chG44uVrJhqRy7u+xAIwdk71V35xIWU4bA7OYN3opxk4Dh2WBqW1fE=
X-Received: by 2002:a05:6000:985:b0:3a4:ea8f:efe4 with SMTP id ffacd0b85a97d-3b61b0f1bd1mr10419439f8f.18.1753199445467;
        Tue, 22 Jul 2025 08:50:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGm2frdCNOY1aH4JiQzplVhsf9wX7Yke0loRi54J0nEvdnAMQE71SJU05PcYhh7A1tnkUVGXQ==
X-Received: by 2002:a05:6000:985:b0:3a4:ea8f:efe4 with SMTP id ffacd0b85a97d-3b61b0f1bd1mr10419384f8f.18.1753199444899;
        Tue, 22 Jul 2025 08:50:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5d018sm13686920f8f.90.2025.07.22.08.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:50:44 -0700 (PDT)
Message-ID: <e7fee2b0-eb71-4556-a99b-ba9b44491519@redhat.com>
Date: Tue, 22 Jul 2025 17:50:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
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
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
 <aH-iGMkP3Ad5yncW@google.com>
 <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22.07.25 17:31, Xiaoyao Li wrote:
> On 7/22/2025 10:37 PM, Sean Christopherson wrote:
>> On Tue, Jul 22, 2025, Xiaoyao Li wrote:
>>> On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
>>>> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>>>>> +/*
>>>>> + * CoCo VMs with hardware support that use guest_memfd only for
>>>>> backing private
>>>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping
>>>>> enabled.
>>>>> + */
>>>>> +#define kvm_arch_supports_gmem_mmap(kvm)        \
>>>>> +    (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&    \
>>>>> +     (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
>>>>
>>>> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
>>>>
>>>> Actually, QEMU can use gmem with mmap support as the normal memory even
>>>> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
>>>> on KVM_SET_USER_MEMORY_REGION2.
>>>>
>>>> Since the gmem is mmapable, QEMU can pass the userspace addr got from
>>>> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
>>>> works well for non-coco VMs on x86.
>>>
>>> one more findings.
>>>
>>> I tested with QEMU by creating normal (non-private) memory with mmapable
>>> guest memfd, and enforcily passing the fd of the gmem to struct
>>> kvm_userspace_memory_region2 when QEMU sets up memory region.
>>>
>>> It hits the kvm_gmem_bind() error since QEMU tries to back different GPA
>>> region with the same gmem.
>>>
>>> So, the question is do we want to allow the multi-binding for shared-only
>>> gmem?
>>
>> Can you elaborate, maybe with code?  I don't think I fully understand the setup.
> 
> well, I haven't fully sorted it out. Just share what I get so far.
> 
> the problem hit when SMM is enabled (which is enabled by default).
> 
> - The trace of "-machine q35,smm=off":
> 
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000
> ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#1 flags=0x4 gpa=0x100000000
> size=0x80000000 ua=0x7f57b3fff000 guest_memfd=15
> guest_memfd_offset=0x80000000 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#2 flags=0x2 gpa=0xffc00000
> size=0x400000 ua=0x7f5840a00000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x0 gpa=0x0 size=0x0
> ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0xc0000
> ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x2 gpa=0xc0000
> size=0x20000 ua=0x7f5841000000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#4 flags=0x2 gpa=0xe0000
> size=0x20000 ua=0x7f5840de0000 guest_memfd=-1
> guest_memfd_offset=0x3e0000 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#5 flags=0x4 gpa=0x100000
> size=0x7ff00000 ua=0x7f57340ff000 guest_memfd=15
> guest_memfd_offset=0x100000 ret=0
> 
> - The trace of "-machine q35"
> 
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000
> ua=0x7f8faffff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#1 flags=0x4 gpa=0x100000000
> size=0x80000000 ua=0x7f902ffff000 guest_memfd=15
> guest_memfd_offset=0x80000000 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#2 flags=0x2 gpa=0xffc00000
> size=0x400000 ua=0x7f90bd000000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
> kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x4 gpa=0xfeda0000
> size=0x20000 ua=0x7f8fb009f000 guest_memfd=15 guest_memfd_offset=0xa0000
> ret=-22
> qemu-system-x86_64: kvm_set_user_memory_region:
> KVM_SET_USER_MEMORY_REGION2 failed, slot=3, start=0xfeda0000,
> size=0x20000, flags=0x4, guest_memfd=15, guest_memfd_offset=0xa0000:
> Invalid argument
> kvm_set_phys_mem: error registering slot: Invalid argument

Weird. When splitting regions (I think that is what's happening), QEMU 
should first remove the old slots to then insert the new slots.

Otherwise there would be GPA overlaps as well?

-- 
Cheers,

David / dhildenb


