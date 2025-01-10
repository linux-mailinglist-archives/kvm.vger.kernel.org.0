Return-Path: <kvm+bounces-35137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CDFA09ECE
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:47:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A5B37A44BC
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD4622257C;
	Fri, 10 Jan 2025 23:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Bd+AchDl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC20E1ACEB8
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 23:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736552868; cv=none; b=FXmpYpN9AshDAzF61XqmUrCur5abOvDfyzAJZC+SZPwUYMKluRbEQmiYA43rogmSabJTXx+vWg6PVw/tWMCwLQTF1013/k6u20yxYLzNq5pupBtu0p7jwzmaeH3GosCiAsHq+VKz/WXZm+CH+TcLxOxDi55rwWQbTU/pzp4xF7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736552868; c=relaxed/simple;
	bh=9Bh4dh+03/jLiIS4sK1fKcIYfTDN2f35KLErB4mqqkQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=SjXuH79fBG7s/2FJdS9cC+LcYQezvCdEoNIXJ6i+puD2O8IjQOar1HxMDuUZ8p2/kxw0ebRaetOSci4SVDqwqS8L4yqlSuuOfs0tZY4/atqG2BkkAaOhpQHTzw2vfpNMWA9eBS90hHbaCGz/xPt0EBENzy2h+aHhgE+Dn1UxRZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=Bd+AchDl; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-84a1ce51187so76264739f.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 15:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1736552866; x=1737157666; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E7FhfTgUDsdvAshb7Fbz0DWhP2Rg10//miG1n5hHZBE=;
        b=Bd+AchDlmQ65qd/dob4CI+d/M0CafkmAnmQFL+R8u5crro1o3kLt2HO8RJp7jeRDP8
         kz2uE819knn5mwm4/bdbesZdEXBgjfWqIvUotsoFBxfxmXzoWuTvriKiuMiaoEFC9oK0
         5PQDaFovfx/nuJNc5/ibTujmAmMjCbYtc2Bu0PGpoch7JFErjmjQlUmGX9RwW2HBlwlq
         zu48wGzu0QJFZ4U6VS6t9xjU/vuyqSsp2HZcMjsHZuB1wfYiU7KihAeRVRgjeC8Jy5vp
         yZEWw++sQoFT2w+vRlpozlwv560/b+3hRFranw4lbcwPq+jdQJ8s1ri1G3osXldK42Kn
         WXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736552866; x=1737157666;
        h=content-transfer-encoding:in-reply-to:cc:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E7FhfTgUDsdvAshb7Fbz0DWhP2Rg10//miG1n5hHZBE=;
        b=UMnSbR4LS787J3LWSIXZnqVQv/zoGe4nf4Lif6yrrBqUnzImB+eKuf0mnodQQenfz5
         bDOHEb3KuDi/1o7jSODUjLX0VnaHHd/8UKOJuL6OZaiMincUqUBMinkVb7yA/QGn3E4y
         dMl8dDAsZwykPD7rHvMWC3WBceqUmQu082IejRXEfBvMbTzaeP1HNbUWjp4YPdLGA6jZ
         5NRsmodf/GxHCbP7WC6bapVDDr/yEZVtj7ObOFJKQPvaMZ6Zyed0vJgsV600g6cnFGtf
         aBqQK7oAr6vYTzNFIDpdJPZ0Bq8SfS8dE1Kx2E+cTesAvwvVj1C8ltnBrKh2gO3R34Ew
         SCxw==
X-Forwarded-Encrypted: i=1; AJvYcCXCfupisoGYKPc/7WRwFL/n0vcD2Uqk1h9wOZtoqP9f1voPncUhdrTEgdxZY4QubKaWwow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEJ3TTcHtzfTyNOKkvWZ0n5DBscbJ1RYw/2env7130LIy4SKQn
	Z+vKYUXZlvGGA1oNhsTVrFluoKfOb1cGQV1b90z5iyw60duuwcvRlnipS19Gt58=
X-Gm-Gg: ASbGncut/bRLVFmDD8vi9A9JKHdUKaO4+a7etLtUomg4VgHcxElggYugvUHpYD/+nbu
	3NtkVvbz152JaXe+Az8FR9CtzN7fH52vLRwTQ3oFFNN9OJFv5o15zExQYBY4dSCjpTD3Xt2ZvTO
	vpc2YTaEEl7hiICFpB8sSACil4qlyMi05EfIbRINuk4VXxq6uU3ZtgCTExKmbAQjhXt5yRX6SDc
	TNPUIayy1fkUyfOt8ouvjDB6oKItAbxZxwH8dwTxarw5iXmMcqTJ7hXw2HypKJFtQ3mbZpCdacA
	Qg6+
X-Google-Smtp-Source: AGHT+IHc3hawEH72BOuREBbr9aM6RiuMYEkEBgMor65OdodG3NV8W/0PQoOelCZBrCJNuv+/uKZ03A==
X-Received: by 2002:a05:6602:751a:b0:83d:ff89:218c with SMTP id ca18e2360f4ac-84ce00b8a80mr1181590939f.7.1736552865857;
        Fri, 10 Jan 2025 15:47:45 -0800 (PST)
