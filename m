Return-Path: <kvm+bounces-34363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C93289FBFDD
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 17:01:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C119165D4F
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 16:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C60A51D63DE;
	Tue, 24 Dec 2024 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtRZJj6r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072141B0F1E
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735056075; cv=none; b=tuiBScS3Q2KcjlxnPqgFqmKWg52Iun3DMqWaA0SC3C/nVz+vs2Yr7gvvduPj67rlva+dMgtInBgZrWz1U5xO3y1BnRQ+Pfff9Fj+qiEVQ9Bi8fYVix5NIMGRRfiwZU56tNxcgzSYuuYRD/RJLkyvRJgUkAsmlKAoVUZZW+ZuokU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735056075; c=relaxed/simple;
	bh=2uOcXTp7pHWaq/BEnjbF8VjooiBCvkYCL6DCeEMyMI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRkE0efx1LH/ibBhLbenyztRk/jC5KYYx6GeQfJnUIku27DIwBb+ssgZckI1molL41Q3ekp6Qo3qyAdJnI3RgUxTAKykRNd9+C9901seKSzoh1CNxX8opD/gkbCCVMn5AndRn357NCqM5TowCOTFUfBgdszHXW5+lTKIyGQ7kFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gtRZJj6r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735056071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i/ex+YEgFBQKbbutLwCLbMm2eOqg4ZA3JWMufpN6EJw=;
	b=gtRZJj6rKj5tw4nIVRAT4fKRdjdAXDts7v1tpfwjs+ndQm9LXF9T5eASF1Kwdt6ivlbrX9
	itmdrYaIbmzb09mbFTmxwhUkBNH5BZpECtvwe4XaodWl4BlxK/yFcEP9B95xYMlV5z2r+X
	JjVwb6FEvKi3LmOU0DXuWu9rAlukLzM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-dm5E6yFnMzGwM3B7dPPMng-1; Tue, 24 Dec 2024 11:01:10 -0500
X-MC-Unique: dm5E6yFnMzGwM3B7dPPMng-1
X-Mimecast-MFC-AGG-ID: dm5E6yFnMzGwM3B7dPPMng
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385d6ee042eso2764127f8f.0
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 08:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735056069; x=1735660869;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i/ex+YEgFBQKbbutLwCLbMm2eOqg4ZA3JWMufpN6EJw=;
        b=KPIz5PdfDi/02XSEGsFf0VUq5ojPTTStqvwCZ4q1TC6eQvVAh3WljRnx59gnmoDgTc
         7goMkR2CIJYTq2/zgCL48dZdXzSOkREJw5BUkx1WFm7oYcDugSsEY3uQfrvFDJcTgL8U
         9hB67pBj0gRKmd9fGZldqnFygkMJvR4AgFE6+Ns7eeKCEMoYoRY0dar3+5wrLcqDodc0
         J1EDsUejg8PBOXk7r4iyokx7XouVQbHV50UfqzwBX9LqLwgC+YbRYbBaTTcL+YPVP/Qf
         3FVDwjk+mcFI1i4cVV/3qOq3MDWCzeAjJF5M4j5GAepBN6EQKqmzpP5qxRoapdFq4kbC
         OGuA==
X-Forwarded-Encrypted: i=1; AJvYcCW2XUkq6Bjpss9TLJJ2yLU/HrL5J6GNEZnm4xsfzPnB/xGHwluzvFAG4TtcnnMCXW6hgyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVT8VWHw/sUYGHiaO+8ukGBPD2QMhiCyLRHHroBoTZy9w4UTEt
	HN6idZ0faJXqjCT+Et1qWYzNRIA/fL+Xe9zezKd7lC5W5ONHDyngA0Fip+4p0PU7HEKkED+ywGr
	5uIMueYnw2p/Ho6Z391SHs+qaAOxi+1K3LxlMglSlmiDCL7xzzQ==
X-Gm-Gg: ASbGncvgoRyMgMohTYPUEuX6eE0Wq5JEF4yRSho0vmoVts7iDkLtu92z1pH7eqh0Olh
	89sPJ2TOQizodZx071dvUJH2rEQTONJ0WE2bdtkAGffGGGiGHTeTmojCv1Syuh+ooIwRG3fHzDI
	+YH2Ie2LVLp0BYQq6Zq3rgcL8v9PhULP1Y9ND5Ec/aSVrqZL9wduLd9TtjftH5L+uWUjbu0XVfE
	HwK9ic65uUTEkWdTSODyBaR5x10bY2BiG3yYYPyZtwe/EJfmpDgj42HrpN2
