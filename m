Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1CC77FD55
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 19:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354146AbjHQRzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 13:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354218AbjHQRyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 13:54:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50FE358C
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 10:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692294842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8CqCmv4ygz1U/GbxwOYkyu8QGxydRz39PkLsNwIRch4=;
        b=B9UAqHHewkNLCnTQ588mz0deknpPFdQz40DjdOTof5GC0VFhj9/yNJTO66PVFp5Wxyh2FT
        9TRmXSSQpr5Fo0VhwP9oTzmReowq2pW+lINyJUAIsAPu3I1z3bHJQcK+kJwtvYX5b86GrZ
        0QK/bv2ROJEceVOI6p8UEM86u/Zc0cM=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-6rz-OX4gNQa5qPd-mvLFmw-1; Thu, 17 Aug 2023 13:54:00 -0400
X-MC-Unique: 6rz-OX4gNQa5qPd-mvLFmw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-78360b16f15so84746839f.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 10:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692294839; x=1692899639;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8CqCmv4ygz1U/GbxwOYkyu8QGxydRz39PkLsNwIRch4=;
        b=dD5vA4nXAo3io5zwSrJ6+ib/uhcXlvs7L/hipDIB6nB11EtxiFw4n2Mn+ChRZgIxF+
         ePFpN9wTn96rYrqTiGwaBpEj7eYlSYLvzjrXsD5r3PNv6PBx3nsc2JUnd6oion0F1VRS
         dOJ93u1UC/EUdkk8sy7d82WmxN7OrW606S3CC9BvYk4nnpcaSd4+5b5M3N4xS9BE4viC
         7W+sll2Nc8097w1mAG/Y21P04hAHjfuXHbrWpqUQOUN7b9guJNeDm66PMIgE3hFBgt0Y
         yY8nxaQZbD+3prKwUZZXKUj5WmG71pI+uak14MfNqZVuMZ2MNNJivABBa5hkeX95Vuhr
         8ODQ==
X-Gm-Message-State: AOJu0YwXIZ9fhWArFg2Dr1FhcXH15SWC06tWSkCPQber0JTMDX1ERBmH
        pqEzqMrxoO+0WiJ2xJ0Rhaox3BgtcroW4Qkix5nYPLOf+fPu6Vm4Ja7GURnKctvlsg0lI/pKdHq
        qABwcHe9D87w7+uWHeMf0
X-Received: by 2002:a05:6e02:1544:b0:348:d683:36bf with SMTP id j4-20020a056e02154400b00348d68336bfmr4496417ilu.12.1692294839473;
        Thu, 17 Aug 2023 10:53:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4EplQcoRv6A79pw2OAKunOZhkQxDQelU1L9hk6MH4uReKOSoYdP2ZJ/a6TZ+k2wCC3nvMuQ==
X-Received: by 2002:a05:6e02:1544:b0:348:d683:36bf with SMTP id j4-20020a056e02154400b00348d68336bfmr4496403ilu.12.1692294839281;
        Thu, 17 Aug 2023 10:53:59 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id n10-20020a056638120a00b0043166f90251sm2082070jas.77.2023.08.17.10.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 10:53:58 -0700 (PDT)
Date:   Thu, 17 Aug 2023 11:53:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     <nipun.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH -next] vfio/cdx: Remove redundant initialization owner
 in vfio_cdx_driver
Message-ID: <20230817115357.7723126b.alex.williamson@redhat.com>
In-Reply-To: <20230808020937.2975196-1-lizetao1@huawei.com>
References: <20230808020937.2975196-1-lizetao1@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Aug 2023 10:09:37 +0800
Li Zetao <lizetao1@huawei.com> wrote:

> The cdx_driver_register() will set "THIS_MODULE" to driver.owner when
> register a cdx_driver driver, so it is redundant initialization to set
> driver.owner in the statement. Remove it for clean code.
> 
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>  drivers/vfio/cdx/main.c | 1 -
>  1 file changed, 1 deletion(-)

Applied to vfio next branch for v6.6.  Thanks!

Alex


> 
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index c376a69d2db2..de56686581ae 100644
> --- a/drivers/vfio/cdx/main.c
> +++ b/drivers/vfio/cdx/main.c
> @@ -223,7 +223,6 @@ static struct cdx_driver vfio_cdx_driver = {
>  	.match_id_table	= vfio_cdx_table,
>  	.driver	= {
>  		.name	= "vfio-cdx",
> -		.owner	= THIS_MODULE,
>  	},
>  	.driver_managed_dma = true,
>  };

