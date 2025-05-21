Return-Path: <kvm+bounces-47231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE02ABECE2
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8A04A68D6
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 07:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B202E1BD9F0;
	Wed, 21 May 2025 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQafN3Ev"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEC023024D
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747811767; cv=none; b=UgP5JknZ4+AUlA3T4tp1YxBWZns/1XFET8lUyvGW0bsA8g2/hiQT7ZxL3pekguwzFhNj2rRSNNvdEAxLk/dbMSiyah/gb5BK6lMhcEZjnBHVQ1VxJKGDDQf/ZiJF6g3QGsM0SNCpuWQn9wkMbFUwCCVPWAnUY5w1sW3j5T6w31I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747811767; c=relaxed/simple;
	bh=N91vqC9Hqi+eO1F3rNUagcwYTQ+xFmyfxxc4v4ZM04U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b11fYr+3SZWiijeELq6BbuV8X2i0pWeR1UgQQVJhkibNanVKN4so8UNQaAfodHZuuClNoooih44eelSrXrzHCmLRI5Ht89IsSKB51fz121dG4A4rDxd50ajHEY4Q5ReLvzINbhtzj3gbmHjyGW/nNWlaYIdrmZRXA2EX0VgfF0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQafN3Ev; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747811765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTzaRFPWQ7i+4l9KZqODL9pww/5z8T5OunpdIlu57pU=;
	b=DQafN3EvSPJ/RYfoxmUEBiImQWD+I/J4ebo2ou2uEQNP6rHMHipL4Q9g9Wq8DeuPew/Jic
	EJewG0g1dyvT03K6G/pZmjbqp06yrT1QDcuCX7QDyQ4e94/98AIXq01oTOcM/m0JIOJOW2
	9VgkoG/XUHIdSmVe67DNYxl45tMrxo8=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-cgMC5gdMOMO1Rk_frmW3-g-1; Wed, 21 May 2025 03:16:04 -0400
X-MC-Unique: cgMC5gdMOMO1Rk_frmW3-g-1
X-Mimecast-MFC-AGG-ID: cgMC5gdMOMO1Rk_frmW3-g_1747811763
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b26e278dd1aso3886446a12.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 00:16:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747811763; x=1748416563;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTzaRFPWQ7i+4l9KZqODL9pww/5z8T5OunpdIlu57pU=;
        b=HzuZBLQzjchbAoT5/t7YLFAoiraNiwRnmUKiIRF7R+aXEjnU6bdNvnTvLXxpL8NkOz
         /hTElgn8zh/PDACoDlYsHC/w4MTAB7jxAtMAB8BlDnuEeQr9HmqnUZk+3Anv/VuXlybm
         YpOvge8EkfndNp+ixgvCST+bNg7peR/dxq2bC7l/uChkK3jKZFUAV95fCJqZ7F7In/ts
         RjwKe4WEFbHJtu4kmTGt5n7x6HyQJYUme0HiAqFdm8KlNhs7j3175zUA588qsIalm7Wi
         JSFlxH4uoZ+dyNL6LvS4NSzCEK+uGidThNVWCt8tTuabe3m7dJhI83vrW1AiiqCE52e2
         6hUg==
X-Forwarded-Encrypted: i=1; AJvYcCU5TkJ/ZQglHZrJovhyRYXKB7MG8xO87kVsflFai1tMvfuL5Na5QRabBc81cNZL7Koee1U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5IZc2VOaLvobH2tvpQsyETd6xaG4V2gB7waL1TBPUmFaKocQq
	jkpvL3FziuY0mjYdNGkIAdMB1v1KXxMXxUCPrrcQiw0EDAUrIbxVU1rldr85XSeyB7qnu+Grolu
	GdY+04nY/UC/gAONZqGSm5JxgkopT4TxjdNpMisJMZ4gneZN4HAyvEA==
X-Gm-Gg: ASbGnctouDjGNVRhXntoTzWLk/wukzlebI//kvcKTrXORVfzBeBLO885ThcvHyb9xhJ
	jRiC26J8dIJB/Ja/Kl3o6grXcLl2T2TV4ZIP1mfZJZiKcFikK41HzofyavVUxNL7yKXbLyo3n+q
	TMmZHP8xVxI4mqU66ZG/oWVe7Pj3nY9J3pbu4t84hj8XqT0NOa6IxgA3qcdmVBMzPQu4vX2la94
	HbZenIbQTsmkF5BqWVlEu5gziNrEnpurI4KVVE8u8QhnwprGMEr6dLikVPxFsa/7pyyXYYBSKQ9
	sdGjSIhf8M3D
X-Received: by 2002:a17:903:94f:b0:220:ea90:191e with SMTP id d9443c01a7336-231d43d9ca1mr296461825ad.4.1747811763200;
        Wed, 21 May 2025 00:16:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnoK8g0q1NOZMt9xynSASmFWdt2Pi3yBk1BSUGkKrW8z0TeuRgmx1uzimzxvzt4Fm3Wu+lsA==
X-Received: by 2002:a17:903:94f:b0:220:ea90:191e with SMTP id d9443c01a7336-231d43d9ca1mr296461265ad.4.1747811762838;
        Wed, 21 May 2025 00:16:02 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ac9510sm87300165ad.8.2025.05.21.00.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 00:16:02 -0700 (PDT)
Message-ID: <0daeb046-67d0-4ca3-a0ea-16c6ba52b7cd@redhat.com>
Date: Wed, 21 May 2025 17:15:43 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 04/17] KVM: x86: Rename kvm->arch.has_private_mem to
 kvm->arch.supports_gmem
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
 <20250513163438.3942405-5-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250513163438.3942405-5-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 2:34 AM, Fuad Tabba wrote:
> The bool has_private_mem is used to indicate whether guest_memfd is
> supported. Rename it to supports_gmem to make its meaning clearer and to
> decouple memory being private from guest_memfd.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 4 ++--
>   arch/x86/kvm/mmu/mmu.c          | 2 +-
>   arch/x86/kvm/svm/svm.c          | 4 ++--
>   arch/x86/kvm/x86.c              | 3 +--
>   4 files changed, 6 insertions(+), 7 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


