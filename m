Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663D840CAE4
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 18:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhIOQp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 12:45:56 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:51297
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229479AbhIOQpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 12:45:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1OxTBtKfEC4X19j6vqc/l4mYo4mZEbEDN+ushWj+tziWkKlFmu149hdxKRLH1lSqjWnySrtw52wJT5lK301eUwBR18q6c8ipHySB98BQx1W/gVmt2Y4cA/FGLZAonlCzS7eN+NyfdW/SC/rCeuvA6MBDru4AkMUGpfef2tNYjlkR33N0geLmSUSvNzlR+Oow6HXhjfssClZybAZJAt5KF4nVBp6roYNqlw/7iDOL8u7mAEns/dZ0mD3F97b4maPY5Mh5jdC8t/DbBgXbaTCX3HcFVc2cJUrrflG4ykzVvuXEoW/WewKBTYqjm3075tNAlxhQF2w8icGaDAb1Y7/7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w903PChsZAxQHve8ChMAHUEVPYUsyIVpoN9xSdfulhs=;
 b=SNINOTXReyQ3WAYnjiYcsUG6stgm5G5l7oCVI3NA5JZsQmO91Chw2Ao3KOACFkZ75yHFbCeJaZVw2UgpAT0bZCnIbpo+fAQQVUsreHZKuli0sOcqq9Sjd2gxjTor4g54ufIXESfZv21sscat+WLzaefs8zekn49g4/mLsuC+zCW+ojFrb3pUdF7avVLfp8ByMpS/jYlBKP/3KRgYABAY3nNzlW4qK79oZ6a5q+RBg4N1stmPdbk8ulYaBaHnrxVKmBECYAs1SXGT2re7Eu+OqDyq4ORORgC3JG5yefXt+AQzNhMre4Cl8chvq+tIXFSsWNdsLrwOGauzbmP48q3dHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w903PChsZAxQHve8ChMAHUEVPYUsyIVpoN9xSdfulhs=;
 b=aJhAijGkAMbkbVCAfoJWkyTTzt6FmtgXOKm8EvmZOc/PN/RUQ8JLaVEh9gGRY7imgYjPzffg+D7mXdp/i39icLEcqzJ1epfBBJ3LkEDucBNcLPW9GLVKk8EzFmCUKPJOf9HeOoIf6AlR0l8ptMgsHZH8LuXWEMRyn2Aj9Ddsa1l5MEkucgkQEYtzM5X+JAb7sTfce5q4+/k7Bv1H+2vfvtFXJfUb69gRaZ8gmARDv5HssDgWWMI1Uny4ixpr4kwIIH0crZVE0tIuVJ1fxynVJVKwcKYFkWVFym4IxUfZCmVx3GmXZuuBpbAzr44ACA+GjjoKPYuxdK2qGeTSNFOtpw==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5158.namprd12.prod.outlook.com (2603:10b6:208:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 16:44:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 16:44:35 +0000
Date:   Wed, 15 Sep 2021 13:44:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 06/14] vfio: remove the iommudata hack for noiommu groups
Message-ID: <20210915164433.GN4065468@nvidia.com>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-7-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913071606.2966-7-hch@lst.de>
X-ClientProxiedBy: YT1PR01CA0095.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0095.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 16:44:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mQY1R-0013Yq-CF; Wed, 15 Sep 2021 13:44:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0996897-7842-44a8-c3ce-08d978681965
X-MS-TrafficTypeDiagnostic: BL1PR12MB5158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51582690C6BD61552F584020C2DB9@BL1PR12MB5158.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29g2VMr27z0BBrM1HCeS705dciOVjXnV32lMf3FBNfkc/xqgvbk7S3vXj+cdOtq5Gi4CWH4XvcFzJMTe0n36GA+3ivt60c7/VKripxm9rVJPHW02Qvyiq7Ou9RTbYiUTPw3bmUSxzmqEq4GDpmwdZmSOd8IZw+GmPKgQJWJ0aXivfvezYJF3OmyUbkGUYiXfZaDoR5gqpqF2lhIXtAopPcrJgnnmzTlbVj+qIZ9YaUxnjKmIAbRc4Dz4rspH8KlfbHxzKRSqVM26K5vFEvUyL7cmjAC+HH5IOz1TAivA6ZnvN54vWNzq4Z+ODvNS3GG1nUoMsN7CNbUKjYfkxOFMHxeZ46iDN77OHDCLc97CTWWkKbiPRCY/KL7u4F2/DXmsC4K770JEBZYrj00yu1ZbHaoiotBm99tCmvYVAc27Zfnk0rz+q5vHurBoY0zi10yX4txRvEHhWbkkNjiXFdKTvyDgpHgL0sMiw20yLuS5naH1iQ5LWf63gde9oqOyKyaBxK37x+stwutNgJ5zkskBz1Ir85REyY9OLI79RECXC24DEuSR6UdugH/tvlOylojPD+2ucHMtc8+be6ZqBgqQ+S9CoPWraP479ZJt/HTlZ9R/DydFWhiAVYPEFubVkPFO9uXQkyEoWjQo/3D4PGW8FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(36756003)(186003)(9786002)(5660300002)(26005)(9746002)(6916009)(86362001)(478600001)(4326008)(4744005)(66476007)(316002)(66946007)(66556008)(8936002)(426003)(2906002)(33656002)(2616005)(8676002)(54906003)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0WLgpEcU4hYexq0SIJNLHGbymhTRYwMrDaCDzFOnMqzcE7G2Ost1jRqlUQTy?=
 =?us-ascii?Q?hX+o0VXGpHH21y1/SSxA0O2fNduOOrK5yOJrzXtYCAB28gMlXFrZmwe0OkRu?=
 =?us-ascii?Q?8RmTQolYNQjuvMu5nhtckQoUKUY0Z0VCZShLfGJ9rIeIkzfvPgmdswCxZXEO?=
 =?us-ascii?Q?2rrRQFNGBzMQtMxqRMMoAak3qK2CHWbfSUBNmA6ZJzFcQpBga5gHsi2OiFVw?=
 =?us-ascii?Q?PmZLo1qoT+N6bPXbO8jieSZqxzaiad7U2w3fyFrXl3GPZ2dWDUsao3BwflXF?=
 =?us-ascii?Q?Owzy44QD1nOoSJ72Bc2fnTeme/FXCTLdUWGCHn8UQ/BDTMwGknT7HG7b/4mK?=
 =?us-ascii?Q?BewPXtDnkro+d+P/1HWvTEeZIWN1vgOeHxW9IuhwOxu3A6rwvVdw22aazyHp?=
 =?us-ascii?Q?7j9/oqblRdwBoEfLdRGGLZ+w1/KrNrJLcw0LxprAfEbY6mAAnRmCGITRNlR5?=
 =?us-ascii?Q?Pp11mc78InAFJXTu50UNLopzsP4EyaTWhl338jbHWchNH6/nxEGOl2/q5VtX?=
 =?us-ascii?Q?ULceAYXIIGlOd0/QCxf/tFbQi1qnl/HtfoYf4eVxeU+BjCp+xwsP9Oca2uea?=
 =?us-ascii?Q?3e2mntaTIFrQishIfYCZdfXgHjLa6tCxxLvOzfM0hx6CpXhKrUcSzG9DljSA?=
 =?us-ascii?Q?gF9qP/ZeFk4exU9ubcggO6/CL2NE78S9XuVXIW4G8VHca4szoj87qC4SsUaf?=
 =?us-ascii?Q?4y5XN21agK7MHgmbl0MUsfN7TPT4AsdFPGZjoQ1lQguq9ygst8fI+4j9/GfD?=
 =?us-ascii?Q?wHlgBn0nHQUpM6lvbW9XHJlrXTbvuFbDFd/nF4OFieVleHxcTRxO5I9bUuCL?=
 =?us-ascii?Q?dPbMbkrH14gpQViXwtftyN3tKBh2pMnk+jUHoHYK+VVMmIgOVXhEpO2REg7N?=
 =?us-ascii?Q?tvpvKo4EXjhVm4Omx9LmVOeRFxah5YrqrfxIvEF3pXqAmpeIbMCdeBomvpBt?=
 =?us-ascii?Q?y33Ede0o3GnqHTCofZ9a0gM8zTdgbnXFKhdzYvo5Zb3RZ6HyH2G4bsos4BaV?=
 =?us-ascii?Q?1xEhdPDDxlTuC2qWjyI+UQhCqyRfg8wdU+f7hQ9d4lemNrD9ujOsaPf1yfp3?=
 =?us-ascii?Q?aY1cMOK+7tTk1mHFU+6nZXzqfK1Q/7NUBlVbn2FWmHS73hKzDOk80X8aypoy?=
 =?us-ascii?Q?yx3hxrlo/tZJQbxy21LxqmPAO+sCwVW7BIJYWItZxCaaWfBZIGJtkMeahJTi?=
 =?us-ascii?Q?/+Z0aguXTV5EnNrzjdHFZTRBnMsHAfdmpZcsbZJh2w+mUNuUssj05RMBPsM5?=
 =?us-ascii?Q?24dGvgiytht9sDZIQZN+ftmR4j5jzq0FdFfqomggSqHmG2zDzdQyHdrMswp0?=
 =?us-ascii?Q?tKIbQRI2QS7cuVtbgxWvr9Sz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0996897-7842-44a8-c3ce-08d978681965
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 16:44:34.9837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7EZYaGpgaypqpGWAaABs1ZlxcqvHZ0R/W6I9YdRJUjfi20YrxNjsA7re1OgSeIXh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5158
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 09:15:58AM +0200, Christoph Hellwig wrote:
> Just pass a noiommu argument to vfio_create_group and set up the
> ->noiommu flag directly, and remove the now superflous
> vfio_iommu_group_put helper.

Nothing wrong with the patch, but vfio_iommu_group_put() is now
removed in patch 1

Jason
