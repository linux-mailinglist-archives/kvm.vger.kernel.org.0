Return-Path: <kvm+bounces-41064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0164AA6136A
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F027419C1FD2
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E353E200BB7;
	Fri, 14 Mar 2025 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="e2ek60YQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEEB200BA8
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741961592; cv=none; b=EuG67bnU7Oa4s93c6EXpxC6cPJVZTmDfVYAvufutDm5IOy/VKKiCGt4oWLcuM3FcIjr7ygkueV5VBgfHWhCggvQZtm4lPuWFRzipUECNccoSLApIjvMn2k+NlcDotw+sHb2QopGawrIfzuk+2Ra1jsCdfVnfACas+TcJwTEprm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741961592; c=relaxed/simple;
	bh=zKkr27YsV98iHcatIGGwp6KposenF94mQPsL98c8i98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJtLMTghTKzsxnp2g3n7O4px+QM9+oOqyp6jZmXtxSdiAyQW4crk+ASp1I+11hU6X3GJmkzZ8wwMFfcKFAdyKeG3fuQvZypMBbkGRiVGunT28ShAci7JDfJYp3G/C9RnLPgiLlCi828owG719bHyh2jQqZBCph3orgk1nwQw4ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=e2ek60YQ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3965c995151so1247999f8f.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 07:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741961588; x=1742566388; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BOtTKHxsBlUHLqz7fX/nbjMS/2K5CqqYxWeMw7RofrY=;
        b=e2ek60YQ2Bave9/BUoXOqVuR0YOiWUylsX3PVSbEdB1fLvXLewhsvDSsQEMC3GN4H6
         bNJoi+yBm0ynetiAIcmi0zKyHa3BAPx7Uk6OAOUmlEILCqdLHzLXsgCdRxEidgL2u0/D
         W4+7fbMSqEhx7bUTtbjgRr7bo3Qj0DnnXiCuGl7kSsu8jyXZOoHNiBOxgahwxZRs3vON
         sQwAUbEdnw4JnK6HrDtwqfggeAM/BFtLrD6+hTkwpNHgTTyIXrSqYGGqbIoMV6i//+aj
         zP56BZdAsqLoxrT7ac4rlAW39xYKXQdOpgC4GXWAPIS6/KpN/BDd0AKhMKEIkmFK8UQz
         D1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741961588; x=1742566388;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BOtTKHxsBlUHLqz7fX/nbjMS/2K5CqqYxWeMw7RofrY=;
        b=KY6w6EKUI/ZmRZIYJBEX7YWoSGLuXgFmNI/d9xc6dZweiLbePf4LBxC7mwjKlL2qJo
         1+UDi1C6Z9xgNiGmUeMPwZB4S1/Z9NJ9T8KzsprNPpQiCjTgbSIKwiTUVPuQ3/wNQgnV
         //r21A+bOMzRGkURA31Y+07X8hY6svAkCvOMVTFgGrf0SPREJjDhEjLPsH1E1YL2MWux
         7DpsxymJwINGUilCCR/JNCFnmAA0JFRp8aArPGXq97yl0h9U2BENF8KTmw6LBIPJwUnM
         ny338ybyl4mFDxMpADFDUUdrEPi1ZpgvADCnGejNdrDn1cKi/uQyRQ4DrxoWObwbYmoE
         cOcg==
X-Gm-Message-State: AOJu0Yyy0j+pcf7TvUZVJbSB0rMCqTb79zXaZqRPjx/OJKEjmHN/Wugn
	LkLJNjiPn8tsppnuoBQz0FBIU/H0s2x621Xf2Z9YEIA8tpLKGNPqTuSpQxOmClI=
X-Gm-Gg: ASbGncuqIEKDn8EY5N3lsOlMtA2P9jexmb8RZWpuqoiLs5AUQg2GIYMhQE1qvGpnjvL
	IdYftl5lqON5ZOvwt8sqlwMw6PJ3nOaMyH/0usBcx3ORLD4suS7c91V8vdgYGC56T3kfb4qUKEf
	LNXGinQO7Sypvq8CmcX2E1fo+X0IrNtHg/v6wbXQJtQa2y/PIxxA8Wifo1PP7FJdJlwkBbbT8nK
	Z+Jplz9xrYF9Pzl1YRaI+jRmChXUbVMmHkFFFeIEjSIFFCuT/isEskSfGHU5jUcFYZwFmM7tkHj
	We357z1JnUePULkEYRpk+J4NXz8AJLSDkKWd/P6BfNRm8jofP1JamAqW45wNWhTPXKpUF1jz12X
	7DY98Xl+rR+5fTQ==
X-Google-Smtp-Source: AGHT+IGCgacB9DRhpEgGF4RbE+sajD5loYzUCHp9z2MkOCzGetiv5BTF6BJDywIqB4bdKYjkoO5kRQ==
X-Received: by 2002:a5d:5f4b:0:b0:38a:88ac:f115 with SMTP id ffacd0b85a97d-3971e972011mr3870485f8f.34.1741961587861;
        Fri, 14 Mar 2025 07:13:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c7df3419sm5564046f8f.9.2025.03.14.07.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 07:13:07 -0700 (PDT)
