Return-Path: <kvm+bounces-37569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EBABA2BD59
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 09:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 927A83AA3DE
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 08:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1B223FC7A;
	Fri,  7 Feb 2025 07:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="BcONL+OD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBB0238756
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 07:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738915075; cv=none; b=L7NP3l//oKMiNtWKWsjnYZmKBc0shKWxvVfz5hCNiclhnP3HAFSpK1XWavB4PpwuRb2di/NNN2RxZlcPilyJvSHw43DFQB9SRYxwDaGIErEBLDonDr8C7LEQovVzaIi2+sGEt+25NKG8/3Bs1qESveHuUEqUdUzdWYvuwI7EpxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738915075; c=relaxed/simple;
	bh=LwY9QkKjrGqjAvf2nxBCWR+BzENMRju/lQJYqpwui6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UMAXVcuou7qD4tzSaS2q1yKn+C3fQYXa0L4UULyQ4BvKKR0aLhOcXchciqmqsjFBoJ+05BlYOecFp4l8KHldN9AWfAiXn5tI1ES8n6U3mtYa4DvabmzV7dQgHXxakTE0GlNv6KiydNIxz1+c94hTO4Z/2H+G2cAaxvcvbk6kT1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=BcONL+OD; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38dc627eba6so625036f8f.2
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 23:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738915071; x=1739519871; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8+8W0r1eBfeQeUIpnApB8DWC5KBFE4067O0DEyXdDjM=;
        b=BcONL+ODGvVDDwQhj3IupJ81Vqw+avYXwPHfioeycwvyBUvN5Teu4tmVCPjBdbO53Q
         Q6wU9q6v8kAGLl5WHBglsv1beGlUVxJ+TlNdTuCsq3Qv/ztRTKioaH3N7DLBoB4eFYM1
         epI/b4zKZDyZ+kkfGTf1gx4lqtiVDMgoQZG5dHyZUXzVLWOaCyiSJZikQdb1AjOBlR+/
         xf617MF/eER2ZQ4ZoeVfYvlWTFAHsY9lj6NPauimjfX4ym6Dnzc+C9zrshyrXsTugy6y
         +YfpxuS2CLoGvnO5uy8qmY2BUTlYXihgQrxg2oXXlbCRuTIQCxXapvlsjdYUHjhRNHrM
         KlGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738915071; x=1739519871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8+8W0r1eBfeQeUIpnApB8DWC5KBFE4067O0DEyXdDjM=;
        b=vokCmIrzGhPKQtsx/vCD3gnr1/coyKA52jPkhatVIZKMmkYtRoTyjq5pIcCzXrObic
         3AxBHeIMPXG6ugtC9K99CJR4i+1oZHm4nYfrXmquFbvCwLnZ3K5zbVkvkqkhTVO6NiG0
         mkAprkyOZsObMbJyN7Vi4fwgNa+9JhBsK0xShHACwR6ge+rpGCWl0r0J2Gm8/nwHmJyW
         lecOt8zRLCaRn4J2R2cXG3t3f3wP7BHQzJxHevnC7heUjTxspiF9HxaUGSup9BUJ2xUx
         D3qPs8LGbKvbL+/S5UqazVpYBSyhZxTdilvTn9QG1JLDKNzJBBVZNHfbMj/N5okCe2c6
         Qkeg==
X-Forwarded-Encrypted: i=1; AJvYcCWBAWcAB3be1bsikd4BPjF7Qlqo/5vNrkdvvrCRb6bvNd3mG3E1EmnfOU7EFoRN1ftZFN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSXwyPWIS0t8THgfrShtZU5zX1SQPjQ0AVB+/xbRQiMmj35UZh
	dIfgK/9bH+obh3c9vlFNb24XpAYaiamC5iBU3tWmn6Tno9B+8+ZkhvbhWjj+KLc=
X-Gm-Gg: ASbGncvtkapPaAXYLCXXXNd65Z9c9FMY6V1gJF1g2BVNg6P+Vrj9P4ET6QjefBDvu1/
	k2LPsJIa7VqoghTqj+1ZnJ7t2S+aMhPR+3EiP6FU62uJsmE69A5mPl3HLpxGVA8YllWQL364o4a
	OvT6uwg0MlRP+tKJzdTJfnQgY3rTsbqQvRKLNsPBDiRi5KRpz3x33AXCVTtYCmx4TVUrhQZi37B
	jRhZiQP+ebmOFK7npx4CrCdD7m/rUk3ASU01rMNOHRmSKUngeeSsN5P19kAYR00SJM5KFY1667Z
	sbF1tlh8jGZ+yVvxsUokDQa8ZodYs1XUHqKHxl7QWTecG+8sGQlHNgKSR/0I
