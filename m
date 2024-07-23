Return-Path: <kvm+bounces-22088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D813B93999D
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 08:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BEC41F2251F
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 06:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DCD13D608;
	Tue, 23 Jul 2024 06:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITRf2ckN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C5E1E4BE
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 06:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721715779; cv=none; b=ThGIw4L/wA5+5YPhzhCu4Fg6AI8g5+AS7zWnExGv2PO6AwfFVrTBpyPE7CsEEyMMNyY7dK/4wqIJ/4jikOjI7KqsvdGZgHVr3V8WMfJzDkuY3khqx/UzQEvZG0yzrQ3q2Gt/HYfEBOm1T/hE/CChrZ01Wf6kLe5k0xqeKqc3YBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721715779; c=relaxed/simple;
	bh=P92MH8B5c9jvC2bnTPtRev2aH6tP4Y8mmGyv/5o49CY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fIr/ImA89ga1Xcc3MzKI2xvwk3ugW9Iig2vgXH43QtJK0hCwlEgQUOlhgrK5cLNennbBgEufPJOxdzgXEJ3uTUuvf7k6NsjUgZ/zeMlUPDLB82r4xsNhXKnxRVPlcAYJIN00yMwYms0KULtbG6t4rqnlqRDQ/q78rywuQlA/6r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ITRf2ckN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721715777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hcTfow7Oo6i9Jk5NtqEjESkJCNqoSWX8VZs+T25c+9Y=;
	b=ITRf2ckNV1dCCHxL7Ho7PYG886JN2kYSJ7wmy8EFv5ApgJ4njEYwDExxVBTLGKZtJnVBw/
	ZnjMviRT3lVlVcR+mF9kECceTZevwYa04rUtWytxmVV00NygsqdRhzgjIK4PkO0KDMoXRS
	b8cws2Kj/SGAw5mHdXJ32d+USPHnCAA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-DibEEXihNEC3Ul4jbrPhZA-1; Tue, 23 Jul 2024 02:22:55 -0400
X-MC-Unique: DibEEXihNEC3Ul4jbrPhZA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1fc58790766so3773735ad.3
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 23:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721715774; x=1722320574;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hcTfow7Oo6i9Jk5NtqEjESkJCNqoSWX8VZs+T25c+9Y=;
        b=nL0BD8B+M2NX8191AczTVHscrYZr14snYF3lkO3gmyNmPJBIqQolsPCZAqu90Cdd0s
         A++NRsnAA3ou1HVbCJN6frp2wwIdOOqbnSsaios5o/f0SY8PTrymMqLaXxkjlu1w/gCL
         3+VcJNUg5ITaKUsSJunJMfBPSvZumDU9uQP9sl7QK2L+T6dMay9FtlwrDCMs8AR12QVz
         9ceq/1UBNjwPgA3eTq7LPGzcGr81UI/KRWOBGklXmRmJNEgl1U6ixc1ky5Ftw38T+xul
         K3qtMT8KtTL924ZfBHN12ZCt9OQ0+tlNS8NF7it9AWpteAhcEZGeM16Dv+UHHxC0iL+x
         zNLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/CBC4CNJJEUWne8OKYCWF37FgHiJIdDmHT9EmeUV5VzD8igCf7+QvuX80i9bF/Z2D6L98qyn0I9AxwzNaRPtiF/8O
X-Gm-Message-State: AOJu0YzErf50i/rDpGhLjwCVyzuoDdl/o3yJozejbZSr9E7L9lihT8Ho
	t2+KTJ/ySmUOWLK8EzRfN9aepS8rZ4C2XIImwpDsJFcKcaKjf4XxMiyVDTYoErLo249WahlZvQw
	JF6CqIpQpvGQZR/VCSq57AJiJ/W+7KIoewKTnSSequr8DvBkBOA==
X-Received: by 2002:a17:902:d50e:b0:1fd:9420:1044 with SMTP id d9443c01a7336-1fdb5f68d70mr21438515ad.16.1721715774004;
        Mon, 22 Jul 2024 23:22:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPgJ2CXE7hNWQ1PFo9WoFtLesM4oKaP8B9Rc3wrzBKg8598MOU00D8FtaHIQZCy0PyD/104Q==
