Return-Path: <kvm+bounces-56682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E94B7B41CE0
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 13:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 795AC1890E80
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 11:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C839F2F745E;
	Wed,  3 Sep 2025 11:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dzmye9V1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A42527AC2A
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 11:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756898162; cv=none; b=GlXhzdNLQrXm5UUgmlB6KX3T1wPUu8nGbMqsdEo0i3QySynkPI1t9mxS10dC2O5CP+rCOie7ZB+CyKHz+hWU49ViSfdQDdYvirzMA+rSEBqXV7mHYWURwikPchc26rbur2XiSuVlhKhm0v278O00qYnggVbFMo4S3rwdhbPbX60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756898162; c=relaxed/simple;
	bh=O5Kl27XB553N7cmeBmXq/uiaTLYFFfTmRY6zD5Qm2IA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V3BYYn2WrELS8fJObeAleo0QIY9GHPnlSP5TRXjTwdV06+tVrUnVPQiJEJ90jVdAGrpzWoAs0CGaE+/LGzUGjGJqxZxOnzn2AeYYzPm4UCsImpjiS5dRsxLlRydpqnM6j2y4BLm2VUrLeeatAqMVkUwP7MshPV9rn62vUsrcz5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dzmye9V1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756898159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kVBqAzXRtaGdVaqdIdbidkD/s0lTNKoOEws6COnY9ko=;
	b=Dzmye9V1k7E7My5fpNFB667pyP3HQl6v85ebqxuUW8Nm+fs3P0VHIJaIoQlSOZHaExEXN8
	gIpgi/QzpiHCU9tKOG/KQkiKNF6v8XeiI2vc86gioCOD+ETy7v+/P08n+7W+yheqfNz05O
	j3nsX+buf3MTj0J3i1+V33a2b7aUS40=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-dV___6t9NoKa1vAyDma-ig-1; Wed, 03 Sep 2025 07:15:55 -0400
X-MC-Unique: dV___6t9NoKa1vAyDma-ig-1
X-Mimecast-MFC-AGG-ID: dV___6t9NoKa1vAyDma-ig_1756898154
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-76e395107e2so6380011b3a.3
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 04:15:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756898154; x=1757502954;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kVBqAzXRtaGdVaqdIdbidkD/s0lTNKoOEws6COnY9ko=;
        b=L2YtOSoa8d4vMG5kPTtcV3xl8PFNf8L07sQhq0HNIxBnbn22u12GBnXyitPui835JO
         /QglkVcEVZjNVx0SCfbpq3kOEnLtIJjtPPeEjqtzxu1eMp4+pBgP/YLt0StrOtRLQFzG
         avrWJN71easvn/EU0VHwdFRBqVl6VSkI+DIBGhwznzwL68dV23p6vifkzfuaT3rP6dl+
         bRWi75kvAXNuyFSp7y6u517aA+GRDSBbvP1nhyiSACgge+9uF7l7/mm/7n/sBtl4A5Uz
         dLNHCqz2pQhNVN/+dVJuSxWw3v54YGtnIsYRa7QX1eVhQWaUtgVLy6Q1+dX2zjfjuTes
         o9AQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsGDonyiLm50mYh4S5od1URdcGf+2+4M5p2oiZdJtVOp1FfimMB+bt8WSOfrncSA9kyOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJUKaxWspSox0j9l3FwQAi/uGRSthUKhllrLiFiDz+9NDIxveb
	wpJQUJxtEC0s5WhSkRq5Ajxia2GWuhSv6SbLSNWDHsfz7fmpIPbYigAGhFqy8Vh7S5LOlBd8S++
	9OmUchxtIq0UZBaWR3aed1EwyCWRh2a2H9Vk/Aw2z0XYZyRH3TYV04A==
X-Gm-Gg: ASbGnct61rI8AkTbfpxgevIAB78NIh7mTV0vMa29Y+YRqLZWvrwcEMLq+ab26QY+qRN
	nDG+UQdu1Wu/rm+XAVUbYThWnx4RxfeKFpW0pjiPRnne7969Uy7IKMvvVKWXTWbKBwwpQ9AHfgW
	L2cvwfibdonFKZvAIsqTRwb3bgWyEvYqOHj05zGK+L9L7b808QO1TYs3Ag5E+ZBUhSXrJPEvH9H
	aIc3qAa+ZeKSjXzCQW5IqUI7oMdpgK/jIS3SzH70FKGQtxfhoix5t3Iky9ySmz/k2YDDeRAzbLS
	21LT0J5NzML02ItV2KA9CF8611yHUTeQ7AFw0ZqhiuPyQvoXELdIs4ulBeJJtj5SU0gwxqHyaea
	CPGcJ
