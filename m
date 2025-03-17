Return-Path: <kvm+bounces-41223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8B0A64F96
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 873931643D2
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD4F239068;
	Mon, 17 Mar 2025 12:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QheHUrA7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8CB4A1C
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 12:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742215568; cv=none; b=EW4YTtJ7DoznepGnF/xnwfxUH0biC0joTuyHbns5BqPZD1F7k/WCM0nHbjO87zm0y4515/rYwrNF46slNMhTnhkuh65+5OtSJzFvdXj+emb8GWAUZzPNuNnSJTf53v9hlpC5i3LUtrrAg1764jby88FmVh6wzD2O/AlZQTfXbr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742215568; c=relaxed/simple;
	bh=No62E9Fb20g4IyWFYT4C/kZjsHPLrs3YrRmCEjZx3nY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UHf7bH7T1mcBhsTQ8Nhly0qKqnweWrUfd7auZj28Qter5aLcqgmfs4Exok1qN1JV3C/cFKgCuo9NPwl9d9iN9vPm/Zz5c2V2Vwy+u2A+JWts8bzgIPls8BofA0rk5r+iuqe2J+FJ8VNPZomJ58On2eTgi6UFNhhXHBOuyTeY/SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QheHUrA7; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac25520a289so763487066b.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742215564; x=1742820364; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dj4a9Qi675m+cGCP0Z29Kbq/EiuHBxMaswPzVF8DZxc=;
        b=QheHUrA7TDWHWqQiKO0CgrGyIaienrWfJaOBkdwJAL67PL07FMmuBDi17eFJyZ9yBl
         tQQqzKNlDBY1mYCE24B4g5FZOs1rFpu5LktDyvQxAl3I3eDO1/0nDX8Sb6ETzlKU/pEu
         CtAn1bI003VJJsAkwQaXsYgs+AI/Ic6uZL1JJ2e9kIL/8xvGjmmDlzBr5TN6fdLhLuEt
         glJsbjJDyxYw+OJUAWs/rKGaPY+/7wfqynKWLldwT3Wsvioqorl7HjrHqrhfRKOwdcbE
         +aiIlJFalPMvkeaBkAz10P8fhqLteZaMf8X+70C6gq8N9berVQN4+Z4ma26hLk7Ok7Ov
         HSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742215564; x=1742820364;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dj4a9Qi675m+cGCP0Z29Kbq/EiuHBxMaswPzVF8DZxc=;
        b=ObxkrKh6t+nddCr8+2VT+V8a4hnbZYGKKJ5tKnbGwzALhsyKO2G4nYP8BlulpAqPmu
         SoqX9b5PbdbD7awFMeY5PcNwsbyDky/IqZnR7nAJ6s8LcgM0y2655RpHiqbcMFWVSFXZ
         kP+mzE9AmExYEuOO3cWKP0DRxMGVZgXLCwqtfIqmj+PxW0f4qJEzPQGj5ncGWQxQZq/x
         Pf4zL6hkqFrY9yW0Sfs3RpUh3bxh+z37DyIUSSVLkOImKNBVQO22ww08qgY6DpFr/ovy
         K8CMVTqGFXDzOAd9to+H9dFH0QFFA/60Mpjr/yrCextzzCwgR+wzRaYr7EJZxd6QosRS
         6mcQ==
X-Gm-Message-State: AOJu0Yx47UhZmWPC0e8P2hhVePxmKthfOv+2jMs1TwYotfimDi5oTbyc
	ApUrSYdKVFUsFn4YlviQoYAMdYJgTAWdIVK7gOrLlpjQY6q2ODCR1TJICOXiNbI=
X-Gm-Gg: ASbGncthd9STraLdyl/b59lLdSxg0nWC3llZtZktX/GddXgEc/QpFd4jt+4jTllnGke
	qq1OoMQF4yJuXxdHl1+0J7F2jUHslSiL2yzgEhe97vLFNlBK8+2A1cZFjRT4xaV0QbDLcb6Ewdv
	mMq2BppnRjLjlXURaQL6njsWQc3tjDe2RXPvMxlxhREXdlIKgLQPYhqf8pGVkrSgxKhRpsKYnOA
	KrGLf0xjcEIAP7IXzd4AZ025r9KBKhOvWPIenTrahChRqq2qsHy1FsuRGtoaQWO6ERcBlitCLE3
	GQMzoJ/HkebpQDW2nviZq/GYtWRtLM4YulXQLXegWMQ=
