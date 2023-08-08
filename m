Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A70774CAC
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 23:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbjHHVO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 17:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbjHHVOQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 17:14:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5535581
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 13:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691525645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tq9zaiMuCXpHn4k92r0nRKOAFW/cdOCpDp3JYeJH9A=;
        b=fCUEq+MvW5psCmpY15mmB4X5qPhChuTRSKlxOMt/VQXIuN9ZoEeFhE93BmlaG1L3St+BYg
        uWDNiiBXU86tqZhh3SfsixaJ9Z7XVS9KCRUdCDvVkksx0YFPGx3UtdJvKirI1SComtY8Db
        lCt7kpxyBLrxz25SyAP3dkodrjTXvi4=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-thv8kBBkP6ymcgT9ihKsXA-1; Tue, 08 Aug 2023 16:14:04 -0400
X-MC-Unique: thv8kBBkP6ymcgT9ihKsXA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3495ff148fcso38388515ab.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 13:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691525643; x=1692130443;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4tq9zaiMuCXpHn4k92r0nRKOAFW/cdOCpDp3JYeJH9A=;
        b=k5P3gvy/n3/fDBcR6K/3RUKGlOdhGVkNPvC3dZsctOKZBAczccQf6dickkYRYw1RTR
         8AstzN+JA7jrtM2hBtRZxQzddeJRWaZfZ1vqpC3AC2QdmLOJvGDl9r8S/qlZH1RQX1TG
         NeQodwcH2tDow0yDU5RcljuZl1IVAG4sQ27aW9R6B3hh6GYRLMsRAhccxF3Ot/8gBNVH
         SRcpmty00C2rwvq0JjqR5iNJ9WvtPn70AEgNkn1Gdvcg6E4M/F19cynG8+/wRfujmQDZ
         FQFWXQM2qQv+m3Yqa/evWBqucXjULyOFB2Ct/2ABbI+ZsNYyS0ikzdL2Ix9BmcZ0syMS
         4aAA==
X-Gm-Message-State: AOJu0YzTaVI18pAhIixdmNSJ3L7JvCRk+OepuMJaNkR8C+wIUN3pqny9
        yjVQRlYYOk1PWY0Ck8q9aX8aiZWSw6R+7f7/NLDGrrUdwQIzead0BcpSp5ehUizHGup2O+j9Sf5
        vYwpvQ5YCyGdhDwSc5j76
X-Received: by 2002:a92:c5cf:0:b0:348:824b:8949 with SMTP id s15-20020a92c5cf000000b00348824b8949mr855992ilt.15.1691525643110;
        Tue, 08 Aug 2023 13:14:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF35Are0JBcvXwaL8NZqOifBd2r2CGWj31ctQ95nS53cfvyCm9DXh5rr72/u+RrbGNG1vRQgw==
X-Received: by 2002:a92:c5cf:0:b0:348:824b:8949 with SMTP id s15-20020a92c5cf000000b00348824b8949mr855984ilt.15.1691525642845;
        Tue, 08 Aug 2023 13:14:02 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id h11-20020a92d08b000000b00348ac48e127sm3688902ilh.33.2023.08.08.13.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 13:14:02 -0700 (PDT)
Date:   Tue, 8 Aug 2023 14:14:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     <nipun.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH -next] vfio/cdx: Remove redundant initialization owner
 in vfio_cdx_driver
Message-ID: <20230808141401.0f680e7a.alex.williamson@redhat.com>
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

Doesn't vfio_fsl_mc_driver have the same issue?

#define fsl_mc_driver_register(drv) \
        __fsl_mc_driver_register(drv, THIS_MODULE)

static struct fsl_mc_driver vfio_fsl_mc_driver = {
        .probe          = vfio_fsl_mc_probe,
        .remove         = vfio_fsl_mc_remove,
        .driver = {
                .name   = "vfio-fsl-mc",
                .owner  = THIS_MODULE,
        },
        .driver_managed_dma = true,
};

That driver could also be converted to use module_driver().  Thanks,

Alex