Received: from [100.64.0.1] ([165.188.116.9])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84d61fc811esm114615839f.42.2025.01.10.15.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 15:47:45 -0800 (PST)
Message-ID: <65f1b520-5d0d-4494-b3f5-1d3e3265a762@sifive.com>
Date: Fri, 10 Jan 2025 17:47:43 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] RISC-V: KVM: add support for FWFT SBI extension
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-5-cleger@rivosinc.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
In-Reply-To: <20250106154847.1100344-5-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Clément,

This looks good to me, but will need changes for the updated semantics of the
LOCK flag. One minor comment below.

On 2025-01-06 9:48 AM, Clément Léger wrote:
> Add basic infrastructure to support the FWFT extension in KVM.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h          |   4 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h      |   1 +
>  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  37 +++++
>  arch/riscv/include/uapi/asm/kvm.h          |   1 +
>  arch/riscv/kvm/Makefile                    |   1 +
>  arch/riscv/kvm/vcpu_sbi.c                  |   4 +
>  arch/riscv/kvm/vcpu_sbi_fwft.c             | 176 +++++++++++++++++++++
>  7 files changed, 224 insertions(+)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 35eab6e0f4ae..9bd046ed7907 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>  #include <asm/kvm_vcpu_fp.h>
>  #include <asm/kvm_vcpu_insn.h>
>  #include <asm/kvm_vcpu_sbi.h>
> +#include <asm/kvm_vcpu_sbi_fwft.h>
>  #include <asm/kvm_vcpu_timer.h>
>  #include <asm/kvm_vcpu_pmu.h>
>  
> @@ -276,6 +277,9 @@ struct kvm_vcpu_arch {
>  	/* Performance monitoring context */
>  	struct kvm_pmu pmu_context;
>  
> +	/* Firmware feature SBI extension context */
> +	struct kvm_sbi_fwft fwft_context;
> +
>  	/* 'static' configurations which are set only once */
>  	struct kvm_vcpu_config cfg;
>  
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 8c465ce90e73..7ff200a1ad3b 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -95,6 +95,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
>  
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> new file mode 100644
> index 000000000000..5782517f6e08
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025 Rivos Inc.
> + *
> + * Authors:
> + *     Clément Léger <cleger@rivosinc.com>
> + */
> +
> +#ifndef __KVM_VCPU_RISCV_FWFT_H
> +#define __KVM_VCPU_RISCV_FWFT_H
> +
> +#include <asm/sbi.h>
> +
> +struct kvm_sbi_fwft_config;
> +struct kvm_vcpu;
> +
> +struct kvm_sbi_fwft_feature {
> +	enum sbi_fwft_feature_t id;
> +	bool (*supported)(struct kvm_vcpu *vcpu);
> +	int (*set)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long value);
> +	int (*get)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long *value);
> +};
> +
> +struct kvm_sbi_fwft_config {
> +	const struct kvm_sbi_fwft_feature *feature;
> +	bool supported;
> +	unsigned long flags;
> +};
> +
> +/* FWFT data structure per vcpu */
> +struct kvm_sbi_fwft {
> +	struct kvm_sbi_fwft_config *configs;
> +};
> +
> +#define vcpu_to_fwft(vcpu) (&(vcpu)->arch.fwft_context)
> +
> +#endif /* !__KVM_VCPU_RISCV_FWFT_H */
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 3482c9a73d1b..0813145a6272 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -198,6 +198,7 @@ enum KVM_RISCV_SBI_EXT_ID {
>  	KVM_RISCV_SBI_EXT_VENDOR,
>  	KVM_RISCV_SBI_EXT_DBCN,
>  	KVM_RISCV_SBI_EXT_STA,
> +	KVM_RISCV_SBI_EXT_FWFT,
>  	KVM_RISCV_SBI_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 0fb1840c3e0a..ece6b119913a 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -32,6 +32,7 @@ kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_sta.o
>  kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
>  kvm-y += vcpu_switch.o
> +kvm-y += vcpu_sbi_fwft.o

nit: this should go with the other vcpu_sbi_* files.

Regards,
Samuel

>  kvm-y += vcpu_timer.o
>  kvm-y += vcpu_vector.o
>  kvm-y += vm.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index d2dbb0762072..5bf6c92cca5b 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -74,6 +74,10 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
>  		.ext_idx = KVM_RISCV_SBI_EXT_STA,
>  		.ext_ptr = &vcpu_sbi_ext_sta,
>  	},
> +	{
> +		.ext_idx = KVM_RISCV_SBI_EXT_FWFT,
> +		.ext_ptr = &vcpu_sbi_ext_fwft,
> +	},
>  	{
>  		.ext_idx = KVM_RISCV_SBI_EXT_EXPERIMENTAL,
>  		.ext_ptr = &vcpu_sbi_ext_experimental,
> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
> new file mode 100644
> index 000000000000..55433e805baa
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
> @@ -0,0 +1,176 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2025 Rivos Inc.
> + *
> + * Authors:
> + *     Clément Léger <cleger@rivosinc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <asm/cpufeature.h>
> +#include <asm/sbi.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +#include <asm/kvm_vcpu_sbi_fwft.h>
> +
> +static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] = {
> +	SBI_FWFT_MISALIGNED_EXC_DELEG,
> +	SBI_FWFT_LANDING_PAD,
> +	SBI_FWFT_SHADOW_STACK,
> +	SBI_FWFT_DOUBLE_TRAP,
> +	SBI_FWFT_PTE_AD_HW_UPDATING,
> +	SBI_FWFT_POINTER_MASKING_PMLEN,
> +};
> +
> +static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(kvm_fwft_defined_features); i++) {
> +		if (kvm_fwft_defined_features[i] == feature)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +static const struct kvm_sbi_fwft_feature features[] = {
> +};
> +
> +static struct kvm_sbi_fwft_config *
> +kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t feature)
> +{
> +	int i = 0;
> +	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
> +
> +	for (i = 0; i < ARRAY_SIZE(features); i++) {
> +		if (fwft->configs[i].feature->id == feature)
> +			return &fwft->configs[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +static int kvm_fwft_get_feature(struct kvm_vcpu *vcpu,
> +				enum sbi_fwft_feature_t feature,
> +				struct kvm_sbi_fwft_config **conf)
> +{
> +	struct kvm_sbi_fwft_config *tconf;
> +
> +	tconf = kvm_sbi_fwft_get_config(vcpu, feature);
> +	if (!tconf) {
> +		if (kvm_fwft_is_defined_feature(feature))
> +			return SBI_ERR_NOT_SUPPORTED;
> +
> +		return SBI_ERR_DENIED;
> +	}
> +
> +	if (!tconf->supported)
> +		return SBI_ERR_NOT_SUPPORTED;
> +
> +	*conf = tconf;
> +
> +	return SBI_SUCCESS;
> +}
> +
> +static int kvm_sbi_fwft_set(struct kvm_vcpu *vcpu,
> +			    enum sbi_fwft_feature_t feature,
> +			    unsigned long value, unsigned long flags)
> +{
> +	int ret;
> +	struct kvm_sbi_fwft_config *conf;
> +
> +	ret = kvm_fwft_get_feature(vcpu, feature, &conf);
> +	if (ret)
> +		return ret;
> +
> +	if ((flags & ~SBI_FWFT_SET_FLAG_LOCK) != 0)
> +		return SBI_ERR_INVALID_PARAM;
> +
> +	if (conf->flags & SBI_FWFT_SET_FLAG_LOCK)
> +		return SBI_ERR_DENIED;
> +
> +	conf->flags = flags;
> +
> +	return conf->feature->set(vcpu, conf, value);
> +}
> +
> +static int kvm_sbi_fwft_get(struct kvm_vcpu *vcpu,
> +			    enum sbi_fwft_feature_t feature,
> +			    unsigned long *value)
> +{
> +	int ret;
> +	struct kvm_sbi_fwft_config *conf;
> +
> +	ret = kvm_fwft_get_feature(vcpu, feature, &conf);
> +	if (ret)
> +		return ret;
> +
> +	return conf->feature->get(vcpu, conf, value);
> +}
> +
> +static int kvm_sbi_ext_fwft_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +				    struct kvm_vcpu_sbi_return *retdata)
> +{
> +	int ret = 0;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	unsigned long funcid = cp->a6;
> +
> +	switch (funcid) {
> +	case SBI_EXT_FWFT_SET:
> +		ret = kvm_sbi_fwft_set(vcpu, cp->a0, cp->a1, cp->a2);
> +		break;
> +	case SBI_EXT_FWFT_GET:
> +		ret = kvm_sbi_fwft_get(vcpu, cp->a0, &retdata->out_val);
> +		break;
> +	default:
> +		ret = SBI_ERR_NOT_SUPPORTED;
> +		break;
> +	}
> +
> +	retdata->err_val = ret;
> +
> +	return 0;
> +}
> +
> +static int kvm_sbi_ext_fwft_init(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
> +	const struct kvm_sbi_fwft_feature *feature;
> +	struct kvm_sbi_fwft_config *conf;
> +	int i;
> +
> +	fwft->configs = kcalloc(ARRAY_SIZE(features), sizeof(struct kvm_sbi_fwft_config),
> +				GFP_KERNEL);
> +	if (!fwft->configs)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < ARRAY_SIZE(features); i++) {
> +		feature = &features[i];
> +		conf = &fwft->configs[i];
> +		if (feature->supported)
> +			conf->supported = feature->supported(vcpu);
> +		else
> +			conf->supported = true;
> +
> +		conf->feature = feature;
> +	}
> +
> +	return 0;
> +}
> +
> +static void kvm_sbi_ext_fwft_deinit(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
> +
> +	kfree(fwft->configs);
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft = {
> +	.extid_start = SBI_EXT_FWFT,
> +	.extid_end = SBI_EXT_FWFT,
> +	.handler = kvm_sbi_ext_fwft_handler,
> +	.init = kvm_sbi_ext_fwft_init,
> +	.deinit = kvm_sbi_ext_fwft_deinit,
> +};


