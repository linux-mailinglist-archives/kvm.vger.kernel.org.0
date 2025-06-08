Return-Path: <kvm+bounces-48704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE23AD15EF
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 01:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CAA716721E
	for <lists+kvm@lfdr.de>; Sun,  8 Jun 2025 23:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF62265626;
	Sun,  8 Jun 2025 23:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c578wH71"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143D9186284
	for <kvm@vger.kernel.org>; Sun,  8 Jun 2025 23:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426222; cv=none; b=UPE9UeRbjKTbav7zPY2r+9bctxL8KvhHZaV8BLwmoAQcvmrNNlVZToo2EhcrKcTegxekKqi+/NCWbps8uwzoebYKO5QNaritHSYO0YdZhc+41ksLzd0oKKxVWzezliDHi4W0WJh8MSicRwfEkxOREK35oRFWSUCD//tawUtSLUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426222; c=relaxed/simple;
	bh=eognrAOK5phWj4syA8utC5cWw/hE0DYWnC/1UPPwauM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i12K17nmUB4eCJBTgDag5YmCGUu0rHjbo3wYokrYs8NMTpHvHCG8mqmIBLeFjUtUtoHdMYBr65ss6J62lnFvyQlm1ZDrxVmyuKcKrKIldK1ZQqLYaNV9bEqVf3noGxaz9cKgrG6wnokSKL2aAYVRvFC1R2C3fKwSWZzcK6/xDtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c578wH71; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749426220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZTYuUEgwsSSH/seLrjyp4437G/xo/ld4sW2rsZ41WE=;
	b=c578wH714mMst6NHg3Yzuw2HiA5ljPKh1kuvi5tGLeglQum1+FxhioCvwBEPOQx0Yscgwq
	/uvQbviAuBUCO8uIV/4FBORbu6z7VS5evpBeKJhSKual8tKoz1mBeO/PLJtsHroWubMtbD
	olmeyRoRCV6efz4SRQOx+gL0yPuaKmM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-UNHapJhlNn2xYYdA-bU_Dg-1; Sun, 08 Jun 2025 19:43:39 -0400
X-MC-Unique: UNHapJhlNn2xYYdA-bU_Dg-1
X-Mimecast-MFC-AGG-ID: UNHapJhlNn2xYYdA-bU_Dg_1749426218
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-74620e98ec8so3315414b3a.1
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 16:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749426218; x=1750031018;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DZTYuUEgwsSSH/seLrjyp4437G/xo/ld4sW2rsZ41WE=;
        b=HQzTRjrrArAyXx/VqDetvlEwMxATuKOOSPFMoSE6Eo3WUOegKhYFCCKXSnj0M1VRmU
         Yv75KmTfD9O7eum4fcopUjMwKL24HNl1HK8m9q8q1Xb4Utf3ivg4XYG14C357FfHIoxQ
         AaahoVYC+F/4hoDspMFDcQ3Ihad1tuJPNrhi0mT8tvU6AvqpcDB6/UJ8oyOhE3a+pYU1
         +4qdGEXFBIzpNHNlZv44ZRpuwpSm8caesapLy9JMfsKsIQ1h8/S/OBBLJesr0DQ2ewia
         wLXb1DrRzgjavE81gVhIaVqZmfcnEg3re4HiCzTRCf9v23W3UZ5SkAo4s1yrSXIqRCh1
         SSSA==
X-Forwarded-Encrypted: i=1; AJvYcCW+tTIF15x/63xrZBiseTvavcKmD6URmTg4cataISG+dXdb71Fm+IrnwXL9nBvbYeYg6lA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2bnptqaU4simHU4RW6lUwCzsMpxDHSxUF8NNIkRGsRscwF03l
	PjFb9mZ1WU37aWw0YrxRuj9p6qCDZYtW9K98mxCvTf5v+AdZ05/ad+WFi/OnarJCFieZUMPy8PO
	qiCglQGyvSgLaPPDo9TPnI4qMMRXtxiAlvSSAn+rkvZRTNj3UL4ptBg==
X-Gm-Gg: ASbGncvXtp2oiYCMHdIFD3UggW9pY7UHdNofYqkEABPWSPQk33ti9SR2YmdQLJISzq3
	l3iCBxL4Z5GxVm1gCUGyQdFi7HXlBVa9QxZ41YCCu2xVlSNXnH15dMkYom2yYnoS39XXNc86vvF
	8L5S1fYGBhes9HFsoprNPIRfZK7Ardc/kEKJOLjDmnauRZ6QwOUqPKchdDceyJMr8kgFje2ma4x
	B/v1CncUa+8cu7f12W+q/G+cJX6PF2s7sblfO/CMz+YaGm1kC2KmsabnUHHjVgKDK4aEW0XCVKi
	C30Mk9tSN4C+GpvRhbk5iFl4SyoR1oC2qfqwVhfjClO+BdxmmJxvAlNqDYo29A==
X-Received: by 2002:a05:6a00:94a0:b0:746:2217:5863 with SMTP id d2e1a72fcca58-74839af6c88mr7041906b3a.6.1749426217843;
        Sun, 08 Jun 2025 16:43:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMrZVN3nL20lU8KRAFANwYTY3wAoHW2KVfIcHNcKcpCW87hvtDrgtI8DfNiEq6ldydFzu9YQ==
X-Received: by 2002:a05:6a00:94a0:b0:746:2217:5863 with SMTP id d2e1a72fcca58-74839af6c88mr7041844b3a.6.1749426217481;
        Sun, 08 Jun 2025 16:43:37 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af7b2aesm4695870b3a.61.2025.06.08.16.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 16:43:36 -0700 (PDT)
Message-ID: <ab9f3307-893e-461c-aa1f-54edc032e11b@redhat.com>
Date: Mon, 9 Jun 2025 09:43:15 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 17/18] KVM: selftests: Don't use hardcoded page sizes
 in guest_memfd test
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
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-18-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-18-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> Using hardcoded page size values could cause the test to fail on systems
> that have larger pages, e.g., arm64 with 64kB pages. Use getpagesize()
> instead.
> 
> Also, build the guest_memfd selftest for arm64.
> 
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   tools/testing/selftests/kvm/Makefile.kvm       |  1 +
>   tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


