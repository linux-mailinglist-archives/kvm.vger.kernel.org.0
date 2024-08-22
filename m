Return-Path: <kvm+bounces-24827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CDC595B948
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB0051F2264F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 15:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BBA1CC8BA;
	Thu, 22 Aug 2024 15:05:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75D51CC8AB;
	Thu, 22 Aug 2024 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724339157; cv=none; b=eXYLGKr4H9hrk86Ff/ljy7Lw1No1GkOEZtC6+CwJubQxP1+BOBC3kvm9YjSa87oOP7MwPFC0kdL9W203EOLzHA2+W4EWB5GjJ6WNZRqv0DkTlDnWBLH3sLcY+D/SWzl6q3+g+xbASdtoK/YCWF1xSvTdrT5KhxPvzoVRbFVNKcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724339157; c=relaxed/simple;
	bh=s0pG1NvmsW9sQDPXQdqIhgDTrl4Tp4o+C7zN6zwtY1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EJ7NDHRsKmor7AjJ0Gdj7ow3tAfslIrWUWRN4/YI47ZdjU0CvXHMvhtrPNoHUjpeWFN4U12yzs7syZQxt2v0L1UJokpwb/Ujl6gv5EJATuwCi0/QOMfGXB+F5Y2Hms9v+9y0FZu2japzlF18SQJ5bdiGRUybBVkAHoukZnK1QwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A9A1DA7;
	Thu, 22 Aug 2024 08:06:21 -0700 (PDT)
Received: from [10.57.85.214] (unknown [10.57.85.214])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7774D3F58B;
	Thu, 22 Aug 2024 08:05:51 -0700 (PDT)
Message-ID: <7bbd5f46-de70-4158-a790-d2aa90d32929@arm.com>
Date: Thu, 22 Aug 2024 16:05:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/43] arm64: RME: Handle realm enter/exit
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
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
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-19-steven.price@arm.com> <yq5a5xrt2oov.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5a5xrt2oov.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/08/2024 04:58, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> +	/* Exit to VMM to complete the change */
>> +	kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
>> +				      ripas == 1);
>> +
> 
> 
> s/1/RMI_RAM ?

Ah, good spot - I must have missed that when I added the definitions.

> May be we can make it an enum like rsi_ripas

I guess that makes sense - I tend to avoid enums where the value is
controlled by something external, but here it makes some sense.

Thanks,

Steve

> modified   arch/arm64/include/asm/rmi_smc.h
> @@ -62,9 +62,11 @@
>  #define RMI_ERROR_REC		3
>  #define RMI_ERROR_RTT		4
>  
> -#define RMI_EMPTY		0
> -#define RMI_RAM			1
> -#define RMI_DESTROYED		2
> +enum rmi_ripas {
> +	RMI_EMPTY,
> +	RMI_RAM,
> +	RMI_DESTROYED,
> +};
>  
>  #define RMI_NO_MEASURE_CONTENT	0
>  #define RMI_MEASURE_CONTENT	1
> modified   arch/arm64/kvm/rme-exit.c
> @@ -112,7 +112,7 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>  
>  	/* Exit to VMM to complete the change */
>  	kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
> -				      ripas == 1);
> +				      ripas == RMI_RAM);
>  
>  	return 0;
>  }


