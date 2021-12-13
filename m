Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906B0471FD2
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 05:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhLMEP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 23:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhLMEP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 23:15:26 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC9AC06173F
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:15:26 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d24so24993498wra.0
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hQuNNiV36mSAjdx2A+UDnj7IsJtVFFXiaU04Zk+mx+E=;
        b=aAJCn2VYvrJO3L1q1FQFa2YE3Ji4AgEAr++5j5JSEWn4z31W0lNbFNEdugdo8/HQFN
         QwaiLEhrrdopD8g9RUhrZ6q+aGrEWP4nQbOFHkZl1kvJomRkxf2vW/6eEfqNWs7m13va
         B/9wanYfbipg+zo1KecnjKRki2pgIFj9qtsDm7q/sjEs1rR+JNO6qJvA+U+8DWrXAFsS
         X8e0e0JoaAhBqKMwRLSndwRLcrdGWJvE7bq5o0fBUH1QL13y/NAY9GXkwOWKMe1mO0+l
         tL3ApUPbMU66pN8FUalPoIwI2Nu7RfBrTPR6P3mUMEK+oqO3Hxh9DORia78fF27C2vnO
         bumQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hQuNNiV36mSAjdx2A+UDnj7IsJtVFFXiaU04Zk+mx+E=;
        b=ocIl4cR0t9Scxs9TKAFKFzBumuXHBQsTuisIsY0ANzr9tlc26yBt9Kjet7hc6i7/3o
         3fffxT7f87M1mBTDEAeHxVrzWd2wTxfVEJYpDF4LCr2akAQq6PJrBcuUJ+L61yefDJnD
         cSLT4kqq/Imv9pvtaU43h3u7LWGWQtJDqKJB4McAoyi4Y7RtA5Vbrrar7vbR91hqNy4u
         i7Mj7p25B4iTiOmpFXG1Y+7Yi4eKlPCefzFQPyJgWiJZDIugqgxbvHJbNNar2ZGZd3x7
         2Ez/nqIhlhnF1gKu+xrrlGYEZcbamAMOhZuLn8qKZFtOUGVY+zmlYqVa5f/U2h0qMF3H
         7imQ==
X-Gm-Message-State: AOAM53275qcTOhwKRmsoJvUcYgfpxl3TGQhqgeWVQxZCbYj7PVkGhjxZ
        dbxbC+xO74agoCUv20Msb16F3CR3r1I2/GLR4NHwiA==
X-Google-Smtp-Source: ABdhPJzsEO0NbXWE7QXUW9Ts0TN3/8EV4LxFUxaBHg8aNp0CX9LcsDcD85gipYZvAa6eRtBVN7Col3rHPtQcrxKMluI=
X-Received: by 2002:adf:d1e2:: with SMTP id g2mr29797466wrd.346.1639368924975;
 Sun, 12 Dec 2021 20:15:24 -0800 (PST)
MIME-Version: 1.0
References: <20211210100732.1080-1-jiangyifei@huawei.com> <20211210100732.1080-4-jiangyifei@huawei.com>
In-Reply-To: <20211210100732.1080-4-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 09:45:12 +0530
Message-ID: <CAAhSdy12sRcAarGN0z4HNDYrWPoJ+H6_HjXzc=2+ohdDvzeg5A@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] target/riscv: Implement function kvm_arch_init_vcpu
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
> Get isa info from kvm while kvm init.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  target/riscv/kvm.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 687dd4b621..ccf3753048 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -38,6 +38,23 @@
>  #include "qemu/log.h"
>  #include "hw/loader.h"
>
> +static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
> +{
> +    uint64_t id = KVM_REG_RISCV | type | idx;
> +
> +    switch (riscv_cpu_mxl(env)) {
> +    case MXL_RV32:
> +        id |= KVM_REG_SIZE_U32;
> +        break;
> +    case MXL_RV64:
> +        id |= KVM_REG_SIZE_U64;
> +        break;
> +    default:
> +        g_assert_not_reached();
> +    }
> +    return id;
> +}
> +
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
>  };
> @@ -79,7 +96,20 @@ void kvm_arch_init_irq_routing(KVMState *s)
>
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
> -    return 0;
> +    int ret = 0;
> +    target_ulong isa;
> +    RISCVCPU *cpu = RISCV_CPU(cs);
> +    CPURISCVState *env = &cpu->env;
> +    uint64_t id;
> +
> +    id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CONFIG, KVM_REG_RISCV_CONFIG_REG(isa));
> +    ret = kvm_get_one_reg(cs, id, &isa);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->misa_ext = isa;
> +
> +    return ret;
>  }
>
>  int kvm_arch_msi_data_to_gsi(uint32_t data)
> --
> 2.19.1
>
