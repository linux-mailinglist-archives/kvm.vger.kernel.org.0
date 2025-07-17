Return-Path: <kvm+bounces-52775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56144B09232
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D1515A1271
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48782FCFE9;
	Thu, 17 Jul 2025 16:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CMCwco2v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D48F2FCE2E
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752771012; cv=none; b=TKE3h0p5OYdRdYK97KidUf6bzWjrGC/wJQrycYLYuWhRLt+Xw8PHKFScqh1MoxhHJMhw0LoRSFzD6ZDLPGU6KWVeiQcXXl9DmpyvoKxaYhQ/ki7cdzhFcwpGiW3e5iXL3z/nX84aYWOnVDlXRl2nBiBsfJHqi2ygHDYa3f0pfjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752771012; c=relaxed/simple;
	bh=TyxGO/XUQe6bmOsTjL4WMUSu82dVkBc++MRqd2R27FY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d1Y9Lya0O7Qbj83PuM7QE7ODNWIOqga2WBlE7OQyvQYtMaiqFJA3FP7IB2Qv+0BbNM9er335Y58JFbfY5TnZWZojcl6YNQshC6eNJBYfowCSXN3/xpjzrmc/KCknv8FOCY0ue6hD/boUM6s5ION5nr8kRSMSLLA+csVQ862lkEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CMCwco2v; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3122368d82bso1613869a91.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752771011; x=1753375811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WBAzc7UgvLX+B8PzHVBbV8hcGwtUEb1k8RUWx3wr7P8=;
        b=CMCwco2vY7t1TnhXypTjUWayG18HdccVToPy/mxm7G6XKbWF4afZzO1A6gEb14pGG0
         foSGxJYsdb/tjqX5Q2GImgP+JqPmh+cE3wfa8QGA1EB9e2WQRKWm/gNQTC8Rh1/gwpfo
         gjJuLhTIJyJWhd2ntCXB8S0h1g5F1xfhFt9/H/M8H4HVUfnK4SwjVSlMCDU6okM3aD+u
         saMswYGLBYOoI6tebf6+KwWk/scOYpDWQgU8PgGaqebMc7ZR4JXnORKs5v97JcKAdwqO
         04rIhq3eKfnFxLZOtNy7ZeMIXTQIHrIkdF/nCYqb281wQ6ldoYBycuIOKcQrcZ3JIefs
         HAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752771011; x=1753375811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WBAzc7UgvLX+B8PzHVBbV8hcGwtUEb1k8RUWx3wr7P8=;
        b=N7tZ2Joxrlrdgd2EG7sCNGu/mfLTpSLXGiukkFohddyU4I3Oz50lLu39dYtCMgr1kZ
         DupkYcMB4NuRcGfIutGi3KNuvYAV6m/V+lFDFE3qXn9B167AhiaDtNRYEfjcY3kIm8UA
         Pov6hq12Bns0GWqhXQRedzN6uiWs6jTi1GTVyKXBirO2ObVBg+arTkWx1YjpV3gh9jjL
         6go26KjJX2WBaSk6txKF3lUWlFlaaaSIMtt/IsOd2arUgk3rbNdxhMRaXqB9Blm3J9wB
         Umk/ZMaro47zeo8qTr8YixsmokEyeixg6nLDNqC6ET3cudisJEtddVinBom5mYKv1aal
         9hDA==
X-Forwarded-Encrypted: i=1; AJvYcCWPTcGCi8LnVG/pq4cgqJWZ1MhuObZKP9uviIPcqZYLi/FG95cypXM57sOnH54PDjAVkGA=@vger.kernel.org
X-Gm-Message-State: AOJu0YznTcXi2hS7X2I/I6IukeqUqU+5J2npOTBdj5SveStp25IVBCTK
	/InPNgMCK2RD87dQGBJNUoT4sIRtqhTYJahVKW9ovlNaTdu445+HgolKbk824p6zhebBAc8ScXO
	SKuJ1/WYI9y8X/tp72u2E6XxVpQ==
