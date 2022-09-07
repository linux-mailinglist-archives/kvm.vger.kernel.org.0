Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB28F5AF8E6
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 02:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiIGALX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 20:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiIGALS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 20:11:18 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89B67F088
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 17:11:11 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id k80so7891164ybk.10
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 17:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=lLG25Crj6LfgDaHR+loX2NoAIZ0fxOyvF8tlzDPfGI4=;
        b=o3CVvDbH3fxbMKnnqt5sbTG/ksB3HeTEWZl7YPi9kdDa0ynFoRqdGtoFbR1JIZp78O
         WtjOP2kho6SCRpmjAzO5yVu4lGMU7Ltg95y8U458jvl6CmEu47XxpmPaIdXwjuZJWmUg
         jEBSH/X7q5EWgRiKhjvHbGyPE/2CXnlTfV/5AxDl18YInYSpybjj0v8pM9kxXPXlexcW
         ArvAbytoqFTxlqJ/4mGITfQeTayYR32kSntL/fX2XcXu+wPx3mzgqLtTyACdrNG9A1gv
         KK7YRllTBYepIO9AbwPjvvkZXpYJET4bVNFbw+v+z1VjUGzRSydSQTG/PhjhlxOm/IHe
         LbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lLG25Crj6LfgDaHR+loX2NoAIZ0fxOyvF8tlzDPfGI4=;
        b=3zhu1Mk2CiGIyqu3FGrt+d+f++lG4mVmxT9vcE2EXk1chpv4bVvSd/ZHXPiIEtSehN
         qfyUDQtxBlHSVYhW+muawHI61LjOBzMAmCZhy7YqY+1uAWDgOIE5LjB05xPkC6iFHKfL
         hM2ikVTbuEBSHaMY18Gd0EBVCjfwStR8lYhNKrfUqLCXR2f8pFvh2JcST+xrpO+UZ2L8
         Nqf246a8m07ytDFjVtJDGCemPLFpzwmup5CsCuM4bb+FOP2NDJAfsBnWp7c0Y2kaxw6l
         vMsbOVBQay5AB0b/eGmSABDE8Puv06dzpV79QZVKwhN7ZHk3AvknEgoSia6XHr/0jW7K
         XzNw==
X-Gm-Message-State: ACgBeo3pPQC9TC/tsz/bXA0zt9FzfLdtKwNqt/lmRsdURC6nqKvoZmLC
        q/dsMKNnkWPnJGoScJwbfHpYXx8L0WIKiQ/nLxnqNg==
X-Google-Smtp-Source: AA6agR4TrPP+3HCsx3CksfJHfhZouFxXx8tYj2cKokkfW1BCWjWZxusW2S77Vq+jgIdGkOYt7ERSlpadN22+jk2TOcU=
X-Received: by 2002:a05:6902:2cb:b0:684:aebe:49ab with SMTP id
 w11-20020a05690202cb00b00684aebe49abmr1002336ybh.242.1662509470939; Tue, 06
 Sep 2022 17:11:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220803122655.100254-1-nipun.gupta@amd.com> <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-4-nipun.gupta@amd.com>
In-Reply-To: <20220906134801.4079497-4-nipun.gupta@amd.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 6 Sep 2022 17:10:34 -0700
Message-ID: <CAGETcx_W8QVe+CdpocN2rHjp08TwsW22FaJgrYW=0JNge_N6KQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
 for CDX bus
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        eric.auger@redhat.com, alex.williamson@redhat.com,
        cohuck@redhat.com, puneet.gupta@amd.com,
        song.bao.hua@hisilicon.com, mchehab+huawei@kernel.org,
        maz@kernel.org, f.fainelli@gmail.com, jeffrey.l.hugo@gmail.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, jgg@nvidia.com, robin.murphy@arm.com,
        will@kernel.org, joro@8bytes.org, masahiroy@kernel.org,
        ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org, okaya@kernel.org,
        harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, aleksandar.radovanovic@amd.com, git@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 6, 2022 at 6:48 AM Nipun Gupta <nipun.gupta@amd.com> wrote:
>
> With new CDX bus supported for AMD FPGA devices on ARM
> platform, the bus requires registration for the SMMU v3
> driver.
>
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index d32b02336411..8ec9f2baf12d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -29,6 +29,7 @@
>  #include <linux/platform_device.h>
>
>  #include <linux/amba/bus.h>
> +#include <linux/cdx/cdx_bus.h>
>
>  #include "arm-smmu-v3.h"
>  #include "../../iommu-sva-lib.h"
> @@ -3690,16 +3691,27 @@ static int arm_smmu_set_bus_ops(struct iommu_ops *ops)
>                 if (err)
>                         goto err_reset_pci_ops;
>         }
> +#endif
> +#ifdef CONFIG_CDX_BUS
> +       if (cdx_bus_type.iommu_ops != ops) {
> +               err = bus_set_iommu(&cdx_bus_type, ops);
> +               if (err)
> +                       goto err_reset_amba_ops;
> +       }

I'm not an expert on IOMMUs, so apologies if the question is stupid.

Why does the CDX bus need special treatment here (like PCI) when there
are so many other busses (eg: I2C, SPI, etc) that don't need any
changes here?

-Saravana

>  #endif
>         if (platform_bus_type.iommu_ops != ops) {
>                 err = bus_set_iommu(&platform_bus_type, ops);
>                 if (err)
> -                       goto err_reset_amba_ops;
> +                       goto err_reset_cdx_ops;
>         }
>
>         return 0;
>
> -err_reset_amba_ops:
> +err_reset_cdx_ops:
> +#ifdef CONFIG_CDX_BUS
> +       bus_set_iommu(&cdx_bus_type, NULL);
> +#endif
> +err_reset_amba_ops: __maybe_unused;
>  #ifdef CONFIG_ARM_AMBA
>         bus_set_iommu(&amba_bustype, NULL);
>  #endif
> --
> 2.25.1
>
