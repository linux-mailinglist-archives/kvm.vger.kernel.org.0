Return-Path: <kvm+bounces-48645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB8CACFF0F
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 11:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACB4716BD22
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A5E2857F8;
	Fri,  6 Jun 2025 09:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XSX3OqV+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9892853F6
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749201493; cv=none; b=eS4WvzVI6GfLk2655/ILXFOAsKsrXwFpZW6WIa3A7C75HgI87KndIXdQXDKxRVRJeHt5Mqtf/ahcn0OFARkHWwGGbwtqAdSaxCsggbKQ172IqVlBgWECI8NLbDCvJ8JPGkLoMCS1i5AS5yymeZ72XTetwga3qKPvG0P87bUTtPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749201493; c=relaxed/simple;
	bh=Fhk8JW40lJiOzjJuYl9plVhfmLpuSn9Evq5zmniYlMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SfKBucjz2Lmwwy7JfMAWOhemOKQgFTRo+cY18jW921JN9Gx8pTx++/s2Bq67EaqmD1/jqw+PXq6Ok082B/ltemKWsalAaN5SeLOlWfxDwBpz2NBY5yDeChFDe+s2DlTOELRveb5u0j7AClpKbHRpMwnbzT7gNqv2Js5nUbc9gH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XSX3OqV+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749201490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jj58XfJATL0B+GEQPXpt1/s2cxBgD2Nu15jBPdy+PsA=;
	b=XSX3OqV+mbVjOI0jPyQKMh/XnSl0BNFX2SRKtSTSmZRiZQhsDLv9B7ZRzT/VYfvb9SYchv
	KAdtC5m5n5JFaZkXbJhtqsi1Cch4DnQTN/J8vWa7VI2/FSyzVrrjdNDLF8G6/QpcBRxpPR
	nqUCC9Ss4L5HgcupiYI/egJMhJ1sd5U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-1AUX0IKCMhq7ydaChp7LYA-1; Fri, 06 Jun 2025 05:18:08 -0400
X-MC-Unique: 1AUX0IKCMhq7ydaChp7LYA-1
X-Mimecast-MFC-AGG-ID: 1AUX0IKCMhq7ydaChp7LYA_1749201487
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so12358335e9.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 02:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749201487; x=1749806287;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Jj58XfJATL0B+GEQPXpt1/s2cxBgD2Nu15jBPdy+PsA=;
        b=USOwPGaefzaPo5itb8eyUfvoazWiF94ecsO1F7i/KNoVZhE7eCSF/8r6oC41NFsRTv
         SbFutezdnLJKxAyOTX/A255QhjZykdj5bUZipFQ5zERMGlTvYMwG0HAFi1NMU58oxanb
         EviY4YfuaVJuRXx2zjBxFLOlpApfedg15u/865tvx6E5dc9ZPjwup4LMIKIslGoJ7NBp
         FvJ7Y7Mu/nEp6U15atasQh6jL9+GXLPv2J9bH7sndtyOMdB4X1b4OC4Isl1Ytz21SahQ
         OOtCpVSasTYndf504k7gLWYiKHgSiY4iD2qadnQQ67J9R5WUNhhzyfAnE1jPECMeXRux
         0mCw==
X-Forwarded-Encrypted: i=1; AJvYcCWQl0FDr5QMOMyxZk4xVUxUe5xCV/Wp9dMkTLH9cE0FXEA/5x3x7psjFLImZUetf9W6y18=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoAvNaMTX8UBFxj3WcdnLtz2DzjAG6pVXFYqN7H9Ei0ZCaH6Hd
	fDJZXe5Q18KVT7tkNU5HA8K/rzYuq5HpL/Momrq+lFeI/+M+zwjHMLurbenm8MU4FPW6CBEjL74
	msHM/4SoW1u4ukm5xSFXSY3S6IJ9KVFau6FHyxzACxPmiFLGEYJ/Y87VwVMrz1w==