X-Google-Smtp-Source: AGHT+IGq74MwyyBs38GAGswE+10Qup4jIp3Pg2RgGuSrurMbFniM8/Z3Fz5NjAT2LPHjyfZgPXz2qQ==
X-Received: by 2002:a5d:64ee:0:b0:38d:ac77:d7cb with SMTP id ffacd0b85a97d-38dc8dd105bmr1267323f8f.25.1738915070831;
        Thu, 06 Feb 2025 23:57:50 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391dc9ff64sm44791635e9.9.2025.02.06.23.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 23:57:50 -0800 (PST)
Message-ID: <76865725-35ce-48c6-822f-ea6cf817cee3@rivosinc.com>
Date: Fri, 7 Feb 2025 08:57:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/21] RISC-V: Add Sxcsrind ISA extension CSR
 definitions
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
 <20250205-counter_delegation-v4-2-835cfa88e3b1@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250205-counter_delegation-v4-2-835cfa88e3b1@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 06/02/2025 08:23, Atish Patra wrote:
> From: Kaiwen Xue <kaiwenx@rivosinc.com>
> 
> This adds definitions of new CSRs and bits defined in Sxcsrind ISA
> extension. These CSR enables indirect accesses mechanism to access
> any CSRs in M-, S-, and VS-mode. The range of the select values
> and ireg will be define by the ISA extension using Sxcsrind extension.
> 
> Signed-off-by: Kaiwen Xue <kaiwenx@rivosinc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 37bdea65bbd8..2ad2d492e6b4 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -318,6 +318,12 @@
>  /* Supervisor-Level Window to Indirectly Accessed Registers (AIA) */
>  #define CSR_SISELECT		0x150
>  #define CSR_SIREG		0x151
> +/* Supervisor-Level Window to Indirectly Accessed Registers (Sxcsrind) */
> +#define CSR_SIREG2		0x152
> +#define CSR_SIREG3		0x153
> +#define CSR_SIREG4		0x155
> +#define CSR_SIREG5		0x156
> +#define CSR_SIREG6		0x157
>  
>  /* Supervisor-Level Interrupts (AIA) */
>  #define CSR_STOPEI		0x15c
> @@ -365,6 +371,14 @@
>  /* VS-Level Window to Indirectly Accessed Registers (H-extension with AIA) */
>  #define CSR_VSISELECT		0x250
>  #define CSR_VSIREG		0x251
> +/*
> + * VS-Level Window to Indirectly Accessed Registers (H-extension with Sxcsrind)
> + */
> +#define CSR_VSIREG2		0x252
> +#define CSR_VSIREG3		0x253
> +#define CSR_VSIREG4		0x255
> +#define CSR_VSIREG5		0x256
> +#define CSR_VISREG6		0x257
>  
>  /* VS-Level Interrupts (H-extension with AIA) */
>  #define CSR_VSTOPEI		0x25c
> @@ -407,6 +421,12 @@
>  /* Machine-Level Window to Indirectly Accessed Registers (AIA) */
>  #define CSR_MISELECT		0x350
>  #define CSR_MIREG		0x351
> +/* Machine-Level Window to Indrecitly Accessed Registers (Sxcsrind) */

Typo: s/Indrecitly/Indirectly

> +#define CSR_MIREG2		0x352
> +#define CSR_MIREG3		0x353
> +#define CSR_MIREG4		0x355
> +#define CSR_MIREG5		0x356
> +#define CSR_MIREG6		0x357
>  
>  /* Machine-Level Interrupts (AIA) */
>  #define CSR_MTOPEI		0x35c
> @@ -452,6 +472,11 @@
>  # define CSR_IEH		CSR_MIEH
>  # define CSR_ISELECT	CSR_MISELECT
>  # define CSR_IREG	CSR_MIREG
> +# define CSR_IREG2	CSR_MIREG2
> +# define CSR_IREG3	CSR_MIREG3
> +# define CSR_IREG4	CSR_MIREG4
> +# define CSR_IREG5	CSR_MIREG5
> +# define CSR_IREG6	CSR_MIREG6
>  # define CSR_IPH		CSR_MIPH
>  # define CSR_TOPEI	CSR_MTOPEI
>  # define CSR_TOPI	CSR_MTOPI
> @@ -477,6 +502,11 @@
>  # define CSR_IEH		CSR_SIEH
>  # define CSR_ISELECT	CSR_SISELECT
>  # define CSR_IREG	CSR_SIREG
> +# define CSR_IREG2	CSR_SIREG2
> +# define CSR_IREG3	CSR_SIREG3
> +# define CSR_IREG4	CSR_SIREG4
> +# define CSR_IREG5	CSR_SIREG5
> +# define CSR_IREG6	CSR_SIREG6
>  # define CSR_IPH		CSR_SIPH
>  # define CSR_TOPEI	CSR_STOPEI
>  # define CSR_TOPI	CSR_STOPI
> 
With that typo fixed:

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément



