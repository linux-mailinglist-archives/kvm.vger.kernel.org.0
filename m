Return-Path: <kvm+bounces-36816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5968A216FE
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 04:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FEB03A6EEA
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 03:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C0318C932;
	Wed, 29 Jan 2025 03:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="glfDfJHa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34780187FFA
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 03:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738123057; cv=none; b=op58jWnBhF1uN3SjLnSHpl5VZnh9dzvyoKTIjDQ25DqvlSoSMDmiieYYWSDk/DK8ChIoKAnhu5A2IbA1AJE1STNJjjSZY3Z3HLMnJziHgElmHy2hSXVmcBJVZoxWx2qLEfMYH30FVTr5GhHEtQzPtAJXqRmZ6ZBEs22Ysmx4jx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738123057; c=relaxed/simple;
	bh=w1SayiDT6fHbjeRtPtYcD6dD/o7ljGA0MzGpca4ixSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJL9L0BPymds1MghFGwdvvR0cdzkYMHTFvffJu3tVA89l5GLQzKzZQ7Vmom4qlr9fZobtT8bZ0msZLZ3pwWkq+DWokHYnda6rkkNnA8s9uHu1kQISNRZpT6jtbAVK2zmevB+4Hk0Q3VtUSaPpX+6QeDZStt3B/KIb4clxgm8590=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=glfDfJHa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738123055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zB7bwFdWnORe6bKwIQ/6vJQvYuugxQ4y04Yn/yJKnPc=;
	b=glfDfJHajjkpoKDbP3N33S3bXnJA7RdqnC1+DmMqevCoZGr6Wb2eZ/iwYppMR6D+URFx+Y
	gVTtyPluhFS3EyBMMhcs8XZ1zJJeBfDi/zLZRJedtt+PUho7NbbAdvNIT6MlvZXA5oo6wa
	uPVFW2N6QiIDeoS7vNGjvyPTclXhItk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-4ebKFl02NjCLgJmM-zh9_g-1; Tue, 28 Jan 2025 22:57:33 -0500
X-MC-Unique: 4ebKFl02NjCLgJmM-zh9_g-1
X-Mimecast-MFC-AGG-ID: 4ebKFl02NjCLgJmM-zh9_g
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2162f80040aso118730385ad.1
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 19:57:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738123052; x=1738727852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zB7bwFdWnORe6bKwIQ/6vJQvYuugxQ4y04Yn/yJKnPc=;
        b=HNUy4nebn4y0hi6In9E4AcV48SNUdev17+fIZsF1P8ug0oklSHDd6xvcB2ZrC+zEyu
         eXMscnauPbAryJEd8eSi2MStdKwZzUAGSNCyg6YqD4z4MFT+E9Fn20wL2rp9g5l9Soy/
         0DH8DPq2LiFOaq0OTZTS9ejwcIj3hQRW9rwwAHR7Z4ibuB3zNL1rduFWx2WiptIZEz1H
         7DhOE2c2TyzxUWXlIqCzL496RbSOZk4DY5Xp9tZheLGeH+loaAwEoQEnE5mikcb4jhHQ
         sEdOKlzl5Zpqjm6gxQQfxUqAKwdYIJ7c5PcTKTnpG8jYY2FOGnRBoYS3LKBbRydCVapO
         aXqg==
X-Forwarded-Encrypted: i=1; AJvYcCXRpDGuQbtE9Zti4BJI2bR1rOuygrB0z7kM/owbHGYdR5tichSsMCb9XKQzpz/dc9YTS+k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7jKI9N80nIeQ9fIOSF7vGWO4cmv2SpMaPhFMWdMerQ0A2mIoU
	IainuL/xdM7QqcoBvqzLtGu0gVjnfCY5NuFTmoSgfsC/WXIYlbdc3dEvKkiug1yndg1vIUi1SAG
	q3optLadm4KmUQ9npuD0itzrIg6LQcHBFh44syYyWYO3cWhvzyg==
X-Gm-Gg: ASbGnctzAIafpdVZryH9sl1Qy5tS2JCFET3ipagtvC14w5k/J2A7tlL55M1kyOina6w
	/HEALc0kRe3FoQEyGymgSn89zLwwBAnNrmKmSZhlFAHRmQuY7P6u+c5mBZ4yrUPUldoz3wj/DTP
	A5WkF/vXMj/YS58UzOYjXjb52f1/AkAa5tCx4yNx9otb6ILr7GDlYFVxFVPsVv5LeOcTPMKhiDY
	+WCud7hO9KQqO7P8DWjRnlHKXqAr0VeP2w/aub9EBIX/aJTp0JGmZmXlGX8uGvBYfN8bES8zXiq
	1wQQWQ==
X-Received: by 2002:a17:902:ce8f:b0:215:9d29:9724 with SMTP id d9443c01a7336-21dd7ddfdc9mr26688165ad.38.1738123052533;
        Tue, 28 Jan 2025 19:57:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdY9KvQ422zqadztWkjkXDL2LuY//Pm08gZwRPHxwWf8KuGeFvCcuuj/IQ8VEC/M+7z5zZXw==
X-Received: by 2002:a17:902:ce8f:b0:215:9d29:9724 with SMTP id d9443c01a7336-21dd7ddfdc9mr26687925ad.38.1738123052171;
        Tue, 28 Jan 2025 19:57:32 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3d9cac3sm89760675ad.38.2025.01.28.19.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 19:57:31 -0800 (PST)
Message-ID: <7271b3ff-8665-4a98-b3dd-77417f85d5e3@redhat.com>
Date: Wed, 29 Jan 2025 13:57:23 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/43] arm64: RME: Check for RME support at KVM init
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-7-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-7-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version. A
> static key is also provided to signal that a supported RMM is available.
> 
> Functions are provided to query if a VM or VCPU is a realm (or rec)
> which currently will always return false.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Reword "unsupported" message from "host supports" to "we want" to
>     clarify that 'we' are the 'host'.
> Changes since v2:
>   * Drop return value from kvm_init_rme(), it was always 0.
>   * Rely on the RMM return value to identify whether the RSI ABI is
>     compatible.
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++
>   arch/arm64/include/asm/kvm_host.h    |  4 ++
>   arch/arm64/include/asm/kvm_rme.h     | 56 ++++++++++++++++++++++++++++
>   arch/arm64/include/asm/virt.h        |  1 +
>   arch/arm64/kvm/Makefile              |  3 +-
>   arch/arm64/kvm/arm.c                 |  6 +++
>   arch/arm64/kvm/rme.c                 | 50 +++++++++++++++++++++++++
>   7 files changed, 137 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>   create mode 100644 arch/arm64/kvm/rme.c
> 

[...]

> +
> +static inline bool kvm_is_realm(struct kvm *kvm)
> +{
> +	if (static_branch_unlikely(&kvm_rme_is_available) && kvm)
> +		return kvm->arch.is_realm;
> +	return false;
> +}
> +

kvm->arch.is_realm won't be true when kvm_rme_is_available is false. It's set
in kvm_arch_init_vm() of PATCH[10]. So it's safe to be simplified as below if
the changes to kvm_arch_init_vm() is slightly modified, more details can be
found from the comments to PATCH[10]

With the changes, we don't have to check kvm_rme_is_available every time.

static inline bool kvm_is_realm(struct kvm *kvm)
{
	return (kvm && kvm->arch.is_realm);
}

Thanks,
Gavin


