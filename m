Return-Path: <kvm+bounces-36299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D05A19AA0
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 23:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F4A6169416
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 22:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD2C1C5F33;
	Wed, 22 Jan 2025 22:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yxcxt46f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB221C5D61
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 22:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737583630; cv=none; b=uQI9sIgxsImRcsD5LDEs9Mgo/QRNkM6u0QkkptVMj1jos6jhepiAahtoMRmfcctX/OsUkcPBmR1uPcN5aJyUe4uBvPEoFzAe6O86N+GbMILeWS6hi6fYDM1zno0NrTGFlZxJFOmfoPmwFA5oDAnUITT9GmhJCphQeJGPSvoDz7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737583630; c=relaxed/simple;
	bh=jVF4WkoCk+y+qnOEyjWF8t8gbC9s+6TfXekZCjSmOCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UnByi6oB0bwfxwmCcdrTI46FuOgLpTLL35x3bqG4kdAKVoLndFPXQ1jx8Wi87yAAwwOevHmp9UIEBfca+EItlZtmO7Xq0L2fz1Tw/YVm6PnRQAHc/opq37FH2tesAOLAtblMzo5sFTE9hybwKMCXLxRb0e610zze9FRuzXRyzFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yxcxt46f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737583628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wa3d2xqSYlULBFS+guV9/8FSM2BW9DTlT2Ore095VS4=;
	b=Yxcxt46fWILKioG+6SP027fKtGmnYotp6D45Q4ww5WJ4pbexGs8jYtdLKSfLQXQA1o3zma
	zIf9YUr35xo3PwwcL2yeI1qI0/ZjevHGa6LOjKF7k+U3qbQS/azW2QtFAE5WFUI/B9UHTQ
	XdHqXsWtlMtoBij+4J8rU/x2R+WBtoc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-IXaW4hUCNDi8aK4JX8QpkQ-1; Wed, 22 Jan 2025 17:07:06 -0500
X-MC-Unique: IXaW4hUCNDi8aK4JX8QpkQ-1
X-Mimecast-MFC-AGG-ID: IXaW4hUCNDi8aK4JX8QpkQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361b090d23so968665e9.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 14:07:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737583625; x=1738188425;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wa3d2xqSYlULBFS+guV9/8FSM2BW9DTlT2Ore095VS4=;
        b=izCAtNI/KzF8Zh1RUsNv7y9VjjbTIUG1a96eA/A7zKak3DxPOxX8k5jVGdp+jvauxS
         4LvfYaS49xet+bByMvOmG9B5UKBSIrsOY1RGcY3m59xeg4sYRAmgSlJK6xuCAf8uuV3w
         nm8PPXtT8Vj/8LgNh39t+5PHQFdtXVh7ePNWJv4frMnNJdSnJ29a8qrO2vTuls2+z6Wa
         9jMrIIcJI3rjfO3Lqe7iIH8byt3wm0J235tjVs+xVRg4un3xMv+LKRJlOVwFpBThWZem
         nvKU89gFI2s0PPw5UPUog2/3jb/Ghu6I9gPJ+DdqZDxh1BFPU/m/38yLtdzCdwspCcF7
         VIrg==
X-Forwarded-Encrypted: i=1; AJvYcCVtZR9uiT7VPfKLOmgnAlOmXXTwfZaz8XDOzTUPDh5U3XWEfy2Twl9DdA3zmVLw9OFxxI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVSaZoc3nLHcmhoGVdEj/YMpL8bg1OmC0WsHkZStxI807GP3gK
	/X6CV9pPHdUE91Yn0gb2utdUFPHRNkdPR3cqWUQ6NrrQv+qrAjuqy/JSmBNFllc6zTWh8JJGJZo
	4CiuLohdSRgiT0W/whAHLil0irQe92vAxdLo6oGATZQZ4YiSv3w==
