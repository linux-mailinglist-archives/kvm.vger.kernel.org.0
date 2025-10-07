Return-Path: <kvm+bounces-59573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA7DBC1944
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 15:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 060FE189379F
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 13:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971042E11C6;
	Tue,  7 Oct 2025 13:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="crT7Ud06"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42C22D9EF0
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759845219; cv=none; b=Mezvn4DzB1pnD/AUqFQnWuj37UKKKQjYEWF/6r7zjc0CPZtaBpELYk9rwxkNH94CIAQm5nEPMH3BagLJkx0BVpNxFeM9JFNGxzwfnpBB75Xrnkmi8EB1rRfrIrLPVoHCUxOAh+xwVQrp8QSkt2EG5sZAMtR0lIUSm/f6Z01sWnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759845219; c=relaxed/simple;
	bh=sWJ71juL1satDzHXgwrmtuK1k8CftCPXMSld83UkeTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dzcFSWYHxJfDnvZ8OTdHdzSyK3X8dmKLQJZd8oR5RvSv4biYmUbWeUGhy5MDNWyDzmswgwuXuPl9STOTqiSH2yiUKg7YtpMhoQ9ZCVLjIoE0Z0hdH82r/edNuaXUs0/8rjuFWXzrzu6ZvGrv/Bu+vDS1DVGmEye1Xmyl5ElXO+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=crT7Ud06; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e4ad36541so67949005e9.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 06:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759845216; x=1760450016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KSu7YaNQ98fqgKApTwJFR5+NIZ1z3gREge4RWvjXBYo=;
        b=crT7Ud064sH/EAek+ASY8YPAiEPHxqDJjKGKBKTW8Vq+fTdK3S1cXljt6Bh2ABBbCV
         AstNu0OpkJvDkoZlly91NaSjK9l0Vji4ibpsFjfpHFpjOjR2LCRnzwIa41KhGCZVerCR
         EpvIm64sYX1/8UkpBCMY4jY2BskFKVawRrM5fnUs+JdOOsIkj3aCvYc1DQLoLrOPuqBn
         3NeLeZsovgzUN0KcUoLS089p5ubDLWqLTyTWqltzAKIIjcKBRs3gPaxcPUwJfHNt72w4
         kH0v9e/aRC/zeY0jfQWek43rtIQt5co2ici2jUhZ+HaHho1EHKoQoEccCSl94+lXHISn
         sUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759845216; x=1760450016;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSu7YaNQ98fqgKApTwJFR5+NIZ1z3gREge4RWvjXBYo=;
        b=I468YFWMUbKdyd0Qjjg5QYQeGl9KxdNNJFgV1ll2vlf9Oprf0TsKZYW0I4uzRXBlE4
         AbI8XQyZzQL9HP1m3IDRq5003BFtjtMkIyxqbLuNiK/O90sVddnJrFcrOSKP0xWpNBg8
         JB4SSEyD7Z0MDN4z7Nq+yxp1IGVxprIL5EUJllWjIin1XGfNvbwU4Gm6Ugdox61ZKhX8
         8yZonr4TB7ApeqkL6z7c4qenbYwTwIBwZX9Dweo0sKYfQKfbJA0tAtt1P5liuZCpHHGA
         Gh+MmK3jytfBkB2usQLHcam9YBujajNB5UCSjE35wu/0SEqAWNfV2a8UsTqWvcVzycpb
         iJ7g==
X-Forwarded-Encrypted: i=1; AJvYcCVumhb5q8lKC2U0hmGv/2LXb+EezSHRtzTu0XSAZey8I/dQlakvN852UKrcBhyAQ5/2b70=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvUelNgQOMdjERTSv1tqHAV0BJ60SaScXVrHrtx/vs73pRMMUQ
	8djpoT1qONaN2oYC222VHqvGHFxXSc6rCzLo5btcV1XYrJp8a1shK/2mN6M2ArKyB7I=