X-Google-Smtp-Source: AGHT+IEhDg9xNtK2OOevEaVdQD/8F/x32XlKvxnbxDiNek4tVELQY02FrDg+/mKgpmUj0DqZBQWsfDifCuQhasqQTg==
X-Received: from pjbqo11.prod.google.com ([2002:a17:90b:3dcb:b0:311:7d77:229f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:270b:b0:311:df4b:4b94 with SMTP id 98e67ed59e1d1-31c9f3ee9dcmr9740819a91.4.1752771010723;
 Thu, 17 Jul 2025 09:50:10 -0700 (PDT)
Date: Thu, 17 Jul 2025 09:50:09 -0700
In-Reply-To: <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-5-tabba@google.com>
 <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com> <diqzwm87fzfc.fsf@ackerleytng-ctop.c.googlers.com>
 <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com>
Message-ID: <diqztt3ag3su.fsf@ackerleytng-ctop.c.googlers.com>
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

> On 7/17/2025 8:12 AM, Ackerley Tng wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> 
>>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>>>> Introduce a new boolean member, supports_gmem, to kvm->arch.
>>>>
>>>> Previously, the has_private_mem boolean within kvm->arch was implicitly
>>>> used to indicate whether guest_memfd was supported for a KVM instance.
>>>> However, with the broader support for guest_memfd, it's not exclusively
>>>> for private or confidential memory. Therefore, it's necessary to
>>>> distinguish between a VM's general guest_memfd capabilities and its
>>>> support for private memory.
>>>>
>>>> This new supports_gmem member will now explicitly indicate guest_memfd
>>>> support for a given VM, allowing has_private_mem to represent only
>>>> support for private memory.
>>>>
>>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>>> Reviewed-by: Shivank Garg <shivankg@amd.com>
>>>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>>>> Co-developed-by: David Hildenbrand <david@redhat.com>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>
>>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>> Btw, it seems that supports_gmem can be enabled for all the types of VM?
>>>
>> 
>> For now, not really, because supports_gmem allows mmap support, and mmap
>> support enables KVM_MEMSLOT_GMEM_ONLY, and KVM_MEMSLOT_GMEM_ONLY will
>> mean that shared faults also get faulted from guest_memfd.
>
> No, mmap support is checked by kvm_arch_supports_gmem_mmap() which is 
> independent to whether gmem is supported.
>
>> A TDX VM that wants to use guest_memfd for private memory and some other
>> backing memory for shared memory (let's call this use case "legacy CoCo
>> VMs") will not work if supports_gmem is just enabled for all types of
>> VMs, because then shared faults will also go to kvm_gmem_get_pfn().
>
> This is not what this patch does. Please go back read this patch.
>
> This patch sets kvm->arch.supports_gmem to true for 
> KVM_X86_SNP_VM/tdx/KVM_X86_SW_PROTECTED_VM.
>
> Further in patch 14, it sets kvm->arch.supports_gmem for KVM_X86_DEFAULT_VM.
>
> After this series, supports_gmem remains false only for KVM_X86_SEV_VM 
> and KVM_X86_SEV_ES_VM. And I don't see why cannot enable supports_gmem 
> for them.
>

My bad, my explanation was actually for
kvm_arch_supports_gmem_mmap(). Could the confusion on this thread be
showing that the .supports_gmem is actually kind of confusing?

If there's nothing dynamic about .supports_gmem, what have we remove the
.supports_gmem field and have kvm_arch_supports_gmem_mmap() decide based
on VM type? 

>> This will be cleaned up when guest_memfd supports conversion
>> (guest_memfd stage 2). There, a TDX VM will have .supports_gmem = true.
>> 
>> With guest_memfd stage-2 there will also be a
>> KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING.
>> KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaults to false, so for legacy
>> CoCo VMs, shared faults will go to the other non-guest_memfd memory
>> source that is configured in userspace_addr as before.
>> 
>> With guest_memfd stage-2, KVM_MEMSLOT_GMEM_ONLY will direct all EPT
>> faults to kvm_gmem_get_pfn(), but KVM_MEMSLOT_GMEM_ONLY will only be
>> allowed if KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING is true. TDX VMs
>> wishing to use guest_memfd as the only source of memory for the guest
>> should set KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING to true before
>> creating the guest_memfd.
>> 
>>> Even without mmap support, allow all the types of VM to create
>>> guest_memfd seems not something wrong. It's just that the guest_memfd
>>> allocated might not be used, e.g., for KVM_X86_DEFAULT_VM.
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> p

