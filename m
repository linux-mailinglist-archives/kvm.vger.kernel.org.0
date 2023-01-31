Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4AB6828C8
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjAaJ0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjAaJ0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:26:08 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2C41E9CF
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:26:07 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 143so9592211pgg.6
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iuOgM24FK59+MffbRIrpSxSdYJY4cKp8hxWLQ7aDyK0=;
        b=mDT4gnR+VFMLC+hvEwWESSYsHhM3swOUMRQkP7LTrvMO2H9o2ZwcW4L7joLuD/XQwX
         owIFiUtwX0EGsPgrnDgoORXLCKM8QzfTDMe8BfdRvCFHYRYmBU13DPROvapuJO+ATfiL
         /5nWa+4I5Ki0TZMWoDyQoeXTyxNcprRRb+lSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iuOgM24FK59+MffbRIrpSxSdYJY4cKp8hxWLQ7aDyK0=;
        b=nxJmEIwAPxq3G2wyCJktE7WIM7RPnNRER9fP1rSwS4b/AR9r+orODznhdzVu/hBfpG
         W64xvW+Fl+4ThsmOK8fKL1NiiJZVUhT72mGBnMemMSdI5fOXKBpEBMdvoxW8ar/9aY9U
         iQdDh3OPL7d028h+M311zTFENgpt/9tr6ucKpOP+8i2KKTz5l0sEBbHhQlv1tE81HqXF
         M7KuOvae60UdZLnaXI7FlOMaNAO1eI1ZD1ydBPrTyduTlg6W3ufJ/I2PnIrjvOxttyl2
         qJamGppZ2h77hksjYVfkGCEvMPqYySpKP+a/kR1+vY+e9i55K74XTQ7yEWh73cTFt3jb
         059Q==
X-Gm-Message-State: AO0yUKWlMTSg/hhThMwJl3dMTl+XePFJL8v3Yymm9obiZTw05v2zKDmY
        m8E/bXqSHAsQhWR56VSpMbO9C3pPJdW315tBbnuU
X-Google-Smtp-Source: AK7set/MSOrSxz1qNdOEo3o9mrx0RsLwAY3Thk/17kJxDWGdCN+7K9AXDb2PlDva9XbGN0WlRZI59ue/ZbriaRWQtuw=
X-Received: by 2002:a63:510a:0:b0:4da:6df2:f28 with SMTP id
 f10-20020a63510a000000b004da6df20f28mr2526765pgb.36.1675157166777; Tue, 31
 Jan 2023 01:26:06 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-1-apatel@ventanamicro.com> <20230128072737.2995881-3-apatel@ventanamicro.com>
In-Reply-To: <20230128072737.2995881-3-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 31 Jan 2023 01:25:55 -0800
Message-ID: <CAOnJCUJnEMxQxjDtzAJe5_0edi=1pQLVE-LDeQtH9bzn7+O4rg@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:27 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
> and Ssaia (S-mode AIA CSRs).
>
> We extend the ISA string parsing to detect Smaia and Ssaia extensions.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/include/asm/hwcap.h | 2 ++
>  arch/riscv/kernel/cpu.c        | 2 ++
>  arch/riscv/kernel/cpufeature.c | 2 ++
>  3 files changed, 6 insertions(+)
>
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index 86328e3acb02..341ef30a3718 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -59,6 +59,8 @@ enum riscv_isa_ext_id {
>         RISCV_ISA_EXT_ZIHINTPAUSE,
>         RISCV_ISA_EXT_SSTC,
>         RISCV_ISA_EXT_SVINVAL,
> +       RISCV_ISA_EXT_SMAIA,
> +       RISCV_ISA_EXT_SSAIA,
>         RISCV_ISA_EXT_ID_MAX
>  };
>  static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
> diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> index 1b9a5a66e55a..a215ec929160 100644
> --- a/arch/riscv/kernel/cpu.c
> +++ b/arch/riscv/kernel/cpu.c
> @@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
>   *    extensions by an underscore.
>   */
>  static struct riscv_isa_ext_data isa_ext_arr[] = {
> +       __RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> +       __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>         __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>         __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
>         __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 93e45560af30..3c5b51f519d5 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
>                                 SET_ISA_EXT_MAP("zihintpause", RISCV_ISA_EXT_ZIHINTPAUSE);
>                                 SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
>                                 SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
> +                               SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);
> +                               SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
>                         }
>  #undef SET_ISA_EXT_MAP
>                 }
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
-- 
Regards,
Atish
