Return-Path: <kvm+bounces-39848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD21CA4B6D0
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 04:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F1A9188E264
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 03:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18861D63F5;
	Mon,  3 Mar 2025 03:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D+zJPZo5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD007DA6D
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 03:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740973365; cv=none; b=OPBCcYTdYALsleTd1eBOuVrnKkrpZx9j4hu8Q/q/dAQI1HNcIzq0cFFYqt24JR6rQBJbO7a3+GZOux9gR75tJc6WTziNx6VuaoenXmG4BlmIF9IXunh8gBXIyWmDjaRiQiZp0y159C0M2o/TIsBJw9CQrd0k9cSMJBDW78VHcvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740973365; c=relaxed/simple;
	bh=38g/wttyi0OVix58IXmMb9keoqRC6204XM1tdy05KJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZIPVFr+B9aEyfq2mrS7lFbQhM1aHn6cnvuoepfeKGivNO9fGGW87eu/3M1pzDA9tkiQ8e6p2owYBH8QTfuE4xNvzONR6zzxFE7IW/eb44h4mqKQK4ySGSA0+dVfJbT3fY/icfsk4wCHyasqcExdMV51y/RX7m6c9XZCWDPikEyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D+zJPZo5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740973362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IEDc5a+qaJ461fEOorI0aPSdSVAqOPF0WWp/svcyhEc=;
	b=D+zJPZo5hgFvYsRt5g+roeOuiiYiqxW7yl6DG20MHaZ2Pcml7/eqbYOHCcrGuCh29bLy9+
	khStkYlcDutc1iaHNcckqBbV0ufZ/gwSg8Qd5oC/vuiOrMoSUR8Z65pRPsZdExpahY81LZ
	fE7u7okeQZ9ETmi8SJB/VECM+2xJblg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-S61RIeTJNn-UJCqpKCx-rw-1; Sun, 02 Mar 2025 22:42:39 -0500
X-MC-Unique: S61RIeTJNn-UJCqpKCx-rw-1
X-Mimecast-MFC-AGG-ID: S61RIeTJNn-UJCqpKCx-rw_1740973359
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2feda472a4aso2530413a91.1
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 19:42:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740973358; x=1741578158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IEDc5a+qaJ461fEOorI0aPSdSVAqOPF0WWp/svcyhEc=;
        b=KgFokYVZ9d+Ku6KKC9r0sgNjMtcI5hyAH/zR4uD95OgUjOvY5d8BkTp6dYDsl8eVZ+
         0CW1SN4A0j3HYb+vrHoMLmAXTMXu/5OkoBcOEueB/nlPbSAsLzaRFZ2S2oZ4Ei9fSz3R
         b5nS7V3d1Oin40PJu9x2AuP1qKg+AkmYADOIUXEQdt0I/RRhxdx6BswiywAHuEavQJXu
         wcRjctaBT5CnhtPsbzdUSPeix8QbCR//nYqwz2jb4fF7uN44owgfG4i1+RKb4gA1mcgp
         ehocIv9sRTz/JRJOOIPLfTDY29LIeTCEj1CQyiVHBCmhLDB/TDfIZz8fFqmK+YFBjgU5
         leUA==
X-Forwarded-Encrypted: i=1; AJvYcCXU0NlsQ3w9cLHIyikGp5BKtkw1uR6ivCOSVaOiFg9t7LZASVCk42QukzQTdwVMWXQGQ70=@vger.kernel.org
X-Gm-Message-State: AOJu0YyArY04+fgrKsQqavlONNC9UEnHGCcSwBPIHe0gORt2m9rRXeXf
	KG5hBc0vEA/ADUV+oUgZKAx/kwP4L73X4R8gKTZz2JqGVqaPLKDPrQft1jv2iODHI7ze2Y0Mfpi
	0vn0nWrQjqUZkRjoF0m5FncVMCagkvNfwO1yMcDkYVRGOPv2o3A==
X-Gm-Gg: ASbGncsq0Gkt4HJ9/ktaPT5NjnnLlVrc1O5DorKxTsMBBCNmFQZ3+5G3ZO8BMsSeaNi
	1FMgtOoH+HIj1pBdwTBkmo6iJeCJdaDXbtRGg4h1JLkc4lMVS8KZZXzt5G7X84Cmok5SnaQJw9b
	wrprzhpwVsWx/+3ZUkXNagRz18V8UZH+87RirR+NOte7z2dY9kLEUZHhPtbErFW2jiAySDurJ9r
	ip74dbEIa4T09cOUegSdEP2fIuoWe44ncCZBF983h06VkMMOWYeLmuFHNhFVFFZUsRu4fs3lqkH
	iN2KDZP0fmau7efsyg==
X-Received: by 2002:a05:6a20:1585:b0:1f0:e708:56e2 with SMTP id adf61e73a8af0-1f2f4cffa11mr18287094637.22.1740973358568;
        Sun, 02 Mar 2025 19:42:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5c7Qc3VVFcg30Esq5DIzJh6RfeW5P5eI8KFXRrs6oJHF3s/m+eXSunL5iyzYk2nV2q0PqZA==
X-Received: by 2002:a05:6a20:1585:b0:1f0:e708:56e2 with SMTP id adf61e73a8af0-1f2f4cffa11mr18287060637.22.1740973358238;
        Sun, 02 Mar 2025 19:42:38 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7362e3b1c61sm4421335b3a.22.2025.03.02.19.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 19:42:37 -0800 (PST)
Message-ID: <8f08b96b-8219-4d51-8f46-bc367bbf2031@redhat.com>
Date: Mon, 3 Mar 2025 13:42:29 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/45] arm64: RME: Add wrappers for RMI calls
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-6-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> The wrappers make the call sites easier to read and deal with the
> boiler plate of handling the error codes from the RMM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v5:
>   * Further improve comments
> Changes from v4:
>   * Improve comments
> Changes from v2:
>   * Make output arguments optional.
>   * Mask RIPAS value rmi_rtt_read_entry()
>   * Drop unused rmi_rtt_get_phys()
> ---
>   arch/arm64/include/asm/rmi_cmds.h | 508 ++++++++++++++++++++++++++++++
>   1 file changed, 508 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
> 

With the following nitpicks addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
> new file mode 100644
> index 000000000000..043b7ff278ee
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_cmds.h
> @@ -0,0 +1,508 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RMI_CMDS_H
> +#define __ASM_RMI_CMDS_H
> +

[...]

> +
> +/**
> + * rmi_rec_aux_count() - Get number of auxiliary granules required
> + * @rd: PA of the RD
> + * @aux_count: Number of pages written to this pointer
                   ^^^^^^^^^^^^^^^
                   Number of granules
> + *
> + * A REC may require extra auxiliary pages to be delegated for the RMM to
                                         ^^^^^
                                         granules

> + * store metadata (not visible to the normal world) in. This function provides
> + * the number of pages that are required.
                     ^^^^^
                     granules
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
> +
> +	if (aux_count)
> +		*aux_count = res.a1;
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_create() - Create a REC
> + * @rd: PA of the RD
> + * @rec: PA of the target REC
> + * @params_ptr: PA of REC parameters
> + *
> + * Create a REC using the parameters specified in the struct rec_params pointed
> + * to by @params_ptr.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_create(unsigned long rd, unsigned long rec,
> +				 unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rd, rec, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +

'params_ptr' may be renamed to 'params'.


[...]
> +#endif /* __ASM_RMI_CMDS_H */

Thanks,
Gavin


