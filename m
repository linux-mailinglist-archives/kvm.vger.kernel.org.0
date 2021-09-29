Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457AF41C2C4
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 12:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245450AbhI2Kha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 06:37:30 -0400
Received: from foss.arm.com ([217.140.110.172]:58088 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232437AbhI2Kha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 06:37:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0138ED6E;
        Wed, 29 Sep 2021 03:35:49 -0700 (PDT)
Received: from [10.57.95.68] (unknown [10.57.95.68])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 918033F70D;
        Wed, 29 Sep 2021 03:35:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Allow KVM to be disabled from the command
 line
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     ascull@google.com, dbrazdil@google.com,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210903091652.985836-1-maz@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <5bc623f2-e4c1-cc9c-683c-2f95648f1a68@arm.com>
Date:   Wed, 29 Sep 2021 11:35:46 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210903091652.985836-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/2021 10:16, Marc Zyngier wrote:
> Although KVM can be compiled out of the kernel, it cannot be disabled
> at runtime. Allow this possibility by introducing a new mode that
> will prevent KVM from initialising.
> 
> This is useful in the (limited) circumstances where you don't want
> KVM to be available (what is wrong with you?), or when you want
> to install another hypervisor instead (good luck with that).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   Documentation/admin-guide/kernel-parameters.txt |  3 +++
>   arch/arm64/include/asm/kvm_host.h               |  1 +
>   arch/arm64/kernel/idreg-override.c              |  1 +
>   arch/arm64/kvm/arm.c                            | 14 +++++++++++++-
>   4 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 91ba391f9b32..cc5f68846434 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2365,6 +2365,9 @@
>   	kvm-arm.mode=
>   			[KVM,ARM] Select one of KVM/arm64's modes of operation.
>   
> +			none: Forcefully disable KVM and run in nVHE mode,
> +			      preventing KVM from ever initialising.
> +
>   			nvhe: Standard nVHE-based mode, without support for
>   			      protected guests.
>   
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..019490c67976 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -58,6 +58,7 @@
>   enum kvm_mode {
>   	KVM_MODE_DEFAULT,
>   	KVM_MODE_PROTECTED,
> +	KVM_MODE_NONE,
>   };
>   enum kvm_mode kvm_get_mode(void);
>   
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index d8e606fe3c21..57013c1b6552 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -95,6 +95,7 @@ static const struct {
>   	char	alias[FTR_ALIAS_NAME_LEN];
>   	char	feature[FTR_ALIAS_OPTION_LEN];
>   } aliases[] __initconst = {
> +	{ "kvm-arm.mode=none",		"id_aa64mmfr1.vh=0" },
>   	{ "kvm-arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
>   	{ "kvm-arm.mode=protected",	"id_aa64mmfr1.vh=0" },
>   	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..cdc70e238316 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2064,6 +2064,11 @@ int kvm_arch_init(void *opaque)
>   		return -ENODEV;
>   	}
>   
> +	if (kvm_get_mode() == KVM_MODE_NONE) {
> +		kvm_info("KVM disabled from command line\n");
> +		return -ENODEV;
> +	}
> +
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
> @@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
>   		return 0;
>   	}
>   
> -	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode()))
> +	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
> +		kvm_mode = KVM_MODE_DEFAULT;
>   		return 0;
> +	}
> +
> +	if (strcmp(arg, "none") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {

nit: Does this really need to WARN here ? Unlike the "nvhe" case, if the
user wants to keep the KVM out of the picture for, say debugging
something, it is perfectly Ok to allow the kernel to be running at EL2
without having to change the Firmware to alter the landing EL for the
kernel ?

Otherwise,

Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
