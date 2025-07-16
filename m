Return-Path: <kvm+bounces-52612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A242B07380
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AABA1C2552E
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8102F363F;
	Wed, 16 Jul 2025 10:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OGXHHyZq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732402F2373
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 10:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661954; cv=none; b=spxtHa7fvaOwiI37CmAXzKl/eCUv/Mb7f3UtWGN6zx2fo7HQEMbqCECVFiQQqFwiba6h/1BrEAGy55sB1g+cfFOl+OPSIzOZHT026t+Sg/9fOvJHPsWgzwVk5VR5p7NusVCsD77Y0zXL8BMZ+DXCUv4KA7RhCsuj3C94J99zr2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661954; c=relaxed/simple;
	bh=SIILFfD9FpWVGU8tYc18+GX/4WCddurDvAAxeExLFuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cO4dSAlbJ0zucrvpjisGa9xQXSHDFZBcvXi4SpA73AQlTRPOeIfihgoNlv5sy0zOJ6LHg5WLjoe5s2eqmzFE9VplPv34ZgZnJP2RH/X/49I4qrFz9wKRGsc/8F9wymxrbRBU706H/MIZQAyar0IuYe3eH7nEKOMN2dN7M/HRiIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OGXHHyZq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752661951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1GYsDWoIStsXMsHD33uJEgdmtm01d6mGHKkFOaBxXvU=;
	b=OGXHHyZqBaKncjW1NlU/vorBy8x0JlDtw6TnCN3JKk3YfpDnWu0Z2mYSkk1hn1CmDKMfTB
	EIT2w7XqRCX8EDNiuI3yxhUv/yvyHgStcadNGo7bqJ4xEvW8ya5WLQrehCe2klZemm89Zv
	NTGKstWOOzH4mDb2urqHnUcc6n9WS9E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-2FyIfzLZNg6lV6AF91y50g-1; Wed, 16 Jul 2025 06:32:29 -0400
X-MC-Unique: 2FyIfzLZNg6lV6AF91y50g-1
X-Mimecast-MFC-AGG-ID: 2FyIfzLZNg6lV6AF91y50g_1752661949
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so41431265e9.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 03:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752661949; x=1753266749;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1GYsDWoIStsXMsHD33uJEgdmtm01d6mGHKkFOaBxXvU=;
        b=tFTq0Id3swnKmzEW3atVYtduaFtqHZJRNw1Va5DpPGlC2wHG7HDMZ9JQaRl4Edi9xV
         Pu1dcBq7dMH3JOtt20Wm+C5gWb61UqKQq8p6W1k1H0QhEhw3yjQYavN60wT0iz/YIKXS
         msdsOdil1ImTeHaKKmBpEiVAzI4oFCgEuI1HNpmQkI1mutJZGW1GkbBjUShHrhkZSZfp
         pJzZU6IpDfQhA4MXMUdaENOBWP4H9VTCyOqJic1s+5SANE137UEuxUiZ2NdDVGlVLHvj
         i/Afz7w2iSTLZwk0Lvg7dYwjkfywDQ0snrVAXsPTrDCV1d4UTnol+TI6WDrJE39dWjd6
         O9jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUeFZk+IoFqklVVunMhSCJv0FvfTnsONXf6YMZ/1apCsbMR4gVoX4wjuzgWRTFJOAlz4A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9PfLu4itmBRoO5nffUXCeUZHxaW330xZQo/3JELidIXwbVLyh
	0g/ZmXEeNAtTmKbdBfHrBZJW/8gtB6Rx+/rPdqm8LIsP3WlceBzpSi7M1RSm+lQaLuVGDdMXnxJ
	1H/aho87mz8JXpJElU/CBRzX9SEHrUutKQHPZByf2roRqvQzH1zKVuw==
