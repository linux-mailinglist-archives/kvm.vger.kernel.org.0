Return-Path: <kvm+bounces-26171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D02FF9725F9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 944D228598B
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BFA18EFCE;
	Mon,  9 Sep 2024 23:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itQsml/5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A287718E740
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 23:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725926226; cv=none; b=r7XLJbEqgiUc0MXA/EakLniV5pCeHvkfeNjOzDhFWQ7qjDNxSL/8ZWLOSDTgX0txjcPC6fqqTmRqA+6SlYGrZCVR5aIsnLMWc/1HmBYL6PLF6w9iM3KjqWRqcYKopNAmyAqblW4QDJitwWAWY1UekB8nAuc7U484V4CfKHEk7wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725926226; c=relaxed/simple;
	bh=3XI5IVZuxU96tWCq021MKnBptmnTHpNo8/GtC8SKI6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oYq+pwtzTOT8qLP7Q3+QzHWdA9GEaUzpk02oN3IUh0KTE+RKqpeUzTiPwK22DCdO0onSeTK9K8K3eMBLnGu7PpTjSOyPhFS3kR0PCxpgitsVEftxrV6sCKBgcGeomS5BBAJzpNPJchZnikPh8idLTTtPC9QaGD4CGo2aEh7C0Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=itQsml/5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725926223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5KDrfnw4h4KPFm9gkKjM5Pcm4Qn58KLQZ4qPPhdTka4=;
	b=itQsml/54rxNNuresKAHUjR7n8sAgJLZs/FHDCmB3EXZKq5eURJhMugnMi6O9AbvkJWSGL
	uBo4TiDnbcYWhTlykOVt3OWuVslVVXx4x5kjV3rGJIZ1+7CxYEYwhggcrwxH+UjTb3Kg3z
	t8lwOwPqGB9zHEBu7ytn9FeSt/An7j8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-LWIJ7GCyPQS_YYqUnWoIWw-1; Mon, 09 Sep 2024 19:57:01 -0400
X-MC-Unique: LWIJ7GCyPQS_YYqUnWoIWw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7179469744dso258239b3a.2
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 16:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725926221; x=1726531021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5KDrfnw4h4KPFm9gkKjM5Pcm4Qn58KLQZ4qPPhdTka4=;
        b=MiQfsHl8GLUM62vHioAFsy1RkZXQEiPRhDJL7QK0rCSgflLMbj3NrtQv44MhZh02fc
         x668wEKm3yth9KwSzCsQmpRo64/lG+KpRIJeGotkWzoAEhuKMicPdttgb/mDeCLFLfu1
         bq7hja7O7qw4L492QvQkKG5S19p4/vrNXyGQ+JM1KoBiKtp/sW7bSnf5aYkYI+h/uMsu
         1RD0OLzay3Szc85h68/uiBmiPnjItAggN+kU4chNJDO/wQq7+DGakPbcltaO/t/it8S4
         IX5IxSyuAsVX0Iy7Qd1kbNb8KL1tLqDOAcbsRcRCbd+kB6w7CW1W1BY+LmKY69kMWXnC
         A5Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWtgnUetRhvgRIRKpuSdZ+uZBjwevSI/EIkV9yY+P4GJ4Y31IqezMEC2t8+9nWIUJJvvk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPf6s28oxavrJ3DOUHh9WS6SYi2SbDwwLazIh5gvlIdFhBAmik
	S8iDCaSgvG6ujkJ65okqNFLABH1dBWw/zEXVktLmohu0SSK/QAiJcbdnJ7hmWlL+QdW8YFNb08X
	BRfK2gkM6UYYq1DGImbsQqePIO+NEzlv/KFbcgR+/tbzzkNwzHQ==
X-Received: by 2002:a05:6a00:3c85:b0:718:d740:b870 with SMTP id d2e1a72fcca58-718e3352956mr12735766b3a.2.1725926220675;
        Mon, 09 Sep 2024 16:57:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsgj8V1pojC58pqDKayl2QgqKFvt9FHbNtmUL06MwiNOepfTXdxL0EwUPYChJ+RhkrUXN3AQ==
X-Received: by 2002:a05:6a00:3c85:b0:718:d740:b870 with SMTP id d2e1a72fcca58-718e3352956mr12735733b3a.2.1725926220087;
        Mon, 09 Sep 2024 16:57:00 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909092258sm269939b3a.127.2024.09.09.16.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 16:56:59 -0700 (PDT)
Message-ID: <41d7c549-072c-4e55-beab-cf339f441ec5@redhat.com>
Date: Tue, 10 Sep 2024 09:56:49 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/19] firmware/psci: Add psci_early_test_conduit()
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
 <alpergun@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-5-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240819131924.372366-5-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:19 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Add a function to test early if PSCI is present and what conduit it
> uses. Because the PSCI conduit corresponds to the SMCCC one, this will
> let the kernel know whether it can use SMC instructions to discuss with
> the Realm Management Monitor (RMM), early enough to enable RAM and
> serial access when running in a Realm.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v4: New patch
> ---
>   drivers/firmware/psci/psci.c | 25 +++++++++++++++++++++++++
>   include/linux/psci.h         |  5 +++++
>   2 files changed, 30 insertions(+)
> 

Question: Do we need same check for ACPI based system?

> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 2328ca58bba6..2b308f97ef2c 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -13,6 +13,7 @@
>   #include <linux/errno.h>
>   #include <linux/linkage.h>
>   #include <linux/of.h>
> +#include <linux/of_fdt.h>
>   #include <linux/pm.h>
>   #include <linux/printk.h>
>   #include <linux/psci.h>
> @@ -769,6 +770,30 @@ int __init psci_dt_init(void)
>   	return ret;
>   }
>   
> +/*
> + * Test early if PSCI is supported, and if its conduit matches @conduit
> + */

Nit: The comments needn't span into multiple lines.

> +bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit)
> +{
> +	int len;
> +	int psci_node;
> +	const char *method;
> +	unsigned long dt_root;
> +
> +	/* DT hasn't been unflattened yet, we have to work with the flat blob */
> +	dt_root = of_get_flat_dt_root();
> +	psci_node = of_get_flat_dt_subnode_by_name(dt_root, "psci");
> +	if (psci_node <= 0)
> +		return false;
> +

Nit: Strictly speaking, "psci_node == 0" isn't an error. So the check would be
"if (psci_node < 0)" if I'm correct.

> +	method = of_get_flat_dt_prop(psci_node, "method", &len);
> +	if (!method)
> +		return false;
> +
> +	return  (conduit == SMCCC_CONDUIT_SMC && strncmp(method, "smc", len) == 0) ||
> +		(conduit == SMCCC_CONDUIT_HVC && strncmp(method, "hvc", len) == 0);
> +}
> +
>   #ifdef CONFIG_ACPI
>   /*
>    * We use PSCI 0.2+ when ACPI is deployed on ARM64 and it's
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index 4ca0060a3fc4..a1fc1703ba20 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -45,8 +45,13 @@ struct psci_0_1_function_ids get_psci_0_1_function_ids(void);
>   
>   #if defined(CONFIG_ARM_PSCI_FW)
>   int __init psci_dt_init(void);
> +bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit);
>   #else
>   static inline int psci_dt_init(void) { return 0; }
> +static inline bool psci_early_test_conduit(enum arm_smccc_conduit conduit)
> +{
> +	return false;
> +}
>   #endif
>   
>   #if defined(CONFIG_ARM_PSCI_FW) && defined(CONFIG_ACPI)

Thanks,
Gavin


