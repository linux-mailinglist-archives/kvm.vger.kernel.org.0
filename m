Return-Path: <kvm+bounces-47212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B46ABEA09
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 04:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 226BE3BB860
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 02:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1F922B8AD;
	Wed, 21 May 2025 02:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Do81MbLt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610D1148827
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 02:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747795643; cv=none; b=ZF2QBVZK2QHeU/73VG2l3i8k6MMpm0jcPfXgK1gpWgziInEQ+632buJ325wrVemO2TRou4s/BVrqpkdkUov7G1725PDavrQCRJCEBPO0cmvkftq6Qr+dpwnXv8PKPJouKLYL/SycyN9a9prC2myv2AXQtBSh4JWnuJMbcyhRGmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747795643; c=relaxed/simple;
	bh=vxbtc1EDqSXR3qS6Mh7hkJsbnUOQ20m1M8ob4WnjGJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o+ki7nECy5/q1uPxfULh5/MrObKr4omOF0pd87I25+EMcWmanuaqTRhbjJTbAA1tjSuhz7nxZCQ0/y/WkHnvgs5cwx2NDqNnoPgLKW3MG/6W2RnIKRjG/NFFOWS+2VBt5ILEn+5b2qifOYL1CTONywT41YsF9BtJzB9zlrDTCNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Do81MbLt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747795640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uu12XEh7AToGw+jGxDZjXo2gU6G0yYISDzb3cxuu9wE=;
	b=Do81MbLtMMQDGYt3zqgy3JWb7oNSmtlaTzBwtGpjUtbt5NsGrcRD+8bVFVUp8AKNmeLokq
	YPLmGzI7BEXMquIf3gJgZHF6Yq08zYzUGHYDEcyBO6ak4FfUSCcKC0XbI76F+RtD7/tbXM
	w1fi50iOlw6ziWE8odhV7rEoNaFJoH0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-0d_ta3vFOqK3euW7a3t-aA-1; Tue, 20 May 2025 22:47:18 -0400
X-MC-Unique: 0d_ta3vFOqK3euW7a3t-aA-1
X-Mimecast-MFC-AGG-ID: 0d_ta3vFOqK3euW7a3t-aA_1747795637
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-742c03c0272so4702246b3a.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 19:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747795637; x=1748400437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uu12XEh7AToGw+jGxDZjXo2gU6G0yYISDzb3cxuu9wE=;
        b=mTfpOxvua82786QtmpHvG5G73/rTHiFt2tTzFd44n62kmzaba7TVUR7C6jciunhBhH
         icLUUqjmcZlaEn5eC+7YLbjxByawJ3v1GXa3kci8zylMrDLqYya7joMVT0/HADIahWEA
         qRHpaxFZ84g6LZ/LIjWEaIz4bKuf1XfNGJ1UqQbBaBDP3t2LvpOQEtWy27Ig45/wkW2K
         61xvqU/Km3Vn4XdGEgiLuZDSajv1R9yTprAPc2u/g7qdKLBX1PjFdnUmKSWxQrAOHZAS
         7S7OhlT473ZretA94fOsnNixK9CNCxM51fx6oq20lqEM4hPoOYLKxpJrZiuq4STp1bc2
         3f/g==
X-Forwarded-Encrypted: i=1; AJvYcCVF5VLn5O0mLRwZwUmaJecbi/CdTxmQwobEJWziUxN1ZDC9bnEq44lpXErin69kf34mmko=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIDEZHzcb2epC3W9z1l2McmqRKqYOpRYrjCenSI/dA8POA8zZK
	FwjZYggRdvLLxe3ulrhcBuptZ5zi4CC5KhpFo07428FfAxGuqqYl4BKvlN4KDLstW9vtMMoHHyG
	WcrOUsProPjyOPgCeA64APBEGzgVWu9Z6ZIyqrUeQG+d7jxgbC5njRw==
