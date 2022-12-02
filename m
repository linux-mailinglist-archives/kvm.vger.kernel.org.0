Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB2363FD54
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 01:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiLBAvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 19:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbiLBAvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 19:51:08 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5336CE42D
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 16:51:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dH9ZltVB4N2S1HQLJKJ2Y6yxJLNftubytaSa6/jOK29P0ujL/dSsXGdjnBEV176v/1djdCy0BtvVY2NiO14asa78Y2c7c9AhqjXRMpiDaK1jy0Eq7yaS3uU/CamcWvLqacEpQmPgVUmfrTNiGsHjPyMwSVf6jnqzik867X1mK2UdVSV0JhRWnlb1xeVJWVMeaujaUDnFdEe02iFsF516MzO8CeGAZk5R9dMJDZmyU7lp1loSLXJKVfOdcgnmQn/fEyQQHFaTIybfG72UzfB9PUeUkkoJAmH+JObkJgde675fSCasktkPHELSZ6RjTyyDGwZP5DqxmYFdIyM9QGviuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9Dvy8TZZMeQsfJOR67UtbnlYqHccBaWoGHlcyfm8Rc=;
 b=MWy3FPH3WgxuSMsX7hFMgF8lvq0jopr2rVdrG/O/Ru+SrFvbzm9PqtR82HVrWBnRauF1btxwRyjD1AN0u2DBaf85Hfl6vhVeIDogTm5XBmwhL/8AgVDpOWWpII3CE9zM7nmTCEZn84JO/HlvU1t1WbfKB1iVeHN4Sv31AT6AVg3hVM7sm3/A5ymqEDjN2EppE0qQ3gtW5TBd1/RF2mjLke0Gkm28AIcwX1eGn9OPjOc9lqznWuxEWMBh8D70ou380C5+YPtFZAHiNovUpR0ssR294MI6wKWxc5g8MD6t217ZEMjYTVTCqNNqxIu6w8s6gH8ocf+wRGR+wERSIKWgYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9Dvy8TZZMeQsfJOR67UtbnlYqHccBaWoGHlcyfm8Rc=;
 b=nLsWSw2uRxOPOfgZRAtg1iJlvV4OUN5jAylGqnZfRnCWBmahhwiR+zHGJ0rach0ZdSDTwre0Yl7qLIP3YKs56c4UqqvTk7ARmHIxYftIATPOfD3wqL/LdaXsDVAYX49F5b/5YiK9kbV9uXufdhBn/QCX+DVuWGbQmo6MQ7mRJjav8B0wwhhtk90rQyiCxmATjo+6hcCMTPyJkYNF3oyHeU2Yo10QArMrOLMVnryJ2CRHXj9o6OJ/3UStVDgFSwKGObtpA2M+puzukitA7suvA0ELnpimpZZGivBlJ24sdTtJVEIFqq9G9qsKMDXlvccSHUiwyt02FP/9zgtiz+Z2vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4581.namprd12.prod.outlook.com (2603:10b6:208:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 00:51:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 00:51:01 +0000
Date:   Thu, 1 Dec 2022 20:51:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH V2 vfio 03/14] vfio/mlx5: Enforce a single SAVE command
 at a time
Message-ID: <Y4lL9CdGcqLWh0F2@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
 <20221201152931.47913-4-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201152931.47913-4-yishaih@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4581:EE_
