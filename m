Return-Path: <kvm+bounces-47230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F95ABECDF
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:16:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7465F3ADCE9
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 07:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8D1235368;
	Wed, 21 May 2025 07:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Muo5qskG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840321ABB9
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747811751; cv=none; b=XC2xpa0M/FDlk5gAfM9xx5PfQJE7dU3kBS27d1KYfSFrYRWijdtPOHPpOpDO52+CqMUq8TVCBxIRxgCJsjyZ8jfwlvzDGSievBb7y8yhDuLOLk+sVuRJ5JKuwlLQSFx85HSTJGg9cjNnJmQuD7rObIsp71D7k5HKtd2zG/i3yFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747811751; c=relaxed/simple;
	bh=Dhs9aqVFQO7vGhW/AbPEHotwKf42ldZ1I3nFiGVGM+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CVSl0AqQKgw017+Llv9b8r3+HdZfjukIuaVTLzBcLAau95TckS0siwsKUG4cq68/5Ptz9CBjYNN2claxrnH53s6bI7NhN5wbZkEXbDdYqkRzAqZiy+5/kTm03WaP+h9XO7RBgUGzJRE7ikiTw/5w9Eb3UPlfJk/v0k/GWEzRh4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Muo5qskG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747811747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H3eiQUkXSkK+bklax3ox1Ui1i+w4bQkjTtwkcHXejTA=;
	b=Muo5qskGZMgqBFxVerM6aZYit0Aa5Wj2DDKk4DRGnGykESLilu+BJmg0l49ywJVJo7wbWa
	Bq+IGXdDZgSTGZpW0W2c1ARZGoVGIa/AaiC1BDfnbe/dLTVE2EelzH95EOYPp8f/97/WZ5
	ObIl2Ow6hgQLmj54KjZTqhxoMqwdaCM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-gB1-qpJXOx60TCx4D_qhWA-1; Wed, 21 May 2025 03:15:44 -0400
X-MC-Unique: gB1-qpJXOx60TCx4D_qhWA-1
X-Mimecast-MFC-AGG-ID: gB1-qpJXOx60TCx4D_qhWA_1747811743
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-231e059b34dso31547595ad.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 00:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747811743; x=1748416543;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H3eiQUkXSkK+bklax3ox1Ui1i+w4bQkjTtwkcHXejTA=;
        b=g187QzWNiLc1KxI6t/y65Zg/uGcq6VCguV6W3UeUyhTBCKKpVKw1NO1DbWuJZ7EKHQ
         oQx9ic+JYzyOuxS9gIp4JAbmeSz165KMATOIa2dzd71Sq7NQBS8cLhnOpUX1iZckHnQh
         YwBaMdvgUHaNP+A/uCALaQf2FHWWSfbkdH3tHwI6+ykOz15Y6wWGPUuJPFAlkHfD4drz
         RCDAhXFbM3yA8ZWCRwu3lJouBsehLM5PMy/NcoV/aFi7jHEPOua67BrUOhtkzaepk1/m
         Za0S+pQd50P6eBDB5MFpUwEwV0tWyuu2+dymNmZ2lZ4iBIWaYYDEIHvYzluDwGcK0V3g
         MbDw==
X-Forwarded-Encrypted: i=1; AJvYcCV8E5jsuiRTknmP1voxHo0h9y4Dmc/YuakHzFEQ0lE778DcULqyPDLJ8xzDEDgmYLPQ8P8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnbJ/5i0zfiwU+DhHEWSnEXUehEM1nr5IJlu6ZCi2NzPIZu2/H
	FoZ+CqKJcrAe1T2GPNy6s/VJ/ZRUATbJqxAiGcGQwNS1kf9A+8wimSUOTRabmPaA3n4uTJz1/Sc
	OeGKWHO6YfKDS5aaetmH3kHvhhsaNYdOHA5NYRUXJ5X+6GgtZeEQZiA==
X-Gm-Gg: ASbGnct83NJrvVPgny2Tfv1ZYIWR3/cVySZ5PK+hqIwAT6tJ2LDQUumtHnDQZWvw7MI
	BoSuFSyZJGkqx5uIcRbAqkHr0M8cVEL9dn1SZg/tzqGfWHeDSFAyaJnXz7tTqQapDW0hbPySB0h
	tyrXHpoKqBICrkrjBJdZGULCuElvWbLl+hMG+S5cqObAyRcOMJaoGAKbKp91aGgwI7lw4bVtgu2
	3LUFAtQi8bfiOGEIL0+kfbfxU9Zi20svFuX6LVENoiqOAtaGB+EWCkSDYLcEXe/Ne7SFdTs5DSR
	3KXzUgknlqFD
X-Received: by 2002:a17:903:22ca:b0:22f:c530:102 with SMTP id d9443c01a7336-231de376f89mr268311235ad.31.1747811743477;
        Wed, 21 May 2025 00:15:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmbyky+/u+zNiEA4cQCcmmtH/5YoDoowrj/kDIVN48q3vqKSgBxzuL9bb5zKnIev64FChL+g==
X-Received: by 2002:a17:903:22ca:b0:22f:c530:102 with SMTP id d9443c01a7336-231de376f89mr268310945ad.31.1747811743083;
        Wed, 21 May 2025 00:15:43 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ac9510sm87300165ad.8.2025.05.21.00.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 00:15:42 -0700 (PDT)
Message-ID: <6227b34f-5f34-4f50-a762-c5cba775b5d2@redhat.com>
Date: Wed, 21 May 2025 17:15:21 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/17] KVM: Rename kvm_arch_has_private_mem() to
 kvm_arch_supports_gmem()
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
 <20250513163438.3942405-4-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250513163438.3942405-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 2:34 AM, Fuad Tabba wrote:
> The function kvm_arch_has_private_mem() is used to indicate whether
> guest_memfd is supported by the architecture, which until now implies
> that its private. To decouple guest_memfd support from whether the
> memory is private, rename this function to kvm_arch_supports_gmem().
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 8 ++++----
>   arch/x86/kvm/mmu/mmu.c          | 8 ++++----
>   include/linux/kvm_host.h        | 6 +++---
>   virt/kvm/kvm_main.c             | 6 +++---
>   4 files changed, 14 insertions(+), 14 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


