Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBD6309D38
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 16:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhAaOvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 09:51:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:48572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhAaOkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 09:40:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A668DAD2B;
        Sun, 31 Jan 2021 14:40:10 +0000 (UTC)
Subject: Re: [PATCH v6 00/11] Support disabling TCG on ARM (part 2)
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Fam Zheng <fam@euphon.net>, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>, qemu-arm@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
References: <20210131115022.242570-1-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <9924223e-3aeb-5200-c7fa-f120a7ae30fe@suse.de>
Date:   Sun, 31 Jan 2021 15:40:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/21 12:50 PM, Philippe Mathieu-Daudé wrote:
> Cover from Samuel Ortiz from (part 1) [1]:
> 
>   This patchset allows for building and running ARM targets with TCG
>   disabled. [...]
> 
>   The rationale behind this work comes from the NEMU project where
>   we're trying to only support x86 and ARM 64-bit architectures,
>   without including the TCG code base. We can only do so if we can
>   build and run ARM binaries with TCG disabled.
> 
> Peter mentioned in v5 [6] that since 32-bit host has been removed,
> we have to remove v7 targets. This is not done in this series, as
> linking succeeds, and there is enough material to review (no need
> to spend time on that extra patch if the current approach is not
> accepted).
> 
> CI: https://gitlab.com/philmd/qemu/-/pipelines/249272441
> 
> v6:
> - rebased on "target/arm/Kconfig" series
> - introduce/use tcg_builtin() for realview machines
> 
> v5:
> - addressed Paolo/Richard/Thomas review comments from v4 [5].
> 
> v4 almost 2 years later... [2]:
> - Rebased on Meson
> - Addressed Richard review comments
> - Addressed Claudio review comments
> 
> v3 almost 18 months later [3]:
> - Rebased
> - Addressed Thomas review comments
> - Added Travis-CI job to keep building --disable-tcg on ARM
> 
> v2 [4]:
> - Addressed review comments from Richard and Thomas from v1 [1]
> 
> Regards,
> 
> Phil.
> 
> [1]: https://lists.gnu.org/archive/html/qemu-devel/2018-11/msg02451.html
> [2]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg689168.html
> [3]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg641796.html
> [4]: https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05003.html
> [5]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg746041.html
> [6]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg777669.html
> 
> Based-on: <20210131111316.232778-1-f4bug@amsat.org>
>           "target: Provide target-specific Kconfig"
> 
> Philippe Mathieu-Daudé (9):
>   sysemu/tcg: Introduce tcg_builtin() helper
>   exec: Restrict TCG specific headers
>   target/arm: Restrict ARMv4 cpus to TCG accel
>   target/arm: Restrict ARMv5 cpus to TCG accel
>   target/arm: Restrict ARMv6 cpus to TCG accel
>   target/arm: Restrict ARMv7 R-profile cpus to TCG accel
>   target/arm: Restrict ARMv7 M-profile cpus to TCG accel
>   target/arm: Reorder meson.build rules
>   .travis.yml: Add a KVM-only Aarch64 job
> 
> Samuel Ortiz (1):
>   target/arm: Do not build TCG objects when TCG is off
> 
> Thomas Huth (1):
>   target/arm: Make m_helper.c optional via CONFIG_ARM_V7M
> 
>  default-configs/devices/aarch64-softmmu.mak |  1 -
>  default-configs/devices/arm-softmmu.mak     | 27 --------
>  include/exec/helper-proto.h                 |  2 +
>  include/sysemu/tcg.h                        |  2 +
>  target/arm/cpu.h                            | 12 ----
>  hw/arm/realview.c                           |  7 +-
>  target/arm/cpu_tcg.c                        |  4 +-
>  target/arm/helper.c                         |  7 --
>  target/arm/m_helper-stub.c                  | 73 +++++++++++++++++++++
>  tests/qtest/cdrom-test.c                    |  6 +-
>  .travis.yml                                 | 32 +++++++++
>  hw/arm/Kconfig                              | 38 +++++++++++
>  target/arm/Kconfig                          | 17 +++++
>  target/arm/meson.build                      | 28 +++++---
>  14 files changed, 196 insertions(+), 60 deletions(-)
>  create mode 100644 target/arm/m_helper-stub.c
> 

Looking at this series, just my 2 cents on how I would suggest to go forward:
I could again split my series in two parts, with only the TCG Ops in the first part.

Then this series could be merged, enabling --disable-tcg for ARM,

then I could extend the second part of my series to include ARM as well.

Wdyt? (Probably Richard?)

Thanks,

Claudio