X-Gm-Gg: ASbGncsCxEm9uwQM8Hlr6JzXxnKZy6gncweGSpfC9d0vN0MSmeBB0C80MHl4ZTk25y6
	jP8U3b3g9IqOy4nNKt2ZpJmMDe2X/CJ13L3EXccvUChDsJrLy8bjutz+TdJ4VbUj+yJ9NZBw7Ox
	aKXxlY8vZZFg6Fugxx5aKO2rG3Y/lzfuA63Acd9EkbQ7yd2SeRGkIwq/I1zS7cQOFiyWeZ9Jo3e
	cMAj5O1G/Ikjd1R3ES1n7cG+VOF+6i5o1fHGTCkXI2yMmpovSr8JS6cHHK+6go9a/LQXxF0Jt9N
	huvPnQIXWbjtbPf8+75J6apqtigLhl3FbcfLBaj1mM7AvQ5HITUt+hOVDISqF4XAMF7Bb0/gRPl
	838ArrsYr4pu1c9Mw8kBIMg==
X-Received: by 2002:a05:600c:5012:b0:434:9e46:5bc with SMTP id 5b1f17b1804b1-438913ca718mr244463515e9.10.1737583625602;
        Wed, 22 Jan 2025 14:07:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxZ0RyfJ2RJeTD3ZLFT75LzLOeNp4itbBSWEqP/PS5xDq8omZA1XoGnRbF2VA3HltJNrsPZA==
X-Received: by 2002:a05:600c:5012:b0:434:9e46:5bc with SMTP id 5b1f17b1804b1-438913ca718mr244463145e9.10.1737583625209;
        Wed, 22 Jan 2025 14:07:05 -0800 (PST)
Received: from ?IPV6:2003:cb:c70b:db00:724d:8b0c:110e:3713? (p200300cbc70bdb00724d8b0c110e3713.dip0.t-ipconnect.de. [2003:cb:c70b:db00:724d:8b0c:110e:3713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b1718741sm24332155e9.0.2025.01.22.14.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 14:07:03 -0800 (PST)
Message-ID: <647bbdac-df82-4cdb-a3e9-287d439b4ef7@redhat.com>
Date: Wed, 22 Jan 2025 23:06:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/9] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
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
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250122152738.1173160-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.01.25 16:27, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd in the host
> for VMs that support in place conversion between shared and
> private.
 > To that end, this patch adds the ability to check> whether the 
architecture has that support, and only allows mmap()
> if that's the case.
 > > Additionally, this is gated with a new configuration option,
> CONFIG_KVM_GMEM_MAPPABLE.
 > > Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 +
>   include/linux/kvm_host.h        | 11 +++++
>   virt/kvm/Kconfig                |  4 ++
>   virt/kvm/guest_memfd.c          | 71 +++++++++++++++++++++++++++++++++
>   4 files changed, 88 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e159e44a6a1b..c0e149bc1d79 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2206,6 +2206,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>   #define kvm_arch_has_private_mem(kvm) false
>   #endif
>   
> +#define kvm_arch_private_mem_inplace(kvm) false
> +
>   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
>   
>   static inline u16 kvm_read_ldt(void)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 401439bb21e3..ebca0ab4c5e2 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -717,6 +717,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>   }
>   #endif
>   
> +/*
> + * Arch code must define kvm_arch_private_mem_inplace if support for private
> + * memory is enabled it supports in-place conversion between shared and private.
> + */
> +#if !defined(kvm_arch_private_mem_inplace) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> +static inline bool kvm_arch_private_mem_inplace(struct kvm *kvm)
I assume right now this would rather indicate "support for shared 
(mappable) memory in guest_memfd".

Maybe there is a better way to express that :)

kvm_arch_gmem_supports_shared_mem ?

The in-place conversion is (at least to me) implied with support for 
shared memory.

> +
>   #ifndef kvm_arch_has_readonly_mem
>   static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>   {
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 54e959e7d68f..59400fd8f539 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>   config HAVE_KVM_ARCH_GMEM_INVALIDATE
>          bool
>          depends on KVM_PRIVATE_MEM
> +
> +config KVM_GMEM_MAPPABLE
> +       select KVM_PRIVATE_MEM

Easier to grasp might be:

KVM_GMEM_MAPPABLE -> KVM_GMEM_SHARED_MEM

Support for "shared" memory kind of imply mmap support (otherwise, how 
to make use of it :) ),


(KVM_PRIVATE_MEM -> KVM_GMEM might also make sense, but it's a different 
discussion)

> +       bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 47a9f68f7b24..9ee162bf6bde 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -307,7 +307,78 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);


Would the idea be later that kvm_gmem_get_folio() would fail on private 
memory, or do you envision other checks in this code here in the future?

-- 
Cheers,

David / dhildenb


