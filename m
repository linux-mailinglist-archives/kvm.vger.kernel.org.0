Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDED7A6B02
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 21:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjISTAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 15:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjISTAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 15:00:02 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040C4131
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 11:59:56 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-50305abe5f0so5441171e87.2
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 11:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1695149994; x=1695754794; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hy4ZWnzFPz+zDftN8eU6StekSEbNrmtd0J3JOw6fos=;
        b=jFX2IY1JMzFYYliSBWShHdEHBMcUu04mHuaRDIyQ2gyLSVMjr1GhPGy5rWHNyGOFKi
         GAUr2CpE/HL+Z7ZuNuchZIpgwgsuR0lJJfRfn/9RwKH0sXdctGO6i8pYnef92u5+WUUy
         7zfpIPRHBzYO5PJnMSxJmuy1wq3nAGZQShP/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695149994; x=1695754794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hy4ZWnzFPz+zDftN8eU6StekSEbNrmtd0J3JOw6fos=;
        b=QfFV/eazM6wLji4kUaf0CjCLxTBbfD3g5y85fmEC/ugxCI5TJVnPKMF7RxBc2+jARX
         5urFYtIi5o7h3PuA66JhFARJXgP6bNOJGFhvmhvrcf0/KMmv+zUwr8jk//pyqbd6aqyF
         PL6U8Yt06xdeA3437dpyNcB7sxUCOQHTpmjXaJlOdephFDd5koqeE7ykQa3Mjb5bIk1K
         0bGM/adghXg5k+Kv5nyYTRe0TTLVLtw84wF2aBIV1rgo9qAh4FbyXxo7hCrkOhRycCW9
         EW/e6aRgnDL10bZOpXr0JJyoWPK5+cXcmmwMtPVTVnSpCcJnIUczNQNxa6lrBwRqF6jt
         H3zg==
X-Gm-Message-State: AOJu0YwtXI+z5Fu1PJWvrVGzmdPhmMOCkiGKoZk/o/7BqrmzWCquVMBR
        dBw0oVYL49a6j4OavltPQQ5tbKyess71MAAUkWIj
X-Google-Smtp-Source: AGHT+IGzXm4g2jK7Xdi6knCthlXq8nCD/mVPShAE5lRiG6xxJ8B4e0CC7iznJCYX/qjLZMxqqH/cNtHjP1O2lo0olhc=
X-Received: by 2002:a19:9111:0:b0:503:ed:8616 with SMTP id t17-20020a199111000000b0050300ed8616mr320596lfd.59.1695149994155;
 Tue, 19 Sep 2023 11:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230918180646.1398384-1-apatel@ventanamicro.com> <20230918180646.1398384-3-apatel@ventanamicro.com>
In-Reply-To: <20230918180646.1398384-3-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 19 Sep 2023 11:59:42 -0700
Message-ID: <CAOnJCUJ-25tCN61K2Uvu__xgKWDZrxpzwCrWW_uGCBROm9pAzw@mail.gmail.com>
Subject: Re: [PATCH 2/4] RISC-V: KVM: Fix riscv_vcpu_get_isa_ext_single() for
 missing extensions
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 11:07=E2=80=AFAM Anup Patel <apatel@ventanamicro.co=
m> wrote:
>
> The riscv_vcpu_get_isa_ext_single() should fail with -ENOENT error
> when corresponding ISA extension is not available on the host.
>
> Fixes: e98b1085be79 ("RISC-V: KVM: Factor-out ONE_REG related code to its=
 own source file")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_onereg.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index e7e833ced91b..b7e0e03c69b1 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -460,8 +460,11 @@ static int riscv_vcpu_get_isa_ext_single(struct kvm_=
vcpu *vcpu,
>             reg_num >=3D ARRAY_SIZE(kvm_isa_ext_arr))
>                 return -ENOENT;
>
> -       *reg_val =3D 0;
>         host_isa_ext =3D kvm_isa_ext_arr[reg_num];
> +       if (!__riscv_isa_extension_available(NULL, host_isa_ext))
> +               return -ENOENT;
> +
> +       *reg_val =3D 0;
>         if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext)=
)
>                 *reg_val =3D 1; /* Mark the given extension as available =
*/
>
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish
