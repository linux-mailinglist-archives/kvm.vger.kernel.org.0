Return-Path: <kvm+bounces-28088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05EA6993BD5
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 02:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11A8F1C246DE
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 00:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6834A8494;
	Tue,  8 Oct 2024 00:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iTSrsogS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A6979C2
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 00:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347481; cv=none; b=hnXprGy97AVy1VJXTHSkfVMcvz4Wmo0GWJX+l2E98DOTpBZl96AbGky8ekwcuJ4PJPak3tP+YpI/TbxoKF1D3o/i/KpA9yN4vLlUxMZPqGsJQ0sFUWs0RRBWVHtRO9o0Vl17zIfKDyjVdDG9RgkZVPxQa91hHUfqTtkwX/BIVp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347481; c=relaxed/simple;
	bh=tbchR47/dXjjE+PvPFck7xaGHnvKhi2I53EICNbpweQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lN0txMLTuB8XvHu0EcSGWdK1fr0wJ4DYWw49I8ZAz6dfI2WoQzMwPmAo0MspuPRYURKnMUIZKbiL1laGTpSkXzj3hBTOBCXyMlZS8wLrhthn6m2gUUah7YN9PGKCNgpt0hBTbmhnUHwsmoYNEcIpqMD0SnSTe3NkwkkgFKoBiEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iTSrsogS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728347479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8CIn7L4t98gFCcpAeot65WzEAFvBmvmwmESlA16rbdY=;
	b=iTSrsogSMw6au/JYnAgkuzzjozjtdRw0qEa+qXH4a4dEa4plqr5OCuxRrCOscWn+3XYsSF
	LIcdU6j90Gvtsi10XUbA94vx/tcq/KBeSc6kb6kcN9n9lmAr5i+KVQCLQnesovq5iZdnHO
	AZtd7E0VDoO22QSQvfl2yh/N37gKsQE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-wIgK4qjFP7ODAATV7gkAbA-1; Mon, 07 Oct 2024 20:31:17 -0400
X-MC-Unique: wIgK4qjFP7ODAATV7gkAbA-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2e0b6b4d427so5565733a91.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 17:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728347477; x=1728952277;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8CIn7L4t98gFCcpAeot65WzEAFvBmvmwmESlA16rbdY=;
        b=ZCrbqSZj1g2k2A9S6fVrukMtKmbUfTcub8Yjs5jqjMJMVyiA1rPx3ZBBHheLpmZnem
         dF6sq3NVzYe7zDp88SIEeHNY3Eydh8qliwUCgYIv6T3IqO/K/aLp2dR8cMXnyIMayzIU
         01MSX948Y3+Zv3ngL87JNbCYXNCmgFxziaELzoQoqFotW9I2BusavFTovSeH3d12M4Kr
         R3yzdyweGVvUc07XyBqe4YQjXa0Xcz9pOg5DSJCXhdnxKiUBnGcWTL0onxuh+2+aWBb8
         kqxtivsls85DYmoEz+Vq4HeonwtQYNPCcTEsp0QwsetvwfRilH7uBEpRiFxw3s9zySyn
         wVew==
X-Forwarded-Encrypted: i=1; AJvYcCW/VqKl1HQTy5n4vOTPLq0cULpEA+bEunelJKp6X+soPeJmU0ZKTEuXEDkRaxveJ8nQoM4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5sPSWR593fhgcXDaJbqL6KRcBdD4Df6E54MVklP8bNkRsPr9E
	oOrDUaeer+MRbZuQ7cY/0nB3OuWCAO0siJOWDepoiQxeGdnHgb4SReyTOdSm+2RvPukmf0kZ0HC
	cbjl+I2hSdRztD1ArnaxLgLl4SO81wDu5xtLP0+qIckK652k7yw==
X-Received: by 2002:a17:90a:db8d:b0:2d8:9fbe:6727 with SMTP id 98e67ed59e1d1-2e27dd46589mr2313520a91.4.1728347476905;
        Mon, 07 Oct 2024 17:31:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5g/BMfTrnv3FT9lAmYAR1aeLFXOfl3JqwydJK0b/zrgK05aYoww94UM4wvonucrKKC1IEwA==
X-Received: by 2002:a17:90a:db8d:b0:2d8:9fbe:6727 with SMTP id 98e67ed59e1d1-2e27dd46589mr2313484a91.4.1728347476546;
        Mon, 07 Oct 2024 17:31:16 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20aebf399sm6231462a91.17.2024.10.07.17.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:31:15 -0700 (PDT)
Message-ID: <e21481a9-3e36-4a5d-9428-0f5ef8083676@redhat.com>
Date: Tue, 8 Oct 2024 10:31:06 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/11] arm64: rsi: Map unprotected MMIO as decrypted
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
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-6-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Instead of marking every MMIO as shared, check if the given region is
> "Protected" and apply the permissions accordingly.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v5
> ---
>   arch/arm64/kernel/rsi.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 

With the following potential issue addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index d7bba4cee627..f1add76f89ce 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -6,6 +6,8 @@
>   #include <linux/jump_label.h>
>   #include <linux/memblock.h>
>   #include <linux/psci.h>
> +
> +#include <asm/io.h>
>   #include <asm/rsi.h>
>   
>   struct realm_config config;
> @@ -92,6 +94,16 @@ bool arm64_is_protected_mmio(phys_addr_t base, size_t size)
>   }
>   EXPORT_SYMBOL(arm64_is_protected_mmio);
>   
> +static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
> +{
> +	if (arm64_is_protected_mmio(phys, size))
> +		*prot = pgprot_encrypted(*prot);
> +	else
> +		*prot = pgprot_decrypted(*prot);
> +
> +	return 0;
> +}
> +

We probably need arm64_is_mmio_private() here, meaning arm64_is_protected_mmio() isn't
sufficient to avoid invoking SMCCC call SMC_RSI_IPA_STATE_GET in a regular guest where
realm capability isn't present.

>   void __init arm64_rsi_init(void)
>   {
>   	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
> @@ -102,6 +114,9 @@ void __init arm64_rsi_init(void)
>   		return;
>   	prot_ns_shared = BIT(config.ipa_bits - 1);
>   
> +	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
> +		return;
> +
>   	arm64_rsi_setup_memory();
>   
>   	static_branch_enable(&rsi_present);

Thanks,
Gavin