Message-ID: <56451a0e-7971-4619-8b2e-84c5129547b4@rivosinc.com>
Date: Fri, 14 Mar 2025 15:13:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 6/6] riscv: sbi: Add SSE extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
 <20250314111030.3728671-7-cleger@rivosinc.com>
 <20250314-0940c2c0dcd92b285f43e4ca@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250314-0940c2c0dcd92b285f43e4ca@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 14/03/2025 15:11, Andrew Jones wrote:
> On Fri, Mar 14, 2025 at 12:10:29PM +0100, Clément Léger wrote:
> ...
>> +static void sse_test_inject_local(uint32_t event_id)
>> +{
>> +	int cpu;
>> +	uint64_t timeout;
>> +	struct sbiret ret;
>> +	struct sse_local_per_cpu *cpu_args, *cpu_arg;
>> +	struct sse_foreign_cpu_test_arg *handler_arg;
>> +
>> +	cpu_args = calloc(NR_CPUS, sizeof(struct sbi_sse_handler_arg));
>> +
>> +	report_prefix_push("local_dispatch");
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		cpu_arg->handler_arg.event_id = event_id;
>> +		cpu_arg->args.stack = sse_alloc_stack();
>> +		cpu_arg->args.handler = sse_foreign_cpu_handler;
>> +		cpu_arg->args.handler_data = (void *)&cpu_arg->handler_arg;
>> +		cpu_arg->state = SBI_SSE_STATE_UNUSED;
>> +	}
>> +
>> +	on_cpus(sse_register_enable_local, cpu_args);
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		ret = cpu_arg->ret;
>> +		if (ret.error) {
>> +			report_fail("CPU failed to register/enable event: %ld", ret.error);
>> +			goto cleanup;
>> +		}
>> +
>> +		handler_arg = &cpu_arg->handler_arg;
>> +		WRITE_ONCE(handler_arg->expected_cpu, cpu);
>> +		/* For handler_arg content to be visible for other CPUs */
>> +		smp_wmb();
>> +		ret = sbi_sse_inject(event_id, cpus[cpu].hartid);
>> +		if (ret.error) {
>> +			report_fail("CPU failed to inject event: %ld", ret.error);
>> +			goto cleanup;
>> +		}
>> +	}
>> +
>> +	for_each_online_cpu(cpu) {
>> +		handler_arg = &cpu_args[cpu].handler_arg;
>> +		smp_rmb();
>> +
>> +		timeout = sse_event_get_complete_timeout();
>> +		while (!READ_ONCE(handler_arg->done) || timer_get_cycles() < timeout) {
> 
> I pointed this out in the last review, the || should be a &&. We don't
> want to keep waiting until we reach the timeout if we get the done signal
> earlier.

Missed it. I'll resend a V10 if you don't have any other comments.

Thanks,

Clément

> 
>> +			/* For handler_arg update to be visible */
>> +			smp_rmb();
>> +			cpu_relax();
>> +		}
>> +		report(READ_ONCE(handler_arg->done), "Event handled");
>> +		WRITE_ONCE(handler_arg->done, false);
>> +	}
>> +
>> +cleanup:
>> +	on_cpus(sbi_sse_disable_unregister_local, cpu_args);
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		ret = READ_ONCE(cpu_arg->ret);
>> +		if (ret.error)
>> +			report_fail("CPU failed to disable/unregister event: %ld", ret.error);
>> +	}
>> +
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		sse_free_stack(cpu_arg->args.stack);
>> +	}
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void sse_test_inject_global_cpu(uint32_t event_id, unsigned int cpu,
>> +				       struct sse_foreign_cpu_test_arg *test_arg)
>> +{
>> +	unsigned long value;
>> +	struct sbiret ret;
>> +	uint64_t timeout;
>> +	enum sbi_sse_state state;
>> +
>> +	WRITE_ONCE(test_arg->expected_cpu, cpu);
>> +	/* For test_arg content to be visible for other CPUs */
>> +	smp_wmb();
>> +	value = cpu;
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Set preferred hart"))
>> +		return;
>> +
>> +	ret = sbi_sse_enable(event_id);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Enable event"))
>> +		return;
>> +
>> +	ret = sbi_sse_inject(event_id, cpu);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Inject event"))
>> +		goto disable;
>> +
>> +	smp_rmb();
>> +	timeout = sse_event_get_complete_timeout();
>> +	while (!READ_ONCE(test_arg->done) || timer_get_cycles() < timeout) {
> 
> same comment
> 
>> +		/* For shared test_arg structure */
>> +		smp_rmb();
>> +		cpu_relax();
>> +	}
>> +
>> +	report(READ_ONCE(test_arg->done), "event handler called");
>> +	WRITE_ONCE(test_arg->done, false);
>> +
>> +	timeout = sse_event_get_complete_timeout();
>> +	/* Wait for event to be back in ENABLED state */
>> +	do {
>> +		ret = sse_event_get_state(event_id, &state);
>> +		if (ret.error)
>> +			goto disable;
>> +		cpu_relax();
>> +	} while (state != SBI_SSE_STATE_ENABLED || timer_get_cycles() < timeout);
> 
> same comment
> 
> Otherwise,
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> 
> Thanks,
> drew