X-Received: by 2002:a05:6000:154f:b0:382:3efc:c6d8 with SMTP id ffacd0b85a97d-38a221ed2fdmr13709804f8f.12.1735056068832;
        Tue, 24 Dec 2024 08:01:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlVVigMON3+v7GZf0Wd8e9A4bsNkgxk/ClDcoTANwHbuOSynV5cwu4x+Ht3c++w6w0CeHixQ==
X-Received: by 2002:a05:6000:154f:b0:382:3efc:c6d8 with SMTP id ffacd0b85a97d-38a221ed2fdmr13709747f8f.12.1735056068308;
        Tue, 24 Dec 2024 08:01:08 -0800 (PST)
Received: from [192.168.10.27] ([151.62.105.73])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c847513sm14570673f8f.49.2024.12.24.08.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 08:01:07 -0800 (PST)
Message-ID: <9bb6ea4b-dd40-446d-887d-4878d180c2a5@redhat.com>
Date: Tue, 24 Dec 2024 17:01:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/11] i386: miscellaneous cleanup
To: Zhao Liu <zhao1.liu@intel.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241106030728.553238-1-zhao1.liu@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 04:07, Zhao Liu wrote:
> Hi Paolo and all,
> 
> Is it necessary to include the first patch (AVX10 cleanup/fix) in v9.2?
> 
> Others are for v10.0.
> 
> Compared with v4 [1],
>   * patch 1 (AVX10 fix) and patch 9 (RAPL cleanup) are newly added.
>   * rebased on commit 9a7b0a8618b1 ("Merge tag 'pull-aspeed-20241104' of
>     https://github.com/legoater/qemu into staging").

Removed patches 5 and 11, fixed patch 4 to include CPUID_KVM_CLOCK2, and 
queued - thanks!

Paolo

> 
> Background and Introduction
> ===========================
> 
> This series picks cleanup from my previous kvmclock [2] (as other
> renaming attempts were temporarily put on hold).
> 
> In addition, this series also include the cleanup on a historically
> workaround, recent comment of coco interface [3] and error handling
> corner cases in kvm_arch_init().
> 
> Avoiding the fragmentation of these misc cleanups, I consolidated them
> all in one series and was able to tackle them in one go!
> 
> [1]: https://lore.kernel.org/qemu-devel/20240716161015.263031-1-zhao1.liu@intel.com/
> [2]: https://lore.kernel.org/qemu-devel/20240329101954.3954987-1-zhao1.liu@linux.intel.com/
> [3]: https://lore.kernel.org/qemu-devel/2815f0f1-9e20-4985-849c-d74c6cdc94ae@intel.com/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (11):
>    i386/cpu: Mark avx10_version filtered when prefix is NULL
>    target/i386/kvm: Add feature bit definitions for KVM CPUID
>    target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
>      MSR_KVM_SYSTEM_TIME definitions
>    target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
>    target/i386/kvm: Save/load MSRs of kvmclock2
>      (KVM_FEATURE_CLOCKSOURCE2)
>    target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
>    target/i386/confidential-guest: Fix comment of
>      x86_confidential_guest_kvm_type()
>    target/i386/kvm: Clean up return values of MSR filter related
>      functions
>    target/i386/kvm: Return -1 when kvm_msr_energy_thread_init() fails
>    target/i386/kvm: Clean up error handling in kvm_arch_init()
>    target/i386/kvm: Replace ARRAY_SIZE(msr_handlers) with
>      KVM_MSR_FILTER_MAX_RANGES
> 
>   hw/i386/kvm/clock.c              |   5 +-
>   target/i386/confidential-guest.h |   2 +-
>   target/i386/cpu.c                |   6 +-
>   target/i386/cpu.h                |  25 ++++
>   target/i386/kvm/kvm.c            | 211 +++++++++++++++++--------------
>   5 files changed, 145 insertions(+), 104 deletions(-)
> 


