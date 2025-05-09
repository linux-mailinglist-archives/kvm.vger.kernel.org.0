Return-Path: <kvm+bounces-46098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2FEAB2002
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 00:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9940D521235
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 22:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DFB2638A2;
	Fri,  9 May 2025 22:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U2uaZT8u"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD5425F79A
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 22:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746830358; cv=none; b=txzqrI2WFhTxa7mApg7OWDhYJ/3zkzYTTkh6zIAaGsBBTFNps5sCi1/BaHaf0L4FtCcE+J5EuapdY6Uf5dJOxnFbWOk22RpJhl6XHRLgwrMceXCvtFeU/xj6k5B8VUPMs0DfCXZqn1kMWSI5ALiDEtWS8QuEzjWOJe622IxLIn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746830358; c=relaxed/simple;
	bh=+z+zW6ppVO139LjzB2cgUDHUv7xx1x/Ibblmf1wA+hI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j7/+vzAeR2ALWp3k3Bnsut/T38n0b5AuoSR2FgcNXp3jaJy403Dhdy5hrC8TsuHPWOWCJTML2DsPHtBRdQGocF8EFCt/gf+bQ9vH3zhL1GZXjG0MDVl7h7UqxFMKcvLW5BAhwZCZGlQr+XAmCM/jarM8zaLi6FCV1ufn43NF4u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U2uaZT8u; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <1da6648a-251b-456b-9ddd-a7ffa95a5125@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746830344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jsqNWeffoeI2a1Nha5CVjiw3khettMZ8t2Y5EabwFrE=;
	b=U2uaZT8uuKGxqCUflSnTSX7zhox5JAB0nlgVO4PX9893DQ3vSWCMm1P8LhI2UeKkeH49Mo
	IUzRFWP2cKwA1wLuc62ymb3HcegdNRpKpxlMHtPh+4CIbCBzqKuS6dc3jo2Jwd7nz0ILcI
	CwOkbRM9NDzpt81bdlAaJYYPfF/NhlI=
Date: Fri, 9 May 2025 15:38:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] RISC-V: KVM: Enable envcfg and sstateen bits lazily
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv <linux-riscv-bounces@lists.infradead.org>
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com>
 <20250505-kvm_lazy_enable_stateen-v1-4-3bfc4008373c@rivosinc.com>
 <D9QTFAE7R84D.2V08QTHORJTAH@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <D9QTFAE7R84D.2V08QTHORJTAH@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 5/8/25 6:32 AM, Radim Krčmář wrote:
> 2025-05-05T14:39:29-07:00, Atish Patra <atishp@rivosinc.com>:
>> SENVCFG and SSTATEEN CSRs are controlled by HSENVCFG(62) and
>> SSTATEEN0(63) bits in hstateen. Enable them lazily at runtime
>> instead of bootime.
>>
>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>> ---
>> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
>> @@ -256,9 +256,37 @@ int kvm_riscv_vcpu_hstateen_lazy_enable(struct kvm_vcpu *vcpu, unsigned int csr_
>>   	return KVM_INSN_CONTINUE_SAME_SEPC;
>>   }
>>   
>> +static int kvm_riscv_vcpu_hstateen_enable_senvcfg(struct kvm_vcpu *vcpu,
>> +						  unsigned int csr_num,
>> +						  unsigned long *val,
>> +						  unsigned long new_val,
>> +						  unsigned long wr_mask)
>> +{
>> +	return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_HSENVCFG);
>> +}
> Basically the same comments as for [1/5]:
>
> Why don't we want to set the ENVCFG bit (62) unconditionally?
>
> It would save us the trap on first access.  We don't get anything from
> the trap, so it looks like a net negative to me.

We want to lazy enablement is to make sure that hypervisor is aware of 
the what features
guest is using. We don't want to necessarily enable the architecture 
states for the guest if guest doesn't need it.

We need lazy enablement for CTR like features anyways. This will align 
all the the features controlled
by stateen in the same manner. The cost is just a single trap at the 
boot time.

IMO, it's fair trade off.
>> +
>> +static int kvm_riscv_vcpu_hstateen_enable_stateen(struct kvm_vcpu *vcpu,
>> +						  unsigned int csr_num,
>> +						  unsigned long *val,
>> +						  unsigned long new_val,
>> +						  unsigned long wr_mask)
>> +{
>> +	const unsigned long *isa = vcpu->arch.isa;
>> +
>> +	if (riscv_isa_extension_available(isa, SMSTATEEN))
>> +		return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_SSTATEEN0);
>> +	else
>> +		return KVM_INSN_EXIT_TO_USER_SPACE;
>> +}
> The same argument applies to the SE0 bit (63) when the guest has the
> sstateen extension.
>
> KVM doesn't want to do anything other than stop trapping and reenter, so
> it seems to me we could just not trap in the first place.
>
> Thanks.