X-Gm-Gg: ASbGncvsy8r8lmhXnHYEv9NFGWFDzsd0QPi6G2waXnTSPZHTF/a/dU+dJKwguxOpLAu
	6RM2c7A8nVGHtgsda4pWlBcXmWQmLDva1pPEpaODMuVzip919t/Uw2Sbz47CcIsJbIMtCAM8IZC
	hukhhov6Z/Mzm/rizkWIyKGvrB5v5cXNzjg6f7folBMw/KxS1N/sMRpKznZuJTfUrZrV0f2/075
	J7Dt6NbmvA/+XFUjn5ge9AExp/KO6o2+SzrMyDUXYj6O+S51YDl18+sWPQORW1lWbHhXDwikFxG
	GKVIsCYAxilbNZZcYIyqWxYWcYoMk3EcoP5DRzGQCRXt46YmPkIv9Ft/rl2+N6Y1TTIb3KLXrrZ
	SViDeJcdDFkZ3xaXVgjTOH0Q8uwFqxaehbb1+RzXIePcJ1CQTCzHJEjh6rJ8q3Lu/JNo=
X-Received: by 2002:a05:600c:5246:b0:456:207e:fd86 with SMTP id 5b1f17b1804b1-4562e03bdf0mr26168855e9.2.1752661948314;
        Wed, 16 Jul 2025 03:32:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQY04F9HJOkn2t2EX1x6mLG2jJ39mE6qwytWm5EzTrhi0RbWVkEIBGqIKBqZCZaFlq4Tb2Yg==
X-Received: by 2002:a05:600c:5246:b0:456:207e:fd86 with SMTP id 5b1f17b1804b1-4562e03bdf0mr26168255e9.2.1752661947743;
        Wed, 16 Jul 2025 03:32:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:ed00:1769:dd7c:7208:eb33? (p200300d82f1ded001769dd7c7208eb33.dip0.t-ipconnect.de. [2003:d8:2f1d:ed00:1769:dd7c:7208:eb33])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e7f2f1bsm17190395e9.4.2025.07.16.03.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 03:32:27 -0700 (PDT)
Message-ID: <c4908e40-fbe0-487e-8380-0a0cc24c18a7@redhat.com>
Date: Wed, 16 Jul 2025 12:32:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
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
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-15-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250715093350.2584932-15-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.07.25 11:33, Fuad Tabba wrote:
> Enable host userspace mmap support for guest_memfd-backed memory when
> running KVM with the KVM_X86_DEFAULT_VM type:
> 
> * Define kvm_arch_supports_gmem_mmap() for KVM_X86_DEFAULT_VM: Introduce
>    the architecture-specific kvm_arch_supports_gmem_mmap() macro,
>    specifically enabling mmap support for KVM_X86_DEFAULT_VM instances.
>    This macro, gated by CONFIG_KVM_GMEM_SUPPORTS_MMAP, ensures that only
>    the default VM type can leverage guest_memfd mmap functionality on
>    x86. This explicit enablement prevents CoCo VMs, which use guest_memfd
>    primarily for private memory and rely on hardware-enforced privacy,
>    from accidentally exposing guest memory via host userspace mappings.
> 
> * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in KVM_X86: Enable the
>    CONFIG_KVM_GMEM_SUPPORTS_MMAP Kconfig option when KVM_X86 is selected.
>    This ensures that the necessary code for guest_memfd mmap support
>    (introduced earlier) is compiled into the kernel for x86. This Kconfig
>    option acts as a system-wide gate for the guest_memfd mmap capability.
>    It implicitly enables CONFIG_KVM_GMEM, making guest_memfd available,
>    and then layers the mmap capability on top specifically for the
>    default VM.
> 
> These changes make guest_memfd a more versatile memory backing for
> standard KVM guests, allowing VMMs to use a unified guest_memfd model
> for both private (CoCo) and non-private (default) VMs. This is a
> prerequisite for use cases such as running Firecracker guests entirely
> backed by guest_memfd and implementing direct map removal for non-CoCo
> VMs.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