X-Received: by 2002:a17:902:d50e:b0:1fd:9420:1044 with SMTP id d9443c01a7336-1fdb5f68d70mr21438325ad.16.1721715773498;
        Mon, 22 Jul 2024 23:22:53 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f484267sm65736445ad.278.2024.07.22.23.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 23:22:53 -0700 (PDT)
Message-ID: <a119ad47-11b7-42e5-a1e2-2706660c93d9@redhat.com>
Date: Tue, 23 Jul 2024 16:22:44 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/15] arm64: rsi: Add RSI definitions
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-2-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240701095505.165383-2-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/24 7:54 PM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by a realm guest through SMC (Realm Services Interface) calls.
> 
> The SMC definitions are based on DEN0137[1] version A-eac5.
> 
> [1] https://developer.arm.com/documentation/den0137/latest
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v3:
>   * Drop invoke_rsi_fn_smc_with_res() function and call arm_smccc_smc()
>     directly instead.
>   * Rename header guard in rsi_smc.h to be consistent.
> Changes since v2:
>   * Rename rsi_get_version() to rsi_request_version()
>   * Fix size/alignment of struct realm_config
> ---
>   arch/arm64/include/asm/rsi_cmds.h |  38 ++++++++
>   arch/arm64/include/asm/rsi_smc.h  | 142 ++++++++++++++++++++++++++++++
>   2 files changed, 180 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rsi_cmds.h
>   create mode 100644 arch/arm64/include/asm/rsi_smc.h
> 

Some nits and questions like below.

> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> new file mode 100644
> index 000000000000..89e907f3af0c
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -0,0 +1,38 @@
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
> +#endif

#endif /* __ASM_RSI_CMDS_H */

> diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
> new file mode 100644
> index 000000000000..b3b3aff88f71
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi_smc.h
> @@ -0,0 +1,142 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RSI_SMC_H_
> +#define __ASM_RSI_SMC_H_
> +
> +/*
> + * This file describes the Realm Services Interface (RSI) Application Binary
> + * Interface (ABI) for SMC calls made from within the Realm to the RMM and
> + * serviced by the RMM.
> + */
> +
> +#define SMC_RSI_CALL_BASE		0xC4000000
> +
> +/*
> + * The major version number of the RSI implementation.  Increase this whenever
> + * the binary format or semantics of the SMC calls change.
> + */
> +#define RSI_ABI_VERSION_MAJOR		1
> +
> +/*
> + * The minor version number of the RSI implementation.  Increase this when
> + * a bug is fixed, or a feature is added without breaking binary compatibility.
> + */
> +#define RSI_ABI_VERSION_MINOR		0
> +
> +#define RSI_ABI_VERSION			((RSI_ABI_VERSION_MAJOR << 16) | \
> +					 RSI_ABI_VERSION_MINOR)
> +
> +#define RSI_ABI_VERSION_GET_MAJOR(_version) ((_version) >> 16)
> +#define RSI_ABI_VERSION_GET_MINOR(_version) ((_version) & 0xFFFF)
> +
> +#define RSI_SUCCESS			0
> +#define RSI_ERROR_INPUT			1
> +#define RSI_ERROR_STATE			2
> +#define RSI_INCOMPLETE			3
> +

I think these return values are copied from tf-rmm/lib/smc/include/smc-rsi.h, but
UL() prefix has been missed. It's still probably worthy to have it to indicate the
width of the return values. Besides, it seems that RSI_ERROR_COUNT is also missed
here.


> +#define SMC_RSI_FID(_x)			(SMC_RSI_CALL_BASE + (_x))
> +
> +#define SMC_RSI_ABI_VERSION			SMC_RSI_FID(0x190)
> +
> +/*
> + * arg1 == Challenge value, bytes:  0 -  7
> + * arg2 == Challenge value, bytes:  7 - 15
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

In tf-rmm/lib/smc/include/smc-rsi.h, it is SMC_RSI_ATTEST_TOKEN_INIT instead
of SMC_RSI_ATTESTATION_TOKEN_INIT. The short description for all SMC calls have
been dropped and I think they're worthy to be kept. At least, it helps readers
to understand what the SMC call does. For this particular SMC call, the short
description is something like below:

/*
  * Initialize the operation to retrieve an attestation token.
  * :
  */