X-Google-Smtp-Source: AGHT+IEBfSYbyu2x/HWSGN8ifvpso0WAd1rWQtIFYheckpwUl1S2vd1gFGlAFb8pHIF7kPaMb4Iowg==
X-Received: by 2002:a17:907:a089:b0:ac1:ddaa:2c03 with SMTP id a640c23a62f3a-ac32fb300edmr1419732566b.0.1742215564362;
        Mon, 17 Mar 2025 05:46:04 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3147e9ab1sm667621866b.52.2025.03.17.05.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 05:46:03 -0700 (PDT)
Date: Mon, 17 Mar 2025 13:46:03 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v10 5/8] lib: riscv: add functions to get
 implementer ID and version
Message-ID: <20250317-a53b74017397269b474dd6b9@orel>
References: <20250317101956.526834-1-cleger@rivosinc.com>
 <20250317101956.526834-6-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317101956.526834-6-cleger@rivosinc.com>

On Mon, Mar 17, 2025 at 11:19:51AM +0100, Clément Léger wrote:
> These function will be used by SSE tests to check for a specific opensbi
> version. sbi_impl_check() is an helper allowing to check for a specific
> SBI implementor without needing to check for ret.error.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/sbi.h | 30 ++++++++++++++++++++++++++++++
>  lib/riscv/sbi.c     | 10 ++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 197288c7..06bcec16 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -18,6 +18,19 @@
>  #define SBI_ERR_IO			-13
>  #define SBI_ERR_DENIED_LOCKED		-14
>  
> +#define SBI_IMPL_BBL		0
> +#define SBI_IMPL_OPENSBI	1
> +#define SBI_IMPL_XVISOR		2
> +#define SBI_IMPL_KVM		3
> +#define SBI_IMPL_RUSTSBI	4
> +#define SBI_IMPL_DIOSIX		5
> +#define SBI_IMPL_COFFER		6
> +#define SBI_IMPL_XEN Project	7

s/Project//

> +#define SBI_IMPL_POLARFIRE_HSS	8
> +#define SBI_IMPL_COREBOOT	9
> +#define SBI_IMPL_OREBOOT	10
> +#define SBI_IMPL_BHYVE		11
> +
>  /* SBI spec version fields */
>  #define SBI_SPEC_VERSION_DEFAULT	0x1
>  #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
> @@ -123,6 +136,10 @@ static inline unsigned long sbi_mk_version(unsigned long major, unsigned long mi
>  		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
>  }
>  
> +static inline unsigned long sbi_impl_opensbi_mk_version(unsigned long major, unsigned long minor)
> +{
> +	return ((major << 16) | (minor));

Should at least mask minor, best to mask both.

> +}
>  
>  struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  			unsigned long arg1, unsigned long arg2,
> @@ -139,7 +156,20 @@ struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
>  struct sbiret sbi_send_ipi_broadcast(void);
>  struct sbiret sbi_set_timer(unsigned long stime_value);
>  struct sbiret sbi_get_spec_version(void);
> +struct sbiret sbi_get_imp_version(void);
> +struct sbiret sbi_get_imp_id(void);
>  long sbi_probe(int ext);
>  
> +static inline bool sbi_check_impl(unsigned long impl)
> +{
> +	struct sbiret ret;
> +
> +	ret = sbi_get_imp_id();
> +	if (ret.error)
> +		return false;
> +
> +	return ret.value == impl;

Or, more tersely,

struct sbiret ret = sbi_get_imp_id();
return !ret.error && ret.value == impl;

but an assert would make more sense, since get-impl-id really shouldn't
fail, unless the SBI version is 0.1, which we don't support.

> +}
> +
>  #endif /* !__ASSEMBLER__ */
>  #endif /* _ASMRISCV_SBI_H_ */
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 3c395cff..9cb5757e 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -107,6 +107,16 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>  }
>  
> +struct sbiret sbi_get_imp_version(void)
> +{
> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_get_imp_id(void)
> +{
> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
> +}

Going with error asserts, then we can just put the asserts in these
functions and return ret.value directly, like sbi_probe() does, which
means sbi_check_impl() can be dropped.

Thanks,
drew

> +
>  struct sbiret sbi_get_spec_version(void)
>  {
>  	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
> -- 
> 2.47.2
> 