X-Gm-Gg: ASbGncsSQl5Ve3ES15AQ55Q70skDUpva9mtuGdXxuECIFDPrOw7S5D2kL+/Zgdjh5Ph
	EcAozm4QczaerPeXAoseRp/7I6MLG9hM1LIoZS9nVLJaKz54EVx5qxybBqg3pEYLIPzI+ayPaov
	sLEso++oqmY6nu6nCS9cyJ7oszRn2HMfMzIHwr765ZgvjJ7ZtrMUKkQ30aoXASAXlych8aDLdAE
	4CRKKXKqQnY8S1hdUDuBtQ1rttEGTDTOPFo+ywIOyvVKUP2D7z4x/FlZPRkyOGa7uU+8sA4JKAC
	d1gwOJrsIaMiMXD+nt/Fv/0KkMT+C5DAmnAxv/hDnEFXq8z21gaWNL6fmvCGzRfuUO0Y6bo8slL
	6Xh3VxhFTd2tTzIwgfoy1lN5EssjhQ1U=
X-Received: by 2002:a05:600c:1c99:b0:44a:b793:9e4f with SMTP id 5b1f17b1804b1-4520143724fmr22881725e9.19.1749201487255;
        Fri, 06 Jun 2025 02:18:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXHxPEab+pPqx+rT1qPLZUVdURglPsCFidzht7Kh/mmEEi+EL5y02Ki6Q7IFWhAT0wjRNTiQ==
X-Received: by 2002:a05:600c:1c99:b0:44a:b793:9e4f with SMTP id 5b1f17b1804b1-4520143724fmr22881395e9.19.1749201486711;
        Fri, 06 Jun 2025 02:18:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:9c00:568:7df7:e1:293d? (p200300d82f199c0005687df700e1293d.dip0.t-ipconnect.de. [2003:d8:2f19:9c00:568:7df7:e1:293d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45209bc6d50sm17630415e9.5.2025.06.06.02.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 02:18:06 -0700 (PDT)
Message-ID: <870d1f85-840b-40ba-9eeb-14d3a5b7f169@redhat.com>
Date: Fri, 6 Jun 2025 11:18:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
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
References: <20250605153800.557144-1-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.06.25 17:37, Fuad Tabba wrote:
> Main changes since v10 [1]:
> - Added bounds checking when faulting a shared page into the host, along
>    with a selftest to verify the check.
> - Refactored KVM/arm64's handling of guest faults (user_mem_abort()).
>    I've dropped the Reviewed-by tags from "KVM: arm64: Refactor
>    user_mem_abort()..." since it has changed significantly.
> - Handled nested virtualization in KVM/arm64 when faulting guest_memfd
>    backed pages into the guest.
> - Addressed various points of feedback from the last revision.
> - Still based on Linux 6.15
> 
> This patch series enables the mapping of guest_memfd backed memory in
> the host. This is useful for VMMs like Firecracker that aim to run
> guests entirely backed by guest_memfd [2]. When combined with Patrick's
> series for direct map removal [3], this provides additional hardening
> against Spectre-like transient execution attacks.
> 
> This series also lays the groundwork for restricted mmap() support for
> guest_memfd backed memory in the host for Confidential Computing
> platforms that permit in-place sharing of guest memory with the host
> [4].
> 
> Patch breakdown:
> 
> Patches 1-7: Primarily refactoring and renaming to decouple the concept
> of guest memory being "private" from it being backed by guest_memfd.
> 
> Patches 8-9: Add support for in-place shared memory and the ability for
> the host to map it. This is gated by a new configuration option, toggled
> by a new flag, and advertised to userspace by a new capability
> (introduced in patch 16).
> 
> Patches 10-15: Implement the x86 and arm64 support for this feature.
> 
> Patch 16: Introduces the new capability to advertise this support and
> updates the documentation.
> 
> Patches 17-18: Add and fix selftests for the new functionality.
> 
> For details on how to test this patch series, and on how to boot a guest
> that uses the new features, please refer to v8 [5].

Paolo Et. al,

I only found some smaller things, this is looking mostly good to me.

... worth having a look ;)

-- 
Cheers,

David / dhildenb


