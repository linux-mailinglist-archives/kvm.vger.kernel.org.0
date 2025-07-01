Return-Path: <kvm+bounces-51160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 497F7AEEEED
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 08:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B4F03B1E6D
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 06:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE0625BF16;
	Tue,  1 Jul 2025 06:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3fM6c9p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2B21F4285
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 06:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751351940; cv=none; b=V+/X9a83evVVulH0EGJ+UujhRp/c+wk/HejkKE9mnZsDiZyB0MXGzAFkRIvevG/emh4wmNkacXnwT4wKw3x9pv/WqJC7JKbMoXcoMZ91pRaNaBg4d4mtYLsHTpqP3J1FHfBEd3qmwmIwE6wsyHzYiY4MbKlF/XYkr8vOOJzbSl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751351940; c=relaxed/simple;
	bh=vdn58W0P4SV8Ws3EOrRhV/EDGwj8q19SsrDH5hQ3C3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWnYvu25E7I7wfGsATzJ8xElFsME05HvmDrBvJQkrjI5lVn2IgH1vzyWunL5aqBzUDZ80go9Lm0FDbF7OYIaUG9L5P23WdQjzu9cIVpOSm8ZJLF1wxhZQsUCmAVaC3j8SC6PoJX1kaCu56FLHuPyqV0uFmPKvIiFSQpDsNRjxrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J3fM6c9p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751351936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/N2L3Cw1UrT66uEmHGGmoTWSgiUKsnwQtuwgvg8Krxk=;
	b=J3fM6c9pIGIO/62xO58L/gejBho5qFBGgoNMPUhhpa+dS4z2i7OgEZLtVBTNKJ7qUA269m
	AX5JF5GYgHaxVnxV6X6zvNwK/Af1wJHY29Ddh9r2uJQwneEpj7gtLS9bdgkHsggg+3/+jh
	zQmIN1ZR+nizzmW1DQ5Siny5RQiYgPk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-6HnCc7XCPfeoHLqvi8jqGg-1; Tue, 01 Jul 2025 02:38:55 -0400
X-MC-Unique: 6HnCc7XCPfeoHLqvi8jqGg-1
X-Mimecast-MFC-AGG-ID: 6HnCc7XCPfeoHLqvi8jqGg_1751351935
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-315af08594fso2995175a91.2
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 23:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751351935; x=1751956735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/N2L3Cw1UrT66uEmHGGmoTWSgiUKsnwQtuwgvg8Krxk=;
        b=uVHGp9HaiBWApycjsMciEG3J9P77B9B9pzneovAqLf2/Pz+8LP+1+kpHO0DkXGrNtG
         x6GGM8nHv31ci9uU57QKcF7ZNrhZ7iZsWZF+wIWdToIV/wFFHLfAWN+ijWzopkjFgGJY
         kjI8O/RBxa9IpFVOlFTQ0bL9S2whRlBjR/+poKBwy8fhr8+mgaD8Ko/92u1NX4XZcAU3
         qW3wDRbh/Hd5GwOU+jLPgyScu497R/RB0q1GTScCaL2TiiZIqrbHOQazFCZ1R25emTf8
         9lfiks5BC8+ZBp3yv/d6P/RS3NTM6Uj2wmM6c4D8dr00+2Ibp48jIlwLgO/5mzyTbrC6
         aIXg==
X-Forwarded-Encrypted: i=1; AJvYcCXQtc1kNiHxzUGB31DGlLZHx31nvP8MTY4XP4JGp8U+zIx7cGnc1q0bddGcgQotkL8TdRo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYA/iy9chq9eAEFiqjCB65CoXm796WrGoF9Fa6/++XodVT/Jaa
	AE+tzQNU1JoZu/ODaLODlUhbnL8mYbMYZIFacqIKZnKVGsry9HwL78Suu8Y1c8M0dPbBSvEQ66k
	0aeLuTkcNUn9aBj+twMcrp/1TFn+1F9ZHGn4h0CZj503HVqTPDe8e6Q==