X-Gm-Gg: ASbGncsa7gf9vAYSt1Voxv5ToX8QE6YDwqkFIUpOJ1s/Jfq5SrO5IcdNmEZpRJe2l8C
	sFanomqkZUqEX+EgroARugHOaYEFR3AbF3XWYgoMDlmoeB5jABI7xM0haxcFyasU7fwDLDrrv+v
	IjuFSsgMRS3IFwUSutPxuBXtAzfJFS5vqfCIA6Ej1QuprZHX0VMvJgmSBq2wQ7kvyMbli8lg1N7
	lYjAcjWiHkYuyUV97TAcOdS3vT6yWbDydBOHJeRS14sEFrstVbCNISLNPKnPT9NUZAA7jrYp/37
	B8YHLIkwyyXJ
X-Received: by 2002:aa7:8e8a:0:b0:742:b3a6:db09 with SMTP id d2e1a72fcca58-742b3a6dbdbmr19583181b3a.16.1747795637093;
        Tue, 20 May 2025 19:47:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzkHF4ER+v9r//dGWI45mzF35nZdjti9WpLsYuT60Xr9ICzKlggdIDgLPRs9dM7JzLT2yOBw==
X-Received: by 2002:aa7:8e8a:0:b0:742:b3a6:db09 with SMTP id d2e1a72fcca58-742b3a6dbdbmr19583136b3a.16.1747795636622;
        Tue, 20 May 2025 19:47:16 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a970d1b2sm8941786b3a.66.2025.05.20.19.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 19:47:15 -0700 (PDT)
Message-ID: <498765f6-c20e-48f2-98e4-4134bfe150a3@redhat.com>
Date: Wed, 21 May 2025 12:46:55 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/17] KVM: Introduce the KVM capability
 KVM_CAP_GMEM_SHARED_MEM
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
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
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-16-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250513163438.3942405-16-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 5/14/25 2:34 AM, Fuad Tabba wrote:
> This patch introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> indicates that guest_memfd supports shared memory (when enabled by the
> flag). This support is limited to certain VM types, determined per
> architecture.
> 
> This patch also updates the KVM documentation with details on the new
> capability, flag, and other information about support for shared memory
> in guest_memfd.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   Documentation/virt/kvm/api.rst | 18 ++++++++++++++++++
>   include/uapi/linux/kvm.h       |  1 +
>   virt/kvm/kvm_main.c            |  4 ++++
>   3 files changed, 23 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 47c7c3f92314..86f74ce7f12a 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6390,6 +6390,24 @@ most one mapping per page, i.e. binding multiple memory regions to a single
>   guest_memfd range is not allowed (any number of memory regions can be bound to
>   a single guest_memfd file, but the bound ranges must not overlap).
>   
> +When the capability KVM_CAP_GMEM_SHARED_MEM is supported, the 'flags' field
> +supports GUEST_MEMFD_FLAG_SUPPORT_SHARED.  Setting this flag on guest_memfd
> +creation enables mmap() and faulting of guest_memfd memory to host userspace.
> +
> +When the KVM MMU performs a PFN lookup to service a guest fault and the backing
> +guest_memfd has the GUEST_MEMFD_FLAG_SUPPORT_SHARED set, then the fault will
> +always be consumed from guest_memfd, regardless of whether it is a shared or a
> +private fault.
> +
> +For these memslots, userspace_addr is checked to be the mmap()-ed view of the
> +same range specified using gmem.pgoff.  Other accesses by KVM, e.g., instruction
> +emulation, go via slot->userspace_addr.  The slot->userspace_addr field can be
> +set to 0 to skip this check, which indicates that KVM would not access memory
> +belonging to the slot via its userspace_addr.
> +

This paragraph needs to be removed if PATCH[08/17] is going to be dropped.

[PATCH v9 08/17] KVM: guest_memfd: Check that userspace_addr and fd+offset refer to same range

> +The use of GUEST_MEMFD_FLAG_SUPPORT_SHARED will not be allowed for CoCo VMs.
> +This is validated when the guest_memfd instance is bound to the VM.
> +
>   See KVM_SET_USER_MEMORY_REGION2 for additional details.
>   

[...]

Thanks,
Gavin


