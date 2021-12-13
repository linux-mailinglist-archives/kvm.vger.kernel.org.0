Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E0A472007
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 05:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhLMEhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 23:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbhLMEhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 23:37:18 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CF5C06173F
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:37:17 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id j3so24962648wrp.1
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kKCr2ecM6VBsb8ohhcbuab5U65Dp3oJzfYpYi0gNHbE=;
        b=17LM5XvH8e1cnkvKk5Ew22eudYjKMtrCHBWvTQUqJFsDE661jcJD2TKWb80TCT82J1
         zD2avhRsUSKGkyuda4nkVyvIdSOdI/5fL0JKGgOnOYtlPvSzGgfK/NSEXXG8rUXUgaqC
         eKp7DVK/WHNVzS5jdCg08iKivOtdT6KWVYI6VpiMl9CYFvWjj8+N1YHfNv/FJvBRy+MR
         WogxgARlHi5RYOr/XbRmih4oaS0MKyAqlYktyFK+hXoCRXNYMgT4MKCr08YPgo7Glgwy
         yMELnvRvWop20UaiZpMs892PdWCEQpA18yetfDo1WbrxM+DjbySKt1aa0wc4kBXllzIB
         wXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kKCr2ecM6VBsb8ohhcbuab5U65Dp3oJzfYpYi0gNHbE=;
        b=CGYwkUt/Pq4oPXW7vS1KGbBs83VDZSeAEqNSZj7bdDa0V0elMETlCTYXMpDGKZHdek
         V5jGDIWB2Ut5wZ2k6YOrUfkC7untP2BvJiXWFLPbs6bHqkx5gC53ukdmcO6ZTdixujBh
         anAT2TcgESEamYfNUudd0Q3xk4wmMMBDkzlcZ1z60jpobVsJLgY/cP6Va6P0wjzgs0TQ
         sibumKGdvBnDT0b174hyJFvxNH3DxaAgScfdrAQqgjNbBbn1GJHvcPi3SDLJiiDynv/O
         BrrtD8s/USVd01CKQBB0do1TE6P6SpSnzl0cvkp5ErjfDwORlMVKQRkb85TFEBZgFfnk
         hFfw==
X-Gm-Message-State: AOAM532DUuKk/gO+69dgldH1dHRI15r0/o0kzuHFSqRLtHaoAFwv3zJ4
        JnnlVvlKENA2QdW9M5pLqX+uUIOEWH+R0f3ZBcTv5w==
X-Google-Smtp-Source: ABdhPJyPjhB3U7Dgrq0pcHpZV9ySNICkS4hCSXx3Z88oXhFwRhpHQx1egn3yO1EQpj8GellDGtX5XzovPmsjQVEEniI=
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr29349165wrx.86.1639370235926;
 Sun, 12 Dec 2021 20:37:15 -0800 (PST)
