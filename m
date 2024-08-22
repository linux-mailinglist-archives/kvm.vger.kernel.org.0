Return-Path: <kvm+bounces-24826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 352AB95B945
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D78D1C216E0
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 15:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07B31CB13F;
	Thu, 22 Aug 2024 15:05:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8B81CB135;
	Thu, 22 Aug 2024 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724339151; cv=none; b=BUphna/t3LRj1vVUAoGCFjVrXw80FrFaOOBUV/0pZ/PuW00eJKqfVFFjjp+ReZX2tQ9Uy0TOphMsGnEyhMbbNtee+UwGT7ADRmuIO0+1U6pJKm5nxy/dwRIDJQYSyGUWQGQck6wK35ym6e5Jfsy7NH/CT1zsAqAD5P1vgpiQbhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724339151; c=relaxed/simple;
	bh=ckZVQAPtqUDDfr2uWCswFyOrbmb4d7geYTQJBXBwm+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f+N+LGpFa/hU/JQLRsCbyULjUZcsbwoVnClmRCcHxJsyrL7SC77BTteiUpJHPPxun5LrZ5xuo7+T4TYS4M4400+zjG/7Z2iQqQYwHQX3r/OlQ3Fr+JNj6GvHrMb++iVKAE/pG2gBdnDTDjJnC3Z+kbrHYXstMhyxesyi8Lzn9VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8A22DA7;
	Thu, 22 Aug 2024 08:06:13 -0700 (PDT)
Received: from [10.57.85.214] (unknown [10.57.85.214])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEED43F58B;
	Thu, 22 Aug 2024 08:05:43 -0700 (PDT)
Message-ID: <039e21db-5705-4f1c-bf0f-35130ccbcfd4@arm.com>
Date: Thu, 22 Aug 2024 16:05:41 +0100
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
 <20240821153844.60084-19-steven.price@arm.com> <yq5aa5h52oyk.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5aa5h52oyk.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/08/2024 04:53, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v2:
>>  * realm_set_ipa_state() now provides an output parameter for the
>>    top_iap that was changed. Use this to signal the VMM with the correct
>>    range that has been transitioned.
>>  * Adapt to previous patch changes.
>> ---
>>  arch/arm64/include/asm/kvm_rme.h |   3 +
>>  arch/arm64/kvm/Makefile          |   2 +-
>>  arch/arm64/kvm/arm.c             |  19 +++-
>>  arch/arm64/kvm/rme-exit.c        | 181 +++++++++++++++++++++++++++++++
>>  arch/arm64/kvm/rme.c             |  11 ++
>>  5 files changed, 210 insertions(+), 6 deletions(-)
>>  create mode 100644 arch/arm64/kvm/rme-exit.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index c064bfb080ad..0e44b20cfa48 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -96,6 +96,9 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>>  int kvm_create_rec(struct kvm_vcpu *vcpu);
>>  void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>  
>> +int kvm_rec_enter(struct kvm_vcpu *vcpu);
>> +int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>> +
>>  void kvm_realm_unmap_range(struct kvm *kvm,
>>  			   unsigned long ipa,
>>  			   u64 size,
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 5e79e5eee88d..9f893e86cac9 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -21,7 +21,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>>  	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>>  	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>>  	 vgic/vgic-its.o vgic/vgic-debug.o \
>> -	 rme.o
>> +	 rme.o rme-exit.o
>>  
>>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>>  kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 568e9e6e5a4e..e8dabb996705 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1282,7 +1282,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  		trace_kvm_entry(*vcpu_pc(vcpu));
>>  		guest_timing_enter_irqoff();
>>  
>> -		ret = kvm_arm_vcpu_enter_exit(vcpu);
>> +		if (vcpu_is_rec(vcpu))
>> +			ret = kvm_rec_enter(vcpu);
>> +		else
>> +			ret = kvm_arm_vcpu_enter_exit(vcpu);
>>  
>>  		vcpu->mode = OUTSIDE_GUEST_MODE;
>>  		vcpu->stat.exits++;
>> @@ -1336,10 +1339,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  
>>  		local_irq_enable();
>>  
>> -		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>> -
>>  		/* Exit types that need handling before we can be preempted */
>> -		handle_exit_early(vcpu, ret);
>> +		if (!vcpu_is_rec(vcpu)) {
>> +			trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
>> +				       *vcpu_pc(vcpu));
>> +
>> +			handle_exit_early(vcpu, ret);
>> +		}
>>  
>>  		preempt_enable();
>>  
>> @@ -1362,7 +1368,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  			ret = ARM_EXCEPTION_IL;
>>  		}
>>  
>> -		ret = handle_exit(vcpu, ret);
>> +		if (vcpu_is_rec(vcpu))
>> +			ret = handle_rme_exit(vcpu, ret);
>> +		else
>> +			ret = handle_exit(vcpu, ret);
>>  	}
>>
> 
> like kvm_rec_enter, should we name this as handle_rec_exit()?

Fair enough, will rename.

Steve

> 
>  arch/arm64/include/asm/kvm_rme.h | 2 +-
>  arch/arm64/kvm/arm.c             | 2 +-
>  arch/arm64/kvm/rme-exit.c        | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index a72e06cf4ea6..cd42c19ca21d 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -102,7 +102,7 @@ int kvm_create_rec(struct kvm_vcpu *vcpu);
>  void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>  
>  int kvm_rec_enter(struct kvm_vcpu *vcpu);
> -int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_status);
> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>  
>  void kvm_realm_unmap_range(struct kvm *kvm,
>  			   unsigned long ipa,
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 05d9062470c2..1e34541d88db 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1391,7 +1391,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		}
>  
>  		if (vcpu_is_rec(vcpu))
> -			ret = handle_rme_exit(vcpu, ret);
> +			ret = handle_rec_exit(vcpu, ret);
>  		else
>  			ret = handle_exit(vcpu, ret);
>  	}
> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> index 0940575b0a14..f888cfe72dfa 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -156,7 +156,7 @@ static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
>   * proper exit to userspace.
>   */
> -int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>  {
>  	struct realm_rec *rec = &vcpu->arch.rec;
>  	u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);


