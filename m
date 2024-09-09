Return-Path: <kvm+bounces-26095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2370B970CDA
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 07:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73B24282341
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 05:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5411ACE1F;
	Mon,  9 Sep 2024 05:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZV1rt+vc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D99146D75
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 05:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725858658; cv=none; b=Al6XbnN5ZyEzX06HED9K6jgG6TsbrETfkosnT8y3mUsGsY201krT42aTLpiYnR+vq9PlCS+9jXE66/NoYatxEvuc+y4HGWrf8+mnSVOA7Qf/XNevoKpMM1shWOqJCx6WRzBHQwNYBpNTaWI8WGbugIVZDsIArLYtNclEkzm9tVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725858658; c=relaxed/simple;
	bh=aPhA3WQQa0MxHMNgZPnDAf3yXqc9Gm5YK4bP6eua/BI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NMDzEPtriA4Kmz8qfsb5PdDZlGIiO4piF1GiZ/GjRM4JruGJCCBxpbi6UWzLL1+jmWDXdabn27JUJBGygMhcTAoyx1bdW8HJGPHMRwOeh/btlAF5sCvLFlpGVCmdlnvqBAmslEc40lan7XHpWa26WNgoQEL9VJN/CAkpWhAcg4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZV1rt+vc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725858655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ETrbcC4qgbJQMnMDrmeu5ZmTJyBUS9aQKwjjh3lA/dk=;
	b=ZV1rt+vcFQJTYhqI1sQJiNMGO8IisLeiJLoHXnoopJ7ndipwYvdvYf1ANaNNU8CU1f4enB
	UrD7/HNrEfIC4XDMfC4UVEHbh4efw595YLWxNf4+kCCYx+Ae9JWIpO03T4DUjTwrHlklyv
	ERIjEE27MzphVEGZCq52Srxon8r08jE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-Ao3MNGvVNT625N_ye_q9oQ-1; Mon, 09 Sep 2024 01:10:54 -0400
X-MC-Unique: Ao3MNGvVNT625N_ye_q9oQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-7cbe272efa6so4715628a12.3
        for <kvm@vger.kernel.org>; Sun, 08 Sep 2024 22:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725858653; x=1726463453;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ETrbcC4qgbJQMnMDrmeu5ZmTJyBUS9aQKwjjh3lA/dk=;
        b=lJ7+MkVbjoAOJ7LIZca2E/ATkKKymwW18aeelYv+EHKi9bmOBkDC3GbeHiBHSk0NH+
         eJXQ6Op+bKfAfOyMUIFXJPBGH0mWr5N/gwErC7XwRT9st25SHmVsRy32QBsxTyQg5Jsn
         YgLOwfrWX5p7vcLCR4rF3TXv3RK7kby97YkX/wwNcoPEZ90IsqoIj/sDczG3uzYpO7g9
         0FAEU3MELaxxeOoCNMj5ZX5eUB37bX814ZmwGd5p6sMdBS0kQLr2KOUgE1GOCxi4e1U0
         VzKZyTDoixGeebykPGh7iCBz6vQrGio1PiWYDNiz9kQvPnH7hJtDcW6k7lAewjkgvy4e
         TPtw==
X-Forwarded-Encrypted: i=1; AJvYcCVq162RES7w+ZdOAZD7S0Gr4sQhqVdAjBulqZZG6TRnq38K3niQAY39V3d6DBsX13HhbWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyblAuDRhS8SIpyWhxhFl/2xmzIMnlYSNOIzyCIIE1eAsMqhMvo
	xF3hm7Qdmq9yS1IZ0fjEr8y3b9MY6ogWMd3VxWd4aaS4v4qbA3rMJhAAMgYiF3L6HSBlZrq6Z9y
	XsakSNvjV6NEQlUyL3702jiQgq4bQJcqWhwH5/a6vTtI12+VpSA==
X-Received: by 2002:a05:6a20:43a2:b0:1c6:fb07:381e with SMTP id adf61e73a8af0-1cf2ad43463mr7889418637.44.1725858652867;
        Sun, 08 Sep 2024 22:10:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCkA0En7FW4rczG2AJTNzxPhR60tRcuFH0IUN7mXvz1KNapRWnQAj2YllUSLag5i0bZzjtiw==
X-Received: by 2002:a05:6a20:43a2:b0:1c6:fb07:381e with SMTP id adf61e73a8af0-1cf2ad43463mr7889394637.44.1725858652120;
        Sun, 08 Sep 2024 22:10:52 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710e18eecsm26331565ad.49.2024.09.08.22.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 22:10:51 -0700 (PDT)
