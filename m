Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4EF309CFC
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 15:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhAaOd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 09:33:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:45664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232174AbhAaOXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 09:23:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CBB57ABD6;
        Sun, 31 Jan 2021 14:22:58 +0000 (UTC)
Subject: Re: [PATCH v6 04/11] target/arm: Restrict ARMv5 cpus to TCG accel
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
 <20210131115022.242570-5-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <553ccc92-5188-0779-fed7-be77f9c160e8@suse.de>
Date:   Sun, 31 Jan 2021 15:22:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210131115022.242570-5-f4bug@amsat.org>
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
> Only enable the following ARMv5 CPUs when TCG is available:
> 
>   - ARM926
>   - ARM946
>   - ARM1026
>   - XScale (PXA250/255/260/261/262/270)
> 
> The following machines are no more built when TCG is disabled:
> 
>   - akita                Sharp SL-C1000 (Akita) PDA (PXA270)
>   - ast2500-evb          Aspeed AST2500 EVB (ARM1176)
>   - ast2600-evb          Aspeed AST2600 EVB (Cortex A7)
>   - borzoi               Sharp SL-C3100 (Borzoi) PDA (PXA270)
>   - canon-a1100          Canon PowerShot A1100 IS (ARM946)
>   - collie               Sharp SL-5500 (Collie) PDA (SA-1110)
>   - connex               Gumstix Connex (PXA255)
>   - g220a-bmc            Bytedance G220A BMC (ARM1176)
>   - imx25-pdk            ARM i.MX25 PDK board (ARM926)
>   - integratorcp         ARM Integrator/CP (ARM926EJ-S)
>   - mainstone            Mainstone II (PXA27x)
>   - musicpal             Marvell 88w8618 / MusicPal (ARM926EJ-S)
>   - palmetto-bmc         OpenPOWER Palmetto BMC (ARM926EJ-S)
>   - realview-eb          ARM RealView Emulation Baseboard (ARM926EJ-S)
>   - romulus-bmc          OpenPOWER Romulus BMC (ARM1176)
>   - sonorapass-bmc       OCP SonoraPass BMC (ARM1176)
>   - spitz                Sharp SL-C3000 (Spitz) PDA (PXA270)
>   - supermicrox11-bmc    Supermicro X11 BMC (ARM926EJ-S)
>   - swift-bmc            OpenPOWER Swift BMC (ARM1176)
>   - tacoma-bmc           OpenPOWER Tacoma BMC (Cortex A7)
>   - terrier              Sharp SL-C3200 (Terrier) PDA (PXA270)
>   - tosa                 Sharp SL-6000 (Tosa) PDA (PXA255)
>   - verdex               Gumstix Verdex (PXA270)
>   - versatileab          ARM Versatile/AB (ARM926EJ-S)
>   - versatilepb          ARM Versatile/PB (ARM926EJ-S)
>   - witherspoon-bmc      OpenPOWER Witherspoon BMC (ARM1176)
>   - z2                   Zipit Z2 (PXA27x)
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  default-configs/devices/arm-softmmu.mak | 12 ------------
>  hw/arm/realview.c                       |  5 ++++-
>  tests/qtest/cdrom-test.c                |  6 +++++-
>  hw/arm/Kconfig                          | 19 +++++++++++++++++++
>  target/arm/Kconfig                      |  4 ++++
>  5 files changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
> index 6ae964c14fd..0aad35da0c4 100644
> --- a/default-configs/devices/arm-softmmu.mak
> +++ b/default-configs/devices/arm-softmmu.mak
> @@ -10,33 +10,21 @@ CONFIG_ARM_VIRT=y
>  CONFIG_CUBIEBOARD=y
>  CONFIG_EXYNOS4=y
>  CONFIG_HIGHBANK=y
> -CONFIG_INTEGRATOR=y
>  CONFIG_FSL_IMX31=y
> -CONFIG_MUSICPAL=y
>  CONFIG_MUSCA=y
>  CONFIG_NSERIES=y
>  CONFIG_STELLARIS=y
>  CONFIG_REALVIEW=y
> -CONFIG_VERSATILE=y
>  CONFIG_VEXPRESS=y
>  CONFIG_ZYNQ=y
> -CONFIG_MAINSTONE=y
> -CONFIG_GUMSTIX=y
> -CONFIG_SPITZ=y
> -CONFIG_TOSA=y
> -CONFIG_Z2=y
>  CONFIG_NPCM7XX=y
> -CONFIG_COLLIE=y
> -CONFIG_ASPEED_SOC=y
>  CONFIG_NETDUINO2=y
>  CONFIG_NETDUINOPLUS2=y
>  CONFIG_MPS2=y
>  CONFIG_RASPI=y
> -CONFIG_DIGIC=y
>  CONFIG_SABRELITE=y
>  CONFIG_EMCRAFT_SF2=y
>  CONFIG_MICROBIT=y
> -CONFIG_FSL_IMX25=y
>  CONFIG_FSL_IMX7=y
>  CONFIG_FSL_IMX6UL=y
>  CONFIG_ALLWINNER_H3=y
> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
> index 0831159d158..2dcf0a4c23e 100644
> --- a/hw/arm/realview.c
> +++ b/hw/arm/realview.c
> @@ -18,6 +18,7 @@
>  #include "hw/pci/pci.h"
>  #include "net/net.h"
>  #include "sysemu/sysemu.h"
> +#include "sysemu/tcg.h"
>  #include "hw/boards.h"
>  #include "hw/i2c/i2c.h"
>  #include "exec/address-spaces.h"
> @@ -460,7 +461,9 @@ static const TypeInfo realview_pbx_a9_type = {
>  
>  static void realview_machine_init(void)
>  {
> -    type_register_static(&realview_eb_type);
> +    if (tcg_builtin()) {
> +        type_register_static(&realview_eb_type);
> +    }
>      type_register_static(&realview_eb_mpcore_type);
>      type_register_static(&realview_pb_a8_type);
>      type_register_static(&realview_pbx_a9_type);
> diff --git a/tests/qtest/cdrom-test.c b/tests/qtest/cdrom-test.c
> index 5af944a5fb7..1f1bc26fa7a 100644
> --- a/tests/qtest/cdrom-test.c
> +++ b/tests/qtest/cdrom-test.c
> @@ -222,7 +222,11 @@ int main(int argc, char **argv)
>          add_cdrom_param_tests(mips64machines);
>      } else if (g_str_equal(arch, "arm") || g_str_equal(arch, "aarch64")) {
>          const char *armmachines[] = {
> -            "realview-eb", "realview-eb-mpcore", "realview-pb-a8",
> +#ifdef CONFIG_TCG
> +            "realview-eb",
> +#endif /* CONFIG_TCG */
> +            "realview-eb-mpcore",
> +            "realview-pb-a8",
>              "realview-pbx-a9", "versatileab", "versatilepb", "vexpress-a15",
>              "vexpress-a9", "virt", NULL
>          };
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index f2957b33bee..560442bfc5c 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -42,6 +42,8 @@ config CUBIEBOARD
>  
>  config DIGIC
>      bool
> +    default y if TCG && ARM
> +    select ARM_V5
>      select PTIMER
>      select PFLASH_CFI02
>  
> @@ -72,6 +74,8 @@ config HIGHBANK
>  
>  config INTEGRATOR
>      bool
> +    default y if TCG && ARM
> +    select ARM_V5
>      select ARM_TIMER
>      select INTEGRATOR_DEBUG
>      select PL011 # UART
> @@ -84,6 +88,7 @@ config INTEGRATOR
>  
>  config MAINSTONE
>      bool
> +    default y if TCG && ARM
>      select PXA2XX
>      select PFLASH_CFI01
>      select SMC91C111
> @@ -98,6 +103,8 @@ config MUSCA
>  
>  config MUSICPAL
>      bool
> +    default y if TCG && ARM
> +    select ARM_V5
>      select OR_IRQ
>      select BITBANG_I2C
>      select MARVELL_88W8618
> @@ -138,6 +145,7 @@ config OMAP
>  
>  config PXA2XX
>      bool
> +    select ARM_V5
>      select FRAMEBUFFER
>      select I2C
>      select SERIAL
> @@ -147,12 +155,14 @@ config PXA2XX
>  
>  config GUMSTIX
>      bool
> +    default y if TCG && ARM
>      select PFLASH_CFI01
>      select SMC91C111
>      select PXA2XX
>  
>  config TOSA
>      bool
> +    default y if TCG && ARM
>      select ZAURUS  # scoop
>      select MICRODRIVE
>      select PXA2XX
> @@ -160,6 +170,7 @@ config TOSA
>  
>  config SPITZ
>      bool
> +    default y if TCG && ARM
>      select ADS7846 # touch-screen controller
>      select MAX111X # A/D converter
>      select WM8750  # audio codec
> @@ -172,6 +183,7 @@ config SPITZ
>  
>  config Z2
>      bool
> +    default y if TCG && ARM
>      select PFLASH_CFI01
>      select WM8750
>      select PL011 # UART
> @@ -245,6 +257,7 @@ config STRONGARM
>  
>  config COLLIE
>      bool
> +    default y if TCG && ARM
>      select PFLASH_CFI01
>      select ZAURUS  # scoop
>      select STRONGARM
> @@ -257,6 +270,8 @@ config SX1
>  
>  config VERSATILE
>      bool
> +    default y if TCG && ARM
> +    select ARM_V5
>      select ARM_TIMER # sp804
>      select PFLASH_CFI01
>      select LSI_SCSI_PCI
> @@ -376,6 +391,8 @@ config NPCM7XX
>  
>  config FSL_IMX25
>      bool
> +    default y if TCG && ARM
> +    select ARM_V5
>      select IMX
>      select IMX_FEC
>      select IMX_I2C
> @@ -402,6 +419,8 @@ config FSL_IMX6
>  
>  config ASPEED_SOC
>      bool
> +    default y if TCG && ARM
> +    select ARM_V5
>      select DS1338
>      select FTGMAC100
>      select I2C
> diff --git a/target/arm/Kconfig b/target/arm/Kconfig
> index 811e1e81652..9b3635617dc 100644
> --- a/target/arm/Kconfig
> +++ b/target/arm/Kconfig
> @@ -10,6 +10,10 @@ config ARM_V4
>      bool
>      depends on TCG && ARM
>  
> +config ARM_V5
> +    bool
> +    depends on TCG && ARM
> +
>  config ARM_V7M
>      bool
>      select PTIMER
> 

Looks good to me

Acked-by: Claudio Fontana <cfontana@suse.de>
