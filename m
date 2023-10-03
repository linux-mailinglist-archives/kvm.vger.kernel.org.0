Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835487B7079
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 20:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240706AbjJCSCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 14:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjJCSCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 14:02:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82272B8
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 11:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696356118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1O1P5RRCZO3I2Cb3ZB5a7k3rWZWIpd5L49t63w6uEck=;
        b=COBCzydrWgPhPtn/T1lEz2S3hllh6MBaw+h3mZhbeI4s5c7PKP7ptPknVPLZQ2fzogP9+T
        JJSk6vF74Pk+bIGDzUEnqpzSsNQqFkU28djQaHzqqFNXwtuD1gz2BjewqCVDf51P1U0sBG
        TdcGZ/6G1OlaNEld6CcV4FsnRBSEats=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-AIUeISoeMBywSvYAFxsX0w-1; Tue, 03 Oct 2023 14:01:52 -0400
X-MC-Unique: AIUeISoeMBywSvYAFxsX0w-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-797f3f27badso75460839f.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 11:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696356111; x=1696960911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1O1P5RRCZO3I2Cb3ZB5a7k3rWZWIpd5L49t63w6uEck=;
        b=XzvQ6x7NtohYuYubRiN3qtXP0BmFDvQHG23QZ78P9O/TGIxl6JFS/v7hYNoPk35vSM
         uCpj9W0pMXk4zqQjjoFTl+zuWv/UB/Jxl1TiJOYfRIuxgViAT9mnUXp7ernfyzDsB4zo
         90r8d3I1ZXk19rN4X1MIZi9FxPz+1Ddt96u9hyafBDWecXm3HDeqz48YO/hADtWKjO93
         1oupBFR0Ago1TklSUTruvNud+oFYI5ZqW+Q27zq+DZUINsC8owGjzip9O7uj4Xlaj3TQ
         uQfE+ItXQCap4M3BTo6kd2TjFZqtMnlIUPOanSFQyWE9LWX2enqS/XPE57PMTZdVaUQ5
         m+SQ==
X-Gm-Message-State: AOJu0YyPhRv9ctv34Cc96xFK5B3dtiiM7e99ugb+xqcC2daF2/z6vl0O
        ZMZqM+7sYdgQb0SQ3LD0mFrHJbR+EUEBE0ghZ+IuNDdn4POEkzFa3QEXUG3pX7M/1GUvdo0rVKz
        TKBkp8xFaVk8b
X-Received: by 2002:a5e:a915:0:b0:794:eddf:daae with SMTP id c21-20020a5ea915000000b00794eddfdaaemr178009iod.12.1696356111549;
        Tue, 03 Oct 2023 11:01:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4yTp9WE3Q/12Yk/wXuK2OODFz+pJdNL9fInAXp4IHhkyJn89d6aKAzKcOPfaMvL+GsZni7A==
X-Received: by 2002:a5e:a915:0:b0:794:eddf:daae with SMTP id c21-20020a5ea915000000b00794eddfdaaemr177988iod.12.1696356111291;
        Tue, 03 Oct 2023 11:01:51 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id fn12-20020a056638640c00b00439e3c9f958sm480243jab.129.2023.10.03.11.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 11:01:50 -0700 (PDT)
Date:   Tue, 3 Oct 2023 12:01:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     nipun.gupta@amd.com, nikhil.agarwal@amd.com,
        ndesaulniers@google.com, trix@redhat.com, shubham.rohila@amd.com,
        kvm@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND
 expression and logical NOT
Message-ID: <20231003120149.11c89206.alex.williamson@redhat.com>
In-Reply-To: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 02 Oct 2023 10:53:13 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> When building with clang, there is a warning (or error with
> CONFIG_WERROR=y) due to a bitwise AND and logical NOT in
> vfio_cdx_bm_ctrl():
> 
>   drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^            ~
>   drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to evaluate the bitwise operator first
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^
>         |              (                        )
>   drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand side expression to silence this warning
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^
>         |             (           )
>   1 error generated.
> 
> Add the parentheses as suggested in the first note, which is clearly
> what was intended here.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/vfio/cdx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index a437630be354..a63744302b5e 100644
> --- a/drivers/vfio/cdx/main.c
> +++ b/drivers/vfio/cdx/main.c
> @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
>  	struct vfio_device_feature_bus_master ops;
>  	int ret;
>  
> -	if (!vdev->flags & BME_SUPPORT)
> +	if (!(vdev->flags & BME_SUPPORT))
>  		return -ENOTTY;
>  
>  	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> 
> ---
> base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
> 
> Best regards,

Applied to vfio next branch for v6.7.  Thanks!

Alex

