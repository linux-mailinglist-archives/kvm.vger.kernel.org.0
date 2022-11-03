Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F55618835
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 20:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiKCTIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 15:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKCTIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 15:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4EA1C919
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 12:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667502467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zhbRKqOz7AwtNr+GvYAbUWRDPYB/jC5g0HhlYMT07Es=;
        b=QYPtAB/CUu6FPrjMGtwHp3yK698dSBygUauhFmiW0Pz26GjQPIRhrTtKWjoxL5VeIQm+nn
        bUf6V9m17KK+PHuGQO1THGWD2D7NJzVrB42fGy2+7qeoG2tmtp00FpJrafgFQ5xcnx1RnF
        cYaKtdvSNMP7URYnoe62DlF0aAB+ZwQ=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-312-QaItLcmUPLSwBs4UDARjKQ-1; Thu, 03 Nov 2022 15:07:45 -0400
X-MC-Unique: QaItLcmUPLSwBs4UDARjKQ-1
Received: by mail-io1-f70.google.com with SMTP id r197-20020a6b8fce000000b006c3fc33424dso1624785iod.5
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 12:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhbRKqOz7AwtNr+GvYAbUWRDPYB/jC5g0HhlYMT07Es=;
        b=ceTsEyhhfx8KdXliLYXflg7e8HZ6Y+0AgM+jsXf6kLSgnmasMhs2ITCyPeuKv4UlYK
         hICjeeTqErfqucYZVVMcFI+JYV4slsO5sAGBnrKloAuGJBbULqnFyM3plmzK1WDM0qH5
         S/GzNllky6qzbJYai3IcOb1pOi8+34yf49xfKq/w+DpX7ca5TxkK5AX7lN5GNddMj1Pm
         xzgVYCPcnhURhjAKqv6DhsfT/i4ltIqOH7Jnfy9JkOqTAZZFVp7svshi5Ru/K3y8KACG
         MK8w7ZvV43CdR3PqxTBK1zxKKwWkQM/Jeeaa3EPApQ8bArzp/IRdtOsrt9N3t5ucyexC
         1TsA==
X-Gm-Message-State: ACrzQf3WulFeocSNxtY34kqsS3MiIMYAGpEs/T7NUee//oA4SLvB5Oig
        3DPCJY8PD8Nj4E38RLxKmGw2ETRSiI/ijfUrjlj6xVOiKYzMu8mVygH+r/x/cJVjhpnCICwcF/U
        NvUboiK3yJgsW
X-Received: by 2002:a92:6b0e:0:b0:2ff:df3e:995b with SMTP id g14-20020a926b0e000000b002ffdf3e995bmr18395888ilc.193.1667502464730;
        Thu, 03 Nov 2022 12:07:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6fhGJKoBZkZf/dm9GJzjm9FHbno8qR0vL3K83tJEgMIfrczp5aL7DisKmHa0IGGRd58m9GWw==
X-Received: by 2002:a92:6b0e:0:b0:2ff:df3e:995b with SMTP id g14-20020a926b0e000000b002ffdf3e995bmr18395878ilc.193.1667502464554;
        Thu, 03 Nov 2022 12:07:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i9-20020a056638050900b0035678e2e175sm453025jar.50.2022.11.03.12.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 12:07:44 -0700 (PDT)
Date:   Thu, 3 Nov 2022 13:07:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     <yishaih@nvidia.com>, <jgg@ziepe.ca>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH -next] vfio/mlx5: Switch to use module_pci_driver()
 macro
Message-ID: <20221103130742.1f95c45c.alex.williamson@redhat.com>
In-Reply-To: <20220922123507.11222-1-shangxiaojing@huawei.com>
References: <20220922123507.11222-1-shangxiaojing@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Sep 2022 20:35:07 +0800
Shang XiaoJing <shangxiaojing@huawei.com> wrote:

> Since pci provides the helper macro module_pci_driver(), we may replace
> the module_init/exit with it.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Nice cleanup.  Yishai?  Thanks,

Alex

> 
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 759a5f5f7b3f..42bfa2678b81 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -654,18 +654,7 @@ static struct pci_driver mlx5vf_pci_driver = {
>  	.driver_managed_dma = true,
>  };
>  
> -static void __exit mlx5vf_pci_cleanup(void)
> -{
> -	pci_unregister_driver(&mlx5vf_pci_driver);
> -}
> -
> -static int __init mlx5vf_pci_init(void)
> -{
> -	return pci_register_driver(&mlx5vf_pci_driver);
> -}
> -
> -module_init(mlx5vf_pci_init);
> -module_exit(mlx5vf_pci_cleanup);
> +module_pci_driver(mlx5vf_pci_driver);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");

