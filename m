Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 728431840DB
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 07:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgCMGby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 02:31:54 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36323 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgCMGby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 02:31:54 -0400
Received: by mail-io1-f67.google.com with SMTP id d15so8261697iog.3;
        Thu, 12 Mar 2020 23:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gwo18I+qhDyK0f9CRK6fxLCdLThMsDTks/uef8gm4kY=;
        b=arC548UFw58zPiZMTGpKSTA6C6cShe4/2dw/ERpegDkNqAfCg04TZN4DNuXAGiPlWr
         wpIlPtGJ8GPVxD37ww0/w34k112uvnTr9PsHbgyAiKqDeKaTewKk4XNcZL3L1tLv/2Ty
         zhQaCGOfFI4vhmKGlFgoFBweHPRg9V4g50Cg4rmKpBG1oULr/u58nB5rowQucqVdBFDC
         taW9/oROrxRrnjSpEKQiok8fJOJ9zvNbuhGz9A+i/aAJOr4VSfxZSZb2aS4P5uMEe/F6
         9Q/rIiQfE5+nL17Egz0+euMGpKMeuYP5t2KK/XV6aDHDZVyI+pT+jdTTsK+Bl2C+vh78
         JTHA==
X-Gm-Message-State: ANhLgQ0vLxbb7Qf1CtK3POF+QhCCMG9wEy8KvB0KkXthXDXKSdlgNBJf
        kmxekXZfdla1cQouxOd53WTgJoMlPyH+Z8GESaAVT+cW
X-Google-Smtp-Source: ADFU+vsYn7olWjR5ZdnVzmHpadFtCBryj55XjQULGF5Jf4ExDfr1NLEO1VzBnFywsf13xgwymPRjhRkizQCmf4VjPIo=
X-Received: by 2002:a6b:8ec2:: with SMTP id q185mr10907291iod.180.1584081112766;
 Thu, 12 Mar 2020 23:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <1584069257-30896-1-git-send-email-lixing@loongson.cn> <1584069257-30896-3-git-send-email-lixing@loongson.cn>
In-Reply-To: <1584069257-30896-3-git-send-email-lixing@loongson.cn>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 13 Mar 2020 14:38:20 +0800
Message-ID: <CAAhV-H6_eouq_i9RRntTVk2kwEDf62zSoy1Xz9rD30cVjKcRyg@mail.gmail.com>
Subject: Re: [PATCH v2 Resend 3/3] KVM: MIPS: Support kvm modules autoprobed
 when startup system
To:     Xing Li <lixing@loongson.cn>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, maobibo@loongson.cn,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Lixing,

On Fri, Mar 13, 2020 at 11:14 AM Xing Li <lixing@loongson.cn> wrote:
>
> Currently, the module_init of kvm_mips_init cannot force the kvm
> modules insmod when startup system.
>
> Add new feature CPU_MIPS_VZ in elf_hwcap to support KVM auto probe
> when hardware virtualization supported.
I think this patch is not suitable, because:
1, KVM has VZ mode and TE mode, you only consider VZ mode?
2, As X86 does, you can use udev or modprobe.conf to autoprobe kvm module.

Regards,
Huacai
>
> Signed-off-by: Xing Li <lixing@loongson.cn>
> ---
>  arch/mips/include/uapi/asm/hwcap.h | 1 +
>  arch/mips/kernel/cpu-probe.c       | 4 +++-
>  arch/mips/kvm/mips.c               | 3 ++-
>  3 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
> index 1ade1da..9e66509 100644
> --- a/arch/mips/include/uapi/asm/hwcap.h
> +++ b/arch/mips/include/uapi/asm/hwcap.h
> @@ -17,5 +17,6 @@
>  #define HWCAP_LOONGSON_MMI  (1 << 11)
>  #define HWCAP_LOONGSON_EXT  (1 << 12)
>  #define HWCAP_LOONGSON_EXT2 (1 << 13)
> +#define HWCAP_MIPS_VZ       (1 << 14)
>
>  #endif /* _UAPI_ASM_HWCAP_H */
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index c543326..b305269 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -2242,8 +2242,10 @@ void cpu_probe(void)
>         if (cpu_has_loongson_ext2)
>                 elf_hwcap |= HWCAP_LOONGSON_EXT2;
>
> -       if (cpu_has_vz)
> +       if (cpu_has_vz) {
>                 cpu_probe_vz(c);
> +               elf_hwcap |= HWCAP_MIPS_VZ;
> +       }
>
>         cpu_probe_vmbits(c);
>
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 1109924..1da5df3 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -19,6 +19,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/fs.h>
>  #include <linux/memblock.h>
> +#include <linux/cpufeature.h>
>
>  #include <asm/fpu.h>
>  #include <asm/page.h>
> @@ -1742,7 +1743,7 @@ static void __exit kvm_mips_exit(void)
>         unregister_die_notifier(&kvm_mips_csr_die_notifier);
>  }
>
> -module_init(kvm_mips_init);
> +module_cpu_feature_match(MIPS_VZ, kvm_mips_init);
>  module_exit(kvm_mips_exit);
>
>  EXPORT_TRACEPOINT_SYMBOL(kvm_exit);
> --
> 2.1.0
>
