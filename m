Return-Path: <kvm+bounces-28097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C960993DD2
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 06:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2E391C232F4
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 04:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1922762D2;
	Tue,  8 Oct 2024 04:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BpyYvCeq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90C2225A8
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 04:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728360765; cv=none; b=b6LncJx1nER+ZLxfe3i2yefqoPHp/h80S+CdML7dDnNPqsUAv8GdCpNnIlJVg7Ws21iGXmViJ+BQJe523T0M7D6sDzH/gtQhutdtZwMWVZikOBrKyHwv6ReB2TfsEy7TbDRZ0fbtHwJo3Pe/UiBhPzeH9+qc8DiwzfNiQ4qWCIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728360765; c=relaxed/simple;
	bh=mVqdjTbCtA8TBjY8IEFTyXF/jJOEa/Fe5b9nry9h5S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mKMPO2L6DeSdj3+z/mWe7Di+icTpH1gRlrd51eUw9BlQ+AGdV914H71WyajOCV+iXDaxJfvmq5CZVcMW0zuTUxen+oetNTfb7Nx/XuEFtP+jmgOm7ezDjOR0xYARXrNX2BekRqPUeZD7ZZbsrhA8tUX5dYHPDHLH2iSk8qtA4VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BpyYvCeq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728360761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iB7VR+F0izQt/1AwWqlFhbEEHRdhpQNSe93k08IM7wY=;
	b=BpyYvCeqBbTdKJILwtum8/gMobPm9fL6Ic+pprpPd4PgdU8gsanUEftDJjR9Q9k5PfQ2MJ
	UPhxB9QGUNWvu3G2PbBUPzB8jWeHaFETjjV8sxerBZYKelX+ilU4Jx6LfSASgyTQf0dtGa
	6GD1LQQaTOwgWRiVXDIQFkvrRIuyTxc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-TFdwiqdrOxmAT0ZsTmxj2A-1; Tue, 08 Oct 2024 00:12:40 -0400
X-MC-Unique: TFdwiqdrOxmAT0ZsTmxj2A-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2e27884fe9aso866885a91.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 21:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728360759; x=1728965559;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iB7VR+F0izQt/1AwWqlFhbEEHRdhpQNSe93k08IM7wY=;
        b=MSx8BSDrOXmKSuyJA8RHVohC8QmDk37o6bk+oQlm7NnuFGr+ikWZ3zu6Kf11LDkbmI
         vrwdSA93mMXO7NZdbgDEReyf+1guiZqLW+oG9UpV3McopmTr46R7UywNTPqWthoq7Wsu
         DgsEDnrnHB2Tz7+O+vJpS+IvgPeVoTPYuu6Ii5B62yi+ocQVjUGsr7u8qljIBnlrXBoQ
         BZU/rHe2QFloISmHU/JhNZbHaAtcTivJTgz/AKy9Rl0uVrhsv/GRFO4H2qynJtZpxFfW
         h8ibCH7jCa8TzqgTTrqhCvET1xlmDNjSQR57NCnjlD4eskCl5e2QQQD/TlAZBuI5VsOL
         ZuAA==
X-Forwarded-Encrypted: i=1; AJvYcCXztp8O3By+lNFWjx5vGWfcn4vO8aiu1kgpYxVdrUypFUfqgpAsOm3qJL1xl9n0L16WQzk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4QqwpvRW3/57/dk5Pyn7+acv0jLTY/os4KR4pLwByUVfMJv5W
	q42qIEBKTj2WGXLNlVohPnplih4LSVVzl7dSoFij9L/NL21g26A5Ox2gQsOxtzcPGNosKdepJ0F
	hBE93VF3yVq3Of0YiF8BKb3dM9N8puxzKkyXrxga6XNjqfqlzWA==
X-Received: by 2002:a17:90a:3002:b0:2e0:a28a:ef88 with SMTP id 98e67ed59e1d1-2e1e63bc02bmr13374242a91.41.1728360758981;
        Mon, 07 Oct 2024 21:12:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGA/CHl8zm/92lWi/L7FoeUMSJpYRtqnW9WHjrnjP7ggJdEvZY0t9Iqgf6zPlNUzsqWnZOTHA==
