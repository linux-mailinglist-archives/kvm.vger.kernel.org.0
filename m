Return-Path: <kvm+bounces-47241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7AF8ABED89
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F2E21885CBA
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91F5231A23;
	Wed, 21 May 2025 08:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BsR2TTBF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F9F21ABB9
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747814799; cv=none; b=pE+ZSAtkmKoT/UtwxLuxFvcmF8FCzyil0c0zo+0JozzJD/fHxKgi+y6BidKCQWf2btT9UzWc2Qr9gy7OA/jQnI9GLc/WKsiLZZ2ez+CKmGxEmThr1633qmovpVeIQJJ07nE7Ork4FIz2ZlCIXsH1gUQi2Wst1CMWHFSLU9wxZjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747814799; c=relaxed/simple;
	bh=hu5J5+XNwkFM46bDV/QJbe0xO8P/PgzDuswn9qkh5Ts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P2uMIlB98/qLSeU7hp9gCWjCinf32ts427CbqcOm3Y9y2gHRid0llStzcSEnVIeH4Ka67uJjXhL1nR8Qp1jT7uQRqW6V055tgBLeup+2L03SSOkJyaAS3ClVD6UZmri+PtfIp+ITCE4QhVbqC+BSh4Bo8Vp2FNVQYyPLFitE95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BsR2TTBF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747814796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Pl7X3KWgj8hu+DkvB4tuUaoMulhn6+3Nc2gMnNYzx+8=;
	b=BsR2TTBFUtE60nqsmQmiNTDTEx0FZgd0pimZZcV2ZSNZ50FJY0Kz19Dhp5romFvVqEKRbi
	uklg3chhpAFg4lzT66HvTbktqmRCY8leo7jYap64xJq3aIsAY0+4vvZ+WgYJzjsgBGT2Sh
	0oKtMm1MIYNusXWlW49tD6qhDe9tst4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-D2jSXL4JOP2eZ2t_0G72dQ-1; Wed, 21 May 2025 04:06:34 -0400
X-MC-Unique: D2jSXL4JOP2eZ2t_0G72dQ-1
X-Mimecast-MFC-AGG-ID: D2jSXL4JOP2eZ2t_0G72dQ_1747814793
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a375938404so1804435f8f.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 01:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747814793; x=1748419593;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pl7X3KWgj8hu+DkvB4tuUaoMulhn6+3Nc2gMnNYzx+8=;
        b=n97OLuNxwlhvM8a9dLmwBVSe7kb3Q4UGAeWSlaIwNoAM9Fdh5/nMYoSBJ1KheHL+y5
         +AgueTc3A/4NB6sNM9qLuZDce2RJkhioTNgvvmUo+7eDTATvJdgyGWcYW9G67sopITQF
         FjcRnnbifwuUoM+CPmzTcL5rpNUS+Co8q9aGmRWnhfzqevizOzGj1YNgYxi+oCmsfBYA
         hdwGB059fKUexSBllaytYgIlgzEkraHnGgQKv3Kp/7nO372zGW68izfgOjNMCr8kvRAX
         1RQzcayFyJAWlA/K3kwLxi6AyjSdcfgNlAhTkhItFjgS56zRa9yVw5/IBOi9aRUN8eNx
         iSYw==
X-Forwarded-Encrypted: i=1; AJvYcCX+lxDs4glEQhAKGhW0bNyPvS6opW6HV07nj4J4w/jAfPEsThBBRCE5hlERRsO6dFrq53M=@vger.kernel.org
X-Gm-Message-State: AOJu0YylS/YuZNSpvgLZZbhpLlcucugCaoQ7qZ+4LcadSevp/PDSDuP9
	V89tf9RGWSYQ5abqSJHwR8jaiNAM9LbdMqpuGcZ4tpsNW1f2Y+ejpXTL47Q5lsFY6ILn7K/v7Y/
	kYyIbymBFl5ppEr7D8tM2svuYtmlfYGA10jUYTslQwMh86ic73xARRQ==
X-Gm-Gg: ASbGncuCheDp1WSKSuVaLDWaW8nm7qqj6EkIhQUf8beQzpXBmehgh1t65MAr2fNMaSv
	xdeXPW1id4g5MeXdgPRx6OvYp5OK7kEFHllE4b8TOWw2DW2dZzFWyMQ7KrGmYRg+UWmMZ0soubb
	hMnrKfwegyzkk3yizgype9LnoLXidTCJs8iK0x6ZKS58k/XmX42KCjJaq4u1XnSNCPNeIGrxzFJ
	+2jm99kd48fyJrsog1T54VQYRaEjvSn4YNcwvawFrSrsMAAvL59fDy6Nat0l1znFCk3snHopVlb
	xcFo90etNvYMinML/PqzJRiE7AZEZLJcNbTtDXAz4G8/yEuFe5vpYXzoJWwh9JLjSmMhDk0On9t
	fzE70ZjZvuKCPoi6BrZC38hnGWAqIIB9QRwy60NM=
X-Received: by 2002:a05:6000:1862:b0:3a1:f69f:3341 with SMTP id ffacd0b85a97d-3a35fe929c0mr15864058f8f.26.1747814793126;
        Wed, 21 May 2025 01:06:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2+lWrYBGOo14ifcWRyyjzJy38hgRyoVZoquUV7/QFhSo5OfjVjWu5BI4SWaanzIFbUmG0cQ==
X-Received: by 2002:a05:6000:1862:b0:3a1:f69f:3341 with SMTP id ffacd0b85a97d-3a35fe929c0mr15863983f8f.26.1747814792589;
        Wed, 21 May 2025 01:06:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca888afsm19250604f8f.64.2025.05.21.01.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 01:06:32 -0700 (PDT)
Message-ID: <338c5df3-c7c7-4b44-8e09-09ee77563ff2@redhat.com>
Date: Wed, 21 May 2025 10:06:29 +0200
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
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-16-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250513163438.3942405-16-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.05.25 18:34, Fuad Tabba wrote:
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
> +The use of GUEST_MEMFD_FLAG_SUPPORT_SHARED will not be allowed for CoCo VMs.
> +This is validated when the guest_memfd instance is bound to the VM.
> +
>   See KVM_SET_USER_MEMORY_REGION2 for additional details.

With Gavin's comment addressed

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