X-Received: by 2002:a05:6a00:2d13:b0:772:2fad:ff64 with SMTP id d2e1a72fcca58-7723e257daamr16145018b3a.8.1756898154147;
        Wed, 03 Sep 2025 04:15:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEehFXhizd/XBGs6lPLajyy1rp0g+vzzGOhiFu//IuUVahDT7Y1/d6xBov7/G/ROyWBDy0Hlg==
X-Received: by 2002:a05:6a00:2d13:b0:772:2fad:ff64 with SMTP id d2e1a72fcca58-7723e257daamr16144978b3a.8.1756898153626;
        Wed, 03 Sep 2025 04:15:53 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a269e9csm16651516b3a.17.2025.09.03.04.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 04:15:52 -0700 (PDT)
Message-ID: <0481109b-769f-464b-aa72-ad6e07bdfa78@redhat.com>
Date: Wed, 3 Sep 2025 21:15:43 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/43] arm64: RME: Check for RME support at KVM init
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-6-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/25 12:55 AM, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version. A
> static key is also provided to signal that a supported RMM is available.
> 
> Functions are provided to query if a VM or VCPU is a realm (or rec)
> which currently will always return false.
> 
> Later patches make use of struct realm and the states as the ioctls
> interfaces are added to support realm and REC creation and destruction.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v8:
>   * No need to guard kvm_init_rme() behind 'in_hyp_mode'.
> Changes since v6:
>   * Improved message for an unsupported RMI ABI version.
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
>   arch/arm64/kvm/Makefile              |  2 +-
>   arch/arm64/kvm/arm.c                 |  5 +++
>   arch/arm64/kvm/rme.c                 | 56 ++++++++++++++++++++++++++++
>   7 files changed, 141 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>   create mode 100644 arch/arm64/kvm/rme.c
> 

[...]

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 888f7c7abf54..76177c56f1ef 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -40,6 +40,7 @@
>   #include <asm/kvm_nested.h>
>   #include <asm/kvm_pkvm.h>
>   #include <asm/kvm_ptrauth.h>
> +#include <asm/kvm_rme.h>
>   #include <asm/sections.h>
>   

Nit: The header file <asm/kvm_rme.h> has been included to <asm/kvm_host.h> and
<linux/kvm_host.h>, which has been included to arm.c. So this explicit inclusion
can be dropped.

>   #include <kvm/arm_hypercalls.h>
> @@ -59,6 +60,8 @@ enum kvm_wfx_trap_policy {
>   static enum kvm_wfx_trap_policy kvm_wfi_trap_policy __read_mostly = KVM_WFX_NOTRAP_SINGLE_TASK;
>   static enum kvm_wfx_trap_policy kvm_wfe_trap_policy __read_mostly = KVM_WFX_NOTRAP_SINGLE_TASK;
>   
> +DEFINE_STATIC_KEY_FALSE(kvm_rme_is_available);
> +
>   DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>   
>   DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
> @@ -2836,6 +2839,8 @@ static __init int kvm_arm_init(void)
>   
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
> +	kvm_init_rme();
> +
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>   	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>   		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> new file mode 100644
> index 000000000000..67cf2d94cb2d
> --- /dev/null
> +++ b/arch/arm64/kvm/rme.c
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/rmi_cmds.h>
> +#include <asm/virt.h>
> +
> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	unsigned short version_major, version_minor;
> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
> +						     RMI_ABI_MINOR_VERSION);
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
> +
> +	if (res.a0 != RMI_SUCCESS) {
> +		unsigned short high_version_major, high_version_minor;
> +
> +		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
> +		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
> +
> +		kvm_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
> +			version_major, version_minor,
> +			high_version_major, high_version_minor,
> +			RMI_ABI_MAJOR_VERSION,
> +			RMI_ABI_MINOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +
> +void kvm_init_rme(void)
> +{
> +	if (PAGE_SIZE != SZ_4K)
> +		/* Only 4k page size on the host is supported */
> +		return;

Nit: The comment can be moved before the check, something like below. Otherwise,
{} is needed here.

	/* Only 4kB page size is supported */
	if (PAGE_SIZE != SZ_4K)
		return;

> +
> +	if (rmi_check_version())
> +		/* Continue without realm support */
> +		return;

Nit: same as above.

> +
> +	/* Future patch will enable static branch kvm_rme_is_available */
> +}

Thanks,
Gavin


