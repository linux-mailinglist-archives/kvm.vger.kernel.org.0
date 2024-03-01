Return-Path: <kvm+bounces-10602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D4286DD11
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:27:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0583D1F21BB2
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B1569D25;
	Fri,  1 Mar 2024 08:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="M81FT9RJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4F969D13
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709281664; cv=none; b=sNIKpQ462Ew+yo5UnyyZEeVz9RHODwiphGkK8WTCIjFF80MiPeRDiXld8bnSukFPCsOL7m6mFCiVeLeUoDQ+OlgCs7KRzPTRNr1ChMD9PuOMliaHA4biSkuGz6rex1HpdID6/lFbCfRqA/cm3q1LuLFXoKdocYQANpvYTZ3fpSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709281664; c=relaxed/simple;
	bh=XqfNJZAlUlGhU0tMLlsUHrVl8hhs+fFQE6upJ67bxBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sP1VK5KL1WQBwW95H1JMK8B2DDmsE+cYYUEfcuPH6UeqL4yGOGAoT4j8EdTD94vswfTj+4/A+Mf7/7rvvzjgVPTVjHNFWH7G2hVfa+1PYouOgsCCX0Z+nxgBWh0hJmtkyKyvPsYkhYti8SK/NTtHQim3drqNod3Dyh0bNrFHdp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=M81FT9RJ; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3bc21303a35so577132b6e.0
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 00:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709281661; x=1709886461; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u+1gYR9fNMcL6Yz70ujlHI/EnqcOVjeumCs1fZJGDkY=;
        b=M81FT9RJhuS9Xgc+mQidbYySp/9ztKdkjneZ+/Fya+5wAZ2jd4T5TT7PxYjUJNrVtQ
         7nJ/ydMd8Lekbv9o+1sTbDzdvUa8jceAfl9NfegRUmgj0VsFOUQqjQXXsUB52qO35QwW
         ibxtKFAZHEe1WFrNVSAjnlYdCILBObuCHZLZ1KW03DEUl0QyLficwx7qfOz4rBYgUn17
         dmNlOlW5+E+pGHMIBw1ZeX7VGsrlepDADzU0ymBY5wyb18VL3tiebKSN8LENyRDfv3Us
         xyM5DOCAMYwDultm2kbe4gnDu6tbxFmbn4W6aYjHEvqBtcuOwoXG5ejfvuhmh9IXBY4s
         f8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709281661; x=1709886461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+1gYR9fNMcL6Yz70ujlHI/EnqcOVjeumCs1fZJGDkY=;
        b=VyfzhpwUz0qZR79CoBT+vDQ9FMSPcE1u65wbkvorkFdSwpwX5Dmidb5rFUjRZSquk9
         r5x3P5kQRMKGXL/rHgRzhhSE/QlJt/98D+GghyN4QRR1nwkNaPLeGqpkGewLmXNK3rVj
         hXHZ7IWGN9cZd1ljaD0o6fqbyIPzORxk7ab8j85NuubeKMNnULHZhsw0PIVpE4apyxK0
         Xkg0xR0SxiO2V93ydLbYF5akSN00fhdXM/+vIolQmf0ixIl6EEZh7imsbl6oB77rRnJJ
         JSzoXPwpB5O6/72gKGfrV4viQ7HLF/mBpQoSClVILXkG6CubLIvmaC+GdUvHZsqQDWqK
         LknA==
X-Forwarded-Encrypted: i=1; AJvYcCU5JmHlsFeVlk73j8ms3x9L5g4LUjX06UNcv2JMWtA64Ix91cI4NovHrX3fg8zMn4D2T5ZJVBQZpKi8GnlU4wOIrcU2
X-Gm-Message-State: AOJu0YzWXUMTbme2jhclJPoPOsOc9qCdiMHVxi6FCKeQ0zW6kBvAIt8C
	tphdd9Am6MoGlcRZ3/K3exiFctd2wgPNZalxAlLOaoDww8ptu3i8sdphEQMI2yc=
X-Google-Smtp-Source: AGHT+IEdyiT1lfztdP7slsQZvQ1H9ibF+1htyyfiSkFgE7uzu3qWKNguG9y0uIjwtsPG01jsOQ/DmQ==
X-Received: by 2002:a05:6808:211a:b0:3c1:aa85:7ab4 with SMTP id r26-20020a056808211a00b003c1aa857ab4mr1284563oiw.3.1709281661587;
        Fri, 01 Mar 2024 00:27:41 -0800 (PST)
Received: from ?IPV6:2a01:e0a:999:a3a0:1070:febd:b4af:e79a? ([2a01:e0a:999:a3a0:1070:febd:b4af:e79a])
        by smtp.gmail.com with ESMTPSA id r7-20020aa78b87000000b006e13e202914sm2449292pfd.56.2024.03.01.00.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 00:27:40 -0800 (PST)
Message-ID: <8e3003f0-ec27-47d4-9b1f-89de2afbb8b8@rivosinc.com>
Date: Fri, 1 Mar 2024 09:27:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/15] RISC-V: Add FIRMWARE_READ_HI definition
Content-Language: en-US
To: Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kselftest@vger.kernel.org,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Conor Dooley <conor.dooley@microchip.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Guo Ren <guoren@kernel.org>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, linux-riscv@lists.infradead.org,
 Shuah Khan <shuah@kernel.org>, Andrew Jones <ajones@ventanamicro.com>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
 <20240229010130.1380926-3-atishp@rivosinc.com>
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20240229010130.1380926-3-atishp@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 29/02/2024 02:01, Atish Patra wrote:
> SBI v2.0 added another function to SBI PMU extension to read
> the upper bits of a counter with width larger than XLEN.
> 
> Add the definition for that function.
> 
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 6e68f8dff76b..ef8311dafb91 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -131,6 +131,7 @@ enum sbi_ext_pmu_fid {
>  	SBI_EXT_PMU_COUNTER_START,
>  	SBI_EXT_PMU_COUNTER_STOP,
>  	SBI_EXT_PMU_COUNTER_FW_READ,
> +	SBI_EXT_PMU_COUNTER_FW_READ_HI,
>  };
>  
>  union sbi_pmu_ctr_info {

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément

