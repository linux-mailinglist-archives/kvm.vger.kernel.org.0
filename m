Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95ABE758328
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbjGRRBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 13:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbjGRRAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 13:00:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B66C26BF;
        Tue, 18 Jul 2023 09:59:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiiapCrqrz7e6ewnuDopwfL9ZttMwjebdaBkz3E6U+GTquOqarmc5v+oLTMCc+E1q406v3Tje3YOiQUR5ThLIp8iEzsdaKDUjDztcQ6MRlLpkDssuLHPCjcnpzK0Nm74tArP7vwEPRYM/GoDKt929BGgy2w9MUjcP64RxmEfqVZ7naHyqn1hYrJroWYMMuuLV+mkXfHGiOWVMzDMdRS7fe6O83cDMU7UMihzSd9YByfTWJdGOA33pIU5xZyMUKHB+S2nn0HmVTorIIuSiDNiadh074rUoC2Eq0Ivw0h7HKQnTgx56GuP4GXgatP2hVopvw4QUx8kLhXqFaKIGv2qLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZujBfGy/37u3JUZbqh9MtiouR/Kzzi46Zchc+42S2CI=;
 b=OFPkB+2OdYP01wiWBnd43PjBgBvieUftiVN6xU2UZ8INf1xIIBzzqGwOaXDjhb2VeZCNT0KJhuFbY766AGm4YkB4ZIN1a466D9dZk8B6xPoATaqk4avdkVv07q6AxjY7PXOCNqfoA0a0AmRHPnrhK5Ytx3BwyP0cONXD6aoM1Aibg94j88BopLH2R3pfbs6KOnyk+9YeLIVRFroqS3ZCvcWAIiuSgDLLRhYGQ+AU5sxwgEDQ8G8HzPfkORzU+D7qZKPEyZm0AtrIgDHOUrh7IiYcZt0r7JqGUPAkmiTdEWIt8IjWgZFJpdoihhIJd9g2RYKCDRrozM1tuNDcTwI1Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZujBfGy/37u3JUZbqh9MtiouR/Kzzi46Zchc+42S2CI=;
 b=cY1KqGz6LnjhEZlTLOMvI0A5xanWq92Q966MO8OdnLQ1LEebMEC0eJkITGoLj3mCfomopF3CYUHRkA2O+7bD4pl3cGWh6Av7B2mQxzywrDt067pbzM7rmHHRI7JyRiAREXKKEnvRpWzPklWjX9CGsHdQsev9M8ky10rxJHcNSecLwpEsKhb+EP76XHr7Ki+GoxhWNb6Lere1iCR3NXkSnfukzBkS6a0HgBWdRxO+hVpgtmsxqoe5acnES72ENnEdsBNnXF1QgQHqqEz0zqiVdcOr/fj6Ml8hMeczQacxgiSSW2TXGX5x/IMqLKPp6lX1RNZHJI1NQyCU9spx6a7Yhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 16:56:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 16:56:47 +0000
