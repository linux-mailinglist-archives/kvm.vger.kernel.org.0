Return-Path: <kvm+bounces-39964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D961AA4D2E1
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:15:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BA3C7A24E8
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2541F3FE8;
	Tue,  4 Mar 2025 05:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X+quAv34"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9289149C7D
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 05:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741065345; cv=none; b=H0ravGBZSFp2vd4GuKRYZ8IC8nbX6V80+dVlOb8NeeR62XGPGc3GghjxxRZ0AsjlXVLxh8ZsshG5BtHaXTx5fpMOiU8ORyi+4mQkDz75hDBfqJCfrEaLo8fHveHgO0MAVhtUHjHhecNgkn33SiNH6UKfFbIyuoybfQyMje0hsCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741065345; c=relaxed/simple;
	bh=I70BjEXqWMzdLTvepT7oYU6oxEIcfIfhUlrieGGjjJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E36zmNP4K2ugHJEV8ewUkBgwYHv8gqidJL4ocNLT1fhkoPP3bkjiD4j61CuyaKyjc688QHG44Xpwo1LMXlR/Xd2gYzmbtGTsSF/Zbtrv44MlEzr0TqnOilQWaXZShY76kewMEcYNHxI3/Tx5g+gKpGaH9CFFMk5Q4eEghyJc4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X+quAv34; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741065342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHp7c8083IblnSkSElkO4q8Pyi74C3j+q7Rd++XFOzQ=;
	b=X+quAv34a7mtlrbHZv7MMfNNl7HR2RHTHpykDEkkz0S3LLiWNLCD9xolMZDK1P2FSbmma0
	IvVH5w8px6kNM6NongRsRhEWz23nHhIEKpOm4Zjm99gtYAONr2bH2NW5nHHCyvNeIqQvpp
	MR9s4l1TSM4pVAcKU6ac1pjMhhVkTPg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-dedTFw0YO6qduqz8VOGm4w-1; Tue, 04 Mar 2025 00:15:40 -0500
X-MC-Unique: dedTFw0YO6qduqz8VOGm4w-1
X-Mimecast-MFC-AGG-ID: dedTFw0YO6qduqz8VOGm4w_1741065339
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-22366bcf24bso73110875ad.1
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 21:15:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741065339; x=1741670139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iHp7c8083IblnSkSElkO4q8Pyi74C3j+q7Rd++XFOzQ=;
        b=OmIsYO53SsnBDQZ2grclY+l/zryzB9jDZd6woZLCkBfdWxgOgVxhmEohYRUlMLXgEf
         6V9YbI1UwLRwjmRH7qNNkFPrUkGxqT7/VLY3O6GUCOrrbzkjeOKB+mxitbkNCMTG8T2l
         1T8WiHDLqrjf/RmfNvP68WaK1MEMTwvE7VVhR65tgipDE165TwhnhO3a12To0tIDlS2C
         zBWR8UWrGOTcUFMYqOQ4d3EXTHwvobOvE3yJvonLs8yRhLgh/7xzdtw4gxoXdsXSPnFO
         gBxJd4Y6MgehwDYvHf0SRRKIImZUx/lUfrJbDERjDVQCRNxvKVvzExVKQ0PTpMZ6X0Lt
         bzdA==
X-Forwarded-Encrypted: i=1; AJvYcCW0lkBSotVantoOV65IW8V5HuZtXZmWq2ePptfvZp3d1mhkx2pJAprwQI7OZSuevgSoacY=@vger.kernel.org
X-Gm-Message-State: AOJu0YynWvagxJ2VxTxMAHoHrccSbU0HnhAtBK4WFPkgnRsIxixZEyEO
	fbWUzc+O2R4nLbola0k4ElLUFJpIj8daFcsV/97eq+4pCxDWnXK3SwtaSAO9R/OWW5MwnhW79Q7
	//e4g/+Mjk+rdy1HTWqRAQzHhfLwLaDZGee9anckVPmI+PjrWfw==
X-Gm-Gg: ASbGncvEzrwCbAtyf/gjOEKMj1EihP3aZ0l2YT7HS5k/Q/hjwedu8sg6D64+ccOnCIx
	o5XUio/K8zA6FvpRded4wChBNtvRhn3SbelTqZKkJsRZmtENx+BCX9ucgsWOI3AcPC81UZTSwZI
	Zv2xV0GvrhL+/e5n6/bgoxLfY5xhonNUHGz5gBBJuk5CLn0rSuoyOJ2hE4vHOoU0s2UmdnNUrhG
	YjiM41o5cSUxcOqx2ck/JbKvAOCaXBfLPrGleWG6kDeeI9u1CK1EAr3x7HV9kefj+WfphamsOHG
	Dhnua8sU4sRpWh5jjg==
X-Received: by 2002:a17:903:244d:b0:215:9470:7e82 with SMTP id d9443c01a7336-22368f71b7amr213249575ad.4.1741065339586;
        Mon, 03 Mar 2025 21:15:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwYeNz4BZ5M1mONF0+zOWTYRV5h3Fu8fVqk+GofZ0hdvm3v9bSMtAm5K07jzNGKbCercWDMg==
X-Received: by 2002:a17:903:244d:b0:215:9470:7e82 with SMTP id d9443c01a7336-22368f71b7amr213249125ad.4.1741065339283;
        Mon, 03 Mar 2025 21:15:39 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fe825a99a7sm13451855a91.6.2025.03.03.21.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:15:38 -0800 (PST)
Message-ID: <eb8ea5a0-fe6c-4b96-92da-f9ec0355b4dd@redhat.com>
Date: Tue, 4 Mar 2025 15:15:31 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 22/45] KVM: arm64: Handle realm VCPU load
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-23-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-23-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> When loading a realm VCPU much of the work is handled by the RMM so only
> some of the actions are required. Rearrange kvm_arch_vcpu_load()
> slightly so we can bail out early for a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 

One nitpick below:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 49ad633c5ca5..3e13e3d87ed9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -633,10 +633,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	kvm_vgic_load(vcpu);
>   	kvm_timer_vcpu_load(vcpu);
>   	kvm_vcpu_load_debug(vcpu);
> -	if (has_vhe())
> -		kvm_vcpu_load_vhe(vcpu);
> -	kvm_arch_vcpu_load_fp(vcpu);
> -	kvm_vcpu_pmu_restore_guest(vcpu);
>   	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>   		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>   
> @@ -659,6 +655,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs,
>   			     &vcpu->arch.vgic_cpu.vgic_v3);
>   	}

A spare line is needed here.

> +	/* No additional state needs to be loaded on Realmed VMs */
> +	if (vcpu_is_rec(vcpu))
> +		return;
> +
> +	if (has_vhe())
> +		kvm_vcpu_load_vhe(vcpu);
> +	kvm_arch_vcpu_load_fp(vcpu);
> +	kvm_vcpu_pmu_restore_guest(vcpu);
>   
>   	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
>   		vcpu_set_on_unsupported_cpu(vcpu);

Thanks,
Gavin


