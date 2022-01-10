Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B8848905F
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 07:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiAJGtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 01:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiAJGtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 01:49:16 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84163C06173F
        for <kvm@vger.kernel.org>; Sun,  9 Jan 2022 22:49:15 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id y11so16194556iod.6
        for <kvm@vger.kernel.org>; Sun, 09 Jan 2022 22:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UngnJwPTdW06Vewlid5EdxtKrdw9E5PBkNU7imKIie8=;
        b=G0F7MMDZIRfSQPJhT2x/pZxQmS73pbXPG3ITPKmhjjhIV7VcPpsClJT9gy5+MJDLtY
         1+MdcfOtKm8JebJKkdlvQaYy1xR4eRcakbch/32yLrNI3dt41tG7Adz/HctCu5Ljandj
         1w3DcNjCnBaQZGuMDpMN0+46GsN1r45l6MvS5JpaoIY6i4CT8EfSOQYipNq7uL66Dm/4
         ieVI6zmA1OZ4ysfZzo6Ut2l/NhX/upBoHtzZkDVxB4HcC5tOdA1ATp8ZBPwm2a18cHAJ
         lHU/zEblVY89Myt+ljZjYHB2fb9dyLXFL3UrP4IrPn4y+I+swzaGYYnT1eIxpFyz/2vG
         6o0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UngnJwPTdW06Vewlid5EdxtKrdw9E5PBkNU7imKIie8=;
        b=C6lyuyA5qbsiEQRlfsLuSyQhmIKA4l7XhMtDVX3Kq96vK3SVOBB5FhPqAIRupdF5dP
         CvPYpQnbsJhZIL2jEwOYToKvtLYWLlCdSDtfvb050k2fGHk2QmbRfR58TjlOaE3njCuC
         91zxr+8ioqrM3J3XO2AV6k7yesWcvM845yc8VSaWbPzehaY/YdNGVPBAURr7YpDYQofQ
         tfp0onu7Qc1ZUSpW4QWkI72fH4nk5/4riG2loZ5gDXH+sxYvLiF6KDz12ZH5izj1C8UL
         d6IF31T03KQq3U+W5xDvtlmwQkguxRirVJsKrh6pIfoH3AcKrVqUu7Tq9+ZqhX2LNlTB
         ezzw==
X-Gm-Message-State: AOAM532akZBSpgk8C/PMSkjG4xfjQ/i9HhCD3jdaheQi8Q5j9/X+iXJq
        kvZaclf26NP8FnBrGFP1Ffk2Iy89BTgCxeHp2VMHDOhee0UIB3qH
X-Google-Smtp-Source: ABdhPJyx+T2JxsxPKptnjlak8JZqTtdokpYw3S1FBToK2I0b4LKYRlCQx/ycm+PVdvfxf2Ic3QlchL7PbrsTX9fkOYM=
X-Received: by 2002:a02:aa8f:: with SMTP id u15mr34430273jai.63.1641797354958;
 Sun, 09 Jan 2022 22:49:14 -0800 (PST)
MIME-Version: 1.0
References: <20220110013831.1594-1-jiangyifei@huawei.com> <20220110013831.1594-9-jiangyifei@huawei.com>
In-Reply-To: <20220110013831.1594-9-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Mon, 10 Jan 2022 16:48:48 +1000
Message-ID: <CAKmqyKMoCVpdKv+PJ+pu5Wvr45K1+wSVA+rTxf+_Ga16ErZGUw@mail.gmail.com>
Subject: Re: [PATCH v4 08/12] target/riscv: Handle KVM_EXIT_RISCV_SBI exit
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>,
        Anup Patel <anup.patel@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 11:49 AM Yifei Jiang via <qemu-devel@nongnu.org> wrote:
>
> Use char-fe to handle console sbi call, which implement early
> console io while apply 'earlycon=sbi' into kernel parameters.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/kvm.c                 | 42 ++++++++++++++++-
>  target/riscv/sbi_ecall_interface.h | 72 ++++++++++++++++++++++++++++++
>  2 files changed, 113 insertions(+), 1 deletion(-)
>  create mode 100644 target/riscv/sbi_ecall_interface.h
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 0027f11f45..ded2a8c29d 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -38,6 +38,8 @@
>  #include "qemu/log.h"
>  #include "hw/loader.h"
>  #include "kvm_riscv.h"
> +#include "sbi_ecall_interface.h"
> +#include "chardev/char-fe.h"
>
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
>  {
> @@ -365,9 +367,47 @@ bool kvm_arch_stop_on_emulation_error(CPUState *cs)
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
> +        qemu_chr_fe_write(serial_hd(0)->be, &ch, sizeof(ch));
> +        break;
> +    case SBI_EXT_0_1_CONSOLE_GETCHAR:
> +        ret = qemu_chr_fe_read_all(serial_hd(0)->be, &ch, sizeof(ch));
> +        if (ret == sizeof(ch)) {
> +            run->riscv_sbi.args[0] = ch;
> +        } else {
> +            run->riscv_sbi.args[0] = -1;
> +        }
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
>
