Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC426877D9
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjBBIuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjBBItz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:49:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B7987165
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 00:49:36 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id gr7so3915594ejb.5
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 00:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=scOOV9S3a4QBlzHpx87cDvuev3VEso20BNEexdmKlT0=;
        b=O3nVgV9gtylTwn60p8kK9nZJZAoCc9Ha3iSF7VeLPJh/boPlEGgsEPEHEFjH8JnJwd
         6tmiA7JTfitRNVs4FO8C0pxnMHwq4vv6sZceQKNZJwi7VUaSVMVWPFml6hLKnt9kcd+Y
         uLwneuso9EiX+opusRuUOkRANvzQqcZqDc3idsjXEGt2My08V6zhbGslYIXHKccK8Pcx
         c8LZpp9pOB0rQT6HQaySWrbs/EMBFWRMArEOPwlGuHPcBgu1CNCVBt8RIc8hVREJ0uMB
         /HdDYcwEVvfwxdLlcgZK8Q72tKxZ7W2tfRsQDTne3VkaW0T4ir1YHExTH9YtstvtmoAW
         ocVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=scOOV9S3a4QBlzHpx87cDvuev3VEso20BNEexdmKlT0=;
        b=tUnYdkmFE832/FsnD1XdIm9kfS+tz2x2ympAD0xxjRKCXEblN1PSgCklDx/PvlfpTm
         YTA4Op/Zj3yCpwXiIuO4wEXDWtrz43HpuxtyEqRf6GZFW4Jzl/5XPD9QdIJm8i4SA7lr
         tq5KOXsNGLEwwEsKvJ2r6tTdrlY8okOOH5hvnA8yeyWtBIPfkevsP0yOvnufgfT0riDp
         KISfvnaJHmMG0pq598jIf69DryRygwtMhzPU4CrNYo3ydUNox/3o9AbQGdBe1n7J39Zr
         YyBPXteAoXDw8rtw3bS2jQEYOlNtPU9D0wWhYNq2ocjS6WxEnWYT/ZWf0XfdZdEYt6cZ
         esFQ==
X-Gm-Message-State: AO0yUKWltxWtlaTjvUMhXxdFTi1JUkoXtKXYCZxGTM6xCFhS/KarMRkH
        Oh//Q6T2jugcQ4rrxLK7dJgJuPqVN+SIkC++eJcdDQ==
X-Google-Smtp-Source: AK7set8SjP7qAzOcTogP1InH1AzFV1lpTeuCw9CVQKwooWB2cjtaB7tzWyOwcOgZfvqWksth3Uyd9cPPqpbjKz4stP0=
X-Received: by 2002:a17:906:1653:b0:88a:7cf5:5d33 with SMTP id
 n19-20020a170906165300b0088a7cf55d33mr1792317ejd.100.1675327774906; Thu, 02
 Feb 2023 00:49:34 -0800 (PST)
MIME-Version: 1.0
References: <20230128082847.3055316-1-apatel@ventanamicro.com>
In-Reply-To: <20230128082847.3055316-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 2 Feb 2023 14:19:23 +0530
Message-ID: <CAAhSdy17dUdhn3ijVzps4J0k=_xH6GWC16CHHJPN_2E7xBwdbA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] RISC-V: KVM: Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 1:58 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The kvm_riscv_vcpu_trap_redirect() should set guest privilege mode
> to supervisor mode because guest traps/interrupts are always handled
> in virtual supervisor mode.
>
> Fixes: 9f7013265112 ("RISC-V: KVM: Handle MMIO exits for VCPU")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

Queued this patch for Linux-6.3

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_exit.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index c9f741ab26f5..af7c4bc07929 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -160,6 +160,9 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>
>         /* Set Guest PC to Guest exception vector */
>         vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
> +
> +       /* Set Guest privilege mode to supervisor */
> +       vcpu->arch.guest_context.sstatus |= SR_SPP;
>  }
>
>  /*
> --
> 2.34.1
>
