Return-Path: <kvm+bounces-15805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA4008B0AAF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 182421C23463
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE08415CD69;
	Wed, 24 Apr 2024 13:19:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1A515B546;
	Wed, 24 Apr 2024 13:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713964778; cv=none; b=B0dQrL9uwM7BwBtbqJuaGU0O5QvjEdWxJRrgsWdWJFjKJfNoOA1GaYH+e27mVLf0WY0jKhLoLb77IoWdNTbFGzzwrrztF72lVd/jjYziU1M2NO1HNnniJ3yYVeIIWSt+W51Ogn5+mkZd7bkNCr1SvIYIp48DRXKov+rea254YTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713964778; c=relaxed/simple;
	bh=ra/7jHys5HrzBtDMjN1d+lExD93krBdyqnbBb71Q7v4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DwUwc3Fc0TB1TWjXIhHO7n4N6dhkruuZrxKc0cXsOHXQzMT7kjJ4RvMpNfUc4ruaQx/eloxiVnJS3hXKT1OopH6Pwn3A20iqtwYrUtkCEDIiBMiYILXpjuBfmkCoHJDCSoCh+Oy/5SW58TL6xMlDlBVFiZmshbBSit0cbxWT2jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 438422F;
	Wed, 24 Apr 2024 06:20:02 -0700 (PDT)
Received: from [10.57.86.198] (unknown [10.57.86.198])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2932E3F64C;
	Wed, 24 Apr 2024 06:19:32 -0700 (PDT)
Message-ID: <87ac462c-c453-4f3a-9b0e-5542727578aa@arm.com>
Date: Wed, 24 Apr 2024 14:19:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/14] virt: arm-cca-guest: TSM_REPORT support for
 realms
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-15-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084213.1733764-15-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/04/2024 09:42, Steven Price wrote:
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
>   drivers/virt/coco/Kconfig                     |   2 +
>   drivers/virt/coco/Makefile                    |   1 +
>   drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>   drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>   .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 208 ++++++++++++++++++
>   5 files changed, 224 insertions(+)
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>   create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> 
> diff --git a/drivers/virt/coco/Kconfig b/drivers/virt/coco/Kconfig
> index 87d142c1f932..4fb69804b622 100644
> --- a/drivers/virt/coco/Kconfig
> +++ b/drivers/virt/coco/Kconfig
> @@ -12,3 +12,5 @@ source "drivers/virt/coco/efi_secret/Kconfig"
>   source "drivers/virt/coco/sev-guest/Kconfig"
>   
>   source "drivers/virt/coco/tdx-guest/Kconfig"
> +
> +source "drivers/virt/coco/arm-cca-guest/Kconfig"
> diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
> index 18c1aba5edb7..a6228a1bf992 100644
> --- a/drivers/virt/coco/Makefile
> +++ b/drivers/virt/coco/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_TSM_REPORTS)	+= tsm.o
>   obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
>   obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
>   obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
> +obj-$(CONFIG_ARM_CCA_GUEST)	+= arm-cca-guest/
> diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig b/drivers/virt/coco/arm-cca-guest/Kconfig
> new file mode 100644
> index 000000000000..c4039c10dce2
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
> +	  realm-guest.

This needs to be updated to arm-cca-guest.

Suzuki


