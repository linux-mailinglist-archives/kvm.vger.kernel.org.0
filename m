Return-Path: <kvm+bounces-45528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA912AAB451
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C437A3AB953
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE508474F44;
	Tue,  6 May 2025 00:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4HkJgdo6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9152EEBC4
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486603; cv=none; b=LMrmeU5oN0b8TGCrgN1N++H5qjIoybSud7HaukY9DqNIKgFuVV2AMcb8LtBVphjeKc1TMOEHgHUa2XFTCom1PcVrcpc3nA6jLnjj0GAwJ8uoUiR5/omJTj6ijm+leiDucNAvlYSXuOTAXOAbSadKgEmGa27s3+7fAbY9KuvWK0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486603; c=relaxed/simple;
	bh=RONzCBKEJXsibO821H3QXKTMTcGq3jA6Qh5Dz6t2q8I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MvOp4OcBv9isDPbWwnQv0Ffa36bJ0FsGbmrKNzDCtNUunYF85vtm9Vr8p6ABG4i/jqNn9W/kVf0xfnfkKZEmcHre1mi2sUWqx6Cj6monYIYNuk7q6pKihtT+Kw5W4TBJq6k7iDbreTJK23p2jXzTC7tkhfq4avl8U6AbW56HH3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4HkJgdo6; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b5f9279cso4114802b3a.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746486600; x=1747091400; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QKDIrUmShBenn7oyPXZBGKMvZgIcDdiYuAx6vvvr0uk=;
        b=4HkJgdo6PWxRFgvN0l4WFIYrioMyTEmY1wu//CCKR89dF9kQy3PuV1F/2plvvBnsY8
         4rccS2r0eV+Mz3B2G4FGmT470NUpUXrXE4Fj1iisnoTSieFibeH9e5MN+H8NhVxeVB6v
         0qv2O2d0f3GBipYkwK8nyZB3C2EjugohWzB+wmma/ByDg6eYEJxisw7ebc1ZjNxMQ8yz
         KbtvR+bha/yWUuue0UaGM6VlzgXsgWnyjHzoFNL/X0a3XnnzFh+ypvFRmD6/VQuWhC2e
         51nFUIYCgpTkkj0CQ/FXSernmJn+MjPYt4QL9JJlJFojEqtNxdMc9USrrwsuO8MmRtcz
         iw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746486600; x=1747091400;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QKDIrUmShBenn7oyPXZBGKMvZgIcDdiYuAx6vvvr0uk=;
        b=gukrpEOSLwplkek51069YcCccyiNQh9Z5KKggVKQ8+BJ8Ce3Ni/5ElnPzeDTWA+ge7
         6IG3nq03HdaRWnTjiAl5SO27p4Uy4m5UZOXqSoYoHnhmz+kQ104QwS5E3hFcsY/ZdtCp
         1pAhavrf6bpVLq+zrj8FiCMHZLNcIT0oF/+uMt+7mgs4rpxDlzcGEF+bjIdvqOxV8X/S
         sMIJW5QYwCtMLEtbTLQ/gD0jFZpM2l+dz646iLGoWBMqxZXuHmVuH4Ifc0zvwocPAkwz
         O/MsNc/MnEGasEdmRe2dt15xAa8RXCMVNrAfvlV/fWRPABscySVxOTb+UeoprHojgMI2
         k8LQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/IzjBH6CQhxU+Ajk4Jb0Op9a2F+Z/oXLF6J+VqDRxZWFjB87h0LcewjZ1gRCHoyIIRFM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5eEy5Mri39+nSG9ZbaOwQJU/hCf16Io2tGzQfIQg3IJTIxUt1
	a2fQ/Ld23UoA+n/LPiaLA7YsLhiqwo9HERuS/IYXtgnl7wIwxHmv5fvVwiLBvsHVTpBTvKrZiMr
	TqRFO3rVAcyhAlhg+s2+glQ==
X-Google-Smtp-Source: AGHT+IH8nRtKZdcXRNW5pHePDqwjVYLFx8dauinck+p9OIy/5vnrG+4KpoUHfGGyuxJRstUfMIhSpCGvhSjtLgsvJw==
X-Received: from pfst35.prod.google.com ([2002:aa7:8fa3:0:b0:736:86e0:8dee])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:aa8d:b0:73e:1e24:5a4e with SMTP id d2e1a72fcca58-74091a963c7mr1411673b3a.24.1746486600519;
 Mon, 05 May 2025 16:10:00 -0700 (PDT)
Date: Mon, 05 May 2025 16:09:58 -0700
In-Reply-To: <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com> <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com> <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
Message-ID: <diqzfrhik62h.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