X-Received: by 2002:a17:90a:3002:b0:2e0:a28a:ef88 with SMTP id 98e67ed59e1d1-2e1e63bc02bmr13374217a91.41.1728360758610;
        Mon, 07 Oct 2024 21:12:38 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e83c9f60sm8271492a91.6.2024.10.07.21.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 21:12:37 -0700 (PDT)
Message-ID: <5a3432d1-6a79-434c-bc93-6317c8c6435c@redhat.com>
Date: Tue, 8 Oct 2024 14:12:27 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-11-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-11-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> From: Sami Mujawar <sami.mujawar@arm.com>
> 
> Introduce an arm-cca-guest driver that registers with
> the configfs-tsm module to provide user interfaces for
> retrieving an attestation token.
> 
> When a new report is requested the arm-cca-guest driver
> invokes the appropriate RSI interfaces to query an
> attestation token.
> 
> The steps to retrieve an attestation token are as follows:
>    1. Mount the configfs filesystem if not already mounted
>       mount -t configfs none /sys/kernel/config
>    2. Generate an attestation token
>       report=/sys/kernel/config/tsm/report/report0
>       mkdir $report
>       dd if=/dev/urandom bs=64 count=1 > $report/inblob
>       hexdump -C $report/outblob
>       rmdir $report
> 
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v3: Minor improvements to comments and adapt to the renaming of
> GRANULE_SIZE to RSI_GRANULE_SIZE.
> ---
>   drivers/virt/coco/Kconfig                     |   2 +
>   drivers/virt/coco/Makefile                    |   1 +
>   drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>   drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>   .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
>   5 files changed, 227 insertions(+)
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>   create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> 
> diff --git a/drivers/virt/coco/Kconfig b/drivers/virt/coco/Kconfig
> index d9ff676bf48d..ff869d883d95 100644
> --- a/drivers/virt/coco/Kconfig
> +++ b/drivers/virt/coco/Kconfig
> @@ -14,3 +14,5 @@ source "drivers/virt/coco/pkvm-guest/Kconfig"
>   source "drivers/virt/coco/sev-guest/Kconfig"
>   
>   source "drivers/virt/coco/tdx-guest/Kconfig"
> +
> +source "drivers/virt/coco/arm-cca-guest/Kconfig"
> diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
> index b69c30c1c720..c3d07cfc087e 100644
> --- a/drivers/virt/coco/Makefile
> +++ b/drivers/virt/coco/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
>   obj-$(CONFIG_ARM_PKVM_GUEST)	+= pkvm-guest/
>   obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
>   obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
> +obj-$(CONFIG_ARM_CCA_GUEST)	+= arm-cca-guest/
> diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig b/drivers/virt/coco/arm-cca-guest/Kconfig
> new file mode 100644
> index 000000000000..9dd27c3ee215
> --- /dev/null
> +++ b/drivers/virt/coco/arm-cca-guest/Kconfig
> @@ -0,0 +1,11 @@
> +config ARM_CCA_GUEST
> +	tristate "Arm CCA Guest driver"
> +	depends on ARM64
> +	default m
> +	select TSM_REPORTS
> +	help
> +	  The driver provides userspace interface to request and
> +	  attestation report from the Realm Management Monitor(RMM).
> +
> +	  If you choose 'M' here, this module will be called
> +	  arm-cca-guest.
> diff --git a/drivers/virt/coco/arm-cca-guest/Makefile b/drivers/virt/coco/arm-cca-guest/Makefile
> new file mode 100644
> index 000000000000..69eeba08e98a
> --- /dev/null
> +++ b/drivers/virt/coco/arm-cca-guest/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_ARM_CCA_GUEST) += arm-cca-guest.o
> diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c b/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> new file mode 100644
> index 000000000000..e22a565cb425
> --- /dev/null
> +++ b/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> @@ -0,0 +1,211 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/cc_platform.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/smp.h>
> +#include <linux/tsm.h>
> +#include <linux/types.h>
> +
> +#include <asm/rsi.h>
> +
> +/**
> + * struct arm_cca_token_info - a descriptor for the token buffer.
> + * @granule:	PA of the page to which the token will be written
                       ^^^^^^^^

s/the page/the granule. They are same thing when we have 4KB page size,
but there are conceptually different if I'm correct.

> + * @offset:	Offset within granule to start of buffer in bytes
> + * @len:	Number of bytes of token data that was retrieved
> + * @result:	result of rsi_attestation_token_continue operation
> + */
> +struct arm_cca_token_info {
> +	phys_addr_t     granule;
> +	unsigned long   offset;
> +	int             result;
> +};
> +
> +/**
> + * arm_cca_attestation_continue - Retrieve the attestation token data.
> + *
> + * @param: pointer to the arm_cca_token_info
> + *
> + * Attestation token generation is a long running operation and therefore
> + * the token data may not be retrieved in a single call. Moreover, the
> + * token retrieval operation must be requested on the same CPU on which the
> + * attestation token generation was initialised.
> + * This helper function is therefore scheduled on the same CPU multiple
> + * times until the entire token data is retrieved.
> + */
> +static void arm_cca_attestation_continue(void *param)
> +{
> +	unsigned long len;
> +	unsigned long size;
> +	struct arm_cca_token_info *info;
> +
> +	if (!param)
> +		return;

This check seems unnecessary and can be dropped.

> +
> +	info = (struct arm_cca_token_info *)param;
> +
> +	size = RSI_GRANULE_SIZE - info->offset;
> +	info->result = rsi_attestation_token_continue(info->granule,
> +						      info->offset, size, &len);
> +	info->offset += len;
> +}
> +

