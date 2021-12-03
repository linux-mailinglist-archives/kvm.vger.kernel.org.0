Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48055467429
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 10:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351406AbhLCJmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 04:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243553AbhLCJmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 04:42:05 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4A9C06173E
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 01:38:42 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u1so4351489wru.13
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 01:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fPLe+X7B/92EvPeH79F8SC+4zXJechhiMlgJJ6ygJmM=;
        b=CJaqo33rn2+ADYA2f/NMEfRi3vbkvCgT8HP4vhySKDcBqFs6H+5s0DmFpNUdTgaXb9
         swu9tUt/h83MNptF7zM7T37Hau8UDcu9IEFeJtYOrDo9eaMrO0shVGyJ1kZuReH6PfuR
         nfwLPAaxb5gMd9+pUwcVYUCpyhlo7YFxcqWsDfaUrfAVcmHinzpe+YvjKxiQvExpdUyV
         +NkRwo6qJ2O6CKidqkOurhuU78GikV9ud2+p5sKI9BgzqapfQg9V9MROJbXY84/hYnwv
         JLmDHTOI/xOjw4MRXjqSPQVwf82QqWHn2RSLMuVRA0umGUIzyQZYKB/wgYfa747Tzjtb
         r1WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fPLe+X7B/92EvPeH79F8SC+4zXJechhiMlgJJ6ygJmM=;
        b=qdIT+PIyWhtNt/1UkhdVbQqkZdRT/YSFPc3AXoLBJPlKYBwbzjge/qi7OLKUo9oIMh
         AzhcV2fv3CdDtEprigGulsgDQesa3Sjgbr/QIuA4mEFS+UuZkRo2BIAKEYvf8cwWPvy3
         E1xjm3VDkaNA4r2JyE26+NX7bqjyWOkWS0iP89+WzvvqnPyIwyuByOHnYjqtYpPI4foY
         ZQ814k0Ofe6IPGrgUrfgiNKvNWIehufyTK8hJ3riPGoH9NNM6vyzeK3XSkKUTVtn3dHH
         9twoW2RV0Qe5yOqkCFkKO7jfGDw3ELvpzv64W/w21IhKcdJ96NKHl45wOzf2LHLBG/9l
         roCQ==
X-Gm-Message-State: AOAM530shzYZnTw31SStbEytuD7QwlJK4wdQc8wPEm75il5oD3NizYXK
        qFXxf8Wsei+yn1bJxN2Gs6Pm9zt1Aet1M8cbDU9kmw==
X-Google-Smtp-Source: ABdhPJysNJvbytvXQ9Wiw5VXNtJc5Npfsb4jjldQ+LMjn/PB6gfHLrfoog5BHaXm8GtO9JC9uFk0bMrmdlhQ7wr54uE=
X-Received: by 2002:adf:e848:: with SMTP id d8mr20955918wrn.3.1638524320486;
 Fri, 03 Dec 2021 01:38:40 -0800 (PST)
MIME-Version: 1.0
References: <20211120074644.729-1-jiangyifei@huawei.com> <20211120074644.729-11-jiangyifei@huawei.com>
In-Reply-To: <20211120074644.729-11-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Dec 2021 15:08:29 +0530
Message-ID: <CAAhSdy075GcmcMTsVsvgXN+W9Cf7EKCrycnOG9BZAkfKfp3J-w@mail.gmail.com>
Subject: Re: [PATCH v1 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
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

On Sat, Nov 20, 2021 at 1:17 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Add kvm_riscv_get/put_regs_timer to synchronize virtual time context
> from KVM.
>
> To set register of RISCV_TIMER_REG(state) will occur a error from KVM
> on kvm_timer_state == 0. It's better to adapt in KVM, but it doesn't matter
> that adaping in QEMU.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> ---
>  target/riscv/cpu.h |  6 ++++
>  target/riscv/kvm.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 78 insertions(+)
>
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index e7dba35acb..dea49e53f0 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -259,6 +259,12 @@ struct CPURISCVState {
>
>      hwaddr kernel_addr;
>      hwaddr fdt_addr;
> +
> +    /* kvm timer */
> +    bool kvm_timer_dirty;
> +    uint64_t kvm_timer_time;
> +    uint64_t kvm_timer_compare;
> +    uint64_t kvm_timer_state;

We should also include kvm_timer_frequency here.

Currently, it is read-only but in-future KVM RISC-V will allow
setting timer_frequency using SBI para-virt time scaling extension.

Regards,
Anup

>  };
>
>  OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 6d419ba02e..e5725770f2 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -64,6 +64,9 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
>  #define RISCV_CSR_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CSR, \
>                   KVM_REG_RISCV_CSR_REG(name))
>
> +#define RISCV_TIMER_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_TIMER, \
> +                 KVM_REG_RISCV_TIMER_REG(name))
> +
>  #define RISCV_FP_F_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_F, idx)
>
>  #define RISCV_FP_D_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_D, idx)
> @@ -310,6 +313,75 @@ static int kvm_riscv_put_regs_fp(CPUState *cs)
>      return ret;
>  }
>
> +static void kvm_riscv_get_regs_timer(CPUState *cs)
> +{
> +    int ret;
> +    uint64_t reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (env->kvm_timer_dirty) {
> +        return;
> +    }
> +
> +    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, time), &reg);
> +    if (ret) {
> +        abort();
> +    }
> +    env->kvm_timer_time = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, compare), &reg);
> +    if (ret) {
> +        abort();
> +    }
> +    env->kvm_timer_compare = reg;
> +
> +    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, state), &reg);
> +    if (ret) {
> +        abort();
> +    }
> +    env->kvm_timer_state = reg;
> +
> +    env->kvm_timer_dirty = true;
> +}
> +
> +static void kvm_riscv_put_regs_timer(CPUState *cs)
> +{
> +    int ret;
> +    uint64_t reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (!env->kvm_timer_dirty) {
> +        return;
> +    }
> +
> +    reg = env->kvm_timer_time;
> +    ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, time), &reg);
> +    if (ret) {
> +        abort();
> +    }
> +
> +    reg = env->kvm_timer_compare;
> +    ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, compare), &reg);
> +    if (ret) {
> +        abort();
> +    }
> +
> +    /*
> +     * To set register of RISCV_TIMER_REG(state) will occur a error from KVM
> +     * on env->kvm_timer_state == 0, It's better to adapt in KVM, but it
> +     * doesn't matter that adaping in QEMU now.
> +     * TODO If KVM changes, adapt here.
> +     */
> +    if (env->kvm_timer_state) {
> +        reg = env->kvm_timer_state;
> +        ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, state), &reg);
> +        if (ret) {
> +            abort();
> +        }
> +    }
> +
> +    env->kvm_timer_dirty = false;
> +}
>
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
> --
> 2.19.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