Message-ID: <c44e9d4f-9ad2-4ff7-9b18-ede351950149@redhat.com>
Date: Mon, 9 Sep 2024 15:10:42 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/19] arm64: rsi: Add RSI definitions
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-4-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240819131924.372366-4-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:19 PM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by a realm guest through SMC (Realm Services Interface) calls.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0-rc1.
> 
> [1] https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Update to match the latest RMM spec version 1.0-rel0-rc1.
>   * Make use of the ARM_SMCCC_CALL_VAL macro.
>   * Cast using (_UL macro) various values to unsigned long.
> Changes since v3:
>   * Drop invoke_rsi_fn_smc_with_res() function and call arm_smccc_smc()
>     directly instead.
>   * Rename header guard in rsi_smc.h to be consistent.
> Changes since v2:
>   * Rename rsi_get_version() to rsi_request_version()
>   * Fix size/alignment of struct realm_config
> ---
>   arch/arm64/include/asm/rsi_cmds.h | 136 +++++++++++++++++++++
>   arch/arm64/include/asm/rsi_smc.h  | 189 ++++++++++++++++++++++++++++++
>   2 files changed, 325 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rsi_cmds.h
>   create mode 100644 arch/arm64/include/asm/rsi_smc.h
> 

With the following minor comments addressed:

Reviewed-by: Gavin Shan <gshan@redht.com>

> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> new file mode 100644
> index 000000000000..968b03f4e703
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -0,0 +1,136 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RSI_CMDS_H
> +#define __ASM_RSI_CMDS_H
> +
> +#include <linux/arm-smccc.h>
> +
> +#include <asm/rsi_smc.h>
> +
> +#define RSI_GRANULE_SHIFT		12
> +#define RSI_GRANULE_SIZE		(_AC(1, UL) << RSI_GRANULE_SHIFT)
> +
> +enum ripas {
> +	RSI_RIPAS_EMPTY = 0,
> +	RSI_RIPAS_RAM = 1,
> +	RSI_RIPAS_DESTROYED = 2,
> +	RSI_RIPAS_IO = 3,
> +};
> +

The 'RSI_RIPAS_IO' corresponds to 'RIPAS_DEV' defined in tf-rmm/lib/s2tt/include/ripas.h.
Shall we rename it to RSI_RIPAS_DEV so that the name is matched with that defined in
tf-rmm?

---> tf-rmm/lib/s2tt/include/ripas.h

/*
  * The RmmRipas enumeration represents realm IPA state.
  *
  * Map RmmRipas to RmiRipas to simplify code/decode operations.
  */
enum ripas {
         RIPAS_EMPTY = RMI_EMPTY,        /* Unused IPA for Realm */
         RIPAS_RAM = RMI_RAM,            /* IPA used for Code/Data by Realm */
         RIPAS_DESTROYED = RMI_DESTROYED,/* IPA is inaccessible to the Realm */
         RIPAS_DEV                       /* Address where memory of an assigned
                                            Realm device is mapped */
};

> +static inline unsigned long rsi_request_version(unsigned long req,
> +						unsigned long *out_lower,
> +						unsigned long *out_higher)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_RSI_ABI_VERSION, req, 0, 0, 0, 0, 0, 0, &res);
> +
> +	if (out_lower)
> +		*out_lower = res.a1;
> +	if (out_higher)
> +		*out_higher = res.a2;
> +
> +	return res.a0;
> +}
> +
> +static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_RSI_REALM_CONFIG, virt_to_phys(cfg),
> +		      0, 0, 0, 0, 0, 0, &res);
> +	return res.a0;
> +}
> +
> +static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
> +						     phys_addr_t end,
> +						     enum ripas state,
> +						     unsigned long flags,
> +						     phys_addr_t *top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_RSI_IPA_STATE_SET, start, end, state,
> +		      flags, 0, 0, 0, &res);
> +
> +	if (top)
> +		*top = res.a1;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rsi_attestation_token_init - Initialise the operation to retrieve an
> + * attestation token.
> + *
> + * @challenge:	The challenge data to be used in the attestation token
> + *		generation.
> + * @size:	Size of the challenge data in bytes.
> + *
> + * Initialises the attestation token generation and returns an upper bound
> + * on the attestation token size that can be used to allocate an adequate
> + * buffer. The caller is expected to subsequently call
> + * rsi_attestation_token_continue() to retrieve the attestation token data on
> + * the same CPU.
> + *
> + * Returns:
> + *  On success, returns the upper limit of the attestation report size.
> + *  Otherwise, -EINVAL
> + */
> +static inline unsigned long
> +rsi_attestation_token_init(const u8 *challenge, unsigned long size)
> +{
> +	struct arm_smccc_1_2_regs regs = { 0 };
> +
> +	/* The challenge must be at least 32bytes and at most 64bytes */
> +	if (!challenge || size < 32 || size > 64)
> +		return -EINVAL;
> +
> +	regs.a0 = SMC_RSI_ATTESTATION_TOKEN_INIT;
> +	memcpy(&regs.a1, challenge, size);
> +	arm_smccc_1_2_smc(&regs, &regs);
> +
> +	if (regs.a0 == RSI_SUCCESS)
> +		return regs.a1;
> +
> +	return -EINVAL;
> +}
> +

