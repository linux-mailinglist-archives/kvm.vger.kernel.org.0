Return-Path: <kvm+bounces-10601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A08FD86DD07
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27F851F27037
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7399169E04;
	Fri,  1 Mar 2024 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="nGoccN7C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECBB69DE3
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 08:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709281576; cv=none; b=jDcWNwtgo7c+PkSTmj5rLXM/ilKt57d4barpS3yaRlZdV//WoOF/ALLVpQblZANcVc5ePNUXuEEz5iTRli4H17qhWN3dWO5V4BcFJ58rFhj0fV6ufVq9fKTgMqqgH6sz0frjpI/pB0CzlmKTvjiyObXZ7N05M0KDvbGufCXNilE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709281576; c=relaxed/simple;
	bh=rGugC4CtKyBNC9wfpMo8MLd50utveTzcgNmmqGOwzrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tVawxHEa2hH4Ce379Xe46U0njuq/HV/Ax0/oZl9OaCQhedSGbvWOlRG/ty6Am13ATdqiZnZDFXt4JoFKvpcBc1lLqXkJ89JWFSKkMwFmaYMbAck5FJfF1umJPem92GXdsHxEIWihxrq8m+sUtX4acrShPju+eD18+nBX60quRQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=nGoccN7C; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6e447c39525so414638a34.0
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 00:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709281574; x=1709886374; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f0O2fV0WbAx46xM1Y6qPjUuO/OeNoTHA0KPqbfE4bGA=;
        b=nGoccN7CErqYXvwaklzhOj1brNmcnCXh6XJTx1evZ0OXdE0dfsLfrfIWF4ePNNeWrQ
         uZGTmeMbk/Ki+Wg6lixyv5BEvX5fztrVHXFWbuixWVd7cSR7ydQXt42AlUFi0hiEt0Le
         7D234beEwEK28uNPVwXrw0naedz9oGOOgj6zRdFSTJMMDJX4dtWVZmEbdJcqNiA2IZMS
         Z77JDQaCtMXe+b+RoCJg6Kp0JevfWqqzjBHudfQ9OZySX9q8XAt9GFbSMbwrcL6ijUkE
         uOnkBTr5JJgcxtoBiASdYb2494Vqox2awB3QQlRZVM0L3D7tQj0GVAb+W7mff84fFqyu
         G/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709281574; x=1709886374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f0O2fV0WbAx46xM1Y6qPjUuO/OeNoTHA0KPqbfE4bGA=;
        b=TF8TbfxSSzgBrHWsHXSCux+9S8pAFoXKC/OgA59g2m+O7HJEi7fqoYlSsseO77AfCH
         RrZBXaFQY6H3BUvlQdAFijKNHGJyB7F+k1UiSWxEdfN8u5bVHTRSuCFvf9iZiGsAtfjX
         A+mKiAxT95fMEQfxrVYouXLVBOKj0vJKG7lzIQzXUJAZW5F52OeuRYLrs5DAtpL+lJbY
         hKdENvlAuMMk8QOIyJ347TrHye8+pb0OhS/EMefxqWdrkWyW0QVjT7VLT7JMLQyJ4Oav
         /25Nq2xNleBCtuS8H9c1tpwA+K2eXjdrDjgEo7USQghrAK1ypnSUDPxj9vYs2auTy8Vk
         d3ow==
X-Forwarded-Encrypted: i=1; AJvYcCUaWlg/iUuLuG9ezJnwqd7cC9ozHVjp3hoBFtZSoNEcB3jGf1FdlRHWL/T4LdLEv5EAb6LKTjRRwebvGzf1yk/irBJB
X-Gm-Message-State: AOJu0YwBgGo4aH6MGhsCRoEdrsUOrNNQUZTivU/envGEzNjiqmtOBqMO
	oc5yAlwj04ZqIGd4y9v0rh/uBLP9sXpw7nixnISUJ9ZtdGoEh6DghGdsMpvjAsA=
X-Google-Smtp-Source: AGHT+IEO2VE95MaGXRr6VmSeAK9U9lNiLgxplCLbWJe649iHowWVgQB/IkCDcUSOog4HOG7PQm9Yjw==
X-Received: by 2002:a05:6820:41:b0:5a0:4216:c5f0 with SMTP id v1-20020a056820004100b005a04216c5f0mr887748oob.0.1709281573977;
        Fri, 01 Mar 2024 00:26:13 -0800 (PST)
Received: from ?IPV6:2a01:e0a:999:a3a0:1070:febd:b4af:e79a? ([2a01:e0a:999:a3a0:1070:febd:b4af:e79a])
        by smtp.gmail.com with ESMTPSA id r7-20020aa78b87000000b006e13e202914sm2449292pfd.56.2024.03.01.00.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 00:26:13 -0800 (PST)
Message-ID: <9c466c89-3788-4473-a657-1f117cd5e5ab@rivosinc.com>
Date: Fri, 1 Mar 2024 09:25:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/15] RISC-V: Fix the typo in Scountovf CSR name
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
 <20240229010130.1380926-2-atishp@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20240229010130.1380926-2-atishp@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 29/02/2024 02:01, Atish Patra wrote:
> The counter overflow CSR name is "scountovf" not "sscountovf".
> 
> Fix the csr name.
> 
> Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h         | 2 +-
>  arch/riscv/include/asm/errata_list.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 510014051f5d..603e5a3c61f9 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -281,7 +281,7 @@
>  #define CSR_HPMCOUNTER30H	0xc9e
>  #define CSR_HPMCOUNTER31H	0xc9f
>  
> -#define CSR_SSCOUNTOVF		0xda0
> +#define CSR_SCOUNTOVF		0xda0
>  
>  #define CSR_SSTATUS		0x100
>  #define CSR_SIE			0x104
> diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/asm/errata_list.h
> index ea33288f8a25..cd49eb025ddf 100644
> --- a/arch/riscv/include/asm/errata_list.h
> +++ b/arch/riscv/include/asm/errata_list.h
> @@ -114,7 +114,7 @@ asm volatile(ALTERNATIVE(						\
>  
>  #define ALT_SBI_PMU_OVERFLOW(__ovl)					\
>  asm volatile(ALTERNATIVE(						\
> -	"csrr %0, " __stringify(CSR_SSCOUNTOVF),			\
> +	"csrr %0, " __stringify(CSR_SCOUNTOVF),				\
>  	"csrr %0, " __stringify(THEAD_C9XX_CSR_SCOUNTEROF),		\
>  		THEAD_VENDOR_ID, ERRATA_THEAD_PMU,			\
>  		CONFIG_ERRATA_THEAD_PMU)				\


Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément

