Return-Path: <kvm+bounces-39854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B01A4B742
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 05:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EA34167B5A
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 04:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BC31E32C5;
	Mon,  3 Mar 2025 04:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QN8alu6p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15D01AD3E1
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 04:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740977339; cv=none; b=CN8tjibys8NJKvyU1DY7G1bCFEQ7OR1sAStsaR04a9As1PX5ry9lXjn/WzTGrjffH9BWrHv3VX/R4QC4AX0js3L0EAfKhzTyO37uuSl0/TRmU5SErZdRidbKmRmXuivoJ227IsnYPC1vMH24nOpnoYyDNcGrjkToUhLpJpWbhvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740977339; c=relaxed/simple;
	bh=zGU7A3mRvM1g91UEynHedjBx/bXUZ7w7qLMnWHvuBwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DHSUeWyKf6YCYZdHLNIcSYwv6VbyGNJ/rR3eT5K8liuGYyQsbgdjXygj/Nl1lHrm6z5fYyXqq0Vshx+4Uh6EtgO99SJ8RKx8THmzvqkqguftPQzdOwMAAUd1XWfI0mQGTHWxg0sUvi5WAQhf9JZXNGWsqfM0u7C/VPMX9NmUw70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QN8alu6p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740977335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=szUhRzEc3gD/KXfeBaNWZbbt2DelRUyv9Ye2MPiDleo=;
	b=QN8alu6pm3R3ygZWRkUmDyYI1U+xq+WnrhO3AA/6L0M0ecSxhMC0cKoYJYqWFHiL9SEV6v
	d0WGREYaalthJXnPW2r30Eq6CP1OO0a0f9USmwrk48juAlGxiJVCA0cyMNsDwzQJkiJPUd
	xZXc0D/LgsQxXPIMncO35dKijRHKpdA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-G9jvSr0WO7qK6LJkkbbODA-1; Sun, 02 Mar 2025 23:48:54 -0500
X-MC-Unique: G9jvSr0WO7qK6LJkkbbODA-1
X-Mimecast-MFC-AGG-ID: G9jvSr0WO7qK6LJkkbbODA_1740977333
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2fed0f307ccso3346131a91.0
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 20:48:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740977333; x=1741582133;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=szUhRzEc3gD/KXfeBaNWZbbt2DelRUyv9Ye2MPiDleo=;
        b=PabasLft5uhPnfOIByrKOomOUNiRNPxBllzNmF2HFbEoEjNWMzhdsjbZbx4taVHtnX
         gb3GGLCkYgT0hjF0U4EcnvezZPdhL9QcV5O6fHdn/twppzAg0GfVUuk9+Kd9bGxsPAVc
         r+cBIgxJD/VvsnSSLke0iwDlRDb/tClQKx5FU4Cb0DKaw8QtPSJ7tD7mszZ0Tci8Y20V
         /TTqhJE9VOY6wiPgnCNQhVfl8zYrnA91ab1HmbXjTya5LpJhGr73M8AccY7LVIGDnx3A
         IdElHYExSrv0PV5+6YlNtFj7hHe1Jez1PgfyM4agBAeOMt3NHQVHr9JBQIq/hyVFTEZ7
         hqXg==
X-Forwarded-Encrypted: i=1; AJvYcCWowZSj+BFQwDZR45smFT5lpF3j8Twdt+UXF6HxSx6F/XwGXlvhUhETV2Qqe6OUNxyBAlY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVMTIDUJMw/8BAqrvfcCzRt1QNcqkoGA/5q76WTi3fGw9iALeq
	B/MSFp0mXHzP/Z8vjH9EzL46+AEEfku/wEX/70PfIMzvYoW0VoeNZMAZQ8kugalzdRRWHM1jVpb
	RtfGtcm2gfU+lSGgmU7zcm2H5Iw5EXj2Ur58iM33v+D7DIBB6Ww==
