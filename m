Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3537D6A4A5C
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjB0Szz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0Szy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:55:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E6C222DF;
        Mon, 27 Feb 2023 10:55:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcZvlaurPUEoQWHni370+YhZCj7cnstwNzp+ZGxEF7CW8OJ2YIoR5rKTX0/uESfJYq2gM3qZggQ6TUzbfoO9ztysuvpI8uRPlM7p70r7Fq88LyAFk187dPqtloep+AHLmFNhgOUmk3KHU38TXLyvpvCnyY3yGLYP58YjzwEl1j7PJ/nJAGZj/duoe7yg5H9bp1k0+pYjmvY9FSNzy0JIB564e5gs40326T02K+cYvn5I5+LZcXBXSEvH4NPK9BS+qf4tWxhJjgSkaApOt1JpYw7H5wWXDflTMde0W6T9QskQUhyquGt0mMrx8KCf/3j7vgac41kCpuy4j39tWK7pRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EX0p5CZp4zXx+V1LhpTGrsDjBDxtE2+6rc8EDkR8H2U=;
 b=hN4TprEr33VTc5ehRnAI8HOjc3lKIp57Pous89Bx+e03f3ldypKVYhVuyUdGGwK11owL7nLmGnuXSRixUFboMdPNNF1HpRgWbh7sFwA5rEM0y+S6QqksKkRd4xONseZOZTD093dcJNK71QBdB264zDQuF/Sssb8noQPjObDfE9144ldPBWlQvCgVPwxKxs7LVBvvWvuT5xqlxPDIEFE6YZ4Lr5+S7c3w9YBbzHR7Qk/yKqjEsrXA0ZyJBJ03OtHmfgBo2MKmtWK9GyuqFqrd5t5RqdTCFggA313fD3KktYjaefhQNT4pIaDiMGtSTMn56h9TT+OUarLAgmy/alsu+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EX0p5CZp4zXx+V1LhpTGrsDjBDxtE2+6rc8EDkR8H2U=;
 b=NXeQ+H/piAyYFZSLGdCPZc20NicJr2tmfZ6ojyvXxWjtKd9SZGjAEdILGAhuZm+3sXcjneIvRksy2YoQ+z3u0dbBzC0545F3TkIp8cWqLf8qoy8laId3KBh0uHl4GemorJFfRuqNhFq8hz0GrhLnUG24bJanzoGXni4xbqeHhyCW1pzEXB9HUg088rTivzIFYLdmjMF0FYye9GwYN5hjfOFHgLd8rN5czcMHUq1NMw9x4KHI2R4qbqeqJQPqnBEMxj96ro/tCy8hRsmfTy7iL9an9MGErqj/Sc6dhu4WQUZcTQ4h6yL5VJjuWlqVGrN1B0ejsmDgFeTEiGj3i+ysoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6565.namprd12.prod.outlook.com (2603:10b6:8:8c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Mon, 27 Feb
 2023 18:55:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:55:51 +0000
Date:   Mon, 27 Feb 2023 14:55:49 -0400
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 15/19] vfio: Add cdev for vfio_device
Message-ID: <Y/z8tVo1ujcmHBSJ@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-16-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-16-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6565:EE_
X-MS-Office365-Filtering-Correlation-Id: a1bf8f44-9043-4a7d-f568-08db18f43ecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F68lyw+cREkj5KTjWTclEshBN1i3SJSqYnSL4o60Jv2qYjuqtR19A9VrHGvIVyL9s16Oe6pgbrVp1KfnnIZvv6p4g/VPcrwVrEY3HwbCUevYI4mju7VxgXqnoODAiP1JAr69Tqbam8+tonbhd4o8OybFjs2j15juI8LdOtxzOcsM+HMB6TxF24ynnT1R+F6/lgyUaAA8EpUlSz30AmM/AIg0NK+fleWEBs+ZsL+3j/1l1CvWP/X7/S+JJd7SZgdlrYPTfJokhce0WkX+HRMZm8+R6supH/bX2LMjcAONoVRt1xEZg4w6+Nvo6k5dnOdpO0Q1ZeZgEzfpeD7pMlOMu8IibsVvAqCjAM11tEvvBfH5HlyaxoloWsrLspQPNbY8qjPug3tDnZatcIeFa5qMyY9zOw4hZhmsuHLvYIVq0GjazA6jhoVccWRpEaezxyiETAJF8fShedwU8REintx7pJxCpFfxuKfk3GAsVQm1Ticrl7d1d+64FtP7ntUfllkn+HO5WowQbpi1U2GTty3zMOw0jkvKL0MBSXvEZFxmysTJLw3+3suECiQRoGSkle6AK07A8lX9SOGpYQVawo7MTfSg1TxiHgcs/jaVw0IZ2QJJB+yueHEdZeFujj+rgzS6Pc6LiN+XH3xpaSaqtuE+zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199018)(66946007)(66476007)(66556008)(6916009)(6506007)(4326008)(26005)(36756003)(6512007)(478600001)(186003)(6486002)(2616005)(86362001)(316002)(8936002)(4744005)(8676002)(38100700002)(5660300002)(7416002)(41300700001)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l1KCET9Tg5stkZLVTg53kIYav1Vo1e+6SIMdjr3RLYzufeL2ztqJ5dpLfsBv?=
 =?us-ascii?Q?/hc7yrRyHooZ+pdDARRIG8Q7Bv8V0okUzf0JdLFEUpX4aA73fwUByJfdg2hr?=
 =?us-ascii?Q?emmG61ywZGuZruyQs2WE4VevUr2JlKHWJJQJsJEmJVeNXwMkstazbdZayCVI?=
 =?us-ascii?Q?hpqsbW3HJEHVAv+zjkzixZk/mz7/kocOuuSZ3FfPBd18EGLLgIiVbpF5+OEy?=
 =?us-ascii?Q?eFLH4SHYDkWQDiHUdfzbfm2FUheyY5ntbA4qa418s6gwUGE5VBT92XXGPyfI?=
 =?us-ascii?Q?QIMYKVFrnu6wMtccPri/yOro0kPFBKyRvODQT3ax7jJGIESLtmfTvk5y4Zq/?=
 =?us-ascii?Q?CeK+Y7xr8T9I4ub5LR9c1kl3NIMCzNpnczeHCAYOGv0B1fXTIb2YPlyehgvT?=
 =?us-ascii?Q?GensF14dP1BQsk89QJds3PngYbM+KE7JnkpYPMjf0QzqChbnnLzvPIpJqfgc?=
 =?us-ascii?Q?HLOD4UmXs+9HpQSsXe50QPbEQXQXtjtd/eZh69vbraMjvdm7x5OHQZyvo6Nr?=
 =?us-ascii?Q?/iRufhW/6zJo9Z1XAq35brWaMlhAuH8En1ijhpOScmPgJe9RO4sBHB64opQd?=
 =?us-ascii?Q?fkhwb4E4ZUsFfASFtUquyYNwSj4XPdYWQ+LrVEPPeGjuayByAFIgry7JGzaC?=
 =?us-ascii?Q?7KNX3yxgDKwoN/0B6SGe1rpUPi6EtsVEBNhPvRNitWb2+xNTfs5fRtpdBSqx?=
 =?us-ascii?Q?aYMtQ+I5ysb2xMSW/99f+x8bjS3IFxjnn6Sfz3qf8vn+KwW5UIuGe1emgyVy?=
 =?us-ascii?Q?J7Amp+9qiH4bT73jIW0nJS9REjq2fzqsvS3jBGWXW8xqkgIo31Mbbhq12VKX?=
 =?us-ascii?Q?OWzEYnrYDxAgFogXDiiAl3GGfbdCjCLjbFf7gyqoKVOKKlhJ6iRRear3TNl/?=
 =?us-ascii?Q?cKDJUda25JgjuRPXxcLM8Lx7eNgbDveYYeaqIVDujN5YZyVSDBI330IUNAmB?=
 =?us-ascii?Q?+yGvVyU4l9yJf3cpaOmnmwIV730px6Bnt5ZUG1yV22ZzxF9ulKkfvks/nNVS?=
 =?us-ascii?Q?kUdTlPnFxTvDa8s7XkipLi4kSveU8k/XnKpEh6lJgdFaRkn3KmjZcPDb71vN?=
 =?us-ascii?Q?HCle7tmhcZU/0yW0Y2JvJFvKjzPl3bK0XzM0aPHUdg9QbzHneSyJDqGsR8z7?=
 =?us-ascii?Q?I1Jb5MFRGfThX6WVFUSGSeQr2oyEzIsvRry1iUxstWfLf5G1Mh4oWJeQrtrt?=
 =?us-ascii?Q?GTWyfMttMHmhJIJNxOpeGIOH+s0hbJqqsVD4DVBb+3EcG7zLoLnmOy/O16uB?=
 =?us-ascii?Q?lNjHQq1/ZIa97B1lu+s1pK1W3m9x4Mei64HUQJKkQYC0zXh+APwxYPW9d6zv?=
 =?us-ascii?Q?o/EqqMqUbAdrr6aoOv0aMzEH9U5HEdOvrCghMgMwzYKfvYlHA9UOf18ByIiK?=
 =?us-ascii?Q?fi32Jwo+gFOtB8A9f6Rh+g7Yboguj10qrehdqcoKrBIb0Xw6hhCWlzy/xd+8?=
 =?us-ascii?Q?O+BJiUtlexlejel7veMsYAUQ2aFpfJJlc9WQXVQMzpUGp4s+fSZkdwWBdjwm?=
 =?us-ascii?Q?sESgan2Esf4racVWlJBAsKfapBc0ZjiH9xuYH7PQ3dQQOozvuUGVdjcS5P4g?=
 =?us-ascii?Q?ECHws8Tzaj3vt+d/ZP9D9MHmjjmUs6m/TsVUK2FJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bf8f44-9043-4a7d-f568-08db18f43ecb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:55:50.9260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDomXVwL5V16YD0VonShz9CbeR+VNTLEMGCzlV8ussovp4r7FO7DmFdNwMLi6wjm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6565
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:31AM -0800, Yi Liu wrote:
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index a8f544629467..169762316513 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -12,6 +12,18 @@ menuconfig VFIO
>  	  If you don't know what to do here, say N.
>  
>  if VFIO
> +config VFIO_DEVICE_CDEV
> +	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> +	depends on IOMMUFD && (X86 || S390 || ARM || ARM64)

We don't need to propogate this arch detection stuff, at worst it
should be in iommufd kconfig if it is really needed.

Also that other thread shows that vfio doesn't work on ARM because we
can never take ownership of a device due to arm iommu

Jason