David Hildenbrand <david@redhat.com> writes:

> On 03.05.25 00:00, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>>> On Fri, May 02, 2025, David Hildenbrand wrote:
>>>> On 30.04.25 20:58, Ackerley Tng wrote:
>>>>>> -	if (is_private)
>>>>>> +	if (is_gmem)
>>>>>>    		return max_level;
>>>>>
>>>>> I think this renaming isn't quite accurate.
>>>>
>>>> After our discussion yesterday, does that still hold true?
>>>
>>> No.
>>>
>>>>> IIUC in __kvm_mmu_max_mapping_level(), we skip considering
>>>>> host_pfn_mapping_level() if the gfn is private because private memory
>>>>> will not be mapped to userspace, so there's no need to query userspace
>>>>> page tables in host_pfn_mapping_level().
>>>>
>>>> I think the reason was that: for private we won't be walking the user space
>>>> pages tables.
>>>>
>>>> Once guest_memfd is also responsible for the shared part, why should this
>>>> here still be private-only, and why should we consider querying a user space
>>>> mapping that might not even exist?
>>>
>>> +1, one of the big selling points for guest_memfd beyond CoCo is that it provides
>>> guest-first memory.  It is very explicitly an intended feature that the guest
>>> mappings KVM creates can be a superset of the host userspace mappings.  E.g. the
>>> guest can use larger page sizes, have RW while the host has RO, etc.
>> 
>> Do you mean that __kvm_mmu_max_mapping_level() should, in addition to
>> the parameter renaming from is_private to is_gmem, do something like
>> 
>> if (is_gmem)
>> 	return kvm_gmem_get_max_mapping_level(slot, gfn);
>
> I assume you mean, not looking at lpage_info at all?
>

My bad. I actually meant just to take input from guest_memfd and stop
there without checking with host page tables, perhaps something like
min(kvm_gmem_get_max_mapping_level(slot, gfn), max_level);

> I have limited understanding what lpage_info is or what it does. I 
> believe all it adds is a mechanism to *disable* large page mappings.
>

This is my understanding too.

> We want to disable large pages if (using 2M region as example)
>
> (a) Mixed memory attributes. If a PFN falls into a 2M region, and parts
>      of that region are shared vs. private (mixed memory attributes ->
>      KVM_LPAGE_MIXED_FLAG)
>
>   -> With gmem-shared we could have mixed memory attributes, not a PFN
>      fracturing. (PFNs don't depend on memory attributes)
>
> (b) page track: intercepting (mostly write) access to GFNs
>

Could you explain more about page track case? 

>
> So, I wonder if we still have to take care of lpage_info, at least for
> handling (b) correctly [I assume so]. Regarding (a) I am not sure: once 
> memory attributes are handled by gmem in the gmem-shared case. IIRC, 
> with AMD SEV we might still have to honor it? But gmem itself could 
> handle that.
>

For AMD SEV, I believe kvm_max_private_mapping_level() already takes
care of that, at least for the MMU faulting path [1], where guest_memfd
gives input using max_order, then arch-specific callback contributes input.

>
> What we could definitely do here for now is:
>
> if (is_gmem)
> 	/* gmem only supports 4k pages for now. */
> 	return PG_LEVEL_4K;
>
> And not worry about lpage_infor for the time being, until we actually do 
> support larger pages.
>
>

Perhaps this is better explained as an RFC in code. I'll put in a patch
as part of Fuad's series if Fuad doesn't mind.

>> 
>> and basically defer to gmem as long as gmem should be used for this gfn?
>> 
>> There is another call to __kvm_mmu_max_mapping_level() via
>> kvm_mmu_max_mapping_level() beginning from recover_huge_pages_range(),
>> and IIUC that doesn't go through guest_memfd.
>> 
>> Hence, unlike the call to __kvm_mmu_max_mapping_level() from the KVM x86
>> MMU fault path, guest_memfd didn't get a chance to provide its input in
>> the form of returning max_order from kvm_gmem_get_pfn().
>
> Right, we essentially say that "this is a private fault", likely 
> assuming that we already verified earlier that the memory is also private.
>
> [I can see that happening when the function is called through 
> direct_page_fault()]
>
> We could simply call kvm_mmu_max_mapping_level() from 
> kvm_mmu_hugepage_adjust() I guess. (could possibly be optimized later)
>
> -- 
> Cheers,
>
> David / dhildenb

[1] https://github.com/torvalds/linux/blob/01f95500a162fca88cefab9ed64ceded5afabc12/arch/x86/kvm/mmu/mmu.c#L4480

