Return-Path: <kvm+bounces-28838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F094F99DD0C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 05:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 720511F23BC9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 03:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFC41714B5;
	Tue, 15 Oct 2024 03:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sg2VmH3s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D062716B38B
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 03:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728964568; cv=none; b=RQwF8zR+Hn4dALG4AS0x03g1ggBi5y31+kfGFYXyqGzDUrsJJV3mA8fxyBw9QpwOph74Wfk6wmjf3g6A0SrlK44Ud7u45bKhGizSmonxoUOR0UnkO+dk9XzQCmmd3kYFNbs/0D/GdizchJmxHepjUtbz0lUSK5lKj46oqLDcNmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728964568; c=relaxed/simple;
	bh=MgtyB/AAROrtxH1XraK2lYAW3vbCsCYiprQHNQSY0ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kqCTyZVi+vFKLp537EVO2vPVGj+zfv5ouhH3rV7EXQCC6U8RX9ld4rBq5zuuGMWIT7NzztymrgHEo2pZepkq6bQlc5Xxj4cx9dBlrDWSJ4eqOmtXSR5zCfSTaQAD0Sbcf3Xzc0/XqFeR3APcWb/JzJ6bJnJZTanarMz/kWYVUuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sg2VmH3s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728964565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/gQj7yhKGwHX3tay3bEUPL2aqsF2Bb60CY1YisKDKbg=;
	b=Sg2VmH3srXdzxjPr1P5SpmaxF4U72H+kzlOrICxip4aD+ubId/45O8/A/19eglCE/4iunD
	qqe5es/KuNw09IYmjyUOOnM+sd/zRpCTQtsh9BupZMbj4gD4zp6PxXnyYGRAzHG2U5rs1O
	G4sitf8IcyhDeajG6UaSvoXrJcCwoUs=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-jj9yvM5_MTW5YpmXmJR0rQ-1; Mon, 14 Oct 2024 23:56:04 -0400
X-MC-Unique: jj9yvM5_MTW5YpmXmJR0rQ-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-7ea999a79a2so717910a12.2
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 20:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728964563; x=1729569363;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/gQj7yhKGwHX3tay3bEUPL2aqsF2Bb60CY1YisKDKbg=;
        b=kxOr7XSinH0iBu+pWi/qdNgLoIHQJjxELrA2Hp28vXcosbft1hZnT7gELmvD5oN//c
         KBMQFe7WSVUqF0lRsE4sh7PI4KomE1VuNqCwzFzZfB/hqmoGVndrrHq223dZtfH1fExR
         /gWKBUyPzhCzBO5ZjPs547ynAhmKMTjl1yEYq4ybTRXAbUVUVJOj3trQJgNIsPL+TYmS
         wDBgg9mO0/tFv9wsP/fxCAK06rAYMOd/EBMIysnW8z5Fp8HWx45qYkF1QJjVoh8vqJpJ
         dpFs1vWmawOGGOV4Sm5gLDCwGAHj44t8ZZMZ+YBPQQf3sXtFfHUkyEpunLxF5Tn1QxWQ
         VVNg==
X-Forwarded-Encrypted: i=1; AJvYcCUiU+9OGyU+AGOsrkhH8hJgoMkAbWH5BkKP3llr52vcyeGPufvXFRPspYPg6FmxwQpo4n4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy44VIBL6twdd/VGSKcBjNzE7tuhm9rar/oaxRs8NTLjviHDfBI
	OUWxQurYW3X49bmRA5D5sDBZSypag4W7yPmFdtsvF4KRTtV9+U1I/CkXbzRvIaQGRPRDZvdIHJy
	A3xW6bmzzPraisAOOSFKsqjjhZovTLRKhn4YGL5G5BhvKfmPz3Q==
X-Received: by 2002:a05:6a21:4d8c:b0:1d8:f894:43f9 with SMTP id adf61e73a8af0-1d8f89445eamr681081637.11.1728964563166;
        Mon, 14 Oct 2024 20:56:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGybMblrnhP5WbRv8pGItZKUwHcNnS++KdeQ7wfVC+XkNBJwpsFwHEmwrwG693wjo55GOXWsQ==
X-Received: by 2002:a05:6a21:4d8c:b0:1d8:f894:43f9 with SMTP id adf61e73a8af0-1d8f89445eamr681045637.11.1728964562725;
        Mon, 14 Oct 2024 20:56:02 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea9c6ba2d4sm339896a12.11.2024.10.14.20.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 20:56:02 -0700 (PDT)
Message-ID: <2352629a-3742-45e9-a38f-196989918c9b@redhat.com>
Date: Tue, 15 Oct 2024 13:55:53 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/11] arm64: realm: Query IPA size from the RMM
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
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-4-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-4-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:42 AM, Steven Price wrote:
> The top bit of the configured IPA size is used as an attribute to
> control whether the address is protected or shared. Query the
> configuration from the RMM to assertain which bit this is.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Make PROT_NS_SHARED check is_realm_world() to reduce impact on
>     non-CCA systems.
> Changes since v2:
>   * Drop unneeded extra brackets from PROT_NS_SHARED.
>   * Drop the explicit alignment from 'config' as struct realm_config now
>     specifies the alignment.
> ---
>   arch/arm64/include/asm/pgtable-prot.h | 4 ++++
>   arch/arm64/include/asm/rsi.h          | 2 +-
>   arch/arm64/kernel/rsi.c               | 8 ++++++++
>   3 files changed, 13 insertions(+), 1 deletion(-)
> 

[...]

> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index 9bf757b4b00c..a6495a64d9bb 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -8,6 +8,11 @@
>   #include <linux/psci.h>
>   #include <asm/rsi.h>
>   
> +struct realm_config config;
> +

Nit: I think this variable is file-scoped since it has a generic name.
In this case, 'static' is needed to match with the scope.

> +unsigned long prot_ns_shared;
> +EXPORT_SYMBOL(prot_ns_shared);
> +
>   DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
>   EXPORT_SYMBOL(rsi_present);
>   
> @@ -67,6 +72,9 @@ void __init arm64_rsi_init(void)
>   		return;
>   	if (!rsi_version_matches())
>   		return;
> +	if (WARN_ON(rsi_get_realm_config(&config)))
> +		return;
> +	prot_ns_shared = BIT(config.ipa_bits - 1);
>   
>   	arm64_rsi_setup_memory();
>   

Thanks,
Gavin