As I suggested in another reply, the return value type of rsi_attestation_token_continue()
needs to be 'unsigned long'. In that case, the type of struct arm_cca_token_info::result
needs to be adjusted either.

> +/**
> + * arm_cca_report_new - Generate a new attestation token.
> + *
> + * @report: pointer to the TSM report context information.
> + * @data:  pointer to the context specific data for this module.
> + *
> + * Initialise the attestation token generation using the challenge data
> + * passed in the TSM descriptor. Allocate memory for the attestation token
> + * and schedule calls to retrieve the attestation token on the same CPU
> + * on which the attestation token generation was initialised.
> + *
> + * The challenge data must be at least 32 bytes and no more than 64 bytes. If
> + * less than 64 bytes are provided it will be zero padded to 64 bytes.
> + *
> + * Return:
> + * * %0        - Attestation token generated successfully.
> + * * %-EINVAL  - A parameter was not valid.
> + * * %-ENOMEM  - Out of memory.
> + * * %-EFAULT  - Failed to get IPA for memory page(s).
> + * * A negative status code as returned by smp_call_function_single().
> + */
> +static int arm_cca_report_new(struct tsm_report *report, void *data)
> +{
> +	int ret;
> +	int cpu;
> +	long max_size;
> +	unsigned long token_size;
> +	struct arm_cca_token_info info;
> +	void *buf;
> +	u8 *token __free(kvfree) = NULL;
> +	struct tsm_desc *desc = &report->desc;
> +
> +	if (!report)
> +		return -EINVAL;
> +

This check seems unnecessary and can be dropped.

> +	if (desc->inblob_len < 32 || desc->inblob_len > 64)
> +		return -EINVAL;
> +
> +	/*
> +	 * Get a CPU on which the attestation token generation will be
> +	 * scheduled and initialise the attestation token generation.
> +	 */
> +	cpu = get_cpu();
> +	max_size = rsi_attestation_token_init(desc->inblob, desc->inblob_len);
> +	put_cpu();
> +

It seems that put_cpu() is called early, meaning the CPU can go away before
the subsequent call to arm_cca_attestation_continue() ?

> +	if (max_size <= 0)
> +		return -EINVAL;
> +
> +	/* Allocate outblob */
> +	token = kvzalloc(max_size, GFP_KERNEL);
> +	if (!token)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Since the outblob may not be physically contiguous, use a page
> +	 * to bounce the buffer from RMM.
> +	 */
> +	buf = alloc_pages_exact(RSI_GRANULE_SIZE, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	/* Get the PA of the memory page(s) that were allocated. */
> +	info.granule = (unsigned long)virt_to_phys(buf);
> +
> +	token_size = 0;

This initial assignment can be moved to where the variable is declared.

> +	/* Loop until the token is ready or there is an error. */
                                                              ^^

Maybe it's the personal preference, I personally prefer to avoid the ending
character '.' for the single line of comment.

> +	do {
> +		/* Retrieve one RSI_GRANULE_SIZE data per loop iteration. */
> +		info.offset = 0;
> +		do {
> +			/*
> +			 * Schedule a call to retrieve a sub-granule chunk
> +			 * of data per loop iteration.
> +			 */
> +			ret = smp_call_function_single(cpu,
> +						       arm_cca_attestation_continue,
> +						       (void *)&info, true);
> +			if (ret != 0) {
> +				token_size = 0;
> +				goto exit_free_granule_page;
> +			}
> +
> +			ret = info.result;
> +		} while ((ret == RSI_INCOMPLETE) &&
> +			 (info.offset < RSI_GRANULE_SIZE));

It may be clearer to use 'info.result' here. Besides, unnecessary () exists
in the check.

                 } while (info.result == RSI_INCOMPLETE &&
                          info.offset < RSI_GRANULE_SIZE);

Apart from that, we needn't to copy the token over when info.result isn't
RSI_SUCCESS nor RSI_INCOMPLETE.

> +
> +		/*
> +		 * Copy the retrieved token data from the granule
> +		 * to the token buffer, ensuring that the RMM doesn't
> +		 * overflow the buffer.
> +		 */
> +		if (WARN_ON(token_size + info.offset > max_size))
> +			break;
> +		memcpy(&token[token_size], buf, info.offset);
> +		token_size += info.offset;
> +	} while (ret == RSI_INCOMPLETE);
> +

As above, it may be clearer to use 'info.result' in the check.

         } while (info.result == RSI_INCOMPLETE);

