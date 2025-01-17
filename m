Return-Path: <kvm+bounces-35787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6657A1526F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6A1E161AC9
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B79818B463;
	Fri, 17 Jan 2025 15:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ByhHdQcw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6EE18858A
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737126573; cv=none; b=Fi59s3Zro9V+glbJY2tU5Tho7GkYUgg2KC3mw/VV1KTvMIL4dZma2les2FocEffSR68bAmXO3YOuPYDcLyZKzPTObsppya+FcupCe/aO7xmgpH+a+TBdkiSe/mr54206GXH5gC7gyl+cPDsPoIkiMg4aGM02yd9OLnKKb8z3Qlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737126573; c=relaxed/simple;
	bh=inUeq6IPy0tOSN5tNPx8YmCl9sfH7a15OZf6QpDe5o4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LyZNlS1tmiBKSBvyX9+qUO6OGdTkknw4j93/F5o3y6JuuYxV4BflUvtdlxPYPiO1IbjUsL0WitvgTNN0Z1ile6dYJnxPoRxokJCFEZ143o8JfsEP3xeldM66v3rE7tViWfOhQ6+luIyDTscjcbyYyGI39YTDW7LTwnIBHZ7BgNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ByhHdQcw; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-436249df846so14839835e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 07:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737126569; x=1737731369; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eeBHQLs9jVU95ezPlxDDqu8VwoV3ld6Y4fMnADed+lM=;
        b=ByhHdQcwJR1Vk3GUQdletUr7cy6cUX2v1kuKEabsUBAhWa8Adt5quePWXL3FUBKgJ8
         rTfT+UQBWR09Bl9dprBTeG+3HlF0YOWoGPs0tOAqCpjMGma2Rpz1zMgOU17uqI4xoJT0
         BPTsDnu6lRWpNl0XYcY0UtQcXIMG33oGmlBM/iPk8s/TZB8FogyOmN470Uo08YFSCzFp
         CDu5xeEzOpTcPGa9B2lkkM9WO4Z93MwZYaaY82+7G2tqq/GT6vqDB+MMMiuUg99vbrrq
         m7MGafPFlNeGhuboBF8Yrmz5ZK+CdTQnZdXPPVdaxWZWrNSp8fs6aRSB4l8zeUVjqe97
         1vHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737126569; x=1737731369;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eeBHQLs9jVU95ezPlxDDqu8VwoV3ld6Y4fMnADed+lM=;
        b=eDYdOetsxNz4c07ksfAgD1itsnXYgKc1snNBhlcr3kMY6nYTNIu7k7Pq7BrjxGDIzi
         k5Vq3eFg6qT8QFlXOBy+CR83GbZG0bbYFrcC5/pL/K+40uW5tl3e1B1LQvdcXQTNmm7c
         hpMiwy++abs2Q02cqRdGuMfKESx97iPPkmBHTeGWw4e20MJoVNkNRRjAeDK3whjni6YH
         NCVoBh8Gy5muGjIXctmuo3rkTeGhVyFOcgg8i8B25olxUkBreKUsK/UXYaQbjeenA+AB
         nfTs7Nl6VASrShQAM2d31Mr0QPRbHhI8Xv4Oe6LB0bU2cT1lsLMODiFrveRwuvk7TNvf
         GUUw==
X-Forwarded-Encrypted: i=1; AJvYcCVVhtrpJP8AciJ9CSpXraJupfZy0sop6VtzXYf7YGwPmxOVo1mNskqqqy+8ijF1pPeYsMY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd6pp5fo/IvV9ReTx9C5d7bKmnCz+vG2fVEMPcdLMVHbqyxCee
	8TGahp5Wn6/94JQcMf4SeH9rxR4+XklStWZIIm1VojsEEKJpZJ3RPwVgKWrHfa/y8BjaqoQwZ8s
	o
X-Gm-Gg: ASbGnctsgH5vbk6tkqNaUJcxTwoApFy29rwsFsbnIFcsDg+OQIry7r3ttylelc0t1pN
	+c0OV0+uOPUwmcafGeUb+0LCJtIkVzsG8ulZ+C/NcPHlNRxtPf3XecUotzim5axVZCo8qvZEGdn
	IUNXoxbWhZkp7ws10LM2A/0f+Fsyhs9gMuiJgxglk38O8xbWOOo9Et/hwDFAG4ZOUxxaEAbKS37
	HMRx71K4u371dH5qetn67nt4kLUllzKG8Z/hBgtOikP45hvdSuFByNdRp4/fqm4do2QmoIjf/D6
	FSSplYFl2HqIyDM3YO8ZxtUWbg==
X-Google-Smtp-Source: AGHT+IG1uZGUInjJmwhJbH8Ho3BFf5w1Dx39oNxBLgMYa7175SzgdXR9MqOpaXnkZP4l9hYELj4CQA==
X-Received: by 2002:a05:600c:5101:b0:434:f925:f5c9 with SMTP id 5b1f17b1804b1-438913c85e0mr30286255e9.6.1737126568985;
        Fri, 17 Jan 2025 07:09:28 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c7499bbasm101555505e9.3.2025.01.17.07.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 07:09:28 -0800 (PST)
Message-ID: <24f9b863-9b88-4a58-a7a0-b562f6be56ad@rivosinc.com>
Date: Fri, 17 Jan 2025 16:09:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] riscv: request misaligned exception delegation from
 SBI
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-3-cleger@rivosinc.com>
 <fca2a328-f2c4-4df3-9086-06b8a12b8da4@sifive.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <fca2a328-f2c4-4df3-9086-06b8a12b8da4@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/01/2025 00:35, Samuel Holland wrote:
> Hi Clément,
> 
> On 2025-01-06 9:48 AM, Clément Léger wrote:
>> Now that the kernel can handle misaligned accesses in S-mode, request
>> misaligned access exception delegation from SBI. This uses the FWFT SBI
>> extension defined in SBI version 3.0.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/include/asm/cpufeature.h        |  1 +
>>  arch/riscv/kernel/traps_misaligned.c       | 59 ++++++++++++++++++++++
>>  arch/riscv/kernel/unaligned_access_speed.c |  2 +
>>  3 files changed, 62 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
>> index 4bd054c54c21..cd406fe37df8 100644
>> --- a/arch/riscv/include/asm/cpufeature.h
>> +++ b/arch/riscv/include/asm/cpufeature.h
>> @@ -62,6 +62,7 @@ void __init riscv_user_isa_enable(void);
>>  	_RISCV_ISA_EXT_DATA(_name, _id, _sub_exts, ARRAY_SIZE(_sub_exts), _validate)
>>  
>>  bool check_unaligned_access_emulated_all_cpus(void);
>> +void unaligned_access_init(void);
>>  #if defined(CONFIG_RISCV_SCALAR_MISALIGNED)
>>  void check_unaligned_access_emulated(struct work_struct *work __always_unused);
>>  void unaligned_emulation_finish(void);
>> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
>> index 7cc108aed74e..4aca600527e9 100644
>> --- a/arch/riscv/kernel/traps_misaligned.c
>> +++ b/arch/riscv/kernel/traps_misaligned.c
>> @@ -16,6 +16,7 @@
>>  #include <asm/entry-common.h>
>>  #include <asm/hwprobe.h>
>>  #include <asm/cpufeature.h>
>> +#include <asm/sbi.h>
>>  #include <asm/vector.h>
>>  
>>  #define INSN_MATCH_LB			0x3
>> @@ -689,3 +690,61 @@ bool check_unaligned_access_emulated_all_cpus(void)
>>  	return false;
>>  }
>>  #endif
>> +
>> +#ifdef CONFIG_RISCV_SBI
>> +
>> +struct misaligned_deleg_req {
>> +	bool enable;
>> +	int error;
>> +};
>> +
>> +static void
>> +cpu_unaligned_sbi_request_delegation(void *arg)
>> +{
>> +	struct misaligned_deleg_req *req = arg;
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
>> +			SBI_FWFT_MISALIGNED_EXC_DELEG, req->enable, 0, 0, 0, 0);
>> +	if (ret.error)
>> +		req->error = 1;
>> +}
>> +
>> +static void unaligned_sbi_request_delegation(void)
>> +{
>> +	struct misaligned_deleg_req req = {true, 0};
>> +
>> +	on_each_cpu(cpu_unaligned_sbi_request_delegation, &req, 1);
>> +	if (!req.error) {
>> +		pr_info("SBI misaligned access exception delegation ok\n");
>> +		/*
>> +		 * Note that we don't have to take any specific action here, if
>> +		 * the delegation is successful, then
>> +		 * check_unaligned_access_emulated() will verify that indeed the
>> +		 * platform traps on misaligned accesses.
>> +		 */
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * If at least delegation request failed on one hart, revert misaligned
>> +	 * delegation for all harts, if we don't do that, we'll panic at
>> +	 * misaligned delegation check time (see
>> +	 * check_unaligned_access_emulated()).
>> +	 */
>> +	req.enable = false;
>> +	req.error = 0;
>> +	on_each_cpu(cpu_unaligned_sbi_request_delegation, &req, 1);
>> +	if (req.error)
>> +		panic("Failed to disable misaligned delegation for all CPUs\n");
> 
> This logic doesn't handle the case where the delegation request failed on every
> CPU, so there's nothing to revert. This causes a panic in a KVM guest inside
> qemu-softmmu (the host kernel detects MISALIGNED_SCALAR_FAST, so
> unaligned_ctl_available() returns false, and all FWFT calls fail).

Hi Samuel,

Indeed, that's a problem and the revert is not really clean since it is
called on all CPUs (even tha rone that failed). I'll modify that to use
cpumasks and thus cleanly revert the misaligned delegation on CPUs that
actually succeeded only.

Thanks,

Clément

> 
> Regards,
> Samuel
> 
>> +
>> +}
>> +
>> +void unaligned_access_init(void)
>> +{
>> +	if (sbi_probe_extension(SBI_EXT_FWFT) > 0)
>> +		unaligned_sbi_request_delegation();
>> +}
>> +#else
>> +void unaligned_access_init(void) {}
>> +#endif
>> diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
>> index 91f189cf1611..1e3166100837 100644
>> --- a/arch/riscv/kernel/unaligned_access_speed.c
>> +++ b/arch/riscv/kernel/unaligned_access_speed.c
>> @@ -403,6 +403,8 @@ static int check_unaligned_access_all_cpus(void)
>>  {
>>  	bool all_cpus_emulated, all_cpus_vec_unsupported;
>>  
>> +	unaligned_access_init();
>> +
>>  	all_cpus_emulated = check_unaligned_access_emulated_all_cpus();
>>  	all_cpus_vec_unsupported = check_vector_unaligned_access_emulated_all_cpus();
>>  
> 


