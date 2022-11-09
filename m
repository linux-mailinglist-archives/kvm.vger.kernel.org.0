Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FC0622CB2
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 14:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiKINr0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 9 Nov 2022 08:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKINrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 08:47:24 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F148817054;
        Wed,  9 Nov 2022 05:47:22 -0800 (PST)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N6mVM4snzzmVmJ;
        Wed,  9 Nov 2022 21:47:07 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 21:47:19 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.031;
 Wed, 9 Nov 2022 13:47:18 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     ruanjinjie <ruanjinjie@huawei.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] vfio/mlx5: use module_pci_driver
Thread-Topic: [PATCH -next] vfio/mlx5: use module_pci_driver
Thread-Index: AQHY9B9JATTBSKrWTEWcdf6z7LJE4a42mwjw
Date:   Wed, 9 Nov 2022 13:47:18 +0000
Message-ID: <3f95546cfb8a43d8b33b9b5e32203289@huawei.com>
References: <20221109093703.3551036-1-ruanjinjie@huawei.com>
In-Reply-To: <20221109093703.3551036-1-ruanjinjie@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: ruanjinjie
> Sent: 09 November 2022 09:37
> To: jgg@ziepe.ca; yishaih@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kevin.tian@intel.com;
> alex.williamson@redhat.com; cohuck@redhat.com; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Cc: ruanjinjie <ruanjinjie@huawei.com>
> Subject: [PATCH -next] vfio/mlx5: use module_pci_driver
> 
> mlx5vf_pci_init and mlx5vf_pci_cleanup with module_init and module_exit
> calls can be replaced with the module_pci_driver call, as they are similar
> to what module_pci_driver does

There is already a patch out there,
https://lore.kernel.org/kvm/20220922123507.11222-1-shangxiaojing@huawei.com/

Thanks,
Shameer

> Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index fd6ccb8454a2..457138b92f13 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -676,18 +676,7 @@ static struct pci_driver mlx5vf_pci_driver = {
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
> --
> 2.25.1

