Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A295153757
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 19:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbgBESRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 13:17:04 -0500
Received: from foss.arm.com ([217.140.110.172]:50662 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727550AbgBESRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 13:17:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F9D01FB;
        Wed,  5 Feb 2020 10:17:03 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 042003F52E;
        Wed,  5 Feb 2020 10:17:00 -0800 (PST)
Subject: Re: [PATCH kvmtool 04/16] kvmtool: Add helper to sanitize arch
 specific KVM configuration
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, julien.grall@arm.com, andre.przywara@arm.com
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <1569245722-23375-5-git-send-email-alexandru.elisei@arm.com>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <916fbe5a-ae8c-412c-b2ae-9c93e9d755e7@arm.com>
Date:   Wed, 5 Feb 2020 18:16:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1569245722-23375-5-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2019 14:35, Alexandru Elisei wrote:
> kvmtool accepts generic and architecture specific parameters. When creating
> a virtual machine, only the generic parameters are checked against sane
> values. Add a function to sanitize the architecture specific configuration
> options and call it before the initialization routines.
> 
> This patch was inspired by Julien Grall's patch.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arm/aarch64/include/kvm/kvm-arch.h |  2 +-
>   arm/include/arm-common/kvm-arch.h  |  4 ++++
>   arm/kvm.c                          | 11 +++++++++--
>   builtin-run.c                      |  2 ++
>   mips/include/kvm/kvm-arch.h        |  4 ++++
>   mips/kvm.c                         |  5 +++++
>   powerpc/include/kvm/kvm-arch.h     |  4 ++++
>   powerpc/kvm.c                      |  5 +++++
>   x86/include/kvm/kvm-arch.h         |  4 ++++
>   x86/kvm.c                          | 24 ++++++++++++------------
>   10 files changed, 50 insertions(+), 15 deletions(-)
> 
> diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
> index 9de623ac6cb9..1b3d0a5fb1b4 100644
> --- a/arm/aarch64/include/kvm/kvm-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-arch.h
> @@ -5,7 +5,7 @@
>   				0x8000				:	\
>   				0x80000)
>   
> -#define ARM_MAX_MEMORY(kvm)	((kvm)->cfg.arch.aarch32_guest	?	\
> +#define ARM_MAX_MEMORY(cfg)	((cfg)->arch.aarch32_guest	?	\
>   				ARM_LOMAP_MAX_MEMORY		:	\
>   				ARM_HIMAP_MAX_MEMORY)
>   
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index b9d486d5eac2..965978d7cfb5 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -74,4 +74,8 @@ struct kvm_arch {
>   	u64	dtb_guest_start;
>   };
>   
> +struct kvm_config;
> +
> +void kvm__arch_sanitize_cfg(struct kvm_config *cfg);

minor nit: We could have passed "struct kvm", which could

1) avoid the hunk above for ARM_MAX_MEMORY()
2) make better use of the other info available in KVM for
    anything that we could potentially do.

But hey, we don't change the kvmtool that much. So, feel free
to ignore this.

Either way:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
