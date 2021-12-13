Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033DB47200E
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 05:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhLMEkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 23:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhLMEkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 23:40:12 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F998C06173F
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:40:11 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v11so24886962wrw.10
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zTiIr8OWSR3f3Ah/0/DftB635Ef64Tgir5ocWnSiAY=;
        b=TCT+vTZkBXE7Gs0pgBRaca4BXo2tH3YZRpnCoGTv6o//Dr8n/0h2WO2DmByWuvc2cx
         ANj8nIM2UcVgHOOPEbtNIUCgejfbCy9dbnOYsIw0yrZYPEteeXZ0eMTOd6C9M2l6UZ+h
         EHBtGFVpE/PXmQ5NrOiGHeCJATeiwxlDjh+MQfyKwVVJd7X7XNZMGsslFXkiDN560Dr+
         YhJS/p5bttAfskGQUXYF8dQBeBrg1kT12zLfaxvSwljwRycJLph9noVdP9KYWFer2vy1
         RDHcERDCyYBiFLHbVFzk2ctExVfrvOkg6tt8vVBqiAofp8T++KGnojzuP/o/BcU0+1ef
         +vqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zTiIr8OWSR3f3Ah/0/DftB635Ef64Tgir5ocWnSiAY=;
        b=zwGVkKVNiB+5C3HqcwKcr3hNGqNIXLregrtHXUbMRSVjYDLxbPz+lbx9JgfuFcOVg+
         vKtxX6wOSfT3QM3KjCB5XAq8T84V3X1oxrOkbY+/v3bhrAX6gP/02fBZmcDHzqxmJQzV
         5sga2Y0oLMsdFya0HRiL0x7pAL8dRVljCmPY1TK1d7BeTTKo+xSnX0ESPRGopFT0WSWC
         qlKtdISgWGmxxjJYs4mID1x91RzLdAszZ+3JTpwbcOk3+8fgcOYs2Wu3MkUNAijP6+jh
         Ea4p2eqchmFgu0YNoxitRjRIxonxKwlTvUZKBEjLKQtGvKrfFXf2AW+HARS2GB57iRfb
         Np4A==
X-Gm-Message-State: AOAM530Q/o82N+kYf+ULRJMsUHoM/ekmc2j1WVgtaqvzeNx5LBA05QIV
        RFc4IXcjjZ8OxLf0pab0OV7Qu3E55F7PnhAF1ya0EaiZC/U=
X-Google-Smtp-Source: ABdhPJz+CpsBjjYfGUhCwCWmwSWsKTqLI5tgKCy66Psgn6elmT67fpv3TO2rfU3FXV2P1AwOlvjfVVsjgnGkFt3gYKI=
X-Received: by 2002:adf:d082:: with SMTP id y2mr30031299wrh.214.1639370410077;
 Sun, 12 Dec 2021 20:40:10 -0800 (PST)
MIME-Version: 1.0
References: <20211210100732.1080-1-jiangyifei@huawei.com> <20211210100732.1080-12-jiangyifei@huawei.com>
In-Reply-To: <20211210100732.1080-12-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 10:09:58 +0530
Message-ID: <CAAhSdy1gYnsQo2LOWAOtjSa8BKoK7btmXfaig-+6vRTF2b0QXQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/12] target/riscv: Implement virtual time adjusting
 with vm state changing
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

On Fri, Dec 10, 2021 at 3:38 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> We hope that virtual time adjusts with vm state changing. When a vm
> is stopped, guest virtual time should stop counting and kvm_timer
> should be stopped. When the vm is resumed, guest virtual time should
> continue to count and kvm_timer should be restored.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  target/riscv/kvm.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 802c076b22..be95dbc3f3 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -40,6 +40,7 @@
>  #include "kvm_riscv.h"
>  #include "sbi_ecall_interface.h"
>  #include "semihosting/console.h"
> +#include "sysemu/runstate.h"
>
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
>  {
> @@ -377,6 +378,17 @@ unsigned long kvm_arch_vcpu_id(CPUState *cpu)
>      return cpu->cpu_index;
>  }
>
> +static void kvm_riscv_vm_state_change(void *opaque, bool running, RunState state)
> +{
> +    CPUState *cs = opaque;
> +
> +    if (running) {
> +        kvm_riscv_put_regs_timer(cs);
> +    } else {
> +        kvm_riscv_get_regs_timer(cs);
> +    }
> +}
> +
>  void kvm_arch_init_irq_routing(KVMState *s)
>  {
>  }
> @@ -389,6 +401,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      CPURISCVState *env = &cpu->env;
>      uint64_t id;
>
> +    qemu_add_vm_change_state_handler(kvm_riscv_vm_state_change, cs);
> +
>      id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CONFIG, KVM_REG_RISCV_CONFIG_REG(isa));
>      ret = kvm_get_one_reg(cs, id, &isa);
>      if (ret) {
> --
> 2.19.1
>