X-Gm-Gg: ASbGncsHPVjW5QNEuDxGGlBULcJsd0sEa8TIfCdooHHGloV55Y0MzX/ePF70kPBMDhR
	u6exrabMjecbzjzNt163K5CpWjiXJjhpnLuWWLhWAw7MoULFA2A5WScBQv6rqxS9MbECqXWztS+
	6E9JBWdRKyy+XLPzC7PPkfvVL8ILiUPU+HtdGFGyY+7TzW1W2uJLSISVGGgVpgSuSQKFbwRDen3
	XdblWG9Ckv1xx5Uy+pXx5AH+Z3DelMog2lmMB/iW1WMO771O4pRRpC7ZVHP39xIOI3pk3qYw6e0
	FCoro1WMkW+Gd3b+Hvz8DwpcGpsrqOz55qnvvF6LUtIMzZUaVMa5e6g2AJTRxFz7CCScYfRbEyG
	AAuY0KbTMsN1WoOWuGEQ18YKLcJYKWOJRvcS6LLGQ8/Iw4dIYgWT699ngMHvwa3DGqV3G+HWlis
	qCpvIumOC9aPDMvYukiA==
X-Google-Smtp-Source: AGHT+IEnky2yVJPGAWBDFxN4WGWRP9AzefwqPuoYNHPLT0f5ShCcXu2lf1+SKolr1wo3QdbUohJxXA==
X-Received: by 2002:a05:600c:4e92:b0:46e:448a:1235 with SMTP id 5b1f17b1804b1-46e7110f1bemr142948205e9.16.1759845216081;
        Tue, 07 Oct 2025 06:53:36 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa3a0d17fsm17718285e9.4.2025.10.07.06.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 06:53:35 -0700 (PDT)
Message-ID: <8a931a39-fb34-4176-b8b8-c47bd2b1d266@linaro.org>
Date: Tue, 7 Oct 2025 15:53:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] accel/kvm: Factor kvm_cpu_synchronize_put() out
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>
Cc: qemu-devel@nongnu.org, Weiwei Li <liwei1518@gmail.com>,
 David Hildenbrand <david@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, qemu-s390x@nongnu.org,
 Song Gao <gaosong@loongson.cn>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
 Aurelien Jarno <aurelien@aurel32.net>, Aleksandar Rikalo
 <arikalo@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>, qemu-riscv@nongnu.org,
 Nicholas Piggin <npiggin@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Chinmay Rath <rathc@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20251007081616.68442-1-philmd@linaro.org>
 <20251007081616.68442-4-philmd@linaro.org>
 <20251007-650e7ef70cc4591d1ef647f1@orel>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251007-650e7ef70cc4591d1ef647f1@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/10/25 15:30, Andrew Jones wrote:
> On Tue, Oct 07, 2025 at 10:16:16AM +0200, Philippe Mathieu-Daudé wrote:
>> The same code is duplicated 3 times: factor a common method.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   accel/kvm/kvm-all.c | 47 ++++++++++++++++++---------------------------
>>   1 file changed, 19 insertions(+), 28 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 9060599cd73..de79f4ca099 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2935,22 +2935,32 @@ void kvm_cpu_synchronize_state(CPUState *cpu)
>>       }
>>   }
>>   
>> -static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
>> +static bool kvm_cpu_synchronize_put(CPUState *cpu, KvmPutState state,
>> +                                    const char *desc)
>>   {
>>       Error *err = NULL;
>> -    int ret = kvm_arch_put_registers(cpu, KVM_PUT_RESET_STATE, &err);
>> +    int ret = kvm_arch_put_registers(cpu, state, &err);
>>       if (ret) {
>>           if (err) {
>> -            error_reportf_err(err, "Restoring resisters after reset: ");
>> +            error_reportf_err(err, "Restoring resisters %s: ", desc);
>>           } else {
>> -            error_report("Failed to put registers after reset: %s",
>> +            error_report("Failed to put registers %s: %s", desc,
>>                            strerror(-ret));
>>           }
>> -        cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
>> -        vm_stop(RUN_STATE_INTERNAL_ERROR);
>> +        return false;
>>       }
>>   
>>       cpu->vcpu_dirty = false;
>> +
>> +    return true;
>> +}
>> +
>> +static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
>> +{
>> +    if (kvm_cpu_synchronize_put(cpu, KVM_PUT_RESET_STATE, "after reset")) {
> 
> This should be !kvm_cpu_synchronize_put() and same comment for the other
> calls below.

Oops! Thanks :)

> 
> Thanks,
> drew