X-MS-Office365-Filtering-Correlation-Id: c916efbb-3848-4804-cff7-08dad3ff48c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PlrNA2IBbZ2Wmp64oI244p44FDioqhCYMwx+OtKBTXbxJjZO3wAfD+trLKvh3LbL5HSKfB/5JwNCItyTkkZ8riHrG3cpYiibLvgKzlj8Jy61u2zw+mfJomu8LLMjuOvYQgPa9rToOQ+MQgLRKv49iQXl2o5Ncmx9jQdwLeYrYb0RFuOhMpoei26oRp6SFEAvaDAzW2e0NGMRK43lBMfIdjzxcxX+XpAGrFuS/KIye2wpmoOogEvX15yAqJsxLJSq7CTIQfEDO0CmzBsS/58o5JE+HP9HiES2wL9WfJVjLcYRYgNErBKdAFXg6Vg/0HeN5kbo5rBM90NaElQ3uuo7Q+b8UFN7F1kcQsIYGYjKKN5zFtJPKKo3sJjIAf+fyrz2n1Rw8oF7mbE8lGF20naOjZQLTXEOFGt3YfJaMy0RyQWAs0m4qUAdvnQWtxVbw99cdySbaE991WmQhW0cVbgPOqBgqNw5KBXHwrvVmzVSGYkWZaSUfZTW7pASswz/4RUAlQ0oco1mAV9McW2EIFydUcnTJzaT0Nf8pLc/fz2R+VhmOIgQLjQ3eOqL3yfpvzLrhjmOVebTQOVlqVid8nArhKHfOtnqZCzajPtXKI3hehJtgPhKAyq6LRObINwPWnZwOablUc6Ehv2pZFj3zGCnvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199015)(6486002)(6506007)(478600001)(4326008)(2616005)(36756003)(41300700001)(186003)(8676002)(66476007)(66556008)(4744005)(6512007)(316002)(5660300002)(6636002)(26005)(37006003)(2906002)(66946007)(83380400001)(86362001)(8936002)(6862004)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RPeNmyK9fEjFIQii2FLTIHABNTTpErDKCRrWP+swDA+zHvA2XXYo2K3UcpIc?=
 =?us-ascii?Q?l4sULW7yMr3yv/5iOzZ4bR6lYKQ61LkdsKj9JMbjSCm5W4Q37U6PRFA5sTCf?=
 =?us-ascii?Q?L46gtFFFac3eajRMN+gCPATImrzYyzMbrHtOfGtg6XRX0928AqI5QMI1ZB+u?=
 =?us-ascii?Q?K2UAG9cdkF3YuW4dtasMAkVMw6bzi+ergHJC9aDHV1PJyoRJGYo23Bt2PMfh?=
 =?us-ascii?Q?729eORudcd5HAUs4i+8gqHvgcod3tEhVj1jBTGEiwq5XnxwQhP5YpH+YaJxE?=
 =?us-ascii?Q?TMaFIxcsEl7H/w6f1QDslxcMLiCVMWMguKjNVbvzKS2hzTbD6057yioI+46Y?=
 =?us-ascii?Q?56CBERki+gcw9H5fGDb9icNpLMXdlwtPtHly7kTrmp0+83msUdLr9LMAm4ju?=
 =?us-ascii?Q?wzBqzUsxbxS810QJv8Oonqd1roJkcpBiX+ykCiTRTEsmXWQB+PO0bq74NWxh?=
 =?us-ascii?Q?T32yUVktbmxC2vlm+CVhtRp3G9ZnvBK+ayDX96f4NuMJFtV/WH6RQO+KNDQz?=
 =?us-ascii?Q?8sHXB3a7vYPnEr/K9IHiPIFJdPrVlVjK/D1xGQw6b4zV/Wkr2RMzOP5EZVbf?=
 =?us-ascii?Q?Onv4hlArdW9Qve0Sfums+6SBzqZSU02smIe0LiEZEQYeICBgelI1QE3hyQG3?=
 =?us-ascii?Q?oO/01/gLkRPNJb/6AEfdoCPd9v9TX0CG89La7QDLgijWqEgBkwAMTRGCXBnE?=
 =?us-ascii?Q?ut4ZwzLCfqWSILbcW9TlKXGBkQTtmRZ3H+MdX3lvCX5hMfDb343H9TLS8l62?=
 =?us-ascii?Q?jG7+njyZORA6C150A6FP5XYHLsRAar7a/yXJr5pegN9H91pJt2rOz3Z+v9kS?=
 =?us-ascii?Q?Y8vW5XPkqkORyE15jPxe0o57xF/JZ406mUYfyHvQCc06+8Nge5vF4aaSzrf9?=
 =?us-ascii?Q?iikV7VogbFycH8/EW3Mh3FcDlGPpcb8EwID3gLzubuVA2Esq9ewIUeG4tgxA?=
 =?us-ascii?Q?GbytNH/+ZVgg8edBCzsQdIgjAmm84nYK3XviwIeR1VS3LeN1Z/+sNRLHGmv6?=
 =?us-ascii?Q?3kap30ZMrV2aeTTQpG3pbhaxr9dbw2b/vqRW3jMUsS4OCb+EdXZWI/e77O5h?=
 =?us-ascii?Q?KaY4zI+bjnOZI0qe8k/45IqUOdJA1RCAVVpHOjtyhyAwPG0Vp1IJL9GS2TyQ?=
 =?us-ascii?Q?rWFBZEF0c0FjnFua0aW4lpf+VLiPwUtpcXtkM7r+ZQRXLjXuQghsZ0h3n8q3?=
 =?us-ascii?Q?X37u9Beet6ZRPmCeV3QNIfa3wsTm/C3ybjOjRjI6RxozgEcRX8VypGFqJyf3?=
 =?us-ascii?Q?7aSDhO0DC/he61Nb6u75YZcKoAxdIdfa4V0xTBtPsye0l6x7ZdeVXJdQDkms?=
 =?us-ascii?Q?ZNXsBJWdfuCahpgcxHHv5s01IuEYnwIfdjHGyIqDidXSIHg79lo3QZnogamT?=
 =?us-ascii?Q?UkQ0BoBlbBMVyBYoc2i5R2n0R/S9dOnXenfQB2M5ku/hiayeoeVqR4IJhkEt?=
 =?us-ascii?Q?et7577CY5cD4ZzpDU46F1ld2Bm/tluvsuQp1rjdCOymlOeZvxk3RBYeca5Dv?=
 =?us-ascii?Q?LdsXFUuPlFm84S5q+WvmQbHyXnN6N+WNNCHRApPIiKwDkqwBSX4SylAXO1Be?=
 =?us-ascii?Q?PPtRdK8z9/U2h7IM7eE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c916efbb-3848-4804-cff7-08dad3ff48c8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 00:51:01.8681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0g6Hfaq6oXFnW8REI1u/FHIWZbZfrRHHzHlPw+oJNXwziAoMh8J2JD2N6XJCXEib
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4581
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 05:29:20PM +0200, Yishai Hadas wrote:

> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 6e9cf2aacc52..4081a0f7e057 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -245,6 +245,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
>  	stream_open(migf->filp->f_inode, migf->filp);
>  	mutex_init(&migf->lock);
>  	init_waitqueue_head(&migf->poll_wait);
> +	init_completion(&migf->save_comp);
> +	complete(&migf->save_comp);

Add comment here 

save_comp is being used as a binary semaphore built from a
completion. A normal mutex cannot be used because the lock is passed
between kernel threads and lockdep can't model this.

Jason
