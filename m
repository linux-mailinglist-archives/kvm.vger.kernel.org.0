Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F224A6FDB
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 12:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343894AbiBBLVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 06:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343887AbiBBLVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 06:21:45 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7EDC06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 03:21:45 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id s9so37649096wrb.6
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 03:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLpBWpR4AdxV5k5a9SzxOwC4Is5G/R+GFZUj0OPG68E=;
        b=0GzZnB6+OCeckMUkTJmkIO5sfwKHCblMsvuWqQfWsqJAhSN7p5my9G/QCBoR6UwdAi
         jN/c7wPi23GCh/djF3RvdTynngxkjgI4Ct6t3wl5Qt/YFhFpU4FSATeju5bRLe6Xi05M
         6Q0voGGh4CpnD/whLpVbYzlLvBThs1p5AscZe1PUEtOENxlUTOZHWuQNPb/orkrS7CZq
         CKaZWk2Uxa89CqefqP9gdaLI9gb+wBBgh8QjhHLgzuCgCg3kGVjB6nLc5EgLxPRciSUN
         LU8GAoJvu9GdmAQPYgNnbPKtbIz0BgB+3D25b0wmvSaAL7w7c/ZFbRsKj8Ymy+C8GdWW
         Wkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLpBWpR4AdxV5k5a9SzxOwC4Is5G/R+GFZUj0OPG68E=;
        b=vxnWegdCjVSfZXznKoZq/E7X53Rmp07eYhutEFziFRApNLsVk96wBzoCJ4iWKsZpoE
         isjGDpz/JZJ7DRsH5h1gMiXF7x/Hm/BG1qn4r5KqQq3p2e3JZg/nPyGXjj42MP2/3y4M
         NepN+HzdtjkAmqlL6idFcaYIx3tH5lofkELUAAo//MwVX9N8vRudzUywekAISpEixb/2
         KC6bSkRZ8TnFmrluwxrv54/tCfPFIhJnIUUdGMBiWK2nwVfgt1iPOfxB7PHKe27vqMPE
         HHcC2eq3IszvjeZmaTrxibyNO2FnfSqScmXNNdz/pxp1OTlFIG3HECyIzTxy7lLGFbBm
         FICA==
X-Gm-Message-State: AOAM533C1UN4UH2BHXuzJNvoGjjFuW5k9c+EpKnXjLJHK82S6CYqf0ou
        NBBYyjvJPu1LMxWvJTFCTTl3VLBZXK47hhjRsEQ5hw==
X-Google-Smtp-Source: ABdhPJzlXdO1QshYnBgRMzXJ2ivnlrYwpOvle2NHmkETsqwszvU55uwzYT90mGUVAB/9xurup36pfFR95cYb5rz617U=
X-Received: by 2002:adf:d08c:: with SMTP id y12mr25480446wrh.346.1643800903609;
 Wed, 02 Feb 2022 03:21:43 -0800 (PST)
MIME-Version: 1.0
References: <20220131164232.295585-1-apatel@ventanamicro.com>
In-Reply-To: <20220131164232.295585-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 2 Feb 2022 16:51:30 +0530
Message-ID: <CAAhSdy3ReL2cJXZ+0YMcEeWJg02p86Sr-dNXKXm7GMMaqUZJiA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix SBI implementation version
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 31, 2022 at 10:13 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The SBI implementation version returned by KVM RISC-V should be the
> Host Linux version code.
>
> Fixes: c62a76859723 ("RISC-V: KVM: Add SBI v0.2 base extension")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

Thanks, I have queued this for fixes.

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_base.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 4ecf377f483b..48f431091cdb 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -9,6 +9,7 @@
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/kvm_host.h>
> +#include <linux/version.h>
>  #include <asm/csr.h>
>  #include <asm/sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> @@ -32,7 +33,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 *out_val = KVM_SBI_IMPID;
>                 break;
>         case SBI_EXT_BASE_GET_IMP_VERSION:
> -               *out_val = 0;
> +               *out_val = LINUX_VERSION_CODE;
>                 break;
>         case SBI_EXT_BASE_PROBE_EXT:
>                 if ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
> --
> 2.25.1
>
