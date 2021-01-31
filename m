Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FDB309D01
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 15:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhAaOeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 09:34:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:46784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231493AbhAaObP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 09:31:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B8E87AD3E;
        Sun, 31 Jan 2021 14:30:33 +0000 (UTC)
Subject: Re: [PATCH v6 07/11] target/arm: Restrict ARMv7 M-profile cpus to TCG
 accel
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
 <20210131115022.242570-8-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <ae9c7af9-3036-d7f6-194f-ee91acf0e016@suse.de>
Date:   Sun, 31 Jan 2021 15:30:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210131115022.242570-8-f4bug@amsat.org>
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
> Beside, KVM only supports A-profile, thus won't be able to run
> M-profile cpus.
> 
> Only enable the following ARMv7 M-Profile CPUs when TCG is available:
> 
>   - Cortex-M0
>   - Cortex-M3
>   - Cortex-M4
>   - Cortex-M33
> 
> The following machines are no more built when TCG is disabled:
> 
>   - emcraft-sf2          SmartFusion2 SOM kit from Emcraft (M2S010)
>   - highbank             Calxeda Highbank (ECX-1000)
>   - lm3s6965evb          Stellaris LM3S6965EVB (Cortex-M3)
>   - lm3s811evb           Stellaris LM3S811EVB (Cortex-M3)
>   - midway               Calxeda Midway (ECX-2000)
>   - mps2-an385           ARM MPS2 with AN385 FPGA image for Cortex-M3
>   - mps2-an386           ARM MPS2 with AN386 FPGA image for Cortex-M4
>   - mps2-an500           ARM MPS2 with AN500 FPGA image for Cortex-M7
>   - mps2-an505           ARM MPS2 with AN505 FPGA image for Cortex-M33
>   - mps2-an511           ARM MPS2 with AN511 DesignStart FPGA image for Cortex-M3
>   - mps2-an521           ARM MPS2 with AN521 FPGA image for dual Cortex-M33
>   - musca-a              ARM Musca-A board (dual Cortex-M33)
>   - musca-b1             ARM Musca-B1 board (dual Cortex-M33)
>   - netduino2            Netduino 2 Machine (Cortex-M3)
>   - netduinoplus2        Netduino Plus 2 Machine(Cortex-M4)
> 
> We don't need to enforce CONFIG_ARM_V7M in default-configs anymore.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  default-configs/devices/arm-softmmu.mak | 11 -----------
>  hw/arm/Kconfig                          |  7 +++++++
>  target/arm/Kconfig                      |  1 +
>  3 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
> index 175530595ce..0fc80d7d6df 100644
> --- a/default-configs/devices/arm-softmmu.mak
> +++ b/default-configs/devices/arm-softmmu.mak
> @@ -1,28 +1,17 @@
>  # Default configuration for arm-softmmu
>  
> -# TODO: ARM_V7M is currently always required - make this more flexible!
> -CONFIG_ARM_V7M=y
> -
>  # CONFIG_PCI_DEVICES=n
>  # CONFIG_TEST_DEVICES=n
>  
>  CONFIG_ARM_VIRT=y
>  CONFIG_CUBIEBOARD=y
>  CONFIG_EXYNOS4=y
> -CONFIG_HIGHBANK=y
> -CONFIG_MUSCA=y
> -CONFIG_STELLARIS=y
>  CONFIG_REALVIEW=y
>  CONFIG_VEXPRESS=y
>  CONFIG_ZYNQ=y
>  CONFIG_NPCM7XX=y
> -CONFIG_NETDUINO2=y
> -CONFIG_NETDUINOPLUS2=y
> -CONFIG_MPS2=y
>  CONFIG_RASPI=y
>  CONFIG_SABRELITE=y
> -CONFIG_EMCRAFT_SF2=y
> -CONFIG_MICROBIT=y
>  CONFIG_FSL_IMX7=y
>  CONFIG_FSL_IMX6UL=y
>  CONFIG_ALLWINNER_H3=y
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index 4baf1f97694..62f8b0d24e7 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -60,6 +60,7 @@ config EXYNOS4
>  
>  config HIGHBANK
>      bool
> +    default y if TCG && ARM
>      select A9MPCORE
>      select A15MPCORE
>      select AHCI
> @@ -95,6 +96,7 @@ config MAINSTONE
>  
>  config MUSCA
>      bool
> +    default y if TCG && ARM
>      select ARMSSE
>      select PL011
>      select PL031
> @@ -115,10 +117,12 @@ config MUSICPAL
>  
>  config NETDUINO2
>      bool
> +    default y if TCG && ARM
>      select STM32F205_SOC
>  
>  config NETDUINOPLUS2
>      bool
> +    default y if TCG && ARM
>      select STM32F405_SOC
>  
>  config NSERIES
> @@ -240,6 +244,7 @@ config SABRELITE
>  
>  config STELLARIS
>      bool
> +    default y if TCG && ARM
>      select ARM_V7M
>      select CMSDK_APB_WATCHDOG
>      select I2C
> @@ -443,6 +448,7 @@ config ASPEED_SOC
>  
>  config MPS2
>      bool
> +    default y if TCG && ARM
>      select ARMSSE
>      select LAN9118
>      select MPS2_FPGAIO
> @@ -496,6 +502,7 @@ config NRF51_SOC
>  
>  config EMCRAFT_SF2
>      bool
> +    default y if TCG && ARM
>      select MSF2
>      select SSI_M25P80
>  
> diff --git a/target/arm/Kconfig b/target/arm/Kconfig
> index 4dc96c46520..07a2fad7a2b 100644
> --- a/target/arm/Kconfig
> +++ b/target/arm/Kconfig
> @@ -24,4 +24,5 @@ config ARM_V7R
>  
>  config ARM_V7M
>      bool
> +    depends on TCG && ARM
>      select PTIMER
> 

Acked-by: Claudio Fontana <cfontana@suse.de>
