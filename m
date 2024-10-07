Return-Path: <kvm+bounces-28053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5C2992910
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 12:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADD7DB23960
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 10:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33571B86E6;
	Mon,  7 Oct 2024 10:22:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEB01B78F6;
	Mon,  7 Oct 2024 10:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728296542; cv=none; b=L/8aEDPtmQT0BB8/Our4oTLsITOjZn2g4Oxh7OP/Q2V3R/qzml5+8zD1NaEtn3s7c/28NaYxdzAJOAnZ52TdL/Mp5jQactfj/YCkYLzXAVe6fHxx3QVlZvJ1WR/ftDirdbqoOTKzkxqfl+3dz25nnHhNtkKOtw98WPqxoHK32gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728296542; c=relaxed/simple;
	bh=kTc+AjP0b7abuuU4psMJVQLsuk/9Sn+RLxkMe+/u/mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ARB3SV1Yqszmixq6Jau+9QwLkhrF9CFC4qQl8d2LRjpscCljv1NPp7o4nrG8fWVlo73+4rJT1wm8aNut4z7G8zPnNcGrwG6197ipAj1HcBTA8jSPb7deyni1PHQ9zF8NN1vMTFaf3YT4YwsO+O8nQ7tN7sJvg3cTB+0dK42+PVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E2E7FEC;
	Mon,  7 Oct 2024 03:22:49 -0700 (PDT)
Received: from [10.57.78.166] (unknown [10.57.78.166])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B63263F64C;
	Mon,  7 Oct 2024 03:22:15 -0700 (PDT)
Message-ID: <3dd5059b-a42d-496b-8de3-e16012d6dafd@arm.com>
Date: Mon, 7 Oct 2024 11:22:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 19/43] KVM: arm64: Handle realm MMIO emulation
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
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-20-steven.price@arm.com> <yq5awmik5yai.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5awmik5yai.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/10/2024 05:31, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> MMIO emulation for a realm cannot be done directly with the VM's
>> registers as they are protected from the host. However, for emulatable
>> data aborts, the RMM uses GPRS[0] to provide the read/written value.
>> We can transfer this from/to the equivalent VCPU's register entry and
>> then depend on the generic MMIO handling code in KVM.
>>
>> For a MMIO read, the value is placed in the shared RecExit structure
>> during kvm_handle_mmio_return() rather than in the VCPU's register
>> entry.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> v3: Adapt to previous patch changes
>> ---
>>  arch/arm64/kvm/mmio.c     | 10 +++++++++-
>>  arch/arm64/kvm/rme-exit.c |  6 ++++++
>>  2 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>> index cd6b7b83e2c3..66a838b3776a 100644
>> --- a/arch/arm64/kvm/mmio.c
>> +++ b/arch/arm64/kvm/mmio.c
>> @@ -6,6 +6,7 @@
>>  
>>  #include <linux/kvm_host.h>
>>  #include <asm/kvm_emulate.h>
>> +#include <asm/rmi_smc.h>
>>  #include <trace/events/kvm.h>
>>  
>>  #include "trace.h"
>> @@ -90,6 +91,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>  
>>  	vcpu->mmio_needed = 0;
>>  
>> +	if (vcpu_is_rec(vcpu))
>> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_EMULATED_MMIO;
>> +
>>  	if (!kvm_vcpu_dabt_iswrite(vcpu)) {
>>  		struct kvm_run *run = vcpu->run;
>>  
>> @@ -108,7 +112,11 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>  		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
>>  			       &data);
>>  		data = vcpu_data_host_to_guest(vcpu, data, len);
>> -		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>> +
>> +		if (vcpu_is_rec(vcpu))
>> +			vcpu->arch.rec.run->enter.gprs[0] = data;
>> +		else
>> +			vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>>  	}
>>  
>>  	/*
>>
> 
> Does a kvm_incr_pc(vcpu); make sense for realm guest? Should we do

The PC is ignored when restarting realm guest, so kvm_incr_pr() is
effectively a no-op. But I guess REC_ENTER_EMULATED_MMIO is our way of
signalling to the RMM that it should skip the instruction, so your
proposed patch below makes the code slightly clearer.

Thanks,
Steve

> modified   arch/arm64/kvm/mmio.c
> @@ -91,9 +91,6 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>  
>  	vcpu->mmio_needed = 0;
>  
> -	if (vcpu_is_rec(vcpu))
> -		vcpu->arch.rec.run->enter.flags |= RMI_EMULATED_MMIO;
> -
>  	if (!kvm_vcpu_dabt_iswrite(vcpu)) {
>  		struct kvm_run *run = vcpu->run;
>  
> @@ -123,7 +120,10 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>  	 * The MMIO instruction is emulated and should not be re-executed
>  	 * in the guest.
>  	 */
> -	kvm_incr_pc(vcpu);
> +	if (vcpu_is_rec(vcpu))
> +		vcpu->arch.rec.run->enter.flags |= RMI_EMULATED_MMIO;
> +	else
> +		kvm_incr_pc(vcpu);
>  
>  	return 1;
>  }
> 
> 
> 
>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>> index e96ea308212c..1ddbff123149 100644
>> --- a/arch/arm64/kvm/rme-exit.c
>> +++ b/arch/arm64/kvm/rme-exit.c
>> @@ -25,6 +25,12 @@ static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>>  
>>  static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>>  {
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +	if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu))
>> +		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
>> +			     rec->run->exit.gprs[0]);
>> +
>>  	return kvm_handle_guest_abort(vcpu);
>>  }
>>  
>> -- 
>> 2.34.1


