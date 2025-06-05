Return-Path: <kvm+bounces-48512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67282ACED33
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 11:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E74907A3839
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 09:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73062212FB0;
	Thu,  5 Jun 2025 09:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RAk2DVu4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2278120B218
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 09:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749117566; cv=none; b=IT0LVRfMqgsps0AFv8OLZKquPEhhvl6TFgRtCftCoLzQSF9bW7bLfLLl/WnsvaktOVVYy4vvDJL4AdAHaa6rv69b5uHLxjcmgg/uOjMRLKk7TmmsanfNTeXEbwKdJUBp9mVltyb0tlUUu8SzaarS3pW69W0UpP54k5W+7zbH2Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749117566; c=relaxed/simple;
	bh=qWbpizDlWV+4rfjwxkDCtQHGIV13qSmCC/6p3Vf8Rmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z+RGtppKEGBauadsDRtPwZcPqrFiHG+90OwlnOTw9I08lNiiJ+ZyZEgUybDXByAiGRlnfBxUhHIjTn3dsfDbPF+bxnL4rlf2IHM4EkMbngwkb6PcS90EDUhRdwRr+A8YfS1utP3cg3XSGCfs+rm0KaOdFkpkxrWRNId8aAq+5RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RAk2DVu4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749117564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CvrMDhlWszi0keWJlBW0yQr44STIzAIf2eScUi0AOJs=;
	b=RAk2DVu4Cu3+FsIstNIQz5NxfU53XZzX76DPTeMRpRmQig91K730EbgMDI9dEfT0wS+/f+
	wy4gJmZEhLFMw63QdSkh0h91nnyYWpa7oXfmi9+YO3RvB5qi3ise390+ZTdEOAYyaukk6t
	4x4LyDydn6sNCNrGkePxwlqvvArChs8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-IDf-HFlMOTKxzXfl4ld1Vw-1; Thu, 05 Jun 2025 05:59:22 -0400
X-MC-Unique: IDf-HFlMOTKxzXfl4ld1Vw-1
X-Mimecast-MFC-AGG-ID: IDf-HFlMOTKxzXfl4ld1Vw_1749117562
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-235089528a0so16865015ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 02:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749117562; x=1749722362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CvrMDhlWszi0keWJlBW0yQr44STIzAIf2eScUi0AOJs=;
        b=LZAPfsHLocKReo2b03Yvp29xAcarHIVahpROg1Nl4RNvuZBpZNkocUXub6u9TlVlpu
         1R9Z9aaTRsSbTrIYhaS56AnCcZ1aMuoxRAKQaKtWfJGU2c/Q7GYeqehcEfqm5UtjQsBF
         4WrJUJhvmgmzptGo3nZ4UNVKAQuhax9tT6c1fravxTHmD3Ptgv0Jn2V/qbGLq81edNPL
         P041Zh1vS5BI7Si9UpFNTLoox553lHOvvCAMdt2NKnB33ReQ9geZ7yOgM/Ij3y6A08Hi
         FNqqfEgnuKnDpUeDO/uu7JvPPvVo8ta0vaCAKBfbKPCqgNJAHHERhV/jVkUACXKGZh8l
         PA0g==
X-Forwarded-Encrypted: i=1; AJvYcCUE6BNW89EbfAsn6b7nxSR8Zey7zIHbmOqjrtXPV1pK69PyZ24sgw8+1BaQVOp8ZQiQNCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAdtmXen94kgh7IoRALwfUVwcraOpMwLkUjhLHMvFoXg8wloXj
	YOkjHU858nnaBsL4mNbTL2URz/KBoPPbv365MqloL+Skhybekb46lLE5qMy8uHY5S9pILcPGTac
	/Iy5Z5ZitFQ6TsJjbvbksZFIYbo5B5xy9oI3ciTJK83zfyJCnststcQ==
X-Gm-Gg: ASbGnctDV6zfmV60IkWNU/GOF0qgcnKNAjuAxRDMrCJU/AeIC5ITFQWRGh4+NPzUibP
	IeZYpNB1JvKA1uH0WNFric9HSbH1CgU41GGt3Naphfl0+i7iBS2OQl0K+i36YlLLK8xob/xq0X7
	gcSnMg+lStSO8WnAxRgMxSFVj6c01p8+0d8GwBVya+PM3oYPWRyznX3bizVb5fNGCjbH3XThhIC
	mMGQBhaUZ0DVqjChmEwqerFg1LNHZ5mhIcu5H+1aRjS8ABy7QOtZ+kosydQSO4CF/cFZ+/rZBS9
	hBU+/two1ktg8bzD81+vDqvFbYZjuK0hYWI2c5fPpn9j8BW8BLs=
X-Received: by 2002:a17:902:d4c2:b0:215:6c5f:d142 with SMTP id d9443c01a7336-235f168bf97mr42628195ad.20.1749117561835;
        Thu, 05 Jun 2025 02:59:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9cjR2JYFAnN2N4gG1ebHDB79lgrRQXScktsAHkDD1ZcOUnhM4BJ6wXqjCQ6YZbZqsfs0/kA==
X-Received: by 2002:a17:902:d4c2:b0:215:6c5f:d142 with SMTP id d9443c01a7336-235f168bf97mr42627905ad.20.1749117561444;
        Thu, 05 Jun 2025 02:59:21 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bd8e2dsm116565275ad.56.2025.06.05.02.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 02:59:20 -0700 (PDT)
Message-ID: <0b329f63-dbb6-4652-b598-2b07bd4f5e67@redhat.com>
Date: Thu, 5 Jun 2025 19:59:00 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 15/16] KVM: Introduce the KVM capability
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
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-16-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250527180245.1413463-16-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/25 4:02 AM, Fuad Tabba wrote:
> This patch introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> indicates that guest_memfd supports shared memory (when enabled by the
> flag). This support is limited to certain VM types, determined per
> architecture.
> 
> This patch also updates the KVM documentation with details on the new
> capability, flag, and other information about support for shared memory
> in guest_memfd.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   Documentation/virt/kvm/api.rst | 9 +++++++++
>   include/uapi/linux/kvm.h       | 1 +
>   virt/kvm/kvm_main.c            | 4 ++++
>   3 files changed, 14 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


