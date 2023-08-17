Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292D477FD52
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354139AbjHQRzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 13:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354169AbjHQRyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 13:54:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F9626BC
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692294823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0YkpgQw4vlMJpOpc6GJJPGsxaFy+WkowoWtqubNlaH0=;
        b=cAqbAstwTCxBXj2dK9N1qno6fo9k9SS9q0Xgb6Mz4iqtYGQyLyzXcZhVVxAKQEVWh92KJB
        YdDahTyR6VgBHe+Llcr8ii0BZeoQc6wfPoAQ6cN7uw5YtY8slwOzD/ncmqv/v+d4brgA0N
        npOJ4sfLPnIMobrICYsO3zHTEmerhfA=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-G3c9bO26OZGin6HUG-Ka5g-1; Thu, 17 Aug 2023 13:53:39 -0400
X-MC-Unique: G3c9bO26OZGin6HUG-Ka5g-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-34a8bb63376so840345ab.2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 10:53:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692294819; x=1692899619;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0YkpgQw4vlMJpOpc6GJJPGsxaFy+WkowoWtqubNlaH0=;
        b=cLKgpWy9llgty5yzPo/6Ign8B91fnLIJ35kH6rKHJF7JNJuHeQBD7vFiEnucQDxkbg
         XDRfrp9tYxL+6WkQ8t6pyCqytq+8G/dqZQ02jKIxYjcYcrVFbkcOCo6pKzQeJGlcjYAx
         aV9+0W4xS4UlLCQ9Yu5zrWgpPjEwdmqJvqJQO3ejnsFMoTvjeeF6Ob80nDDXjR7UIpfv
         kC6T5j7O73QFS2UfB+6T/nOtTNKsckrsgxcF9JcN14rzCbWfrG6cma3TYt5pH28M23TU
         B/e7+79wfEi1ateAakvuNblDukJFF0c9Vf0YX+OTNDdy+9BOFuQCi3nIodKFmJ575k2M
         vjSg==
X-Gm-Message-State: AOJu0YyJnc4iNkitmVOnQJp9Pk5bihEj1ylMptaj0EAPoQLINF9CX8NB
        pDuat34+NXhMz5za779UaWR7HvkfEbfxmCf8rTqApr4ZveGFgM2O6iU3d19GSR27hYmHSmBj6+Q
        ytkCi1ljbA3yJ
X-Received: by 2002:a92:c54d:0:b0:34a:c28f:9416 with SMTP id a13-20020a92c54d000000b0034ac28f9416mr355672ilj.26.1692294818979;
        Thu, 17 Aug 2023 10:53:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFc5fBPCWW0VkS/+HBJ/rv67ZjWM/4cVw+vZB2KZA1X47ULnhiHeA67lC0L7xyCML5TLwPlIw==
X-Received: by 2002:a92:c54d:0:b0:34a:c28f:9416 with SMTP id a13-20020a92c54d000000b0034ac28f9416mr355661ilj.26.1692294818739;
        Thu, 17 Aug 2023 10:53:38 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id l3-20020a922803000000b00348cb9adb38sm10478ilf.7.2023.08.17.10.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 10:53:38 -0700 (PDT)
Date:   Thu, 17 Aug 2023 11:53:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     <diana.craciun@oss.nxp.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH -next] vfio/fsl-mc: Use module_fsl_mc_driver macro to
 simplify the code
Message-ID: <20230817115337.5d80c684.alex.williamson@redhat.com>
In-Reply-To: <20230809131536.4021639-1-lizetao1@huawei.com>
References: <20230809131536.4021639-1-lizetao1@huawei.com>
Organization: Red Hat
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

On Wed, 9 Aug 2023 21:15:36 +0800
Li Zetao <lizetao1@huawei.com> wrote:

> Use the module_fsl_mc_driver macro to simplify the code and
> remove redundant initialization owner in vfio_fsl_mc_driver.
> 
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

Applied to vfio next branch for v6.6.  Thanks!

Alex

> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 116358a8f1cf..f65d91c01f2e 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -601,23 +601,11 @@ static struct fsl_mc_driver vfio_fsl_mc_driver = {
>  	.remove		= vfio_fsl_mc_remove,
>  	.driver	= {
>  		.name	= "vfio-fsl-mc",
> -		.owner	= THIS_MODULE,
>  	},
>  	.driver_managed_dma = true,
>  };
>  
> -static int __init vfio_fsl_mc_driver_init(void)
> -{
> -	return fsl_mc_driver_register(&vfio_fsl_mc_driver);
> -}
> -
> -static void __exit vfio_fsl_mc_driver_exit(void)
> -{
> -	fsl_mc_driver_unregister(&vfio_fsl_mc_driver);
> -}
> -
> -module_init(vfio_fsl_mc_driver_init);
> -module_exit(vfio_fsl_mc_driver_exit);
> +module_fsl_mc_driver(vfio_fsl_mc_driver);
>  
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_DESCRIPTION("VFIO for FSL-MC devices - User Level meta-driver");