X-Gm-Gg: ASbGnculMM+klwVnGhD/MoFfLmnoBMfKxcGu9jiWaR+HalS7D2UTghh7erhLTzmM3lK
	Lwi3BfxOijIIl6rp8DDWURPLcoJk8mUVh4nyTd0NbNzbsea8hObU0OS3Dv+PjZD5nqagU9NMTVr
	wl6BKPZ3fxJgk7CiwdlB7WwJ9sVtUuUhJdN05w1UxYyGwdVcwOam+DVOy9HQxSFqO9Kpywc2fIp
	91IQFreg2yg3S3HuCH8Q6hPG0OGO/+CppXfo7AVcYL+9Vz+2jesBq1hfyzgRZo21G3kh4w44sBe
	K/fMqynxap9Gye2neQ==
X-Received: by 2002:a17:90b:3e84:b0:2ee:8031:cdbc with SMTP id 98e67ed59e1d1-2febac046a6mr14181187a91.23.1740977333513;
        Sun, 02 Mar 2025 20:48:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0bFqBHp5vrV5kno/u9pdc5LbTz/krk4wxyP++znTwdfie+ZMz0iB8kF9GwoMI70Qf1wWKBg==
X-Received: by 2002:a17:90b:3e84:b0:2ee:8031:cdbc with SMTP id 98e67ed59e1d1-2febac046a6mr14181169a91.23.1740977333178;
        Sun, 02 Mar 2025 20:48:53 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235050d7c1sm68704355ad.198.2025.03.02.20.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 20:48:52 -0800 (PST)
Message-ID: <cec600f2-2ddc-4c71-9bab-0a0403132b43@redhat.com>
Date: Mon, 3 Mar 2025 14:48:44 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/45] kvm: arm64: Expose debug HW register numbers for
 Realm
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-10-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-10-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Expose VM specific Debug HW register numbers.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 24 +++++++++++++++++++++---
>   1 file changed, 21 insertions(+), 3 deletions(-)
> 

Documentation/virt/kvm/api.rst needs to be updated accordingly.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index b8fa82be251c..df6eb5e9ca96 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -78,6 +78,22 @@ bool is_kvm_arm_initialised(void)
>   	return kvm_arm_initialised;
>   }
>   
> +static u32 kvm_arm_get_num_brps(struct kvm *kvm)
> +{
> +	if (!kvm_is_realm(kvm))
> +		return get_num_brps();
> +	/* Realm guest is not debuggable. */
> +	return 0;
> +}
> +
> +static u32 kvm_arm_get_num_wrps(struct kvm *kvm)
> +{
> +	if (!kvm_is_realm(kvm))
> +		return get_num_wrps();
> +	/* Realm guest is not debuggable. */
> +	return 0;
> +}
> +

The above two comments "Realm guest is not debuggable." can be dropped since
the code is self-explanatory, and those two functions are unnecessary to be
kept in that way, for example:

	case KVM_CAP_GUEST_DEBUG_HW_BPS:
		return kvm_is_realm(kvm) ? 0 : get_num_brps();
	case KVM_CAP_GUEST_DEBUG_HW_WRPS:
		return kvm_is_realm(kvm) ? 0 : get_num_wrps();


>   int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>   {
>   	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
> @@ -323,7 +339,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>   	case KVM_CAP_ARM_NISV_TO_USER:
>   	case KVM_CAP_ARM_INJECT_EXT_DABT:
> -	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_VCPU_ATTRIBUTES:
>   	case KVM_CAP_PTP_KVM:
>   	case KVM_CAP_ARM_SYSTEM_SUSPEND:
> @@ -331,6 +346,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_COUNTER_OFFSET:
>   		r = 1;
>   		break;
> +	case KVM_CAP_SET_GUEST_DEBUG:
> +		r = !kvm_is_realm(kvm);
> +		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
>   		return KVM_GUESTDBG_VALID_MASK;
>   	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> @@ -376,10 +394,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
>   		break;
>   	case KVM_CAP_GUEST_DEBUG_HW_BPS:
> -		r = get_num_brps();
> +		r = kvm_arm_get_num_brps(kvm);
>   		break;
>   	case KVM_CAP_GUEST_DEBUG_HW_WPS:
> -		r = get_num_wrps();
> +		r = kvm_arm_get_num_wrps(kvm);
>   		break;
>   	case KVM_CAP_ARM_PMU_V3:
>   		r = kvm_arm_support_pmu_v3();

Thanks,
Gavin