> +/*
> + * arg1 == The IPA of token buffer
> + * arg2 == Offset within the granule of the token buffer
> + * arg3 == Size of the granule buffer
> + * ret0 == Status / error
> + * ret1 == Length of token bytes copied to the granule buffer
> + */
> +#define SMC_RSI_ATTESTATION_TOKEN_CONTINUE	SMC_RSI_FID(0x195)
> +

SMC_RSI_ATTEST_TOKEN_CONTINUE as defined in tf-rmm.

> +/*
> + * arg1  == Index, which measurements slot to extend
> + * arg2  == Size of realm measurement in bytes, max 64 bytes
> + * arg3  == Measurement value, bytes:  0 -  7
> + * arg4  == Measurement value, bytes:  7 - 15
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
> + * arg1 == Index, which measurements slot to read
> + * ret0 == Status / error
> + * ret1 == Measurement value, bytes:  0 -  7
> + * ret2 == Measurement value, bytes:  7 - 15
> + * ret3 == Measurement value, bytes: 16 - 23
> + * ret4 == Measurement value, bytes: 24 - 31
> + * ret5 == Measurement value, bytes: 32 - 39
> + * ret6 == Measurement value, bytes: 40 - 47
> + * ret7 == Measurement value, bytes: 48 - 55
> + * ret8 == Measurement value, bytes: 56 - 63
> + */
> +#define SMC_RSI_MEASUREMENT_READ		SMC_RSI_FID(0x192)
> +

The order of these SMC call definitions are sorted based on their corresponding
function IDs. For example, SMC_RSI_MEASUREMENT_READ would be appearing prior to
SMC_RSI_MEASUREMENT_EXTEND.

> +#ifndef __ASSEMBLY__
> +
> +struct realm_config {
> +	union {
> +		struct {
> +			unsigned long ipa_bits; /* Width of IPA in bits */
> +			unsigned long hash_algo; /* Hash algorithm */
> +		};
> +		u8 pad[0x1000];
> +	};
> +} __aligned(0x1000);
> +

This describes the argument to SMC call RSI_REALM_CONFIG and its address needs to
be aligned to 0x1000. Otherwise, RSI_ERROR_INPUT is returned. This maybe worthy
a comment to explain it why we need 0x1000 alignment here.

It seems the only 4KB page size (GRANULE_SIZE) is supported by tf-rmm at present.
The fixed alignment (0x1000) becomes broken if tf-rmm is extended to support
64KB in future. Maybe tf-rmm was designed to work with the minimal page size (4KB).

> +#endif /* __ASSEMBLY__ */
> +
> +/*
> + * arg1 == struct realm_config addr
> + * ret0 == Status / error
> + */
> +#define SMC_RSI_REALM_CONFIG			SMC_RSI_FID(0x196)
> +
> +/*
> + * arg1 == Base IPA address of target region
> + * arg2 == Top of the region
> + * arg3 == RIPAS value
> + * arg4 == flags
> + * ret0 == Status / error
> + * ret1 == Top of modified IPA range
> + */
> +#define SMC_RSI_IPA_STATE_SET			SMC_RSI_FID(0x197)
> +
> +#define RSI_NO_CHANGE_DESTROYED			0
> +#define RSI_CHANGE_DESTROYED			1
> +
> +/*
> + * arg1 == IPA of target page
> + * ret0 == Status / error
> + * ret1 == RIPAS value
> + */
> +#define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
> +
> +/*
> + * arg1 == IPA of host call structure
> + * ret0 == Status / error
> + */
> +#define SMC_RSI_HOST_CALL			SMC_RSI_FID(0x199)
> +
> +#endif /* __ASM_RSI_SMC_H_ */

Thanks,
Gavin