MIME-Version: 1.0
References: <20211210100732.1080-1-jiangyifei@huawei.com> <20211210100732.1080-9-jiangyifei@huawei.com>
In-Reply-To: <20211210100732.1080-9-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 10:07:04 +0530
Message-ID: <CAAhSdy2yif18ewN_-77eRRkhsO-7iZGev0J6cs_DKg5Uq+=V=g@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] target/riscv: Handle KVM_EXIT_RISCV_SBI exit
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        libvir-list@redhat.com, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 3:37 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Use char-fe to handle console sbi call, which implement early
> console io while apply 'earlycon=sbi' into kernel parameters.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  target/riscv/kvm.c                 | 38 +++++++++++++++-
>  target/riscv/sbi_ecall_interface.h | 72 ++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+), 1 deletion(-)
>  create mode 100644 target/riscv/sbi_ecall_interface.h
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 0027f11f45..171a32adf9 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -38,6 +38,8 @@
>  #include "qemu/log.h"
>  #include "hw/loader.h"
>  #include "kvm_riscv.h"
> +#include "sbi_ecall_interface.h"
> +#include "semihosting/console.h"
>
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
>  {
> @@ -365,9 +367,43 @@ bool kvm_arch_stop_on_emulation_error(CPUState *cs)
>      return true;
>  }
>
> +static int kvm_riscv_handle_sbi(CPUState *cs, struct kvm_run *run)
> +{
> +    int ret = 0;
> +    unsigned char ch;
> +    switch (run->riscv_sbi.extension_id) {
> +    case SBI_EXT_0_1_CONSOLE_PUTCHAR:
> +        ch = run->riscv_sbi.args[0];
> +        qemu_semihosting_log_out((const char *)&ch, sizeof(ch));
> +        break;
> +    case SBI_EXT_0_1_CONSOLE_GETCHAR:
> +        run->riscv_sbi.args[0] =
> +            (unsigned long)qemu_semihosting_console_inc(cs->env_ptr);
> +        break;
> +    default:
> +        qemu_log_mask(LOG_UNIMP,
> +                      "%s: un-handled SBI EXIT, specific reasons is %lu\n",
> +                      __func__, run->riscv_sbi.extension_id);
> +        ret = -1;
> +        break;
> +    }
> +    return ret;
> +}
> +
>  int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>  {
> -    return 0;
> +    int ret = 0;
> +    switch (run->exit_reason) {
> +    case KVM_EXIT_RISCV_SBI:
> +        ret = kvm_riscv_handle_sbi(cs, run);
> +        break;
> +    default:
> +        qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
> +                      __func__, run->exit_reason);
> +        ret = -1;
> +        break;
> +    }
> +    return ret;
>  }
>
>  void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
> diff --git a/target/riscv/sbi_ecall_interface.h b/target/riscv/sbi_ecall_interface.h
> new file mode 100644
> index 0000000000..fb1a3fa8f2
> --- /dev/null
> +++ b/target/riscv/sbi_ecall_interface.h
> @@ -0,0 +1,72 @@
> +/*
> + * SPDX-License-Identifier: BSD-2-Clause
> + *
> + * Copyright (c) 2019 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *   Anup Patel <anup.patel@wdc.com>
> + */
> +
> +#ifndef __SBI_ECALL_INTERFACE_H__
> +#define __SBI_ECALL_INTERFACE_H__
> +
> +/* clang-format off */
> +
> +/* SBI Extension IDs */
> +#define SBI_EXT_0_1_SET_TIMER           0x0
> +#define SBI_EXT_0_1_CONSOLE_PUTCHAR     0x1
> +#define SBI_EXT_0_1_CONSOLE_GETCHAR     0x2
> +#define SBI_EXT_0_1_CLEAR_IPI           0x3
> +#define SBI_EXT_0_1_SEND_IPI            0x4
> +#define SBI_EXT_0_1_REMOTE_FENCE_I      0x5
> +#define SBI_EXT_0_1_REMOTE_SFENCE_VMA   0x6
> +#define SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID 0x7
> +#define SBI_EXT_0_1_SHUTDOWN            0x8
> +#define SBI_EXT_BASE                    0x10
> +#define SBI_EXT_TIME                    0x54494D45
> +#define SBI_EXT_IPI                     0x735049
> +#define SBI_EXT_RFENCE                  0x52464E43
> +#define SBI_EXT_HSM                     0x48534D
> +
> +/* SBI function IDs for BASE extension*/
> +#define SBI_EXT_BASE_GET_SPEC_VERSION   0x0
> +#define SBI_EXT_BASE_GET_IMP_ID         0x1
> +#define SBI_EXT_BASE_GET_IMP_VERSION    0x2
> +#define SBI_EXT_BASE_PROBE_EXT          0x3
> +#define SBI_EXT_BASE_GET_MVENDORID      0x4
> +#define SBI_EXT_BASE_GET_MARCHID        0x5
> +#define SBI_EXT_BASE_GET_MIMPID         0x6
> +
> +/* SBI function IDs for TIME extension*/
> +#define SBI_EXT_TIME_SET_TIMER          0x0
> +
> +/* SBI function IDs for IPI extension*/
> +#define SBI_EXT_IPI_SEND_IPI            0x0
> +
> +/* SBI function IDs for RFENCE extension*/
> +#define SBI_EXT_RFENCE_REMOTE_FENCE_I       0x0
> +#define SBI_EXT_RFENCE_REMOTE_SFENCE_VMA    0x1
> +#define SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID  0x2
> +#define SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA   0x3
> +#define SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID 0x4
> +#define SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA   0x5
> +#define SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID 0x6
> +
> +/* SBI function IDs for HSM extension */
> +#define SBI_EXT_HSM_HART_START          0x0
> +#define SBI_EXT_HSM_HART_STOP           0x1
> +#define SBI_EXT_HSM_HART_GET_STATUS     0x2
> +
> +#define SBI_HSM_HART_STATUS_STARTED     0x0
> +#define SBI_HSM_HART_STATUS_STOPPED     0x1
> +#define SBI_HSM_HART_STATUS_START_PENDING   0x2
> +#define SBI_HSM_HART_STATUS_STOP_PENDING    0x3
> +
> +#define SBI_SPEC_VERSION_MAJOR_OFFSET   24
> +#define SBI_SPEC_VERSION_MAJOR_MASK     0x7f
> +#define SBI_SPEC_VERSION_MINOR_MASK     0xffffff
> +#define SBI_EXT_VENDOR_START            0x09000000
> +#define SBI_EXT_VENDOR_END              0x09FFFFFF
> +/* clang-format on */
> +
> +#endif
> --
> 2.19.1
>
