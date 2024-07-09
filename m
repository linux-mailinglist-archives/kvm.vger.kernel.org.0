Return-Path: <kvm+bounces-21150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 392C092AF63
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 07:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACFE91F21B91
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 05:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37E112F5B3;
	Tue,  9 Jul 2024 05:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IKH3rs2I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D234D8BB
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 05:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720502359; cv=none; b=aLcqjZE1aWi0TddD/y+5eN8kE3JwDzhv35kvqMENZlSkxAYjXo4e29OcVyc8GDkcxCnmOO5rlFoYeKrJbi2ZUfx/WcFruraUQuL7DBNG2iYYTrzTLi/0tN/h2VpLsXGD0UxbdZj+VZVukTyZx+B1zGWdG1drC1SXDA3w5aF0+Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720502359; c=relaxed/simple;
	bh=kxxZ4GZi+K29+wA/0D4vq8njOFzYZ2ku8FWTAgcRy2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BrujcQV34XLRKj9vRSZidi600hQaZ/Dw/k5NENJ2NBPBITxLeOwKAyGvhWeKDW+S029ohdutfCvrI+IJoIx8UyH5VSwWd22b+VIAf/oR6DteCrz4Hxf5fyIf8kqiclwOuNHfU3fZ0ZdgMznAaTJ3ThaO0+pq7bBX95eZ/ruZsP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IKH3rs2I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720502356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1NO3dhCc2LGOp3hm3fp51cTnn6RCFGh5hrEz11I777E=;
	b=IKH3rs2IPYxOPwulkfGsXTPS64WwojKTuy0C5DPl7ul1Co6zt4TKgTDuFGi7PCcj/enxml
	/e2G7P+1hq9bpJHNxb5TyGNrypcShdvx0GmzOwtTaYaLCME2Gx4sJSRwFtB5pR3+BV/Ia7
	Z0cICrUlTJJ9UsUT/Bc9+t0E+EzHPUs=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-HZsClmOLOzmjCwh0a88wGw-1; Tue, 09 Jul 2024 01:19:14 -0400
X-MC-Unique: HZsClmOLOzmjCwh0a88wGw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1fb0d545c60so31138385ad.2
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 22:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720502354; x=1721107154;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1NO3dhCc2LGOp3hm3fp51cTnn6RCFGh5hrEz11I777E=;
        b=tX8DRndgS4UWmEFtkgf+FkNcdE7SV8vOLh+9A6Wre1kGUpWjpWo9g+GWaNWrQt1ZUQ
         Rh5Gf5UrsDkGxU6aumFYgADUjNwOcz1uACfBxwCne37z2ZJTm31Nr4bVdvSZ2YCR/4da
         N1fDD/X+qvyU0gVmGYeX/FV6pA8wI2n1CwG5bC42T+5TB8tZ/k2YMTmqofw+6pmjblTB
         GPCb6GNRynOVJbYy8St3QJJhhNkicxm6pIJPzWWqdmyZxHm9u9lGM9X0TN4qnAUtxO5O
         HkJUCyEoP0HdilQIL3n8mHTA7NXH3IDbRMPKuN9zFeiJYte+RzFLLckNWG+hMWV6t5SW
         RXeA==
X-Forwarded-Encrypted: i=1; AJvYcCUavQzMwf9lYSL4FNfU9zav4NtEaoQ++RPqUr2LlBAYsjUcNiYBWmjMF1H/ArLvRuBjH5/kMXMvrd2z55vfZXrC4KBy
X-Gm-Message-State: AOJu0YxtASXOM2o9KRlZy7ga1TlpOBzS7PPkz7nQ7spefJyb+mzEUI4E
	wkq+Y6OkUUu1w90fSgKPTfX8t5oCLMWCD2IKDmeuZkzg8PV9SHM666xczYmGqHoiSMMd2Ig6dDB
	QI2QOq6Q/xEmOtPzjHLnHolKtaF7gcMfpwnBV6FOEEvUfbVJoWw==
X-Received: by 2002:a17:902:ced2:b0:1fb:6ea1:4c with SMTP id d9443c01a7336-1fbb6d3d631mr11099405ad.23.1720502352939;
        Mon, 08 Jul 2024 22:19:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnVXcKv//QUkd2zalk0KVeKlO2V4LMxD2AA7tVtpYgxucEKRW687wZfsonrs0t+riLdK1vzA==
X-Received: by 2002:a17:902:ced2:b0:1fb:6ea1:4c with SMTP id d9443c01a7336-1fbb6d3d631mr11099335ad.23.1720502352511;
        Mon, 08 Jul 2024 22:19:12 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a28f83sm7276275ad.72.2024.07.08.22.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jul 2024 22:19:11 -0700 (PDT)
Message-ID: <3b1c8387-f40f-4841-b2b3-9e4dc1e35efc@redhat.com>
Date: Tue, 9 Jul 2024 15:19:03 +1000
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

[...]

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

These fields have been defined in include/linux/arm-smccc.h. Those definitions
can be reused. Otherwise, it's not obvious to reader what does 0xC4000000 represent.

#define SMC_RSI_CALL_BASE	((ARM_SMCCC_FAST_CALL << ARM_SMCCC_TYPE_SHIFT)   | \
                                  (ARM_SMCCC_SMC_64 << ARM_SMCCC_CALL_CONV_SHIFT) | \
                                  (ARM_SMCCC_OWNER_STANDARD << ARM_SMCCC_OWNER_SHIFT))

or

#define SMC_RSI_CALL_BASE       ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,            \
                                                    ARM_SMCCC_SMC_64,               \
                                                    ARM_SMCCC_OWNER_STANDARD,       \
                                                    0)

Thanks,
Gavin


