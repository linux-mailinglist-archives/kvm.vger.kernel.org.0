Return-Path: <kvm+bounces-14643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC41C8A50E6
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93E9D1F20FA7
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2B81272AE;
	Mon, 15 Apr 2024 13:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jdyoAfd1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A9A757FD
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186110; cv=none; b=Bj3QO5FW12XEGsZiKS733p54fZNEqHl0AHS1rRWiT1e0AsqzSmECilW0KrY6DikX0Vpb8DQKI0RiqtoH5BNHZEEmfh3ZIrJCuclq203xNuWbWB//Uy8wN7opm1749nRKGdqEJSgm/z5GPynC5DvgolxrSrbpsZTdb7id72gp0/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186110; c=relaxed/simple;
	bh=htFP120gjn5bGGk+lM2AXxOpa6zNGkVhobl+AAmgTfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DymRtVxquGBsVm2FyiQ+g/+wU60K96AyY+DWq0VyISW1lgoEMLS0puDmUjCLTOkyjBePmqkW5PXfB/EcK/eueJW3uO5Knf2QPfJoaZwx3bbblIkILhGjeYzQqwva3QaKGhnTDu/7Mvc25mU7FLEqgTerjdxiDIjocrZafM1sIDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jdyoAfd1; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-516d727074eso4070925e87.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1713186103; x=1713790903; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JAzNe/Dr2zrsI9zQzFBtyYItApxCRsnWpljg+FQj6uo=;
        b=jdyoAfd1MxoPLVCGlGc/r3BKMlWWnP8t9Gnw2/NMHZgBTIKPwhkVcYlnI0uNHWZZA7
         QIlNenptnQNcuPxpPu9iAnGiTYdbvT8Di73Nlf4ZbfRKUV9pL/chlrHYPdYGnuJBARmA
         Vmvx6W+P1ks2COOnJsqTf4/DuHbvxYp3EN1hy8wzcrigaWEwtivYnkGIDgDZN49KwiB4
         A1mXUceZOyNFlS5/SVDtpb5+4WKBv2K5PzMxmXrCueV0MDHwNaYxpa8P1SRCNt7YB13Q
         56uVANo3NioCR6bv5eY/ARsg0fMZ67p8lFUuQfSDXQ3q6gKY2HQocvxIblnirf8CI5zI
         WzHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713186103; x=1713790903;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JAzNe/Dr2zrsI9zQzFBtyYItApxCRsnWpljg+FQj6uo=;
        b=xUJiuRgzZtTS9ZU3LAJKsV/VQydZNoBNAZzgGkDUy11jx2/LEEzPqGTTUC0qEuNLoJ
         uttY0nopjVk/hekdrsL8ykBDcEyvkZvon2eP2CXQ50J3Bctl8zHYHzIn0YGfyVKn7aGu
         T+XCxD26xywLwYTVqimUGEA9rmz/B2sWti+ocZuxN1lE7yeBfxIVxfknlvBG3ITpVWqX
         b4HXlrnk7zeXTDJ/ZjBhTswUdF48VkdhgSug5+Q2HqIarwHEaBhlA+faJYiyduvSrGm1
         7rp3oTnUZsk3hbiH3Re/1XFoCWf8WZuJGTynU4EHgmjax1jxrA1LuN7NW0MNiYU4yIbR
         Ug7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgh1F9OoxJX64MjGsNbr+GyC9XXnKfBvvlYIrm/H35p0tKEmwD6XRjxZTc6tfLgFuC8mJERKec8p8jbYJTlv8L0dJX
X-Gm-Message-State: AOJu0YyrZxgZn0VuK7ucDdaoEqy8tAnHi3pUXNRyr/T2o1oixssCWf+E
	hLgUZevhqbZeoBHI77hl/zCAP8m/ithdszZNP7ajNPiRtGyUd20DPQQkMSwalGsIUmsxANjaQL/
	A
X-Google-Smtp-Source: AGHT+IF1FG1SINFeCjGlp0eZOZIZwVeoNZP8XYe8YPY4t8v9NbI69LFZuWlNvlzfivwxMIckGeJs1Q==
X-Received: by 2002:a2e:b4a8:0:b0:2d8:6b0c:d91c with SMTP id q8-20020a2eb4a8000000b002d86b0cd91cmr5501216ljm.47.1713186103351;
        Mon, 15 Apr 2024 06:01:43 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id r9-20020adff109000000b00341de3abb0esm11994830wro.20.2024.04.15.06.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 06:01:42 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:01:42 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, 
	=?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Anup Patel <anup@brainfault.org>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Atish Patra <atishp@atishpatra.org>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	x86@kernel.org
Subject: Re: [PATCH v6 01/24] RISC-V: Fix the typo in Scountovf CSR name
Message-ID: <20240415-b899e62329c901f59db9f146@orel>
References: <20240411000752.955910-1-atishp@rivosinc.com>
 <20240411000752.955910-2-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240411000752.955910-2-atishp@rivosinc.com>

On Wed, Apr 10, 2024 at 05:07:29PM -0700, Atish Patra wrote:
> The counter overflow CSR name is "scountovf" not "sscountovf".
> 
> Fix the csr name.
> 
> Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
> Reviewed-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h | 2 +-
>  drivers/perf/riscv_pmu_sbi.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 2468c55933cd..9d1b07932794 100644
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
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 8cbe6e5f9c39..3e44d2fb8bf8 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -27,7 +27,7 @@
>  
>  #define ALT_SBI_PMU_OVERFLOW(__ovl)					\
>  asm volatile(ALTERNATIVE_2(						\
> -	"csrr %0, " __stringify(CSR_SSCOUNTOVF),			\
> +	"csrr %0, " __stringify(CSR_SCOUNTOVF),				\
>  	"csrr %0, " __stringify(THEAD_C9XX_CSR_SCOUNTEROF),		\
>  		THEAD_VENDOR_ID, ERRATA_THEAD_PMU,			\
>  		CONFIG_ERRATA_THEAD_PMU,				\
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

