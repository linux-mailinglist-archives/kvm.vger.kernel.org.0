Return-Path: <kvm+bounces-52678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F88EB08150
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 02:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43EE1580802
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 00:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45136C8FE;
	Thu, 17 Jul 2025 00:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a31jNAEp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C974A33
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 00:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752711147; cv=none; b=WumP7Shnd4BpRe3vXfVyFh7h5PMNtc4hjZZGNZ9zEG7o4j5DqDJ7SIRo3+KCxu++Jx5YGdRi1UPNSXOyVZS+6vQK0iHByBkxAOsB/ZX0WMgu+eSXVFprCA7xLxOAORPrVjIuzqXCPLhWqfGGPBLmM6+wxTFOGkBAAw1owgcqg+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752711147; c=relaxed/simple;
	bh=64u7gplaNw1kunyC5ugvI4yrr4rxsuaT3qUlLaDC6K4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XaN+FMIbJdujfDMU7CU4fG6G9/ExqOX0h6SJlIf3cygnPE96QSzH+vZGpvkGkOmoLnwqirpTLGBvJqA/bXRSWm4+lg97SjGzGbG8FKXPNM4NWyn4AM/reQMy3If/V+sP6RsKWXnqtpCKIo1ictsVvTJ2LEGclfwYCUNKtnswjSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a31jNAEp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c8437ffso685935a91.1
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 17:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752711145; x=1753315945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gk6wLLhT1qqsQx1vsq1Ga7hHjoZDrrbu+Mlqiv/jJEw=;
        b=a31jNAEpucafMWrZbGm/Mb9Uvg+CdTfuy0vesvc2+rtCpeSIslRb4vwq4O97oAiQW1
         b41/H5BRfffXfKzO7kGgdSCd3AThdGJUty28GVMJ6SFdvEyIflTYNboUMiFGE+eufjfq
         ICiIYAWW/pSpAzCDYsBjJlB1SK5T59TLAmlGJKkVOzLalg/S4eM6a7p73hg2jnWWAIqK
         I53T8jiZl9+76sCwtpC1OUzSEmvIN1fD/FkecSJNA0LMKwi1a2iot7yWl24Rk4IKdJ53
         1K0r/GK5b8jm1whMwz6ZfZWdm0FfpM5+Bi/af/Ggt7MYTeM/jTC8YOC92R1J+/4Twi9J
         IZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752711145; x=1753315945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gk6wLLhT1qqsQx1vsq1Ga7hHjoZDrrbu+Mlqiv/jJEw=;
        b=e6IekbXy3tV1fR+cqhH8Iarp7VOHB53Q4RraDNU3VLi6ATyKu5dViHBMYKj3cE/F9K
         WeSJkD10Vz7RGetIaASX/4TSmkmjSv2ArXCf5g6sKuGInqmQjpidD2rztWNhBw7IowoT
         BNSieKjiyXyGC45rSZ6wm3wGvSTnXbUrK5rLr5jV/xDVRDPDhBaI9kgKePICA/AO0kJJ
         oCw0CyIGKbcOv06WxRQyTtRuAqqf+51XvTkzYYhjaeb0Sb85LqnGnWn4DvxOdx8zmNyZ
         A1NMc95UHilt/HaTRozovpPs1jM1aFXX7rAFKnahsv+qWEEy96tZBwC1IBb0EwPMISat
         QldA==
X-Forwarded-Encrypted: i=1; AJvYcCXaJyoblHJ+cPTNFFviJkee3wryJ68NvAnNyRiiGylltTsBmzz/VX6Mm1e6BThuai/XrRU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXm7QuHSzx9VNshN/x159Gu3EPx+J69aihj6OT3JKbgEnOQ6/A
	ZUAalQANemQW/LCcVZzPZpcYIlpCTfxF2Rvtj2fLfffOQyz8AJkWRKI4g5dD0dIO7cZeEK2t42l
	J9oFXuayvLq1oIgXKsV1Fkdfv8Q==
X-Google-Smtp-Source: AGHT+IHYqkhidL9ADNIxka/sw9kZlySMvbshPs2sml34P69NiRa5nonm2zXm4PkWmozfaq0ESGY7q3V4+4cqMYXu2A==
X-Received: from pjbsd11.prod.google.com ([2002:a17:90b:514b:b0:311:c5d3:c7d0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5307:b0:313:db0b:75e4 with SMTP id 98e67ed59e1d1-31c9f48a241mr8160755a91.33.1752711145174;
 Wed, 16 Jul 2025 17:12:25 -0700 (PDT)
Date: Wed, 16 Jul 2025 17:12:23 -0700
In-Reply-To: <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-5-tabba@google.com>
 <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com>
Message-ID: <diqzwm87fzfc.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v14 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
From: Ackerley Tng <ackerleytng@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>> Introduce a new boolean member, supports_gmem, to kvm->arch.
>> 
>> Previously, the has_private_mem boolean within kvm->arch was implicitly
>> used to indicate whether guest_memfd was supported for a KVM instance.
>> However, with the broader support for guest_memfd, it's not exclusively
>> for private or confidential memory. Therefore, it's necessary to
>> distinguish between a VM's general guest_memfd capabilities and its
>> support for private memory.
>> 
>> This new supports_gmem member will now explicitly indicate guest_memfd
>> support for a given VM, allowing has_private_mem to represent only
>> support for private memory.
>> 
>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Shivank Garg <shivankg@amd.com>
>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>> Co-developed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Btw, it seems that supports_gmem can be enabled for all the types of VM?
>

For now, not really, because supports_gmem allows mmap support, and mmap
support enables KVM_MEMSLOT_GMEM_ONLY, and KVM_MEMSLOT_GMEM_ONLY will
mean that shared faults also get faulted from guest_memfd.

A TDX VM that wants to use guest_memfd for private memory and some other
backing memory for shared memory (let's call this use case "legacy CoCo
VMs") will not work if supports_gmem is just enabled for all types of
VMs, because then shared faults will also go to kvm_gmem_get_pfn().

This will be cleaned up when guest_memfd supports conversion
(guest_memfd stage 2). There, a TDX VM will have .supports_gmem = true.

With guest_memfd stage-2 there will also be a
KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING.
KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaults to false, so for legacy
CoCo VMs, shared faults will go to the other non-guest_memfd memory
source that is configured in userspace_addr as before.

With guest_memfd stage-2, KVM_MEMSLOT_GMEM_ONLY will direct all EPT
faults to kvm_gmem_get_pfn(), but KVM_MEMSLOT_GMEM_ONLY will only be
allowed if KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING is true. TDX VMs
wishing to use guest_memfd as the only source of memory for the guest
should set KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING to true before
creating the guest_memfd.

> Even without mmap support, allow all the types of VM to create 
> guest_memfd seems not something wrong. It's just that the guest_memfd 
> allocated might not be used, e.g., for KVM_X86_DEFAULT_VM.


































































p

