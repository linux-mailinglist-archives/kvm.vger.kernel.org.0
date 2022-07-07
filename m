Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35C556ADB2
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 23:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiGGVdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 17:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbiGGVdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 17:33:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26D9C32EEC
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 14:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657229585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AgSzWSDbGjhzoFk42SsVA9TRs/p1ehj7SbLA+QBY5xE=;
        b=QHTd45OgqWcj/lTQ22BsesGkOJrrWHniDkSm4PkTCD8AUwUctFRFfEINMIYZZp9V6w+waF
        bgG7jd2fUgZ8rAHdOpN87nPyp+cxHtDdoEn4n9KJXspGJRGBFe1aqnTZKwX0VcMuMEdFI8
        ZVwAvlCbtRRgJ1/niVDLRolUrGe5fmc=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-YgN5Kf9fNlisA5tugVLcLQ-1; Thu, 07 Jul 2022 17:32:50 -0400
X-MC-Unique: YgN5Kf9fNlisA5tugVLcLQ-1
Received: by mail-io1-f71.google.com with SMTP id h18-20020a5d9712000000b00674f83a60f0so10407560iol.4
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 14:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AgSzWSDbGjhzoFk42SsVA9TRs/p1ehj7SbLA+QBY5xE=;
        b=gzaSAF3Yj8Ufudo25VzujlxiTAuySHtJX3N0C+09alAFy2+l6J4WqCSMT2anmpe6Aw
         2jJXU9E4H88zPkZ54OdkB36mly20JZ7ecRklgXyz5jv+so58UrjJOVt2+maXCSu1MjNU
         q2afImcf7Y57BnAN1JbbduAyIfCBHj3oZQEHoxzuxUMhvFuzCLCX8ZrIdhxp/0HmcwUM
         f/6P/7b5Wiwxlnhu5O9TBd/OAsB7RNY4lKs7oWmfKfHbT0jIaZrl79/ZXIqBauiCjjlR
         ivzX0mAOdjhVeZ/fsOkxYeKREs+m+KKPXNdTx7s300LL/w+ZuM5N/v8Rz4Tui8UYVsFP
         fCUA==
X-Gm-Message-State: AJIora/7AQWpBcLaI3chPtuh9X/Iqyypvm3O/GllG6CDwnIGRJozGwRV
        5u7JWp7u8d+qa3jxRXy+Jwxioo4sbLAsOGsp7Xb3ZJGP+zWZZfMS7BNaszLcPaLXkn1qQQJpyv1
        LrsjA3+5vSPkU
X-Received: by 2002:a05:6602:27cd:b0:669:3d8d:4d77 with SMTP id l13-20020a05660227cd00b006693d8d4d77mr83534ios.216.1657229569985;
        Thu, 07 Jul 2022 14:32:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tg2gPxDcSD3Zl8LYAqqK1uXEOcMwrfIdH93nrGqcskQfyjnsBJL74W73KB+ULdOtM2GF25kg==
X-Received: by 2002:a05:6602:27cd:b0:669:3d8d:4d77 with SMTP id l13-20020a05660227cd00b006693d8d4d77mr83529ios.216.1657229569809;
        Thu, 07 Jul 2022 14:32:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y22-20020a056638229600b00339e2f0a9bfsm793307jas.13.2022.07.07.14.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 14:32:49 -0700 (PDT)
Date:   Thu, 7 Jul 2022 15:32:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/pci: fix the wrong word
Message-ID: <20220707153246.48b26a68.alex.williamson@redhat.com>
In-Reply-To: <20220704023649.3913-1-liubo03@inspur.com>
References: <20220704023649.3913-1-liubo03@inspur.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 3 Jul 2022 22:36:49 -0400
Bo Liu <liubo03@inspur.com> wrote:

> This patch fixes a wrong word in comment.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 9343f597182d..97e5ade6efb3 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1728,7 +1728,7 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
>  	/*
>  	 * Config space, caps and ecaps are all dword aligned, so we could
>  	 * use one byte per dword to record the type.  However, there are
> -	 * no requiremenst on the length of a capability, so the gap between
> +	 * no requirements on the length of a capability, so the gap between
>  	 * capabilities needs byte granularity.
>  	 */
>  	map = kmalloc(pdev->cfg_size, GFP_KERNEL);

Applied to vfio next branch for v5.20.  Thanks,

Alex

