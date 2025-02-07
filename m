Return-Path: <kvm+bounces-37573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D53A2BF58
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 10:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86E29188CEE7
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 09:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454E71DDC0D;
	Fri,  7 Feb 2025 09:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LYDnjM0J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F89C166F07
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 09:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738920645; cv=none; b=S6FBoqsqpSZSXuRn7zqB1SeYSaH9z9yq4/0LdTU4+eUq1AxV719U8nryH8UnZk6QMYBQm9KCO7W64DpNmr3YecXQICzpXjeGPp/0i8GDIJcz1FOEoQuosqsf/5CiYC4QM1SoIyWbsSZpMar61io1O0XGSAHD1NDcj3MPg84JuvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738920645; c=relaxed/simple;
	bh=3T3FNEMDS87D9bzr1Wj8zuVHAVXHeuIwGxQ786Nx1qA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J6nl/HIrQlnxaCtp76yxiLLhCEOajefhsEtFlwmyX+0lBD/fv2MY5yJfvQkWgOcLo5dQJ8cZ0XXInhBWas2WO0cW062SMA941rNHkXaHAeY2Jaz5NliULnxDJYwptGaSP3QmnlbnU9FLaSAk70KC49ATS9V3LoFqfbIofFSYo58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LYDnjM0J; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38dcc6df5d3so230596f8f.0
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 01:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738920642; x=1739525442; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3a+d7uyoeApEWBBfKQwFeZRvjtQlKPA0vvhD7J7Rfb0=;
        b=LYDnjM0JCg0h7Ocrho+6E1W2jxX+f4kFtJ7N6eXuQNB0KSTUrZ0ZnwY7yNWHQ6y9Mo
         FRMXqGYCaBY1kWCzBMJgQsYDyGBdrJhHNo4rYf8Dzlxtzpalf7rovZRPkWlohUhd29KU
         cPh+Bq84LH6LTE+8BZP6P5oa+CI4p4BYAq6cKsU2R9vesAVyQ1PkIUFJY5iDBu5Nkrm4
         NtoXRED/IjV8Nocw977ed8xHgZlm23odiuPj1sNlmw2gFUsoffRnvmMw17sMepgFA2+e
         wVrdsCE18q+NAVFCAHrqrwLsPaJzHNF3icPsTsazwHm2QngC2HPDWKDcvu2yNV6dsEUn
         OHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738920642; x=1739525442;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3a+d7uyoeApEWBBfKQwFeZRvjtQlKPA0vvhD7J7Rfb0=;
        b=rLbFDp7K6DDaWYzI7OZJGr6sThV5yEkFHLwxs2qacquVffpjTp7gun/XUzxnHkGkDD
         lA9l/YUmb7IeWyfmID4s/XsHm1dV9jFTCnXOmhR0upp9QutmnYh9u797UOoPLSXR9IL6
         2iONJ06T3o4FDDN9W3qzMCPNdfeG52WxBPtWIglAfaW2X0LMoaefqA9IcqeeAkEf9SlQ
         ekRzJYHrD4Yfx8krRUG6Ms9gsOoTXeIlrfShUhfp1E3MaVWDOEbcytxVEDOqscmRXkLx
         Q0LsDe84TtPm9/mAnqpueFX7RiYsW2FcDpOmovexGFGNwsvGOjxYa5YQVSHCA1TR/Q5O
         I1Xg==
X-Forwarded-Encrypted: i=1; AJvYcCVXMdOcCTfjanHxoZwFmTecdHfj6cIKxTE1NHcuPZhdkMmAoJt/K8RqMxhTbbdHOoLjv+U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsCGziisj+4BRGRJvzlR5F5qyD2+Fp5ekVwBGBUwu7pMG4TqXJ
	vAUO5v6VXLbvLbOsSDAo9coyR65T7b6n2maJIMxqYsXL7ugI1Dx0MeciatxoKTPFA1bDNg7/QeY
	qxPE=
X-Gm-Gg: ASbGnctpnKa4/Sa7RZ+P2ZQ1WuidYSpDf8v2FNrpm+gPqRyTXicVZOK8TCvB+j6lp8N
	7jOX+7Igq/w130dc33lUNOtdx461EanfsoPUZHZSh3ioptLpeXBFRRaWa1JoRtn3IuRKihyr3gT
	hREjMpgiLlkKP8kkeLFswB2c29HyeFytZXfALzJsWpsOk8yG9TLM7lO/BeRl8JLvc9sN5A52tUo
	QC2u7orpEhVIbg1eIbuSjPyEJQlFrFRME6ctL4GcrbRd0eTMCzFDjzner0AZBgX07JZT+tvY+LQ
	BfRHkZRmdXBTxlPumI21VBAII6uzI6p24mw05wxXdDyAjm3woRMZSz5er+Af
