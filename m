Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3D640C99
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbiLBRxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiLBRxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:53:41 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B239C2D2E
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:53:40 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso9037134pjt.0
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ZvJzDorQtOwNqLa1HHYVuO6backFKSVBd3ruJxRA2A=;
        b=eQnZOvNRY11eiZD6GVvQZwn1takWYswEZO6mnHfFnI3IOwcIiD6Zx+pagggcuTggyE
         KI2v9qhiuLOtxUaSbh05X+3u3ZJeuy2KPUw24QAEHeemgwvBVYSNg7VIrTgM/9CZF7Mh
         qIGRAfb52QV9/EArXB3WfOf73n/Zj+mT+acVF8xXToHtE9sTGamB58BUDzFZvKKrcrQs
         N82x9nRGEqlbGZDDayglBKpHk1Ju0LRifyISFL7XGTuJ4VTQZxgsAckVsHg9WKJDAtXL
         l1P2Bi6HAp3c1vtRk7yGNxdUdXKhF7PSfRXpRsPFM+uN9qkQfh86kWUV6Q3Nt+kAw8ul
         RFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ZvJzDorQtOwNqLa1HHYVuO6backFKSVBd3ruJxRA2A=;
        b=Oehb0Qm3Q/Ufn0G3nsm0Lvrej1Vd0OaWmdR225pGwezTVhoRi3wqoeUnVKQVdi/22Z
         Wem6BRgOpFRXGGmOXg4XmKdmO/KiyInrhgICPn26OYgdJA1iV0jyHdW7YAACPuxReUwB
         DB1PCncL/GgpyxogtcU7roWX5j4V1tZvnzfI8vLixr3F7FbpDxivVCh+mAHuYKSI/wnk
         xEJVB3yhwNWqU44M3UfYew9Lj6zO01NN0LXI8P+jeXL3S1S8cbVFHLIlztHjPwW6wfMt
         GPT5v6LICfvQBMC3zzYFlEcFojjsCO2xZbtLh2g1cd5NdjZaFGtSWP/TDX8iWVTGtfuA
         2fyQ==
X-Gm-Message-State: ANoB5pkY0aUFtRWdY4Q21UshrfPaF7uT3WPuYsx6zJKCTjmFrQ5bsfTg
        o3XKH9lnXPF0mn6mi5anwRFh0A==
X-Google-Smtp-Source: AA0mqf5X/TeHx5A5xtNnIKw6jgBgvRIH82EYzaYQxx+YmUJkhxCg9UKytVs/q/xMiH6X+7zxecaK0w==
X-Received: by 2002:a17:90a:ca85:b0:219:88aa:d3d1 with SMTP id y5-20020a17090aca8500b0021988aad3d1mr4968286pjt.135.1670003619663;
        Fri, 02 Dec 2022 09:53:39 -0800 (PST)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0056283e2bdbdsm5391440pfq.138.2022.12.02.09.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 09:53:39 -0800 (PST)
Date:   Fri, 02 Dec 2022 09:53:39 -0800 (PST)
X-Google-Original-Date: Fri, 02 Dec 2022 09:53:24 PST (-0800)
Subject:     Re: [PATCH 6/9] RISC-V: Export sbi_get_mvendorid() and friends
In-Reply-To: <20221128161424.608889-7-apatel@ventanamicro.com>
CC:     pbonzini@redhat.com, atishp@atishpatra.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, apatel@ventanamicro.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     apatel@ventanamicro.com
Message-ID: <mhng-365b9851-cb0a-4e2c-9cf4-4eca9623cf04@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Nov 2022 08:14:21 PST (-0800), apatel@ventanamicro.com wrote:
> The sbi_get_mvendorid(), sbi_get_marchid(), and sbi_get_mimpid()
> can be used by KVM module so let us export these functions.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kernel/sbi.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
> index 775d3322b422..5c87db8fdff2 100644
> --- a/arch/riscv/kernel/sbi.c
> +++ b/arch/riscv/kernel/sbi.c
> @@ -627,16 +627,19 @@ long sbi_get_mvendorid(void)
>  {
>  	return __sbi_base_ecall(SBI_EXT_BASE_GET_MVENDORID);
>  }
> +EXPORT_SYMBOL_GPL(sbi_get_mvendorid);
>
>  long sbi_get_marchid(void)
>  {
>  	return __sbi_base_ecall(SBI_EXT_BASE_GET_MARCHID);
>  }
> +EXPORT_SYMBOL_GPL(sbi_get_marchid);
>
>  long sbi_get_mimpid(void)
>  {
>  	return __sbi_base_ecall(SBI_EXT_BASE_GET_MIMPID);
>  }
> +EXPORT_SYMBOL_GPL(sbi_get_mimpid);
>
>  static void sbi_send_cpumask_ipi(const struct cpumask *target)
>  {

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
