Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1F0624B97
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiKJUSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiKJUR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:17:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C681E450BF
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668111415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZltWYVEOG+yM5d6qffeJBrblT1mFe5B3vZnJjt5Y+Xc=;
        b=Oas0NnFeNna0obR+uphGXCH6WxCEONXnrPsUOKsJg2Mg0uLz0/vnF9z8vwkoq8DsSuS2zx
        QG749lo9xoPJmX1Yutg8tRpM/BkcuH+qU4rwXGhFEte3zHSO9rT9vs1gOm4tAn8Tysz2Q4
        Iybb55Q4OkmLhbmbeU44/orbdCtEL7w=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-37-DcEtradSNMupjADhiZedUg-1; Thu, 10 Nov 2022 15:16:54 -0500
X-MC-Unique: DcEtradSNMupjADhiZedUg-1
Received: by mail-io1-f70.google.com with SMTP id i3-20020a5d8403000000b006c9271c3465so1778942ion.4
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZltWYVEOG+yM5d6qffeJBrblT1mFe5B3vZnJjt5Y+Xc=;
        b=fzc2A5eCCtBnfQNMjAKltjKc2Nk9vjQRAOr40E4FgF2O+GFOtoRaET/rPXAQgwNaES
         zOsKhgsLLDoRLVwlgh6trV68xzjongx7kkyPXuTcECjOhQMRUZC+fsXGwLYFPkc1y/CA
         Jd6IxY8keaqDLH23t5hbgEm6l3NeGff2cduglXR5GkSITUUr4BCyQ7mY1t1PRHBSxn02
         GCjmV2D/U5Dzmr+NNCLdZKv0tZobZ16a6jpVz9TI9P+Iz2VrIBQuuUn8ZIaHMFw6OBTS
         x8hcZYTA3vIrGBC5pT9ZIigV2qj4u72oaY8uSculSxS2PsyUQ6I15ylJ+nfTOBciwNGK
         ZEbA==
X-Gm-Message-State: ACrzQf0UKDfps0VzWjkxYk9LvCxpTMGz3dwWffP9Y1XNbmO0VgIkWLlh
        0R8BYDplVxv5tXol84rF+P88pn2lgbcPjdOZw3BbjkpFKvwI3YVUihRGO5UO5aMbJWNczYbrX2S
        aMxWPMUoEU1gh
X-Received: by 2002:a5e:920b:0:b0:6c8:209:fe2d with SMTP id y11-20020a5e920b000000b006c80209fe2dmr3399048iop.47.1668111413929;
        Thu, 10 Nov 2022 12:16:53 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5y8RGsajiWLk30+1ihf0E1uH/5XlBuSC0OV502Coz+hBDuflZrAA1lW9ysp1dWVQh2wvRhPw==
X-Received: by 2002:a5e:920b:0:b0:6c8:209:fe2d with SMTP id y11-20020a5e920b000000b006c80209fe2dmr3399039iop.47.1668111413704;
        Thu, 10 Nov 2022 12:16:53 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b006bbea9f45cesm25981iow.38.2022.11.10.12.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:16:52 -0800 (PST)
Date:   Thu, 10 Nov 2022 13:16:36 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Rafael Mendonca <rafaelmendsr@gmail.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sinan Kaya <okaya@codeaurora.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: platform: Do not pass return buffer to ACPI _RST
 method
Message-ID: <20221110131636.1097802c.alex.williamson@redhat.com>
In-Reply-To: <20221018152825.891032-1-rafaelmendsr@gmail.com>
References: <20221018152825.891032-1-rafaelmendsr@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Oct 2022 12:28:25 -0300
Rafael Mendonca <rafaelmendsr@gmail.com> wrote:

> The ACPI _RST method has no return value, there's no need to pass a return
> buffer to acpi_evaluate_object().
> 
> Fixes: d30daa33ec1d ("vfio: platform: call _RST method when using ACPI")
> Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
> ---
>  drivers/vfio/platform/vfio_platform_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 55dc4f43c31e..1a0a238ffa35 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -72,12 +72,11 @@ static int vfio_platform_acpi_call_reset(struct vfio_platform_device *vdev,
>  				  const char **extra_dbg)
>  {
>  #ifdef CONFIG_ACPI
> -	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>  	struct device *dev = vdev->device;
>  	acpi_handle handle = ACPI_HANDLE(dev);
>  	acpi_status acpi_ret;
>  
> -	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, &buffer);
> +	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, NULL);
>  	if (ACPI_FAILURE(acpi_ret)) {
>  		if (extra_dbg)
>  			*extra_dbg = acpi_format_exception(acpi_ret);

Applied to vfio next branch for v6.2.  Thanks,

Alex