X-Google-Smtp-Source: AGHT+IESXZlQ/7J7RVMhXOtjbNkCC7bnZBXGkym1nxwIOsNsCdWy/rEEkXcjomIH6pUgz9UpP8gZ8g==
X-Received: by 2002:a05:6000:154e:b0:385:e1e8:40db with SMTP id ffacd0b85a97d-38dc8dd0a8amr1292514f8f.24.1738920641731;
        Fri, 07 Feb 2025 01:30:41 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dbdd3856fsm3892845f8f.28.2025.02.07.01.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 01:30:41 -0800 (PST)
Message-ID: <bcb10a3a-162b-4a8c-a479-38f4168cea9a@rivosinc.com>
Date: Fri, 7 Feb 2025 10:30:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/21] RISC-V: Add Sscfg extension CSR definition
To: Atish Patra <atishp@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 Kaiwen Xue <kaiwenx@rivosinc.com>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
 <20250205-counter_delegation-v4-8-835cfa88e3b1@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250205-counter_delegation-v4-8-835cfa88e3b1@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 06/02/2025 08:23, Atish Patra wrote:
> From: Kaiwen Xue <kaiwenx@rivosinc.com>
> 
> This adds the scountinhibit CSR definition and S-mode accessible hpmevent
> bits defined by smcdeleg/ssccfg. scountinhibit allows S-mode to start/stop
> counters directly from S-mode without invoking SBI calls to M-mode. It is
> also used to figure out the counters delegated to S-mode by the M-mode as
> well.
> 
> Signed-off-by: Kaiwen Xue <kaiwenx@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 2ad2d492e6b4..42b7f4f7ec0f 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -224,6 +224,31 @@
>  #define SMSTATEEN0_HSENVCFG		(_ULL(1) << SMSTATEEN0_HSENVCFG_SHIFT)
>  #define SMSTATEEN0_SSTATEEN0_SHIFT	63
>  #define SMSTATEEN0_SSTATEEN0		(_ULL(1) << SMSTATEEN0_SSTATEEN0_SHIFT)
> +/* HPMEVENT bits. These are accessible in S-mode via Smcdeleg/Ssccfg */
> +#ifdef CONFIG_64BIT
> +#define HPMEVENT_OF			(_UL(1) << 63)
> +#define HPMEVENT_MINH			(_UL(1) << 62)
> +#define HPMEVENT_SINH			(_UL(1) << 61)
> +#define HPMEVENT_UINH			(_UL(1) << 60)
> +#define HPMEVENT_VSINH			(_UL(1) << 59)
> +#define HPMEVENT_VUINH			(_UL(1) << 58)
> +#else
> +#define HPMEVENTH_OF			(_ULL(1) << 31)
> +#define HPMEVENTH_MINH			(_ULL(1) << 30)
> +#define HPMEVENTH_SINH			(_ULL(1) << 29)
> +#define HPMEVENTH_UINH			(_ULL(1) << 28)
> +#define HPMEVENTH_VSINH			(_ULL(1) << 27)
> +#define HPMEVENTH_VUINH			(_ULL(1) << 26)

Hi Atish,

Could you use BIT_UL/BIT_ULL() ? With that fixed,

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément

> +
> +#define HPMEVENT_OF			(HPMEVENTH_OF << 32)
> +#define HPMEVENT_MINH			(HPMEVENTH_MINH << 32)
> +#define HPMEVENT_SINH			(HPMEVENTH_SINH << 32)
> +#define HPMEVENT_UINH			(HPMEVENTH_UINH << 32)
> +#define HPMEVENT_VSINH			(HPMEVENTH_VSINH << 32)
> +#define HPMEVENT_VUINH			(HPMEVENTH_VUINH << 32)
> +#endif
> +
> +#define SISELECT_SSCCFG_BASE		0x40
>  
>  /* mseccfg bits */
>  #define MSECCFG_PMM			ENVCFG_PMM
> @@ -305,6 +330,7 @@
>  #define CSR_SCOUNTEREN		0x106
>  #define CSR_SENVCFG		0x10a
>  #define CSR_SSTATEEN0		0x10c
> +#define CSR_SCOUNTINHIBIT	0x120
>  #define CSR_SSCRATCH		0x140
>  #define CSR_SEPC		0x141
>  #define CSR_SCAUSE		0x142
> 