The type of the return value would be 'long' instead of 'unsigned long' since
'-EINVAL' can be returned.

> +/**
> + * rsi_attestation_token_continue - Continue the operation to retrieve an
> + * attestation token.
> + *
> + * @granule: {I}PA of the Granule to which the token will be written.
> + * @offset:  Offset within Granule to start of buffer in bytes.
> + * @size:    The size of the buffer.
> + * @len:     The number of bytes written to the buffer.
> + *
> + * Retrieves up to a RSI_GRANULE_SIZE worth of token data per call. The caller
> + * is expected to call rsi_attestation_token_init() before calling this
> + * function to retrieve the attestation token.
> + *
> + * Return:
> + * * %RSI_SUCCESS     - Attestation token retrieved successfully.
> + * * %RSI_INCOMPLETE  - Token generation is not complete.
> + * * %RSI_ERROR_INPUT - A parameter was not valid.
> + * * %RSI_ERROR_STATE - Attestation not in progress.
> + */
> +static inline int rsi_attestation_token_continue(phys_addr_t granule,
> +						 unsigned long offset,
> +						 unsigned long size,
> +						 unsigned long *len)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RSI_ATTESTATION_TOKEN_CONTINUE,
> +			     granule, offset, size, 0, &res);
> +
> +	if (len)
> +		*len = res.a1;
> +	return res.a0;
> +}
> +
> +#endif /* __ASM_RSI_CMDS_H */
> diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
> new file mode 100644
> index 000000000000..b76b03a8fea8
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi_smc.h
> @@ -0,0 +1,189 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RSI_SMC_H_
> +#define __ASM_RSI_SMC_H_
> +
> +#include <linux/arm-smccc.h>
> +
> +/*
> + * This file describes the Realm Services Interface (RSI) Application Binary
> + * Interface (ABI) for SMC calls made from within the Realm to the RMM and
> + * serviced by the RMM.
> + */
> +
> +/*
> + * The major version number of the RSI implementation.  This is increased when
> + * the binary format or semantics of the SMC calls change.
> + */
> +#define RSI_ABI_VERSION_MAJOR		UL(1)
> +
> +/*
> + * The minor version number of the RSI implementation.  This is increased when
> + * a bug is fixed, or a feature is added without breaking binary compatibility.
> + */
> +#define RSI_ABI_VERSION_MINOR		UL(0)
> +
> +#define RSI_ABI_VERSION			((RSI_ABI_VERSION_MAJOR << 16) | \
> +					 RSI_ABI_VERSION_MINOR)
> +
> +#define RSI_ABI_VERSION_GET_MAJOR(_version) ((_version) >> 16)
> +#define RSI_ABI_VERSION_GET_MINOR(_version) ((_version) & 0xFFFF)
> +
> +#define RSI_SUCCESS		UL(0)
> +#define RSI_ERROR_INPUT		UL(1)
> +#define RSI_ERROR_STATE		UL(2)
> +#define RSI_INCOMPLETE		UL(3)
> +#define RSI_ERROR_UNKNOWN	UL(4)
> +
> +#define SMC_RSI_FID(n)		ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,      \
> +						   ARM_SMCCC_SMC_64,         \
> +						   ARM_SMCCC_OWNER_STANDARD, \
> +						   n)
> +
> +/*
> + * Returns RSI version.
> + *
> + * arg1 == Requested interface revision
> + * ret0 == Status /error
> + * ret1 == Lower implemented interface revision
> + * ret2 == Higher implemented interface revision
> + */
> +#define SMC_RSI_ABI_VERSION	SMC_RSI_FID(0x190)
> +
> +/*
> + * Read feature register.
> + *
> + * arg1 == Feature register index
> + * ret0 == Status /error
               ^^^^^^^^^^^^^
               Status / error

> + * ret1 == Feature register value
> + */
> +#define SMC_RSI_FEATURES			SMC_RSI_FID(0x191)
> +
> +/*
> + * Read measurement for the current Realm.
> + *
> + * arg1 == Index, which measurements slot to read
> + * ret0 == Status / error
> + * ret1 == Measurement value, bytes:  0 -  7
> + * ret2 == Measurement value, bytes:  7 - 15
                                          ^^^^^^
                                          8 - 15

> + * ret3 == Measurement value, bytes: 16 - 23
> + * ret4 == Measurement value, bytes: 24 - 31
> + * ret5 == Measurement value, bytes: 32 - 39
> + * ret6 == Measurement value, bytes: 40 - 47
> + * ret7 == Measurement value, bytes: 48 - 55
> + * ret8 == Measurement value, bytes: 56 - 63
> + */
> +#define SMC_RSI_MEASUREMENT_READ		SMC_RSI_FID(0x192)
> +
> +/*
> + * Extend Realm Extensible Measurement (REM) value.
> + *
> + * arg1  == Index, which measurements slot to extend
> + * arg2  == Size of realm measurement in bytes, max 64 bytes
> + * arg3  == Measurement value, bytes:  0 -  7
> + * arg4  == Measurement value, bytes:  7 - 15
                                           ^^^^^^
                                           8 - 15

> + * arg5  == Measurement value, bytes: 16 - 23
> + * arg6  == Measurement value, bytes: 24 - 31
> + * arg7  == Measurement value, bytes: 32 - 39
> + * arg8  == Measurement value, bytes: 40 - 47
> + * arg9  == Measurement value, bytes: 48 - 55
> + * arg10 == Measurement value, bytes: 56 - 63
> + * ret0  == Status / error
> + */
> +#define SMC_RSI_MEASUREMENT_EXTEND		SMC_RSI_FID(0x193)
> +
> +/*
> + * Initialize the operation to retrieve an attestation token.
> + *
> + * arg1 == Challenge value, bytes:  0 -  7
> + * arg2 == Challenge value, bytes:  7 - 15
                                        ^^^^^^
                                        8 - 15

> + * arg3 == Challenge value, bytes: 16 - 23
> + * arg4 == Challenge value, bytes: 24 - 31
> + * arg5 == Challenge value, bytes: 32 - 39
> + * arg6 == Challenge value, bytes: 40 - 47
> + * arg7 == Challenge value, bytes: 48 - 55
> + * arg8 == Challenge value, bytes: 56 - 63
> + * ret0 == Status / error
> + * ret1 == Upper bound of token size in bytes
> + */
> +#define SMC_RSI_ATTESTATION_TOKEN_INIT		SMC_RSI_FID(0x194)
> +
> +/*
> + * Continue the operation to retrieve an attestation token.
> + *
> + * arg1 == The IPA of token buffer
> + * arg2 == Offset within the granule of the token buffer
> + * arg3 == Size of the granule buffer
> + * ret0 == Status / error
> + * ret1 == Length of token bytes copied to the granule buffer
> + */
> +#define SMC_RSI_ATTESTATION_TOKEN_CONTINUE	SMC_RSI_FID(0x195)
> +
> +#ifndef __ASSEMBLY__
> +
> +struct realm_config {
> +	union {
> +		struct {
> +			unsigned long ipa_bits; /* Width of IPA in bits */
> +			unsigned long hash_algo; /* Hash algorithm */
> +		};
> +		u8 pad[0x200];
> +	};
> +	union {
> +		u8 rpv[64]; /* Realm Personalization Value */
> +		u8 pad2[0xe00];
> +	};
> +	/*
> +	 * The RMM requires the configuration structure to be aligned to a 4k
> +	 * boundary, ensure this happens by aligning this structure.
> +	 */
> +} __aligned(0x1000);
> +
> +#endif /* __ASSEMBLY__ */
> +
> +/*
> + * Read configuration for the current Realm.
> + *
> + * arg1 == struct realm_config addr
> + * ret0 == Status / error
> + */
> +#define SMC_RSI_REALM_CONFIG			SMC_RSI_FID(0x196)
> +
> +/*
> + * Request RIPAS of a target IPA range to be changed to a specified value.
> + *
> + * arg1 == Base IPA address of target region
> + * arg2 == Top of the region
> + * arg3 == RIPAS value
> + * arg4 == flags
> + * ret0 == Status / error
> + * ret1 == Top of modified IPA range
> + */
> +#define SMC_RSI_IPA_STATE_SET			SMC_RSI_FID(0x197)
> +
> +#define RSI_NO_CHANGE_DESTROYED			UL(0)
> +#define RSI_CHANGE_DESTROYED			UL(1)
> +

According to the linked specification, the description for the third return value
has been missed here.

ret2 == Whether the host accepted or rejected the request

> +/*
> + * Get RIPAS of a target IPA range.
> + *
> + * arg1 == Base IPA of target region
> + * arg2 == End of target IPA region
> + * ret0 == Status / error
> + * ret1 == Top of IPA region which has the reported RIPAS value
> + * ret2 == RIPAS value
> + */
> +#define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
> +
> +/*
> + * Make a Host call.
> + *
> + * arg1 == IPA of host call structure
> + * ret0 == Status / error
> + */
> +#define SMC_RSI_HOST_CALL			SMC_RSI_FID(0x199)
> +
> +#endif /* __ASM_RSI_SMC_H_ */

Thanks,
Gavin


