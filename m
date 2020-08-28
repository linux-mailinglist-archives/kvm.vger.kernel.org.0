Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369702553DD
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 06:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgH1Er2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 00:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgH1Er1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 00:47:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F465C061264
        for <kvm@vger.kernel.org>; Thu, 27 Aug 2020 21:47:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x7so43052wro.3
        for <kvm@vger.kernel.org>; Thu, 27 Aug 2020 21:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VoHjgG7QKE51iIfhD6VjTDAp7Ojtyk5HJQxEFibU7HM=;
        b=w4bavdWtOQoS3sfGaaTkABme/fmWscqxZ5LrFLLfrldCDaD5j15cu3uS+4KRzGWtAD
         jL5fKfr/VbGOMCueuYkDR/IHdD3S+K2HmqNHE33cZe92yF3E730cfcNfvJRvvjtvpofv
         o4VjvLoEiX/gTqSaMavHf835jiuIHMP9e29nXHVG3LCcfX1ntDV6SrcZNkxl9BbWySpQ
         L0xCcy75cNcozpbzciAGbPd0mlviVTMYGY1OdS6hsy7vPnm4oCc9i0TaN8v5awlLyqP8
         wKvDiHVEv3U0CxqaC7XDBCMfulRckM5RDLbgkftLx/QA7YHy9JcF1QvK7zu0sHK6W0NZ
         GRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VoHjgG7QKE51iIfhD6VjTDAp7Ojtyk5HJQxEFibU7HM=;
        b=H/LeXhyBotqxKyX808KkNwjgDmT+gWTlcI1/f7fo7dOtQakSUPHh6Tz27ZcuXN8uA5
         98Mpojy6SQwsWlMMSPDHSIRu4mabjghsNo+gmwtaZQL4+GPJ9UBomWBrQK3KRIhFdpis
         OVnqtcvoeBlUJCyYECjwd89jwPj+8y7QpcPKDLlWuV5xO4RDJ+ZMd/tgQrDEQY5wM4tA
         egkh4gvLs3QgmwsTvAGDTSQjoGlD1a4XKbuG0nklHyIYiliswKtWanQ00bGxe5J4TVn2
         /nvfVqg00HPdkQvT6mKr/FO1rC8/3cFsOsOeKZ4rPzmtgxSi5q+KRm9hzi9RNstfUI68
         Goyg==
X-Gm-Message-State: AOAM530XWksyG+ExyKM5B7P4QVDQWIhev4L63LLXdHfHDv+ckuA9u+n9
        wO+u7rx1n1pKWcje/jAOiuo9+eI8beZhlEr1mcfuhA==
X-Google-Smtp-Source: ABdhPJwovIXtCaNH0f/IjP5TwWI+pkvTR7Ji61aZ2sZ97tfrX8pksveSJF1DFwZSGd96+dxbvUTZTnuf4JCJxE9fvBA=
X-Received: by 2002:adf:fb87:: with SMTP id a7mr24852823wrr.390.1598590045816;
 Thu, 27 Aug 2020 21:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200827082251.1591-1-jiangyifei@huawei.com> <20200827082251.1591-2-jiangyifei@huawei.com>
In-Reply-To: <20200827082251.1591-2-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 28 Aug 2020 10:17:14 +0530
Message-ID: <CAAhSdy2+auxYci5guLqtbEf3bO3At5-6AcB9Wj3AK4=YcR8f6w@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] riscv/kvm: Fix use VSIP_VALID_MASK mask HIP register
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Atish Patra <atish.patra@wdc.com>, deepa.kernel@gmail.com,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        wu.wubin@huawei.com,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        yinyipeng <yinyipeng1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 27, 2020 at 1:53 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> The correct sip/sie 0x222 could mask wrong 0x000 by VSIP_VALID_MASK,
> This patch fix it.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  arch/riscv/kvm/vcpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index adb0815951aa..2976666e921f 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -419,8 +419,8 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
>
>         if (reg_num == KVM_REG_RISCV_CSR_REG(sip) ||
>             reg_num == KVM_REG_RISCV_CSR_REG(sie)) {
> -               reg_val = reg_val << VSIP_TO_HVIP_SHIFT;
>                 reg_val = reg_val & VSIP_VALID_MASK;
> +               reg_val = reg_val << VSIP_TO_HVIP_SHIFT;

Thanks for this fix. I have squashed it into PATCH5 of KVM RISC-V v14
series.

Regards,
Anup
