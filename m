Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1030548A365
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 00:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345621AbiAJXHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 18:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242456AbiAJXHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 18:07:13 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38C2C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:07:12 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id u8so19927903iol.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9yk6Bcu1fitpNUpPqU1IkNlHV7SkcpGxAs+8b8ya+Jw=;
        b=kp5nhNlVfP5cUSmergeH2yUe2An8sATSkHa4jRRtTrVAMYvQZP/FZNWmKHZ3qOcRIc
         L6U/5IGi6b/ysGAvkNSykzQHtPz7peRkZwVymngeuQnIKWEdZKgMSwoAvZYAZ9tA/xh4
         LZwpz7vNXH0sXSmoBV0I5ELJCvN7753ZKRBHnRMCdHO6XxfciAKiFRbd6Xc9vnhZ+Ufv
         1PvBGG1LfDONWRH23TWZfGj2LKvhxAjydIw4UzIvxRpvJFQt9OAAEoCW3AFDyj2BMClX
         iv6pQGmRzhCB6wpQjOOc6vAPugTvrfLiYoN/1vQy3qHds667CJ4CspDZxJvLiKGpgma2
         n3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9yk6Bcu1fitpNUpPqU1IkNlHV7SkcpGxAs+8b8ya+Jw=;
        b=5IzBof+f4zWjv9tx06+QFP+0n+qIuP7Gw+Q3noy28vxNB21PgFuxqW037bzI5xj0qi
         y0ls8HBSOpq2FEFxBP191p98wotVkGMB2u+7ErarIRptXQyLENOPM8rcdGe5R097RrK6
         o12zWV98j4aJwSu8WrNeU50ubq3jbYeTdLIT8bgrkczEE8tHUjmzUjz8nsvKED4mnGBP
         xKRWNFf2fMQRhlgfbdxiOFP4IpWgWEy0pidJcyyju7wSh5CuQoFmE3HY16bYm5mqZxZo
         Qm1pyFpQUuvzt1mNEmj8vq2duyNktfe5XXnaEuWCVq1E6oHA5wpoZzNY+AVmAa/NcMMd
         sscg==
X-Gm-Message-State: AOAM533WIO+RH4SSaRc+oV7JqwoZdoIrF+0465hJKDsKNcYas+1nFRZz
        qRsUr0m4nVUU9+cIOdaeONmh2vNxt5MNo1bBLttyyQdBharGjkiV
X-Google-Smtp-Source: ABdhPJzwjiMQFRGUsTNJWfxyanbFpK/E3qPuRVxLdqjeusRLwOMQDlDT2t/VSj7mrqld5jzDVwQcC+4z1iWgVrrDbFs=
X-Received: by 2002:a05:6602:140c:: with SMTP id t12mr922733iov.187.1641856032412;
 Mon, 10 Jan 2022 15:07:12 -0800 (PST)
MIME-Version: 1.0
References: <20220110013831.1594-1-jiangyifei@huawei.com> <20220110013831.1594-6-jiangyifei@huawei.com>
In-Reply-To: <20220110013831.1594-6-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 11 Jan 2022 09:06:46 +1000
Message-ID: <CAKmqyKPsSidxir_1fncugsmLK33aSbHk63MP0JnS3OJLvy65EA@mail.gmail.com>
Subject: Re: [PATCH v4 05/12] target/riscv: Implement kvm_arch_put_registers
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

On Mon, Jan 10, 2022 at 11:57 AM Yifei Jiang via <qemu-devel@nongnu.org> wrote:
>
> Put GPR CSR and FP registers to kvm by KVM_SET_ONE_REG ioctl
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>
> ---
>  target/riscv/kvm.c | 104 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 103 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 6d4df0ef6d..e695b91dc7 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -73,6 +73,14 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
>          } \
>      } while(0)
>
> +#define KVM_RISCV_SET_CSR(cs, env, csr, reg) \
> +    do { \
> +        int ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, csr), &reg); \
> +        if (ret) { \
> +            return ret; \
> +        } \
> +    } while(0)

This fails checkpatch. I know there is lots of QEMU code like this,
but it probably should be `while (0)` to keep checkpatch happy.

Please run checkpatch on all the patches.

Alistair