> +	if (ret != RSI_SUCCESS) {
> +		ret = -ENXIO;
> +		token_size = 0;
> +		goto exit_free_granule_page;
> +	}
> +
> +	report->outblob = no_free_ptr(token);
> +exit_free_granule_page:
> +	report->outblob_len = token_size;
> +	free_pages_exact(buf, RSI_GRANULE_SIZE);
> +	return ret;
> +}
> +
> +static const struct tsm_ops arm_cca_tsm_ops = {
> +	.name = KBUILD_MODNAME,
> +	.report_new = arm_cca_report_new,
> +};
> +
> +/**
> + * arm_cca_guest_init - Register with the Trusted Security Module (TSM)
> + * interface.
> + *
> + * Return:
> + * * %0        - Registered successfully with the TSM interface.
> + * * %-ENODEV  - The execution context is not an Arm Realm.
> + * * %-EINVAL  - A parameter was not valid.
> + * * %-EBUSY   - Already registered.
> + */
> +static int __init arm_cca_guest_init(void)
> +{
> +	int ret;
> +
> +	if (!is_realm_world())
> +		return -ENODEV;
> +
> +	ret = tsm_register(&arm_cca_tsm_ops, NULL);
> +	if (ret < 0)
> +		pr_err("Failed to register with TSM.\n");
> +
> +	return ret;
> +}
> +module_init(arm_cca_guest_init);
> +

It's probably a bit helpful to print the errno returned from tsm_register().

   pr_err("Error %d registering with TSM\n", ret);

The only errno that can be returned from tsm_register() is -EBUSY. So there
is no way for arm_cca_guest_init() to return -EINVAL. The comments need
correction by dropping the description relevant to -EINVAL.

> +/**
> + * arm_cca_guest_exit - unregister with the Trusted Security Module (TSM)
> + * interface.
> + */
> +static void __exit arm_cca_guest_exit(void)
> +{
> +	tsm_unregister(&arm_cca_tsm_ops);
> +}
> +module_exit(arm_cca_guest_exit);
> +
> +MODULE_AUTHOR("Sami Mujawar <sami.mujawar@arm.com>");
> +MODULE_DESCRIPTION("Arm CCA Guest TSM Driver.");
> +MODULE_LICENSE("GPL");

The ending character '.' for the module's description may not be needed and can be
dropped.

Thanks,
Gavin


