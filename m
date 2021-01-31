Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAE4309D51
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 16:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhAaOdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 09:33:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:46582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231351AbhAaO37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 09:29:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 86722AD37;
        Sun, 31 Jan 2021 14:29:17 +0000 (UTC)
Subject: Re: [PATCH v6 05/11] target/arm: Restrict ARMv6 cpus to TCG accel
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
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-6-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <795e5835-bd91-8857-11b5-7d366a0a84df@suse.de>
Date:   Sun, 31 Jan 2021 15:29:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210131115022.242570-6-f4bug@amsat.org>
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
> Only enable the following ARMv6 CPUs when TCG is available:
> 
>   - ARM1136
>   - ARM1176
>   - ARM11MPCore
>   - Cortex-M0
> 
> The following machines are no more built when TCG is disabled:
> 
>   - kzm                  ARM KZM Emulation Baseboard (ARM1136)
>   - microbit             BBC micro:bit (Cortex-M0)
>   - n800                 Nokia N800 tablet aka. RX-34 (OMAP2420)
>   - n810                 Nokia N810 tablet aka. RX-44 (OMAP2420)
>   - realview-eb-mpcore   ARM RealView Emulation Baseboard (ARM11MPCore)
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  default-configs/devices/arm-softmmu.mak | 2 --
>  hw/arm/realview.c                       | 2 +-
>  tests/qtest/cdrom-test.c                | 2 +-
>  hw/arm/Kconfig                          | 6 ++++++
>  target/arm/Kconfig                      | 4 ++++
>  5 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
> index 0aad35da0c4..175530595ce 100644
> --- a/default-configs/devices/arm-softmmu.mak
> +++ b/default-configs/devices/arm-softmmu.mak
> @@ -10,9 +10,7 @@ CONFIG_ARM_VIRT=y
>  CONFIG_CUBIEBOARD=y
>  CONFIG_EXYNOS4=y
>  CONFIG_HIGHBANK=y
> -CONFIG_FSL_IMX31=y
>  CONFIG_MUSCA=y
> -CONFIG_NSERIES=y
>  CONFIG_STELLARIS=y
>  CONFIG_REALVIEW=y
>  CONFIG_VEXPRESS=y
> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
> index 2dcf0a4c23e..0606d22da14 100644
> --- a/hw/arm/realview.c
> +++ b/hw/arm/realview.c
> @@ -463,8 +463,8 @@ static void realview_machine_init(void)
>  {
>      if (tcg_builtin()) {
>          type_register_static(&realview_eb_type);
> +        type_register_static(&realview_eb_mpcore_type);
>      }
> -    type_register_static(&realview_eb_mpcore_type);
>      type_register_static(&realview_pb_a8_type);
>      type_register_static(&realview_pbx_a9_type);
>  }
> diff --git a/tests/qtest/cdrom-test.c b/tests/qtest/cdrom-test.c
> index 1f1bc26fa7a..cb0409c5a11 100644
> --- a/tests/qtest/cdrom-test.c
> +++ b/tests/qtest/cdrom-test.c
> @@ -224,8 +224,8 @@ int main(int argc, char **argv)
>          const char *armmachines[] = {
>  #ifdef CONFIG_TCG
>              "realview-eb",
> -#endif /* CONFIG_TCG */
>              "realview-eb-mpcore",
> +#endif /* CONFIG_TCG */
>              "realview-pb-a8",
>              "realview-pbx-a9", "versatileab", "versatilepb", "vexpress-a15",
>              "vexpress-a9", "virt", NULL
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index 560442bfc5c..6c4bce4d637 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -123,6 +123,8 @@ config NETDUINOPLUS2
>  
>  config NSERIES
>      bool
> +    default y if TCG && ARM
> +    select ARM_V6
>      select OMAP
>      select TMP105   # tempature sensor
>      select BLIZZARD # LCD/TV controller
> @@ -401,6 +403,8 @@ config FSL_IMX25
>  
>  config FSL_IMX31
>      bool
> +    default y if TCG && ARM
> +    select ARM_V6
>      select SERIAL
>      select IMX
>      select IMX_I2C
> @@ -478,11 +482,13 @@ config FSL_IMX6UL
>  
>  config MICROBIT
>      bool
> +    default y if TCG && ARM
>      select NRF51_SOC
>  
>  config NRF51_SOC
>      bool
>      select I2C
> +    select ARM_V6
>      select ARM_V7M
>      select UNIMP
>  
> diff --git a/target/arm/Kconfig b/target/arm/Kconfig
> index 9b3635617dc..fbb7bba9018 100644
> --- a/target/arm/Kconfig
> +++ b/target/arm/Kconfig
> @@ -14,6 +14,10 @@ config ARM_V5
>      bool
>      depends on TCG && ARM
>  
> +config ARM_V6
> +    bool
> +    depends on TCG && ARM
> +
>  config ARM_V7M
>      bool
>      select PTIMER
> 

Added Cc: Eduardo,

Looks good to me in general,

Acked-by: Claudio Fontana <cfontana@suse.de>

I am just wondering about that if (tcg_builtin()) / (or _available() as I suggest elsewhere), 
should we instead use the build system already at this stage, so no such check is necessary?

It could be a successive change, but then tcg_builtin() would be introduced, only to become useless after the proper refactoring is done,
and the build system is used to select the right modules to compile, which would do the registration.

Ciao,

Claudio