X-Gm-Gg: ASbGncv7QQPRA1vl7DOqFa3JsEDnOuMSHcW4Tlk+KgrAv0FFhcNmuuho8VM0/00axZG
	bqQxwZzbNu1ssbe5MVFNDD7UAwvybeur19D+Xz//ZED8563tKXKo/hReSIkjYwtskUT8Iq5bV3F
	a7lrJFUahBhqnGS1HLN0YYHZq2gDSJEwetL2dIAHetz2ugjdOYD3M18S+msI/pDjEQJJGk3aLkM
	yPW7cC6N74zcmieKDiy3rh32QcF0wf1WzT3jm0NqtyIKAWCQuMXEg2qIXgrxljkiFjavHb4SmWa
	g4PBAYTwpfWJJDIeajpI59dE2L8j/BQ+JV5ea62I5iJLQ5LM4rbEz4+yEx0kYg==
X-Received: by 2002:a17:90b:3c50:b0:312:f0d0:bc4 with SMTP id 98e67ed59e1d1-318c8ec5177mr22460851a91.5.1751351934646;
        Mon, 30 Jun 2025 23:38:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXGVdcl+epWZi9VPn55ApO38WReIopBQVp1X+PhM6QPcmIdOqHMzKdtlUHTKMJd/V5XIritA==
X-Received: by 2002:a17:90b:3c50:b0:312:f0d0:bc4 with SMTP id 98e67ed59e1d1-318c8ec5177mr22460805a91.5.1751351934113;
        Mon, 30 Jun 2025 23:38:54 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-318c1523351sm10913306a91.48.2025.06.30.23.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 23:38:53 -0700 (PDT)
Message-ID: <e33e6268-a6a5-421d-97c1-b26044e3cfa5@redhat.com>
Date: Tue, 1 Jul 2025 16:38:44 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/43] KVM: arm64: Allow passing machine type in KVM
 creation
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
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-10-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-10-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Add some documentation explaining the new machine type.
> Changes since v6:
>   * Make the check for kvm_rme_is_available more visible and report an
>     error code of -EPERM (instead of -EINVAL) to make it explicit that
>     the kernel supports RME, but the platform doesn't.
> ---
>   Documentation/virt/kvm/api.rst | 16 ++++++++++++++--
>   arch/arm64/kvm/arm.c           | 15 +++++++++++++++
>   arch/arm64/kvm/mmu.c           |  3 ---
>   include/uapi/linux/kvm.h       | 19 +++++++++++++++----
>   4 files changed, 44 insertions(+), 9 deletions(-)
> 

One nitpick below.

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 65543289f75c..0049d67fe38f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -181,8 +181,20 @@ flag KVM_VM_MIPS_VZ.
>   ARM64:
>   ^^^^^^
>   
> -On arm64, the physical address size for a VM (IPA Size limit) is limited
> -to 40bits by default. The limit can be configured if the host supports the
> +On arm64, the machine type identifier is used to encode a type and the
> +physical address size for the VM. The lower byte (bits[7-0]) encode the
> +address size and the upper bits[11-8] encode a machine type. The machine
> +types that might be available are:
> +
> + ======================   ============================================
> + KVM_VM_TYPE_ARM_NORMAL   A standard VM
> + KVM_VM_TYPE_ARM_REALM    A "Realm" VM using the Arm Confidential
> +                          Compute extensions, the VM's memory is
> +                          protected from the host.
> + ======================   ============================================
> +
> +The physical address size for a VM (IPA Size limit) is limited to 40bits
> +by default. The limit can be configured if the host supports the
>   extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
>   KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
>   identifier, where IPA_Bits is the maximum width of any physical
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8080443d24af..b3e3323573c6 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -172,6 +172,21 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	mutex_unlock(&kvm->lock);
>   #endif
>   
> +	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
> +		return -EINVAL;
> +
> +	switch (type & KVM_VM_TYPE_ARM_MASK) {
> +	case KVM_VM_TYPE_ARM_NORMAL:
> +		break;
> +	case KVM_VM_TYPE_ARM_REALM:
> +		if (!static_branch_unlikely(&kvm_rme_is_available))
> +			return -EPERM;
> +		kvm->arch.is_realm = true;
> +		break;

Here we need to explicitly set the realm's state to REALM_STATE_NONE even though
it's equal to zero, and the struct vm should have been cleared on allocation.

		WRITE_ONCE(kvm->arch.realm.state, REALM_STATE_NONE);
		kvm->arch.is_realm = true;
		break;

> +	default:
> +		return -EINVAL;
> +	}
> +
>   	kvm_init_nested(kvm);
>   
>   	ret = kvm_share_hyp(kvm, kvm + 1);

[...]

Thanks,
Gavin


