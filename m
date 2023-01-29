Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8C767FEEB
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 13:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjA2MgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 07:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjA2MgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 07:36:09 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A0822001
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:36:07 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id dr8so3220165ejc.12
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pon3MbPPW13P0zNvYCd1smE05PP2P+jwr/geqehNzwE=;
        b=NhkuOfB0ra/AVj6j2EVFceBuFWItZkPYikE2pzqJ6Zb0E9Y5TN/8qH2vVwbALlL/n2
         XnWF7FqbsQrX8yG6z7gdiye1PfgdSRbBOUuzr5zYIXG5/HLudCCRaqut3pJOsPZXJc+G
         G6QsqPS7Q4QvSuaKK5Pf4FwwPL91+uJPw7r26FceO4Dfpxk1tHvfHbpq+mVeMqDpheWb
         CdC46mTCMan0NFCDEKcAEdxs5CKmqc3Q1YpUgg72vgO/6DCsywnKpDauA13yA6Vx/rhw
         4p22AxAKKP6EhmJ5jwk/XP1c3SUu1ewaQjqmzwhC8UX3SX2hBNfaZPSqJf+oz8FmU5fB
         /cww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pon3MbPPW13P0zNvYCd1smE05PP2P+jwr/geqehNzwE=;
        b=gOpKwnF5GYcjFwVQUKz8F2MAd2vAUGUFtA3yKLtDejLUlE7cXu6hLYwaOcE/TstH4R
         rXCUC1V/yc2U7a/9/UJkPBrhZhBJr1sq+6/IB7tm2wO4P6o94SImbNMJX62nLHMU0VFl
         uLmkqJ0/McX5KU76CgXBhIkHeT/PhKrE0PbjnmaxScrUSWmC4xGO3viVKEQwZm0TMGhJ
         9NbmOs8WS3P4jIfl7nj9aknc763be+/JbBOlCPnUYxFI8a1ijvkRZS0dl0GxnCsQxIG0
         f8rb0NMFFzdmVkloEdXKLxczxtVhFFHaDwEjLYAByO4/+148f6uzl0pu2njXgtPQHrwc
         AoWw==
X-Gm-Message-State: AFqh2kpp4ditmZ/UIn1ov0ACp/samwMiu1zWGP52sQLG26/MuGnjm57B
        eFl4f12s8yC8vIAI28QX/GQ/3D1og4B2YbMYfYy8HDzC5q7wrw==
X-Google-Smtp-Source: AMrXdXvB3OmLcvEfxFlWKF6yDJduujeg3HFdqoO8lqh4sAOeyWvSijhDyFKCWrJUJ1Xhhmu2uSm7mtH1XcFgoyIBMcg=
X-Received: by 2002:a17:906:6a8e:b0:86e:3764:4f80 with SMTP id
 p14-20020a1709066a8e00b0086e37644f80mr5739206ejr.239.1674995766162; Sun, 29
 Jan 2023 04:36:06 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-10-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-10-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 29 Jan 2023 18:05:55 +0530
Message-ID: <CAAhSdy086ftqg_WXoAJJuXF0WFRpdiM5ipkOG1=XodDa7cZAPg@mail.gmail.com>
Subject: Re: [PATCH v3 09/14] RISC-V: KVM: Make PMU functionality depend on Sscofpmf
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> The privilege mode filtering feature must be available in the host so
> that the host can inhibit the counters while the execution is in HS mode.
> Otherwise, the guests may have access to critical guest information.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index d3fd551..7713927 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -79,6 +79,14 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>         struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
>         struct kvm_pmc *pmc;
>
> +       /*
> +        * PMU functionality should be only available to guests if privilege mode
> +        * filtering is available in the host. Otherwise, guest will always count
> +        * events while the execution is in hypervisor mode.
> +        */
> +       if (!riscv_isa_extension_available(NULL, SSCOFPMF))
> +               return 0;
> +
>         ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
>         if (ret < 0)
>                 return ret;
> --
> 2.25.1
>