Date:   Tue, 18 Jul 2023 13:56:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v15 22/26] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZLbETPMmth9RL560@nvidia.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
 <20230718135551.6592-23-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718135551.6592-23-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: d60ae1a5-074c-40e8-e9fc-08db87aff8e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJ+S7pusripxQvQY1xBu1/9AY5gkQuYOOebpGYjDFysv+QDnDIYej9ihOZwpI2FJRubJydt6npbB9Zlw3S8q02vZ68ANKfkX+yN0lzkI+I0U7KtuhlcrBU8u3PV9f7/+5TeV4LnUiEfyYL0qCCAO0naQ/1u9fOgbuA1FhRyqLMClWZZRz4z/HIqxkWXO61oeQPDXdWAZz24Wzgn/XdpixI9ijwE0iD/1yuQd1ZiSIHEmii7G4c37PPeeKTt8q6hyXN74vlJOFGpg70clXXt17+hn5dyq7stl+m2MnArWLflo84aLQxZSsQgjIdZY/ifrZfj/p8Qf7TyPHMD9Ma8n0oS/Qp8G6kdWPNwS3D4Fowana2H9fJXXNALzF209kyti3V/UQB0+BvSuDQsZ5jb6L1AJEK2EbZG92LgH1qZ48mxRTKe8HyOrekNwHEV/vGVDL5UWmXnKg6n4v3KF0GbPS0TuW3MeEqOhRMS7vmQsdE0HgyUrCh6fKzGD0QnQr96ZVtNPHubd/OVJQbcp+kO+CHqKPdnuTKfeGjln1V+XRASkBaBScG7ZYSiLeuaHffHb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199021)(316002)(41300700001)(66556008)(66476007)(4326008)(6916009)(66946007)(5660300002)(8936002)(8676002)(6512007)(2616005)(83380400001)(86362001)(38100700002)(186003)(26005)(6486002)(6506007)(36756003)(478600001)(6666004)(7416002)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D6WC/QdJ0bcxWURUwzRQia0j/RL2yN8OcJ3NFS2e0VLPWBgPdUxo27ML68Hx?=
 =?us-ascii?Q?nBfPliBq/syny8ol1iQTge+kg7htPycA41ZNB6NDWBCKDwUgqAn3lLQ3De1o?=
 =?us-ascii?Q?idehCaMuMHo7jt7/DrPT8bzfi3AMvcwOJzPfCx3sBNQH6uY4BBGs9LImDWfA?=
 =?us-ascii?Q?STvkVki1B2HvUeH8jQ0EVr4ChYeZOYgZmO3kKzslJoVtLQkvlhUk89ubGRoW?=
 =?us-ascii?Q?wKD4dI+lVXQ/RiF5A/cMYKN572S7MGt6wu0Rh/sRPeQvog2OYDp9d2MvKi7S?=
 =?us-ascii?Q?/uW7MYA67zIAAENmPjsLq6Ij9RR0GXFINaudTJ92TZjyxzQDPBw/UzKHUnC2?=
 =?us-ascii?Q?PBIdcvaHdP6m9DeuJm5Q1PdaI6B4EB7Bsa4x1+aYc/pnJK0XLu0XDNJILiVO?=
 =?us-ascii?Q?xAATwplOH2Sb3Si9F6Afpk6ESeV7MBaxVArPr4jzEyoMnqFbl6jB2SfrZ2/0?=
 =?us-ascii?Q?hBpzs5z6Ss/uwYw175C8H7PXoyuJJM+z5CNbGoP0cWL709PzPRhq9lGkvBJC?=
 =?us-ascii?Q?j6J2rLSehv17eznxrUegrBteQdNneVhibUEbEEZqTnN5Hfapps0nOkFahpGx?=
 =?us-ascii?Q?6GmwkJnM9GM7uVm7Vfjs2csRVKDsZvfEr5w+Uwm48qI0B1n/GFlkVnD/ntJy?=
 =?us-ascii?Q?JSChapvj3QwUYuu5LAziBthFYgWVwDA/9FKhnrVDuw8vaSbx1qj8zqiip7O6?=
 =?us-ascii?Q?iTM8z1OUH3KwxZ/8oS2HBtjH+JxmtTfHBtRlTzQeT8eyCsMgZkorlDdBPNsx?=
 =?us-ascii?Q?jibAT9Nl5Ro8zZxxueVE+oQVvIfNwIRauV9md8ZCHJkR4HDp9yu1BzDEypj/?=
 =?us-ascii?Q?DD8e6+Zb+trpplblf+5cmCHjY9GHpjW8hJlGyJci/GImIQOgfFvqxqf8GXDA?=
 =?us-ascii?Q?0dUXa6s2RasTVJimbz3cNFjhDSLNVl7IXMAiKLgcIV6G7lltbTIoDmW0HgAE?=
 =?us-ascii?Q?FzrDYxcHdr0J3uvVLLYBxZzlzFX29PJQs4hPNU2AGwahJpCBrwqvu+Lu9cqM?=
 =?us-ascii?Q?iT2IBw4Nnb/EDbiDRFFJXCuzestkrW1Sbz6oZeQRxDygFLRb8e33n0Q0ltV7?=
 =?us-ascii?Q?Uyh0Vjdl21sY0bfoH3VtOc6nqnm1ajwXdMfXLLMgeZRZHphAmXnB86uYuIBk?=
 =?us-ascii?Q?6me8MW+IEl+rWQy2CAbn8wS2KFc5HkC6N9LV/xAHLGSGITvhlJn9HtJDFMyf?=
 =?us-ascii?Q?VrAYDtHG/UPEkaDP5oW4Tgp3Ypy60z20NP6JCIy3M7J3bz1I4QrIPefx4Seb?=
 =?us-ascii?Q?VsLR+2Um9/7VCy9PUUeqMLl5TaK+VhoFX++OO+wSPX8hNsklozb3vbGYTVzm?=
 =?us-ascii?Q?FDBEYyhfrei58+RNGRlocXS/B9QFCtoZtuVCgXSzthgiCRroHp2taSM0MgvL?=
 =?us-ascii?Q?MFgauTPbqFDL2JkLazvs4UQgRVdVYpiRg3/IaX1FrqiyyM5AsYDWhZoMhaDu?=
 =?us-ascii?Q?A/p0WDI6zLSAzSppeP/4MD9jmwbmAuiAqFH+F4XA8qy7NuQvEDf8py1eyVi6?=
 =?us-ascii?Q?/CqRC4AOSFC+QyJ3dBUci5WYfYdQfWgJfIROovcZ9/wjWDTG460sjjEHyJlj?=
 =?us-ascii?Q?CFMFZA4S0V8mDhxEzxc1R6KZ8aaQjohl2N4Lon05?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60ae1a5-074c-40e8-e9fc-08db87aff8e9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 16:56:46.9470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pLDEEc1ypr5M8YpayYaQSLPuL5VaEnX3grmSwgmCKU3+KqUgHz5mUKkuzLIOxsfS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 06:55:47AM -0700, Yi Liu wrote:
> This adds ioctl for userspace to bind device cdev fd to iommufd.
> 
>     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> 			      control provided by the iommufd. open_device
> 			      op is called after bind_iommufd op.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 107 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        |  13 +++++
>  drivers/vfio/vfio_main.c   |   5 ++
>  include/linux/vfio.h       |   5 +-
>  include/uapi/linux/vfio.h  |  27 ++++++++++
>  5 files changed, 155 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
