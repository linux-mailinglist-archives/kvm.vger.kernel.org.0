Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98964309CF8
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 15:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhAaOdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 09:33:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:45308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232009AbhAaOVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 09:21:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 01E3FB159;
        Sun, 31 Jan 2021 14:21:11 +0000 (UTC)
Subject: Re: [PATCH v6 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-4-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <7798c062-b657-336d-ee51-e24465c5bd2c@suse.de>
Date:   Sun, 31 Jan 2021 15:21:10 +0100
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

Looks good to me

Acked-by: Claudio Fontana <cfontana@suse.de>

