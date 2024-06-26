Return-Path: <kvm+bounces-20552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 555AD918244
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 15:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 886981C21E74
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867AC181D0E;
	Wed, 26 Jun 2024 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ZP9aKADi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53995181CE1
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 13:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719408285; cv=none; b=lg/StGbXkr1t1DiGcUy6HMFO92ky6rQCaHSfANhYwzKX55/YAmT7irZ/FdFuUxT3E10V0R+oXPrN16b/JyQ2PKba8XRkmQHqFVGtl7yB/Z0yY6wv+fhx08/3ewNb66hZiuW5CNO6Bbw7sWKvK8QKXFW/yIA599JYcGQ1mZngtKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719408285; c=relaxed/simple;
	bh=0gdryHBCLxjbkn2nn9kVoQ75BunZ6TaLK7IoY+AEzJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oOaR/AS43Og5v+O9b+p3W1hzc7BSZW3ULUcUsi5JXThg4o7tHN1y292srse3v0Cb2fu/8qtx8hdQPrYxC3qX5yM/RW/3amy3aTUR3r7zvfrqmDEpO8YdFF1xoahyz+n5S39QP6evUSzgGY4hvyIGqla7Br/3g4ckj0WWS8uS4Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ZP9aKADi; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3d55c28cd0dso841075b6e.3
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 06:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1719408283; x=1720013083; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wkp55ahjVZ0Rfp573fGCok3PgZ8FQzhwmhHHebz4g1I=;
        b=ZP9aKADioZThtluG5R6R6SBUdoG84x+ycRWK1vh8HPzLhHiTSmL5Yup12rqKJFx2P5
         e4Cs36G80h4RNKSKUU6sIi1mwHV7HQ9OY7jTGwXtkwHvb3JM1VbWLG2QTcPeDwzwuMe7
         fdTv5IWG/d3hsSCxIQyEtNVIbPu/JtmEP7XKYqW3PDRNNRlyDfmTnLejNmmZb3RHvPY0
         gefO2iuBf8OOod9vMvSLvrMBSMdDdMLwKdkyXHsn5zfVuKt/eX6wUaDlfdesAiWZC3jx
         dwWDCGJ4XfuRdytRTcnucHMs0nbASOaqpKMpMSl9jXrzNv6kQv737WVFF9/FemOWvP9E
         PBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719408283; x=1720013083;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wkp55ahjVZ0Rfp573fGCok3PgZ8FQzhwmhHHebz4g1I=;
        b=Y4IIR1Ncdz14Gb6JwqyO0bSsCWrEGN9enIRMcbKtBQa4l45Od0qcNp7SpxKyAAviIo
         hNK6URq2nAR/1ewjeLnqA8H3tMhTl4wkRE5ubt0a30L4Uqojc0mCjukMZkGl365CMU8U
         nnTApdno+8x/MCP1zAzRSwAL+GdcQuLDZgFD3bfQ3d7uKgKEj03pmhZH190FHxXpDUdn
         kl2VkGjezGzmUxj0oCVNgojNwAOEB1ZXNJbOx+Pn7uwl0aU9rIDDLItkHlsoJJzlXnNQ
         G+bjEpgyanY/UWSUHGgZnLW9epwwZ51/lJSOhtHrML4DeznaXfPNsnbgLADfAVHBGXUi
         eyqA==
X-Forwarded-Encrypted: i=1; AJvYcCWrs5YmzNfMhXgnhbb21hQHk06Y7r9G6ZuBnSaW3hzJKnXtT93qQ8x2x9bqLi6GvzVjxrhnTXVeiW4QjG152BOBcYH8
X-Gm-Message-State: AOJu0Yyhu/Wt8HNVQm17EOm1Utm3mS5Zv2fLPxFU4ZjTIClLNiDCK8fI
	PrnjSpqUZPYlC/yr5ZDz0eZwklm635pBLJKOuKnk0gKHI3eiUloG77qYkDQ7+EE=
X-Google-Smtp-Source: AGHT+IGjUEEcz36KEcz+5nyRJUX3HiZuhEGJ4dUtFILeDTtVRJBPYTVudg8HhkaZzHTox5uiPEmTvA==
X-Received: by 2002:a05:6808:f87:b0:3d2:83:341c with SMTP id 5614622812f47-3d545a89b08mr12556384b6e.51.1719408283452;
        Wed, 26 Jun 2024 06:24:43 -0700 (PDT)
Received: from [100.64.0.1] ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d5344086c5sm2320908b6e.0.2024.06.26.06.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 06:24:42 -0700 (PDT)
Message-ID: <96ff4dd2-db66-4653-80e9-97d4f1381581@sifive.com>
Date: Wed, 26 Jun 2024 08:24:38 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] drivers/perf: riscv: Reset the counter to hpmevent
 mapping while starting cpus
To: Atish Patra <atishp@rivosinc.com>, linux-riscv@lists.infradead.org,
 kvm-riscv@lists.infradead.org
Cc: Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>,
 Conor Dooley <conor.dooley@microchip.com>,
 Palmer Dabbelt <palmer@rivosinc.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
 <20240626-misc_perf_fixes-v3-2-de3f8ed88dab@rivosinc.com>
Content-Language: en-US
From: Samuel Holland <samuel.holland@sifive.com>
In-Reply-To: <20240626-misc_perf_fixes-v3-2-de3f8ed88dab@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-06-26 2:23 AM, Atish Patra wrote:
> From: Samuel Holland <samuel.holland@sifive.com>
> 
> Currently, we stop all the counters while a new cpu is brought online.
> However, the hpmevent to counter mappings are not reset. The firmware may
> have some stale encoding in their mapping structure which may lead to
> undesirable results. We have not encountered such scenario though.
> 

This needs:

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>

otherwise your commit message looks fine to me.

> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index a2e4005e1fd0..94bc369a3454 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -762,7 +762,7 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
>  	 * which may include counters that are not enabled yet.
>  	 */
>  	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
> -		  0, pmu->cmask, 0, 0, 0, 0);
> +		  0, pmu->cmask, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
>  }
>  
>  static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
> 


