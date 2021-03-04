Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C7532D216
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 12:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbhCDL4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 06:56:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:37458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239462AbhCDLz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 06:55:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 37A87AF87;
        Thu,  4 Mar 2021 11:55:17 +0000 (UTC)
Subject: Re: [PATCH v6 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Fam Zheng <fam@euphon.net>, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>, qemu-arm@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-4-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <1f571396-c225-0372-12f2-1a366ad181c7@suse.de>
Date:   Thu, 4 Mar 2021 12:55:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210131115022.242570-4-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I am trying to take these patches,
in the hope that they help with some of the test issues I am having with the kvm-only build,

but they fail with:

target/arm/Kconfig: does not exist in index

so I guess I need the "target/arm/Kconfig" series right, how can I find that one?

Thanks,

Claudio



On 1/31/21 12:50 PM, Philippe Mathieu-Daudé wrote:
> KVM requires the target cpu to be at least ARMv8 architecture
> (support on ARMv7 has been dropped in commit 82bf7ae84ce:
> "target/arm: Remove KVM support for 32-bit Arm hosts").
> 
> Only enable the following ARMv4 CPUs when TCG is available:
> 
>   - StrongARM (SA1100/1110)
>   - OMAP1510 (TI925T)
> 
> The following machines are no more built when TCG is disabled:
> 
>   - cheetah              Palm Tungsten|E aka. Cheetah PDA (OMAP310)
>   - sx1                  Siemens SX1 (OMAP310) V2
>   - sx1-v1               Siemens SX1 (OMAP310) V1
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  default-configs/devices/arm-softmmu.mak | 2 --
>  hw/arm/Kconfig                          | 4 ++++
>  target/arm/Kconfig                      | 4 ++++
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
> index 0824e9be795..6ae964c14fd 100644
> --- a/default-configs/devices/arm-softmmu.mak
> +++ b/default-configs/devices/arm-softmmu.mak
> @@ -14,8 +14,6 @@ CONFIG_INTEGRATOR=y
>  CONFIG_FSL_IMX31=y
>  CONFIG_MUSICPAL=y
>  CONFIG_MUSCA=y
> -CONFIG_CHEETAH=y
> -CONFIG_SX1=y
>  CONFIG_NSERIES=y
>  CONFIG_STELLARIS=y
>  CONFIG_REALVIEW=y
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index f3ecb73a3d8..f2957b33bee 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -31,6 +31,8 @@ config ARM_VIRT
>  
>  config CHEETAH
>      bool
> +    default y if TCG && ARM
> +    select ARM_V4
>      select OMAP
>      select TSC210X
>  
> @@ -249,6 +251,8 @@ config COLLIE
>  
>  config SX1
>      bool
> +    default y if TCG && ARM
> +    select ARM_V4
>      select OMAP
>  
>  config VERSATILE
> diff --git a/target/arm/Kconfig b/target/arm/Kconfig
> index ae89d05c7e5..811e1e81652 100644
> --- a/target/arm/Kconfig
> +++ b/target/arm/Kconfig
> @@ -6,6 +6,10 @@ config AARCH64
>      bool
>      select ARM
>  
> +config ARM_V4
> +    bool
> +    depends on TCG && ARM
> +
>  config ARM_V7M
>      bool
>      select PTIMER
> 

