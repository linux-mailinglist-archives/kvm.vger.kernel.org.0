Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102D0557A14
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 14:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiFWMPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 08:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiFWMPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 08:15:40 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C96319F
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 05:15:39 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3177f4ce3e2so168347027b3.5
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 05:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F7bi0kL/rFqoaqds1vEBpPil9sgMeNQmgZzhUbZCVTs=;
        b=Q+HHtwCb8GnSNrQGUec7nNeSX83ZY4mtoO2gA80VcnefwaqK+d4K4Kl5l/5sxX6A0K
         +dDmkhkOgDoUbSGcrrtMmc9dF4p/rn7h6tx38fI3R5VDOnXMBX53CMgvZZ8I04jiiFmC
         hC8sqYjPWZ4bct0DAxU5yTQX/N8Wj7jCQqKrI1LdiZlR35fkCmEosGn0hcgWvjLdfSfE
         vWyJzODLKneRIk2JmOcrG5vmBt5dIG7OMK1WaVJHUPPphumQxRu3lG4kTgH3DDOANwnw
         nx7J/MI0e4dtTMGnQFCLzf4hfGa5H80LU/lev6/9TM+x++71Rzz1tzVILro+5lmbFyA5
         R3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F7bi0kL/rFqoaqds1vEBpPil9sgMeNQmgZzhUbZCVTs=;
        b=35osCai/2KGvtZ7QfKVusK7b9OqhS7BQs4SnLNGhtrqrtWjBWzoXR3kgq066/vAfa2
         rb6trjw0nGnIMYVQt+J90hNDtFxH3ZuqMvZPBILLM4nPEm6APHK03/z3eBEX3Ckx4xYZ
         MACBaFEBOhhIZXndGBs6xCUpu8fKGLK6y3PHqjIClcTbJRXRJLMtRdpQT0a16Q5AI0oy
         no/kD7GgXxut/y1v9Z2y2Ph6wb9RwaIAs1j+JkmAl+h3hSwdcswrq/2InI6XWKPwEvyf
         qCaAr4BLPuBdz1NfBGLpAyZd5J0IUibLk5LInsSwvxLqw/ByIDE2ijTieHoWB7jBpA+O
         AqfA==
X-Gm-Message-State: AJIora86Asld0DchtNsmAoGMsk83Xa92yPOm6/dk4cVT5T01FhOf06+1
        MOfZT++RZA3nrveR5Gd0VAOYM9qPgT5P+ATH67wW6Q==
X-Google-Smtp-Source: AGRyM1uRz69Bfh9NsvumFonp6zhJqvibH5w5p7nJe65BZK6bxanJjfUicvi7sbmlQz5eAk2+A255dWUpO0qsDcfXed4=
X-Received: by 2002:a81:8486:0:b0:317:a4af:4e0a with SMTP id
 u128-20020a818486000000b00317a4af4e0amr10217824ywf.455.1655986538673; Thu, 23
 Jun 2022 05:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220623102617.2164175-1-pdel@fb.com> <20220623102617.2164175-5-pdel@fb.com>
In-Reply-To: <20220623102617.2164175-5-pdel@fb.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 23 Jun 2022 13:15:27 +0100
Message-ID: <CAFEAcA9zmmaUth+9k82+ZrhAMOmsmttq2HOKs+DVNx0L1dx6=w@mail.gmail.com>
Subject: Re: [PATCH 04/14] sysbus: Add sysbus_mmio_map_in
To:     Peter Delevoryas <pdel@fb.com>
Cc:     clg@kaod.org, andrew@aj.id.au, joel@jms.id.au, pbonzini@redhat.com,
        berrange@redhat.com, eduardo@habkost.net,
        marcel.apfelbaum@gmail.com, richard.henderson@linaro.org,
        f4bug@amsat.org, ani@anisinha.ca, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jun 2022 at 11:56, Peter Delevoryas <pdel@fb.com> wrote:
>
> Signed-off-by: Peter Delevoryas <pdel@fb.com>
> ---
>  hw/core/sysbus.c    | 6 ++++++
>  include/hw/sysbus.h | 2 ++
>  2 files changed, 8 insertions(+)
>
> diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
> index cb4d6bae9d..7b63ec3fed 100644
> --- a/hw/core/sysbus.c
> +++ b/hw/core/sysbus.c
> @@ -160,6 +160,12 @@ void sysbus_mmio_map(SysBusDevice *dev, int n, hwaddr addr)
>      sysbus_mmio_map_common(dev, n, addr, false, 0, get_system_memory());
>  }
>
> +void sysbus_mmio_map_in(SysBusDevice *dev, int n, hwaddr addr,
> +                        MemoryRegion *system_memory)
> +{
> +    sysbus_mmio_map_common(dev, n, addr, false, 0, system_memory);
> +}
> +
>  void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
>                               int priority)
>  {
> diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
> index a7c23d5fb1..f4578029e4 100644
> --- a/include/hw/sysbus.h
> +++ b/include/hw/sysbus.h
> @@ -80,6 +80,8 @@ void sysbus_connect_irq(SysBusDevice *dev, int n, qemu_irq irq);
>  bool sysbus_is_irq_connected(SysBusDevice *dev, int n);
>  qemu_irq sysbus_get_connected_irq(SysBusDevice *dev, int n);
>  void sysbus_mmio_map(SysBusDevice *dev, int n, hwaddr addr);
> +void sysbus_mmio_map_in(SysBusDevice *dev, int n, hwaddr addr,
> +                        MemoryRegion *system_memory);
>  void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
>                               int priority);

What's this going to be used for?

The current standard way to map a sysbus MMIO region into something
other than the global system memory region is to do:
   memory_region_add_subregion(&container, addr,
                               sysbus_mmio_get_region(sbd, 0));

I'd rather not have two ways to do the same thing; we have
far too many of those already.

thanks
-- PMM
